pageextension 55024 PostedPRSubformExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
            }
            //DX        17 Aug 2021
            field(Exchangeable; Rec.Exchangeable)
            {
                ApplicationArea = all;
            }
            //DX        17 Aug 2021

            field(I9G_SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'I9G System Modified At';
                Visible = false;
            }
        }
    }
}
