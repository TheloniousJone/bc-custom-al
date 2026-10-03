codeunit 90000 ChainPharmaCU
{
    Permissions = tabledata "Sales Invoice Header" = rim;
    procedure CreateOrder(EntryNo: Integer; ChainID: Code[10]; PurchaseOrderID: Code[50])
    var
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
        LSHRec: Record "Sales Header";
        StagingPOHeader: Record "Chain PO Header";
        StagingPOLine: Record "Chain PO Line";
        SONum: Code[20];
        ItemRefCustCode: Code[20];
    begin
        SONum := '';
        ItemRefCustCode := '';
        //DX        23 May 2023
        if PurchOrderHdrIDisValid(EntryNo, ChainID, PurchaseOrderID) then begin       // Initial data validation
            if isNTUCByPOStageEntryNo(EntryNo) = true then begin       //Check if it's NTUC Order, if it's NTUC, straight create
                SONum := CreateSOHeader(EntryNo, ChainID, PurchaseOrderID, SHRec, ItemRefCustCode);
            end else begin      //DX        23 May 2023
                LSHRec.reset;
                LSHRec.SetRange("External Document No.", PurchaseOrderID);
                if LSHRec.FindFirst() then begin
                    if GuiAllowed then
                        Message('Purchase Order ID already exists, the order will not be created again');
                end else begin
                    // Generate Sales Order Header
                    SONum := CreateSOHeader(EntryNo, ChainID, PurchaseOrderID, SHRec, ItemRefCustCode);
                end;
            end;
            //DX        23 May 2023

            // Generate Sales Lines
            if StrLen(SONum) > 0 then
                CreateSOLine(EntryNo, PurchaseOrderID, SONum, ItemRefCustCode);

        end else begin
            StagingPOHeader.Reset;
            StagingPOHeader.SetRange("Entry No.", EntryNo);
            StagingPOHeader.SetRange(Chain, ChainID);
            StagingPOHeader.SetRange("PO Number", PurchaseOrderID);
            if StagingPOHeader.FindFirst() then begin
                StagingPOHeader."Sales Order No." := '';
                StagingPOHeader."SO Created" := false;
                StagingPOHeader."SO Error" := true;
                StagingPOHeader."Process Remarks" := GetLastErrorText();
                StagingPOHeader."Last Error Message" := GetLastErrorText();
                StagingPOHeader.Modify(FALSE);
            end;
        end;
    end;

    local procedure CreateSOHeader(EntryNo: Integer; ChainID: Code[10]; PurchaseOrderID: Code[50]; var SalesHeader: Record "Sales Header"; var ItemRefCustCode: Code[20]): Code[20];
    var
        StagingPOHeader: Record "Chain PO Header";
        ChainLocMapping: Record "Cust. Chain Location Mapping";
        RetSONum: Code[20];
        CustRec: Record Customer;
    begin
        RetSONum := '';
        StagingPOHeader.Reset;
        StagingPOHeader.SetRange("Entry No.", EntryNo);
        StagingPOHeader.SetRange(Chain, ChainID);
        StagingPOHeader.SetRange("PO Number", PurchaseOrderID);

        //RL 01 Dec 2022 - to filter pushing of chain orders after processed by microservice
        // if CompanyName = 'ChainTest' then begin
        StagingPOHeader.FilterGroup(-1);
        StagingPOHeader.SetRange("Ready to Process SO", true);
        StagingPOHeader.SetRange("Push to Open SO", true);
        StagingPOHeader.FilterGroup(0);
        // end;
        //RL 01 Dec 2022 - End

        if StagingPOHeader.FindFirst() then begin

            SalesHeader.Reset;
            SalesHeader.Init();
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.Validate("External Document No.", StagingPOHeader."PO Number");
            SalesHeader.Validate("Order Date", StagingPOHeader."PO Date");
            SalesHeader.Validate("Requested Delivery Date", StagingPOHeader."Delivery Start Date");
            //DX        21 Sept 2021
            SalesHeader.Validate("Shipment Date", StagingPOHeader."Delivery Start Date");
            //DX        21 Sept 2021
            //RL 01 Dec 2022
            SalesHeader.Validate(I9G_Ready_to_Process_SO, StagingPOHeader."Ready to Process SO");
            SalesHeader.Validate(I9G_Push_to_Open_SO, StagingPOHeader."Push to Open SO");
            //RL 01 Dec 2022

            ChainLocMapping.Reset();
            ChainLocMapping.SetRange("Chain Code", StagingPOHeader.Chain);
            ChainLocMapping.SetRange("Chain Location Code", StagingPOHeader."Store Code");
            if ChainLocMapping.FindFirst() then begin
                SalesHeader.Validate("Sell-to Customer No.", ChainLocMapping."Customer No.");
                ItemRefCustCode := ChainLocMapping."Item Ref Customer No.";

            end;

            SalesHeader."PO Integration Source" := StagingPOHeader.Chain;
            SalesHeader."PO Integration Source Ref No." := StagingPOHeader."PO Number"; // alternatively use entry no.

            // SalesHeader."Order Taken By"
            // SalesHeader."SO Placed By"

            if SalesHeader.Insert(true) then begin

                // re update order date // YF 06 Oct 2021
                SalesHeader.Validate("Order Date", StagingPOHeader."PO Date");
                //update customer price group //RL 03 Nov 2021
                CustRec.Reset();
                // CustRec.SetRange("No.", SalesHeader."Sell-to Customer Name 2");
                CustRec.SetRange("No.", SalesHeader."Sell-to Customer No.");
                if CustRec.FindFirst() then begin
                    // SalesHeader.Validate("Customer Price Group", CustRec."Customer Price Group");
                    SalesHeader.Validate("Apply Chain Conversion", CustRec."Apply Chain Conversion");//RL 14 Nov 2021
                end;

                //update customer price group //RL 03 Nov 2021
                SalesHeader.Modify(true);
                // re update order date // YF 06 Oct 2021



                NoOfOrders += 1;
                // Update Staging PO Header Status
                StagingPOHeader."Sales Order No." := SalesHeader."No.";
                StagingPOHeader."SO Created" := true;
                StagingPOHeader."SO Error" := false;
                StagingPOHeader."Process Remarks" := '';
                StagingPOHeader.Modify();
                RetSONum := SalesHeader."No.";
            end
            else begin
                // Update Staging PO Header Status
                StagingPOHeader."Sales Order No." := '';
                StagingPOHeader."SO Created" := false;
                StagingPOHeader."SO Error" := true;
                StagingPOHeader."Process Remarks" := 'SO Insert failed table validation';
                StagingPOHeader."Last Error Message" := 'SO Insert failed table validation';
                StagingPOHeader.Modify();
                RetSONum := '';
            end;
        end;

        exit(RetSONum);
    end;

    local procedure CreateSOLine(EntryNo: Integer; PurchaseOrderID: Code[50]; SONum: Code[20]; ItemRefCustCode: Code[20])
    var
        StagingPOLine: Record "Chain PO Line";
        StagingPOHeader: Record "Chain PO Header";
        SalesLine: Record "Sales Line";
        UnitPrice: Decimal;
        SalesHeader: Record "Sales Header";
        ItemTrackCU: Codeunit "Item Track CU";
        ItemReferenceRec: Record "Item Reference";
        ItemNo: Code[20];
        ItemUOM: Code[10];
        TradeCU: Codeunit "Trade Agreement CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
        ItemRec: Record Item;
        IOFlag: Boolean;
        RollOutChanges0: Boolean; // YF 25 Feb 2022
        FindNext: Boolean; // YF 21 Mar 2022
        ApplyConversion: Boolean;
    begin
        IOFlag := false;
        FindNext := true; // YF 21 Mar 2022

        // YF 25 Feb 2022
        // ### ACTUAL SCHEDULED TRIGGER CONDITION ### //
        // RollOutChanges0 := Today = DMY2Date(1, 4, 2022);
        // ### ACTUAL SCHEDULED TRIGGER CONDITION ### //

        // ### FOR INTERNAL DEBUG AND TEST ### // 
        // RollOutChanges0 := UserId = 'BCADMIN';
        // RollOutChanges0 := false; // override
        RollOutChanges0 := true;
        // ### FOR INTERNAL DEBUG AND TEST ### // 
        // YF 25 Feb 2022

        // Make sure SONum is valid
        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", SONum);

        if SalesHeader.FindFirst() then begin

            StagingPOLine.Reset;
            StagingPOLine.SetRange("PO Entry No.", EntryNo);
            StagingPOLine.SetRange("PO Number", PurchaseOrderID);
            StagingPOLine.SetRange("SO Created", false);


            if StagingPOLine.FindSet() then
                repeat
                    ItemNo := '';
                    ItemUOM := '';
                    ApplyConversion := false;

                    ItemReferenceRec.Reset;
                    ItemReferenceRec.SetRange("Reference Type", ItemReferenceRec."Reference Type"::Customer);
                    ItemReferenceRec.SetRange("Reference Type No.", ItemRefCustCode);
                    ItemReferenceRec.SetRange("Reference No.", StagingPOLine."Buyer Item Code");
                    if ItemReferenceRec.FindFirst() then begin
                        ItemNo := ItemReferenceRec."Item No.";
                        ItemUOM := ItemReferenceRec."Unit of Measure";
                        ApplyConversion := ItemReferenceRec."Apply Chain Conversion";
                    end;

                    if PurchOrderLineIDisValid(StagingPOLine."Buyer Item Code", ItemNo, ItemUOM) then // validate PO data
                        begin
                        if NOT (SOLineExists(SalesHeader."No.", ItemNo, (StagingPOLine."Item Line No." * 10000))) then begin // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            // insert SO Line
                            SalesLine.Init();
                            SalesLine.Validate("Document Type", SalesHeader."Document Type");
                            SalesLine.Validate("Document No.", SalesHeader."No.");
                            SalesLine.Validate("Line No.", StagingPOLine."Item Line No." * 10000); // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            SalesLine.Validate(Type, SalesLine.Type::Item);

                            SalesLine.Validate("No.", ItemReferenceRec."Item No.");
                            SalesLine.Validate("Unit of Measure Code", ItemReferenceRec."Unit of Measure");

                            if ApplyConversion = true then begin
                                SalesLine.Validate("Apply Chain Conversion", ApplyConversion);
                                SalesLine.Validate(Quantity, (StagingPOLine."Order Quantity" + StagingPOLine."FOC Quantity") * StagingPOLine."Pack Size");
                                if StagingPOLine."Pack Size" > 0 then begin
                                    SalesLine.Validate("Selling Price", StagingPOLine."Unit Price" / StagingPOLine."Pack Size");
                                    SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price" / StagingPOLine."Pack Size")
                                end else begin
                                    SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                    SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");
                                end;

                                SalesLine.Validate("Order Qty", StagingPOLine."Order Quantity" * StagingPOLine."Pack Size");
                                SalesLine.Validate("Line Discount Amount", StagingPOLine."Total Discount Amount");
                                SalesLine.Validate("FOC Qty", StagingPOLine."FOC Quantity" * StagingPOLine."Pack Size");

                            end else begin
                                SalesLine.Validate(Quantity, StagingPOLine."Order Quantity" + StagingPOLine."FOC Quantity");
                                SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                SalesLine.Validate("Order Qty", StagingPOLine."Order Quantity");
                                SalesLine.Validate("FOC Qty", StagingPOLine."FOC Quantity");
                                SalesLine.Validate("Line Discount Amount", StagingPOLine."Total Discount Amount");
                                SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");
                            end;

                            IOFlag := SalesLine.Insert(true);
                        end
                        else begin
                            // modify SO Line
                            SalesLine.Reset;
                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            SalesLine.SetRange("Line No.", (StagingPOLine."Item Line No." * 10000)); // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            if SalesLine.FindFirst() then begin
                                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                SalesLine.Validate("Line No.", StagingPOLine."Item Line No." * 10000); // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                                SalesLine.Validate(Type, SalesLine.Type::Item);

                                SalesLine.Validate("No.", ItemReferenceRec."Item No.");
                                SalesLine.Validate("Unit of Measure Code", ItemReferenceRec."Unit of Measure");

                                if ApplyConversion = true then begin
                                    SalesLine.Validate("Apply Chain Conversion", ApplyConversion);
                                    SalesLine.Validate(Quantity, (StagingPOLine."Order Quantity" + StagingPOLine."FOC Quantity") * StagingPOLine."Pack Size");
                                    if StagingPOLine."Pack Size" > 0 then begin
                                        SalesLine.Validate("Selling Price", StagingPOLine."Unit Price" / StagingPOLine."Pack Size");
                                        SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price" / StagingPOLine."Pack Size")
                                    end else begin
                                        SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                        SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");
                                    end;

                                    SalesLine.Validate("Order Qty", StagingPOLine."Order Quantity" * StagingPOLine."Pack Size");
                                    SalesLine.Validate("Line Discount Amount", StagingPOLine."Total Discount Amount");
                                    SalesLine.Validate("FOC Qty", StagingPOLine."FOC Quantity" * StagingPOLine."Pack Size");

                                end else begin
                                    SalesLine.Validate(Quantity, StagingPOLine."Order Quantity" + StagingPOLine."FOC Quantity");
                                    SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                    SalesLine.Validate("Order Qty", StagingPOLine."Order Quantity");
                                    SalesLine.Validate("FOC Qty", StagingPOLine."FOC Quantity");
                                    SalesLine.Validate("Line Discount Amount", StagingPOLine."Total Discount Amount");
                                    SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");
                                end;

                                IOFlag := SalesLine.Modify(true);
                            end;

                        end;

                        // Staging PO Line Status Update
                        if IOFlag then begin
                            StagingPOLine."Sales Order No." := SalesHeader."No.";
                            StagingPOLine."Sales Line No." := StagingPOLine."Item Line No." * 10000; // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            StagingPOLine."SO Created" := true;
                            StagingPOLine."SO Error" := false;
                            StagingPOLine."Process Remarks" := '';
                            StagingPOLine.Modify();
                            NoOfLines += 1;
                        end
                        else begin
                            StagingPOLine."Sales Order No." := SalesHeader."No.";
                            StagingPOLine."Sales Line No." := StagingPOLine."Item Line No." * 10000; // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            StagingPOLine."SO Created" := false;
                            StagingPOLine."SO Error" := true;
                            StagingPOLine."Process Remarks" := 'Sales Line Insert/Modify failed';
                            StagingPOLine."Last Error Message" := 'Sales Line Insert/Modify failed';
                            StagingPOLine.Modify();

                            // Update Staging PO Header also
                            StagingPOHeader.Reset;
                            StagingPOHeader.SetRange("Entry No.", EntryNo);
                            StagingPOHeader.SetRange("PO Number", PurchaseOrderID);
                            if StagingPOHeader.FindFirst() then begin
                                StagingPOHeader."SO Error" := true;
                                StagingPOHeader."Process Remarks" := 'Sales Line Insert/Modify failed';
                                StagingPOHeader."Last Error Message" := 'Sales Line Insert/Modify failed';
                                StagingPOHeader.Modify();
                            end;

                            // NoOfLines += 1;
                        end;

                        // Post process pricing

                        // Start PMP sales line customization logic

                        if (SalesLine.Type = SalesLine.Type::Item) then begin
                            EnhanceCU.CustItemIsBlocked(SalesLine."Sell-to Customer No.", SalesLine."No.");
                            //DX        21 July 2021
                            EnhanceCU.LsItemCannotEnter(SalesLine);
                            //DX        21 July 2021
                            //DX        08 Aug 2021
                            ItemRec.Reset();
                            ItemRec.SetRange("No.", SalesLine."No.");
                            if itemrec.FindFirst() then begin
                                SalesLine.Principal := ItemRec.Principal;
                            end;
                            //DX        08 Aug 2021
                            //DX        13 Aug 2021
                            EnhanceCU.CustItemForensicIsTrue(SalesLine);
                            EnhanceCU.CustIsInAllowed(SalesLine);
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
                            //DX        27 Jun 2021
                            EnhanceCU.ExpirationLessThan12Mths(SalesLine."No.");
                            //DX        27 Jun 2021
                            TradeCU.RequireMaxQtyApproval(SalesLine);

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


                        // Auto Batch No. / Lot No.
                        //ClearTrackingLinesSO(SalesLine);
                        //AutoPopulateTrackingSO(SalesLine);

                    end
                    else begin
                        // insert sales line with error message comments due to invalid PO data
                        if NOT (SOCommentLineExists(SalesHeader."No.", ItemNo, (StagingPOLine."Item Line No." * 10000))) then begin  // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            SalesLine.Reset;
                            SalesLine.Init;
                            SalesLine.Validate("Document Type", SalesHeader."Document Type");
                            SalesLine.Validate("Document No.", SalesHeader."No.");
                            SalesLine.Validate("Line No.", StagingPOLine."Item Line No." * 10000); // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            SalesLine.Validate(Type, SalesLine.Type::" ");
                            SalesLine.Validate(Description, CopyStr(StrSubstNo('%1 : item error : ', StagingPOLine."Item Description", GetLastErrorText()), 1, 100));
                            SalesLine.Insert(TRUE);

                            StagingPOLine."Sales Order No." := SalesHeader."No.";
                            StagingPOLine."Sales Line No." := StagingPOLine."Item Line No." * 10000; // 16 Sep 2021 YF Issue #250 Line No Increment by 10000
                            StagingPOLine."SO Created" := true;
                            StagingPOLine."SO Error" := true;
                            StagingPOLine."Process Remarks" := GetLastErrorText();
                            StagingPOLine."Last Error Message" := GetLastErrorText();
                            StagingPOLine.Modify();

                            // Update Staging PO Header also
                            StagingPOHeader.Reset;
                            StagingPOHeader.SetRange("Entry No.", EntryNo);
                            StagingPOHeader.SetRange("PO Number", PurchaseOrderID);
                            if StagingPOHeader.FindFirst() then begin
                                StagingPOHeader."SO Error" := true;
                                StagingPOHeader."Process Remarks" := 'Line Err: ' + GetLastErrorText();
                                StagingPOHeader."Last Error Message" := 'Line Err: ' + GetLastErrorText();
                                StagingPOHeader.Modify();
                            end;

                            NoOfLines += 1;
                        end;
                    end;

                until StagingPOLine.Next() = 0;

        end;
    end;

    [TryFunction]
    local procedure PurchOrderHdrIDisValid(EntryNo: Integer; ChainID: Code[10]; PurchOrderID: Code[50])
    var
        ItemRec: Record Item;
        CustRec: Record Customer;
        ItemUOM: Record "Item Unit of Measure";
        StagingPOHeader: Record "Chain PO Header";
        ChainLocMapping: Record "Cust. Chain Location Mapping";
    begin
        StagingPOHeader.Reset;
        StagingPOHeader.SetRange("Entry No.", EntryNo);
        StagingPOHeader.SetRange(Chain, ChainID);
        StagingPOHeader.SetRange("PO Number", PurchOrderID);
        if StagingPOHeader.FindFirst() then begin

            ChainLocMapping.Reset();
            //ChainLocMapping.SetRange("Chain Code", ChainID);      DX      20 Jun 2023     to set filter to search by blank
            ChainLocMapping.SetFilter("Chain Code", '%1', ChainID);    // DX      20 Jun 2023     to set filter to search by blank            
            ChainLocMapping.SetRange("Chain Location Code", StagingPOHeader."Store Code");
            if ChainLocMapping.FindFirst() then begin
                if Not CustRec.Get(ChainLocMapping."Customer No.") then
                    Error('No such customer record.');
            end
            else
                Error('Cust. Chain Store Mapping not found');
        end;
    end;

    [TryFunction]
    local procedure PurchOrderLineIDisValid(BuyerItemCode: Code[20]; ItemNo: Code[20]; ItemUOMCode: Code[10])
    var
        ItemRec: Record Item;
        ItemUOM: Record "Item Unit of Measure";
    begin
        if StrLen(ItemNo) <= 0 then
            Error('No Item Reference Item Code');

        if StrLen(ItemUOMCode) <= 0 then
            Error('No Item Reference UOM Code');

        if StrLen(BuyerItemCode) > 0 then begin

            ItemRec.Reset;
            ItemRec.SetRange("No.", ItemNo);
            if not (ItemRec.FindFirst()) then
                Error('No such item code.');

            ItemUOM.reset;
            ItemUOM.SetRange("Item No.", ItemNo);
            ItemUOM.SetRange(Code, ItemUOMCode);
            if not (ItemUOM.FindFirst()) then
                Error('No such item UOM code.');

        end
        else
            Error('No Buyer Item Code');
    end;

    /*
    local procedure GetSONo(PurchOrderID: Code[100]): Code[20]
    var
        myInt: Integer;
        PomHdr: Record POM2HeaderTbl;
    begin
        PomHdr.reset;
        PomHdr.SetRange(PurchaseOrderID, PurchOrderID);
        if PomHdr.FindFirst() then begin
            exit(PomHdr."Doc No.")
        end else
            exit('');
    end;
    */

    procedure NoOfOrdersCreated(): Integer
    begin
        exit(NoOfOrders);
    end;

    procedure NoOfLinesCreated(): Integer
    begin
        exit(NoOfLines);
    end;

    local procedure SOLineExists(SONo: Code[20]; ItemCode: Code[20]; LineNo: Integer): Boolean
    var
        SLRec: Record "Sales Line";
    begin
        SLRec.Reset;
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetRange("Document No.", SONo);
        SLRec.SetRange("Line No.", LineNo);
        // SLRec.SetRange(Type, SLRec.Type::" ");
        // SLRec.SetFilter(Description, '<>%1', '');
        if SLRec.FindFirst() then begin
            exit(TRUE)
        end else
            exit(FALSE);
    end;

    local procedure SOCommentLineExists(SONo: Code[20]; ItemCode: Code[20]; LineNo: Integer): Boolean
    var
        SLRec: Record "Sales Line";
    begin
        SLRec.Reset;
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetRange("Document No.", SONo);
        SLRec.SetRange("Line No.", LineNo);
        SLRec.SetRange(Type, SLRec.Type::" ");
        SLRec.SetFilter(Description, '<>%1', '');
        if SLRec.FindFirst() then begin
            exit(TRUE)
        end else
            exit(FALSE);
    end;

    procedure AutoPopulateTrackingSO(SLLineRec: Record "Sales Line")
    var
        ItemRec: Record "Item";
        ILERec: Record "Item Ledger Entry";
        InputLineQty: Decimal;
        xcount: Integer;
        LotNoDim: array[500] of Code[20];
        LotNoQty: array[500] of Decimal;
        i: Integer;
        ReservEntryNo: Record "Reservation Entry";
        TempinputLineQty: Decimal;
        XVar: Decimal;
        ESRec: Record "Entry Summary";
        ResEntryRec: Record "Reservation Entry";
        //SLLineRec: Record "Sales Line";
        ATOLink: Record "Assemble-to-Order Link";
        AHRec: Record "Assembly Header";
        lrec_SH: Record "Sales Header";//#log1
        ldt_PostingDate: Date; //#log1
        ExprDate: Date;     //DX        27 Aug 201      Chain pharmacy require to have More than 1 year expiration
    begin
        ExprDate := CalcDate('<1Y>', Today);
        ItemRec.RESET;
        ItemRec.GET(SLLineRec."No.");
        CLEAR(LotNoDim);
        CLEAR(LotNoQty);
        IF ItemRec."Item Tracking Code" <> '' THEN BEGIN
            InputLineQty := SLLineRec."Quantity (Base)";
            xcount := 0;
            ILERec.RESET;
            ILERec.SETCURRENTKEY("Item No.", "Expiration Date");
            ILERec.SETASCENDING("Expiration Date", TRUE);
            ILERec.SETFILTER("Expiration Date", '%1..', ExprDate);
            ILERec.SETRANGE("Item No.", SLLineRec."No.");
            ILERec.SETFILTER("Lot No.", '<>%1', '');
            ILERec.SETRANGE("Location Code", SLLineRec."Location Code"); //DX    24 July 2019
            ILERec.SETFILTER("Remaining Quantity", '>0');
            IF ILERec.FINDSET THEN
                REPEAT    //Populate all the dimensions
                    xcount += 1;
                    XVar := 0;
                    ResEntryRec.RESET;
                    ResEntryRec.SETFILTER("Item No.", SLLineRec."No.");
                    ResEntryRec.SETFILTER("Lot No.", ILERec."Lot No.");
                    ResEntryRec.SETFILTER("Location Code", SLLineRec."Location Code");
                    IF ResEntryRec.FINDSET THEN
                        REPEAT
                            XVar += ResEntryRec."Quantity (Base)";
                        UNTIL ResEntryRec.NEXT = 0;
                    IF ILERec."Remaining Quantity" + XVar > 0 THEN BEGIN
                        LotNoDim[xcount] := ILERec."Lot No.";
                        LotNoQty[xcount] := ILERec."Remaining Quantity" + XVar;
                    END;
                UNTIL ILERec.NEXT = 0;
            TempinputLineQty := InputLineQty;
            FOR i := 1 TO (xcount) DO BEGIN
                IF LotNoQty[i] <> 0 THEN BEGIN
                    IF LotNoQty[i] - TempinputLineQty >= 0 THEN BEGIN
                        InsertJnlLineTrackingSO(LotNoDim[i], TempinputLineQty, SLLineRec);
                        BREAK;
                    END ELSE
                        IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                            InsertJnlLineTrackingSO(LotNoDim[i], LotNoQty[i], SLLineRec);
                            TempinputLineQty := TempinputLineQty - LotNoQty[i];
                        END;
                END;
            END;
        END;
    end;

    procedure InsertJnlLineTrackingSO(LotNo: Code[20]; Qty: Decimal; SORec: Record "Sales Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        SHRec: Record "Sales Header";

    begin
        CLEAR(ReservEntry);
        ReservEntryNo.RESET;
        ReservEntry.INIT;
        IF ReservEntryNo.FINDLAST THEN
            ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
        ELSE
            ReservEntry."Entry No." := 1;

        ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
        ReservEntry.VALIDATE("Item No.", SORec."No.");
        ReservEntry.VALIDATE("Location Code", SORec."Location Code");
        ReservEntry.VALIDATE("Source Type", 37);
        ReservEntry.VALIDATE("Source Subtype", 1);
        ReservEntry.VALIDATE("Source ID", SORec."Document No.");
        ReservEntry.VALIDATE("Source Ref. No.", SORec."Line No.");
        ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
        ReservEntry.VALIDATE("Lot No.", LotNo);
        ReservEntry.VALIDATE("Qty. per Unit of Measure", SORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE(Quantity, -Qty * SORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE("Quantity (Base)", -Qty);
        SHRec.RESET;
        SHRec.SETRANGE("No.", SORec."Document No.");
        IF SHRec.FINDFIRST THEN BEGIN
            //DX        21 Sept 2021
            //ReservEntry.VALIDATE("Shipment Date", SHRec."Posting Date");
            ReservEntry.VALIDATE("Shipment Date", SHRec."Shipment Date");
            //DX        21 Sept 2021
        END;
        ReservEntry.VALIDATE("Creation Date", TODAY);
        ReservEntry.VALIDATE("Created By", USERID);
        ReservEntry.VALIDATE("Qty. to Handle (Base)", -Qty);
        ReservEntry.VALIDATE("Qty. to Invoice (Base)", -Qty);
        ReservEntry.INSERT(TRUE);

    end;
    //insert negative journal for transfer

    procedure ClearTrackingLinesSO(SLRec: Record "Sales Line")
    var
        reserveEntry: Record "Reservation Entry";
    begin

        reserveEntry.RESET;
        reserveEntry.SETRANGE("Item No.", SLRec."No.");
        reserveEntry.SETRANGE("Source ID", SLRec."Document No.");
        reserveEntry.SETRANGE("Source Ref. No.", SLRec."Line No.");
        reserveEntry.SETRANGE("Location Code", SLRec."Location Code");
        reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Surplus);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not reserveEntry.IsEmpty then
            reserveEntry.DELETEALL(TRUE);
        // YF 10 Aug 2022 // To avoid unnecessary table lock

    end;
    //Delete all existing item tracking lines


    procedure ImportChainGuardianPOXML()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        XMLBuffer: Record "XML Buffer" temporary;
        LinesMod: integer;

        IncomingPOHeader: Record "Chain PO Header";
        IncomingPOLine: Record "Chain PO Line";

        TempIncomingPOHeader: Record "Chain PO Header" temporary;
        TempIncomingPOLine: Record "Chain PO Line" temporary;

        CurrentItemLine: Integer;
        CurrentPONumber: Code[20];

    begin

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);

        LinesMod := 0;
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not TempIncomingPOHeader.IsEmpty then
            TempIncomingPOHeader.DeleteAll();
        if not TempIncomingPOLine.IsEmpty then
            TempIncomingPOLine.DeleteAll();
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        CurrentItemLine := 0;
        CurrentPONumber := '';

        XMLBuffer.DeleteAll();
        XMLBuffer.LoadFromStream(ImportStream);

        if XMLBuffer.FindFirst() then begin
            // should have data. insert temp PO header entry first
            TempIncomingPOHeader.Init();
            TempIncomingPOHeader."Entry No." := 1;
            TempIncomingPOHeader.Chain := 'GUARDIAN';
            // TempIncomingPOHeader.Insert();
        end;

        if XMLBuffer.FindSet() then
            repeat

                // Document Type
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'typedEntityIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification') then begin
                    TempIncomingPOHeader."Document Type" := XMLBuffer.GetAttributeValueAsText('entityType');
                end;

                // PO Number
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'uniqueCreatorIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification/entityIdentification/uniqueCreatorIdentification') then begin
                    TempIncomingPOHeader."PO Number" := XMLBuffer.Value;
                    CurrentPONumber := XMLBuffer.Value;
                end;

                // PO Date
                if (XMLBuffer.Type = XMLBuffer.Type::Attribute) And (XMLBuffer.Name = 'creationDate') then
                    Evaluate(TempIncomingPOHeader."PO Date", COPYSTR(XMLBuffer.Value, 1, 10));

                // Buyer Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/buyer/alternatePartyIdentification') then
                    TempIncomingPOHeader."Buyer Code" := XMLBuffer.Value;

                // Buyer Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/buyer/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Buyer Name" := XMLBuffer.Value;

                // Supplier Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/seller/alternatePartyIdentification') then
                    TempIncomingPOHeader."Supplier Code" := XMLBuffer.Value;

                // Supplier Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/seller/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Supplier Name" := XMLBuffer.Value;

                // Line Item Count
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'totalLineItem') And (XMLBuffer.Path = '/sanc:order/totalLineItem') then begin
                    if Not Evaluate(TempIncomingPOHeader."Line Item Count", XMLBuffer.Value) then
                        TempIncomingPOHeader."Line Item Count" := 0;
                end;


                // Line Item[n] Setup
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'lineItem') then begin

                    // Set current item line no.
                    if not Evaluate(CurrentItemLine, XMLBuffer.GetAttributeValueAsText('number')) then
                        CurrentItemLine := 0
                    else begin
                        // Setup line record
                        TempIncomingPOLine.Init();
                        TempIncomingPOLine."PO Entry No." := 1;
                        TempIncomingPOLine."PO Number" := CurrentPONumber;
                        TempIncomingPOLine."Item Line No." := CurrentItemLine;
                        TempIncomingPOLine.ChainPOLineTimestamp := CurrentDateTime;
                        TempIncomingPOLine.Insert();
                    end;

                end;

                // get line data for header
                if CurrentItemLine = 1 then begin

                    // Line Delivery Start Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyStartDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyStartDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery Start Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery Start Date" := 0D;

                    end;

                    // Line Delivery End Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyEndDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyEndDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery End Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery End Date" := 0D;

                    end;

                    // Line Store Code - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalPartyIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/additionalPartyIdentification') then
                        TempIncomingPOHeader."Store Code" := XMLBuffer.Value;

                    // Line Store Name - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/nameAndAddress/name') then
                        TempIncomingPOHeader."Store Name" := XMLBuffer.Value;

                end;

                // get line details
                if CurrentItemLine > 0 then begin
                    // Line Buyer Item Code
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/additionalItemIdentification') then
                        TempIncomingPOLine."Buyer Item Code" := XMLBuffer.Value;

                    // Line Barcode
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternateItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/alternateItemIdentification') then
                        TempIncomingPOLine.Barcode := XMLBuffer.Value;

                    // Line Item Description
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'text') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradeItemDescription/descriptionShort/description/text') then
                        TempIncomingPOLine."Item Description" := XMLBuffer.Value;

                    // Line UOM
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'packagingTypeCode') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/packagingType/packagingTypeCode') then
                        TempIncomingPOLine.UOM := XMLBuffer.Value;

                    // Line Pack Size
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'quantityOfNextLevelTradeItemWithinInnerPack') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemHierarchy/quantityOfNextLevelTradeItemWithinInnerPack') then begin
                        if not Evaluate(TempIncomingPOLine."Pack Size", XMLBuffer.Value) then
                            TempIncomingPOLine."Pack Size" := 0;
                    end;

                    // Unit Price
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netPrice/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Unit Price", XMLBuffer.Value) then
                            TempIncomingPOLine."Unit Price" := 0;
                    end;

                    // Order Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'requestedQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/requestedQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."Order Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."Order Quantity" := 0;
                    end;

                    // FOC Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'freeQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/freeQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."FOC Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."FOC Quantity" := 0;
                    end;

                    // Line Item Total Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netAmount/amount') then begin

                        if not Evaluate(TempIncomingPOLine."Line Item Total", XMLBuffer.Value) then
                            TempIncomingPOLine."Line Item Total" := 0;

                        if not Evaluate(TempIncomingPOLine."Total Amount After Discount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Amount After Discount" := 0;

                    end;

                    // Line Total Discount Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Amount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Amount" := 0;
                    end;

                    // Line Total Discount Percent
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'percentage') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/percentage') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Percentage", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Percentage" := 0;
                    end;

                    // Update line
                    If not TempIncomingPOLine.Insert() then TempIncomingPOLine.Modify();
                end;

            until XMLBuffer.Next() = 0;

        // Settle header record
        TempIncomingPOHeader.ChainPOHeaderTimestamp := CurrentDateTime;
        if not TempIncomingPOHeader.Insert() then TempIncomingPOHeader.Modify();

        // Loop and display temp tables for data verification
        /*
        Message('Header = ' + Format(TempIncomingPOHeader."Entry No.") + ' | '
                    + TempIncomingPOHeader."Document Type" + ' | '
                    + TempIncomingPOHeader."PO Number" + ' | '
                    + Format(TempIncomingPOHeader."PO Date") + ' | '
                    + Format(TempIncomingPOHeader."Buyer Code") + ' | '
                    + TempIncomingPOHeader."Buyer Name");

        TempIncomingPOLine.Reset;
        if TempIncomingPOLine.FindSet() then
            repeat
                Message('Line = ' + Format(TempIncomingPOLine."Item Line No.") + ' | ' + TempIncomingPOLine."Buyer Item Code " + ' | ' + TempIncomingPOLine."Item Description ");
            until TempIncomingPOLine.Next() = 0;
        */

        // Write to actual staging tables
        IncomingPOHeader.Reset;
        IncomingPOHeader.Init();
        IncomingPOHeader."PO Number" := TempIncomingPOHeader."PO Number";
        IncomingPOHeader.Chain := TempIncomingPOHeader.Chain;
        IncomingPOHeader."Document Type" := TempIncomingPOHeader."Document Type";
        IncomingPOHeader."PO Date" := TempIncomingPOHeader."PO Date";
        IncomingPOHeader."Buyer Code" := TempIncomingPOHeader."Buyer Code";
        IncomingPOHeader."Buyer Name" := TempIncomingPOHeader."Buyer Name";
        IncomingPOHeader."Supplier Code" := TempIncomingPOHeader."Supplier Code";
        IncomingPOHeader."Supplier Name" := TempIncomingPOHeader."Supplier Name";
        IncomingPOHeader."Line Item Count" := TempIncomingPOHeader."Line Item Count";
        IncomingPOHeader."Delivery Start Date" := TempIncomingPOHeader."Delivery Start Date";
        IncomingPOHeader."Delivery End Date" := TempIncomingPOHeader."Delivery End Date";
        IncomingPOHeader."Store Code" := TempIncomingPOHeader."Store Code";
        IncomingPOHeader."Store Name" := TempIncomingPOHeader."Store Name";
        IncomingPOHeader.ChainPOHeaderTimestamp := TempIncomingPOHeader.ChainPOHeaderTimestamp;

        if IncomingPOHeader.Insert(true) then begin
            TempIncomingPOLine.Reset;
            if TempIncomingPOLine.FindSet() then
                repeat
                    IncomingPOLine.Reset;
                    IncomingPOLine.Init();
                    IncomingPOLine."PO Entry No." := IncomingPOHeader."Entry No.";
                    IncomingPOLine."PO Number" := IncomingPOHeader."PO Number";
                    IncomingPOLine."Item Line No." := TempIncomingPOLine."Item Line No.";
                    IncomingPOLine."Buyer Item Code" := TempIncomingPOLine."Buyer Item Code";
                    IncomingPOLine.Barcode := TempIncomingPOLine.Barcode;
                    IncomingPOLine."Item Description" := TempIncomingPOLine."Item Description";
                    IncomingPOLine.UOM := TempIncomingPOLine.UOM;
                    IncomingPOLine."Pack Size" := TempIncomingPOLine."Pack Size";
                    IncomingPOLine."Unit Price" := TempIncomingPOLine."Unit Price";
                    IncomingPOLine."Order Quantity" := TempIncomingPOLine."Order Quantity";
                    IncomingPOLine."FOC Quantity" := TempIncomingPOLine."FOC Quantity";
                    IncomingPOLine."Line Item Total" := TempIncomingPOLine."Line Item Total";
                    IncomingPOLine."Total Discount Amount" := TempIncomingPOLine."Total Discount Amount";
                    IncomingPOLine."Total Discount Percentage" := TempIncomingPOLine."Total Discount Percentage";
                    IncomingPOLine."Total Amount After Discount" := TempIncomingPOLine."Total Amount After Discount";
                    IncomingPOLine.ChainPOLineTimestamp := TempIncomingPOLine.ChainPOLineTimestamp;
                    IncomingPOLine.Insert();
                until TempIncomingPOLine.Next() = 0;
        end;

        // Status Message with Entry No. information
        Message('PO imported. Entry No. ' + Format(IncomingPOHeader."Entry No."));

        /*
        if LinesMod <> 0 then
            Message('%1 headers imported.', LinesMod);
        */
    end;


    procedure ImportChainWatsonPOXML()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        XMLBuffer: Record "XML Buffer" temporary;
        LinesMod: integer;

        IncomingPOHeader: Record "Chain PO Header";
        IncomingPOLine: Record "Chain PO Line";

        TempIncomingPOHeader: Record "Chain PO Header" temporary;
        TempIncomingPOLine: Record "Chain PO Line" temporary;

        CurrentItemLine: Integer;
        CurrentPONumber: Code[20];

    begin

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);

        LinesMod := 0;
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not TempIncomingPOHeader.IsEmpty then
            TempIncomingPOHeader.DeleteAll();
        if not TempIncomingPOLine.IsEmpty then
            TempIncomingPOLine.DeleteAll();
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        CurrentItemLine := 0;
        CurrentPONumber := '';

        XMLBuffer.DeleteAll();
        XMLBuffer.LoadFromStream(ImportStream);

        if XMLBuffer.FindFirst() then begin
            // should have data. insert temp PO header entry first
            TempIncomingPOHeader.Init();
            TempIncomingPOHeader."Entry No." := 1;
            TempIncomingPOHeader.Chain := 'WATSON';
            // TempIncomingPOHeader.Insert();
        end;

        if XMLBuffer.FindSet() then
            repeat

                // Document Type
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'typedEntityIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification') then begin
                    TempIncomingPOHeader."Document Type" := XMLBuffer.GetAttributeValueAsText('entityType');
                end;

                // PO Number
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'uniqueCreatorIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification/entityIdentification/uniqueCreatorIdentification') then begin
                    TempIncomingPOHeader."PO Number" := XMLBuffer.Value;
                    CurrentPONumber := XMLBuffer.Value;
                end;

                // PO Date
                if (XMLBuffer.Type = XMLBuffer.Type::Attribute) And (XMLBuffer.Name = 'creationDate') then
                    Evaluate(TempIncomingPOHeader."PO Date", COPYSTR(XMLBuffer.Value, 1, 10));

                // Buyer Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/buyer/alternatePartyIdentification') then
                    TempIncomingPOHeader."Buyer Code" := XMLBuffer.Value;

                // Buyer Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/buyer/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Buyer Name" := XMLBuffer.Value;

                // Supplier Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/seller/alternatePartyIdentification') then
                    TempIncomingPOHeader."Supplier Code" := XMLBuffer.Value;

                // Supplier Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/seller/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Supplier Name" := XMLBuffer.Value;

                // Line Item Count
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'totalLineItem') And (XMLBuffer.Path = '/sanc:order/totalLineItem') then begin
                    if Not Evaluate(TempIncomingPOHeader."Line Item Count", XMLBuffer.Value) then
                        TempIncomingPOHeader."Line Item Count" := 0;
                end;


                // Line Item[n] Setup
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'lineItem') then begin

                    // Set current item line no.
                    if not Evaluate(CurrentItemLine, XMLBuffer.GetAttributeValueAsText('number')) then
                        CurrentItemLine := 0
                    else begin
                        // Setup line record
                        TempIncomingPOLine.Init();
                        TempIncomingPOLine."PO Entry No." := 1;
                        TempIncomingPOLine."PO Number" := CurrentPONumber;
                        TempIncomingPOLine."Item Line No." := CurrentItemLine;
                        TempIncomingPOLine.ChainPOLineTimestamp := CurrentDateTime;
                        TempIncomingPOLine.Insert();
                    end;

                end;

                // get line data for header
                if CurrentItemLine = 10 then begin

                    // Line Delivery Start Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyStartDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyStartDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery Start Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery Start Date" := 0D;

                    end;

                    // Line Delivery End Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyEndDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyEndDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery End Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery End Date" := 0D;

                    end;

                    // Line Store Code - [1] for Header
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalPartyIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/additionalPartyIdentification') then
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/alternatePartyIdentification') then
                        TempIncomingPOHeader."Store Code" := XMLBuffer.Value;

                    // Line Store Name - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/nameAndAddress/name') then
                        TempIncomingPOHeader."Store Name" := XMLBuffer.Value;

                end;

                // get line details
                if CurrentItemLine > 0 then begin
                    // Line Buyer Item Code
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/additionalItemIdentification') then
                        TempIncomingPOLine."Buyer Item Code" := XMLBuffer.Value;

                    // Line Barcode
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternateItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/alternateItemIdentification') then
                        TempIncomingPOLine.Barcode := XMLBuffer.Value;

                    // Line Item Description
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'text') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradeItemDescription/descriptionShort/description/text') then
                        TempIncomingPOLine."Item Description" := XMLBuffer.Value;

                    // Line UOM
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'packagingTypeCode') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/packagingType/packagingTypeCode') then
                        TempIncomingPOLine.UOM := XMLBuffer.Value;

                    // Line Pack Size
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'quantityOfNextLevelTradeItemWithinInnerPack') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemHierarchy/quantityOfNextLevelTradeItemWithinInnerPack') then begin
                        if not Evaluate(TempIncomingPOLine."Pack Size", XMLBuffer.Value) then
                            TempIncomingPOLine."Pack Size" := 0;
                    end;

                    // Unit Price
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netPrice/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Unit Price", XMLBuffer.Value) then
                            TempIncomingPOLine."Unit Price" := 0;
                    end;

                    // Order Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'requestedQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/requestedQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."Order Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."Order Quantity" := 0;
                    end;

                    // FOC Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'freeQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/freeQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."FOC Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."FOC Quantity" := 0;
                    end;

                    // Line Item Total Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netAmount/amount') then begin

                        if not Evaluate(TempIncomingPOLine."Line Item Total", XMLBuffer.Value) then
                            TempIncomingPOLine."Line Item Total" := 0;

                        if not Evaluate(TempIncomingPOLine."Total Amount After Discount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Amount After Discount" := 0;

                    end;

                    // Line Total Discount Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Amount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Amount" := 0;
                    end;

                    // Line Total Discount Percent
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'percentage') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/percentage') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Percentage", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Percentage" := 0;
                    end;

                    // Update line
                    If not TempIncomingPOLine.Insert() then TempIncomingPOLine.Modify();
                end;

            until XMLBuffer.Next() = 0;

        // Settle header record
        TempIncomingPOHeader.ChainPOHeaderTimestamp := CurrentDateTime;
        if not TempIncomingPOHeader.Insert() then TempIncomingPOHeader.Modify();

        // Loop and display temp tables for data verification
        /*
        Message('Header = ' + Format(TempIncomingPOHeader."Entry No.") + ' | '
                    + TempIncomingPOHeader."Document Type" + ' | '
                    + TempIncomingPOHeader."PO Number" + ' | '
                    + Format(TempIncomingPOHeader."PO Date") + ' | '
                    + Format(TempIncomingPOHeader."Buyer Code") + ' | '
                    + TempIncomingPOHeader."Buyer Name");

        TempIncomingPOLine.Reset;
        if TempIncomingPOLine.FindSet() then
            repeat
                Message('Line = ' + Format(TempIncomingPOLine."Item Line No.") + ' | ' + TempIncomingPOLine."Buyer Item Code " + ' | ' + TempIncomingPOLine."Item Description ");
            until TempIncomingPOLine.Next() = 0;
        */

        // Write to actual staging tables
        IncomingPOHeader.Reset;
        IncomingPOHeader.Init();
        IncomingPOHeader."PO Number" := TempIncomingPOHeader."PO Number";
        IncomingPOHeader.Chain := TempIncomingPOHeader.Chain;
        IncomingPOHeader."Document Type" := TempIncomingPOHeader."Document Type";
        IncomingPOHeader."PO Date" := TempIncomingPOHeader."PO Date";
        IncomingPOHeader."Buyer Code" := TempIncomingPOHeader."Buyer Code";
        IncomingPOHeader."Buyer Name" := TempIncomingPOHeader."Buyer Name";
        IncomingPOHeader."Supplier Code" := TempIncomingPOHeader."Supplier Code";
        IncomingPOHeader."Supplier Name" := TempIncomingPOHeader."Supplier Name";
        IncomingPOHeader."Line Item Count" := TempIncomingPOHeader."Line Item Count";
        IncomingPOHeader."Delivery Start Date" := TempIncomingPOHeader."Delivery Start Date";
        IncomingPOHeader."Delivery End Date" := TempIncomingPOHeader."Delivery End Date";
        IncomingPOHeader."Store Code" := TempIncomingPOHeader."Store Code";
        IncomingPOHeader."Store Name" := TempIncomingPOHeader."Store Name";
        IncomingPOHeader.ChainPOHeaderTimestamp := TempIncomingPOHeader.ChainPOHeaderTimestamp;

        if IncomingPOHeader.Insert(true) then begin
            TempIncomingPOLine.Reset;
            if TempIncomingPOLine.FindSet() then
                repeat
                    IncomingPOLine.Reset;
                    IncomingPOLine.Init();
                    IncomingPOLine."PO Entry No." := IncomingPOHeader."Entry No.";
                    IncomingPOLine."PO Number" := IncomingPOHeader."PO Number";
                    IncomingPOLine."Item Line No." := TempIncomingPOLine."Item Line No.";
                    IncomingPOLine."Buyer Item Code" := TempIncomingPOLine."Buyer Item Code";
                    IncomingPOLine.Barcode := TempIncomingPOLine.Barcode;
                    IncomingPOLine."Item Description" := TempIncomingPOLine."Item Description";
                    IncomingPOLine.UOM := TempIncomingPOLine.UOM;
                    IncomingPOLine."Pack Size" := TempIncomingPOLine."Pack Size";
                    IncomingPOLine."Unit Price" := TempIncomingPOLine."Unit Price";
                    IncomingPOLine."Order Quantity" := TempIncomingPOLine."Order Quantity";
                    IncomingPOLine."FOC Quantity" := TempIncomingPOLine."FOC Quantity";
                    IncomingPOLine."Line Item Total" := TempIncomingPOLine."Line Item Total";
                    IncomingPOLine."Total Discount Amount" := TempIncomingPOLine."Total Discount Amount";
                    IncomingPOLine."Total Discount Percentage" := TempIncomingPOLine."Total Discount Percentage";
                    IncomingPOLine."Total Amount After Discount" := TempIncomingPOLine."Total Amount After Discount";
                    IncomingPOLine.ChainPOLineTimestamp := TempIncomingPOLine.ChainPOLineTimestamp;
                    IncomingPOLine.Insert();
                until TempIncomingPOLine.Next() = 0;
        end;

        // Status Message with Entry No. information
        Message('PO imported. Entry No. ' + Format(IncomingPOHeader."Entry No."));

        /*
        if LinesMod <> 0 then
            Message('%1 headers imported.', LinesMod);
        */
    end;

    procedure ImportChainNTUCPOXML()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        XMLBuffer: Record "XML Buffer" temporary;
        LinesMod: integer;

        IncomingPOHeader: Record "Chain PO Header";
        IncomingPOLine: Record "Chain PO Line";

        TempIncomingPOHeader: Record "Chain PO Header" temporary;
        TempIncomingPOLine: Record "Chain PO Line" temporary;

        CurrentItemLine: Integer;
        CurrentPONumber: Code[20];

    begin

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);

        LinesMod := 0;
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not TempIncomingPOHeader.IsEmpty then
            TempIncomingPOHeader.DeleteAll();
        if not TempIncomingPOLine.IsEmpty then
            TempIncomingPOLine.DeleteAll();
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        CurrentItemLine := 0;
        CurrentPONumber := '';

        XMLBuffer.DeleteAll();
        XMLBuffer.LoadFromStream(ImportStream);

        if XMLBuffer.FindFirst() then begin
            // should have data. insert temp PO header entry first
            TempIncomingPOHeader.Init();
            TempIncomingPOHeader."Entry No." := 1;
            TempIncomingPOHeader.Chain := 'NTUC';
            // TempIncomingPOHeader.Insert();
        end;

        if XMLBuffer.FindSet() then
            repeat

                // Document Type
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'typedEntityIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification') then begin
                    TempIncomingPOHeader."Document Type" := XMLBuffer.GetAttributeValueAsText('entityType');
                end;

                // PO Number
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'uniqueCreatorIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification/entityIdentification/uniqueCreatorIdentification') then begin
                    TempIncomingPOHeader."PO Number" := XMLBuffer.Value;
                    CurrentPONumber := XMLBuffer.Value;
                end;

                // PO Date
                if (XMLBuffer.Type = XMLBuffer.Type::Attribute) And (XMLBuffer.Name = 'creationDate') then
                    Evaluate(TempIncomingPOHeader."PO Date", COPYSTR(XMLBuffer.Value, 1, 10));

                // Buyer Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/buyer/alternatePartyIdentification') then
                    TempIncomingPOHeader."Buyer Code" := XMLBuffer.Value;

                // Buyer Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/buyer/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Buyer Name" := XMLBuffer.Value;

                // Supplier Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/seller/alternatePartyIdentification') then
                    TempIncomingPOHeader."Supplier Code" := XMLBuffer.Value;

                // Supplier Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/seller/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Supplier Name" := XMLBuffer.Value;

                // Line Item Count
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'totalLineItem') And (XMLBuffer.Path = '/sanc:order/totalLineItem') then begin
                    if Not Evaluate(TempIncomingPOHeader."Line Item Count", XMLBuffer.Value) then
                        TempIncomingPOHeader."Line Item Count" := 0;
                end;


                // Line Item[n] Setup
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'lineItem') then begin

                    // Set current item line no.
                    if not Evaluate(CurrentItemLine, XMLBuffer.GetAttributeValueAsText('number')) then
                        CurrentItemLine := 0
                    else begin
                        // Setup line record
                        TempIncomingPOLine.Init();
                        TempIncomingPOLine."PO Entry No." := 1;
                        TempIncomingPOLine."PO Number" := CurrentPONumber;
                        TempIncomingPOLine."Item Line No." := CurrentItemLine;
                        TempIncomingPOLine.ChainPOLineTimestamp := CurrentDateTime;
                        TempIncomingPOLine.Insert();
                    end;

                end;

                // get line data for header
                if CurrentItemLine = 1 then begin

                    // Line Delivery Start Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyStartDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyStartDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery Start Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery Start Date" := 0D;

                    end;

                    // Line Delivery End Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyEndDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyEndDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery End Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery End Date" := 0D;

                    end;

                    // Line Store Code - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/alternatePartyIdentification') then
                        TempIncomingPOHeader."Store Code" := XMLBuffer.Value;

                    // Line Store Name - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/nameAndAddress/name') then
                        TempIncomingPOHeader."Store Name" := XMLBuffer.Value;

                end;

                // get line details
                if CurrentItemLine > 0 then begin
                    // Line Buyer Item Code
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternateItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/buyerStockCode/alternateItemIdentification') then
                        TempIncomingPOLine."Buyer Item Code" := XMLBuffer.Value;

                    // Line Barcode
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/additionalItemIdentification') then
                        TempIncomingPOLine.Barcode := XMLBuffer.Value;

                    // Line Item Description
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'text') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradeItemDescription/descriptionShort/description/text') then
                        TempIncomingPOLine."Item Description" := XMLBuffer.Value;

                    // Line UOM
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'measurementValue') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemMeasurements/netContent/measurementValue') then
                        TempIncomingPOLine.UOM := XMLBuffer.GetAttributeValueAsText('unitOfMeasure');

                    // Line Pack Size
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'quantityOfNextLevelTradeItemWithinInnerPack') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemHierarchy/quantityOfNextLevelTradeItemWithinInnerPack') then begin
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'quantityOfInnerPack') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemHierarchy/quantityOfInnerPack') then begin
                        if not Evaluate(TempIncomingPOLine."Pack Size", XMLBuffer.Value) then
                            TempIncomingPOLine."Pack Size" := 0;
                    end;

                    // Unit Price
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netPrice/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Unit Price", XMLBuffer.Value) then
                            TempIncomingPOLine."Unit Price" := 0;
                    end;

                    // Order Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'requestedQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/requestedQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."Order Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."Order Quantity" := 0;
                    end;

                    // FOC Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'freeQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/freeQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."FOC Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."FOC Quantity" := 0;
                    end;

                    // Line Item Total Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netAmount/amount') then begin

                        if not Evaluate(TempIncomingPOLine."Line Item Total", XMLBuffer.Value) then
                            TempIncomingPOLine."Line Item Total" := 0;

                        if not Evaluate(TempIncomingPOLine."Total Amount After Discount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Amount After Discount" := 0;

                    end;

                    // Line Total Discount Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Amount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Amount" := 0;
                    end;

                    // Line Total Discount Percent
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'percentage') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/percentage') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Percentage", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Percentage" := 0;
                    end;

                    // Update line
                    If not TempIncomingPOLine.Insert() then TempIncomingPOLine.Modify();
                end;

            until XMLBuffer.Next() = 0;

        // Settle header record
        TempIncomingPOHeader.ChainPOHeaderTimestamp := CurrentDateTime;
        if not TempIncomingPOHeader.Insert() then TempIncomingPOHeader.Modify();

        // Loop and display temp tables for data verification
        /*
        Message('Header = ' + Format(TempIncomingPOHeader."Entry No.") + ' | '
                    + TempIncomingPOHeader."Document Type" + ' | '
                    + TempIncomingPOHeader."PO Number" + ' | '
                    + Format(TempIncomingPOHeader."PO Date") + ' | '
                    + Format(TempIncomingPOHeader."Buyer Code") + ' | '
                    + TempIncomingPOHeader."Buyer Name");

        TempIncomingPOLine.Reset;
        if TempIncomingPOLine.FindSet() then
            repeat
                Message('Line = ' + Format(TempIncomingPOLine."Item Line No.") + ' | ' + TempIncomingPOLine."Buyer Item Code " + ' | ' + TempIncomingPOLine."Item Description ");
            until TempIncomingPOLine.Next() = 0;
        */

        // Write to actual staging tables
        IncomingPOHeader.Reset;
        IncomingPOHeader.Init();
        IncomingPOHeader."PO Number" := TempIncomingPOHeader."PO Number";
        IncomingPOHeader.Chain := TempIncomingPOHeader.Chain;
        IncomingPOHeader."Document Type" := TempIncomingPOHeader."Document Type";
        IncomingPOHeader."PO Date" := TempIncomingPOHeader."PO Date";
        IncomingPOHeader."Buyer Code" := TempIncomingPOHeader."Buyer Code";
        IncomingPOHeader."Buyer Name" := TempIncomingPOHeader."Buyer Name";
        IncomingPOHeader."Supplier Code" := TempIncomingPOHeader."Supplier Code";
        IncomingPOHeader."Supplier Name" := TempIncomingPOHeader."Supplier Name";
        IncomingPOHeader."Line Item Count" := TempIncomingPOHeader."Line Item Count";
        IncomingPOHeader."Delivery Start Date" := TempIncomingPOHeader."Delivery Start Date";
        IncomingPOHeader."Delivery End Date" := TempIncomingPOHeader."Delivery End Date";
        IncomingPOHeader."Store Code" := TempIncomingPOHeader."Store Code";
        IncomingPOHeader."Store Name" := TempIncomingPOHeader."Store Name";
        IncomingPOHeader.ChainPOHeaderTimestamp := TempIncomingPOHeader.ChainPOHeaderTimestamp;

        if IncomingPOHeader.Insert(true) then begin
            TempIncomingPOLine.Reset;
            if TempIncomingPOLine.FindSet() then
                repeat
                    IncomingPOLine.Reset;
                    IncomingPOLine.Init();
                    IncomingPOLine."PO Entry No." := IncomingPOHeader."Entry No.";
                    IncomingPOLine."PO Number" := IncomingPOHeader."PO Number";
                    IncomingPOLine."Item Line No." := TempIncomingPOLine."Item Line No.";
                    IncomingPOLine."Buyer Item Code" := TempIncomingPOLine."Buyer Item Code";
                    IncomingPOLine.Barcode := TempIncomingPOLine.Barcode;
                    IncomingPOLine."Item Description" := TempIncomingPOLine."Item Description";
                    IncomingPOLine.UOM := TempIncomingPOLine.UOM;
                    IncomingPOLine."Pack Size" := TempIncomingPOLine."Pack Size";
                    IncomingPOLine."Unit Price" := TempIncomingPOLine."Unit Price";
                    IncomingPOLine."Order Quantity" := TempIncomingPOLine."Order Quantity";
                    IncomingPOLine."FOC Quantity" := TempIncomingPOLine."FOC Quantity";
                    IncomingPOLine."Line Item Total" := TempIncomingPOLine."Line Item Total";
                    IncomingPOLine."Total Discount Amount" := TempIncomingPOLine."Total Discount Amount";
                    IncomingPOLine."Total Discount Percentage" := TempIncomingPOLine."Total Discount Percentage";
                    IncomingPOLine."Total Amount After Discount" := TempIncomingPOLine."Total Amount After Discount";
                    IncomingPOLine.ChainPOLineTimestamp := TempIncomingPOLine.ChainPOLineTimestamp;
                    IncomingPOLine.Insert();
                until TempIncomingPOLine.Next() = 0;
        end;

        // Status Message with Entry No. information
        Message('PO imported. Entry No. ' + Format(IncomingPOHeader."Entry No."));

        /*
        if LinesMod <> 0 then
            Message('%1 headers imported.', LinesMod);
        */
    end;


    procedure ImportChainPOXML()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        XMLBuffer: Record "XML Buffer" temporary;
        LinesMod: integer;

        IncomingPOHeader: Record "Chain PO Header";
        IncomingPOLine: Record "Chain PO Line";

        TempIncomingPOHeader: Record "Chain PO Header" temporary;
        TempIncomingPOLine: Record "Chain PO Line" temporary;

        CurrentItemLine: Integer;
        CurrentPONumber: Code[20];

        BuyerCodeChainMapping: Record "Buyer Code Chain Mapping";

    begin

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);

        LinesMod := 0;
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not TempIncomingPOHeader.IsEmpty then
            TempIncomingPOHeader.DeleteAll();
        if not TempIncomingPOLine.IsEmpty then
            TempIncomingPOLine.DeleteAll();
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        CurrentItemLine := 0;
        CurrentPONumber := '';

        XMLBuffer.DeleteAll();
        XMLBuffer.LoadFromStream(ImportStream);

        if XMLBuffer.FindFirst() then begin
            // should have data. insert temp PO header entry first
            TempIncomingPOHeader.Init();
            TempIncomingPOHeader."Entry No." := 1;
            // TempIncomingPOHeader.Chain := 'NTUC';
            // TempIncomingPOHeader.Insert();
        end;

        if XMLBuffer.FindSet() then
            repeat

                // Document Type
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'typedEntityIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification') then begin
                    TempIncomingPOHeader."Document Type" := XMLBuffer.GetAttributeValueAsText('entityType');
                end;

                // PO Number
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'uniqueCreatorIdentification') And (XMLBuffer.Path = '/sanc:order/typedEntityIdentification/entityIdentification/uniqueCreatorIdentification') then begin
                    TempIncomingPOHeader."PO Number" := XMLBuffer.Value;
                    CurrentPONumber := XMLBuffer.Value;
                end;

                // PO Date
                if (XMLBuffer.Type = XMLBuffer.Type::Attribute) And (XMLBuffer.Name = 'creationDate') then
                    Evaluate(TempIncomingPOHeader."PO Date", COPYSTR(XMLBuffer.Value, 1, 10));

                // Buyer Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/buyer/alternatePartyIdentification') then begin
                    TempIncomingPOHeader."Buyer Code" := XMLBuffer.Value;
                    BuyerCodeChainMapping.Reset;
                    BuyerCodeChainMapping.SetRange("Buyer Code", TempIncomingPOHeader."Buyer Code");
                    if BuyerCodeChainMapping.FindFirst() then
                        TempIncomingPOHeader.Chain := BuyerCodeChainMapping."Chain Code";
                end;


                // Buyer Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/buyer/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Buyer Name" := XMLBuffer.Value;

                // Supplier Code
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/seller/alternatePartyIdentification') then
                    TempIncomingPOHeader."Supplier Code" := XMLBuffer.Value;

                // Supplier Name
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/seller/partyInformation/nameAndAddress/name') then
                    TempIncomingPOHeader."Supplier Name" := XMLBuffer.Value;

                // Line Item Count
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'totalLineItem') And (XMLBuffer.Path = '/sanc:order/totalLineItem') then begin
                    if Not Evaluate(TempIncomingPOHeader."Line Item Count", XMLBuffer.Value) then
                        TempIncomingPOHeader."Line Item Count" := 0;
                end;


                // Line Item[n] Setup
                if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'lineItem') then begin

                    // Set current item line no.
                    if not Evaluate(CurrentItemLine, XMLBuffer.GetAttributeValueAsText('number')) then
                        CurrentItemLine := 0
                    else begin
                        // Setup line record
                        TempIncomingPOLine.Init();
                        TempIncomingPOLine."PO Entry No." := 1;
                        TempIncomingPOLine."PO Number" := CurrentPONumber;
                        TempIncomingPOLine."Item Line No." := CurrentItemLine;
                        TempIncomingPOLine.ChainPOLineTimestamp := CurrentDateTime;
                        TempIncomingPOLine.Insert();
                    end;

                end;

                // get line data for header
                if CurrentItemLine = 1 then begin

                    // Line Delivery Start Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyStartDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyStartDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery Start Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery Start Date" := 0D;

                    end;

                    // Line Delivery End Date - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'partyEndDate') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/partyDates/partyEndDate') then begin

                        if not Evaluate(TempIncomingPOHeader."Delivery End Date", COPYSTR(XMLBuffer.Value, 1, 10)) then
                            TempIncomingPOHeader."Delivery End Date" := 0D;

                    end;

                    // Line Store Code - [1] for Header
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternatePartyIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/alternatePartyIdentification') then
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalPartyIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/additionalPartyIdentification') then
                        TempIncomingPOHeader."Store Code" := XMLBuffer.Value;

                    // Line Store Name - [1] for Header
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'name') And (XMLBuffer.Path = '/sanc:order/lineItem/shiptoDetails/shiptoParty/partyInformation/nameAndAddress/name') then
                        TempIncomingPOHeader."Store Name" := XMLBuffer.Value;

                end;

                // get line details
                if CurrentItemLine > 0 then begin
                    // Line Buyer Item Code
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternateItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/buyerStockCode/alternateItemIdentification') then
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/additionalItemIdentification') then
                        TempIncomingPOLine."Buyer Item Code" := XMLBuffer.Value;

                    // Line Barcode
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'additionalItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/additionalItemIdentification') then
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'alternateItemIdentification') And (XMLBuffer.Path = '/sanc:order/lineItem/itemIdentification/alternateItemIdentification') then
                        TempIncomingPOLine.Barcode := XMLBuffer.Value;

                    // Line Item Description
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'text') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradeItemDescription/descriptionShort/description/text') then
                        TempIncomingPOLine."Item Description" := XMLBuffer.Value;

                    // Line UOM
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'measurementValue') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemMeasurements/netContent/measurementValue') then
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'packagingTypeCode') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/packagingType/packagingTypeCode') then
                        TempIncomingPOLine.UOM := XMLBuffer.GetAttributeValueAsText('unitOfMeasure');

                    // Line Pack Size
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'quantityOfNextLevelTradeItemWithinInnerPack') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemHierarchy/quantityOfNextLevelTradeItemWithinInnerPack') then begin
                        // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'quantityOfInnerPack') And (XMLBuffer.Path = '/sanc:order/lineItem/itemInformation/tradingPartnerNeutralTradeItemInformation/tradeItemHierarchy/quantityOfInnerPack') then begin
                        if not Evaluate(TempIncomingPOLine."Pack Size", XMLBuffer.Value) then
                            TempIncomingPOLine."Pack Size" := 0;
                    end;

                    // Unit Price
                    // if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netPrice/amount') then begin
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'netPrice') And (XMLBuffer.Path = '/sanc:order/lineItem/netPrice') then begin
                        if not Evaluate(TempIncomingPOLine."Unit Price", XMLBuffer.Value) then
                            TempIncomingPOLine."Unit Price" := 0;
                    end;

                    // Order Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'requestedQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/requestedQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."Order Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."Order Quantity" := 0;
                    end;

                    // FOC Quantity
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'freeQuantity') And (XMLBuffer.Path = '/sanc:order/lineItem/freeQuantity') then begin
                        if not Evaluate(TempIncomingPOLine."FOC Quantity", XMLBuffer.Value) then
                            TempIncomingPOLine."FOC Quantity" := 0;
                    end;

                    // Line Item Total Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/netAmount/amount') then begin

                        if not Evaluate(TempIncomingPOLine."Line Item Total", XMLBuffer.Value) then
                            TempIncomingPOLine."Line Item Total" := 0;

                        if not Evaluate(TempIncomingPOLine."Total Amount After Discount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Amount After Discount" := 0;

                    end;

                    // Line Total Discount Amount
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'amount') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/amount') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Amount", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Amount" := 0;
                    end;

                    // Line Total Discount Percent
                    if (XMLBuffer.Type = XMLBuffer.Type::Element) And (XMLBuffer.Name = 'percentage') And (XMLBuffer.Path = '/sanc:order/lineItem/monetaryAmountOrPercentage/percentage') then begin
                        if not Evaluate(TempIncomingPOLine."Total Discount Percentage", XMLBuffer.Value) then
                            TempIncomingPOLine."Total Discount Percentage" := 0;
                    end;

                    // Update line
                    If not TempIncomingPOLine.Insert() then TempIncomingPOLine.Modify();
                end;

            until XMLBuffer.Next() = 0;

        // Settle header record
        TempIncomingPOHeader.ChainPOHeaderTimestamp := CurrentDateTime;
        if not TempIncomingPOHeader.Insert() then TempIncomingPOHeader.Modify();

        // Loop and display temp tables for data verification
        /*
        Message('Header = ' + Format(TempIncomingPOHeader."Entry No.") + ' | '
                    + TempIncomingPOHeader."Document Type" + ' | '
                    + TempIncomingPOHeader."PO Number" + ' | '
                    + Format(TempIncomingPOHeader."PO Date") + ' | '
                    + Format(TempIncomingPOHeader."Buyer Code") + ' | '
                    + TempIncomingPOHeader."Buyer Name");

        TempIncomingPOLine.Reset;
        if TempIncomingPOLine.FindSet() then
            repeat
                Message('Line = ' + Format(TempIncomingPOLine."Item Line No.") + ' | ' + TempIncomingPOLine."Buyer Item Code " + ' | ' + TempIncomingPOLine."Item Description ");
            until TempIncomingPOLine.Next() = 0;
        */

        // Write to actual staging tables
        IncomingPOHeader.Reset;
        IncomingPOHeader.Init();
        IncomingPOHeader."PO Number" := TempIncomingPOHeader."PO Number";
        IncomingPOHeader.Chain := TempIncomingPOHeader.Chain;
        IncomingPOHeader."Document Type" := TempIncomingPOHeader."Document Type";
        IncomingPOHeader."PO Date" := TempIncomingPOHeader."PO Date";
        IncomingPOHeader."Buyer Code" := TempIncomingPOHeader."Buyer Code";
        IncomingPOHeader."Buyer Name" := TempIncomingPOHeader."Buyer Name";
        IncomingPOHeader."Supplier Code" := TempIncomingPOHeader."Supplier Code";
        IncomingPOHeader."Supplier Name" := TempIncomingPOHeader."Supplier Name";
        IncomingPOHeader."Line Item Count" := TempIncomingPOHeader."Line Item Count";
        IncomingPOHeader."Delivery Start Date" := TempIncomingPOHeader."Delivery Start Date";
        IncomingPOHeader."Delivery End Date" := TempIncomingPOHeader."Delivery End Date";
        IncomingPOHeader."Store Code" := TempIncomingPOHeader."Store Code";
        IncomingPOHeader."Store Name" := TempIncomingPOHeader."Store Name";
        IncomingPOHeader.ChainPOHeaderTimestamp := TempIncomingPOHeader.ChainPOHeaderTimestamp;

        if IncomingPOHeader.Insert(true) then begin
            TempIncomingPOLine.Reset;
            if TempIncomingPOLine.FindSet() then
                repeat
                    IncomingPOLine.Reset;
                    IncomingPOLine.Init();
                    IncomingPOLine."PO Entry No." := IncomingPOHeader."Entry No.";
                    IncomingPOLine."PO Number" := IncomingPOHeader."PO Number";
                    IncomingPOLine."Item Line No." := TempIncomingPOLine."Item Line No.";
                    IncomingPOLine."Buyer Item Code" := TempIncomingPOLine."Buyer Item Code";
                    IncomingPOLine.Barcode := TempIncomingPOLine.Barcode;
                    IncomingPOLine."Item Description" := TempIncomingPOLine."Item Description";
                    IncomingPOLine.UOM := TempIncomingPOLine.UOM;
                    IncomingPOLine."Pack Size" := TempIncomingPOLine."Pack Size";
                    IncomingPOLine."Unit Price" := TempIncomingPOLine."Unit Price";
                    IncomingPOLine."Order Quantity" := TempIncomingPOLine."Order Quantity";
                    IncomingPOLine."FOC Quantity" := TempIncomingPOLine."FOC Quantity";
                    IncomingPOLine."Line Item Total" := TempIncomingPOLine."Line Item Total";
                    IncomingPOLine."Total Discount Amount" := TempIncomingPOLine."Total Discount Amount";
                    IncomingPOLine."Total Discount Percentage" := TempIncomingPOLine."Total Discount Percentage";
                    IncomingPOLine."Total Amount After Discount" := TempIncomingPOLine."Total Amount After Discount";
                    IncomingPOLine.ChainPOLineTimestamp := TempIncomingPOLine.ChainPOLineTimestamp;
                    IncomingPOLine.Insert();
                until TempIncomingPOLine.Next() = 0;
        end;

        // Status Message with Entry No. information
        Message('PO imported. Entry No. ' + Format(IncomingPOHeader."Entry No."));

        /*
        if LinesMod <> 0 then
            Message('%1 headers imported.', LinesMod);
        */
    end;

    // YF 27 Sep 2021
    procedure ValidatePOInfo(ChainID: Code[10]; POID: Code[20]): Boolean
    var
        ItemRec: Record Item;
        CustRec: Record Customer;
        ItemUOM: Record "Item Unit of Measure";
        StageHeader: Record "Chain PO Header";
        Stageline: Record "Chain PO Line";
        ItemRefCustCode: Code[20];
    begin
        ItemRefCustCode := '';

        StageHeader.Reset;
        StageHeader.SetRange(Chain, ChainID);
        StageHeader.SetRange("PO Number", POID);

        if StageHeader.FindFirst() then begin
            IF TrySOCLEDocExist(POID) then begin
                if CustCodeIsValid(StageHeader.Chain, StageHeader."Store Code", ItemRefCustCode) then begin
                    Stageline.Reset;
                    Stageline.SetRange("PO Entry No.", StageHeader."Entry No.");
                    Stageline.SetRange("PO Number", POID);
                    Stageline.SetRange("SO Created", false);

                    if Stageline.FindSet() then
                        repeat
                            if NOT (CheckItemDetails(Stageline, ItemRefCustCode)) then begin
                                Stageline."Process Remarks" := GetLastErrorText();
                                Stageline."Last Error Message" := GetLastErrorText();
                                Stageline."SO Error" := true;
                                Stageline.Modify(false);
                                //DX        08 Oct 2021
                                StageHeader."SO Error" := true;
                                StageHeader."Process Remarks" := 'Line Error, refer to details.';
                                StageHeader."Last Error Message" := 'Line Error, refer to details.';
                                StageHeader.Modify(FALSE);
                                //DX        08 Oct 2021
                            end;

                        until Stageline.next = 0;

                end else begin
                    StageHeader."Process Remarks" := GetLastErrorText();
                    StageHeader."Last Error Message" := GetLastErrorText();
                    StageHeader."SO Error" := true;
                    StageHeader.Modify(false);
                    exit(false);
                end;
            end else begin
                StageHeader."Process Remarks" := GetLastErrorText();
                StageHeader."Last Error Message" := GetLastErrorText();
                StageHeader."SO Error" := true;
                StageHeader.Modify(FALSE);
                exit(false);
            end;
            if GetLastErrorText() <> '' then
                exit(false)
            else
                exit(true);
        end;

        Commit();
    end;

    [TryFunction]
    procedure TrySOCLEDocExist(DocNo: Code[20])
    var
        SHRec: Record "Sales Header";
        CLERec: Record "Cust. Ledger Entry";
    begin
        if isNTUC(DocNo) = false then begin //DX    23 May 2023
            SHRec.reset;
            SHRec.SetRange("External Document No.", DocNo);
            if SHRec.FindFirst() then begin
                Error('PO ' + DocNo + ' exists in Sales Order entry.');
            end;

            CLERec.reset;
            CLERec.SetRange("External Document No.", DocNo);
            if CLERec.FindFirst() then begin
                Error('PO ' + DocNo + ' exists in Cust Ledger Entry.');
            end;
        end;        //DX    23 May 2023

    end;

    [TryFunction]
    local procedure CustCodeIsValid(ChainID: Code[10]; StoreID: Code[20]; var ItemCustRefCode: Code[20])
    var
        CustRec: Record Customer;
        ChainLocMapping: Record "Cust. Chain Location Mapping";
    begin
        if StrLen(ChainID) = 0 then
            Error('No Chain ID');

        if StrLen(StoreID) = 0 then
            Error('No Store ID');

        ChainLocMapping.Reset();
        ChainLocMapping.SetRange("Chain Code", ChainID);
        ChainLocMapping.SetRange("Chain Location Code", StoreID);
        if ChainLocMapping.FindFirst() then begin
            CustRec.reset;
            CustRec.SetRange("No.", ChainLocMapping."Customer No.");
            if not (CustRec.FindFirst()) then
                Error('No such sell-to customer record.');

            CustRec.reset;
            CustRec.SetRange("No.", ChainLocMapping."Customer No.");
            if not (CustRec.FindFirst()) then
                Error('No such item reference mapping customer record.')
            else
                ItemCustRefCode := ChainLocMapping."Item Ref Customer No.";
        end
        else begin
            Error('No Customer Chain Mapping record');
        end;
    end;

    [TryFunction]
    procedure CheckItemDetails(StagingPOLine: Record "Chain PO Line"; ItemRefCustCode: Code[20])
    var
        ItemUOM: Record "Item Unit of Measure";
        MissingUOM: Code[20];
        ItemRec: Record item;
        ItemReferenceRec: Record "Item Reference";
        ItemNo: Code[20];
        ItemUOMCode: Code[20];
    begin
        if StrLen(ItemRefCustCode) = 0 then
            Error('No Item Reference Customer Code');

        ItemReferenceRec.Reset;
        ItemReferenceRec.SetRange("Reference Type", ItemReferenceRec."Reference Type"::Customer);
        ItemReferenceRec.SetRange("Reference Type No.", ItemRefCustCode);
        ItemReferenceRec.SetRange("Reference No.", StagingPOLine."Buyer Item Code");
        if ItemReferenceRec.FindFirst() then begin
            ItemNo := ItemReferenceRec."Item No.";
            ItemUOMCode := ItemReferenceRec."Unit of Measure";
        end
        else
            Error('Item Reference record not found.');

        ItemRec.reset;
        ItemRec.SetRange("No.", ItemNo);
        if not (ItemRec.FindFirst()) then
            Error(StrSubstNo('Missing Item Code: %1', ItemNo));

        ItemUOM.reset;
        ItemUOM.SetRange("Item No.", ItemNo);
        ItemUOM.SetRange(Code, ItemUOMCode);
        if Not (ItemUOM.FindFirst()) then
            Error(StrSubstNo('Missing UOM For Item : %1 %2', ItemNo, ItemUOMCode));

    end;

    // YF 27 Sep 2021


    //DX        23 May 2023
    local procedure isNTUC(PONo: Code[100]): Boolean
    var
        myInt: Integer;
        StageHdr: Record "Chain PO Header";
    begin
        StageHdr.Reset();
        StageHdr.SetLoadFields("Entry No.", "PO Number", Chain);
        StageHdr.SetRange("PO Number", PONo);
        if StageHdr.FindFirst() then begin
            if StageHdr.Chain = 'NTUC' then
                if StageHdr.Chain = 'NTUC' then
                    exit(true)
                else
                    exit(false);
        end;
    end;
    //DX        23 May 2023
    local procedure isNTUCByPOStageEntryNo(EntryNO: Integer): Boolean
    var
        myInt: Integer;
        StageHdr: Record "Chain PO Header";
    begin
        StageHdr.Reset();
        StageHdr.SetLoadFields("Entry No.", Chain);
        StageHdr.SetRange("Entry No.", EntryNO);
        if StageHdr.FindFirst() then begin
            if (StageHdr.Chain = 'NTUC') or (StageHdr.Chain = '') then //RL 21 June 2023 - added blank chain
                exit(true)
            else
                exit(false);
        end;
        exit(false);

    end;
    //DX        23 May 2023
    //DX        23 May 2023

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        if IsChanged = false then begin
            IsChanged := (SalesInvoiceHeader."Apply Chain Conversion" <> xSalesInvoiceHeader."Apply Chain Conversion");

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnOnRunOnBeforeTestFieldNo', '', false, false)]
    local procedure OnOnRunOnBeforeTestFieldNo(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Apply Chain Conversion" := SalesInvoiceHeaderRec."Apply Chain Conversion";
    end;


    procedure UpdatePosted(var SINVRe: Record "Sales Invoice Header"; SetBool: Boolean)
    var
        myInt: Integer;
    begin
        SINVRe.Exported := SetBool;
        SINVRe.Modify(false);
    end;

    var
        NoOfOrders: Integer;
        NoOfLines: Integer;
}
