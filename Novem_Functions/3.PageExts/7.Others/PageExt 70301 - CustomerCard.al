pageextension 70301 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field(LicenseStatus; LicenseStatus)
            {
                ApplicationArea = All;
                Caption = 'License Status';
                Visible = CustomizedVisible;
                StyleExpr = StatusStyleExpression;
                Editable = false;
            }
            field(I9G_CustomerRemarks; Rec.I9G_CustomerRemarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Remarks field.';
            }
            field(I9G_CustomerCreatedAt; Rec.I9G_CustomerCreatedAt)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer Created At field.';
            }
            field(SystemModifiedByUserName; SystemModifiedByUserName)
            {
                ApplicationArea = All;
                Caption = 'Customer Modified By';
                Visible = CustomizedVisible;
                Editable = false;
            }
        }
        addafter("Address 2")
        {
            field(I9G_Adddress3; Rec.I9G_Adddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Address 3 field.';
            }
        }
        addlast("Address & Contact")
        {
            field(I9G_ContactDetail; Rec.I9G_ContactDetail)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_FinanceDetail; Rec.I9G_FinanceDetail)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
        addafter("Bill Country Code")
        {
            field(I9G_MailingClinicName; Rec.I9G_MailingClinicName)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_MailingAddress; Rec.I9G_MailingAddress)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_MailingAddress2; Rec.I9G_MailingAddress2)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_MailingAddress3; Rec.I9G_MailingAddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_MailingAttnTo; Rec.I9G_MailingAttnTo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_UseForSOA; Rec.I9G_UseForSOA)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }
    actions
    {
        addbefore("Report Statement")
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
        addbefore("Report Statement_Promoted")
        {
            actionref(StatementOfAccount_Promoted; StatementOfAccount) { }
        }
    }
    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        StatusStyleExpression := GetStyleExprForLicenseStatus();

        Clear(SystemModifiedByUserName);
        if User.Get(Rec.SystemModifiedBy) then
            SystemModifiedByUserName := User."User Name";
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
        SystemModifiedByUserName: Code[50];
        LicenseStatus: Enum I9G_LicenseStatus;
}