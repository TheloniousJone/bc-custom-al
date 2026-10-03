pageextension 55079 GeneralJnlPageExt extends "General Journal"
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
            group("Total Debit ")
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

            group("Total Credit ")
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
        addafter(Amount)
        {
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = All;
            }
            field(I9G_YourReference; Rec.I9G_YourReference)
            {
                Caption = 'Your Reference';
                ApplicationArea = all;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            action("Import BIPO HR")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IntegrationCU.ImportBIPOHREntries(Rec."Journal Batch Name");
                end;
            }

            action("Import BIPO Expense")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IntegrationCU.ImportBIPOExpenseEntries(Rec."Journal Batch Name");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcTotalDebitCreditAmount();
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        CalcTotalDebitCreditAmount();
    end;

    trigger OnOpenPage()
    begin
        CalcTotalDebitCreditAmount();
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

    var
        IntegrationCU: Codeunit "PMP Integrations";
        TotalDebit: Decimal;
        TotalCredit: Decimal;
}