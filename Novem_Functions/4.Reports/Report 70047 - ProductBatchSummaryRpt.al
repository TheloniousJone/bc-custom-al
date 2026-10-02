report 70047 "Product Batch Summary Rpt"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Novem - Product Batch Summary Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "Novem - Product Batch Summary Report";

    dataset
    {
        // dataitem("Lot No. Information"; "Lot No. Information")
        // {
        //     DataItemTableView = SORTING("Lot No.");
        //     dataitem(ItemLedEntry; "Item Ledger Entry")
        //     {
        //         DataItemTableView = SORTING("Lot No.");
        //         DataItemLinkReference = "Lot No. Information";

        //         trigger OnAfterGetRecord()
        //         var
        //         begin
        //             InsertItemLedgerBFStartDateIntoTemp(ItemLedEntry);
        //         end;

        //         trigger OnPreDataItem()
        //         begin
        //             ItemLedEntry.SetRange("Lot No.", "Lot No. Information"."Lot No.");
        //             ItemLedEntry.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', StartDate));
        //             ItemLedEntry.SetLoadFields("Item No.", "Posting Date", "Invoiced Quantity", "Lot No.", "Location Code", "Expiration Date", Description);
        //         end;
        //     }
        //     trigger OnPreDataItem()
        //     begin
        //         "Lot No. Information".SetFilter(Inventory, '>%1', 0);
        //         // "Lot No. Information".SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
        //         "Lot No. Information".SetLoadFields("Item No.", "Lot No.");
        //         // ItemLedEntry.SetLoadFields("Item No.", "Posting Date", "Invoiced Quantity", "Lot No.", "Location Code", "Expiration Date", Description);
        //     end;
        // }
        dataitem(ItemLedEntry2; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Posting Date");
            RequestFilterFields = "Item No.", "Location Code", "Lot No.";

            trigger OnAfterGetRecord()
            var
            begin
                InsertItemLedgerIntoTemp(ItemLedEntry2);
            end;

            trigger OnPreDataItem()
            begin
                // ItemLedEntry2.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                ItemLedEntry2.SetLoadFields("Item No.", "Posting Date", Quantity, "Invoiced Quantity", "Lot No.", "Location Code", "Expiration Date", Description);
                DateFilter := Format(StartDate) + '..' + Format(EndDate);
            end;
        }

        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(CompanyName; CompanyInformationRec.Name) { }
            column(Today; CurrentDateTime()) { }
            column(STRSUBSTNO__ItemLedEntryFilter_; StrSubstNo('%1', ItemLedEntryFilter)) { }
            column(ItemNoFilter; ItemNoFilter) { }
            column(DateFilter; DateFilter) { }
            column(LocationFilter; LocationFilter) { }
            column(LotNoFilter; LotNoFilter) { }
            column(BFDate; Format(CalcDate('<-1D>', StartDate), 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(StartDate; StartDate) { }
            Column(EndDate; EndDate) { }
            column(Item_No_; I9G_TempTableRec.Code1) { }
            column(Lot_No_; I9G_TempTableRec.Code2) { }
            column(Location_Code; I9G_TempTableRec.Code3) { }
            column(Description; I9G_TempTableRec.Text1) { }
            column(Expiration_Date; Format(I9G_TempTableRec.Date1, 0, '<Day,2>-<Month Text, 3>-<Year>')) { }
            column(BF; I9G_TempTableRec.Decimal1) { }
            column(In; I9G_TempTableRec.Decimal2) { }
            column(Out; I9G_TempTableRec.Decimal3) { }

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
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }
    }

    rendering
    {
        layout("Novem - Product Batch Summary Report")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70047-PrdtBatchSumRpt.rdl';
        }
    }

    trigger OnPreReport()
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Error('Please fill in the start date and end date.');

        if StartDate > EndDate then
            Error('Start date cannot be later than the end date..');

        // ItemLedEntryFilter := ItemLedEntry2.GetFilters();

        ItemNoFilter := ItemLedEntry2.GetFilter("Item No.");
        LocationFilter := ItemLedEntry2.GetFilter("Location Code");
        LotNoFilter := ItemLedEntry2.GetFilter("Lot No.");

        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);

    end;


    var
        I9G_TempTableRec: Record I9G_TempTable temporary;
        StartDate: Date;
        EndDate: Date;
        ItemLedEntryFilter: Text;
        ItemNoFilter: Text;
        DateFilter: Text;
        LocationFilter: Text;
        LotNoFilter: Text;
        EntryNo: Integer;
        CompanyInformationRec: Record "Company Information";
        ItemRec: Record Item;

    local procedure InsertItemLedgerIntoTemp(par_ItemLedgerEntry: Record "Item Ledger Entry")
    var
        ItemLedEntryBF: Record "Item Ledger Entry";
    begin
        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code1, par_ItemLedgerEntry."Item No.");
        I9G_TempTableRec.SetRange(Code2, par_ItemLedgerEntry."Lot No.");
        I9G_TempTableRec.SetRange(Code3, par_ItemLedgerEntry."Location Code");
        I9G_TempTableRec.SetRange(Date1, par_ItemLedgerEntry."Expiration Date");

        if not I9G_TempTableRec.FindFirst() then begin
            I9G_TempTableRec.Reset();
            I9G_TempTableRec.Init();
            I9G_TempTableRec."Entry No." := EntryNo;
            I9G_TempTableRec.Code1 := par_ItemLedgerEntry."Item No.";
            I9G_TempTableRec.Code2 := par_ItemLedgerEntry."Lot No.";
            I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Location Code";
            I9G_TempTableRec.Date1 := par_ItemLedgerEntry."Expiration Date";

            ItemRec.Reset();
            if ItemRec.Get(par_ItemLedgerEntry."Item No.") then begin
                I9G_TempTableRec.Text1 := ItemRec.Description;
            end;

            // get BF
            InsertItemLedgerBFStartDateIntoTemp(par_ItemLedgerEntry, I9G_TempTableRec);

            if (par_ItemLedgerEntry."Posting Date" >= StartDate) and (par_ItemLedgerEntry."Posting Date" <= EndDate) then begin
                if par_ItemLedgerEntry.Quantity > 0 then
                    I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity;

                if par_ItemLedgerEntry.Quantity < 0 then
                    I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry.Quantity;
            end;

            I9G_TempTableRec.Insert();
        end else begin
            if (par_ItemLedgerEntry."Posting Date" >= StartDate) and (par_ItemLedgerEntry."Posting Date" <= EndDate) then begin
                if par_ItemLedgerEntry.Quantity > 0 then
                    I9G_TempTableRec.Decimal2 += par_ItemLedgerEntry.Quantity;

                if par_ItemLedgerEntry.Quantity < 0 then
                    I9G_TempTableRec.Decimal3 += par_ItemLedgerEntry.Quantity;
            end;

            I9G_TempTableRec.Modify();
        end;
    end;

    local procedure InsertItemLedgerBFStartDateIntoTemp(var ItemLedEntry: Record "Item Ledger Entry"; var I9G_TempTableRec: Record I9G_TempTable)
    var
        ItemLedEntryBF: Record "Item Ledger Entry";
    begin
        ItemLedEntryBF.Reset();
        ItemLedEntryBF.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', StartDate));
        ItemLedEntryBF.SetRange("Item No.", ItemLedEntry."Item No.");
        ItemLedEntryBF.SetRange("Lot No.", ItemLedEntry."Lot No.");
        ItemLedEntryBF.SetRange("Location Code", ItemLedEntry."Location Code");
        ItemLedEntryBF.SetRange("Expiration Date", ItemLedEntry."Expiration Date");
        if ItemLedEntryBF.FindSet() then begin
            ItemLedEntryBF.CalcSums(Quantity);
            I9G_TempTableRec.Decimal1 := ItemLedEntryBF.Quantity;
        end;
    end;
}

