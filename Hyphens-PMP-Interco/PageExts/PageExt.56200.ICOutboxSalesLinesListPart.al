pageextension 56200 ICOutboxSalesLinesListExt extends "IC Outbox Sales Lines"
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

            /*
            field("Qty To Deliver"; Rec."Qty To Deliver")
            {
                ApplicationArea = All;
            }

            field("FOC Qty To Deliver"; Rec."FOC Qty To Deliver")
            {
                ApplicationArea = All;
            }
            */
        }
    }

}
