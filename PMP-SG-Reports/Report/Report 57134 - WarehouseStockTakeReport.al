report 57134 "WarehouseStockTakePivot"
{
    RDLCLayout = './ReportLayouts/ReportLayout 57134 - WarehouseStockTakePivot.rdl';
    Caption = 'Warehouse Stock Take Pivot';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Journal Line"; "Warehouse Journal Line")
        {
            DataItemTableView =
                sorting("Item No.")
                where("Journal Template Name" = const('PHYSICAL I'));

            column(Item_No_; "Item No.") { }
            column(QtyCalculated; "Qty. (Calculated)") { }
            column(QtyPhysInventory; "Qty. (Phys. Inventory)") { }
            column(Quantity; Quantity) { }
        }
    }

    requestpage { }
}