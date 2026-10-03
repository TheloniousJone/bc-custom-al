pageextension 56001 WhseEmployeesExt extends "Warehouse Employees"
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
