pageextension 90003 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addafter("Chain Pharmacy")
        {
            field("Apply Chain Conversion"; Rec."Apply Chain Conversion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Apply Chain Conversion field.', Comment = '%';
            }
        }
    }
}
