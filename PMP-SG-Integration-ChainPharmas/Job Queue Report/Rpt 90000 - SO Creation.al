report 90000 "Chain Pharma SO Creation"
{

    Caption = 'Chain Pharma SO Creation';
    ProcessingOnly = true;

    dataset
    {
        dataitem(StagingPOHeader; "Chain PO Header")
        {
            trigger OnPreDataItem()
            begin
                StagingPOHeader.SetRange("SO Created", false);
                //RL 01 Dec 2022 - to filter pushing of chain orders after processed by microservice
                /*
                StagingPOHeader.FilterGroup(-1);
                StagingPOHeader.SetRange("Ready to Process SO", true);
                StagingPOHeader.SetRange("Push to Open SO", true);
                StagingPOHeader.FilterGroup(0);
                */
            end;

            trigger OnAfterGetRecord()
            var
                StagingPOLine: Record "Chain PO Line";
                SalesHeader: Record "Sales Header";
                SalesLine: Record "Sales Line";
                CanCreateSO: Boolean;
                LineNo: Integer;
                EnhanceCU: Codeunit "PMP-Enhancements";
                ItemRec: Record Item;
                TradeCU: Codeunit "Trade Agreement CU";
                TotalQuantity: Decimal;
                ChainLocMapping: Record "Cust. Chain Location Mapping";
                // ItemCrossRefRec: Record "Item Cross Reference"; // obselete
                ItemReferenceRec: Record "Item Reference";
                RollOutChanges0: Boolean; // YF 25 Feb 2022
                FindNext: Boolean; // YF 21 Mar 2022
            begin
                if ("Ready to Process SO" = true) or ("Push to Open SO" = true) then begin
                    // Message('correct');
                    // CurrReport.Break();

                    CanCreateSO := false;
                    FindNext := true; // YF 21 Mar 2022

                    // ### ACTUAL SCHEDULED TRIGGER CONDITION ### //
                    // RollOutChanges0 := Today = DMY2Date(1, 4, 2022);
                    // ### ACTUAL SCHEDULED TRIGGER CONDITION ### //

                    // ### FOR INTERNAL DEBUG AND TEST ### // 
                    // RollOutChanges0 := UserId = 'BCADMIN';
                    // RollOutChanges0 := false; // override
                    RollOutChanges0 := true;
                    // ### FOR INTERNAL DEBUG AND TEST ### // 

                    // Look for Staging PO Lines
                    StagingPOLine.Reset();
                    StagingPOLine.SetRange("PO Entry No.", StagingPOHeader."Entry No.");
                    // StagingPOLine.SetRange("PO Number", StagingPOHeader."PO Number");
                    StagingPOLine.SetRange("SO Created", false);
                    if StagingPOLine.FindFirst() then
                        CanCreateSO := true;

                    if CanCreateSO then begin

                        // Create Header
                        SalesHeader.Init();
                        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
                        if StrLen(StagingPOHeader."PO Number") > 0 then begin
                            SalesHeader.Validate("External Document No.", StagingPOHeader."PO Number");
                            SalesHeader.Validate("Order Date", StagingPOHeader."PO Date");
                        end

                        else begin
                            SalesHeader.Validate("External Document No.", StagingPOHeader."Invoice Number");
                            SalesHeader.Validate("Order Date", StagingPOHeader."Invoice Date");
                        end;

                        SalesHeader.Validate("Requested Delivery Date", StagingPOHeader."Delivery Start Date");

                        ChainLocMapping.Reset();
                        ChainLocMapping.SetRange("Chain Code", StagingPOHeader.Chain);
                        ChainLocMapping.SetRange("Chain Location Code", StagingPOHeader."Store Code");
                        if ChainLocMapping.FindFirst() then
                            SalesHeader.Validate("Sell-to Customer No.", ChainLocMapping."Customer No.");

                        SalesHeader."PO Integration Source" := StagingPOHeader.Chain;
                        SalesHeader."PO Integration Source Ref No." := StagingPOHeader."PO Number"; // alternatively use entry no.

                        //RL 01 Dec 2022 - to filter pushing of chain orders after processed by microservice
                        if StagingPOHeader."Ready to Process SO" = true then
                            SalesHeader.I9G_Ready_to_Process_SO := true;

                        if StagingPOHeader."Push to Open SO" = true then
                            SalesHeader.I9G_Push_to_Open_SO := true;
                        //RL 01 Dec 2022

                        if SalesHeader.Insert(true) then // must be true to trigger auto number
                            begin

                            Commit();

                            // Update Staging PO Header Status
                            StagingPOHeader."Sales Order No." := SalesHeader."No.";
                            StagingPOHeader."SO Created" := true;
                            StagingPOHeader."SO Error" := false;
                            StagingPOHeader.Modify();

                            LineNo := 10000;

                            if StagingPOLine.FindSet() then
                                repeat
                                    // Create Lines
                                    SalesLine.Init();
                                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                    SalesLine.Validate("Document No.", SalesHeader."No.");
                                    SalesLine.Validate("Line No.", LineNo);
                                    SalesLine.Validate(Type, SalesLine.Type::Item);
                                    //Buyer Item Code

                                    /*
                                    // Obselete
                                    ItemCrossRefRec.Reset;
                                    ItemCrossRefRec.SetRange("Cross-Reference Type", ItemCrossRefRec."Cross-Reference Type"::Customer);
                                    ItemCrossRefRec.SetRange("Cross-Reference No.", StagingPOLine."Supplier Item Code ");
                                    if ItemCrossRefRec.FindFirst() then
                                        SalesLine.Validate("No.", ItemCrossRefRec."Item No.");
                                    */

                                    if ItemRec.Get(StagingPOLine."Buyer Item Code") then begin
                                        SalesLine.Validate("No.", StagingPOLine."Buyer Item Code");
                                    end
                                    else begin
                                        ItemReferenceRec.Reset;
                                        ItemReferenceRec.SetRange("Reference Type", ItemReferenceRec."Reference Type"::Customer);
                                        ItemReferenceRec.SetRange("Reference Type No.", ChainLocMapping."Item Ref Customer No.");
                                        ItemReferenceRec.SetRange("Reference No.", StagingPOLine."Buyer Item Code");
                                        if ItemReferenceRec.FindFirst() then begin
                                            SalesLine.Validate("No.", ItemReferenceRec."Item No.");
                                            SalesLine.Validate("Unit of Measure Code", ItemReferenceRec."Unit of Measure");
                                            //DX        27 Sept 2021        Only when got item reference, then insert the price, else will insert blank item without quantity
                                            SalesLine.Validate(Quantity, StagingPOLine."Order Quantity" + StagingPOLine."FOC Quantity");
                                            SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                            SalesLine.Validate("Order Qty", StagingPOLine."Order Quantity");
                                            SalesLine.Validate("FOC Qty", StagingPOLine."FOC Quantity");
                                            SalesLine.Validate("Line Discount Amount", StagingPOLine."Total Discount Amount");

                                            SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");
                                            //DX        27 Sept 2021
                                        end;
                                    end;
                                    if SalesLine.Insert(true) then begin
                                        // Post Insert Sales Line Customization Logic
                                        // Start PMP sales line customization logic
                                        if (SalesLine.Type = SalesLine.Type::Item) then begin
                                            ItemRec.Reset();
                                            ItemRec.SetRange("No.", SalesLine."No.");
                                            if itemrec.FindFirst() then begin
                                                SalesLine.Principal := ItemRec.Principal;
                                            end;
                                            //DX        13 Aug 2021
                                            //EnhanceCU.CustItemForensicIsTrue(SalesLine);
                                            //EnhanceCU.CustIsInAllowed(SalesLine);
                                            //DX        13 Aug 2021
                                        end;

                                        //DX        01 July 2021

                                        if (SalesLine.Type = SalesLine.Type::Item) and
                                                    (SalesLine."No." <> '') and
                                                    (SalesLine."Order Qty" <> 0) then begin

                                            // YF 25 Feb 2022
                                            if RollOutChanges0 then begin
                                                if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(SalesLine, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                                                    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomizedV2(SalesLine, FindNext); // YF 21 Mar 2022 // Added FindNext parameter
                                                end else begin
                                                    // take from item card price
                                                    if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then begin
                                                        if ItemRec.Get(SalesLine."No.") then begin
                                                            SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                                            SalesLine.Validate("FOC Qty", 0);
                                                            SalesLine.Validate("Selling Price", ItemRec."Unit Price");
                                                            SalesLine.Validate("Unit Price", ItemRec."Unit Price");
                                                            // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                                                        end;
                                                    end;
                                                end;
                                            end
                                            else begin
                                                if TradeCU.IsValidSalesAgreement_PMPCustomized(SalesLine) then begin
                                                    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(SalesLine);
                                                end else begin
                                                    // take from item card price
                                                    if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then begin
                                                        if ItemRec.Get(SalesLine."No.") then begin
                                                            SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                                            SalesLine.Validate("FOC Qty", 0);
                                                            SalesLine.Validate("Selling Price", ItemRec."Unit Price");
                                                            SalesLine.Validate("Unit Price", ItemRec."Unit Price");
                                                            // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            // YF 25 Feb 2022

                                            if (SalesLine."Order Qty" = 0) then begin
                                                SalesLine.Validate("Unit Price", 0);
                                                SalesLine.Validate("Selling Price", 0);
                                                SalesLine.Validate("FOC Qty", 0);
                                                // Rec.Modify(TRUE);
                                            end;
                                            //DX        27 Sept 2021 No need check, when send for approval, then will check.
                                            //EnhanceCU.ExpirationLessThan12Mths(SalesLine."No.");\                                        
                                            //TradeCU.RequireMaxQtyApproval(SalesLine);

                                        end else begin
                                            //DX        27 Jun 2021
                                            SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                            //DX        27 Jun 2021
                                        end;

                                        // YF 06 Aug 2021 // Temp Fix for Issue #80
                                        if (SalesLine."Selling Price" = 0) Or (SalesLine."Unit Price" = 0) And (SalesLine."Order Qty" > 0) then
                                            SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                        // YF 06 Aug 2021 // Temp Fix for Issue #80

                                        // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                                        SalesLine."Qty To Deliver" := SalesLine."Order Qty" - SalesLine."Qty Delivered";
                                        SalesLine."FOC (Qty) To Deliver" := SalesLine."FOC Qty" - SalesLine."FOC Qty Delivered";
                                        // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                                        SalesLine.Modify();

                                        // End PMP sales line customization logic 

                                        // Update Staging PO Line Status
                                        StagingPOLine."Sales Order No." := SalesHeader."No.";
                                        StagingPOLine."Sales Line No." := LineNo;
                                        StagingPOLine."SO Created" := true;
                                        StagingPOLine."SO Error" := false;
                                        StagingPOLine.Modify();
                                    end
                                    else begin
                                        // Update Staging PO Line Status
                                        StagingPOLine."Sales Order No." := SalesHeader."No.";
                                        StagingPOLine."Sales Line No." := LineNo;
                                        StagingPOLine."SO Created" := false;
                                        StagingPOLine."SO Error" := true;
                                        StagingPOLine.Modify();
                                    end;

                                    LineNo += 10000;

                                until StagingPOLine.Next() = 0;

                        end
                        else begin
                            // Update Staging PO Header Status
                            StagingPOHeader."Sales Order No." := '';
                            StagingPOHeader."SO Created" := false;
                            StagingPOHeader."SO Error" := true;
                            StagingPOHeader.Modify();
                        end;

                    end;
                end;
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }


}

