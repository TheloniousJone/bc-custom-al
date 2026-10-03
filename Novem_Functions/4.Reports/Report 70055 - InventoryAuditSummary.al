report 70055 "InventoryAuditSummary"
{
    DefaultRenderingLayout = "Novem - Inventory Audit Summary";
    Caption = 'Inventory Audit Summary';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(SNNO; SNNO) { }
            column(No; "No.") { }
            column(Description; Description) { }
            column(Unit_Cost; "Unit Cost") { }

            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLinkReference = Item;
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Item No.", "Location Code", "Posting Date");
                RequestFilterFields = "Posting Date", "Location Code";

                column(Item_No; "Item No.") { }
                column(Location_Code; "Location Code") { }
                column(Posting_Date; Format("Posting Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(SystemCreatedAt; Format(SystemCreatedAt, 0, ' <Day,2>.<Month,2>.<Year>')) { }
                column(Document_No_; "Document No.") { }
                column(Invoiced_Quantity; Quantity) { }
                column(Cost_Amount_Actual_; "Cost Amount (Actual)") { }
                column(Cummulative_Qty; Cummulative_Qty) { }
                column(Cummulative_Value; Cummulative_Value) { }


                trigger OnPreDataItem()
                begin
                    "Item Ledger Entry".CalcFields("Cost Amount (Actual)");
                    Cummulative_Qty := 0;
                    Cummulative_Value := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    Cummulative_Qty += Quantity;
                    Cummulative_Value += "Cost Amount (Actual)";
                end;
            }

            trigger OnPreDataItem()
            var
            begin
            end;

            trigger OnAfterGetRecord()
            begin
                SNNO += 1;
            end;
        }
    }


    rendering
    {
        layout("Novem - Inventory Audit Summary")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70055-InventoryAuditSummary.rdl';
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
        SNNO: Integer;
        Cummulative_Qty: Decimal;
        Cummulative_Value: Decimal;

}