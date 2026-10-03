report 70041 "I9G_PaymentVoucherPostedGJ"
{
    DefaultRenderingLayout = "Novem - Payment Voucher";
    ApplicationArea = All;
    Caption = 'Payment Voucher';

    dataset
    {
        dataitem("Posted Gen. Journal Line"; "Posted Gen. Journal Line")
        {
            DataItemTableView = sorting("Document No.", "Posting Date");//where("Document Type" = const(Payment));
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
            column(CurrencyFactor; "Currency Factor") { }
            column(OutputString; OutputString) { }
            column(AccountCode; "Account No.") { }
            column(AccountDescription; Description) { }
            column(DocumentRemarks; I9G_Remarks) { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount (LCY)") { }
            column(VATAmount; Abs("VAT Amount")) { }
            column(VATAmountLCY; Abs("VAT Amount (LCY)")) { }
            column(VATBaseAmount; "VAT Base Amount") { }
            column(VATBaseAmountLCY; "VAT Base Amount (LCY)") { }
            column(AccountDetails; I9G_AccountDetails) { }
            column(AppliestoDocNo; "Applies-to Doc. No.") { }
            column(AccountType; "Account Type") { }
            column(GLCode; GLCode) { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(LCYCurrencyCode; LCYCurrencyCode) { }
            column(HideLocalCurrency; HideLocalCurrency) { }
            column(ExchRate; ExchRate) { }
            trigger OnPreDataItem()
            var
            begin
                "Posted Gen. Journal Line".SetRange("Bal. Account Type", "Bal. Account Type"::"Bank Account");

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
                GeneralLedgerSetupRec.Get();
                Clear(CurrencyCode);
                Clear(LCYCurrencyCode);
                Clear(ExchRate);
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
                    CurrExchRate.Reset();
                    CurrExchRate.SetRange("Currency Code", CurrencyCode);
                    if CurrExchRate.FindLast() then begin
                        ExchRate := CurrExchRate."Exchange Rate Amount" / "Currency Factor";
                    end;
                end;
                if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::Customer then begin
                    CustomerRec.Reset();
                    if CustomerRec.Get("Posted Gen. Journal Line"."Bal. Account No.") then begin
                        Name := CustomerRec.Name;
                        Address := CustomerRec.Address;
                        Address2 := CustomerRec."Address 2";
                        CountryRegion := CustomerRec."Country/Region Code";
                        PostalCode := CustomerRec."Post Code";
                    end;
                end else if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::Vendor then begin
                    VendorRec.Reset();
                    if VendorRec.Get("Posted Gen. Journal Line"."Bal. Account No.") then begin
                        Name := VendorRec.Name;
                        Address := VendorRec.Address;
                        Address2 := VendorRec."Address 2";
                        CountryRegion := VendorRec."Country/Region Code";
                        PostalCode := VendorRec."Post Code";
                    end;
                end;
                GenJournalBatchRec.Reset();
                if GenJournalBatchRec.Get("Journal Template Name", "Journal Batch Name") then;
                TotalAmount += Amount;
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
    }
    rendering
    {
        layout("Novem - Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70041-PaymentVoucherPostedGJ.rdl';
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
        LCYCurrencyCode: Code[20];
        HideLocalCurrency: Boolean;
        TotalAmount: Decimal;
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i : integer;
        BankAccRec: Record "Bank Account";
        BankAccPostGrpRec: Record "Bank Account Posting Group";
        GLCode: Code[20];
        ExchRate: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
}