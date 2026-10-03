pageextension 55074 CashReceiptJnlPageExt extends "Cash Receipt Journal"
{
    layout
    {
        modify(CurrentJnlBatchName)
        {
            trigger OnAfterValidate()
            begin
                CalcTotalDebitCreditAmount();
            end;
        }

        addbefore("Total Balance")
        {
            group("Total Debit")
            {
                Caption = 'Total Debit';
                field(TotalDebit; TotalDebit)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total Debit';
                    Editable = false;
                }
            }

            group("Total Credit")
            {
                Caption = 'Total Credit';
                field(TotalCredit; TotalCredit)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total Credit';
                    Editable = false;
                }
            }
        }

        addbefore("Bal. Account Type")
        {
            field(LineTotalAppliedAmount; LineTotalAppliedAmount)
            {
                ApplicationArea = All;
                Caption = 'Total Applied Amount';
                Editable = false;
            }
        }

    }

    actions
    {
        addafter("F&unctions")
        {
            action("Import NTUC Payments")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IntegrationCU.ImportChainPayments(Rec."Journal Batch Name", 'NTUC');
                end;
            }

            action("Import Watsons Payments")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IntegrationCU.ImportChainPayments(Rec."Journal Batch Name", 'WATSON');
                end;
            }

            action("Import Guardian Payments")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IntegrationCU.ImportChainPayments(Rec."Journal Batch Name", 'GUARDIAN');
                end;
            }

            action("Process Deposit Slip")
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    ProcessDepositSlip();
                    CurrPage.Update();
                end;
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcLineTotalAppliedAmount();
        CalcTotalDebitCreditAmount();
    end;

    trigger OnAfterGetRecord()
    begin
        CalcLineTotalAppliedAmount();
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        CalcTotalDebitCreditAmount();
    end;

    trigger OnOpenPage()
    begin
        CalcTotalDebitCreditAmount();
    end;

    local procedure ProcessDepositSlip()
    var
        SRSetup: Record "Sales & Receivables Setup";
        TotalAmount: Decimal;
        BankBalAcctNo: Code[20];
        GenJnlLineRec: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        // 1. Get total amount and bal acct no (from first line) - bank type
        GenJnlLineRec.Reset;
        GenJnlLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlLineRec.CalcSums(Amount);
        // TotalAmount := GenJnlLineRec.Amount * -1; //RL   101021- inversed sign
        TotalAmount := GenJnlLineRec.Amount;

        GenJnlLineRec.SetRange("Bal. Account Type", GenJnlLineRec."Bal. Account Type"::"Bank Account");
        if GenJnlLineRec.FindFirst() then
            BankBalAcctNo := GenJnlLineRec."Bal. Account No.";

        if TotalAmount = 0 then
            Error('Total Amount is zero');

        if BankBalAcctNo = '' then
            Error('Bank Bal. Acct No. is blank');

        // 2. Update existing lines to  Bal Account to G/L Acct and Deposit Slip Clearing Account
        SRSetup.Get;
        if SRSetup."Deposit Slip Clearing Account" = '' then
            Error('Deposit Slip Clearing Account is blank')
        else begin
            GenJnlLineRec.Reset;
            GenJnlLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJnlLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJnlLineRec.ModifyAll("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");
            GenJnlLineRec.ModifyAll("Bal. Account No.", SRSetup."Deposit Slip Clearing Account");
        end;

        // 3. Add new G/L Account to bank line
        GenJnlLineRec.Reset;
        GenJnlLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
        if GenJnlLineRec.FindLast() then
            LineNo := GenJnlLineRec."Line No." + 10000
        else
            LineNo := 10000;

        GenJnlLineRec.Reset;
        GenJnlLineRec.Init();
        GenJnlLineRec.Validate("Journal Template Name", Rec."Journal Template Name");
        GenJnlLineRec.Validate("Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLineRec.Validate("Line No.", LineNo);
        GenJnlLineRec.Validate("Document Type", Rec."Document Type");
        GenJnlLineRec.Validate("Posting Date", WorkDate());
        GenJnlLineRec.Validate("Account Type", GenJnlLineRec."Account Type"::"G/L Account");
        GenJnlLineRec.Validate("Account No.", SRSetup."Deposit Slip Clearing Account");
        GenJnlLineRec.Validate("Document No.", Rec."Document No.");
        GenJnlLineRec.Validate("Bal. Account Type", GenJnlLineRec."Bal. Account Type"::"Bank Account");
        GenJnlLineRec.Validate("Bal. Account No.", BankBalAcctNo);
        GenJnlLineRec.Validate(Amount, TotalAmount);

        if Not GenJnlLineRec.Insert(true) then
            Error('Insert bank line error');

        Message('Deposit Slips Processed');

    end;

    local procedure CalcTotalDebitCreditAmount()
    var
        GenRec: Record "Gen. Journal Line";
    begin
        GenRec.Reset;
        GenRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        GenRec.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenRec.CalcSums("Debit Amount", "Credit Amount");
        TotalCredit := GenRec."Credit Amount";
        TotalDebit := GenRec."Debit Amount";
    end;

    local procedure CalcLineTotalAppliedAmount()
    var
        CLERec: Record "Cust. Ledger Entry";
        VLERec: Record "Vendor Ledger Entry";
    begin
        LineTotalAppliedAmount := 0;

        if Rec."Account Type" = Rec."Account Type"::Customer then begin
            CLERec.Reset();
            CLERec.SetRange("Customer No.", Rec."Account No.");
            CLERec.SetRange("Applies-to ID", Rec."Document No.");
            CLERec.CalcSums("Amount to Apply");
            LineTotalAppliedAmount := CLERec."Amount to Apply";
        end;

        if Rec."Account Type" = Rec."Account Type"::Vendor then begin
            VLERec.Reset();
            VLERec.SetRange("Vendor No.", Rec."Account No.");
            VLERec.SetRange("Applies-to ID", Rec."Document No.");
            VLERec.CalcSums("Amount to Apply");
            LineTotalAppliedAmount := VLERec."Amount to Apply";
        end;
    end;

    var
        IntegrationCU: Codeunit "PMP Integrations";
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        LineTotalAppliedAmount: Decimal;
}