pageextension 56202 ICInboxPurchLinesListExt extends "IC Inbox Purchase Lines"
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
