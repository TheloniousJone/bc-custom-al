codeunit 56100 "Zuellig Integrations"
{

    Permissions = TableData "Reservation Entry" = rimd;

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
    procedure DoesPOEDIRecordExists(PONum: Text; isReturn: Boolean; isProcessed: Boolean): Boolean
    var
        OutgoingPOEDIHeaderRec: Record "Outgoing ZP PO Header";
    begin
        OutgoingPOEDIHeaderRec.Reset;
        OutgoingPOEDIHeaderRec.SetRange("No.", PONum);

        if isReturn then
            OutgoingPOEDIHeaderRec.SetRange("Document Type Code", 'R')
        else
            OutgoingPOEDIHeaderRec.SetRange("Document Type Code", '');

        OutgoingPOEDIHeaderRec.SetRange(Processed, isProcessed);

        if OutgoingPOEDIHeaderRec.Count > 0 then
            exit(true);

        exit(false);
    end;

    // Insert Or Update Unprocessed Staging Records
    procedure InsertOrUpdateOutgoingPOEDIRecords(PONum: Text; isReturn: Boolean)
    var
        POHeader: Record "Purchase Header";
        POLines: Record "Purchase Line";
        ZPSGID: Code[20];
        ZPLocationCode: Code[20];
        ZPSetupRec: Record "Zuellig Integration Setup";
        UnitPriceCents: Integer;
        POEDIHeaderRec: Record "Outgoing ZP PO Header";
        POEDILineRec: Record "Outgoing ZP PO Line";
    begin
        if Not DoesPOEDIRecordExists(PONum, isReturn, true) then begin
            // check existin unprocessed
            if DoesPOEDIRecordExists(PONum, isReturn, false) then begin
                DeleteOutgoingPOEDIRecords(PONum, isReturn); // reset to reinsert
                Commit();
            end;

            // insert records
            if ZPSetupRec.Get() then
                if ZPSetupRec."Enable EC-Web Customer ID" then begin
                    ZPSGID := ZPSetupRec."Assigned EC-Web Customer ID";
                    ZPLocationCode := ZPSetupRec."Location/Store Code";
                end;

            POHeader.Reset;
            POHeader.SetRange("No.", PONum);
            if isReturn then
                POHeader.SetRange("Document Type", POHeader."Document Type"::"Return Order")
            else
                POHeader.SetRange("Document Type", POHeader."Document Type"::Order);

            if POHeader.FindSet() then
                repeat
                    // Header Record
                    // 1. Record Type - M - C1 - Header H
                    // 2. Location/Store Code - M - C10 - Customer Code
                    // 3. PO Number - O - C15 - Customer PO Number
                    // 4. Tender No - O - C15 - Harcode as Blank
                    // 5. Contract No - O - C20 -  Hardcode as Blank
                    // 6. Order Date - M - C8 - YYYYMMDD
                    // 7. Delivery Date - M - C8 - YYYYMMDD, if null default to order date
                    // 8. Special Instruction - O - C60 - Hardcode as Blank
                    // 9. Total Line Items - M N5 - Line count of detail record
                    // 10. Sales Order # - O - C12 -  Sales Order Number

                    POEDIHeaderRec.Init();
                    POEDIHeaderRec."No." := COPYSTR(POHeader."No.", 1, 15);
                    if isReturn then
                        POEDIHeaderRec."Document Type Code" := 'R'
                    else
                        POEDIHeaderRec."Document Type Code" := '';
                    POEDIHeaderRec."ZP Customer ID" := ZPSGID;
                    POEDIHeaderRec."Record Type" := 'H';
                    POEDIHeaderRec."Location Store Code" := ZPLocationCode;
                    POEDIHeaderRec."Tender No." := '';
                    POEDIHeaderRec."Contract No." := '';
                    POEDIHeaderRec."Order Date" := FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>');
                    if POHeader."Expected Receipt Date" = 0D then
                        POEDIHeaderRec."Delivery Date" := FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>')
                    else
                        POEDIHeaderRec."Delivery Date" := FORMAT(POHeader."Expected Receipt Date", 0, '<Year4><Month,2><Day,2>');
                    POEDIHeaderRec."Special Instruction" := CopyStr(POHeader."Special Instructions", 1, 60); //RL 14 Jun 2022 - add in special instructions

                    POLines.Reset;
                    POLines.SetRange("Document Type", POHeader."Document Type");
                    POLines.SetRange("Document No.", POHeader."No.");
                    POEDIHeaderRec."Total Line Items" := POLines.Count;

                    POEDIHeaderRec."Sales Order No." := '';
                    POEDIHeaderRec.Processed := false;
                    POEDIHeaderRec."Has Error" := false;
                    POEDIHeaderRec.Insert();

                    POLines.Reset;
                    POLines.SetRange("Document Type", POHeader."Document Type");
                    POLines.SetRange("Document No.", POHeader."No.");
                    if POLines.FindSet() then
                        repeat
                            // Detail Record
                            // 1. Record Type - M - C1 - Detail D
                            // 2. Customer Item Code - M - C20 - Customer Item code 
                            // 3. Customer Item Description - M - C80
                            // 4. Customer Item UOM - M - C10 - UOM
                            // 5. ZP Item Code - O - C20
                            // 6. Commercial Qty - M - N8 - Order Qty no decimal point. Use the conversion qty if exists
                            // 7. Unit Price - M - N10,2 - Unit Price, Implicit 2 decimal ppoint i.e. 514 = 5.14
                            // 8. Bonus Item 1 (Using Customer Item Code) - O - C20
                            // 9. Bonus Item 1 (Using ZP Item Code) - O - C20
                            // 10. Bonus Item 1 Qty - O - N8 - Order Qty no decimal point. Use the conversion qty if exist
                            // 11. Bonus Item 2 (Using Customer Item Code) - O - C20
                            // 12. Bonus Item 2 (Using ZP Item Code) - O - C20
                            // 13. Bonus Item 2 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                            // 14. Bonus Item 3 (Using Customer Item Code) - O - C20
                            // 15. Bonus Item 3 (Using ZP Item Code) - O - C20
                            // 16. Bonus Item 3 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist

                            POEDILineRec.Init();
                            POEDILineRec."Document No." := COPYSTR(POLines."Document No.", 1, 15);
                            POEDILineRec."Document Line No." := POLines."Line No.";
                            if isReturn then
                                POEDILineRec."Document Type Code" := 'R'
                            else
                                POEDILineRec."Document Type Code" := '';
                            POEDILineRec."Record Type" := 'D';
                            POEDILineRec."Customer Item Code" := POLines."No.";
                            POEDILineRec."Customer Item Descr" := COPYSTR(POLines.Description, 1, 80);
                            POEDILineRec."Customer Item UOM" := POLines."Unit of Measure Code";
                            POEDILineRec."ZP Item Code" := '';
                            POEDILineRec."Commercial Qty" := FORMAT(POLines."Order Qty", 0, '<Integer>');
                            UnitPriceCents := ((POLines."Purchase Price" + 0.005) * 100) div 1;
                            POEDILineRec."Unit Price" := FORMAT(UnitPriceCents, 0, '<Integer>');
                            if POLines."FOC Qty" > 0 then begin
                                POEDILineRec."Bonus 1 Cust Item Code" := POLines."No.";
                                POEDILineRec."Bonus 1 ZP Item Code" := '';
                                POEDILineRec."Bonus 1 Qty" := FORMAT(POLines."FOC Qty", 0, '<Integer>');
                            end
                            else begin
                                POEDILineRec."Bonus 1 Cust Item Code" := '';
                                POEDILineRec."Bonus 1 ZP Item Code" := '';
                                POEDILineRec."Bonus 1 Qty" := '';
                            end;
                            POEDILineRec."Bonus 2 Cust Item Code" := '';
                            POEDILineRec."Bonus 2 ZP Item Code" := '';
                            POEDILineRec."Bonus 2 Qty" := '';
                            POEDILineRec."Bonus 3 Cust Item Code" := '';
                            POEDILineRec."Bonus 3 ZP Item Code" := '';
                            POEDILineRec."Bonus 3 Qty" := '';
                            POEDILineRec.Processed := false;
                            POEDILineRec."Has Error" := false;
                            POEDILineRec.Insert();

                        until POLines.Next() = 0;

                until POHeader.Next() = 0;

        end;
    end;

    // Remove Unprocessed Staging Records
    procedure DeleteOutgoingPOEDIRecords(PONum: Text; isReturn: Boolean)
    var
        OutgoingPOEDIHeaderRec: Record "Outgoing ZP PO Header";
        OutgoingPOEDILineRec: Record "Outgoing ZP PO Line";
    begin
        if DoesPOEDIRecordExists(PONum, isReturn, false) then begin
            // Delete Lines
            OutgoingPOEDILineRec.Reset;
            OutgoingPOEDILineRec.SetRange("Document No.", PONum);
            if isReturn then
                OutgoingPOEDILineRec.SetRange("Document Type Code", 'R')
            else
                OutgoingPOEDILineRec.SetRange("Document Type Code", '');
            OutgoingPOEDILineRec.SetRange(Processed, false);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            if not OutgoingPOEDILineRec.IsEmpty then
                OutgoingPOEDILineRec.DeleteAll();
            // YF 10 Aug 2022 // To avoid unnecessary table lock

            // Delete Header               
            OutgoingPOEDIHeaderRec.Reset;
            OutgoingPOEDIHeaderRec.SetRange("No.", PONum);
            if isReturn then
                OutgoingPOEDIHeaderRec.SetRange("Document Type Code", 'R')
            else
                OutgoingPOEDIHeaderRec.SetRange("Document Type Code", '');
            OutgoingPOEDIHeaderRec.SetRange(Processed, false);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            if not OutgoingPOEDIHeaderRec.IsEmpty then
                OutgoingPOEDIHeaderRec.DeleteAll();
            // YF 10 Aug 2022 // To avoid unnecessary table lock
        end;
        /*
        else
            Message('Unable to delete PO EDI record for ' + PONum + '. Does not exist or is processed');
        */
    end;

    procedure ValidateInvoiceBarcode(input: Text[1000]; debugMode: Boolean): Boolean
    var
        result: List of [Text];
        headerBreakLimiter: Integer; // identify which first columns are for header data
        lineBreakLimiter: Integer; // identify which index sequence for next line item
        poHeader: Record "Purchase Header";
        poLines: Record "Purchase Line";
        counter: Integer;
        lineCounter: Integer;

        // Header QR Code Data
        poHeaderNo: Text; // 1. PO Header No.
        invoiceNo: Text; // 2. Invoice No.
        invoiceDateText: Text; // 3. Invoice Date.

        // Item QR Code Data
        lineItemNo: Text; // 1. Item No.
        lineQtyText: Text; // 2. Qty
        lineUOMConversionFactorText: Text; // 3. UOM Conversion Factor
        lineUnitPriceText: Text; // 4. Unit Price
        lineBatchNo: Text; // 5. Batch No.
        lineBatchExpiryDateText: Text; // 6. Batch Expiary Date

    begin
        headerBreakLimiter := 3;
        lineBreakLimiter := 6;

        result := input.Split('|');

        if result.Count > 0 then begin
            // Get Header data
            poHeaderNo := result.Get(1);
            invoiceNo := result.Get(2);
            invoiceDateText := result.Get(3);

            if debugMode then
                Message('Header = ' + poHeaderNo + ' | ' + invoiceNo + ' | ' + invoiceDateText);

            if StrLen(poHeaderNo) <= 0 then begin
                Message('Missing PO No.');
                exit(false);
            end;

            // Get Line data
            for counter := (headerBreakLimiter + 1) to result.Count do begin
                if result.Count >= (counter + lineBreakLimiter - 1) then begin
                    // potential well-formed data, else ignore
                    lineItemNo := result.Get(counter);
                    lineQtyText := result.Get(counter + 1);
                    lineUOMConversionFactorText := result.Get(counter + 2);
                    lineUnitPriceText := result.Get(counter + 3);
                    lineBatchNo := result.Get(counter + 4);
                    lineBatchExpiryDateText := result.Get(counter + 5);
                    counter := (counter + lineBreakLimiter - 1);

                    // validation of scanned data if required here

                    if debugMode then
                        Message('Line = ' + lineItemNo + ' | ' + lineQtyText + ' | ' + lineUOMConversionFactorText + ' | ' + lineUnitPriceText + ' | ' + lineBatchNo + ' | ' + lineBatchExpiryDateText)
                    else
                        InsertInvoiceASNEntry(poHeaderNo, invoiceDateText, invoiceNo, lineItemNo, lineQtyText, lineUnitPriceText, lineBatchExpiryDateText, lineBatchNo, '', lineUOMConversionFactorText, true);

                end
                else begin
                    Message('QR code data may not be well-formed or complete');
                    counter := result.Count;
                    exit(false);
                end;
            end;
        end
        else begin
            Message('No data from QR Code');
            exit(false);
        end;

        exit(true);
    end;

    procedure ProcessInvoiceASN(IsDebug: Boolean)
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        CSVBuffer: Record "CSV Buffer" temporary;

        PONumber: Text[15];
        InvoiceDateText: Text[10];
        InvoiceNumber: Text[10];
        CustomerItemCode: Text[20];
        BillQtyText: Text[8];
        SellingPrice: Text[13];
        BatchExpiryDateText: Text[10];
        BatchNumber: Text[10];
        ItemDescr: Text[80];
        ConversionFactor: Text[10];

        recordCounter: Integer;
        PrevLineNo: Integer;
    begin
        recordCounter := 0;
        PrevLineNo := 1;

        // Get File
        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);

        CSVBuffer.DeleteAll();
        CSVBuffer.LoadDataFromStream(ImportStream, '|');
        if CSVBuffer.FindSet() then
            repeat
                // Legend
                // 1. Customer PO Number
                // 2. Invoice Date in DD.MM.YYYY
                // 3. Zuellig Invoice Number
                // 4. Customer Item Code
                // 5. Invoice Bill Qty, non decimal point
                // 6. Invoice Selling Price
                // 7. Batch Expiry Date in DD.MM.YYYY
                // 8. Batch Number
                // 9. Zuellig Item Description
                // 10. Converstion Factor (ZP: Customer)        

                if CSVBuffer."Line No." <> PrevLineNo then begin

                    if IsDebug then
                        Message('Data = ' + PONumber + ' | ' + InvoiceDateText + ' | ' + InvoiceNumber + ' | ' + CustomerItemCode + ' | ' + BillQtyText + ' | ' + SellingPrice + ' | ' + BatchExpiryDateText + ' | ' + BatchNumber + ' | ' + ItemDescr + ' | ' + ConversionFactor)
                    else
                        InsertInvoiceASNEntry(PONumber, InvoiceDateText, InvoiceNumber, CustomerItemCode, BillQtyText, SellingPrice, BatchExpiryDateText, BatchNumber, ItemDescr, ConversionFactor, false);

                    recordCounter += 1;

                    PONumber := '';
                    InvoiceDateText := '';
                    InvoiceNumber := '';
                    CustomerItemCode := '';
                    BillQtyText := '';
                    SellingPrice := '';
                    BatchExpiryDateText := '';
                    BatchNumber := '';
                    ItemDescr := '';
                    ConversionFactor := '';

                    PrevLineNo := CSVBuffer."Line No.";
                end;

                // ignore first header line
                //if CSVBuffer."Line No." > 1 then begin

                //  Grab data                    
                case CSVBuffer."Field No." of
                    1:
                        PONumber := ReplaceString(CSVBuffer.Value, '"', '');
                    2:
                        InvoiceDateText := ReplaceString(CSVBuffer.Value, '"', '');
                    3:
                        InvoiceNumber := ReplaceString(CSVBuffer.Value, '"', '');
                    4:
                        CustomerItemCode := ReplaceString(CSVBuffer.Value, '"', '');
                    5:
                        BillQtyText := ReplaceString(CSVBuffer.Value, '"', '');
                    6:
                        SellingPrice := ReplaceString(CSVBuffer.Value, '"', '');
                    7:
                        BatchExpiryDateText := ReplaceString(CSVBuffer.Value, '"', '');
                    8:
                        BatchNumber := ReplaceString(CSVBuffer.Value, '"', '');
                    9:
                        ItemDescr := ReplaceString(CSVBuffer.Value, '"', '');
                    10:
                        ConversionFactor := ReplaceString(CSVBuffer.Value, '"', '');
                end;

            //end;

            until CSVBuffer.Next() = 0;

        if PrevLineNo <> 1 then begin

            if IsDebug then
                Message('Data = ' + PONumber + ' | ' + InvoiceDateText + ' | ' + InvoiceNumber + ' | ' + CustomerItemCode + ' | ' + BillQtyText + ' | ' + SellingPrice + ' | ' + BatchExpiryDateText + ' | ' + BatchNumber + ' | ' + ItemDescr + ' | ' + ConversionFactor)
            else
                InsertInvoiceASNEntry(PONumber, InvoiceDateText, InvoiceNumber, CustomerItemCode, BillQtyText, SellingPrice, BatchExpiryDateText, BatchNumber, ItemDescr, ConversionFactor, false);

            recordCounter += 1;

            PONumber := '';
            InvoiceDateText := '';
            InvoiceNumber := '';
            CustomerItemCode := '';
            BillQtyText := '';
            SellingPrice := '';
            BatchExpiryDateText := '';
            BatchNumber := '';
            ItemDescr := '';
            ConversionFactor := '';

            PrevLineNo := 1;
        end;

        Message(Format(recordCounter) + ' record(s) Read Completed');
    end;

    local procedure InsertInvoiceASNEntry(PONum: Text; InvoiceDate: Text; InvoiceNum: Text; CustItemCode: Text; BillQty: Text; SellPrice: Text; BatchExpDate: Text; BatchNum: Text; ItemDescr: Text; ConvFactor: Text; IsQRCode: Boolean)
    var
        ZPInvoiceASNEntry: Record "Zuellig Invoice ASN Import Log";
    begin
        ZPInvoiceASNEntry.Init();
        ZPInvoiceASNEntry."PO Number" := PONum;
        ZPInvoiceASNEntry."Invoice Date Text" := InvoiceDate;

        if IsQRCode then begin
            if Not Evaluate(ZPInvoiceASNEntry."Invoice Date", CopyStr(InvoiceDate, 7, 2) + CopyStr(InvoiceDate, 5, 2) + CopyStr(InvoiceDate, 1, 4)) then
                ZPInvoiceASNEntry."Invoice Date" := 0D;
        end
        else begin
            if Not Evaluate(ZPInvoiceASNEntry."Invoice Date", InvoiceDate) then
                ZPInvoiceASNEntry."Invoice Date" := 0D;
        end;

        ZPInvoiceASNEntry."Invoice Number" := InvoiceNum;
        ZPInvoiceASNEntry."Customer Item Code" := CustItemCode;
        ZPInvoiceASNEntry."Bill Qty Text" := BillQty;

        if Not Evaluate(ZPInvoiceASNEntry."Bill Qty", BillQty) then
            ZPInvoiceASNEntry."Bill Qty" := 0;

        ZPInvoiceASNEntry."Selling Price Text" := SellPrice;

        if Not Evaluate(ZPInvoiceASNEntry."Selling Price", SellPrice) then
            ZPInvoiceASNEntry."Selling Price" := 0;

        ZPInvoiceASNEntry."Batch Expiry Date Text" := BatchExpDate;

        if IsQRCode then begin
            if Not Evaluate(ZPInvoiceASNEntry."Batch Expiry Date", CopyStr(BatchExpDate, 7, 2) + CopyStr(BatchExpDate, 5, 2) + CopyStr(BatchExpDate, 1, 4)) then
                ZPInvoiceASNEntry."Batch Expiry Date" := 0D;
        end
        else begin
            if Not Evaluate(ZPInvoiceASNEntry."Batch Expiry Date", BatchExpDate) then
                ZPInvoiceASNEntry."Batch Expiry Date" := 0D;
        end;

        ZPInvoiceASNEntry."Batch Number" := BatchNum;
        ZPInvoiceASNEntry."Item Description" := ItemDescr;
        ZPInvoiceASNEntry."Conversion Factor" := ConvFactor;

        if Not Evaluate(ZPInvoiceASNEntry."Conversion Factor Decimal", ConvFactor) then
            ZPInvoiceASNEntry."Conversion Factor Decimal" := 0;

        ZPInvoiceASNEntry.UserId := UserId;
        ZPInvoiceASNEntry."Entry Date Time" := CurrentDateTime;
        ZPInvoiceASNEntry.Insert();
    end;

    LOCAL procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(String, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(String, FindPos) + ReplaceWith;
            String := COPYSTR(String, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(String, FindWhat);
        END;
        NewString += String;
    end;



    local procedure GenerateFileName(var ZPSGID: Text; groupName: Text; locationCode: Text; PONum: Text): Text
    var
        IntegrationSetup: Record "Zuellig Integration Setup";
        POEDIFileName: Text;
    begin
        if Not IntegrationSetup.Get() then
            Error('Zuellig Integration not Setup');

        // Set ZPSGID
        ZPSGID := IntegrationSetup."Assigned EC-Web Customer ID";

        // Generate File Name
        POEDIFileName := 'PO_' + FORMAT(CURRENTDATETIME, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>');
        if IntegrationSetup."Enable EC-Web Customer ID" then
            POEDIFileName += '_' + IntegrationSetup."Assigned EC-Web Customer ID"
        else begin
            if StrLen(groupName) > 0 then
                POEDIFileName += '_' + groupName;
            if StrLen(locationCode) > 0 then
                POEDIFileName += '_' + locationCode;
        end;

        // Optional - Add on PO Num to make file name unique. Saas process too fast for filename to be unique by timestamp
        if StrLen(PONum) > 0 then
            POEDIFileName += '_' + PONum;

        exit(POEDIFileName);
    end;


    procedure GeneratePOEDI_PONum_API(PONum: Text; isReturn: Boolean) // cater for 1 PO 1 File
    var
        POHeader: Record "Purchase Header";
    begin
        if isReturn then begin
            POHeader.SetRange("Document Type", POHeader."Document Type"::"Return Order");
            POHeader.SetRange("No.", PONum);
            if POHeader.Find('-') then
                GeneratePOEDI_APICall(POHeader, isReturn)
            else
                Error('PO Return not found to Generate PO Return EDI');
        end
        else begin
            POHeader.SetRange("Document Type", POHeader."Document Type"::Order);
            POHeader.SetRange("No.", PONum);
            if POHeader.Find('-') then
                GeneratePOEDI_APICall(POHeader)
            else
                Error('PO not found to Generate PO EDI');
        end;
    end;


    procedure GeneratePOEDI_APICall(var POHeader: Record "Purchase Header"; isReturn: Boolean) // Currently limited to 1 PO 1 File
    begin
        if isReturn then
            GeneratePROEDI_APICall(POHeader)
        else
            GeneratePOEDI_APICall(POHeader);
    end;

    // For Purchase Order EDI
    procedure GeneratePOEDI_APICall(var POHeader: Record "Purchase Header") // Currently limited to 1 PO 1 File
    var
        POEDIFileName: Text;
        TabDelimiter: Text[1];
        CrLfLineBreak: Text[2];
        SummaryRecordString: Text;
        HeaderRecordString: Text;
        LineRecordString: Text;
        GroupName: Text;
        LocationName: Text;
        POLines: Record "Purchase Line";
        ZPSGID: Text;
        ZPLocationCode: Code[20];

        TempBlob: Codeunit "Temp Blob";
        MyOutStream: OutStream;
        Tofile: Variant;
        NewStream: InStream;
        returnValue: Boolean;

        ContentResult: Text[2048];
        ZPSetupRec: Record "Zuellig Integration Setup";
        UnitPriceCents: Integer;

        POEDIHeaderRec: Record "Outgoing ZP PO Header";
        POEDILineRec: Record "Outgoing ZP PO Line";
    begin
        if ZPSetupRec.Get() then
            if ZPSetupRec."Enable EC-Web Customer ID" then begin
                ZPSGID := ZPSetupRec."Assigned EC-Web Customer ID";
                ZPLocationCode := ZPSetupRec."Location/Store Code";
            end;

        TabDelimiter[1] := 9;
        CrLfLineBreak := ' ';
        CrLfLineBreak[1] := 13;
        CrLfLineBreak[2] := 10;

        if POHeader.Count > 1 then begin
            // multi PO detected
            GroupName := '';
            LocationName := '';
            POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, '');
        end
        else begin
            // single PO detected
            GroupName := '';
            LocationName := '';
            POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, '');
            // POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, POHeader."No.");
        end;

        // TempBlob.CreateOutStream(MyOutStream, TextEncoding::Windows);
        TempBlob.CreateOutStream(MyOutStream, TextEncoding::UTF8);

        // Summary Record
        // 1. Record Type - M - C1 - Summary S
        // 2. Group - M - C10 - Customer ID in EC-Web
        // 3. Total PO Count - M - N5 - Total number of PO header lines
        // 4. Return Order - O - C1 - R for return order, none required for normal
        // SummaryRecordString := 'S' + TabDelimiter + COPYSTR(ZPSGID, 1, 10) + TabDelimiter + Format(POHeader.Count) + CrLfLineBreak;
        SummaryRecordString := 'S' + TabDelimiter + COPYSTR(ZPSGID, 1, 10) + TabDelimiter + Format(POHeader.Count) + TabDelimiter + '';
        MyOutStream.WriteText(SummaryRecordString);
        MyOutStream.WriteText();

        if POHeader.FindSet() then
            repeat
                // Header Record
                // 1. Record Type - M - C1 - Header H
                // 2. Location/Store Code - M - C10 - Customer Code
                // 3. PO Number - O - C15 - Customer PO Number
                // 4. Tender No - O - C15 - Harcode as Blank
                // 5. Contract No - O - C20 -  Hardcode as Blank
                // 6. Order Date - M - C8 - YYYYMMDD
                // 7. Delivery Date - M - C8 - YYYYMMDD, if null default to order date
                // 8. Special Instruction - O - C60 - Hardcode as Blank
                // 9. Total Line Items - M N5 - Line count of detail record
                // 10. Sales Order # - O - C12 -  Sales Order Number
                HeaderRecordString := 'H';
                HeaderRecordString += TabDelimiter + ZPLocationCode;
                // HeaderRecordString += TabDelimiter + CustRec."Location Code";
                HeaderRecordString += TabDelimiter + POHeader."No.";
                HeaderRecordString += TabDelimiter + '';
                HeaderRecordString += TabDelimiter + '';
                HeaderRecordString += TabDelimiter + FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>');
                if POHeader."Expected Receipt Date" = 0D then
                    HeaderRecordString += TabDelimiter + FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>')
                else
                    HeaderRecordString += TabDelimiter + FORMAT(POHeader."Expected Receipt Date", 0, '<Year4><Month,2><Day,2>');
                HeaderRecordString += TabDelimiter + '';
                POLines.Reset;
                POLines.SetRange("Document Type", POHeader."Document Type");
                POLines.SetRange("Document No.", POHeader."No.");
                HeaderRecordString += TabDelimiter + FORMAT(POLines.Count);
                HeaderRecordString += TabDelimiter + '';

                MyOutStream.WriteText(HeaderRecordString);
                MyOutStream.WriteText();

                // YF 05 Aug 2021 // Insert PO EDI Outgoing Header Record
                /*
                POEDIHeaderRec.Init();
                POEDIHeaderRec."No." := COPYSTR(POHeader."No.", 1, 15);
                POEDIHeaderRec."Document Type Code" := '';
                POEDIHeaderRec."ZP Customer ID" := ZPSGID;
                POEDIHeaderRec."Record Type" := 'H';
                POEDIHeaderRec."Location Store Code" := ZPSGID;
                POEDIHeaderRec."Tender No." := '';
                POEDIHeaderRec."Contract No." := '';
                POEDIHeaderRec."Order Date" := FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>');
                if POHeader."Expected Receipt Date" = 0D then
                    POEDIHeaderRec."Delivery Date" := FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>')
                else
                    POEDIHeaderRec."Delivery Date" := FORMAT(POHeader."Expected Receipt Date", 0, '<Year4><Month,2><Day,2>');
                POEDIHeaderRec."Special Instruction" := '';
                POEDIHeaderRec."Total Line Items" := POLines.Count;
                POEDIHeaderRec."Sales Order No." := '';
                POEDIHeaderRec.Processed := false;
                POEDIHeaderRec."Has Error" := false;
                POEDIHeaderRec.Insert();
                */
                // YF 05 Aug 2021 // Insert PO EDI Outgoing Header Record

                POLines.Reset;
                POLines.SetRange("Document Type", POHeader."Document Type");
                POLines.SetRange("Document No.", POHeader."No.");
                if POLines.FindSet() then
                    repeat
                        // Detail Record
                        // 1. Record Type - M - C1 - Detail D
                        // 2. Customer Item Code - M - C20 - Customer Item code 
                        // 3. Customer Item Description - M - C80
                        // 4. Customer Item UOM - M - C10 - UOM
                        // 5. ZP Item Code - O - C20
                        // 6. Commercial Qty - M - N8 - Order Qty no decimal point. Use the conversion qty if exists
                        // 7. Unit Price - M - N10,2 - Unit Price, Implicit 2 decimal ppoint i.e. 514 = 5.14
                        // 8. Bonus Item 1 (Using Customer Item Code) - O - C20
                        // 9. Bonus Item 1 (Using ZP Item Code) - O - C20
                        // 10. Bonus Item 1 Qty - O - N8 - Order Qty no decimal point. Use the conversion qty if exist
                        // 11. Bonus Item 2 (Using Customer Item Code) - O - C20
                        // 12. Bonus Item 2 (Using ZP Item Code) - O - C20
                        // 13. Bonus Item 2 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                        // 14. Bonus Item 3 (Using Customer Item Code) - O - C20
                        // 15. Bonus Item 3 (Using ZP Item Code) - O - C20
                        // 16. Bonus Item 3 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                        LineRecordString := 'D';
                        LineRecordString += TabDelimiter + POLines."No.";
                        LineRecordString += TabDelimiter + COPYSTR(POLines.Description, 1, 80);
                        LineRecordString += TabDelimiter + POLines."Unit of Measure Code";
                        LineRecordString += TabDelimiter + '';

                        LineRecordString += TabDelimiter + FORMAT(POLines."Order Qty", 0, '<Integer>');
                        // LineRecordString += TabDelimiter + FORMAT(POLines.Quantity, 0, '<Integer Thousand>');

                        UnitPriceCents := ((POLines."Purchase Price" + 0.005) * 100) div 1;
                        LineRecordString += TabDelimiter + FORMAT(UnitPriceCents, 0, '<Integer>');
                        // LineRecordString += TabDelimiter + FORMAT(Round(POLines."Direct Unit Cost", 0.01, '='), 0, '<Integer><Decimals,3>');

                        if POLines."FOC Qty" > 0 then begin
                            LineRecordString += TabDelimiter + POLines."No.";
                            LineRecordString += TabDelimiter + '';
                            LineRecordString += TabDelimiter + FORMAT(POLines."FOC Qty", 0, '<Integer>');
                        end
                        else begin
                            LineRecordString += TabDelimiter + '';
                            LineRecordString += TabDelimiter + '';
                            LineRecordString += TabDelimiter + '';
                        end;

                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';

                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';

                        MyOutStream.WriteText(LineRecordString);
                        MyOutStream.WriteText();

                    // YF 05 Aug 2021 // Insert PO EDI Outgoing Line Record
                    /*
                    POEDILineRec.Init();
                    POEDILineRec."Document No." := COPYSTR(POLines."Document No.", 1, 15);
                    POEDILineRec."Document Line No." := POLines."Line No.";
                    POEDILineRec."Document Type Code" := '';
                    POEDILineRec."Record Type" := 'D';
                    POEDILineRec."Customer Item Code" := POLines."No.";
                    POEDILineRec."Customer Item Descr" := COPYSTR(POLines.Description, 1, 80);
                    POEDILineRec."Customer Item UOM" := POLines."Unit of Measure Code";
                    POEDILineRec."ZP Item Code" := '';
                    POEDILineRec."Commercial Qty" := FORMAT(POLines."Order Qty", 0, '<Integer>');
                    POEDILineRec."Unit Price" := FORMAT(UnitPriceCents, 0, '<Integer>');
                    if POLines."FOC Qty" > 0 then begin
                        POEDILineRec."Bonus 1 Cust Item Code" := POLines."No.";
                        POEDILineRec."Bonus 1 ZP Item Code" := '';
                        POEDILineRec."Bonus 1 Qty" := FORMAT(POLines."FOC Qty", 0, '<Integer>');
                    end
                    else begin
                        POEDILineRec."Bonus 1 Cust Item Code" := '';
                        POEDILineRec."Bonus 1 ZP Item Code" := '';
                        POEDILineRec."Bonus 1 Qty" := '';
                    end;
                    POEDILineRec."Bonus 2 Cust Item Code" := '';
                    POEDILineRec."Bonus 2 ZP Item Code" := '';
                    POEDILineRec."Bonus 2 Qty" := '';
                    POEDILineRec."Bonus 3 Cust Item Code" := '';
                    POEDILineRec."Bonus 3 ZP Item Code" := '';
                    POEDILineRec."Bonus 3 Qty" := '';
                    POEDILineRec.Processed := false;
                    POEDILineRec."Has Error" := false;
                    POEDILineRec.Insert();
                    */
                    // YF 05 Aug 2021 // Insert PO EDI Outgoing Line Record

                    until POLines.Next() = 0;

            until POHeader.Next() = 0;

        // TODO: INSERT API CALL CODES HERE
        // Stream Blob data to message box for now
        /*
        TempBlob.CreateInStream(NewStream, TextEncoding::UTF8);
        NewStream.Read(ContentResult);
        Message(POEDIFileName);
        Message(ContentResult);
        */

        // Generate File

        // TempBlob.CreateInStream(NewStream, TextEncoding::Windows);
        TempBlob.CreateInStream(NewStream, TextEncoding::UTF8);
        Tofile := POEDIFileName + '.txt';
        returnValue := DownloadFromStream(NewStream, 'Save File to RoleTailored Client', '', 'Text File *.txt| *.txt', ToFile);

    end;

    // For Purchase Return Order EDI
    procedure GeneratePROEDI_APICall(var POHeader: Record "Purchase Header") // Currently limited to 1 PO 1 File
    var
        POEDIFileName: Text;
        TabDelimiter: Text[1];
        CrLfLineBreak: Text[2];
        SummaryRecordString: Text;
        HeaderRecordString: Text;
        LineRecordString: Text;
        GroupName: Text;
        LocationName: Text;
        POLines: Record "Purchase Line";
        ZPSGID: Text;
        ZPLocationCode: Code[20];

        TempBlob: Codeunit "Temp Blob";
        MyOutStream: OutStream;
        Tofile: Variant;
        NewStream: InStream;
        returnValue: Boolean;

        ContentResult: Text[2048];
        ZPSetupRec: Record "Zuellig Integration Setup";
        UnitPriceCents: Integer;

        POEDIHeaderRec: Record "Outgoing ZP PO Header";
        POEDILineRec: Record "Outgoing ZP PO Line";
    begin
        if ZPSetupRec.Get() then
            if ZPSetupRec."Enable EC-Web Customer ID" then begin
                ZPSGID := ZPSetupRec."Assigned EC-Web Customer ID";
                ZPLocationCode := ZPSetupRec."Location/Store Code";
            end;

        TabDelimiter[1] := 9;
        CrLfLineBreak := ' ';
        CrLfLineBreak[1] := 13;
        CrLfLineBreak[2] := 10;

        if POHeader.Count > 1 then begin
            // multi PO detected
            GroupName := '';
            LocationName := '';
            POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, '');
        end
        else begin
            // single PO detected
            GroupName := '';
            LocationName := '';
            POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, '');
            // POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, POHeader."No.");
        end;

        // TempBlob.CreateOutStream(MyOutStream, TextEncoding::Windows);
        TempBlob.CreateOutStream(MyOutStream, TextEncoding::UTF8);

        // Summary Record
        // 1. Record Type - M - C1 - Summary S
        // 2. Group - M - C10 - Customer ID in EC-Web
        // 3. Total PO Count - M - N5 - Total number of PO header lines
        // 4. Return Order - O - C1 - Return R (not required for normal order)
        // SummaryRecordString := 'S' + TabDelimiter + COPYSTR(ZPSGID, 1, 10) + TabDelimiter + Format(POHeader.Count) + CrLfLineBreak;
        SummaryRecordString := 'S' + TabDelimiter + COPYSTR(ZPSGID, 1, 10) + TabDelimiter + Format(POHeader.Count) + TabDelimiter + 'R';
        MyOutStream.WriteText(SummaryRecordString);
        MyOutStream.WriteText();

        if POHeader.FindSet() then
            repeat
                // Header Record
                // 1. Record Type - M - C1 - Header H
                // 2. Location/Store Code - M - C10 - Customer Code
                // 3. PO Number - O - C15 - Customer PO Number
                // 4. Tender No - O - C15 - Harcode as Blank
                // 5. Contract No - O - C20 -  Hardcode as Blank
                // 6. Order Date - M - C8 - YYYYMMDD
                // 7. Delivery Date - M - C8 - YYYYMMDD, if null default to order date
                // 8. Special Instruction - O - C60 - Hardcode as Blank
                // 9. Total Line Items - M N5 - Line count of detail record
                // 10. Sales Order # - O - C12 -  Sales Order Number
                HeaderRecordString := 'H';
                HeaderRecordString += TabDelimiter + ZPLocationCode;
                // HeaderRecordString += TabDelimiter + CustRec."Location Code";
                HeaderRecordString += TabDelimiter + POHeader."No.";
                HeaderRecordString += TabDelimiter + '';
                HeaderRecordString += TabDelimiter + '';
                HeaderRecordString += TabDelimiter + FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>');
                if POHeader."Expected Receipt Date" = 0D then
                    HeaderRecordString += TabDelimiter + FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>')
                else
                    HeaderRecordString += TabDelimiter + FORMAT(POHeader."Expected Receipt Date", 0, '<Year4><Month,2><Day,2>');
                HeaderRecordString += TabDelimiter + '';
                POLines.Reset;
                POLines.SetRange("Document Type", POHeader."Document Type");
                POLines.SetRange("Document No.", POHeader."No.");
                HeaderRecordString += TabDelimiter + FORMAT(POLines.Count);
                HeaderRecordString += TabDelimiter + '';
                MyOutStream.WriteText(HeaderRecordString);
                MyOutStream.WriteText();

                // YF 05 Aug 2021 // Insert PO EDI Outgoing Header Record
                /*
                POEDIHeaderRec.Init();
                POEDIHeaderRec."No." := COPYSTR(POHeader."No.", 1, 15);
                POEDIHeaderRec."Document Type Code" := 'R';
                POEDIHeaderRec."ZP Customer ID" := ZPSGID;
                POEDIHeaderRec."Record Type" := 'H';
                POEDIHeaderRec."Location Store Code" := ZPSGID;
                POEDIHeaderRec."Tender No." := '';
                POEDIHeaderRec."Contract No." := '';
                POEDIHeaderRec."Order Date" := FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>');
                if POHeader."Expected Receipt Date" = 0D then
                    POEDIHeaderRec."Delivery Date" := FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>')
                else
                    POEDIHeaderRec."Delivery Date" := FORMAT(POHeader."Expected Receipt Date", 0, '<Year4><Month,2><Day,2>');
                POEDIHeaderRec."Special Instruction" := '';
                POEDIHeaderRec."Total Line Items" := POLines.Count;
                POEDIHeaderRec."Sales Order No." := '';
                POEDIHeaderRec.Processed := false;
                POEDIHeaderRec."Has Error" := false;
                POEDIHeaderRec.Insert();
                */
                // YF 05 Aug 2021 // Insert PO EDI Outgoing Header Record

                POLines.Reset;
                POLines.SetRange("Document Type", POHeader."Document Type");
                POLines.SetRange("Document No.", POHeader."No.");
                if POLines.FindSet() then
                    repeat
                        // Detail Record
                        // 1. Record Type - M - C1 - Detail D
                        // 2. Customer Item Code - M - C20 - Customer Item code 
                        // 3. Customer Item Description - M - C80
                        // 4. Customer Item UOM - M - C10 - UOM
                        // 5. ZP Item Code - O - C20
                        // 6. Commercial Qty - M - N8 - Order Qty no decimal point. Use the conversion qty if exists
                        // 7. Unit Price - M - N10,2 - Unit Price, Implicit 2 decimal ppoint i.e. 514 = 5.14
                        // 8. Bonus Item 1 (Using Customer Item Code) - O - C20
                        // 9. Bonus Item 1 (Using ZP Item Code) - O - C20
                        // 10. Bonus Item 1 Qty - O - N8 - Order Qty no decimal point. Use the conversion qty if exist
                        // 11. Bonus Item 2 (Using Customer Item Code) - O - C20
                        // 12. Bonus Item 2 (Using ZP Item Code) - O - C20
                        // 13. Bonus Item 2 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                        // 14. Bonus Item 3 (Using Customer Item Code) - O - C20
                        // 15. Bonus Item 3 (Using ZP Item Code) - O - C20
                        // 16. Bonus Item 3 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                        LineRecordString := 'D';
                        LineRecordString += TabDelimiter + POLines."No.";
                        LineRecordString += TabDelimiter + COPYSTR(POLines.Description, 1, 80);
                        LineRecordString += TabDelimiter + POLines."Unit of Measure Code";
                        LineRecordString += TabDelimiter + '';

                        LineRecordString += TabDelimiter + FORMAT(POLines.Quantity, 0, '<Integer>');

                        UnitPriceCents := ((POLines."Purchase Price" + 0.005) * 100) div 1;
                        LineRecordString += TabDelimiter + FORMAT(UnitPriceCents, 0, '<Integer>');

                        if POLines."FOC Qty" > 0 then begin
                            LineRecordString += TabDelimiter + POLines."No.";
                            LineRecordString += TabDelimiter + '';
                            LineRecordString += TabDelimiter + FORMAT(POLines."FOC Qty", 0, '<Integer>');
                        end
                        else begin
                            LineRecordString += TabDelimiter + '';
                            LineRecordString += TabDelimiter + '';
                            LineRecordString += TabDelimiter + '';
                        end;

                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';

                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';
                        LineRecordString += TabDelimiter + '';

                        MyOutStream.WriteText(LineRecordString);
                        MyOutStream.WriteText();

                    // YF 05 Aug 2021 // Insert PO EDI Outgoing Line Record
                    /*
                    POEDILineRec.Init();
                    POEDILineRec."Document No." := COPYSTR(POLines."Document No.", 1, 15);
                    POEDILineRec."Document Line No." := POLines."Line No.";
                    POEDILineRec."Document Type Code" := 'R';
                    POEDILineRec."Record Type" := 'D';
                    POEDILineRec."Customer Item Code" := POLines."No.";
                    POEDILineRec."Customer Item Descr" := COPYSTR(POLines.Description, 1, 80);
                    POEDILineRec."Customer Item UOM" := POLines."Unit of Measure Code";
                    POEDILineRec."ZP Item Code" := '';
                    POEDILineRec."Commercial Qty" := FORMAT(POLines."Order Qty", 0, '<Integer>');
                    POEDILineRec."Unit Price" := FORMAT(UnitPriceCents, 0, '<Integer>');
                    if POLines."FOC Qty" > 0 then begin
                        POEDILineRec."Bonus 1 Cust Item Code" := POLines."No.";
                        POEDILineRec."Bonus 1 ZP Item Code" := '';
                        POEDILineRec."Bonus 1 Qty" := FORMAT(POLines."FOC Qty", 0, '<Integer>');
                    end
                    else begin
                        POEDILineRec."Bonus 1 Cust Item Code" := '';
                        POEDILineRec."Bonus 1 ZP Item Code" := '';
                        POEDILineRec."Bonus 1 Qty" := '';
                    end;
                    POEDILineRec."Bonus 2 Cust Item Code" := '';
                    POEDILineRec."Bonus 2 ZP Item Code" := '';
                    POEDILineRec."Bonus 2 Qty" := '';
                    POEDILineRec."Bonus 3 Cust Item Code" := '';
                    POEDILineRec."Bonus 3 ZP Item Code" := '';
                    POEDILineRec."Bonus 3 Qty" := '';
                    POEDILineRec.Processed := false;
                    POEDILineRec."Has Error" := false;
                    POEDILineRec.Insert();
                    */
                    // YF 05 Aug 2021 // Insert PO EDI Outgoing Line Record

                    until POLines.Next() = 0;

            until POHeader.Next() = 0;

        // TODO: INSERT API CALL CODES HERE
        /*
        // Stream Blob data to message box for now
        TempBlob.CreateInStream(NewStream, TextEncoding::UTF8);
        NewStream.Read(ContentResult);
        Message(POEDIFileName);
        Message(ContentResult);
        */

        // Generate File

        // TempBlob.CreateInStream(NewStream, TextEncoding::Windows);
        TempBlob.CreateInStream(NewStream, TextEncoding::UTF8);
        Tofile := POEDIFileName + '.txt';
        returnValue := DownloadFromStream(NewStream, 'Save File to RoleTailored Client', '', 'Text File *.txt| *.txt', ToFile);
    end;

    /*
    procedure GeneratePOEDI_File(var POHeader: Record "Purchase Header") // Currently limited to 1 PO 1 File
    var
        TempBlob: Codeunit "Temp Blob";
        MyOutStream: OutStream;
        POEDIFileName: Text;
        TabDelimiter: Text[1];
        SummaryRecordString: Text;
        HeaderRecordString: Text;
        LineRecordString: Text;
        Tofile: Variant;
        NewStream: InStream;
        returnValue: Boolean;
        GroupName: Text;
        LocationName: Text;
        POLines: Record "Purchase Line";
        ZPSGID: Text;
    begin
        TabDelimiter[1] := 9;

        if POHeader.FindFirst() then begin

            GroupName := '';
            LocationName := '';

            POEDIFileName := GenerateFileName(ZPSGID, GroupName, LocationName, '');

            // TempBlob.CreateOutStream(MyOutStream, TextEncoding::Windows);
            TempBlob.CreateOutStream(MyOutStream, TextEncoding::UTF8);

            // Summary Record
            // 1. Record Type - M - C1 - Summary S
            // 2. Group - M - C10 - Customer ID in EC-Web
            // 3. Total PO Count - M - N5 - Total number of PO header lines
            SummaryRecordString := 'S' + TabDelimiter + COPYSTR(ZPSGID, 1, 10) + TabDelimiter + '1';
            MyOutStream.WriteText(SummaryRecordString);
            MyOutStream.WriteText();

            // Header Record
            // 1. Record Type - M - C1 - Header H
            // 2. Location/Store Code - M - C10 - Customer Code
            // 3. PO Number - O - C15 - Customer PO Number
            // 4. Tender No - O - C15 - Harcode as Blank
            // 5. Contract No - O - C20 -  Hardcode as Blank
            // 6. Order Date - M - C8 - YYYYMMDD
            // 7. Delivery Date - M - C8 - YYYYMMDD, if null default to order date
            // 8. Special Instruction - O - C60 - Hardcode as Blank
            // 9. Total Line Items - M N5 - Line count of detail record
            HeaderRecordString := 'H';
            HeaderRecordString += TabDelimiter + ZPSGID;
            // HeaderRecordString += TabDelimiter + CustRec."Location Code";
            HeaderRecordString += TabDelimiter + POHeader."No.";
            HeaderRecordString += TabDelimiter + '';
            HeaderRecordString += TabDelimiter + '';
            HeaderRecordString += TabDelimiter + FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>');
            if POHeader."Expected Receipt Date" = 0D then
                HeaderRecordString += TabDelimiter + FORMAT(POHeader."Order Date", 0, '<Year4><Month,2><Day,2>')
            else
                HeaderRecordString += TabDelimiter + FORMAT(POHeader."Expected Receipt Date", 0, '<Year4><Month,2><Day,2>');
            HeaderRecordString += TabDelimiter + '';
            POLines.Reset;
            POLines.SetRange("Document Type", POHeader."Document Type");
            POLines.SetRange("Document No.", POHeader."No.");
            HeaderRecordString += TabDelimiter + FORMAT(POLines.Count);
            MyOutStream.WriteText(HeaderRecordString);
            MyOutStream.WriteText();

            POLines.Reset;
            POLines.SetRange("Document Type", POHeader."Document Type");
            POLines.SetRange("Document No.", POHeader."No.");
            if POLines.FindSet() then
                repeat
                    // Detail Record
                    // 1. Record Type - M - C1 - Detail D
                    // 2. Customer Item Code - M - C20 - Customer Item code 
                    // 3. Customer Item Description - O - C80
                    // 4. Customer Item UOM - M - C10 - UOM
                    // 5. ZP Item Code - O - C20
                    // 6. Commercial Qty - M - N8 - Order Qty no decimal point. Use the conversion qty if exists
                    // 7. Unit Price - M - N10,2 - Unit Price, Implicit 2 decimal ppoint
                    // 8. Bonus Item 1 (Using Customer Item Code) - O - C20
                    // 9. Bonus Item 1 (Using ZP Item Code) - O - C20
                    // 10. Bonus Item 1 Qty - O - N8 - Order Qty no decimal point. Use the conversion qty if exist
                    // 11. Bonus Item 2 (Using Customer Item Code) - O - C20
                    // 12. Bonus Item 2 (Using ZP Item Code) - O - C20
                    // 13. Bonus Item 2 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                    // 14. Bonus Item 3 (Using Customer Item Code) - O - C20
                    // 15. Bonus Item 3 (Using ZP Item Code) - O - C20
                    // 16. Bonus Item 3 Qty - O - N8 - Order Qty no decimal point, Use the conversion qty if exist
                    LineRecordString := 'D';
                    LineRecordString += TabDelimiter + POLines."No.";
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + POLines."Unit of Measure Code";
                    LineRecordString += TabDelimiter + '';

                    LineRecordString += TabDelimiter + FORMAT(POLines.Quantity, 0, '<Integer Thousand>');
                    LineRecordString += TabDelimiter + FORMAT(Round(POLines."Direct Unit Cost", 0.01, '='), 0, '<Integer Thousand><Decimals,3>');

                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    LineRecordString += TabDelimiter + '';
                    MyOutStream.WriteText(LineRecordString);
                    MyOutStream.WriteText();
                until POLines.Next() = 0;

            // Generate File
            // TempBlob.CreateInStream(NewStream, TextEncoding::Windows);
            TempBlob.CreateInStream(NewStream, TextEncoding::UTF8);
            Tofile := POEDIFileName + '.txt';
            returnValue := DownloadFromStream(NewStream, 'Save File to RoleTailored Client', '', 'Text File *.txt| *.txt', ToFile);

        end;
    end;
    */

    //DX        03 Oct 2021
    procedure IsZuelligVendor(VendCode: Code[20]): Boolean
    var
        myInt: Integer;
        ZPSetup: Record "Zuellig Integration Setup";
    begin
        ZPSetup.reset;
        ZPSetup.get;
        if ZPSetup."BC Vendor Code" <> '' then begin
            if VendCode = ZPSetup."BC Vendor Code" then
                exit(true)
            else
                exit(false);
        end;
    end;
    //DX        03 Oct 2021

    // YF        07 Oct 2021 
    [TryFunction]
    procedure CheckPOLineInfo(EntryNo: BigInteger; PurchOrderID: Text[20]; ItemCode: Text[20])
    var
        ItemRec: Record Item;
        POLineRec: Record "Purchase Line";
        StagingRec: Record "Zuellig Invoice ASN Import Log";
        CheckStagingRec: Record "Zuellig Invoice ASN Import Log";
    begin

        // Check for existing Staged Records
        if Not StagingRec.Get(EntryNo) then
            Error('Staging record not found');

        CheckStagingRec.Reset();
        CheckStagingRec.SetRange("PO Number", StagingRec."PO Number");
        CheckStagingRec.SetRange("Customer Item Code", StagingRec."Customer Item Code");
        CheckStagingRec.SetRange("Batch Number", StagingRec."Batch Number");
        CheckStagingRec.SetRange("Bill Qty", StagingRec."Bill Qty");
        CheckStagingRec.SetRange("Selling Price", StagingRec."Selling Price");
        CheckStagingRec.SetFilter("Entry No", '<>%1', EntryNo);
        if CheckStagingRec.FindFirst() then
            Error('Duplicates staging record found');

        if Not ItemRec.Get(UpperCase(ItemCode)) then
            Error('No such item');

        POLineRec.Reset;
        POLineRec.SetRange("Document Type", POLineRec."Document Type"::Order);
        POLineRec.SetRange("Document No.", UpperCase(PurchOrderID));
        POLineRec.SetRange("No.", UpperCase(ItemCode));

        if POLineRec.Count <= 0 then
            Error('Matching PO Line not found');
    end;

    procedure CreatePOBatch(EntryNo: BigInteger)
    var
        StagingRec: Record "Zuellig Invoice ASN Import Log";
        CheckStagingRec: Record "Zuellig Invoice ASN Import Log";
        ItemRec: Record Item;
        POLineRec: Record "Purchase Line";
        ReservationEntryRec: Record "Reservation Entry";
        POHeaderRec: Record "Purchase Header";
    begin
        if Not StagingRec.Get(EntryNo) then
            exit;

        CheckStagingRec.Reset();
        CheckStagingRec.SetRange("PO Number", StagingRec."PO Number");
        CheckStagingRec.SetRange("Customer Item Code", StagingRec."Customer Item Code");
        CheckStagingRec.SetRange("Batch Number", StagingRec."Batch Number");
        CheckStagingRec.SetRange("Bill Qty", StagingRec."Bill Qty");
        CheckStagingRec.SetRange("Selling Price", StagingRec."Selling Price");
        CheckStagingRec.SetFilter("Entry No", '<>%1', EntryNo);
        if CheckStagingRec.FindFirst() then begin
            StagingRec."PO Error" := true;
            StagingRec."Process Remarks" := 'Duplicate Staging Record found during creation';
            StagingRec.Modify();
            exit;
        end;

        if Not ItemRec.Get(UpperCase(StagingRec."Customer Item Code")) then begin
            StagingRec."PO Error" := true;
            StagingRec."Process Remarks" := GetLastErrorText();
            StagingRec.Modify();
            exit;
        end;

        POLineRec.Reset;
        POLineRec.SetRange("Document Type", POLineRec."Document Type"::Order);
        POLineRec.SetRange("Document No.", UpperCase(StagingRec."PO Number"));
        POLineRec.SetRange("No.", UpperCase(StagingRec."Customer Item Code"));

        if POLineRec.FindFirst() then begin

            POHeaderRec.Reset;
            POHeaderRec.SetRange("Document Type", POHeaderRec."Document Type"::Order);
            POHeaderRec.SetRange("No.", POLineRec."Document No.");
            POHeaderRec.FindFirst();

            // reservation entry
            ReservationEntryRec.Reset;
            ReservationEntryRec.Init();
            ReservationEntryRec."Entry No." := 0;
            ReservationEntryRec.Validate("Source Type", 39);
            ReservationEntryRec.Validate("Source Subtype", 1);
            ReservationEntryRec.Validate("Source ID", POLineRec."Document No.");
            ReservationEntryRec.Validate("Source Ref. No.", POLineRec."Line No.");
            ReservationEntryRec.Validate("Item No.", POLineRec."No.");
            ReservationEntryRec.Validate("Location Code", POLineRec."Location Code");
            ReservationEntryRec.Validate("Reservation Status", ReservationEntryRec."Reservation Status"::Surplus);
            ReservationEntryRec.Validate("Item Tracking", ReservationEntryRec."Item Tracking"::"Lot No.");
            ReservationEntryRec.Validate("Lot No.", StagingRec."Batch Number");
            ReservationEntryRec.Validate("Expiration Date", StagingRec."Batch Expiry Date");
            ReservationEntryRec.Validate(Quantity, StagingRec."Bill Qty");
            ReservationEntryRec.Validate("Creation Date", Today);
            ReservationEntryRec.Validate("Expected Receipt Date", POLineRec."Expected Receipt Date");
            ReservationEntryRec.Validate("Created By", UserId);
            ReservationEntryRec.Validate(Positive, true);
            ReservationEntryRec.Validate("Qty. per Unit of Measure", StagingRec."Conversion Factor Decimal");
            ReservationEntryRec.Validate("Quantity (Base)", StagingRec."Bill Qty");
            ReservationEntryRec.Validate("Qty. to Handle (Base)", StagingRec."Bill Qty");
            ReservationEntryRec.Validate("Qty. to Invoice (Base)", StagingRec."Bill Qty");

            if ReservationEntryRec.Insert(true) then begin
                StagingRec."Purchase Order No. Updated" := POLineRec."Document No.";
                StagingRec."Purchase Line No. Updated" := POLineRec."Line No.";
                StagingRec."PO Updated" := true;
                StagingRec."PO Error" := false;
                StagingRec."Process Remarks" := '';
                StagingRec.Modify();
            end
            else begin
                StagingRec."Purchase Order No. Updated" := POLineRec."Document No.";
                StagingRec."Purchase Line No. Updated" := POLineRec."Line No.";
                StagingRec."PO Updated" := false;
                StagingRec."PO Error" := true;
                StagingRec."Process Remarks" := 'Error inserting reservation entry';
                StagingRec.Modify();
            end;
        end
        else begin
            StagingRec."PO Error" := true;
            StagingRec."Process Remarks" := 'Matching PO Line not found';
            StagingRec.Modify();
        end;
    end;

    procedure Cleanup()
    var
        ReservationEntryRec: Record "Reservation Entry";
    begin
        ReservationEntryRec.Reset;
        ReservationEntryRec.SetFilter("Entry No.", '%1|%2', 61880, 61881);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not ReservationEntryRec.IsEmpty then
            ReservationEntryRec.DeleteAll();
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        Message('Cleanup done');
    end;

    // YF        07 Oct 2021 

    // YF        25 Oct 2021 
    procedure CreateZPInvCRDocs() DocCreated: Integer;
    var
        ZLRec: Record "Zuellig Invoices";
        SalesInvDocNo: Code[20];
        SalesCRDocNo: Code[20];
    begin
        SalesInvDocNo := '';
        SalesCRDocNo := '';

        ZLRec.Reset;
        ZLRec.SetRange("Invoice Created", false);
        if ZLRec.FindSet() then
            repeat
                if ZLRec.Type = 'IV' then begin
                    // Handle Invoice Creation
                    if StrLen(SalesInvDocNo) <= 0 then
                        SalesInvDocNo := CreateSHRec(ZLRec);

                    if StrLen(SalesInvDocNo) > 0 then
                        CreateSLRec(ZLRec, SalesInvDocNo);

                    ZLRec."BC Invoice No." := SalesInvDocNo;
                end
                else begin
                    // Handle Credit Note Creation
                    if StrLen(SalesCRDocNo) <= 0 then
                        SalesCRDocNo := CreateSHRec(ZLRec);

                    if StrLen(SalesCRDocNo) > 0 then
                        CreateSLRec(ZLRec, SalesCRDocNo);

                    ZLRec."BC Invoice No." := SalesCRDocNo;
                end;

                // Status Updates
                ZLRec."Invoice Created" := true;
                ZLRec.Modify(true);
                DocCreated += 1;

            until ZLRec.Next() = 0;
    end;

    local procedure CreateSHRec(ZLInv: Record "Zuellig Invoices") DocNo: code[20]
    var
        SSSetup: Record "Sales & Receivables Setup";
        SHRec: Record "Sales Header";
    begin
        SSSetup.Reset;
        SSSetup.Get;
        SHRec.Reset;
        SHRec.Init;

        if ZLInv.Type = 'IV' then
            SHRec.Validate("Document Type", SHRec."Document Type"::Invoice)
        else
            SHRec.Validate("Document Type", SHRec."Document Type"::"Credit Memo");

        SHRec.Insert(true);

        SHRec.validate("Sell-to Customer No.", SSSetup."Zuellig Def. Inv/CR Cust. Code");
        SHRec.Validate("Document Date", ZLInv."Recorded Date");
        SHRec.Validate("Location Code", SSSetup."Def. ZP Invoice Loc. Code");
        SHRec.Modify(true);

        exit(SHRec."No.");
    end;

    local procedure CreateSLRec(ZPInv: Record "Zuellig Invoices"; lDocNo: code[20])
    var
        SLRec: Record "Sales Line";
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        EntryNo: Integer;
        SHRec: Record "Sales Header";
        LocRec: Record Location;
        SSSetup: Record "Sales & Receivables Setup";
        ILERec: Record "Item Ledger Entry";
    begin
        SSSetup.reset;
        SSSetup.get;
        SLRec.reset;
        SLRec.init;

        if ZPInv.Type = 'IV' then
            SLRec.Validate("Document Type", SLRec."Document Type"::Invoice)
        else
            SLRec.Validate("Document Type", SLRec."Document Type"::"Credit Memo");

        SLRec.Validate("Document No.", lDocNo);
        SLRec.Validate("Line No.", GetLineNo(lDocNo, ZPInv.Type));

        SLRec.Validate(Type, SLRec.Type::Item);
        SLRec.Validate("No.", GetItemCode(ZPInv."New Item No.")); // YF 22 Oct 2021

        SHRec.Reset;
        SHRec.SetRange("No.", SLRec."Document No.");
        SHRec.SetRange("Document Type", SLRec."Document Type");
        if SHRec.FindFirst() then begin
            SLRec.Validate("Location Code", SHRec."Location Code");
            LocRec.reset;
            LocRec.SetRange(Code, SHRec."Location Code");
            if LocRec.FindFirst() then begin
                if LocRec."Bin Mandatory" = true then
                    SLRec.Validate("Bin Code", SSSetup."Def. ZP Invoice Bin Code");
            end;
        end;

        SLRec.Validate(Quantity, abs(ZPInv."Trans Qty"));
        SLRec.Validate("Unit Price", ZPInv."Selling Price");

        // YF 22 Oct 2021
        SLRec."ZP Customer Name" := CopyStr(ZPInv."Customer Name", 1, 100);
        SLRec."ZP SP" := CopyStr(ZPInv."SP", 1, 50);
        SLRec."ZP Detailman" := CopyStr(ZPInv."Detailman", 1, 50);
        // YF 22 Oct 2021

        // YF 26 Oct 2021
        SLRec.Validate("Selling Price", ZPInv."Selling Price");
        SLRec.Validate("Order Qty", Abs(ZPInv."Trans Qty"));
        SLRec.Validate("Qty To Deliver", Abs(ZPInv."Trans Qty"));
        SLRec.Validate("PO Import Price", ZPInv."Selling Price");
        // YF 26 Oct 2021

        SLRec.insert(TRUE);

        //DX    01 Sept 2021

        ResEntry2.reset;
        if ResEntry2.FindLast() then begin
            EntryNo := ResEntry2."Entry No." + 1;
        end else begin
            EntryNo := 1;
        end;

        // YF 02 Nov 2021 // Bug Fix

        if ZPInv.Type = 'IV' then begin
            // Invoice
            ResEntry.Reset;
            ResEntry.Init;
            ResEntry."Entry No." := EntryNo;
            ResEntry."Item No." := SLRec."No.";
            ResEntry."Location Code" := SLRec."Location Code";
            ResEntry."Quantity (Base)" := -SLRec."Quantity (Base)";
            ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
            ResEntry."Creation Date" := today;
            ResEntry."Source Type" := 37;
            ResEntry."Source Subtype" := 2;
            ResEntry."Source ID" := SLRec."Document No.";
            ResEntry."Source Ref. No." := SLRec."Line No.";
            ResEntry."Expected Receipt Date" := Today;
            ResEntry."Created By" := UserId;
            ResEntry.Positive := false;
            ResEntry."Qty. per Unit of Measure" := 1;
            ResEntry.Quantity := -SLRec."Quantity";

            // ResEntry."Expiration Date" := ZPInv."Lot Expiry Date";
            ILERec.Reset;
            ILERec.SetRange("Lot No.", ZPInv."Lot No.");
            ILERec.SetCurrentKey("Entry No.");
            ILERec.SetAscending("Entry No.", false);
            if ILERec.FindFirst() then
                ResEntry."Expiration Date" := ILERec."Expiration Date"
            else
                ResEntry."Expiration Date" := ZPInv."Lot Expiry Date";

            ResEntry."Qty. to Handle (Base)" := -SLRec."Quantity (Base)";
            ResEntry."Qty. to Invoice (Base)" := -SLRec."Quantity (Base)";
            ResEntry."Lot No." := ZPInv."Lot No.";
            ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
            ResEntry.Insert(false);
        end
        else begin
            // Credit Memo
            ResEntry.Reset;
            ResEntry.Init;
            ResEntry."Entry No." := EntryNo;
            ResEntry."Item No." := SLRec."No.";
            ResEntry."Location Code" := SLRec."Location Code";
            ResEntry."Quantity (Base)" := SLRec."Quantity (Base)";
            ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
            ResEntry."Creation Date" := today;
            ResEntry."Source Type" := 37;
            ResEntry."Source Subtype" := 3;
            ResEntry."Source ID" := SLRec."Document No.";
            ResEntry."Source Ref. No." := SLRec."Line No.";
            ResEntry."Expected Receipt Date" := Today;
            ResEntry."Created By" := UserId;
            ResEntry.Positive := true;
            ResEntry."Qty. per Unit of Measure" := 1;
            ResEntry.Quantity := SLRec."Quantity";

            // ResEntry."Expiration Date" := ZPInv."Lot Expiry Date";
            ILERec.Reset;
            ILERec.SetRange("Lot No.", ZPInv."Lot No.");
            ILERec.SetCurrentKey("Entry No.");
            ILERec.SetAscending("Entry No.", false);
            if ILERec.FindFirst() then
                ResEntry."Expiration Date" := ILERec."Expiration Date"
            else
                ResEntry."Expiration Date" := ZPInv."Lot Expiry Date";

            ResEntry."Qty. to Handle (Base)" := SLRec."Quantity (Base)";
            ResEntry."Qty. to Invoice (Base)" := SLRec."Quantity (Base)";
            ResEntry."Lot No." := ZPInv."Lot No.";
            ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
            ResEntry.Insert(false);
        end;

        /*
        ResEntry.reset;
        ResEntry.init;
        ResEntry."Entry No." := EntryNo;
        ResEntry."Item No." := SLRec."No.";
        ResEntry."Location Code" := SLRec."Location Code";
        ResEntry."Quantity (Base)" := SLRec."Quantity (Base)";
        ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
        ResEntry."Creation Date" := today;
        ResEntry."Source Type" := 39;
        ResEntry."Source Subtype" := 1;
        ResEntry."Source ID" := SLRec."Document No.";
        ResEntry."Source Ref. No." := SLRec."Line No.";
        ResEntry."Expected Receipt Date" := Today;
        ResEntry."Created By" := UserId;
        ResEntry.Positive := true;
        ResEntry."Qty. per Unit of Measure" := 1;
        ResEntry.Quantity := SLRec."Quantity";
        ResEntry."Expiration Date" := ZPInv."Lot Expiry Date";
        ResEntry."Qty. to Handle (Base)" := SLRec."Quantity (Base)";
        ResEntry."Qty. to Invoice (Base)" := SLRec."Quantity (Base)";
        ResEntry."Lot No." := ZPInv."Lot No.";
        ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
        ResEntry.Insert(FALSE);
        */

        // YF 02 Nov 2021 // Bug Fix

        //DX    01 Sept 2021

    end;

    procedure GetLineNo(DocNo: code[20]; DocType: Text[30]) LineNo: Integer;
    var
        LSLRec: Record "Sales Line";
    begin
        LSLRec.reset;
        if doctype = 'IV' then
            LSLRec.SetRange("Document Type", LSLRec."Document Type"::Invoice)
        else
            LSLRec.SetRange("Document Type", LSLRec."Document Type"::"Credit Memo");
        LSLRec.SetRange("Document No.", DocNo);
        if LSLRec.FindLast() then
            exit(LSLRec."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetItemCode(CrossRefNo: code[20]) ItemCode: Code[20]
    var
        CrossRefRec: Record "Item Reference";
        ItemRec: Record Item;
        SSSetup: Record "Sales & Receivables Setup";
    begin
        SSSetup.Reset;
        SSSetup.Get;

        CrossRefRec.reset;
        CrossRefRec.SetRange("Reference Type", CrossRefRec."Reference Type"::Customer);
        CrossRefRec.SetRange("Reference Type No.", SSSetup."Zuellig Def. Inv/CR Cust. Code");
        CrossRefRec.SetRange("Reference No.", CrossRefNo);
        if CrossRefRec.FindFirst() then
            exit(CrossRefRec."Item No.");
    end;

    // YF        25 Oct 2021 
}