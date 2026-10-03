report 70051 "InventoryTurnover"
{
    DefaultRenderingLayout = "Novem - Inventory Turnover";
    Caption = 'Inventory Turnover';
    ApplicationArea = All;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.");

            trigger OnAfterGetRecord()
            var
            begin
                InsertItemLedgerIntoTemp(ItemLedgerEntry);
            end;

            trigger OnPreDataItem()
            var
            begin
                if (FilterStartDate <> 0D) and (FilterEndDate <> 0D) then
                    ItemLedgerEntry.SetFilter("Posting Date", '..%1', FilterEndDate);
                if FilterItemNo <> '' then
                    ItemLedgerEntry.SetFilter("Item No.", FilterItemNo);
                if FilterLocationCode <> '' then
                    ItemLedgerEntry.SetFilter("Location Code", FilterLocationCode);
            end;

        }
        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);

            column(ReportCaption; ReportCaption) { }
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(ItemNo; I9G_TempTableRec.Code1) { }
            column(ItemDescr; I9G_TempTableRec.Text1) { }
            column(ItemGrpCode; I9G_TempTableRec.code2) { }
            column(UOM; I9G_TempTableRec.Code3) { }
            column(LocationCode; I9G_TempTableRec.Code4) { }
            column(OpeningInventory; I9G_TempTableRec.Decimal1) { }
            column(ClosingInventory; I9G_TempTableRec.Decimal2) { }
            column(IssuedQty; I9G_TempTableRec.Decimal3) { }
            column(ReceivedQty; I9G_TempTableRec.Decimal4) { }
            column(FilterItemNo; FilterItemNo) { }
            column(FilterLocationCode; FilterLocationCode) { }
            column(FilterStartDate; FilterStartDate) { }
            column(FilterEndDate; FilterEndDate) { }

            trigger OnPreDataItem()
            begin
                I9G_TempTableRec.Reset();
                SetRange(Number, 1, I9G_TempTableRec.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    I9G_TempTableRec.FindFirst()
                else
                    I9G_TempTableRec.Next();
            end;

            trigger OnPostDataItem()
            begin
                I9G_TempTableRec.DeleteAll();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                field(FilterItemNo; FilterItemNo)
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                    TableRelation = Item;
                }
                field(FilterLocationCode; FilterLocationCode)
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                    TableRelation = Location;
                }
                field(FilterStartDate; FilterStartDate)
                {
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field(FilterEndDate; FilterEndDate)
                {
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
            }
        }
    }

    rendering
    {
        layout("Novem - Inventory Turnover")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70051-InventoryTurnover.rdl';
        }
    }

    trigger OnInitReport()
    var
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    local procedure InsertItemLedgerIntoTemp(var par_ItemLedgerEntry: Record "Item Ledger Entry")
    var
        GetItemRec: Record Item;
    begin
        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;
        GetItemRec.Reset();
        GetItemRec := GetItemRecord(par_ItemLedgerEntry."Item No.");

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code1, par_ItemLedgerEntry."Item No.");
        I9G_TempTableRec.SetRange(Code2, GetItemRec.I9G_ItemGroupCode);
        I9G_TempTableRec.SetRange(Code3, par_ItemLedgerEntry."Unit of Measure Code");
        I9G_TempTableRec.SetRange(Code4, par_ItemLedgerEntry."Location Code");
        if not I9G_TempTableRec.FindFirst() then begin
            I9G_TempTableRec.Reset();
            I9G_TempTableRec.Init();
            I9G_TempTableRec."Entry No." := EntryNo;
            I9G_TempTableRec.Code1 := par_ItemLedgerEntry."Item No.";
            I9G_TempTableRec.Text1 := GetItemRec.Description;
            I9G_TempTableRec.Code2 := GetItemRec.I9G_ItemGroupCode;
            I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Unit of Measure Code";
            I9G_TempTableRec.Code4 := par_ItemLedgerEntry."Location Code";

            if par_ItemLedgerEntry."Posting Date" <= (FilterStartDate - 1) then begin
                I9G_TempTableRec.Decimal1 := par_ItemLedgerEntry.Quantity;
            end;

            if par_ItemLedgerEntry."Posting Date" <= FilterEndDate then begin
                I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity;
            end;

            if (par_ItemLedgerEntry."Posting Date" >= FilterStartDate) and (par_ItemLedgerEntry."Posting Date" <= FilterEndDate) then begin
                if par_ItemLedgerEntry.Quantity < 0 then
                    I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry.Quantity
                else if par_ItemLedgerEntry.Quantity > 0 then
                    I9G_TempTableRec.Decimal4 := par_ItemLedgerEntry.Quantity
                else begin
                    I9G_TempTableRec.Decimal3 := 0;
                    I9G_TempTableRec.Decimal4 := 0;
                end;
            end;

            I9G_TempTableRec.Insert();

        end else begin
            if par_ItemLedgerEntry."Posting Date" <= (FilterStartDate - 1) then begin
                I9G_TempTableRec.Decimal1 += par_ItemLedgerEntry.Quantity;
            end;

            if par_ItemLedgerEntry."Posting Date" <= FilterEndDate then begin
                I9G_TempTableRec.Decimal2 += par_ItemLedgerEntry.Quantity;
            end;

            if (par_ItemLedgerEntry."Posting Date" >= FilterStartDate) and (par_ItemLedgerEntry."Posting Date" <= FilterEndDate) then begin
                if par_ItemLedgerEntry.Quantity < 0 then
                    I9G_TempTableRec.Decimal3 += par_ItemLedgerEntry.Quantity
                else if par_ItemLedgerEntry.Quantity > 0 then
                    I9G_TempTableRec.Decimal4 += par_ItemLedgerEntry.Quantity
                else begin
                    I9G_TempTableRec.Decimal3 += 0;
                    I9G_TempTableRec.Decimal4 += 0;
                end;
            end;

            I9G_TempTableRec.Modify();

        end;
    end;

    local procedure GetItemRecord(par_ItemNo: Code[20]): Record Item
    var
        ItemRec: Record Item;
    begin
        ItemRec.Reset();
        ItemRec.SetRange("No.", par_ItemNo);
        if ItemRec.FindFirst() then begin
            exit(ItemRec);
        end;
    end;


    var
        CompanyInformationRec: Record "Company Information";
        I9G_TempTableRec: Record I9G_TempTable temporary;
        EntryNo: Integer;
        ReportCaption: Label 'Inventory Turnover';
        FilterItemNo: Code[20];
        FilterLocationCode: Code[10];
        FilterStartDate: Date;
        FilterEndDate: Date;
}