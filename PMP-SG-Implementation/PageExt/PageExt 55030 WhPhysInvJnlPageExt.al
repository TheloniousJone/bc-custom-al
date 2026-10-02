pageextension 55030 WhPhysInvJnlPageExt extends "Whse. Phys. Invt. Journal"
{
    layout
    {
        addafter("Lot No.")
        {

            field("I9G_Expiration Date"; Rec."Expiration Date")
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Expiration Date';
            } //I9 040423 - Update version
            field("Phys. Inventory"; Rec."Phys. Inventory")
            {
                ApplicationArea = All;
                Editable = True;
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                Visible = false;
            }

        }
        modify("Lot No.")
        {
            ApplicationArea = All;
            Visible = True;
            trigger OnAfterValidate()
            var
                ILERec: Record "Item Ledger Entry";

            begin
                ILERec.Reset();
                ILERec.SetRange("Item No.", rec."Item No.");
                ILERec.SetRange("Lot No.", Rec."Lot No.");
                if ILERec.FindFirst() then
                    Rec.Validate("Expiration Date", ILERec."Expiration Date");
            end;
        }
        modify("Qty. (Calculated)")
        {
            Visible = false;
        }
        modify(Quantity)
        {
            Visible = false;
        }
    }
    actions
    {

    }
}
