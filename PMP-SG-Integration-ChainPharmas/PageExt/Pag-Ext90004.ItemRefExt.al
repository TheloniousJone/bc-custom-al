pageextension 90004 ItemRefExt extends "Item Reference List"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Apply Chain Conversion"; Rec."Apply Chain Conversion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Apply Chain Conversion field.', Comment = '%';
            }
        }
    }
}
