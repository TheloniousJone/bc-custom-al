pageextension 55023 PostedPCNSubformExt extends "Posted Purch. Cr. Memo Subform"
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
        addlast(content)
        {
            //DX        15 Aug 2021 
            field(">5K"; Rec.">5K")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(">300K"; Rec.">300K")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(">6 Mth"; Rec.">6 Mth Inventory")
            {
                ApplicationArea = all;
                Editable = false;
            }
            //DX        17 Aug 2021
            field(Exchangeable; Rec.Exchangeable)
            {
                ApplicationArea = all;
            }
            //DX        17 Aug 2021
            //DX        15 Aug 2021 
        }
        addafter(Quantity)
        {
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Line Amount")
        {

            field("I9G_VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                Caption = 'VAT Prod. Posting Group';
            }
        }
    }
}
