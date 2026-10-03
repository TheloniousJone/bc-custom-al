pageextension 50033 BankAccountCard extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Name 2";Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}