tableextension 55050 BankAcctLedgerEntryTblExt extends "Bank Account Ledger Entry"
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
