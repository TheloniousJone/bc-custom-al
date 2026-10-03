pageextension 55071 BinContentsListExt extends "Bin Contents List"
{
    layout
    {
        addafter("Item No.")
        {
            field(gItemName; gItemName)
            {
                ApplicationArea = All;
                Caption = 'Item Name';
                Editable = false;
            }

            field(gBatchLotNo; gBatchLotNo)
            {
                ApplicationArea = All;
                Caption = 'Batch No.';
                Editable = false;
            }

            field(gExpiryDate; gExpiryDate)
            {
                ApplicationArea = All;
                Caption = 'Expiry Date';
                Editable = false;
            }
        }
    }

    var
        gItemName: Text[100];
        gBatchLotNo: Code[50];
        gExpiryDate: Date;

    local procedure PopulateData()
    var
        lItemRec: Record Item;
        lWarehouseEntryRec: Record "Warehouse Entry";
    begin
        gItemName := '';
        gBatchLotNo := '';
        gExpiryDate := 0D;

        if lItemRec.Get(Rec."Item No.") then
            gItemName := lItemRec.Description;

        lWarehouseEntryRec.Reset;
        lWarehouseEntryRec.SetLoadFields("Entry No.", "Item No.", "Variant Code", "Lot No.", "Expiration Date", "Bin Code", "Location Code", "Unit of Measure Code");     //DX        24 May 2023

        lWarehouseEntryRec.SetRange("Item No.", Rec."Item No.");
        lWarehouseEntryRec.SetRange("Variant Code", Rec."Variant Code");
        lWarehouseEntryRec.SetRange("Bin Code", Rec."Bin Code");
        lWarehouseEntryRec.SetRange("Location Code", Rec."Location Code");
        lWarehouseEntryRec.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        // lWarehouseEntryRec.SetRange("Entry Type", lWarehouseEntryRec."Entry Type"::"Positive Adjmt.");

        // lWarehouseEntryRec.SetFilter("Lot No.", Rec."Lot No.");
        lWarehouseEntryRec.SetCurrentKey("Entry No.");
        lWarehouseEntryRec.SetAscending("Entry No.", false);
        if lWarehouseEntryRec.FindFirst() then begin
            gBatchLotNo := lWarehouseEntryRec."Lot No.";
            // gExpiryDate := lWarehouseEntryRec."Expiration Date";
        end;

    end;


    trigger OnAfterGetCurrRecord()
    begin
        //PopulateData();
    end;

    trigger OnAfterGetRecord()
    var
        lItemRec: Record Item;
        lWarehouseEntryRec: Record "Warehouse Entry";
        QuryRep: Query 55001;
        ILERec: Record "Item Ledger Entry";
        TempILERec: Record "Item Ledger Entry" temporary;
        DefLotQuery: Query 7300;
        EntryNo: Integer;
    begin
        //DX        30 May 2023

        gItemName := '';
        gBatchLotNo := '';
        gExpiryDate := 0D;
        EntryNo := 1;
        //DX        03 Jun 2023         Restructure the code to just take first line of Query, assign var and exit loop immediately
        /*
                clear(QuryRep);
                QuryRep.SetFilter(QuryRep.Location_Code, Rec."Location Code");
                QuryRep.SetFilter(QuryRep.Item_No, Rec."Item No.");
                QuryRep.SetFilter(QuryRep.Bin_Code, Rec."Bin Code");
                QuryRep.SetFilter(QuryRep.Zone_Code, Rec."Zone Code");    //DX        03 June 2023
                QuryRep.SetFilter(QuryRep.Variant_Code, Rec."Variant Code");     //DX        03 June 2023        
                QuryRep.SetFilter(QuryRep.Unit_of_Measure_Code, Rec."Unit of Measure Code");   //DX        03 June 2023
                QuryRep.TopNumberOfRows(1);       //DX        03 June 2023
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
                QuryRep.Close();
                */
        //DX        03 June 2023        Change to using back default lot number by bin query instead for performance.
        //DX        03 June 2023        Previous query 55003 was joined to ILE OPEN = TRUE, default less 1 join which improves performance, so revert to original query first.
        clear(DefLotQuery);
        DefLotQuery.SetFilter(DefLotQuery.Location_Code, Rec."Location Code");
        DefLotQuery.SetFilter(DefLotQuery.Item_No, Rec."Item No.");
        DefLotQuery.SetFilter(DefLotQuery.Bin_Code, Rec."Bin Code");
        DefLotQuery.SetFilter(DefLotQuery.Zone_Code, Rec."Zone Code");    //DX        03 June 2023
        DefLotQuery.SetFilter(DefLotQuery.Variant_Code, Rec."Variant Code");     //DX        03 June 2023        
        DefLotQuery.SetFilter(DefLotQuery.Unit_of_Measure_Code, Rec."Unit of Measure Code");   //DX        03 June 2023
        DefLotQuery.Open();
        while DefLotQuery.Read() do begin
            TempILERec.reset;
            TempILERec."Entry No." := EntryNo;
            TempILERec."Item No." := DefLotQuery.Item_No;
            //TempILERec.Description := testquery.ItemDescription;
            TempILERec."External Document No." := DefLotQuery.Bin_Code;
            TempILERec.Quantity := DefLotQuery.Sum_Qty_Base;
            TempILERec."Lot No." := DefLotQuery.Lot_No;
            //TempILERec."Expiration Date" := testquery.Expiration_Date;
            TempILERec.Insert(FALSE);
            EntryNo += 1;
        end;
        DefLotQuery.Close();

        TempILERec.reset;
        TempILERec.SetLoadFields("Item No.", Description, "Entry No.", "External Document No.", Quantity, "Lot No.", "Expiration Date");
        TempILERec.SetCurrentKey("Item No.", "External Document No.");   //DX        24 may 2023
        TempILERec.SetRange("Item No.", Rec."Item No.");
        TempILERec.SetFilter("External Document No.", '%1', Rec."Bin Code");        //DX        24 May 2023
        TempILERec.SetFilter(Quantity, '>0');
        if TempILERec.FindFirst() then begin
            gBatchLotNo := TempILERec."Lot No.";
            //DX        03 June 2023 change to after retrieval of first record then go find the expiration and description.
            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Lot No.", "Expiration Date", Description);        //DX        03 June 2023
            ILERec.SetCurrentKey("Item No.", "Lot No.");
            ILERec.SetRange("Item No.", TempILERec."Item No.");
            ILERec.SetRange("Lot No.", TempILERec."Lot No.");
            if ILERec.FindLast() then begin
                gExpiryDate := ILERec."Expiration Date";
                gItemName := ILERec.Description;
            end;
        end;
    end;
}
