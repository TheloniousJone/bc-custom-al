pageextension 52151 CitiBankAcctCardExt extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account No.")
        {
            field("Citibank Export Account No."; Rec."Citibank Export Account No.")
            {
                ApplicationArea = All;
            }
        }
    }

}