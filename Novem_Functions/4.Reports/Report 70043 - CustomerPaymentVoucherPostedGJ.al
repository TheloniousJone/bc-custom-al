report 70043 "I9G_CustPaymentVoucherPostedGJ"
{
    DefaultRenderingLayout = "Novem - Customer Outgoing Payment Voucher";
    ApplicationArea = All;
    Caption = 'Incoming Payment Voucher';

    dataset
    {
        dataitem("Posted Gen. Journal Line"; "Posted Gen. Journal Line")
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
            column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(AccountDetails; I9G_AccountDetails) { }
            column(AppliestoDocNo; "Applies-to Doc. No.") { }
            column(AccountType; "Account Type") { }
            column(GLCode; GLCode) { }
            column(BalAccountNo; "Bal. Account No.") { }

            dataitem("CustLedgerEntry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = "Posted Gen. Journal Line";
                DataItemTableView = sorting("Customer No.", "Document No.", "Posting Date") where("Document Type" = const(Payment));
                DataItemLink = "Document No." = field("Document No."), "Posting Date" = field("Posting Date");

                column(DocumentNo; "Document No.") { }
                //column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
                column(VendorName; CustomerRec.Name) { }
                column(VendorAddress; CustomerRec.Address) { }
                column(VendorAddress2; CustomerRec."Address 2") { }
                column(VendorCountryRegion; CustomerRec."Country/Region Code") { }
                column(VendorPostCode; CustomerRec."Post Code") { }
                column(BatchName; "Journal Batch Name") { }
                column(BatchDescrption; GenJournalBatchRec.Description) { }
                column(Amount; Abs(Amount - "Remaining Amount")) { }
                column(AmountLCY; Abs("Amount (LCY)" - "Remaining Amt. (LCY)")) { }
                column(AppliedDocument; AppliedDocument) { }
                column(DocumentRemarks; I9G_Remarks) { }
                column(VendorAddress3; CustomerRec.I9G_Adddress3) { }

                dataitem("DetailedCustLedgEntry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLinkReference = CustLedgerEntry;
                    DataItemTableView = sorting("Customer No.", "Document No.", "Posting Date") where("Entry Type" = const(Application));
                    DataItemLink = "Applied Cust. Ledger Entry No." = field("Entry No.");

                    // column(InvoiceDate; Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }

                    dataitem("CustLedgerEntry2"; "Cust. Ledger Entry")
                    {
                        DataItemLinkReference = DetailedCustLedgEntry;
                        DataItemTableView = sorting("Customer No.", "Document No.", "Posting Date");
                        DataItemLink = "Entry No." = field("Cust. Ledger Entry No.");

                        column(InvoiceDate; Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
                        column(CurrencyCode; CurrencyCode) { }
                        column(CurrencyFactor; "Original Currency Factor") { }
                        column(LCYCurrencyCode; LCYCurrencyCode) { }
                        column(HideLocalCurrency; HideLocalCurrency) { }
                        column(OutputString; OutputString) { }
                        column(InvoiceNo; "Document No.") { }
                        column(PaidAmount; Abs(DetailedCustLedgEntry."Amount (LCY)")) { }
                        column(OriginalAmount; Abs("Amount (LCY)")) { }
                        column(OutstandingAmount; Abs("Amount (LCY)" - Abs(DetailedCustLedgEntry."Amount (LCY)"))) { }
                        column(Overpaid; CustLedgerEntry."Remaining Amount") { }

                        trigger OnPreDataItem()
                        begin
                            CustLedgerEntry2.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amount");
                        end;

                        trigger OnAfterGetRecord()
                        var
                        begin
                            GeneralLedgerSetupRec.Get();
                            CustomerRec.Reset();
                            if CustomerRec.Get("Customer No.") then;
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

                    trigger OnPreDataItem()
                    begin
                        DetailedCustLedgEntry.SetFilter("Cust. Ledger Entry No.", '<>%1', CustLedgerEntry."Entry No.");
                    end;
                }

                trigger OnPreDataItem()
                var
                begin
                    CustLedgerEntry.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amount");
                    Clear(TotalAmount);
                end;
            }

            trigger OnAfterGetRecord()
            var
                BankAccRec: Record "Bank Account";
                BankAccPostGrpRec: Record "Bank Account Posting Group";
            begin
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
        layout("Novem - Customer Outgoing Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70043-CustomerOutgoingPaymentVoucherPostedGJ.rdl';
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
        CustomerRec: Record Customer;
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
        GLCode: Code[20];
        PaidAmount: Decimal;
}