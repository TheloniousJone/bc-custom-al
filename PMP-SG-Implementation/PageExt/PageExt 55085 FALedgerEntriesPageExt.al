pageextension 55085 FALedgerEntriesPageExt extends "FA Ledger Entries"
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
    }
}
