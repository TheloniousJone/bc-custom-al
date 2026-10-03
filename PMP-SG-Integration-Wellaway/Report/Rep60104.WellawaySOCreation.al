report 60104 "Wellaway SO Creation"
{

    Caption = 'Wellaway SO Creation';
    ProcessingOnly = true;

    dataset
    {
        dataitem(StagingPOHeader; "Incoming Wellaway PO Header")
        {
            trigger OnPreDataItem()
            begin
                StagingPOHeader.SetRange("SO Created", false);
                StagingPOHeader.SetFilter(SystemCreatedAt, '..%1', CurrentDateTime - 60000);
                // Error('%1', GetFilter(StagingPOHeader.SystemCreatedAt));
            end;

            trigger OnAfterGetRecord()
            var
                StagingPOLine: Record "Incoming Wellaway PO Line";
                SalesHeader: Record "Sales Header";
                SalesLine: Record "Sales Line";
                CanCreateSO: Boolean;
                LineNo: Integer;
                EnhanceCU: Codeunit "PMP-Enhancements";
                ItemRec: Record Item;
                TradeCU: Codeunit "Trade Agreement CU";
                PatientRec: Record Patient;
                NewPatientRec: Record Patient;
                PatientNo: Code[20];
                PatientName: Text[250];
                WellCU: Codeunit "Wellaway CU";

            begin
                /*
                                ClearLastError();
                                WellCU.TrySOCLEDocExist(StagingPOHeader."Purchase Order ID");
                                WellCU.ValidatePOInfo(StagingPOHeader."Purchase Order ID");
                                if GetLastErrorText() = '' then begin
                                    WellCU.CreateDocuments(StagingPOHeader."Purchase Order ID");
                                end;
                */
                ClearLastError();
                WellCU.ValidatePOInfo(StagingPOHeader."Purchase Order ID");
                if GetLastErrorText() = '' then begin
                    WellCU.CreateDocuments(StagingPOHeader."Purchase Order ID");
                end;

                /*
                                // Handle Patient Record
                                PatientRec.Reset;
                                PatientRec.SetRange(NRIC, StagingPOHeader."Patient NRIC/FIN/Passport No.");
                                if PatientRec.FindFirst() then begin
                                    PatientNo := PatientRec."No.";
                                    PatientName := PatientRec.Name;
                                end
                                else begin
                                    NewPatientRec.Init();
                                    NewPatientRec.Name := StagingPOHeader."Customer Name";
                                    NewPatientRec."Address 1" := StagingPOHeader."Street Name";
                                    NewPatientRec."Address 2" := StagingPOHeader."Country/Region" + ' ' + StagingPOHeader."Zip Code";
                                    NewPatientRec.NRIC := StagingPOHeader."Patient NRIC/FIN/Passport No.";
                                    NewPatientRec.DOB := StagingPOHeader."Patient Date of Birth";
                                    NewPatientRec."Mobile No." := StagingPOHeader.Telephone;
                                    NewPatientRec."Drug Allergy" := StagingPOHeader."Drug Allergies ";
                                    NewPatientRec.Insert(true);

                                    PatientNo := NewPatientRec."No.";
                                    PatientName := NewPatientRec.Name;
                                end;

                                CanCreateSO := false;

                                // Look for Staging PO Lines
                                StagingPOLine.Reset();
                                StagingPOLine.SetRange("Purchase Order ID", StagingPOHeader."Purchase Order ID");
                                StagingPOLine.SetRange("SO Created", false);
                                if StagingPOLine.FindFirst() then
                                    CanCreateSO := true;

                                if CanCreateSO then begin

                                    // Create Header
                                    SalesHeader.Init();
                                    SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
                                    SalesHeader.Validate("External Document No.", StagingPOHeader."Purchase Order ID");
                                    SalesHeader.Validate("Document Date", StagingPOHeader."Transaction Date");
                                    SalesHeader.Validate("Order Date", StagingPOHeader."Order Date ");
                                    SalesHeader.Validate("Sell-to Customer No.", StagingPOHeader."Clinic ID");
                                    if StagingPOHeader."Currency " <> 'SGD' then
                                        SalesHeader."Currency Code" := StagingPOHeader."Currency ";

                                    SalesHeader.Validate("Payment Terms Code", StagingPOHeader."Terms of Payment ");
                                    SalesHeader.Validate("Invoice Discount Amount", StagingPOHeader."Online Discount Amount");

                                    SalesHeader."Customer Instructions" := StagingPOHeader."Remarks 1 ";
                                    SalesHeader.Validate("Ship-to Code", '');
                                    SalesHeader.Validate("Ship-to Name", StagingPOHeader."Customer Name");
                                    SalesHeader."Ship-to Address" := StagingPOHeader."Street Name";
                                    SalesHeader."Ship-to Address 2" := '';
                                    SalesHeader."Ship-to Post Code" := StagingPOHeader."Zip Code";
                                    SalesHeader."Ship-to County" := '';
                                    SalesHeader."Ship-to Contact" := StagingPOHeader.Telephone;
                                    SalesHeader."Ship-to Country/Region Code" := StagingPOHeader."Country/Region";

                                    SalesHeader."Patient No." := PatientNo;
                                    SalesHeader."Patient Name" := PatientName;

                                    SalesHeader."PO Integration Source" := 'WELLAWAY';
                                    SalesHeader."PO Integration Source Ref No." := StagingPOHeader."Purchase Order ID";

                                    if SalesHeader.Insert(true) then // must be true to trigger auto number
                                        begin

                                        Commit();

                                        // Update Staging PO Header Status
                                        StagingPOHeader."Sales Order No." := SalesHeader."No.";
                                        StagingPOHeader."SO Created" := true;
                                        StagingPOHeader."SO Error " := false;
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
                                                SalesLine.Validate("No.", StagingPOLine."Product Code");
                                                SalesLine.Validate("Unit Price", StagingPOLine."Unit Price");
                                                SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                                SalesLine.Validate("Order Qty", StagingPOLine."Quantity Ordered");
                                                SalesLine.Validate("FOC Qty", StagingPOLine."Bonus Quantity ");
                                                SalesLine.Validate("Unit of Measure Code", StagingPOLine."UOM Code");
                                                SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");

                                                if SalesLine.Insert(true) then begin

                                                    // Post Insert Sales Line Customization Logic
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

                                                    if (SalesLine.Type = SalesLine.Type::Item) and
                                                                (SalesLine."No." <> '') and
                                                                (SalesLine."Order Qty" <> 0) then begin

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

                                                    // YF 25 Aug 2021 // Use Presc. to populate from import. If blank then use item card version
                                                    if ItemRec.Get(SalesLine."No.") then begin
                                                        if StrLen(StagingPOLine."Instruction of Use") > 0 then
                                                            SalesLine."Presc. Desc" := StagingPOLine."Instruction of Use"
                                                        else
                                                            SalesLine."Presc. Desc" := ItemRec."Prescription 1";

                                                        if StrLen(StagingPOLine."Precautions ") > 0 then
                                                            SalesLine."Presc. Desc 2" := StagingPOLine."Precautions "
                                                        else
                                                            SalesLine."Presc. Desc 2" := ItemRec."Prescription 2";
                                                    end
                                                    else begin
                                                        SalesLine."Presc. Desc" := StagingPOLine."Instruction of Use";
                                                        SalesLine."Presc. Desc 2" := StagingPOLine."Precautions ";
                                                    end;
                                                    // YF 25 Aug 2021 // Use Presc. to populate from import. If blank then use item card version

                                                    SalesLine.Modify();

                                                    // End PMP sales line customization logic 

                                                    // Update Staging PO Line Status
                                                    StagingPOLine."Sales Order No." := SalesHeader."No.";
                                                    StagingPOLine."Sales Line No. " := LineNo;
                                                    StagingPOLine."SO Created" := true;
                                                    StagingPOLine."SO Error " := false;
                                                    StagingPOLine.Modify();
                                                end
                                                else begin
                                                    // Update Staging PO Line Status
                                                    StagingPOLine."Sales Order No." := SalesHeader."No.";
                                                    StagingPOLine."Sales Line No. " := LineNo;
                                                    StagingPOLine."SO Created" := false;
                                                    StagingPOLine."SO Error " := true;
                                                    StagingPOLine.Modify();
                                                end;

                                                LineNo += 10000;

                                            until StagingPOLine.Next() = 0;

                                    end
                                    else begin
                                        // Update Staging PO Header Status
                                        StagingPOHeader."Sales Order No." := '';
                                        StagingPOHeader."SO Created" := false;
                                        StagingPOHeader."SO Error " := true;
                                        StagingPOHeader.Modify();
                                    end;

                                end;
                */
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
