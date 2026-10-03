pageextension 55043 ContactCardPageExt extends "Contact Card"
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
            field("MCR Number"; Rec."MCR Number")
            {
                ApplicationArea = all;
            }
        }
    }
}
