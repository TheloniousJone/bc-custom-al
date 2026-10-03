tableextension 55046 PostedGenJnlLineTblExt extends "Posted Gen. Journal Line"
{
    fields
    {
        field(55000; "Journal Batch Description"; Text[100])
        {
            Caption = 'Journal Batch Description';
            DataClassification = ToBeClassified;
        }
    }
    //DX        13 Jun 2023
    keys
    {
        key(i9Key1; "Document No.")
        {

        }
        key(i9Key2; "Account Type", "Account No.")
        {
        }


        key(i9Key3; "Source Type", "Source No.")
        {
        }
        key(i9Key4; "Posting Date", "Document No.")
        {
        }
        key(i9Key5; "Account Type", "Sell-to/Buy-from No.")
        {
        }
        //DX        13 Jun 2023
    }
}
