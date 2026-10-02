pageextension 52004 DBSBankAcctCardExt extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account No.")
        {
            field("H2H Export Account No."; Rec."H2H Export Account No.")
            {
                ApplicationArea = All;
            }
        }
    }

}