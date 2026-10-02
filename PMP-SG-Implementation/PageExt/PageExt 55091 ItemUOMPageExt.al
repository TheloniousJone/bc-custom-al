pageextension 55091 ItemUOMPageExt extends "Item Units of Measure"
{
    layout
    {
        addafter(Weight)
        {
            field("Alternate Description"; Rec."Alternate Description")
            {
                ApplicationArea = All;
            }
        }
    }
}
