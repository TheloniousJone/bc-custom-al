tableextension 55049 VendLedgerEntryTblExt extends "Vendor Ledger Entry"
{
    fields
    {
        field(55000; "Journal Batch Description"; Text[100])
        {
            Caption = 'Journal Batch Description';
            DataClassification = ToBeClassified;
        }
        field(55001; "I9G_YourReference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }

    }
}
