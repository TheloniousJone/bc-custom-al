report 50014 "Peg CLE List"
{
    DefaultLayout = RDLC;
    Caption = 'Peg CLE List';
    RDLCLayout = './ReportLayouts/ReportLayout 50014 Peg CLE List.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Gen. Journal Line" = rimd;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            // DataItemTableView = sorting(Number) where(Number = const(1));
            RequestFilterFields = "Posting Date", "Customer No.";
            DataItemTableView = sorting("Posting Date");

            column(Posting_Date; "Posting Date") { }
            column(Document_No_; "Document No.") { }
            column(ReferenceDocNo; ReferenceDocNo) { } // if document is CR, show invoice no. here
            column(Customer_No_; "Customer No.") { } // Sell to Customer No.
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { } // Business Segement
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { } // Business Unit
            column(Shortcut_Dimension_4_Code; "Shortcut Dimension 4 Code") { } // Product
            column(Shortcut_Dimension_6_Code; "Shortcut Dimension 6 Code") { } // Geographical
            column(SourceCurrency; "Currency Code") { } // Source Currency
            column(InvoiceAmountFCY; Amount)
            { // Invoice Amount (FCY)
                DecimalPlaces = 2 : 2;
            }
            column(ExchangeRateFCYToLCY; "FCY-LCY Rate")
            {  // Exchange rate (FCY->LCY)
                DecimalPlaces = 2 : 2;
            }
            column(SGDAmount; "LCY Amount")
            {  // SGD Amount
                DecimalPlaces = 2 : 2;
            }
            // column(SGDAmount; "Amount (LCY)")
            // {  // SGD Amount
            //     DecimalPlaces = 2 : 2;
            // }
            column(PeggedRateFCYToVND; "Peg Rate")
            {  // Pegged Rate (FCY->VND)
                DecimalPlaces = 2 : 2;
            }
            column(VNDAmount; "VND Amount")
            {  // VND Amount
                DecimalPlaces = 2 : 2;
            }
            column(ExchangeRateVNDToLCY; "VND-LCY Rate")
            {  // Exchange rate (VND->LCY)
                DecimalPlaces = 2 : 2;
            }
            column(SGDAmountFromVND; "Peg SGD Amount")
            {  // SGD Amount (from VND)
                DecimalPlaces = 2 : 2;
            }
            column(AdjustmentSGD; Adjustment)
            {  // Adjustment (SGD)
                DecimalPlaces = 2 : 2;
            }

            trigger OnPreDataItem()
            begin
                SetFilter("Peg Rate", '<>%1', 0);
            end;

            trigger OnAfterGetRecord()
            var
                CLERec: Record "Cust. Ledger Entry";
                NewGenJnlLine: Record "Gen. Journal Line";
                LineNo: Integer;
            begin
                // Init values

                // InvoiceAmountFCY := "Cust. Ledger Entry".Amount;
                // ReferenceDocNo := "Cust. Ledger Entry"."Document No.";
                Clear(ReferenceDocNo);
                if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::"Credit Memo" then begin
                    CLERec.Reset;
                    if CLERec.Get("Cust. Ledger Entry"."Closed by Entry No.") then begin
                        ReferenceDocNo := CLERec."Document No.";
                    end;
                end;

                // SourceCurrency := "Cust. Ledger Entry"."Currency Code";
                // ExchangeRateFCYToLCY := "Cust. Ledger Entry"."FCY-LCY Rate";
                // PeggedRateFCYToVND := "Cust. Ledger Entry"."Peg Rate";
                // ExchangeRateVNDToLCY := "Cust. Ledger Entry"."VND-LCY Rate";

                // // Tail end calculations
                // SGDAmount := "Cust. Ledger Entry"."Amount (LCY)";
                // VNDAmount := "Cust. Ledger Entry"."VND Amount";
                // SGDAmountFromVND := "Cust. Ledger Entry"."Peg SGD Amount";
                // // if ExchangeRateVNDToLCY <> 0 then
                // //     SGDAmountFromVND := VNDAmount / ExchangeRateVNDToLCY;
                // AdjustmentSGD := "Cust. Ledger Entry".Adjustment;

                // Check settings for Generate Journals
                GenerateGoAhead := GenerateJournals;
                if GenerateJournals then begin
                    if CompanyInfo."Exch. Adj. Gen. Jnl Batch" = '' then GenerateGoAhead := false; // check batch
                    if CompanyInfo."Trade Sales Adjustment Account" = '' then GenerateGoAhead := false; // check trade agreement account
                end;

                if GenerateGoAhead then begin
                    // get last line no
                    NewGenJnlLine.Reset;
                    NewGenJnlLine.SetRange("Journal Template Name", 'GENERAL');
                    NewGenJnlLine.SetRange("Journal Batch Name", CompanyInfo."Exch. Adj. Gen. Jnl Batch");
                    if NewGenJnlLine.FindLast() then
                        LineNo := NewGenJnlLine."Line No." + 10000
                    else
                        LineNo := 10000;

                    // insert gen. jnl line
                    NewGenJnlLine.Reset;
                    NewGenJnlLine.Init();
                    NewGenJnlLine.Validate("Journal Template Name", 'GENERAL');
                    NewGenJnlLine.Validate("Journal Batch Name", CompanyInfo."Exch. Adj. Gen. Jnl Batch");
                    NewGenJnlLine.Validate("Line No.", LineNo);
                    NewGenJnlLine.Validate("Posting Date", CalcDate('CM', "Cust. Ledger Entry"."Posting Date"));
                    NewGenJnlLine.Validate("Document No.", "Cust. Ledger Entry"."Document No.");
                    NewGenJnlLine.Validate("Account Type", NewGenJnlLine."Account Type"::"G/L Account");
                    NewGenJnlLine.Validate("Account No.", CompanyInfo."Exch. Var. Settlement Account");
                    NewGenJnlLine.Validate("Bal. Account Type", NewGenJnlLine."Bal. Account Type"::"G/L Account");
                    NewGenJnlLine.Validate("Bal. Account No.", CompanyInfo."Trade Sales Adjustment Account");
                    NewGenJnlLine.Insert(true);

                    NewGenJnlLine.Description := "Cust. Ledger Entry"."Document No." + ' - Exchange variable - ' + Format("Cust. Ledger Entry"."Posting Date", 0, '<Month Text,3>/<Year>');
                    NewGenJnlLine.Validate(Amount, "Cust. Ledger Entry".Adjustment);
                    NewGenJnlLine.Validate("Dimension Set ID", "Cust. Ledger Entry"."Dimension Set ID"); //RL 14 Feb 2022
                    NewGenJnlLine.Modify();
                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(GenerateJournals; GenerateJournals)
                    {
                        ApplicationArea = all;
                        Caption = 'Generate Journals';
                        ToolTip = 'Check this to generate journals';
                    }
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
    end;

    var
        ReferenceDocNo: Code[20];
        SourceCurrency: Code[20];
        InvoiceAmountFCY: Decimal;
        ExchangeRateFCYToLCY: Decimal;
        SGDAmount: Decimal;
        PeggedRateFCYToVND: Decimal;
        VNDAmount: Decimal;
        ExchangeRateVNDToLCY: Decimal;
        SGDAmountFromVND: Decimal;
        AdjustmentSGD: Decimal;
        GenerateJournals: Boolean;
        GenerateGoAhead: Boolean;
        CompanyInfo: Record "Company Information";
}