pageextension 60104 LocCardPageExt extends "Location Card"
{
    layout
    {
        addafter("Address 2")
        {
            field("Wellaway Location"; Rec."Wellaway Location")
            {
                ApplicationArea = all;
            }
        }
    }
}
