tableextension 55068 ItemSubstituteExt extends "Item Substitution"
{
    fields
    {

    }
    trigger OnAfterInsert()
    begin
        UpdateItemTimestamp(rec."No.");
    end;

    trigger OnAfterModify()
    begin
        UpdateItemTimestamp(rec."No.");
    end;

    trigger OnAfterDelete()
    begin
        UpdateItemTimestamp(rec."No.");
    end;

    trigger OnAfterRename()
    begin
        UpdateItemTimestamp(rec."No.");
    end;


    local procedure UpdateItemTimestamp(ItemNo: Code[20])
    var
        ItemRec: Record Item;
        Counter: Integer;
    begin
        if ItemRec.Get(ItemNo) then begin
            ItemRec."Last DateTime Modified" := CurrentDateTime;
            if not Evaluate(Counter, ItemRec."Common Item No.") then
                Counter := 0;
            ItemRec."Common Item No." := Format(Counter + 1);
            ItemRec.Modify(false);
        end;
    end;
}
