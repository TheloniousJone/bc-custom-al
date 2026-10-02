pageextension 55090 BankLedgerEntriesPageExt extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Document Type")
        {
            field("Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = All;
            }

            field("Journal Batch Description"; Rec."Journal Batch Description")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Amount)
        //RL 23 Feb 2022
        {
            field(PaymentReference; PaymentReference)
            {
                ApplicationArea = All;
            }
        }
        //RL 23 Feb 2022
    }
    trigger OnAfterGetRecord()
    var
        PGJRec: Record "Posted Gen. Journal Line";
    begin

        PGJRec.Reset();
        Clear(PaymentReference);
        PGJRec.SetRange("Document No.", rec."Document No.");
        PGJRec.SetFilter("Payment Reference", '<>%1', '');
        if PGJRec.FindFirst() then begin
            PaymentReference := PGJRec."Payment Reference";
        end;

    end;

    var
        PaymentReference: text[100];
}
