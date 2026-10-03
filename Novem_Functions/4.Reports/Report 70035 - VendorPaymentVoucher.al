report 70035 "I9G_VendorPaymentVoucher"
{
    DefaultRenderingLayout = "Novem - Vendor Outgoing Payment Voucher";
    ApplicationArea = All;
    Caption = 'Outgoing Payment Voucher';

    dataset
    {
        dataitem("VendorLedgerEntry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.", "Document No.", "Posting Date") where("Document Type" = const(Payment));
            RequestFilterFields = "Vendor No.", "Document No.", "Posting Date";
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(CompanyAddress; CompanyInformationRec.Address) { }
            column(CompanyAddress2; CompanyInformationRec."Address 2") { }
            column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
            column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
            column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
            column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
            column(DocumentNo; "Document No.") { }
            column(VendorName; VendorRec.Name) { }
            column(VendorAddress; VendorRec.Address) { }
            column(VendorAddress2; VendorRec."Address 2") { }
            column(VendorCountryRegion; VendorRec."Country/Region Code") { }
            column(VendorPostCode; VendorRec."Post Code") { }
            column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(BatchName; "Journal Batch Name") { }
            column(BatchDescrption; GenJournalBatchRec.Description) { }
            column(CurrencyCode; CurrencyCode) { }
            column(CurrencyFactor; "Original Currency Factor") { }
            column(Amount; Abs(Amount - "Remaining Amount")) { }
            column(AmountLCY; Abs("Amount (LCY)" - "Remaining Amt. (LCY)")) { }
            column(LCYCurrencyCode; LCYCurrencyCode) { }
            column(HideLocalCurrency; HideLocalCurrency) { }
            column(OutputString; OutputString) { }
            column(AppliedDocument; AppliedDocument) { }
            column(InvoiceDate; Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(InvoiceNo; "Document No.") { }
            column(DocumentRemarks; I9G_Remarks) { }
            column(PaidAmount; Abs(Amount - "Remaining Amount")) { }
            trigger OnPreDataItem()
            var
            begin
                VendorLedgerEntry.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)");
                Clear(TotalAmount);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                GeneralLedgerSetupRec.Get();
                VendorRec.Reset();
                if VendorRec.Get("Vendor No.") then;
                GenJournalBatchRec.Reset();
                if GenJournalBatchRec.Get("Journal Templ. Name", "Journal Batch Name") then;
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
                TotalAmount += Abs(Amount - "Remaining Amount");
                Clear(NoText);
                Clear(InputString);
                Clear(OutputString);
                Clear(n);
                Clear(i);
                ReportConverter.InitTextVariable;
                ReportConverter.FormatNoText(NoText, Abs(TotalAmount), CurrencyCode);
                InputString := NoText[1] + ' ' + NoText[2] + ' ONLY';
                n := STRLEN(InputString);
                FOR i := 1 TO n DO
                    IF (InputString[i] = ' ') AND (i < n) THEN BEGIN
                        IF NOT (InputString[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                            OutputString += FORMAT(InputString[i])
                    END ELSE
                        OutputString += FORMAT(InputString[i]);
                OutputString := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString, '<>', ' '));
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
        layout("Novem - Vendor Outgoing Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70035-VendorOutgoingPaymentVoucher.rdl';
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
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        GenJournalBatchRec: Record "Gen. Journal Batch";
        VendorRec: Record Vendor;
        ReportConverter: Report I9G_ReportConverter;
        CurrencyCode: Code[20];
        LCYCurrencyCode: Code[20];
        HideLocalCurrency: Boolean;
        AppliedDocument: Boolean;
        DocumentRemarks: Text[250];
        TotalAmount: Decimal;
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i : integer;
}