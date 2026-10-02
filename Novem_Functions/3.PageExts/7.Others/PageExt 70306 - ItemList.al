pageextension 70306 ItemListExt extends "Item List"
{
    actions
    {
        addlast(reporting)
        {
            action(ProductCustomerSalesReport)
            {
                Caption = 'Product Customer Sales Report';
                Image = InventoryJournal;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    I9G_SalesHistoryReport: Report I9G_SalesHistory;
                    ItemRec: Record Item;
                    SelectionFilterManagementCodeUnit: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    ItemRec.Reset();
                    CurrPage.SetSelectionFilter(ItemRec);
                    RecRef.GetTable(ItemRec);
                    I9G_SalesHistoryReport.GetReportOptionAndFilterText(ReportFilterOptions::Product, SelectionFilterManagementCodeUnit.GetSelectionFilterForItem(ItemRec));
                    I9G_SalesHistoryReport.RunModal();
                end;
            }
            action(InventoryAuditReportSummary)
            {
                Caption = 'Inventory Audit Report Summary';
                Image = Report;
                ApplicationArea = All;
                Visible = CustomizedVisible;

                trigger OnAction()
                var
                    InvtAuditSummaryRpt: Report InventoryAuditSummary;
                    ItemRec: Record Item;
                begin
                    ItemRec.Reset();
                    CurrPage.SetSelectionFilter(ItemRec);
                    InvtAuditSummaryRpt.SetTableView(ItemRec);
                    InvtAuditSummaryRpt.RunModal();
                end;
            }
        }
        addlast(Category_Report)
        {
            actionref(ProductCustomerSalesReport_Promoted; ProductCustomerSalesReport) { }
            actionref(InventoryAuditReportSummary_Promoted; InventoryAuditReportSummary) { }
        }
    }
    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
        ReportFilterOptions: Option "Product","Customer";
}