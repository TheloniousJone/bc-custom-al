tableextension 52151 CitiBankAcctExt extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(52150; "Citibank Export Account No."; Text[30])
        {
            Caption = 'Citibank Export Account No.';
            DataClassification = ToBeClassified;
        }
    }

}