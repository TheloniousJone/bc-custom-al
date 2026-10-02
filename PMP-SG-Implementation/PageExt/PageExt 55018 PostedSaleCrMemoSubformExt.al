pageextension 55018 PostedSaleCrMemoSubformExt extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Line Discount %")
        {
            //LK231123
            field("I9G QC/QA Comments"; Rec."I9G QC/QA Comments")
            {
                ApplicationArea = All;

            }
            //LK231123
        }
        // Add changes to page layout here
        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
            }
            field("Selling Price"; Rec."Selling Price")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
            }
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
            }
            field("To Del. Amt"; Rec."To Del. Amt")
            {
                ApplicationArea = all;
                Editable = false;
            }

            // YF 25 Aug 2021
            field("PO Import Price"; Rec."PO Import Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
            // YF 25 Aug 2021
            field("Remarks"; Rec."I9G Remarks")
            {
                ApplicationArea = All;
                Caption = 'Remarks';
            }
        }

        // YF            22 Oct 2021
        addbefore("Unit of Measure Code")
        {
            field("ZP Customer Name"; Rec."ZP Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("ZP SP"; Rec."ZP SP")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("ZP Detailman"; Rec."ZP Detailman")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        // YF            22 Oct 2021
        addbefore("Line Amount")
        {

            field("I9G_VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                Caption = 'VAT Prod. Posting Group';
            }
        }
        addlast(Control1)
        {
            field("I9G Driver Reason"; Rec."I9G Driver Reason")
            {
                ApplicationArea = All;
            }
            field(I9G_ChainRemarks; Rec.I9G_ChainRemarks)
            {
                Caption = 'Chain Remarks';
                ApplicationArea = All;
            }

            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                Caption = 'System Modified At';
                ApplicationArea = All;
                Editable = false;
            }

            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                Caption = 'System Modified By';
                ApplicationArea = All;
                Editable = false;
            }
            field(I9G_RequiredLOU; Rec.I9G_RequiredLOU)
            {
                applicationArea = All;
                editable = false;
            }
            field(I9G_Restriction; Rec.I9G_Restriction)
            {
                applicationArea = All;
                editable = false;
            }
            field(I9G_LineNFRemarks; Rec.I9G_LineNFRemarks)
            {
                ApplicationArea = all;
                Caption = 'NF Line Remarks';
            }   //DX        12 Jun 26

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}