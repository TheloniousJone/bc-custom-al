tableextension 56214 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(56200; "Transferred to OH"; Boolean)
        {
            Caption = 'Transferred to OH';
            DataClassification = ToBeClassified;
        }
        field(56201; "Invoiced to OH"; Boolean)
        {
            Caption = 'Invoiced to OH';
            DataClassification = ToBeClassified;
        }
    }
}
