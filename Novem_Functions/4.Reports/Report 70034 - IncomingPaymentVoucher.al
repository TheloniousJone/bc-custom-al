report 70034 "I9G_IncomingPaymentVoucher"
{
    DefaultRenderingLayout = "Novem - Incoming Payment Voucher";
    ApplicationArea = All;
    Caption = 'Incoming Payment Voucher';

    dataset
    {
        dataitem("GenJournalLine"; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.";
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(CompanyAddress; CompanyInformationRec.Address) { }
            column(CompanyAddress2; CompanyInformationRec."Address 2") { }
            column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
            column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
            column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
            column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
            column(DocumentNo; "Document No.") { }
            column(VendorName; CustomerRec.Name) { }
            column(VendorAddress; CustomerRec.Address) { }
            column(VendorAddress2; CustomerRec."Address 2") { }
            column(VendorCountryRegion; CustomerRec."Country/Region Code") { }
            column(VendorPostCode; CustomerRec."Post Code") { }
            column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(BatchName; "Journal Batch Name") { }
            column(BatchDescrption; GenJournalBatchRec.Description) { }
            column(CurrencyCode; CurrencyCode) { }
            column(CurrencyFactor; "Currency Factor") { }
            column(Amount; Abs(Amount)) { }
            column(AmountLCY; Abs("Amount (LCY)")) { }
            column(LCYCurrencyCode; LCYCurrencyCode) { }
            column(HideLocalCurrency; HideLocalCurrency) { }
            column(OutputString; OutputString) { }
            column(AppliedDocument; AppliedDocument) { }
            column(VATAmount; Abs("VAT Amount")) { }
            column(VATAmountLCY; Abs("VAT Amount (LCY)")) { }
            column(AccountCode; "Account No.") { }
            column(AccountDescription; Description) { }
            column(Remarks; I9G_Remarks) { }
            column(VATBaseAmount; Abs("VAT Base Amount")) { }
            column(VATBaseAmountLCY; Abs("VAT Base Amount (LCY)")) { }
            column(AccountDetails; I9G_AccountDetails) { }
            column(AppliestoDocNo; "Applies-to Doc. No.") { }
            column(AccountType; "Account Type") { }
            column(GLCode; GLCode) { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(VendorAddress3; CustomerRec.I9G_Adddress3) { }
            dataitem("CustLedgerEntry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = GenJournalLine;
                DataItemLink = "Customer No." = field("Account No."), "Applies-to ID" = field("Document No.");
                DataItemTableView = sorting("Document No.") order(ascending) where(Open = const(true));
                column(InvoiceDate; Format(CustLedgerEntry."Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
                column(InvoiceNo; CustLedgerEntry."Document No.") { }
                column(OriginalAmount; Abs("Remaining Amount")) { }
                column(OustandingAmount; Abs("Remaining Amount" - "Amount to Apply")) { }
                column(PaidAmount; "Amount to Apply") { }
                column(OutputString2; OutputString2) { }
                column(Overpaid; GenJournalLine."Amount (LCY)" + TotalPaidAmount) { }
                trigger OnPreDataItem()
                var
                begin
                    Clear(TotalPaidAmount);
                    CustLedgerEntry.SetAutoCalcFields("Original Amount", "Remaining Amount", Amount);
                end;

                trigger OnAfterGetRecord()
                var
                    PurchInvHeaderRec: Record "Purch. Inv. Header";
                    PurchCrMemoHeaderRec: Record "Purch. Cr. Memo Hdr.";
                begin
                    Clear(DocumentRemarks);
                    if "Document Type" = "Document Type"::"Credit Memo" then begin
                        PurchCrMemoHeaderRec.Reset();
                        PurchCrMemoHeaderRec.SetRange("No.", "Document No.");
                        if PurchCrMemoHeaderRec.FindFirst() then begin
                            DocumentRemarks := PurchCrMemoHeaderRec.I9G_Remarks;
                        end;
                    end;
                    if "Document Type" = "Document Type"::Invoice then begin
                        PurchInvHeaderRec.Reset();
                        PurchInvHeaderRec.SetRange("No.", "Document No.");
                        if PurchInvHeaderRec.FindFirst() then begin
                            DocumentRemarks := PurchInvHeaderRec.I9G_Remarks;
                        end;
                    end;
                    TotalPaidAmount += CustLedgerEntry."Amount to Apply";
                    Clear(NoText);
                    Clear(InputString2);
                    Clear(OutputString2);
                    Clear(n);
                    Clear(i);
                    ReportConverter.InitTextVariable;
                    ReportConverter.FormatNoText(NoText, TotalPaidAmount, CurrencyCode);
                    InputString2 := NoText[1] + ' ' + NoText[2] + ' ONLY';
                    n := STRLEN(InputString);
                    FOR i := 1 TO n DO
                        IF (InputString2[i] = ' ') AND (i < n) THEN BEGIN
                            IF NOT (InputString2[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                                OutputString2 += FORMAT(InputString2[i])
                        END ELSE
                            OutputString2 += FORMAT(InputString2[i]);
                    OutputString2 := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString2, '<>', ' '));
                end;
            }
            trigger OnPreDataItem()
            var
            begin
                Clear(TotalAmount);
                if I9G_TempTableRec.IsTemporary then
                    I9G_TempTableRec.DeleteAll();
                EntryNo := 1;
            end;

            trigger OnAfterGetRecord()
            var
                BankAccRec: Record "Bank Account";
                BankAccPostGrpRec: Record "Bank Account Posting Group";
            begin
                if GenJournalLine.IsApplied() then begin
                    I9G_TempTableRec.Reset();
                    I9G_TempTableRec.SetRange(Code1, GenJournalLine."Document No.");
                    I9G_TempTableRec.SetRange(Code2, GenJournalLine."Account No.");
                    if I9G_TempTableRec.FindFirst() then begin
                        CurrReport.Skip();
                    end else begin
                        I9G_TempTableRec.Reset();
                        I9G_TempTableRec.Init();
                        I9G_TempTableRec."Entry No." := EntryNo + 1;
                        I9G_TempTableRec.Code1 := GenJournalLine."Document No.";
                        I9G_TempTableRec.Code2 := GenJournalLine."Account No.";
                        I9G_TempTableRec.Insert();
                    end;
                end;
                GeneralLedgerSetupRec.Get();
                CustomerRec.Reset();
                if "Account Type" = "Account Type"::Customer then
                    if CustomerRec.Get("Account No.") then;
                GenJournalBatchRec.Reset();
                if GenJournalBatchRec.Get("Journal Template Name", "Journal Batch Name") then;
                Clear(CurrencyCode);
                Clear(LCYCurrencyCode);
                if "Currency Code" = '' then begin
                    CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                end else begin
                    CurrencyCode := "Currency Code";
                end;
                LCYCurrencyCode := GeneralLedgerSetupRec."LCY Code";
                if CurrencyCode = LCYCurrencyCode then begin
                    HideLocalCurrency := true;
                end else begin
                    HideLocalCurrency := false;
                end;
                TotalAmount += Abs(Amount);
                Clear(NoText);
                Clear(InputString);
                Clear(OutputString);
                Clear(n);
                Clear(i);
                ReportConverter.InitTextVariable;
                ReportConverter.FormatNoText(NoText, TotalAmount, CurrencyCode);
                InputString := NoText[1] + ' ' + NoText[2] + ' ONLY';
                n := STRLEN(InputString);
                FOR i := 1 TO n DO
                    IF (InputString[i] = ' ') AND (i < n) THEN BEGIN
                        IF NOT (InputString[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                            OutputString += FORMAT(InputString[i])
                    END ELSE
                        OutputString += FORMAT(InputString[i]);
                OutputString := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString, '<>', ' '));

                Clear(GLCode);
                BankAccRec.Reset();
                if BankAccRec.Get("Bal. Account No.") then begin
                    BankAccPostGrpRec.Reset();
                    if BankAccPostGrpRec.Get(BankAccRec."Bank Acc. Posting Group") then
                        GLCode := BankAccPostGrpRec."G/L Account No.";
                end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                field(AppliedDocument; AppliedDocument)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }
    rendering
    {
        layout("Novem - Incoming Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70034-IncomingPaymentVoucher.rdl';
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    procedure GetReportFilter(par_AppliedDocument: Boolean)
    var
    begin
        AppliedDocument := par_AppliedDocument;
    end;

    var
        I9G_TempTableRec: Record I9G_TempTable temporary;
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        GenJournalBatchRec: Record "Gen. Journal Batch";
        CustomerRec: Record Customer;
        ReportConverter: Report I9G_ReportConverter;
        CurrencyCode: Code[20];
        LCYCurrencyCode: Code[20];
        HideLocalCurrency: Boolean;
        AppliedDocument: Boolean;
        DocumentRemarks: Text[250];
        TotalAmount, TotalPaidAmount : Decimal;
        NoText: array[2] of Text[250];
        InputString, InputString2, OutputString, OutputString2 : Text[2400];
        n, i, EntryNo : integer;
        GLCode: Code[20];
        PaidAmount: Decimal;
}