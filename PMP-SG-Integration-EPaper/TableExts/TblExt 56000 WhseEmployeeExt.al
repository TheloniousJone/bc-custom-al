tableextension 56000 WhseEmployeeExt extends "Warehouse Employee"
{
    fields
    {
        // Add changes to table fields here
        field(56000; "LED Tag Colour"; Option)
        {
            OptionMembers = " ",Red,Green,Blue,Yellow,Magenta,Cyan;
            OptionCaption = ' ,Red,Green,Blue,Yellow,Magenta,Cyan';
            Caption = 'LED Tag Colour';
        }

    }

}