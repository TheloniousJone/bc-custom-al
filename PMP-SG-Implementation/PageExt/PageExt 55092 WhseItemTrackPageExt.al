pageextension 55092 WhseItemTrackPageExt extends "Whse. Item Tracking Lines"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
        WhseJnl: Record "Whse. Worksheet Line";
    begin
        if Rec."Lot No." <> '' then begin

        end;
    end;

    procedure GetFirstBatchOfBin(TrackLine: Record "Whse. Item Tracking Line")
    var
        lItemRec: Record Item;
        lWarehouseEntryRec: Record "Warehouse Entry";
        QuryRep: Query 55001;
        TempILERec: Record "Item Ledger Entry" temporary;
        EntryNo: Integer;
        MovementRec: Record "Whse. Worksheet Line";
        Bincode: Code[20];
    begin
        MovementRec.reset;
        MovementRec.SetRange("Worksheet Template Name", 'MOVEMENT');
        MovementRec.SetRange(Name, TrackLine."Source ID");
        MovementRec.SetRange("Item No.", TrackLine."Item No.");
        MovementRec.SetRange("Line No.", TrackLine."Source Ref. No.");
        if MovementRec.FindFirst() then begin
            Bincode := MovementRec."To Bin Code";
        end;
        gBatchLotNo := '';

        EntryNo := 1;
        QuryRep.SetFilter(QuryRep.Location_Code, Rec."Location Code");
        QuryRep.SetFilter(QuryRep.Item_No, Rec."Item No.");
        QuryRep.SetFilter(QuryRep.Bin_Code, Bincode);
        QuryRep.Open();
        while QuryRep.Read() do begin
            TempILERec.reset;
            TempILERec."Entry No." := EntryNo;
            TempILERec."Item No." := QuryRep.Item_No;
            TempILERec.Description := QuryRep.ItemDescription;
            TempILERec."External Document No." := QuryRep.Bin_Code;
            TempILERec.Quantity := QuryRep.Sum_Qty_Base;
            TempILERec."Lot No." := QuryRep.Lot_No;
            TempILERec."Expiration Date" := QuryRep.Expiration_Date;
            TempILERec.Insert(FALSE);
            EntryNo += 1;
        end;

        TempILERec.reset;
        TempILERec.SetRange("Item No.", Rec."Item No.");
        TempILERec.SetRange("External Document No.", Bincode);
        TempILERec.SetFilter(Quantity, '>0');
        if TempILERec.FindFirst() then begin
            gBatchLotNo := TempILERec."Lot No.";
        end;

        if gBatchLotNo <> Rec."Lot No." then begin
            Message(StrSubstNo('Entered Lot : %1, Current Lot in Bin : %2', Rec."Lot No.", gBatchLotNo));
        end;
    end;

    var
        gBatchLotNo: Code[60];
}
