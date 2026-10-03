pageextension 56201 HandICOutboxSalesLinesListExt extends "Handled IC Outbox Sales Lines"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = All;
            }

            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = All;
            }

            field("Selling Price"; Rec."Selling Price")
            {
                ApplicationArea = All;
            }
        }
    }

}
