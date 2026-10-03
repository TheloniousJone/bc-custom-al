report 70056 "InventoryAuditDetail"
{
    DefaultRenderingLayout = "Novem - Inventory Audit Detail";
    Caption = 'Inventory Audit Detail';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLinkReference = Item;
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Item No.", "Location Code", "Posting Date");
                RequestFilterFields = "Posting Date", "Document No.", "Location Code";

                trigger OnPreDataItem()
                begin
                    "Item Ledger Entry".CalcFields("Cost Amount (Actual)");
                end;

                trigger OnAfterGetRecord()
                var
                    ValueEntry: Record "Value Entry";
                begin

                    Clear(InvNo);
                    SNNO += 1;

                    if ("Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Shipment") then begin
                        ValueEntry.Reset();
                        ValueEntry.SetCurrentKey("Document No.");
                        ValueEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                        ValueEntry.SetRange(Adjustment, false);
                        ValueEntry.SetRange("Document Type", "Item Ledger Entry"."Document Type"::"Sales Invoice");
                        if ValueEntry.FindFirst() then begin
                            InvNo := ValueEntry."Document No.";
                        end
                        else begin
                            InvNo := "Item Ledger Entry"."Document No.";
                        end;
                    end
                    else if ("Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Purchase Receipt") then begin
                        ValueEntry.Reset();
                        ValueEntry.SetCurrentKey("Document No.");
                        ValueEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                        ValueEntry.SetRange(Adjustment, false);
                        ValueEntry.SetRange("Document Type", "Item Ledger Entry"."Document Type"::"Purchase Invoice");
                        if ValueEntry.FindFirst() then begin
                            InvNo := ValueEntry."Document No.";
                        end
                        else begin
                            InvNo := "Item Ledger Entry"."Document No.";
                        end;
                    end
                    else begin
                        InvNo := "Item Ledger Entry"."Document No.";
                    end;

                    InsertItemLedgerIntoTemp("Item Ledger Entry", Item);
                end;
            }

            trigger OnPreDataItem()
            var
            begin
            end;
        }

        dataitem(SummaryLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(No; I9G_TempTableRec.Code1) { }
            column(Description; I9G_TempTableRec.Text1) { }
            column(Unit_Cost; I9G_TempTableRec.Decimal1) { }
            // column(SNNO; SNNO) { }
            column(Item_No; I9G_TempTableRec.Code2) { }
            column(Location_Code; I9G_TempTableRec.Code3) { }
            column(Posting_Date; I9G_TempTableRec.Text2) { }
            column(SystemCreatedAt; I9G_TempTableRec.Text3) { }
            column(InvNo; I9G_TempTableRec.Code5) { }
            column(Invoiced_Quantity; I9G_TempTableRec.Decimal2) { }
            column(Cost_Amount_Actual_; I9G_TempTableRec.Decimal3) { }
            column(ItemTotalQty; I9G_TempTableRec.Decimal4) { }
            column(ItemTotalValue; I9G_TempTableRec.Decimal5) { }
            column(ItemLocTotalQty; I9G_TempTableRec.Decimal6) { }
            column(ItemLocTotalValue; I9G_TempTableRec.Decimal7) { }
            column(Cummulative_Qty; I9G_TempTableRec.Decimal8) { }
            column(Cummulative_Value; I9G_TempTableRec.Decimal9) { }

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
        layout("Novem - Inventory Audit Detail")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70056-InventoryAuditDetail.rdl';
        }
    }

    trigger OnInitReport()
    var
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    trigger OnPreReport()
    var
    begin
        SNNO := 0;
    end;

    var
        CompanyInformationRec: Record "Company Information";
        I9G_TempTableRec: Record I9G_TempTable temporary;
        SNNO: Integer;
        ItemTotalQty: Decimal;
        ItemTotalValue: Decimal;
        ItemLocTotalQty: Decimal;
        ItemLocTotalValue: Decimal;
        Cummulative_Qty: Decimal;
        Cummulative_Value: Decimal;
        InvNo: Code[20];
        EntryNo: Integer;

    local procedure InsertItemLedgerIntoTemp(var par_ItemLedgerEntry: Record "Item Ledger Entry"; var par_Item: Record Item)
    var
    begin
        Clear(ItemTotalQty);
        Clear(ItemTotalValue);
        Clear(ItemLocTotalQty);
        Clear(ItemLocTotalValue);
        Clear(Cummulative_Qty);
        Clear(Cummulative_Value);
        par_ItemLedgerEntry.CalcFields("Cost Amount (Actual)");

        if EntryNo = 0 then
            EntryNo := 1
        else
            EntryNo += 1;

        I9G_TempTableRec.Reset();
        I9G_TempTableRec.SetRange(Code2, par_ItemLedgerEntry."Item No.");
        if I9G_TempTableRec.FindLast() then begin
            ItemTotalQty := par_ItemLedgerEntry.Quantity + I9G_TempTableRec.Decimal4;
            ItemTotalValue := par_ItemLedgerEntry."Cost Amount (Actual)" + I9G_TempTableRec.Decimal5;

            I9G_TempTableRec.SetRange(Code3, par_ItemLedgerEntry."Location Code");
            if I9G_TempTableRec.FindLast() then begin
                ItemLocTotalQty := par_ItemLedgerEntry.Quantity + I9G_TempTableRec.Decimal6;
                ItemLocTotalValue := par_ItemLedgerEntry."Cost Amount (Actual)" + I9G_TempTableRec.Decimal7;
                Cummulative_Qty := par_ItemLedgerEntry.Quantity + I9G_TempTableRec.Decimal8;
                Cummulative_Value := par_ItemLedgerEntry."Cost Amount (Actual)" + I9G_TempTableRec.Decimal9;

                I9G_TempTableRec.Reset();
                I9G_TempTableRec.Init();
                I9G_TempTableRec."Entry No." := EntryNo;
                I9G_TempTableRec.Code1 := par_Item."No.";
                I9G_TempTableRec.Code2 := par_ItemLedgerEntry."Item No.";
                I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Location Code";
                I9G_TempTableRec.Code4 := par_ItemLedgerEntry."Document No.";
                I9G_TempTableRec.Code5 := InvNo;

                I9G_TempTableRec.Text1 := par_Item.Description;
                I9G_TempTableRec.Text2 := Format(par_ItemLedgerEntry."Posting Date", 0, '<Closing><Day,2>.<Month,2>.<Year>');
                I9G_TempTableRec.Text3 := Format(par_ItemLedgerEntry.SystemCreatedAt, 0, '<Day,2>.<Month,2>.<Year>');

                I9G_TempTableRec.Decimal1 := par_Item."Unit Cost";
                I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity;
                I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry."Cost Amount (Actual)";
                I9G_TempTableRec.Decimal4 := ItemTotalQty;
                I9G_TempTableRec.Decimal5 := ItemTotalValue;
                I9G_TempTableRec.Decimal6 := ItemLocTotalQty;
                I9G_TempTableRec.Decimal7 := ItemLocTotalValue;
                I9G_TempTableRec.Decimal8 := Cummulative_Qty;
                I9G_TempTableRec.Decimal9 := Cummulative_Value;

                I9G_TempTableRec.Insert();
            end else begin
                I9G_TempTableRec.Reset();
                I9G_TempTableRec.Init();
                I9G_TempTableRec."Entry No." := EntryNo;
                I9G_TempTableRec.Code1 := par_Item."No.";
                I9G_TempTableRec.Code2 := par_ItemLedgerEntry."Item No.";
                I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Location Code";
                I9G_TempTableRec.Code4 := par_ItemLedgerEntry."Document No.";
                I9G_TempTableRec.Code5 := InvNo;

                I9G_TempTableRec.Text1 := par_Item.Description;
                I9G_TempTableRec.Text2 := Format(par_ItemLedgerEntry."Posting Date", 0, '<Closing><Day,2>.<Month,2>.<Year>');
                I9G_TempTableRec.Text3 := Format(par_ItemLedgerEntry.SystemCreatedAt, 0, '<Day,2>.<Month,2>.<Year>');

                I9G_TempTableRec.Decimal1 := par_Item."Unit Cost";
                I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity;
                I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry."Cost Amount (Actual)";
                I9G_TempTableRec.Decimal4 := ItemTotalQty;
                I9G_TempTableRec.Decimal5 := ItemTotalValue;
                I9G_TempTableRec.Decimal6 := par_ItemLedgerEntry.Quantity;
                I9G_TempTableRec.Decimal7 := par_ItemLedgerEntry."Cost Amount (Actual)";
                I9G_TempTableRec.Decimal8 := par_ItemLedgerEntry.Quantity;
                I9G_TempTableRec.Decimal9 := par_ItemLedgerEntry."Cost Amount (Actual)";

                I9G_TempTableRec.Insert();
            end;
        end
        else begin
            I9G_TempTableRec.Reset();
            I9G_TempTableRec.Init();
            I9G_TempTableRec."Entry No." := EntryNo;
            I9G_TempTableRec.Code1 := par_Item."No.";
            I9G_TempTableRec.Code2 := par_ItemLedgerEntry."Item No.";
            I9G_TempTableRec.Code3 := par_ItemLedgerEntry."Location Code";
            I9G_TempTableRec.Code4 := par_ItemLedgerEntry."Document No.";
            I9G_TempTableRec.Code5 := InvNo;

            I9G_TempTableRec.Text1 := par_Item.Description;
            I9G_TempTableRec.Text2 := Format(par_ItemLedgerEntry."Posting Date", 0, '<Closing><Day,2>.<Month,2>.<Year>');
            I9G_TempTableRec.Text3 := Format(par_ItemLedgerEntry.SystemCreatedAt, 0, '<Day,2>.<Month,2>.<Year>');

            I9G_TempTableRec.Decimal1 := par_Item."Unit Cost";
            I9G_TempTableRec.Decimal2 := par_ItemLedgerEntry.Quantity;
            I9G_TempTableRec.Decimal3 := par_ItemLedgerEntry."Cost Amount (Actual)";
            I9G_TempTableRec.Decimal4 := par_ItemLedgerEntry.Quantity;
            I9G_TempTableRec.Decimal5 := par_ItemLedgerEntry."Cost Amount (Actual)";
            I9G_TempTableRec.Decimal6 := par_ItemLedgerEntry.Quantity;
            I9G_TempTableRec.Decimal7 := par_ItemLedgerEntry."Cost Amount (Actual)";
            I9G_TempTableRec.Decimal8 := par_ItemLedgerEntry.Quantity;
            I9G_TempTableRec.Decimal9 := par_ItemLedgerEntry."Cost Amount (Actual)";

            I9G_TempTableRec.Insert();
        end;

    end;
}