pageextension 90005 PstdSalesInvoiceUpdatechain extends "Posted Sales Inv. - Update"
{
    layout
    {
        addlast(General)
        {

            //DX        21 Feb 2024
            field("Apply Chain Conversion"; Rec."Apply Chain Conversion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Apply Chain Conversion field.', Comment = '%';
                Visible = false;
            }
        }
    }

    actions
    {

    }
}