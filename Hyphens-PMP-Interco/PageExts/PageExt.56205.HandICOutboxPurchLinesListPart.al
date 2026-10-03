pageextension 56205 HandICOutboxPurchLinesListExt extends "Handled IC Outbox Purch. Lines"
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

            field("Purchase Price"; Rec."Purchase Price")
            {
                ApplicationArea = All;
            }
        }
    }

}
