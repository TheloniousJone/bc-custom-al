pageextension 55046 InvShipSubformPageExt extends "Invt. Shipment Subform"
{
    layout
    {
        addafter("Item No.")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Unit of Measure Code")
        {
            field("I9 Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    var
        InvtDocHeaderRec: Record "Invt. Document Header";
    begin
        if InvtDocHeaderRec.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."Bin Code" := InvtDocHeaderRec."Bin Code";
            Rec."Gen. Prod. Posting Group" := InvtDocHeaderRec."Gen. Prod. Posting Group";
            Rec."Customer No." := InvtDocHeaderRec."Customer No.";
            Rec."Salespers./Purch. Code" := InvtDocHeaderRec."Salesperson/Purchaser Code";
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        InvtDocHeaderRec: Record "Invt. Document Header";
    begin
        if InvtDocHeaderRec.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."Bin Code" := InvtDocHeaderRec."Bin Code";
            Rec."Gen. Prod. Posting Group" := InvtDocHeaderRec."Gen. Prod. Posting Group";
            Rec."Customer No." := InvtDocHeaderRec."Customer No.";
            Rec."Salespers./Purch. Code" := InvtDocHeaderRec."Salesperson/Purchaser Code";
        end;
    end;
}
