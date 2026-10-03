report 70037 "I9G_PaymentVoucher"
{
    DefaultRenderingLayout = "Novem - Payment Voucher";
    ApplicationArea = All;
    Caption = 'Payment Voucher';

    dataset
    {
        dataitem("GLEntry"; "G/L Entry")
        {
            DataItemTableView = sorting("Document No.", "Posting Date") where("Document Type" = const(Payment));
            RequestFilterFields = "Document No.", "Posting Date";
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(CompanyAddress; CompanyInformationRec.Address) { }
            column(CompanyAddress2; CompanyInformationRec."Address 2") { }
            column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
            column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
            column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
            column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
            column(DocumentNo; "Document No.") { }
            column(VendorName; Name) { }
            column(VendorAddress; Address) { }
            column(VendorAddress2; Address2) { }
            column(VendorCountryRegion; CountryRegion) { }
            column(VendorPostCode; PostalCode) { }
            column(DocumentDate; Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(BatchName; "Journal Batch Name") { }
            column(BatchDescrption; GenJournalBatchRec.Description) { }
            column(CurrencyCode; CurrencyCode) { }
            column(OutputString; OutputString) { }
            column(AccountCode; "G/L Account No.") { }
            column(AccountDescription; Description) { }
            column(DocumentRemarks; I9G_Remarks) { }
            column(Amount; Abs(Amount)) { }
            column(VATAmount; "VAT Amount") { }
            trigger OnPreDataItem()
            var
            begin
                GLEntry.SetFilter("Bal. Account Type", '%1|%2', GLEntry."Bal. Account Type"::Customer, GLEntry."Bal. Account Type"::Vendor);
                Clear(TotalAmount);
                Clear(Name);
                Clear(Address);
                Clear(Address2);
                Clear(CountryRegion);
                Clear(PostalCode);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                Clear(CurrencyCode);
                GeneralLedgerSetupRec.Get();
                CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                if GLEntry."Bal. Account Type" = GLEntry."Bal. Account Type"::Customer then begin
                    CustomerRec.Reset();
                    if CustomerRec.Get(GLEntry."Bal. Account No.") then begin
                        Name := CustomerRec.Name;
                        Address := CustomerRec.Address;
                        Address2 := CustomerRec."Address 2";
                        CountryRegion := CustomerRec."Country/Region Code";
                        PostalCode := CustomerRec."Post Code";
                    end;
                end else if GLEntry."Bal. Account Type" = GLEntry."Bal. Account Type"::Vendor then begin
                    VendorRec.Reset();
                    if VendorRec.Get(GLEntry."Bal. Account No.") then begin
                        Name := VendorRec.Name;
                        Address := VendorRec.Address;
                        Address2 := VendorRec."Address 2";
                        CountryRegion := VendorRec."Country/Region Code";
                        PostalCode := VendorRec."Post Code";
                    end;
                end;
                GenJournalBatchRec.Reset();
                if GenJournalBatchRec.Get("Journal Templ. Name", "Journal Batch Name") then;
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
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
    }
    rendering
    {
        layout("Novem - Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70037-PaymentVoucher.rdl';
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        GenJournalBatchRec: Record "Gen. Journal Batch";
        CustomerRec: Record Customer;
        VendorRec: Record Vendor;
        ReportConverter: Report I9G_ReportConverter;
        Name, Address, Address2 : Text[300];
        CountryRegion, PostalCode : code[50];
        CurrencyCode: Code[20];
        TotalAmount: Decimal;
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i : integer;
}