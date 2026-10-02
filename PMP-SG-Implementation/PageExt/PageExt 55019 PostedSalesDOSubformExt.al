pageextension 55019 PostedSalesDOSubformExt extends "Posted Sales Shpt. Subform"
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
        addbefore("Quantity Invoiced")
        {

            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
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

    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        MiniShelf.Reset();
        MiniShelf.SetRange("No.", Rec."No.");
        MiniShelf.SetRange(Code, Rec."Customer Price Group");
        if MiniShelf.FindFirst() then begin
            VarMinShelf := CalcDate(MiniShelf.MinShelf, Rec."Posting Date");
        end;
    end;

    var
        myInt: Integer;
        MiniShelf: Record MinimumShelf;
        VarMinShelf: Date;
}