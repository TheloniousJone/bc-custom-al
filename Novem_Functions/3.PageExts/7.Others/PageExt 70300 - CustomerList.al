pageextension 70300 CustomerListExt extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field(LicenseStatus; LicenseStatus)
            {
                ApplicationArea = All;
                Caption = 'License Status';
                Visible = CustomizedVisible;
                StyleExpr = StatusStyleExpression;
                Editable = false;
            }
        }
    }
    actions
    {
        addbefore(Statement)
        {
            action(StatementOfAccount)
            {
                Caption = 'Statement Of Account';
                Image = CalculateSalesTax;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    I9G_StatementofAccountReport: Report I9G_StatementofAccount;
                    CustomerRec: Record Customer;
                    SelectionFilterManagementCodeUnit: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CustomerRec.Reset();
                    CurrPage.SetSelectionFilter(CustomerRec);
                    RecRef.GetTable(CustomerRec);
                    I9G_StatementofAccountReport.GetReportFilterText(SelectionFilterManagementCodeUnit.GetSelectionFilterForCustomer(CustomerRec));
                    I9G_StatementofAccountReport.RunModal();
                end;
            }
        }
        addlast(reporting)
        {
            action(CusotmerProductSalesReport)
            {
                Caption = 'Customer Product Sales Report';
                Image = CashReceiptJournal;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    I9G_SalesHistoryReport: Report I9G_SalesHistory;
                    CustomerRec: Record Customer;
                    SelectionFilterManagementCodeUnit: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CustomerRec.Reset();
                    CurrPage.SetSelectionFilter(CustomerRec);
                    RecRef.GetTable(CustomerRec);
                    I9G_SalesHistoryReport.GetReportOptionAndFilterText(ReportFilterOptions::Customer, SelectionFilterManagementCodeUnit.GetSelectionFilterForCustomer(CustomerRec));
                    I9G_SalesHistoryReport.RunModal();
                end;
            }
        }
        addlast(Category_Report)
        {
            actionref(CusotmerProductSalesReport_Promoted; CusotmerProductSalesReport) { }
        }
        addbefore(Statement_Promoted)
        {
            actionref(StatementOfAccount_Promoted; StatementOfAccount) { }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StatusStyleExpression := GetStyleExprForLicenseStatus();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        StatusStyleExpression := GetStyleExprForLicenseStatus();
    end;

    procedure GetStyleExprForLicenseStatus(): Text[50];
    var
        ShipToAddress: Record "Ship-to Address";
    begin
        if I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck() = true then begin
            Clear(LicenseStatus);

            ShipToAddress.Reset();
            ShipToAddress.SetCurrentKey("Customer No.", I9G_LicenseStatus);
            ShipToAddress.SetRange("Customer No.", Rec."No.");
            if ShipToAddress.FindLast() then begin
                LicenseStatus := ShipToAddress.I9G_LicenseStatus;

                if ShipToAddress.I9G_LicenseStatus = ShipToAddress.I9G_LicenseStatus::Expired then begin
                    exit('Unfavorable');
                end else if ShipToAddress.I9G_LicenseStatus = ShipToAddress.I9G_LicenseStatus::Soon then begin
                    exit('Ambiguous');
                end else begin
                    exit('Favorable');
                end;
            end else begin
                exit('Favorable');
            end;
        end;
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
        StatusStyleExpression: Text[50];
        ReportFilterOptions: Option "Product","Customer";
        LicenseStatus: Enum I9G_LicenseStatus;
}