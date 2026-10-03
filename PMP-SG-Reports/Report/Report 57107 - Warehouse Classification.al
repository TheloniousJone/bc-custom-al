report 57107 "Warehouse Classification"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLinkReference = Item;
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = where("Entry Type" = filter(Sale | Purchase));

                trigger OnPreDataItem()
                var
                    From_Date: Date;
                begin
                    From_Date := CalcDate('-6M', Today);
                    SetFilter("Posting Date", '%1..%2', From_Date, Today);
                end;

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Sales Amount (Actual)", "Purchase Amount (Actual)");
                    InsertIntoTemp("Item Ledger Entry");
                end;
            }
        }

        dataitem(SummaryLoop; Integer)
        {
            trigger OnPreDataItem()
            begin
                Clear(Total_Sales_Amount);
                Clear(Sales_Amount_80);
                Clear(Sales_Amount_95);

                temp_ItemLedgEntry.Reset();
                if temp_ItemLedgEntry.FindSet() then begin
                    repeat
                        Total_Sales_Amount += temp_ItemLedgEntry.Quantity;
                    until temp_ItemLedgEntry.Next() = 0;
                end;

                Sales_Amount_80 := (Total_Sales_Amount * 80) / 100;
                Sales_Amount_95 := (Total_Sales_Amount * 95) / 100;

                temp_ItemLedgEntry.Reset();
                temp_ItemLedgEntry.SetCurrentKey(temp_ItemLedgEntry.Quantity);
                temp_ItemLedgEntry.SetAscending(temp_ItemLedgEntry.Quantity, false);
                SetRange(Number, 1, temp_ItemLedgEntry.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    temp_ItemLedgEntry.FindFirst()
                else
                    temp_ItemLedgEntry.Next();

                Loop_Sales_Amount += temp_ItemLedgEntry.Quantity;

                rec_Item.Reset();
                rec_Item.SetRange("No.", temp_ItemLedgEntry."Item No.");
                if rec_Item.FindFirst() then begin
                    if Loop_Sales_Amount < Sales_Amount_80 then begin
                        rec_Item."Warehouse Classification" := 'A';
                        rec_Item.Modify(false);
                    end else
                        if (Loop_Sales_Amount >= Sales_Amount_80) and (Loop_Sales_Amount < Sales_Amount_95) then begin
                            rec_Item."Warehouse Classification" := 'B';
                            rec_Item.Modify(false);
                        end else
                            if Loop_Sales_Amount >= Sales_Amount_95 then begin
                                rec_Item."Warehouse Classification" := 'C';
                                rec_Item.Modify(false);
                            end
                end
            end;

            trigger OnPostDataItem()
            begin
                temp_ItemLedgEntry.DeleteAll();
            end;
        }
    }

    var
        temp_ItemLedgEntry: Record "Item Ledger Entry" temporary;
        Entry_No: Integer;
        Total_Sales_Amount: Decimal;
        Sales_Amount_80: Decimal;
        Sales_Amount_95: Decimal;
        Loop_Sales_Amount: Decimal;
        rec_Item: Record Item;

    local procedure InsertIntoTemp(par_ILE: Record "Item Ledger Entry")
    begin
        temp_ItemLedgEntry.Reset();
        temp_ItemLedgEntry.SetRange("Item No.", par_ILE."Item No.");
        if not temp_ItemLedgEntry.FindFirst() then begin
            if Entry_No = 0 then
                Entry_No := 1
            else
                Entry_No += 1;

            temp_ItemLedgEntry.Reset();
            temp_ItemLedgEntry.Init();
            temp_ItemLedgEntry."Entry No." := Entry_No;
            temp_ItemLedgEntry."Item No." := par_ILE."Item No.";
            temp_ItemLedgEntry.Quantity := par_ILE."Sales Amount (Actual)" + par_ILE."Purchase Amount (Actual)"; // Sales Amount
            temp_ItemLedgEntry.Insert(false);
        end else begin
            temp_ItemLedgEntry.Quantity += par_ILE."Sales Amount (Actual)" + par_ILE."Purchase Amount (Actual)"; // Sales Amount
            temp_ItemLedgEntry.Modify(false);
        end;
    end;
}