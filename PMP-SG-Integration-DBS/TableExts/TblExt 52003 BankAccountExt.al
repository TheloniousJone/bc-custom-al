tableextension 52003 DBSBankAcctExt extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(52000; "H2H Export Account No."; Text[30])
        {
            Caption = 'DBS H2H Export Account No.';
            DataClassification = ToBeClassified;
        }
    }

}