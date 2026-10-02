codeunit 52100 "DKSH Integrations"
{

    // Permissions = TableData "Reservation Entry" = rimd;

    procedure IsDKSHVendor(VendCode: Code[20]): Boolean
    var
        DKSHSetup: Record "DKSH Integration Setup";
    begin
        if DKSHSetup.Get then begin
            if VendCode = DKSHSetup."BC Vendor Code" then
                exit(true);
        end;

        exit(false);
    end;

    // Check Item Expiry Dates (less than 1 year)
    procedure HasItemExpiryDateBelowOneYear(PONum: Text; isReturn: Boolean): Boolean
    var
        ReservationEntryRec: Record "Reservation Entry";
    begin
        ReservationEntryRec.Reset();
        ReservationEntryRec.SetRange("Source Type", 39); // Purchase line table
        ReservationEntryRec.SetRange("Source ID", PONum);
        if isReturn then
            ReservationEntryRec.SetRange("Source Subtype", ReservationEntryRec."Source Subtype"::"5") // return order
        else
            ReservationEntryRec.SetRange("Source Subtype", ReservationEntryRec."Source Subtype"::"1"); // order
        ReservationEntryRec.SetFilter("Expiration Date", '<>%1', 0D);

        if ReservationEntryRec.FindSet() then
            repeat
                // check dates
                if (ReservationEntryRec."Expiration Date" - WorkDate()) < 365 then
                    exit(true);
            until ReservationEntryRec.Next() = 0;

        exit(false);
    end;

    // Check for existing staging records
    procedure DoesPOStagingRecordExists(PONum: Text; isReturn: Boolean; isProcessed: Boolean): Boolean
    var
        OutgoingPOStagingHeaderRec: Record "DKSH Staging Purch. Order Hdr.";
    begin
        OutgoingPOStagingHeaderRec.Reset;
        OutgoingPOStagingHeaderRec.SetRange("Source PO No.", PONum);

        if isReturn then
            OutgoingPOStagingHeaderRec.SetRange(entityType, 'RETURN')
        else
            OutgoingPOStagingHeaderRec.SetRange(entityType, 'ORDER');

        OutgoingPOStagingHeaderRec.SetRange(Closed, isProcessed);

        if OutgoingPOStagingHeaderRec.Count > 0 then
            exit(true);

        exit(false);
    end;

    // Insert Or Update Unprocessed Staging Records
    procedure InsertOrUpdateOutgoingPOStagingRecords(PONum: Text; isReturn: Boolean)
    var
        POHeader: Record "Purchase Header";
        POLines: Record "Purchase Line";
        DKSHSetupRec: Record "DKSH Integration Setup";
        POStagingHeaderRec: Record "DKSH Staging Purch. Order Hdr.";
        POStagingLineRec: Record "DKSH Staging Purch. Order Line";
        CompInfo: Record "Company Information";
        VendorRec: Record Vendor;
        LineNo: Integer;
        GLSetup: Record "General Ledger Setup";
        LineDiscPerUnitItem: Decimal;
        PrincipalCodeNoSpaces: Code[50]; // YF 06 Oct 2022
    begin
        // YF 06 Oct 2022
        PrincipalCodeNoSpaces := '';

        // Check for Principle EDI
        if not PrincipalHasEDI(PONum, isReturn, PrincipalCodeNoSpaces) then begin
            Message('EDI not enabled for principal - ' + PrincipalCodeNoSpaces + ' for PO - ' + PONum);
            exit;
        end;

        // Remove spaces for Principal Code for API
        PrincipalCodeNoSpaces := DelChr(PrincipalCodeNoSpaces, '=', ' ');
        // YF 06 Oct 2022

        if Not DoesPOStagingRecordExists(PONum, isReturn, true) then begin

            // check existing unprocessed
            if DoesPOStagingRecordExists(PONum, isReturn, false) then begin
                DeleteOutgoingPOStagingRecords(PONum, isReturn); // reset to reinsert
                Commit();
            end;

            CompInfo.Get;
            GLSetup.Get;
            DKSHSetupRec.Get;

            // insert records
            POHeader.Reset;
            POHeader.SetRange("No.", PONum);

            if isReturn then
                POHeader.SetRange("Document Type", POHeader."Document Type"::"Return Order")
            else
                POHeader.SetRange("Document Type", POHeader."Document Type"::Order);

            if POHeader.FindFirst() then begin

                VendorRec.Get(POHeader."Buy-from Vendor No.");

                POStagingHeaderRec.Init();
                POStagingHeaderRec."Entry No." := 0;
                POStagingHeaderRec.documentStatus := DKSHSetupRec."PO Document Status";
                POStagingHeaderRec.creationDateOriginal := POHeader."Order Date";
                POStagingHeaderRec.creationDate := Format(POHeader."Order Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00';
                POStagingHeaderRec.TypeOfOrder := DKSHSetupRec."PO Type of Order";
                POStagingHeaderRec.version := DKSHSetupRec."PO Specs Version";
                POStagingHeaderRec.voidDateOriginal := 0D;
                POStagingHeaderRec.voidDate := '';

                if POHeader."Expected Receipt Date" = 0D then
                    POStagingHeaderRec.movementDateOriginal := POHeader."Order Date"
                else
                    POStagingHeaderRec.movementDateOriginal := POHeader."Expected Receipt Date";

                POStagingHeaderRec.movementDate := Format(POStagingHeaderRec.movementDateOriginal, 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00';
                ;
                POStagingHeaderRec.movementDateType := DKSHSetupRec."PO Movement Data Type";
                POStagingHeaderRec.entityType := DKSHSetupRec."PO Entity Type";
                POStagingHeaderRec.uniqueCreatorIdentification := POHeader."No.";
                POStagingHeaderRec.owner_gln := ''; // DKSH GST Reg No. (Supplier)(Buyer is PMP)
                POStagingHeaderRec.buyer_gln := CompInfo."VAT Registration No.";
                POStagingHeaderRec.buyer_alternatePartyId := DKSHSetupRec."DKSH Buyer Code";
                POStagingHeaderRec.buyer_alternatePartyId_type := DKSHSetupRec."PO Seller Alt. Party ID"; // use seller temp since same as buyer alt id. to add new setup as required in future
                POStagingHeaderRec.buyer_partyRole := DKSHSetupRec."PO Role of Buyer";
                POStagingHeaderRec.buyer_city := CompInfo.City;
                POStagingHeaderRec.buyer_countryISOCode := CompInfo."Country/Region Code"; // SG
                POStagingHeaderRec.buyer_languageOfTheParty := 'en';
                POStagingHeaderRec.buyer_name := CompInfo.Name;
                POStagingHeaderRec.buyer_postalCode := CompInfo."Post Code";
                POStagingHeaderRec.buyer_state := CompInfo.County;
                POStagingHeaderRec.buyer_streetAddressOne := CompInfo.Address;
                POStagingHeaderRec.buyer_streetAddressTwo := CompInfo."Address 2";
                POStagingHeaderRec.buyer_streetAddressThree := '';
                POStagingHeaderRec.buyer_streetAddressFour := '';
                // POStagingHeaderRec.seller_alternatePartyId := DKSHSetupRec."BC Vendor Code";
                // POStagingHeaderRec.seller_alternatePartyId := DKSHSetupRec."DKSH Buyer Given Supplier Code"; // YF 06 Oct 2022
                POStagingHeaderRec.seller_alternatePartyId := PrincipalCodeNoSpaces; // YF 06 Oct 2022
                POStagingHeaderRec.seller_alternatePartyId_type := DKSHSetupRec."PO Seller Alt. Party ID";
                POStagingHeaderRec.seller_partyRole := DKSHSetupRec."PO Role of Seller";
                POStagingHeaderRec.seller_commChannelCode := 'EMAIL';
                POStagingHeaderRec.seller_commNumber := VendorRec."E-Mail";
                POStagingHeaderRec.seller_lanuage := 'en';
                POStagingHeaderRec.seller_text := VendorRec.Contact;
                POStagingHeaderRec.seller_city := VendorRec.City;
                POStagingHeaderRec.seller_countryISOCode := VendorRec."Country/Region Code";
                POStagingHeaderRec.seller_languageOfTheParty := 'en';
                POStagingHeaderRec.seller_name := VendorRec.Name;
                POStagingHeaderRec.seller_postalCode := VendorRec."Post Code";
                POStagingHeaderRec.seller_state := VendorRec.County;
                POStagingHeaderRec.seller_streetAddressOne := VendorRec.Address;
                POStagingHeaderRec.seller_streetAddressTwo := VendorRec."Address 2";
                POStagingHeaderRec.seller_streetAddressThree := '';
                POStagingHeaderRec.seller_streetAddressFour := '';
                POStagingHeaderRec.ship_identificationType := DKSHSetupRec."PO Delivery Party ID Type";
                POStagingHeaderRec.ship_alternatePartyId := DKSHSetupRec."PO Deliver to Location ID";
                POStagingHeaderRec.ship_alternatePartyId_type := DKSHSetupRec."PO Delivery Alt. Party ID";
                POStagingHeaderRec.ship_partyRole := DKSHSetupRec."PO Role of Delivery";
                POStagingHeaderRec.ship_city := POHeader."Ship-to City";
                POStagingHeaderRec.ship_countryISOCode := POHeader."Ship-to Country/Region Code";
                POStagingHeaderRec.ship_languageOfTheParty := 'en';
                POStagingHeaderRec.ship_name := POHeader."Ship-to Name";
                POStagingHeaderRec.ship_postalCode := POHeader."Ship-to Post Code";
                POStagingHeaderRec.ship_state := POHeader."Ship-to County";
                POStagingHeaderRec.ship_streetAddressOne := POHeader."Ship-to Address";
                POStagingHeaderRec.ship_streetAddressTwo := POHeader."Ship-to Address 2";
                POStagingHeaderRec.ship_streetAddressThree := '';
                POStagingHeaderRec.ship_streetAddressFour := '';

                POLines.Reset;
                POLines.SetRange("Document Type", POHeader."Document Type");
                POLines.SetRange("Document No.", POHeader."No.");
                POLines.SetRange(Type, POLines.Type::Item);
                POLines.SetFilter("No.", '<>%1', '');
                POStagingHeaderRec."Total Line Item Count" := POLines.Count;

                POStagingHeaderRec.Remarks := POHeader."Internal Remarks";
                POStagingHeaderRec."Source PO No." := POHeader."No.";

                POStagingHeaderRec."Date Created" := CurrentDateTime;
                POStagingHeaderRec."Is Rejected" := false;
                POStagingHeaderRec."Has Error" := false;
                POStagingHeaderRec.Closed := false;
                POStagingHeaderRec."Process Remarks" := '';

                if POStagingHeaderRec.Insert() then begin

                    LineNo := 0;

                    POLines.Reset;
                    POLines.SetRange("Document Type", POHeader."Document Type");
                    POLines.SetRange("Document No.", POHeader."No.");
                    POLines.SetRange(Type, POLines.Type::Item);
                    POLines.SetFilter("No.", '<>%1', '');

                    if POLines.FindSet() then
                        repeat
                            LineNo += 1;

                            POStagingLineRec.Init();
                            POStagingLineRec."Parent Entry No." := POStagingHeaderRec."Entry No.";
                            POStagingLineRec."Line No." := LineNo;
                            POStagingLineRec."Sequence No." := Format(LineNo);
                            POStagingLineRec.lineItem_number := LineNo;
                            POStagingLineRec.price_amount := POLines."Purchase Price";

                            if POLines."Currency Code" <> '' then
                                POStagingLineRec.price_currencyISOcode := POLines."Currency Code"
                            else
                                POStagingLineRec.price_currencyISOcode := GLSetup."LCY Code";

                            if POLines."Order Qty" > 0 then
                                LineDiscPerUnitItem := POLines."Line Discount Amount" / POLines."Order Qty"
                            else
                                LineDiscPerUnitItem := 0;

                            POStagingLineRec.netPrice_amount := POLines."Purchase Price" - LineDiscPerUnitItem;
                            POStagingLineRec.netPrice_currencyISOcode := POStagingLineRec.price_currencyISOcode;
                            POStagingLineRec.requestedQuantity := POLines."Order Qty";
                            POStagingLineRec.allowanceChargeType := DKSHSetupRec."PO Allowance Level Type";
                            POStagingLineRec.allowanceOrChargeType := DKSHSetupRec."PO Allow Or Charge";
                            POStagingLineRec.settlementType := DKSHSetupRec."PO Allowance Settle Type";
                            POStagingLineRec.monetary_amount := POLines."Line Discount Amount";
                            POStagingLineRec.monetary_currencyISOcode := POStagingLineRec.price_currencyISOcode;
                            POStagingLineRec.monetary_percentage := POLines."Line Discount %";
                            POStagingLineRec.buyer_alternateItemId := '';
                            POStagingLineRec.buyer_additionalItemId := POLines."No.";
                            POStagingLineRec.buyer_additionalItemId_type := DKSHSetupRec."PO Buyer Item Identifier";
                            POStagingLineRec.supplier_additionalItemId := '';
                            POStagingLineRec.supplier_additionalItemId_type := DKSHSetupRec."PO Seller Item Identifier";
                            POStagingLineRec.item_brandName := '';
                            POStagingLineRec.item_desc_language := 'en';
                            POStagingLineRec.item_desc_text := POLines.Description;
                            POStagingLineRec.item_packagingTypeCode := POLines."Unit of Measure Code";
                            POStagingLineRec.item_quantityOfNextLevel := 1;
                            POStagingLineRec.item_amount := POLines."Line Amount";
                            POStagingLineRec.item_currencyISOcode := POStagingLineRec.price_currencyISOcode;
                            POStagingLineRec.item_freeQuantity := POLines."FOC Qty";
                            POStagingLineRec.ship_alternatePartyId := 'WH'; // WH/ST Warehouse/Store
                            POStagingLineRec.ship_alternatePartyId_type := DKSHSetupRec."PO Location Type Attribute";
                            POStagingLineRec.ship_additionalPartyId := DKSHSetupRec."PO Deliver to Location ID";
                            POStagingLineRec.ship_additionalPartyId_type := DKSHSetupRec."PO Location ID Attribute";
                            POStagingLineRec.ship_partyEndDateOriginal := POStagingHeaderRec.movementDateOriginal;
                            POStagingLineRec.ship_partyEndDate := POStagingHeaderRec.movementDate;
                            POStagingLineRec.ship_partyStartDateOriginal := POStagingHeaderRec.movementDateOriginal;
                            POStagingLineRec.ship_partyStartDate := POStagingHeaderRec.movementDate;
                            POStagingLineRec.ship_partyRole := DKSHSetupRec."PO Role of PO Line Delivery";
                            POStagingLineRec.ship_city := POHeader."Ship-to City";
                            POStagingLineRec.ship_countryISOCode := POHeader."Ship-to Country/Region Code";
                            POStagingLineRec.ship_languageOfTheParty := 'en';
                            POStagingLineRec.ship_name := POHeader."Ship-to Name";
                            POStagingLineRec.ship_postalCode := POHeader."Ship-to Post Code";
                            POStagingLineRec.ship_state := POHeader."Ship-to County";
                            POStagingLineRec.ship_streetAddressOne := POHeader."Ship-to Address";
                            POStagingLineRec.ship_streetAddressTwo := POHeader."Ship-to Address 2";
                            POStagingLineRec.ship_streetAddressThree := '';
                            POStagingLineRec.ship_streetAddressFour := '';
                            POStagingLineRec.ship_deliveryQuantity := POLines."Order Qty";
                            POStagingLineRec.ship_freeQuantity := POLines."FOC Qty";

                            POStagingLineRec."Date Created" := CurrentDateTime;
                            POStagingLineRec."Is Rejected" := false;
                            POStagingLineRec."Has Error" := false;
                            POStagingLineRec.Closed := false;
                            POStagingLineRec."Process Remarks" := '';
                            POStagingLineRec."Source PO No." := POLines."Document No.";
                            POStagingLineRec."Source PO Line No." := POLines."Line No.";

                            POStagingLineRec.Insert();

                        until POLines.Next() = 0;
                end;

            end;
        end;
    end;

    // Remove Unprocessed Staging Records
    procedure DeleteOutgoingPOStagingRecords(PONum: Text; isReturn: Boolean)
    var
        OutgoingPOStagingHeaderRec: Record "DKSH Staging Purch. Order Hdr.";
        OutgoingPOStagingLineRec: Record "DKSH Staging Purch. Order Line";
    begin
        if DoesPOStagingRecordExists(PONum, isReturn, false) then begin
            // Delete Lines
            OutgoingPOStagingLineRec.Reset;
            OutgoingPOStagingLineRec.SetRange("Source PO No.", PONum);

            /*
            if isReturn then
                OutgoingPOStagingLineRec.SetRange("Document Type Code", 'RETURN')
            else
                OutgoingPOStagingLineRec.SetRange("Document Type Code", 'ORDER');
            */

            OutgoingPOStagingLineRec.SetRange(Closed, false);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            if not OutgoingPOStagingLineRec.IsEmpty then
                OutgoingPOStagingLineRec.DeleteAll();
            // YF 10 Aug 2022 // To avoid unnecessary table lock

            // Delete Header               
            OutgoingPOStagingHeaderRec.Reset;
            OutgoingPOStagingHeaderRec.SetRange("Source PO No.", PONum);

            /*
            if isReturn then
                OutgoingPOStagingHeaderRec.SetRange(entityType, 'RETURN')
            else
                OutgoingPOStagingHeaderRec.SetRange(entityType, 'ORDER');
            */

            OutgoingPOStagingHeaderRec.SetRange(Closed, false);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            if not OutgoingPOStagingHeaderRec.IsEmpty then
                OutgoingPOStagingHeaderRec.DeleteAll();
            // YF 10 Aug 2022 // To avoid unnecessary table lock
        end;
        /*
        else
            Message('Unable to delete PO EDI record for ' + PONum + '. Does not exist or is processed');
        */
    end;

    procedure UpdatePOLinesFromDKSH(var EntryNo: Integer)
    var
        IncomingStagingHdr: Record "DKSH Staging Purch. Rcpt. Hdr.";
        IncomingStagingLine: Record "DKSH Staging Purch. Rcpt. Line";
        POLines: Record "Purchase Line";
        ReservationEntryRec: Record "Reservation Entry";
        ItemExpiryDate: Date;
        ProcessingLineCounter: Integer;
        ProcessedLineCounter: Integer;
    begin
        ProcessedLineCounter := 0;
        ProcessingLineCounter := 0;

        if IncomingStagingHdr.Get(EntryNo) then begin
            IncomingStagingLine.Reset;
            IncomingStagingLine.SetRange("Parent Entry No.");
            IncomingStagingLine.SetRange(Closed, false); // YF 03 Jan 2023
            if IncomingStagingLine.FindSet() then
                repeat
                    // assuming each item has 1 line only. If not user issue. Richmond say one
                    // Find PO Line to update
                    POLines.Reset;
                    POLines.SetRange("Document Type", POLines."Document Type"::Order);
                    POLines.SetRange("Document No.", IncomingStagingHdr.or_referenceIdentification);
                    POLines.SetRange("No.", IncomingStagingLine.buyer_alternateItemId_value);

                    if POLines.FindFirst() then begin

                        // Update Import Price for PO Line
                        if IncomingStagingLine.item_netp_amount > 0 then // YF 19 Aug 2022
                            POLines."Imported Invoiced Price" := IncomingStagingLine.item_netp_amount;

                        // Clear and Create Reservation Entries for PO Lines
                        ReservationEntryRec.Reset;
                        ReservationEntryRec.Init();
                        ReservationEntryRec."Entry No." := 0;
                        ReservationEntryRec.Validate("Source Type", 39);
                        ReservationEntryRec.Validate("Source Subtype", 1);
                        ReservationEntryRec.Validate("Source ID", POLines."Document No.");
                        ReservationEntryRec.Validate("Source Ref. No.", POLines."Line No.");
                        ReservationEntryRec.Validate("Item No.", POLines."No.");
                        ReservationEntryRec.Validate("Location Code", POLines."Location Code");
                        ReservationEntryRec.Validate("Reservation Status", ReservationEntryRec."Reservation Status"::Surplus);
                        ReservationEntryRec.Validate("Item Tracking", ReservationEntryRec."Item Tracking"::"Lot No.");
                        ReservationEntryRec.Validate("Lot No.", IncomingStagingLine.item_batchNumber);

                        if StrLen(IncomingStagingLine.item_expiry_referenceDateOnly) > 0 then begin
                            if not Evaluate(ItemExpiryDate, IncomingStagingLine.item_expiry_referenceDateOnly) then
                                ItemExpiryDate := 0D;
                        end
                        else
                            ItemExpiryDate := 0D;

                        ReservationEntryRec.Validate("Expiration Date", ItemExpiryDate);
                        ReservationEntryRec.Validate("Creation Date", Today);
                        ReservationEntryRec.Validate("Expected Receipt Date", POLines."Expected Receipt Date");
                        ReservationEntryRec.Validate("Created By", UserId);
                        ReservationEntryRec.Validate(Positive, true);
                        ReservationEntryRec.Validate("Qty. per Unit of Measure", IncomingStagingLine.item_quantityOfNextLevel);
                        ReservationEntryRec.Validate(Quantity, IncomingStagingLine.item_invoicedQuantity + IncomingStagingLine.item_focQuantity);
                        ReservationEntryRec.Validate("Quantity (Base)", IncomingStagingLine.item_invoicedQuantity + IncomingStagingLine.item_focQuantity);
                        ReservationEntryRec.Validate("Qty. to Handle (Base)", IncomingStagingLine.item_invoicedQuantity + IncomingStagingLine.item_focQuantity);
                        ReservationEntryRec.Validate("Qty. to Invoice (Base)", IncomingStagingLine.item_invoicedQuantity + IncomingStagingLine.item_focQuantity);

                        if ReservationEntryRec.Insert(true) then begin
                            IncomingStagingLine."PO No. Updated" := POLines."Document No.";
                            IncomingStagingLine."PO Line No. Updated" := POLines."Line No.";
                            IncomingStagingLine.Closed := true;
                            IncomingStagingLine."Has Error" := false;
                            IncomingStagingLine."Process Remarks" := '';
                            IncomingStagingLine.Modify();
                        end
                        else begin
                            IncomingStagingLine."PO No. Updated" := POLines."Document No.";
                            IncomingStagingLine."PO Line No. Updated" := POLines."Line No.";
                            IncomingStagingLine.Closed := false;
                            IncomingStagingLine."Has Error" := true;
                            IncomingStagingLine."Process Remarks" := 'Error inserting reservation entry';
                            IncomingStagingLine.Modify();
                        end;

                        if POLines.Modify() then
                            ProcessingLineCounter += 1;
                    end;


                until IncomingStagingLine.Next() = 0;

            // Update Incoming Staging header on status

            // YF 19 Aug 2022
            IncomingStagingLine.Reset;
            IncomingStagingLine.SetRange("Parent Entry No.", EntryNo);
            IncomingStagingLine.SetRange("Has Error", true);
            if IncomingStagingLine.FindFirst() then begin
                IncomingStagingHdr.Closed := false;
                IncomingStagingHdr."Has Error" := true;
                IncomingStagingHdr."Process Remarks" := 'Error in Line(s)';
                IncomingStagingHdr."Date Modified" := CurrentDateTime;
                IncomingStagingHdr."PO No. Updated" := IncomingStagingHdr.or_referenceIdentification;
                IncomingStagingHdr.Modify();
            end
            else begin
                IncomingStagingHdr.Closed := true;
                IncomingStagingHdr."Has Error" := false;
                IncomingStagingHdr."Process Remarks" := '';
                IncomingStagingHdr."Date Modified" := CurrentDateTime;
                IncomingStagingHdr."PO No. Updated" := IncomingStagingHdr.or_referenceIdentification;
                IncomingStagingHdr.Modify();
            end;

            /*
            IncomingStagingLine.Reset;
            IncomingStagingLine.SetRange("Parent Entry No.");
            // IncomingStagingLine.SetRange("Has Error", false);
            // IncomingStagingLine.SetRange(Closed, true);
            ProcessedLineCounter := IncomingStagingLine.Count;

            if ProcessedLineCounter = ProcessingLineCounter then begin
                IncomingStagingHdr.Closed := true;
                IncomingStagingHdr."Has Error" := false;
                IncomingStagingHdr."Process Remarks" := '';
                IncomingStagingHdr."Date Modified" := CurrentDateTime;
                IncomingStagingHdr."PO No. Updated" := IncomingStagingHdr.or_referenceIdentification;
                IncomingStagingHdr.Modify();
            end
            else begin
                IncomingStagingHdr.Closed := false;
                IncomingStagingHdr."Has Error" := true;
                IncomingStagingHdr."Process Remarks" := 'No. of Lines updated does not tally';
                IncomingStagingHdr."Date Modified" := CurrentDateTime;
                IncomingStagingHdr."PO No. Updated" := IncomingStagingHdr.or_referenceIdentification;
                IncomingStagingHdr.Modify();
            end;
            */
            // YF 19 Aug 2022
        end;
    end;

    // YF 06 Oct 2022
    procedure PrincipalHasEDI(PONum: Text; isReturn: Boolean; var PrincipalCode: Code[50]): Boolean
    var
        PurchHdrRec: Record "Purchase Header";
        PurchLineRec: Record "Purchase Line";
        PrincipalRec: Record Principal;
    begin
        PurchHdrRec.Reset;
        PurchHdrRec.SetRange("No.", PONum);

        if isReturn then
            PurchHdrRec.SetRange("Document Type", PurchHdrRec."Document Type"::"Return Order")
        else
            PurchHdrRec.SetRange("Document Type", PurchHdrRec."Document Type"::Order);

        if PurchHdrRec.FindFirst() then begin
            PurchLineRec.Reset;
            PurchLineRec.SetRange("Document Type", PurchHdrRec."Document Type");
            PurchLineRec.SetRange("Document No.", PurchHdrRec."No.");
            PurchLineRec.SetRange(Type, PurchLineRec.Type::Item);
            PurchLineRec.SetFilter("No.", '<>%1', '');
            PurchLineRec.SetFilter(Principal, '<>%1', '');

            if PurchLineRec.FindFirst then begin
                if PrincipalRec.Get(PurchLineRec.Principal) then begin
                    PrincipalCode := PurchLineRec.Principal;
                    exit(not PrincipalRec."NO EDI");
                end;
            end;
        end;

        exit(false);
    end;
    // YF 06 Oct 2022

    // YF 17 Nov 2022
    procedure SendPOPDFEDIEmail(var EntryNo: Integer)
    var
        StagingPOHdrRec: Record "DKSH Staging Purch. Order Hdr.";
        DKSHPOReport: Report "Purchase Order";
        EmailToList: List of [Text];
        EmailBody: Text;
        EmailMessage: Codeunit "Email Message";
        ToFile: Text;
        EmailInStream: InStream;
        EmailOutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        POHdrRec: Record "Purchase Header";
        DKSHSetup: Record "DKSH Integration Setup";
    begin
        // Get Data for Email
        if not StagingPOHdrRec.Get(EntryNo) then begin
            StagingPOHdrRec."Process Remarks" := 'Cannot find Staging Rec for Email';
            StagingPOHdrRec.Modify(false);
            exit;
        end;

        if not DKSHSetup.Get then begin
            StagingPOHdrRec."Process Remarks" := 'DKSH Integration not setup for PO EDI Email';
            StagingPOHdrRec.Modify(false);
            exit;
        end;

        if DKSHSetup."PO EDI Email Address" = '' then begin
            StagingPOHdrRec."Process Remarks" := 'PO EDI Email is empty';
            StagingPOHdrRec.Modify(false);
            exit;
        end;

        POHdrRec.Reset;
        POHdrRec.SetRange("Document Type", POHdrRec."Document Type"::Order);
        POHdrRec.SetRange("No.", StagingPOHdrRec."Source PO No.");
        if not POHdrRec.FindFirst() then begin
            StagingPOHdrRec."Process Remarks" := 'Cannot find PO for Email';
            StagingPOHdrRec.Modify(false);
            exit;
        end;

        Clear(EmailToList);
        Clear(EmailMessage);
        Clear(EmailOutStream);
        Clear(EmailInStream);

        EmailToList.Add(DKSHSetup."PO EDI Email Address");

        EmailBody := 'Purchase Order ' + POHdrRec."No." + ' as attached. This is a system generated email.';
        // EmailMessage.Create(EmailToList, '[TESTING] Purchase Order ' + POHdrRec."No." + ' ', EmailBody, true); Testing for EDI order
        EmailMessage.Create(EmailToList, 'PO for EDI order', EmailBody, true);
        ToFile := STRSUBSTNO('Purchase Order %1.pdf', POHdrRec."No.");

        Clear(DKSHPOReport);
        DKSHPOReport.SetTableView(POHdrRec);

        Clear(TempBlob);
        TempBlob.CreateOutStream(EmailOutStream);
        DKSHPOReport.SaveAs('', ReportFormat::Pdf, EmailOutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment(ToFile, 'pdf', EmailInStream);

        // if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Purchase Order") then begin
        if Email.Send(EmailMessage) then begin
            StagingPOHdrRec."Process Remarks" := '';
            StagingPOHdrRec."PO Emailed" := true;
            StagingPOHdrRec.Modify(false);
        end
        else begin
            Message('Failed to send email for ' + POHdrRec."No.");
            StagingPOHdrRec."Process Remarks" := 'Failed to send email';
            StagingPOHdrRec.Modify(false);
        end;
    end;
    // YF 17 Nov 2022
}