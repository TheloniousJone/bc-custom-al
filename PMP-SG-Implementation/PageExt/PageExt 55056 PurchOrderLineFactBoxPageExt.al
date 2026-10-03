pageextension 55056 PurchOrderLineFactBoxPageExt extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field(MinHold; MinHold)
            {
                ApplicationArea = all;
                Caption = 'Min Holding Days';
            }
            field(MaxHold; MaxHold)
            {
                Caption = 'Max Holding Days';
                ApplicationArea = all;
            }
            field(minQty; minQty)
            {
                Caption = 'Minimum Qty';
                ApplicationArea = all;
            }
            field(MaxQty; MaxQty)
            {
                Caption = 'Maximum Qty';
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        if Rec.Type = Rec.Type::Item then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then begin
                MinHold := ItemRec."Min Holding Days";
                MaxHold := ItemRec."Max Holding Days";
                MaxQty := ItemRec."Maximum Inventory";
                minQty := ItemRec."Reorder Point";
            end;
        end;

    end;

    var
        MaxQty: Decimal;
        minQty: Decimal;
        MinHold: Decimal;
        MaxHold: Decimal;
        ItemRec: Record item;
}
