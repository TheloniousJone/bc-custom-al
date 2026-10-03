pageextension 55097 PurchRetOrderSubformPageExt extends "Purchase Return Order Subform"
{
    layout
    {

        modify("Unit of Measure Code")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            var
                ItemUOM: Record "Item Unit of Measure";
                ItemRec: Record Item;
            begin
                // Issue #388 : Overwrite Description with Alternate descr from Item UOM Table
                if ItemRec.Get(Rec."No.") then
                    Rec.Description := ItemRec.Description;

                ItemUOM.Reset;
                ItemUOM.SetRange("Item No.", Rec."No.");
                ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                if ItemUOM.FindFirst() then begin
                    if StrLen(ItemUOM."Alternate Description") > 0 then
                        Rec.Description := ItemUOM."Alternate Description";
                end;
            end;
        }
    }

}
