pageextension 55099 WarehouseMovementPageExt extends "Warehouse Movement"
{
    layout
    {
        // layout changes here
    }

    actions
    {
        // YF 15 Oct 2021 // Alternate Method to Update SO Stock Flags during Movement or Putaway

        modify("Registered Movements")
        {
            ApplicationArea = All;

            trigger OnBeforeAction()
            var
                WhseActLine: Record "Warehouse Activity Line";
                ItemCode: Code[20];
                LocationCode: Code[20];
            begin
                EntryNo := 1;
                TempStagingRec.Reset;
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not TempStagingRec.IsEmpty then
                    TempStagingRec.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock

                WhseActLine.Reset;
                WhseActLine.SetRange("Activity Type", Rec.Type);
                WhseActLine.SetRange("No.", Rec."No.");
                WhseActLine.SetCurrentKey("Item No.", "Location Code");
                WhseActLine.SetAscending("Item No.", true);
                WhseActLine.SetAscending("Location Code", true);
                if WhseActLine.FindSet() then
                    repeat
                        if (WhseActLine."Item No." <> ItemCode) Or (WhseActLine."Location Code" <> LocationCode) then begin
                            TempStagingRec.Init();
                            TempStagingRec."Entry No." := EntryNo;
                            TempStagingRec."Item No." := WhseActLine."Item No.";
                            TempStagingRec."Document No." := WhseActLine."Location Code";
                            TempStagingRec.Insert;
                            EntryNo += 1;
                            ItemCode := WhseActLine."Item No.";
                            LocationCode := WhseActLine."Location Code";
                        end;
                    until WhseActLine.Next() = 0;

            end;

            trigger OnAfterAction()
            begin
                Clear(EnhanceCU);

                TempStagingRec.Reset;
                if TempStagingRec.FindSet() then
                    repeat
                        EnhanceCU.UpdateSOStockStatusFlags(TempStagingRec."Item No.", TempStagingRec."Document No.");
                        TempStagingRec.Delete();
                    until TempStagingRec.Next() = 0;
            end;
        }

        modify("&Register Movement")
        {
            ApplicationArea = All;

            trigger OnBeforeAction()
            var
                WhseActLine: Record "Warehouse Activity Line";
                ItemCode: Code[20];
                LocationCode: Code[20];
            begin
                EntryNo := 1;
                TempStagingRec.Reset;
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not TempStagingRec.IsEmpty then
                    TempStagingRec.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock

                WhseActLine.Reset;
                WhseActLine.SetRange("Activity Type", Rec.Type);
                WhseActLine.SetRange("No.", Rec."No.");
                WhseActLine.SetCurrentKey("Item No.", "Location Code");
                WhseActLine.SetAscending("Item No.", true);
                WhseActLine.SetAscending("Location Code", true);
                if WhseActLine.FindSet() then
                    repeat
                        if (WhseActLine."Item No." <> ItemCode) Or (WhseActLine."Location Code" <> LocationCode) then begin
                            TempStagingRec.Init();
                            TempStagingRec."Entry No." := EntryNo;
                            TempStagingRec."Item No." := WhseActLine."Item No.";
                            TempStagingRec."Document No." := WhseActLine."Location Code";
                            TempStagingRec.Insert;
                            EntryNo += 1;
                            ItemCode := WhseActLine."Item No.";
                            LocationCode := WhseActLine."Location Code";
                        end;
                    until WhseActLine.Next() = 0;

            end;

            trigger OnAfterAction()
            begin
                Clear(EnhanceCU);

                TempStagingRec.Reset;
                if TempStagingRec.FindSet() then
                    repeat
                        EnhanceCU.UpdateSOStockStatusFlags(TempStagingRec."Item No.", TempStagingRec."Document No.");
                        TempStagingRec.Delete();
                    until TempStagingRec.Next() = 0;
            end;
        }

        // YF 15 Oct 2021 // Alternate Method to Update SO Stock Flags during Movement or Putaway
    }

    var
        EnhanceCU: Codeunit "PMP-Enhancements";
        TempStagingRec: Record "TBA Ledger Entry" temporary;
        EntryNo: Integer;
}
