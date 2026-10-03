report 80140 InventoryMatching3PL
{
    ApplicationArea = All;
    Caption = 'Inventory Matching 3PL';
    UsageCategory = Administration;
    DefaultRenderingLayout = "Tax Invoice - 3PL";
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                myInt: Integer;

            begin
                NovEntryNo := 1;
                NovemILE.reset;
                NovemILE.ChangeCompany('Novem-NHC');
                NovemILE.SetLoadFields("Remaining Quantity", "Item No.", "Lot No.");
                NovemILE.SetFilter("Remaining Quantity", '<>0');
                if NovemILE.FindSet() then
                    repeat
                        NovemTempTable.reset;
                        NovemTempTable.SetRange(Code1, NovemILE."Item No.");
                        NovemTempTable.SetRange(Code2, NovemILE."Lot No.");
                        if not NovemTempTable.FindFirst() then begin
                            NovemTempTable2.init;
                            NovemTempTable2."Entry No." := NovEntryNo;
                            NovemTempTable2.Code1 := NovemILE."Item No.";
                            NovemTempTable2.Code2 := NovemILE."Lot No.";
                            NovemTempTable2.Insert(false);
                            NovemTempTable.Copy(NovemTempTable2);
                            NovemTempTable.Insert(false);
                            NovEntryNo += 1;
                        end;

                    until NovemILE.next = 0;
                NovEntryNo := 1;
                if NovemTempTable2.FindSet() then
                    repeat
                        I9tempTable.Init();
                        I9tempTable."Entry No." := NovEntryNo;
                        I9tempTable.Code1 := NovemTempTable2.Code1;
                        I9tempTable.Code2 := NovemTempTable2.Code2;
                        NovemILE.reset;
                        NovemILE.ChangeCompany('Novem-NHC');
                        NovemILE.SetLoadFields("Remaining Quantity", "Item No.", "Lot No.");
                        NovemILE.SetFilter("Remaining Quantity", '<>0');
                        NovemILE.SetRange("Item No.", NovemTempTable2.code1);
                        NovemILE.SetRange("Lot No.", NovemTempTable2.Code2);
                        NovemILE.CalcSums("Remaining Quantity");
                        I9tempTable.Decimal1 := NovemILE."Remaining Quantity";
                        I9tempTable.Insert();
                        NovEntryNo += 1;
                    until NovemTempTable2.next = 0;

                if I9tempTable.FindSet() then
                    repeat
                        PMPILE.reset;
                        PMPILE.ChangeCompany('PMP');
                        PMPILE.SetLoadFields("Item No.", "Lot No.", "Remaining Quantity");
                        PMPILE.SetRange("Location Code", 'PMP-WH');
                        PMPILE.SetRange("Item No.", I9tempTable.Code1);
                        PMPILE.SetRange("Lot No.", I9tempTable.Code2);
                        PMPILE.SetFilter("Remaining Quantity", '<>0');
                        PMPILE.CalcSums("Remaining Quantity");
                        I9tempTable.Decimal2 := PMPILE."Remaining Quantity";
                        I9tempTable.Modify(false);
                    until I9tempTable.next = 0;



            end;
        }

        dataitem(loopItem; Integer)
        {
            DataItemTableView = sorting(Number);

            column(ItemNo; I9tempTable.Code1)
            {

            }
            column(LotNo; I9tempTable.Code2)
            { }
            column(NovemQty; I9tempTable.Decimal1)
            { }
            column(PMPQty; I9tempTable.Decimal2)
            { }
            column(Difference; I9tempTable.Decimal1 - I9tempTable.Decimal2)
            { }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SetRange(Number, 1, I9tempTable.Count);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Number = 1 then
                    I9tempTable.FindFirst()
                else
                    I9tempTable.next;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    rendering
    {
        layout("Tax Invoice - 3PL")
        {
            Type = RDLC;
            LayoutFile = './ReportLayout/Rpt80140-InventoryMatching3PL.rdl';
        }
    }

    var
        I9tempTable: Record I9G_TempTable temporary;
        I9tempTable2: Record I9G_TempTable temporary;
        NovemTempTable: Record I9G_TempTable temporary;
        NovemTempTable2: Record I9G_TempTable temporary;
        NovemILE: Record "Item Ledger Entry";
        PMPILE: Record "Item Ledger Entry";
        NovEntryNo: Integer;
}
