report 70042 "I9G_VendPaymentVoucherPostedGJ"
{
    DefaultRenderingLayout = "Novem - Vendor Outgoing Payment Voucher";
    ApplicationArea = All;
    Caption = 'Outgoing Payment Voucher';

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
            // column(DocumentRemarks; I9G_Remarks) { }
            column(AmountLCY; Abs("Amount (LCY)")) { }

            dataitem("VendorLedgerEntry"; "Vendor Ledger Entry")
            {
                DataItemLinkReference = "Posted Gen. Journal Line";
                DataItemLink = "Document No." = field("Document No."), "Posting Date" = field("Posting Date");
                DataItemTableView = sorting("Vendor No.", "Document No.", "Posting Date")
                where("Document Type" = const(Payment));
                RequestFilterFields = "Vendor No.", "Document No.", "Posting Date";

                column(DocumentNo; "Document No.") { }
                column(VendorName; VendorRec.Name) { }
                column(VendorAddress; VendorRec.Address) { }
                column(VendorAddress2; VendorRec."Address 2") { }
                column(VendorCountryRegion; VendorRec."Country/Region Code") { }
                column(VendorPostCode; VendorRec."Post Code") { }
                column(BatchName; "Journal Batch Name") { }
                column(BatchDescrption; GenJournalBatchRec.Description) { }
                column(Amount; Abs(Amount - "Remaining Amount")) { }
                column(AppliedDocument; AppliedDocument) { }
                column(BalAccountNo; "Bal. Account No.") { }

                dataitem("DetailedVendorLedgEntry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLinkReference = VendorLedgerEntry;
                    DataItemTableView = sorting("Vendor No.", "Document No.", "Posting Date") where("Entry Type" = const(Application));
                    DataItemLink = "Applied Vend. Ledger Entry No." = field("Entry No.");

                    dataitem("VendorLedgerEntry2"; "Vendor Ledger Entry")
                    {
                        DataItemLinkReference = DetailedVendorLedgEntry;
                        DataItemTableView = sorting("Vendor No.", "Document No.", "Posting Date");
                        DataItemLink = "Entry No." = field("Vendor Ledger Entry No.");

                        column(InvoiceNo; InvoiceNo) { }
                        column(InvoiceDate; Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
                        column(CurrencyCode; CurrencyCode) { }
                        column(CurrencyFactor; "Original Currency Factor") { }
                        column(LCYCurrencyCode; LCYCurrencyCode) { }
                        column(HideLocalCurrency; HideLocalCurrency) { }
                        column(OutputString; OutputString) { }
                        column(PaidAmount; PaidAmount) { }
                        column(ExchRate; ExchRate) { }
                        column(DocumentRemarks; DocumentRemarks) { }

                        trigger OnPreDataItem()
                        begin
                            VendorLedgerEntry2.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amount");
                        end;

                        trigger OnAfterGetRecord()
                        var
                            PurchInvHeaderRec: Record "Purch. Inv. Header";
                            PurchCrMemoHeaderRec: Record "Purch. Cr. Memo Hdr.";
                        begin
                            GeneralLedgerSetupRec.Get();
                            VendorRec.Reset();
                            if VendorRec.Get("Vendor No.") then;
                            GenJournalBatchRec.Reset();
                            if GenJournalBatchRec.Get("Journal Templ. Name", "Journal Batch Name") then;
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
                                    ExchRate := CurrExchRate."Exchange Rate Amount" / "Posted Gen. Journal Line"."Currency Factor";
                                end;
                            end;
                            TotalAmount += -(Amount - "Remaining Amount");
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

                            Clear(PaidAmount);
                            Clear(DocumentRemarks);
                            Clear(InvoiceNo);
                            if "Document Type" = "Document Type"::"Credit Memo" then begin
                                PurchCrMemoHeaderRec.Reset();
                                PurchCrMemoHeaderRec.SetRange("No.", "Document No.");
                                if PurchCrMemoHeaderRec.FindFirst() then begin
                                    DocumentRemarks := PurchCrMemoHeaderRec.I9G_Remarks;
                                    InvoiceNo := PurchCrMemoHeaderRec."Vendor Cr. Memo No.";
                                end;
                                PaidAmount := -(Amount - "Remaining Amount");
                            end;
                            if "Document Type" = "Document Type"::Invoice then begin
                                PurchInvHeaderRec.Reset();
                                PurchInvHeaderRec.SetRange("No.", "Document No.");
                                if PurchInvHeaderRec.FindFirst() then begin
                                    DocumentRemarks := PurchInvHeaderRec.I9G_Remarks;
                                    InvoiceNo := PurchInvHeaderRec."Vendor Invoice No.";
                                end;
                                PaidAmount := Abs(Amount - "Remaining Amount");
                            end;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        DetailedVendorLedgEntry.SetFilter("Vendor Ledger Entry No.", '<>%1', "VendorLedgerEntry"."Entry No.");
                    end;
                }

                trigger OnPreDataItem()
                var
                begin
                    VendorLedgerEntry.SetAutoCalcFields(Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)");
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
        layout("Novem - Vendor Outgoing Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70042-VendorOutgoingPaymentVoucherPostedGJ.rdl';
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
        GLCode: Code[20];
        CurrExchRate: Record "Currency Exchange Rate";
        ExchRate: Decimal;
        PaidAmount: Decimal;
        InvoiceNo: Code[35];
}