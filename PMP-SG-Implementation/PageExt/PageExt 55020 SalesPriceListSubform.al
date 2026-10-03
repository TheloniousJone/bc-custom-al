pageextension 55020 SalesPriceListSubform extends "Price List Lines"
{
    layout
    {
        addafter("Minimum Quantity")
        {
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
            }
        }
    }
}
