pageextension 55022 PostedPISubformExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
            }

            field("Purchase Price"; Rec."Purchase Price")
            {
                ApplicationArea = all;
                DecimalPlaces = 2 : 5;
                BlankZero = true;
                Style = Standard;

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

            field(I9G_SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'I9G System Modified At';
                Visible = false;
            }
        }
        addafter(Quantity)
        {
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
            }
        }
        addafter("Direct Unit Cost")
        {
            field("I9G_VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'VAT Prod. Posting Group';
            }
            field("I9G_For Tender"; Rec."For Tender")
            {
                Caption = 'For Tender';
                ApplicationArea = All;
                Visible = false;
            }
            field("I9G_Tender Qty"; Rec."Tender Qty")
            {
                Caption = 'Tender Qty';
                ApplicationArea = All;
                Visible = false;
            }
        }

    }
}
