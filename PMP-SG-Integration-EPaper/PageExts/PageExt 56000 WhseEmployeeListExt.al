pageextension 56000 WhseEmployeeListExt extends "Warehouse Employee List"
{
    layout
    {
        addafter("Location Code")
        {
            field("LED Tag Colour"; Rec."LED Tag Colour")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}
