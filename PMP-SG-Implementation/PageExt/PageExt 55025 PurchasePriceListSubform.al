pageextension 55025 PurchasePriceListSubform extends "Purchase Price List Lines"
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
