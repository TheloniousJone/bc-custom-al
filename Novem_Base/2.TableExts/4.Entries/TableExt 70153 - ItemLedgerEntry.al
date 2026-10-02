tableextension 70153 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(70000; "I9G_CaseNumber"; Code[150])
        {
            Caption = 'Case No.';
        }
        field(70001; "I9G_CaseDR"; Text[100])
        {
            Caption = 'Case DR';
        }
        field(70002; "I9G_ShipToDistrictCode"; Code[20])
        {
            Caption = 'Ship-to District Code';
        }
        field(70003; "I9G_ShipToPostCode"; Code[20])
        {
            Caption = 'Ship-to Post Code';
        }
    }
}