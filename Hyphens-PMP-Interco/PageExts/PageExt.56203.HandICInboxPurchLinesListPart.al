pageextension 56203 HandICInboxPurchLinesListExt extends "Handled IC Inbox Purch. Lines"
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
