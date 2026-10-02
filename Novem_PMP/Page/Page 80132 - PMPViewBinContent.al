Page 80132 "ViewBinContent3PL"
{
    Caption = 'Bin Content 3PL';
    DelayedInsert = true;
    PageType = List;
    SourceTable = I9G_TempTable;
    SourceTableTemporary = true;
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Location Code"; Rec.Code5)
                {
                    ApplicationArea = Location;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the location code of the bin.';
                }
                field("Bin Code"; Rec.Code4)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Bin Code';
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                }
                field("Item No."; Rec.Code1)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Item Code';
                    ToolTip = 'Specifies the number of the item that will be stored in the bin.';
                }
                field(Description; Rec.Text1)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec.Code3)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'UOM';
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("LotNo"; Rec.Code2)
                {
                    Caption = 'Lot No.';
                    ApplicationArea = all;
                }
                field("ExpirationDate"; Rec.Date1)
                {
                    Caption = 'Expiration Date';
                    ApplicationArea = all;
                }
                field("Quantity (Base)"; Rec.Decimal1)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Gross Stock';
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                    Style = Attention;
                }
                field("Pick Quantity (Base)"; Rec.Decimal2)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'To Be Picked';
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, will be picked from the bin.';
                }
                field("AvailToPick"; Rec.Decimal3)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Net Available Stock';
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, will be put away in the bin.';
                    Style = Strong;
                }
            }
        }
    }

    procedure SetData()
    var
        myInt: Integer;
        PMPBinContent: Record "Bin Content";
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        WHEntries: record "Warehouse Entry";
        WHActivity: Record "Warehouse Activity Line";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        totalCount: Decimal;
        TotalPickCount: Decimal;
        lotIntno: Integer;
        ItemRec: Record Item;
    begin
        entryno := 1;
        lotIntno := 1;
        //if I9G_ThirdPartyLogisticSetupRec.Get() then begin
        // if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
        PMPBinContent.reset;
        PMPBinContent.ChangeCompany('PMP');
        PMPBinContent.SetLoadFields("Location Code", "Item No.", "Bin Code", Quantity, "Quantity (Base)", "Pick Quantity (Base)", "Pick Qty.", "Unit of Measure Code");
        PMPBinContent.SetRange("Location Code", 'PMP-WH');
        if PMPBinContent.FindSet() then
            repeat
                clear(totalCount);
                Clear(TotalPickCount);
                ItemRec.Reset();
                ItemRec.ChangeCompany('PMP');
                ItemRec.SetLoadFields("No.", "Gen. Prod. Posting Group");
                ItemRec.SetRange("No.", PMPBinContent."Item No.");
                ItemRec.SetRange("Gen. Prod. Posting Group", 'LS-NOVEM');
                if ItemRec.FindFirst() then begin
                    WHEntries.reset;
                    WHEntries.ChangeCompany('PMP');
                    WHEntries.SetLoadFields("Location Code", "Item No.", "Unit of Measure Code", "Qty. (Base)", Quantity);
                    WHEntries.SetRange("Item No.", PMPBinContent."Item No.");
                    WHEntries.SetRange("Location Code", PMPBinContent."Location Code");
                    WHEntries.SetRange("Unit of Measure Code", PMPBinContent."Unit of Measure Code");
                    WHEntries.SetRange("Bin Code", PMPBinContent."Bin Code");
                    if WHEntries.FindSet() then     //find unique lot by item first.
                        repeat
                            i9tempLot2.reset;
                            i9tempLot2.SetRange(Code1, WHEntries."Item No.");
                            i9tempLot2.SetRange(Code2, WHEntries."Lot No.");
                            i9tempLot2.SetRange(Code3, WHEntries."Unit of Measure Code");
                            i9tempLot2.SetRange(Code4, WHEntries."Bin Code");
                            if not (i9tempLot2.FindFirst()) then begin
                                i9tempLot.reset;
                                i9tempLot."Entry No." := lotIntno;
                                i9tempLot.Code1 := WHEntries."Item No.";
                                i9tempLot.Code2 := WHEntries."Lot No.";
                                i9tempLot.Code3 := WHEntries."Unit of Measure Code";
                                i9tempLot.Code4 := WHEntries."Bin Code";
                                i9tempLot.Code5 := WHEntries."Location Code";
                                ItemLedgerEntryRec.Reset();
                                if ItemLedgerEntryRec.ChangeCompany('PMP') then begin
                                    ItemLedgerEntryRec.SetRange("Location Code", WHEntries."Location Code");
                                    ItemLedgerEntryRec.SetRange("Lot No.", WHEntries."Lot No.");
                                    ItemLedgerEntryRec.SetRange("Item No.", WHEntries."Item No.");
                                    if ItemLedgerEntryRec.FindFirst() then begin
                                        i9tempLot.Date1 := ItemLedgerEntryRec."Expiration Date";
                                    end;
                                end;
                                i9tempLot.Insert(false);
                                i9tempLot2.Copy(i9tempLot);
                                i9tempLot2.Insert(false);
                                lotIntno += 1;
                            end;
                        until WHEntries.next = 0;
                end;
            until PMPBinContent.next = 0;
        if i9tempLot.FindSet() then
            repeat
                WHEntries.reset;
                WHEntries.ChangeCompany('PMP');
                WHEntries.SetLoadFields("Location Code", "Item No.", "Unit of Measure Code", "Qty. (Base)", Quantity);
                WHEntries.SetRange("Item No.", i9tempLot.Code1);
                WHEntries.SetRange("Location Code", PMPBinContent."Location Code");
                WHEntries.SetRange("Unit of Measure Code", i9tempLot.Code3);
                WHEntries.SetRange("Lot No.", i9tempLot.Code2);
                WHEntries.SetRange("Bin Code", i9tempLot.code4);
                WHEntries.CalcSums("Qty. (Base)");
                totalCount := WHEntries."Qty. (Base)";

                WHActivity.reset;
                WHActivity.ChangeCompany('PMP');
                WHActivity.SetLoadFields("Action Type", "Activity Type", "Bin Code", "Item No.", "Location Code", "Qty. (Base)");
                WHActivity.SetRange("Action Type", WHActivity."Action Type"::Take);
                WHActivity.SetRange("Activity Type", WHActivity."Activity Type"::Pick);
                WHActivity.SetRange("Bin Code", i9tempLot.code4);
                WHActivity.SetRange("Item No.", i9tempLot.Code1);
                WHActivity.SetRange("Location Code", PMPBinContent."Location Code");
                WHActivity.CalcSums("Qty. Outstanding (Base)");
                TotalPickCount := WHActivity."Qty. Outstanding (Base)";


                Rec.init;
                Rec."Entry No." := entryno;
                Rec.Code2 := i9tempLot.Code2;        //lot nO.
                Rec.Code5 := i9tempLot.code5;       // locatio
                Rec.Code4 := i9templot.code4;       //Bin Code
                Rec.Code1 := i9templot.code1;       //Item
                Rec.Code3 := i9templot.code3;       //UOM
                Rec.Date1 := i9tempLot.Date1;        // Expiration Date
                ItemRec.reset;
                ItemRec.SetLoadFields(Description);
                ItemRec.SetRange("No.", i9templot.code1);
                if ItemRec.FindFirst() then begin
                    Rec.Text1 := ItemRec.Description;
                end;
                Rec.Decimal1 := totalCount;
                Rec.decimal2 := TotalPickCount;
                Rec.Decimal3 := totalCount - TotalPickCount;
                Rec.Insert(FALSE);
                entryno += 1;
            until i9tempLot.next = 0;
    end;

    //end;
    //end;
    // end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SetData();
    end;

    var
        i9temp: Record I9G_TempTable temporary;
        i9tempLot: Record I9G_TempTable temporary;
        i9tempLot2: Record I9G_TempTable temporary;
        entryno: Integer;
        ItemRec: Record Item;
}