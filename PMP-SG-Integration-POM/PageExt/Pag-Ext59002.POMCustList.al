pageextension 59002 POMCustList extends "Customer List"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("POM No."; Rec."POM No.")
            {
                ApplicationArea = all;
            }

            field("Customer Status"; Rec."Customer Status")
            {
                ApplicationArea = All;
            }
            //  RL 10 Jan 2021
            field("Web User ID"; Rec."Web User ID")
            {

                ApplicationArea = all;
            }
            field("Web User Name"; Rec."Web User Name")
            {
                ApplicationArea = all;
            }
            field("Web User Email"; Rec."Web User Email")
            {
                ApplicationArea = all;
            }
            //  RL 10 Jan 2021
        }
    }
}
