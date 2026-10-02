pageextension 55017 PostedSaleInvSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
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
            field("Selling Price"; Rec."Selling Price")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
            }
            field("Qty To Deliver"; Rec."Qty To Deliver")
            {
                ApplicationArea = all;
            }
            field("FOC Qty To Deliver"; Rec."FOC Qty To Deliver")
            {
                ApplicationArea = all;
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
            field(I9G_LineNFRemarks; Rec.I9G_LineNFRemarks)
            {
                ApplicationArea = all;
                Caption = 'NF Line Remarks';
            }   //DX        12 Jun 26
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

            field("VAT Prod. Posting Group V2"; Rec."VAT Prod. Posting Group") // YF 04 Jan 2023
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                Caption = 'VAT Prod. Posting Group V2'; // YF 04 Jan 2023
                // Comments: To hide in future after upgrade when user request // YF 04 Jan 2023
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
        }

        addafter(Description)
        {
            field(MinShelf; VarMinShelf)
            {
                ApplicationArea = All;
                Editable = false;
                Style = Favorable;
            }
        }

        addlast(Control1)
        {
            field(I9G_ChainRemarks; Rec.I9G_ChainRemarks)
            {
                Caption = 'Chain Remarks';
                ApplicationArea = All;
            }
            field("I9G Line Export"; Rec."I9G Line Export")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Export field.';
                Editable = true;
            }

        }
    }

    actions
    {
        // Add changes to page actions here

    }

    trigger OnAfterGetRecord()
    var
        MiniShelf: Record MinimumShelf;
        VarMinShelf: Date;
    begin
        MiniShelf.Reset();
        MiniShelf.SetRange("No.", Rec."No.");
        MiniShelf.SetRange(Code, Rec."Customer Price Group");
        if MiniShelf.FindFirst() then begin
            // SHRec.reset;
            // SHRec.SetRange("Document Type", Rec."Document Type");
            // SHRec.SetRange("No.", Rec."Document No.");
            // if SHRec.FindFirst() then
            VarMinShelf := CalcDate(MiniShelf.MinShelf, Rec."Posting Date");
            // currpage.update(true);
        end;

    end;

    var
        VarMinShelf: Date;

}