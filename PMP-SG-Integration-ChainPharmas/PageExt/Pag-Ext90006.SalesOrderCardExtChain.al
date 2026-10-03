pageextension 90006 SalesOrderCardExtChain extends "Sales Order"
{
    layout
    {
        addlast(General)
        {

            field("Apply Chain Conversion"; Rec."Apply Chain Conversion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Apply Chain Conversion field.', Comment = '%';
                Visible = false;
            }
        }
    }
}
