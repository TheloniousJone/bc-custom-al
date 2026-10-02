tableextension 55045 FALedgerEntryTblExt extends "FA Ledger Entry"
{
    fields
    {
        field(55000; "Journal Batch Description"; Text[100])
        {
            Caption = 'Journal Batch Description';
            DataClassification = ToBeClassified;
        }

    }
}
