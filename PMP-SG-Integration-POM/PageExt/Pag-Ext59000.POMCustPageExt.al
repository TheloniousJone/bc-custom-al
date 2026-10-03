pageextension 59000 POMCustPageExt extends "Customer Card"
{
    layout
    {
        addafter("Salesperson Code")
        {
            /*
            field("POM No."; Rec."POM No.")
            {
                ApplicationArea = all;
            }
            */

            field("Web User ID"; Rec."Web User ID")
            {

                ApplicationArea = all;
            }
            field("Web User Name"; Rec."Web User Name")
            {
                ApplicationArea = all;
            }
        }
    }
}
