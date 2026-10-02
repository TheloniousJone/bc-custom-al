report 70053 "Batch Expiry And Bal. Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Batch Expiry & Balance Report';
    DefaultRenderingLayout = "Novem - Batch Expiry And Bal. Report";

    dataset
    {
        dataitem(ReservationEntry; "Reservation Entry")
        {
            trigger OnPreDataItem()
            begin
                ReservationEntry.SetCurrentKey("Source Type", "Source Subtype");
            end;

            trigger OnAfterGetRecord()
            begin
                if (ReservationEntry."Source Type" = 37) and (ReservationEntry."Source Subtype" = 1) OR
                    (ReservationEntry."Source Type" = 37) and (ReservationEntry."Source Subtype" = 2) then
                    InsertReservEntryIntoTemp(ReservationEntry);

                if (ReservationEntry."Source Type" = 39) and (ReservationEntry."Source Subtype" = 3) then
                    InsertReservEntryIntoTemp(ReservationEntry);

                if (ReservationEntry."Source Type" = 5741) and (ReservationEntry."Source Subtype" = 1) and
                    (ReservationEntry.PostedTO = true) then
                    InsertReservEntryIntoTemp(ReservationEntry);

                if (ReservationEntry."Source Type" = 901) and (ReservationEntry."Source Subtype" = 1) then
                    InsertReservEntryIntoTemp(ReservationEntry);
            end;
        }
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            trigger OnPreDataItem()
            begin
                ItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);
            end;

            trigger OnAfterGetRecord()
            begin
                InsertItemLedgerEntryIntoTemp(ItemLedgerEntry);
            end;
        }

        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyLogo; CompanyInformation.Picture) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(LocationCode; I9G_TempTableRec.Code2) { }
            column(ItemNo; I9G_TempTableRec.Code1) { }
            column(ItemDescription; I9G_TempTableRec.Text1) { }
            column(LotNo; I9G_TempTableRec.Code3) { }
            column(AllocatedQty; I9G_TempTableRec.Decimal2) { }
            column(ExistingQty; I9G_TempTableRec.Decimal1) { }
            column(ExpirationDate; I9G_TempTableRec.Date1) { }

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

    rendering
    {
        layout("Novem - Batch Expiry And Bal. Report")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70053-BatchExpiryAndBalReport.rdl';
        }
    }

    trigger OnPreReport()
    var
        "Reservation Entry": Record "Reservation Entry";
    begin

    end;

    trigger OnInitReport()
    var
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        I9G_TempTableRec: Record I9G_TempTable temporary;
        Item: Record Item;
        EntryNo: Integer;

    local procedure InsertReservEntryIntoTemp(var ReservationEntry: Record "Reservation Entry")
    begin
        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code1, ReservationEntry."Item No.");
        I9G_TempTableRec.SetRange(Code2, ReservationEntry."Location Code");
        I9G_TempTableRec.SetRange(Code3, ReservationEntry."Lot No.");
        I9G_TempTableRec.SetRange(Date1, ReservationEntry."Expiration Date");
        if not I9G_TempTableRec.FindFirst() then begin
            I9G_TempTableRec.Reset();
            I9G_TempTableRec.init();
            I9G_TempTableRec."Entry No." := EntryNo;
            I9G_TempTableRec.Code1 := ReservationEntry."Item No.";
            I9G_TempTableRec.Text1 := ReservationEntry.Description;
            I9G_TempTableRec.Code2 := ReservationEntry."Location Code";
            I9G_TempTableRec.code3 := ReservationEntry."Lot No.";
            I9G_TempTableRec.Date1 := ReservationEntry."Expiration Date";
            I9G_TempTableRec.Decimal1 := 0;                                         // Ex Qty
            I9G_TempTableRec.Decimal2 := ReservationEntry."Quantity (Base)" * -1;   // Alo Qty
            I9G_TempTableRec.Insert();
        end
        else begin
            I9G_TempTableRec.Decimal2 += ReservationEntry."Quantity (Base)" * -1;
        end;
    end;

    local procedure InsertItemLedgerEntryIntoTemp(var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code1, ItemLedgerEntry."Item No.");
        I9G_TempTableRec.SetRange(Code2, ItemLedgerEntry."Location Code");
        I9G_TempTableRec.SetRange(Code3, ItemLedgerEntry."Lot No.");
        I9G_TempTableRec.SetRange(Date1, ItemLedgerEntry."Expiration Date");
        if not I9G_TempTableRec.FindFirst() then begin
            I9G_TempTableRec.Reset();
            I9G_TempTableRec.init();
            I9G_TempTableRec."Entry No." := EntryNo;
            I9G_TempTableRec.Code1 := ItemLedgerEntry."Item No.";
            Item.Reset();
            if Item.Get(ItemLedgerEntry."Item No.") then
                I9G_TempTableRec.Text1 := ItemLedgerEntry.Description;
            I9G_TempTableRec.Code2 := ItemLedgerEntry."Location Code";
            I9G_TempTableRec.code3 := ItemLedgerEntry."Lot No.";
            I9G_TempTableRec.Date1 := ItemLedgerEntry."Expiration Date";
            I9G_TempTableRec.Decimal1 := ItemLedgerEntry.Quantity;          // Ex Qty
            I9G_TempTableRec.Decimal2 := 0;                                 // Alo Qty
            I9G_TempTableRec.Insert();
        end
        else begin
            I9G_TempTableRec.Decimal1 += ItemLedgerEntry.Quantity;
        end;
    end;
}