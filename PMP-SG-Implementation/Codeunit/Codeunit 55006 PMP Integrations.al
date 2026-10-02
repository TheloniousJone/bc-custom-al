codeunit 55006 "PMP Integrations"
{
    Permissions = TableData "Gen. Journal Line" = rimd, TableData "Cust. Ledger Entry" = rimd;

    procedure GetText(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Text
    begin
        if Buffer.Get(Row, Col) then
            exit(Buffer."Cell Value as Text");
    end;

    procedure GetDate(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        d: Date;
        dateval: DateTime;
        datevalOnly: Date;
        ImportString: text;
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if Buffer.Get(Row, Col) then begin
            //Evaluate(D, format(Buffer."Cell Value as Text", 0, 9));

            importstring := Buffer."Cell Value as Text";
            evaluate(Day, copystr(Importstring, 7, 2));
            evaluate(Month, copystr(Importstring, 5, 2));
            evaluate(Year, copystr(Importstring, 1, 4));
            datevalOnly := DMY2DATE(Day, Month, Year);
            exit(datevalOnly);

        end;
    end;

    procedure GetDateLot(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        d: Date;
        dateval: DateTime;
        datevalOnly: Date;
        ImportString: text;
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if Buffer.Get(Row, Col) then begin

            // importstring := Buffer."Cell Value as Text";
            // evaluate(Day, copystr(Importstring, 1, 2));
            // evaluate(Month, copystr(Importstring, 4, 3));
            // evaluate(Year, copystr(Importstring, 7, 4));
            // datevalOnly := DMY2DATE(Day, Month, Year);

            exit(datevalOnly);
        end;
    end;

    procedure GetDecimal(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Decimal
    var
        d: Decimal;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(d, Buffer."Cell Value as Text");
            exit(d);
        end;
    end;

    procedure GetCode(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Code[20]
    var
        c: Code[20];
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(c, Buffer."Cell Value as Text");
            exit(c);
        end;
    end;

    procedure GetInteger(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Integer
    var
        i: Integer;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(i, Buffer."Cell Value as Text");
            exit(i);
        end;
    end;

    procedure GetBoolean(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Boolean
    var
        b: Boolean;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(b, Buffer."Cell Value as Text");
            exit(b);
        end;
    end;

    trigger OnRun()
    begin

    end;

    procedure ImportZLInvoices()
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        Data: Record "Zuellig Invoices";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
    begin
        FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";
        ImportCount := 0;
        for row := 2 to LastRow do begin
            // if NOT (ZLInvDocNoExists(x.GetCode(Buffer, 2, Row))) then begin // YF 02 Nov 2021 // Bug Fix
            Data.Init();
            Data."Entry No." := GetLastZLInvEntry();
            Data."Type" := x.GetText(Buffer, 1, Row);
            Data."Doc No." := x.GetCode(Buffer, 2, Row);
            Data."PO No." := x.GetCode(Buffer, 3, Row);
            Data."Recorded Date" := x.GetDate(Buffer, 4, Row);
            Data."New Customer No." := x.GetCode(Buffer, 5, Row);
            Data."Customer No." := x.GetCode(Buffer, 6, Row);
            Data."Customer Name" := x.GetText(Buffer, 7, Row);
            Data."Type 2" := x.GetCode(Buffer, 8, Row);
            Data."New Item No." := x.GetCode(Buffer, 9, Row);
            Data."Item No." := x.GetCode(Buffer, 10, Row);
            Data."Item Description" := x.GetText(Buffer, 11, Row);
            Data."Trans Qty" := x.getInteger(Buffer, 12, Row);
            Data."Selling Price" := x.GetDecimal(Buffer, 13, Row);
            Data."Trans Value" := x.GetDecimal(Buffer, 14, Row);
            Data.SP := x.GetText(Buffer, 15, Row);
            Data.Detailman := x.GetCode(Buffer, 16, Row);
            Data.Year := x.GetInteger(Buffer, 17, Row);
            Data.Month := x.GetInteger(Buffer, 18, Row);
            Data.Quarter := x.GetCode(Buffer, 19, Row);
            Data."Lot No." := x.GetCode(Buffer, 20, Row);
            Data."Lot Expiry Date" := x.GetDateFromDMY(Buffer, 21, Row);
            Data."Reason For Return" := x.GetText(Buffer, 22, Row);
            Data."Business Division 4" := x.GetText(Buffer, 23, Row);
            Data."Business Division 5" := x.GetText(Buffer, 24, Row);
            Data.Distributor := x.GetCode(Buffer, 25, Row);
            Data."Invoice Created" := x.getBoolean(Buffer, 26, Row);
            Data.Insert(true);
            ImportCount += 1;
            // end; // YF 02 Nov 2021 // Bug Fix

        end;
        if ImportCount <> 0 then
            Message('%1 invoices imported.', ImportCount);
    end;

    local procedure GetLastZLInvEntry() LastEntryNo: Integer
    var
        myInt: Integer;
        ZLInv: Record "Zuellig Invoices";
    begin
        ZLInv.reset;
        if ZLInv.count = 0 then
            exit(1)
        else begin
            if ZLInv.FindLast() then begin
                exit(ZLInv."Entry No." + 1);

            end;
        end;
    end;

    local procedure ZLInvDocNoExists(DocNo: Code[20]) doesExist: Boolean
    var
        myInt: Integer;
        ZLInv: Record "Zuellig Invoices";
    begin
        ZLInv.reset;
        ZLInv.SetRange("Doc No.", DocNo);
        if ZLInv.FindFirst() then
            exit(True)
        else
            exit(FALSE);
    end;

    /*
    // YF 26 Oct 2021 // To retire
    procedure CreateDocuments() DocCreated: Integer;
    var
        myInt: Integer;
        SHRec: Record "Sales Header";

        ZLRec: Record "Zuellig Invoices";
        DocNo: code[20];
    begin
        ZLRec.reset;
        ZLRec.SetRange("Invoice Created", false);
        if ZLRec.FindSet() then
            repeat
                if NOT (DocExist(ZLRec."Doc No.")) then begin
                    DocNo := CreateSHRec(ZLRec);
                    CreateSLRec(ZLRec, DocNo);
                end else begin
                    SHRec.reset;
                    SHRec.SetRange("External Document No.", ZLRec."Doc No.");
                    if SHRec.FindFirst() then
                        CreateSLRec(ZLRec, SHRec."No.");
                end;
                ZLRec."Invoice Created" := true;
                ZLRec."BC Invoice No." := SHRec."No.";
                ZLRec.Modify(true);
                DocCreated += 1;
            until ZLRec.next = 0;

    end;

    local procedure CreateSHRec(ZLInv: Record "Zuellig Invoices") DocNo: code[20]
    var
        SSSetup: Record "Sales & Receivables Setup";
        SHRec: Record "Sales Header";
    begin
        SSSetup.reset;
        SSSetup.get;
        SHRec.reset;
        SHRec.init;
        if ZLInv.Type = 'IV' then
            SHRec.Validate("Document Type", SHRec."Document Type"::Invoice)
        else
            SHRec.Validate("Document Type", SHRec."Document Type"::"Credit Memo");
        SHRec.Insert(true);

        // SHRec.validate("Sell-to Customer No.", ZLInv."New Customer No."); // YF 22 Oct 2021
        SHRec.validate("Sell-to Customer No.", SSSetup."Zuellig Def. Inv/CR Cust. Code"); // YF 22 Oct 2021
        SHRec.Validate("Document Date", ZLInv."Recorded Date");
        SHRec.Validate("Location Code", SSSetup."Def. ZP Invoice Loc. Code");
        SHRec.Validate("External Document No.", ZLInv."Doc No.");
        // SHRec.Validate("Salesperson Code", ZLInv.SP);
        SHRec.Modify(true);

        exit(SHRec."No.");
    end;

    local procedure CreateSLRec(ZPInv: Record "Zuellig Invoices"; lDocNo: code[20])
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        EntryNo: Integer;
        SHRec: Record "Sales Header";
        LocRec: Record Location;
        SSSetup: Record "Sales & Receivables Setup";
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
        SLRec.validate("Line No.", GetLineNo(lDocNo, ZPInv.Type));
        SHRec.reset;
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

        SLRec.Validate(Type, SLRec.Type::Item);
        // SLRec.Validate("No.", GetItemCode(ZPInv."Item No.")); // YF 22 Oct 2021
        SLRec.Validate("No.", GetItemCode(ZPInv."New Item No.")); // YF 22 Oct 2021
        SLRec.Validate(Quantity, abs(ZPInv."Trans Qty"));
        SLRec.Validate("Unit Price", ZPInv."Selling Price");

        // YF 22 Oct 2021
        SLRec."ZP Customer Name" := CopyStr(ZPInv."Customer Name", 1, 100);
        SLRec."ZP SP" := CopyStr(ZPInv."SP", 1, 50);
        SLRec."ZP Detailman" := CopyStr(ZPInv."Detailman", 1, 50);
        // YF 22 Oct 2021

        SLRec.insert(TRUE);

        //DX    01 Sept 2021

        ResEntry2.reset;
        if ResEntry2.FindLast() then begin
            EntryNo := ResEntry2."Entry No." + 1;
        end else begin
            EntryNo := 1;
        end;
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

        //DX    01 Sept 2021

    end;


    local procedure GetItemCode(CrossRefNo: code[20]) ItemCode: Code[20]
    var
        CrossRefRec: Record "Item Reference";
        ItemRec: Record item;
    begin
        CrossRefRec.reset;
        CrossRefRec.SetRange("Reference Type", CrossRefRec."Reference Type"::Customer);
        CrossRefRec.SetRange("Reference Type No.", 'Z004'); // YF 22 Oct 2021
        CrossRefRec.SetRange("Reference No.", CrossRefNo);
        if CrossRefRec.FindFirst() then
            exit(CrossRefRec."Item No.");
    end;

    local procedure DocExist(DocNo: Code[20]) DoesExist: Boolean
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        CLERec: Record "Cust. Ledger Entry";
    begin
        SHRec.reset;
        SHRec.SetRange("External Document No.", DocNo);
        if SHRec.FindFirst() then
            exit(true);

        CLERec.reset;
        CLERec.SetRange("External Document No.", DocNo);
        if CLERec.FindFirst() then
            exit(TRUE);


        exit(FALSE);
    end;

    procedure GetLineNo(DocNo: code[20]; DocType: Text[30]) LineNo: Integer;
    var
        myInt: Integer;
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

    var
        myInt: Integer;



    //DX        12 Sept 2021

    procedure ImportGuardianReceipts(GenJournalName: Code[10])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        CSVBuffer: Record "CSV Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        //Data: Record "Zuellig Invoices";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustRec: Record customer;
        SetApp: Codeunit "Cust. Entry-SetAppl.ID";
        LineAmt: Decimal;
        CLERec: Record "Cust. Ledger Entry";
        ExtDocNo: Code[35];
        CLEDocNo: Code[35];
        CellAmount: Decimal;
        GenTemplateName: Label 'CASHRCPT';
        GenJnlBatch: Record "Gen. Journal Batch";

        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);
        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");
        FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        //SheetName := Buffer.SelectSheetsNameStream(ImportStream);
        CSVBuffer.DeleteAll();
        CSVBuffer.LoadDataFromStream(ImportStream, ',');

        if CSVBuffer.Count <> 0 then begin
            NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            GenJnlRec.reset;
            GenJnlRec.init;
            GenJnlRec.Validate("Journal Template Name", GenTemplateName);
            GenJnlRec.Validate("Journal Batch Name", GenJournalName);
            GenJnlRec.Validate("Line No.", GetNextLineNo(GenJournalName));
            GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
            GenJnlRec.Validate("Posting Date", WorkDate());
            GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::Customer);
            GenJnlRec.Validate("Account No.", 'G035HQ');
            GenJnlRec.Validate("Document No.", DocNo);
            //GenJnlRec.Validate(Amount, x.GetDecimal(Buffer, 4, Row));
            GenJnlRec.Validate("Bal. Account Type", GenJnlRec."Bal. Account Type"::"Bank Account");
            GenJnlRec.Validate("Bal. Account No.", 'DBS');
            GenJnlRec.insert(true);
        end;

        ApplyingCustLedgEntry."Entry No." := 1;
        ApplyingCustLedgEntry."Posting Date" := GenJnlRec."Posting Date";
        ApplyingCustLedgEntry."Document Type" := GenJnlRec."Document Type";
        ApplyingCustLedgEntry."Document No." := GenJnlRec."Document No.";
        IF GenJnlRec."Bal. Account Type" = GenJnlRec."Account Type"::Customer THEN BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Bal. Account No.";
            CustRec.GET(GenJnlRec."Account No.");
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END ELSE BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Account No.";
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END;
        ApplyingCustLedgEntry."Currency Code" := GenJnlRec."Currency Code";
        ApplyingCustLedgEntry.Amount := GenJnlRec.Amount;
        ApplyingCustLedgEntry."Remaining Amount" := GenJnlRec.Amount;


        if CSVBuffer.FindSet() then
            repeat

                if (CSVBuffer."Line No." <> LastRow) And (CellAmount <> 0) then begin
                    CLERec.reset;
                    CLERec.SetRange("Customer No.", 'G035HQ');

                    if CellAmount > 0 then
                        CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
                    else
                        CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");

                    CLERec.SetRange("Document No.", CLEDocNo);
                    CLERec.SetRange("External Document No.", ExtDocNo);
                    CLERec.CalcFields("Remaining Amount");
                    if CLERec.FindFirst() then begin
                        SetApp.SetApplId(CLERec, ApplyingCustLedgEntry, GenJnlRec."Document No.");
                        ImportCount += 1;
                    end;

                    LineAmt += CellAmount;

                    ExtDocNo := '';
                    CellAmount := 0;
                    CLEDocNo := '';
                end;


                if CSVBuffer."Line No." > 20 then begin
                    //  Grab data
                    case CSVBuffer."Field No." of
                        3:
                            ExtDocNo := GetCSVTextValue(CSVBuffer.Value);
                        4:
                            CLEDocNo := GetCSVTextValue(CSVBuffer.Value);
                        9:
                            CellAmount := GetCSVDecimalValue(CSVBuffer.Value, 0);
                    end;
                end;

            until CSVBuffer.next = 0;

        if (LastRow <> 20) And (CellAmount <> 0) then begin
            CLERec.reset;
            CLERec.SetRange("Customer No.", 'G035HQ');

            if CellAmount > 0 then
                CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
            else
                CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");

            CLERec.SetRange("Document No.", CLEDocNo);
            CLERec.SetRange("External Document No.", ExtDocNo);
            CLERec.CalcFields("Remaining Amount");
            if CLERec.FindFirst() then begin
                SetApp.SetApplId(CLERec, ApplyingCustLedgEntry, GenJnlRec."Document No.");
                ImportCount += 1;
            end;

            LineAmt += CellAmount;

            ExtDocNo := '';
            CellAmount := 0;
            CLEDocNo := '';
        end;

        GenJnlRec."External Document No." := '';
        GenJnlRec.Validate(Amount, LineAmt * -1);

        if ImportCount > 0 then
            GenJnlRec.Validate("Applies-to ID", GenJnlRec."Document No.");

        GenJnlRec.Modify(TRUE);

        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);
    end;
    // YF 26 Oct 2021 // To retire
    */

    local procedure GetCSVTextValue(String: Text[250]): Text
    begin
        exit(String.TrimStart('"').TrimEnd('"'));
    end;

    local procedure GetCSVDateValue(String: Text[250]; DefaultValue: Date): Date
    var
        DateText: Text;
        DateValue: Date;
    begin
        DateValue := DefaultValue;
        DateText := GetCSVTextValue(String);
        if DateText = '' then
            DateValue := DefaultValue
        else
            if not Evaluate(DateValue, DateText) then
                DateValue := DefaultValue;
        exit(DateValue);
    end;

    local procedure GetCSVDecimalValue(String: Text[250]; DefaultValue: Decimal): Decimal
    var
        DecimalText: Text;
        DecimalValue: Decimal;
    begin
        DecimalValue := DefaultValue;
        DecimalText := GetCSVTextValue(String);
        if DecimalText = '' then
            DecimalValue := DefaultValue
        else
            if not Evaluate(DecimalValue, DecimalText) then
                DecimalValue := DefaultValue;
        exit(DecimalValue);
    end;


    local procedure GetNextLineNo(GenJournalBatch: Code[10]): Integer
    var
        myInt: Integer;
        GenJnl: Record "Gen. Journal Line";
    begin
        GenJnl.reset;
        GenJnl.SetRange("Journal Template Name", 'CASHRCPT');
        GenJnl.SetRange("Journal Batch Name", GenJournalBatch);
        if GenJnl.FindLast() then
            exit(GenJnl."Line No." + 10000)
        else
            exit(10000);
    end;

    /*
    // YF 26 Oct 2021 // To retire
    procedure ImportNTUC(GenJournalName: Code[10])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        //Data: Record "Zuellig Invoices";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustRec: Record customer;
        SetApp: Codeunit "Cust. Entry-SetAppl.ID";
        LineAmt: Decimal;
        CLERec: Record "Cust. Ledger Entry";
        ExtDocNo: Code[35];
        GenJnlBatch: Record 232;
        GenTemplateName: Label 'CASHRCPT';
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);
        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");
        FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();

        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";
        ImportCount := 0;
        if Buffer.Count <> 0 then begin
            NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            GenJnlRec.reset;
            GenJnlRec.init;
            GenJnlRec.Validate("Journal Template Name", GenTemplateName);
            GenJnlRec.Validate("Journal Batch Name", GenJournalName);
            GenJnlRec.Validate("Line No.", GetNextLineNo(GenJournalName));
            GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
            GenJnlRec.Validate("Posting Date", WorkDate());
            GenJnlRec.Validate("Document No.", DocNo);
            GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::Customer);
            GenJnlRec.Validate("Account No.", 'N043HQ');
            //GenJnlRec.Validate(Amount, x.GetDecimal(Buffer, 4, Row));
            GenJnlRec.Validate("Bal. Account Type", GenJnlRec."Bal. Account Type"::"Bank Account");
            GenJnlRec.Validate("Bal. Account No.", 'DBS');
            GenJnlRec.insert(true);
        end;

        ApplyingCustLedgEntry."Entry No." := 1;
        ApplyingCustLedgEntry."Posting Date" := GenJnlRec."Posting Date";
        ApplyingCustLedgEntry."Document Type" := GenJnlRec."Document Type";
        ApplyingCustLedgEntry."Document No." := GenJnlRec."Document No.";
        IF GenJnlRec."Bal. Account Type" = GenJnlRec."Account Type"::Customer THEN BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Bal. Account No.";
            CustRec.GET(GenJnlRec."Account No.");
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END ELSE BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Account No.";
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END;
        ApplyingCustLedgEntry."Currency Code" := GenJnlRec."Currency Code";
        ApplyingCustLedgEntry.Amount := GenJnlRec.Amount;
        ApplyingCustLedgEntry."Remaining Amount" := GenJnlRec.Amount;
        for row := 2 to LastRow do begin
            ExtDocNo := x.GetText(Buffer, 3, Row);
            CLERec.reset;
            CLERec.SetRange("Customer No.", 'N043HQ');
            if x.GetDecimal(Buffer, 6, Row) > 0 then
                CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
            else
                CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");
            //CLERec.SetRange("Document No.", x.GetText(Buffer, 2, Row));
            CLERec.SetRange("External Document No.", x.GetText(Buffer, 3, Row));
            CLERec.CalcFields("Remaining Amount");
            if CLERec.FindFirst() then begin
                ImportCount += 1;
                //LineAmt += CLERec."Remaining Amount";
                SetApp.SetApplId(CLERec, ApplyingCustLedgEntry, GenJnlRec."Document No.");
            end;
            LineAmt += x.GetDecimal(Buffer, 6, Row);
        end;
        GenJnlRec."External Document No." := '';
        GenJnlRec.Validate(Amount, LineAmt * -1);

        if ImportCount > 0 then
            GenJnlRec.Validate("Applies-to ID", GenJnlRec."Document No.");

        GenJnlRec.Modify(TRUE);
        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);
    end;


    procedure ImportWatsons(GenJournalName: Code[10])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        //Data: Record "Zuellig Invoices";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustRec: Record customer;
        SetApp: Codeunit "Cust. Entry-SetAppl.ID";
        LineAmt: Decimal;
        CLERec: Record "Cust. Ledger Entry";
        ExtDocNo: Code[35];
        GenTemplateName: label 'CASHRCPT';
        GenJnlBatch: Record 232;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;

        TempUnappliedRec: Record "LS Ledger Entry" temporary;
    begin
        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);
        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");

        ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);


        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        if Buffer.Count <> 0 then begin
            NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            GenJnlRec.reset;
            GenJnlRec.init;
            GenJnlRec.Validate("Journal Template Name", GenTemplateName);
            GenJnlRec.Validate("Journal Batch Name", GenJournalName);
            GenJnlRec.Validate("Line No.", GetNextLineNo(GenJournalName));
            GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
            GenJnlRec.Validate("Posting Date", WorkDate());
            GenJnlRec.Validate("Document No.", DocNo);
            GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::Customer);
            GenJnlRec.Validate("Account No.", 'W003888');
            GenJnlRec.Validate("Bal. Account Type", GenJnlRec."Bal. Account Type"::"Bank Account");
            GenJnlRec.Validate("Bal. Account No.", 'DBS');
            GenJnlRec.insert(true);
        end;
        ImportCount := 0;
        ApplyingCustLedgEntry."Entry No." := 1;
        ApplyingCustLedgEntry."Posting Date" := GenJnlRec."Posting Date";
        ApplyingCustLedgEntry."Document Type" := GenJnlRec."Document Type";
        ApplyingCustLedgEntry."Document No." := GenJnlRec."Document No.";
        IF GenJnlRec."Bal. Account Type" = GenJnlRec."Account Type"::Customer THEN BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Bal. Account No.";
            CustRec.GET(GenJnlRec."Account No.");
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END ELSE BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Account No.";
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END;
        ApplyingCustLedgEntry."Currency Code" := GenJnlRec."Currency Code";
        ApplyingCustLedgEntry.Amount := GenJnlRec.Amount;
        ApplyingCustLedgEntry."Remaining Amount" := GenJnlRec.Amount;
        for row := 4 to LastRow do begin
            ExtDocNo := x.GetText(Buffer, 3, Row);

            CLERec.reset;
            CLERec.SetRange("Customer No.", 'W003888');

            if x.GetDecimal(Buffer, 8, Row) < 0 then
                CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
            else
                CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");

            CLERec.SetRange("Document No.", x.GetText(Buffer, 3, Row));
            CLERec.CalcFields("Remaining Amount");

            if CLERec.FindFirst() then begin
                SetApp.SetApplId(CLERec, ApplyingCustLedgEntry, GenJnlRec."Document No.");
                //LineAmt += CLERec."Remaining Amount";
                ImportCount += 1;
            end
            else begin
                if StrLen(ExtDocNo) > 0 then begin
                    TempUnappliedRec.Init;
                    TempUnappliedRec."Entry No." := Row;
                    TempUnappliedRec."Document No." := x.GetText(Buffer, 3, Row);
                    TempUnappliedRec."Line Amount" := x.GetDecimal(Buffer, 8, Row);
                    TempUnappliedRec."Item Description" := ImportFilename;
                    TempUnappliedRec."Customer Name" := SheetName;
                    TempUnappliedRec.Insert();
                end;
            end;

            if StrLen(ExtDocNo) > 0 then begin
                LineAmt += x.GetDecimal(Buffer, 8, Row);
            end;

        end;

        // Reverse the sign
        LineAmt := LineAmt * -1;

        GenJnlRec."External Document No." := '';
        GenJnlRec.Validate(Amount, LineAmt);
        //GenJnlRec.Validate(Amount, x.GetDecimal(Buffer, 4, Row));

        if ImportCount > 0 then
            GenJnlRec.Validate("Applies-to ID", GenJnlRec."Document No.");

        GenJnlRec.Modify(TRUE);
        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);

        // Show List of Unapplied
        if TempUnappliedRec.Count > 0 then
            Page.Run(55085, TempUnappliedRec);

    end;
    //DX        12 Sept 2021


    procedure ImportGuardianV2(GenJournalName: Code[10])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        //Data: Record "Zuellig Invoices";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustRec: Record customer;
        SetApp: Codeunit "Cust. Entry-SetAppl.ID";
        LineAmt: Decimal;
        CLERec: Record "Cust. Ledger Entry";
        ExtDocNo: Code[35];
        GenTemplateName: label 'CASHRCPT';
        GenJnlBatch: Record 232;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;

        TempUnappliedRec: Record "LS Ledger Entry" temporary;
    begin
        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);
        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");

        ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);


        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        if Buffer.Count <> 0 then begin
            NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            GenJnlRec.reset;
            GenJnlRec.init;
            GenJnlRec.Validate("Journal Template Name", GenTemplateName);
            GenJnlRec.Validate("Journal Batch Name", GenJournalName);
            GenJnlRec.Validate("Line No.", GetNextLineNo(GenJournalName));
            GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
            GenJnlRec.Validate("Posting Date", WorkDate());
            GenJnlRec.Validate("Document No.", DocNo);
            GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::Customer);
            GenJnlRec.Validate("Account No.", 'G035HQ');
            GenJnlRec.Validate("Bal. Account Type", GenJnlRec."Bal. Account Type"::"Bank Account");
            GenJnlRec.Validate("Bal. Account No.", 'DBS');
            GenJnlRec.insert(true);
        end;

        ImportCount := 0;

        ApplyingCustLedgEntry."Entry No." := 1;
        ApplyingCustLedgEntry."Posting Date" := GenJnlRec."Posting Date";
        ApplyingCustLedgEntry."Document Type" := GenJnlRec."Document Type";
        ApplyingCustLedgEntry."Document No." := GenJnlRec."Document No.";
        IF GenJnlRec."Bal. Account Type" = GenJnlRec."Account Type"::Customer THEN BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Bal. Account No.";
            CustRec.GET(GenJnlRec."Account No.");
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END ELSE BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Account No.";
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END;
        ApplyingCustLedgEntry."Currency Code" := GenJnlRec."Currency Code";
        ApplyingCustLedgEntry.Amount := GenJnlRec.Amount;
        ApplyingCustLedgEntry."Remaining Amount" := GenJnlRec.Amount;

        for Row := 21 to LastRow do begin
            ExtDocNo := x.GetText(Buffer, 4, Row);

            CLERec.reset;
            CLERec.SetRange("Customer No.", 'G035HQ');

            if x.GetDecimal(Buffer, 9, Row) < 0 then
                CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
            else
                CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");

            CLERec.SetRange("Document No.", x.GetText(Buffer, 4, Row));
            CLERec.CalcFields("Remaining Amount");

            if CLERec.FindFirst() then begin
                SetApp.SetApplId(CLERec, ApplyingCustLedgEntry, GenJnlRec."Document No.");
                //LineAmt += CLERec."Remaining Amount";
                ImportCount += 1;
            end
            else begin
                if StrLen(ExtDocNo) > 0 then begin
                    TempUnappliedRec.Init;
                    TempUnappliedRec."Entry No." := Row;
                    TempUnappliedRec."Document No." := x.GetText(Buffer, 4, Row);
                    TempUnappliedRec."Line Amount" := x.GetDecimal(Buffer, 9, Row);
                    TempUnappliedRec."Item Description" := ImportFilename;
                    TempUnappliedRec."Customer Name" := SheetName;
                    TempUnappliedRec.Insert();
                end;
            end;

            if StrLen(ExtDocNo) > 0 then begin
                LineAmt += x.GetDecimal(Buffer, 9, Row);
            end;

        end;

        // Reverse the sign
        LineAmt := LineAmt * -1;

        GenJnlRec."External Document No." := '';
        GenJnlRec.Validate(Amount, LineAmt);
        //GenJnlRec.Validate(Amount, x.GetDecimal(Buffer, 4, Row));

        if ImportCount > 0 then
            GenJnlRec.Validate("Applies-to ID", GenJnlRec."Document No.");

        GenJnlRec.Modify(TRUE);
        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);

        // Show List of Unapplied
        if TempUnappliedRec.Count > 0 then
            Page.Run(55085, TempUnappliedRec);

    end;
    // YF 26 Oct 2021 // To retire
    */

    procedure ImportChainPayments(GenJournalName: Code[10]; ChainCode: Code[20])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustRec: Record customer;
        SetApp: Codeunit "Cust. Entry-SetAppl.ID";
        LineAmt: Decimal;
        CLERec: Record "Cust. Ledger Entry";
        ExtDocNo: Code[35];
        GenTemplateName: label 'CASHRCPT';
        GenJnlBatch: Record 232;
        DocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        CustNo: Code[20];

        TempUnappliedRec: Record "LS Ledger Entry" temporary;

        RemainingAmt: Decimal;
    begin
        if ChainCode = 'GUARDIAN' then
            CustNo := 'G035HQ';

        if ChainCode = 'NTUC' then
            CustNo := 'N043HQ';

        if ChainCode = 'WATSON' then
            CustNo := 'W003888';

        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);

        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");

        ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        if Buffer.Count <> 0 then begin
            // NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");            
            DocNo := NoSeries.GetNextNo(GenJnlBatch."No. Series", WorkDate());

            GenJnlRec.reset;
            GenJnlRec.init;
            GenJnlRec.Validate("Journal Template Name", GenTemplateName);
            GenJnlRec.Validate("Journal Batch Name", GenJournalName);
            GenJnlRec.Validate("Line No.", GetNextLineNo(GenJournalName));
            GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
            GenJnlRec.Validate("Posting Date", WorkDate());
            GenJnlRec.Validate("Document No.", DocNo);
            GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::Customer);
            GenJnlRec.Validate("Account No.", CustNo);
            GenJnlRec.Validate("Bal. Account Type", GenJnlRec."Bal. Account Type"::"Bank Account");
            GenJnlRec.Validate("Bal. Account No.", 'DBS');
            GenJnlRec.insert(true);
        end;

        ImportCount := 0;

        ApplyingCustLedgEntry."Entry No." := 1;
        ApplyingCustLedgEntry."Posting Date" := GenJnlRec."Posting Date";
        ApplyingCustLedgEntry."Document Type" := GenJnlRec."Document Type";
        ApplyingCustLedgEntry."Document No." := GenJnlRec."Document No.";
        IF GenJnlRec."Bal. Account Type" = GenJnlRec."Account Type"::Customer THEN BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Bal. Account No.";
            CustRec.GET(GenJnlRec."Account No.");
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END ELSE BEGIN
            ApplyingCustLedgEntry."Customer No." := GenJnlRec."Account No.";
            ApplyingCustLedgEntry.Description := GenJnlRec.Description;
        END;
        ApplyingCustLedgEntry."Currency Code" := GenJnlRec."Currency Code";
        ApplyingCustLedgEntry.Amount := GenJnlRec.Amount;
        ApplyingCustLedgEntry."Remaining Amount" := GenJnlRec.Amount;

        Clear(RemainingAmt);

        for Row := 2 to LastRow do begin
            ExtDocNo := x.GetCode(Buffer, 2, Row);

            CLERec.Reset;
            CLERec.SetRange("Customer No.", CustNo);

            if x.GetDecimal(Buffer, 4, Row) > 0 then
                CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
            else
                CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");

            CLERec.SetRange("Document No.", ExtDocNo);
            // CLERec.CalcFields("Remaining Amount");

            if CLERec.FindFirst() then begin
                //RL 07 Feb 2023
                // SetApp.SetApplId(CLERec, ApplyingCustLedgEntry, GenJnlRec."Document No.");
                CLERec."Applies-to ID" := GenJnlRec."Document No.";
                CLERec.MODIFY(false);
                CLERec.CalcFields("Remaining Amount");
                if CLERec."Remaining Amount" > x.GetDecimal(Buffer, 4, Row) then begin
                    CLERec."Amount to Apply" := x.GetDecimal(Buffer, 4, Row);
                end else begin
                    CLERec."Amount to Apply" := CLERec."Remaining Amount";
                    RemainingAmt += (x.GetDecimal(Buffer, 4, Row) - CLERec."Remaining Amount");
                end;

                CLERec.MODIFY(TRUE);
                //RL 07 Feb 2023

                // LineAmt += CLERec."Remaining Amount";

                // CLERec."Applies-to ID" := GenJnlRec."Document No.";
                // CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", CLERec);
                ImportCount += 1;
            end
            else begin
                if StrLen(ExtDocNo) > 0 then begin
                    TempUnappliedRec.Init;
                    TempUnappliedRec."Entry No." := Row;
                    TempUnappliedRec."Document No." := x.GetText(Buffer, 2, Row);
                    TempUnappliedRec."Line Amount" := x.GetDecimal(Buffer, 4, Row);
                    TempUnappliedRec."Item Description" := ImportFilename;
                    TempUnappliedRec."Customer Name" := SheetName;
                    TempUnappliedRec.Insert();
                end;
            end;

            if StrLen(ExtDocNo) > 0 then begin
                LineAmt += x.GetDecimal(Buffer, 4, Row);
            end;

        end;

        // Reverse the sign
        LineAmt := (LineAmt - RemainingAmt) * -1;

        GenJnlRec."External Document No." := '';
        GenJnlRec.Validate(Amount, LineAmt);

        if ImportCount > 0 then
            GenJnlRec.Validate("Applies-to ID", GenJnlRec."Document No.");

        GenJnlRec.Modify(TRUE);

        if RemainingAmt <> 0 then begin
            Clear(DocNo);
            // NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            DocNo := NoSeries.GetNextNo(GenJnlBatch."No. Series", WorkDate());

            GenJnlRec.reset;
            GenJnlRec.init;
            GenJnlRec.Validate("Journal Template Name", GenTemplateName);
            GenJnlRec.Validate("Journal Batch Name", GenJournalName);
            GenJnlRec.Validate("Line No.", GetNextLineNo(GenJournalName));
            GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
            GenJnlRec.Validate("Posting Date", WorkDate());
            GenJnlRec.Validate("Document No.", DocNo);
            GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::Customer);
            GenJnlRec.Validate("Account No.", CustNo);
            GenJnlRec.Validate("Bal. Account Type", GenJnlRec."Bal. Account Type"::"Bank Account");
            GenJnlRec.Validate("Bal. Account No.", 'DBS');
            GenJnlRec.insert(true);
            RemainingAmt *= -1;
            GenJnlRec."External Document No." := '';
            GenJnlRec.Validate(Amount, RemainingAmt);
            GenJnlRec.Modify(TRUE);
        end;

        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);

        // Show List of Unapplied
        if TempUnappliedRec.Count > 0 then
            Page.Run(55085, TempUnappliedRec);

    end;

    // YF 26 Oct 2021 // BIPO Imports
    procedure ImportBIPOHREntries(GenJournalName: Code[10])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        LineAmt: Decimal;
        GenTemplateName: Label 'GENERAL';
        GenJnlBatch: Record 232;
        DocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        Dim3Code: Code[20];
        DialogPage: Page "Generic Input Dialog";
        PostingDate: Date;
    begin

        Clear(DialogPage);
        PostingDate := WorkDate();
        DialogPage.SetPostingDateVisible(true);
        DialogPage.SetDefaultPostingDate(WorkDate());

        if DialogPage.RunModal() = Action::OK then
            PostingDate := DialogPage.GetPostingDate()
        else begin
            Message('Posting Date Input cancelled');
            exit;
        end;

        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);

        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");

        ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        if Buffer.Count <> 0 then begin
            // NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            DocNo := NoSeries.GetNextNo(GenJnlBatch."No. Series", WorkDate());
        end;

        ImportCount := 0;

        for Row := 2 to LastRow do begin

            Dim3Code := x.GetCode(Buffer, 1, Row);

            if StrLen(Dim3Code) > 0 then begin
                GenJnlRec.Reset;
                GenJnlRec.Init;
                GenJnlRec.Validate("Journal Template Name", GenTemplateName);
                GenJnlRec.Validate("Journal Batch Name", GenJournalName);
                GenJnlRec.Validate("Line No.", GetJournalNextLineNo(GenJournalName, GenTemplateName));
                // GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
                GenJnlRec.Validate("Posting Date", PostingDate);
                GenJnlRec.Validate("Document No.", DocNo);
                GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::"G/L Account");
                GenJnlRec.Validate("Account No.", x.GetText(Buffer, 3, Row));
                GenJnlRec.Insert(true);

                GenJnlRec.Validate("Shortcut Dimension 2 Code", x.GetCode(Buffer, 6, Row));
                GenJnlRec.ValidateShortcutDimCode(3, Dim3Code);
                if x.GetDecimal(Buffer, 10, Row) > 0 then
                    GenJnlRec.Validate("Debit Amount", x.GetDecimal(Buffer, 10, Row));
                if x.GetDecimal(Buffer, 11, Row) > 0 then
                    GenJnlRec.Validate("Credit Amount", x.GetDecimal(Buffer, 11, Row));
                GenJnlRec.Description := x.GetText(Buffer, 4, Row);
                GenJnlRec.Modify(true);

                ImportCount += 1;
            end;

        end;

        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);

    end;

    procedure ImportBIPOExpenseEntries(GenJournalName: Code[10])
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        LineAmt: Decimal;
        GenTemplateName: Label 'GENERAL';
        GenJnlBatch: Record 232;
        DocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        GLSetup: Record "General Ledger Setup";
        AccountNo: Code[20];
        Dim3Code: Code[20];
        PlaceholderText: Text;
    begin
        GLSetup.Get;

        GenJnlBatch.reset;
        GenJnlBatch.SetRange(Name, GenJournalName);
        GenJnlBatch.SetRange("Journal Template Name", GenTemplateName);

        if GenJnlBatch.FindFirst() then
            GenJnlBatch.TestField("No. Series");

        ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        if Buffer.Count <> 0 then begin
            // NoSeriesMgt.InitSeries(GenJnlBatch."No. Series", GenJnlBatch."No. Series", WORKDATE(), DocNo, GenJnlBatch."No. Series");
            DocNo := NoSeries.GetNextNo(GenJnlBatch."No. Series", WorkDate());
        end;

        ImportCount := 0;

        for Row := 2 to LastRow do begin

            AccountNo := x.GetCode(Buffer, 3, Row);
            PlaceholderText := x.GetText(Buffer, 2, Row);

            if StrLen(PlaceholderText) > 0 then begin

                GenJnlRec.Reset;
                GenJnlRec.Init;
                GenJnlRec.Validate("Journal Template Name", GenTemplateName);
                GenJnlRec.Validate("Journal Batch Name", GenJournalName);
                GenJnlRec.Validate("Line No.", GetJournalNextLineNo(GenJournalName, GenTemplateName));
                // GenJnlRec.Validate("Document Type", GenJnlRec."Document Type"::Payment);
                GenJnlRec.Validate("Posting Date", x.GetDateFromDMY(Buffer, 1, Row));
                GenJnlRec.Validate("Document No.", DocNo);
                GenJnlRec.Validate("Account Type", GenJnlRec."Account Type"::"G/L Account");
                GenJnlRec.Validate("Account No.", AccountNo);
                GenJnlRec.Insert(true);

                if GLSetup."LCY Code" <> x.GetCode(Buffer, 6, Row) then
                    GenJnlRec.Validate("Currency Code", x.GetCode(Buffer, 6, Row));

                GenJnlRec.Validate("Shortcut Dimension 1 Code", x.GetCode(Buffer, 10, Row));
                GenJnlRec.Validate("Shortcut Dimension 2 Code", x.GetCode(Buffer, 11, Row));
                Dim3Code := x.GetCode(Buffer, 12, Row);
                GenJnlRec.ValidateShortcutDimCode(3, Dim3Code);

                if x.GetDecimal(Buffer, 7, Row) > 0 then
                    GenJnlRec.Validate("Debit Amount", x.GetDecimal(Buffer, 7, Row));
                if x.GetDecimal(Buffer, 8, Row) > 0 then
                    GenJnlRec.Validate("Credit Amount", x.GetDecimal(Buffer, 8, Row));

                GenJnlRec.Description := x.GetText(Buffer, 4, Row);
                GenJnlRec.Modify(true);

                ImportCount += 1;
            end;

        end;

        if ImportCount <> 0 then
            Message('%1 transactions imported.', ImportCount);

    end;

    procedure GetDateFromDMY(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        d: Date;
        dateval: DateTime;
        datevalOnly: Date;
        ImportString: text;
        day: Integer;
        month: Integer;
        year: Integer;
        SplitedText: List of [Text];
    begin
        if Buffer.Get(Row, Col) then begin
            ImportString := Buffer."Cell Value as Text";
            SplitedText := ImportString.Split('/');

            // day
            SplitedText.Get(1, ImportString);
            if Not Evaluate(day, ImportString) then
                exit(WorkDate());
            // month
            SplitedText.Get(2, ImportString);
            if Not Evaluate(month, ImportString) then
                exit(WorkDate());
            // year
            SplitedText.Get(3, ImportString);
            if Not Evaluate(year, ImportString) then
                exit(WorkDate());

            if year < 100 then
                year := 2000 + year;

            datevalOnly := DMY2Date(day, month, year);
            exit(datevalOnly);

        end;
    end;

    local procedure GetJournalNextLineNo(GenJournalBatch: Code[10]; GenJnlTemplate: Code[10]): Integer
    var
        GenJnl: Record "Gen. Journal Line";
    begin
        GenJnl.reset;
        GenJnl.SetRange("Journal Template Name", GenJnlTemplate);
        GenJnl.SetRange("Journal Batch Name", GenJournalBatch);
        if GenJnl.FindLast() then
            exit(GenJnl."Line No." + 10000)
        else
            exit(10000);
    end;
    // YF 26 Oct 2021 // BIPO Imports

    // YF 27 Oct 2021 // Vendor SOA Comparison
    procedure CompareVendorSOA()
    var
        DialogPage: Page "Generic Input Dialog";
        VendorCode: Code[20];
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        SheetName: text;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit "File Management";
        LastRow: Integer;
        TemplateInvNo: Code[20];
        TemplateAmount: Decimal;
        TemplateVLEAmtDiff: Decimal;
        VLERec: Record "Vendor Ledger Entry";
        TempUnappliedRec: Record "LS Ledger Entry" temporary;
    begin
        Clear(DialogPage);
        VendorCode := '';
        DialogPage.SetVendorCodeVisible(true);

        if DialogPage.RunModal() = Action::OK then begin
            VendorCode := DialogPage.GetVendorCode();

            // trigger excel import
            ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
            TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
            SheetName := Buffer.SelectSheetsNameStream(ImportStream);

            Buffer.reset;
            Buffer.OpenBookStream(ImportStream, SheetName);
            Buffer.ReadSheet();
            if Buffer.FindLast() then
                LastRow := Buffer."Row No.";

            ImportCount := 0;

            for Row := 5 to LastRow do begin

                TemplateInvNo := x.GetCode(Buffer, 2, Row);

                if StrLen(TemplateInvNo) > 0 then begin
                    TemplateAmount := x.GetDecimal(Buffer, 6, Row);

                    TempUnappliedRec.Init;
                    TempUnappliedRec."Entry No." := Row;
                    TempUnappliedRec."Document No." := TemplateInvNo; // Template Invoice No
                    TempUnappliedRec."Line Amount" := TemplateAmount; // Template Amount
                    TempUnappliedRec."Amount Incl GST" := TemplateAmount; // Default Difference Amount

                    VLERec.Reset();
                    if StrLen(VendorCode) > 0 then
                        VLERec.SetRange("Vendor No.", VendorCode);
                    VLERec.SetRange("External Document No.", TemplateInvNo);
                    if VLERec.FindFirst() then begin
                        VLERec.CalcFields(Amount);
                        TempUnappliedRec."Posting Date" := VLERec."Posting Date"; // VLE Posting Date
                        TempUnappliedRec."Item No." := VLERec."Document No."; // VLE Document No
                        TempUnappliedRec."Unit Price" := VLERec.Amount; // VLE Amount
                        TempUnappliedRec."Amount Incl GST" := TemplateAmount + VLERec.Amount; // Difference Amount (Template Amount - VLE Amount)
                        TempUnappliedRec."Customer No." := VLERec."Vendor No.";
                        // ImportCount += 1;
                    end;

                    TempUnappliedRec.Insert();
                end;
            end;

            /*
            if ImportCount = 0 then
                Message('%1 transactions imported.', ImportCount);
            */

            // Show List of Unapplied
            if TempUnappliedRec.Count > 0 then
                Page.Run(55100, TempUnappliedRec);
        end;
    end;
    // YF 27 Oct 2021 // Vendor SOA Comparison

    //Import Applies to ID into CLE 
    procedure ImportChainPaymentsCLE()
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        GenJnlRec: Record "Gen. Journal Line";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustRec: Record customer;
        SetApp: Codeunit "Cust. Entry-SetAppl.ID";
        LineAmt: Decimal;
        CLERec: Record "Cust. Ledger Entry";
        ExtDocNo: Code[35];
        GenTemplateName: label 'CASHRCPT';
        GenJnlBatch: Record 232;
        DocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        CustNo: Code[20];

        TempUnappliedRec: Record "LS Ledger Entry" temporary;

        Msg: Text;
    begin
        ImportFilename := FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        ImportCount := 0;
        Clear(Msg);
        for Row := 2 to LastRow do begin
            ExtDocNo := x.GetCode(Buffer, 3, Row);

            CLERec.Reset;
            // if x.GetDecimal(Buffer, 4, Row) > 0 then
            //     CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice)
            // else
            //     CLERec.SetRange("Document Type", CLERec."Document Type"::"Credit Memo");
            CLERec.SetFilter("Applies-to ID", '=%1', '');
            CLERec.SetRange("Document No.", ExtDocNo);
            if CLERec.FindFirst() then begin
                CLERec.CalcFields("Remaining Amount");
                if CLERec."Remaining Amount" >= x.GetDecimal(Buffer, 4, Row) then begin
                    CLERec."Applies-to ID" := UserId;
                    CLERec.MODIFY(false);
                    CLERec."Amount to Apply" := x.GetDecimal(Buffer, 4, Row);
                    CLERec.MODIFY(TRUE);
                end else begin
                    Msg := Msg + 'Document No. : ' + CLERec."Document No." + ' ..... ' + format(x.GetDecimal(Buffer, 4, Row) - CLERec."Remaining Amount") + ' \';
                end;

                ImportCount += 1;
            end else begin
                Msg := Msg + 'Document No. : ' + ExtDocNo + ' cannot be found. \';
            end;

        end;

        if Msg <> '' then begin
            Message(Msg);
        end;
    end;
}
