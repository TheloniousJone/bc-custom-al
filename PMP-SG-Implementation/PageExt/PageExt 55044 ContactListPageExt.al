pageextension 55044 ContactListPageExt extends "Contact List"
{
    layout
    {
        addafter(Name)
        {
            /*
            field("POM Role"; Rec."POM Role")
            {
                ApplicationArea = all;
            }
            */
            field("POM Role"; Rec."POM Role V2")
            {
                ApplicationArea = all;
            }
            //RL    10 Jun 2022
            field("Company No."; Rec."Company No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
