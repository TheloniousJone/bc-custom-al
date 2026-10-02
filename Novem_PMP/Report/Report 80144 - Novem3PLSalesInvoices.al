report 80144 "I9G_Novem3PLSalesInvoiceS"
{
    DefaultRenderingLayout = "Novem 3PL Sales Invoices Report";
    Caption = 'Novem 3PL Sales Invoices Report';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(LineLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(DocumentNo; TempSalesInvoiceHeaderRec."No.") { }
            column(ExternalDocumentNo; TempSalesInvoiceHeaderRec."External Document No.") { }
            column(PostingDate; TempSalesInvoiceHeaderRec."Posting Date") { }
            column(SignedOrder; TempSalesInvoiceHeaderRec.I9G_SignedOrder) { }
            column(DeliveryOrder; TempSalesInvoiceHeaderRec.I9G_DeliveryOrder) { }
            column(BlanketSalesOrderNo; TempSalesInvoiceHeaderRec.I9G_BlanketSalesOrderNo) { }
            column(OrderNo; TempSalesInvoiceHeaderRec."Order No.") { }
            column(CustomerNo; TempSalesInvoiceHeaderRec."Sell-to Customer No.") { }
            column(CustomerName; TempSalesInvoiceHeaderRec."Sell-to Customer Name") { }
            column(DepartmentCode; TempSalesInvoiceHeaderRec."Shortcut Dimension 1 Code") { }
            column(ShipmentDate; TempSalesInvoiceHeaderRec."Shipment Date") { }
            column(ShipToCode; TempSalesInvoiceHeaderRec."Ship-to Code") { }
            column(ShipToName; TempSalesInvoiceHeaderRec."Ship-to Name") { }
            column(ShipToAddress; TempSalesInvoiceHeaderRec."Ship-to Address") { }
            column(ShipToAddress2; TempSalesInvoiceHeaderRec."Ship-to Address 2") { }
            column(Address3; TempSalesInvoiceHeaderRec.I9G_ShipToAddress3) { }
            column(Remarks; TempSalesInvoiceHeaderRec.I9G_Remarks) { }
            column(CurrencyCode; TempSalesInvoiceHeaderRec."Currency Code") { }
            column(DueDate; TempSalesInvoiceHeaderRec."Due Date") { }
            column(Amount; TempSalesInvoiceHeaderRec.Amount) { }
            column(AmountIncludingGST; TempSalesInvoiceHeaderRec."Amount Including VAT") { }
            column(RemainingAmount; TempSalesInvoiceHeaderRec."Remaining Amount") { }
            column(ThreePLInvoiceNo; TempSalesInvoiceHeaderRec.I9G_InvoiceNo) { }
            column(CustomerCode; TempSalesInvoiceHeaderRec."Bill-to Customer No.") { }
            column(CustomerName1; TempSalesInvoiceHeaderRec."Bill-to Name") { }
            column(NovemShipToAddress; TempSalesInvoiceHeaderRec.I9G_NovemShipToAddress) { }
            column(NovemShipToAddress2; TempSalesInvoiceHeaderRec.I9G_NovemShipToAddress2) { }
            column(NovemShipToAddress3; TempSalesInvoiceHeaderRec.I9G_NovemShipToAddress3) { }
            column(LocationCode; TempSalesInvoiceHeaderRec."Location Code") { }
            column(Closed; TempSalesInvoiceHeaderRec.Closed) { }
            column(Cancelled; TempSalesInvoiceHeaderRec.Cancelled) { }
            column(Corrective; TempSalesInvoiceHeaderRec.Corrective) { }

            trigger OnPreDataItem()
            begin
                LoadDataFromNovemNHC();
                TempSalesInvoiceHeaderRec.Reset();
                SetRange(Number, 1, TempSalesInvoiceHeaderRec.Count);
            end;

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then begin
                    TempSalesInvoiceHeaderRec.FindFirst();
                    TempSalesInvoiceHeaderRec.CalcFields(Amount, "Amount Including VAT", "Remaining Amount");
                end
                else begin
                    TempSalesInvoiceHeaderRec.Next();
                    TempSalesInvoiceHeaderRec.CalcFields(Amount, "Amount Including VAT", "Remaining Amount");
                end;
            end;

            trigger OnPostDataItem()
            begin
                TempSalesInvoiceHeaderRec.DeleteAll();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        trigger OnValidate()
                        var
                        begin
                            if EndDate <> 0D then
                                if StartDate > EndDate then
                                    Error('Start Date cannot be later than End Date');
                        end;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                        begin
                            if StartDate <> 0D then
                                if EndDate < StartDate then
                                    Error('End Date cannot be earlier than Start Date');
                        end;
                    }
                }
            }
        }
    }
    rendering
    {
        layout("Novem 3PL Sales Invoices Report")
        {
            Type = Excel;
            LayoutFile = './ReportLayout/Rpt80144-Novem3PLSalesInvoices.xlsx';
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        TempSalesInvoiceHeaderRec: Record "Sales Invoice Header" temporary;
        FilterCompanyName: Text;

    procedure LoadDataFromNovemNHC()
    var
        FromCompanySalesInvoiceHeaderRec: Record "Sales Invoice Header";
        FromCompanySalesInvoiceLineRec: Record "Sales Invoice Line";
        RecordCount: Integer;
    begin
        Clear(FilterCompanyName);
        FilterCompanyName := 'Novem-NHC';

        TempSalesInvoiceHeaderRec.Reset();
        TempSalesInvoiceHeaderRec.DeleteAll();

        FromCompanySalesInvoiceHeaderRec.Reset();
        if FromCompanySalesInvoiceHeaderRec.ChangeCompany(FilterCompanyName) then begin
            // Only apply date filter if dates are provided
            if (StartDate <> 0D) and (EndDate <> 0D) then
                FromCompanySalesInvoiceHeaderRec.SetRange("Posting Date", StartDate, EndDate)
            else if StartDate <> 0D then
                FromCompanySalesInvoiceHeaderRec.SetFilter("Posting Date", '>=%1', StartDate)
            else if EndDate <> 0D then
                FromCompanySalesInvoiceHeaderRec.SetFilter("Posting Date", '<=%1', EndDate);

            // Try with I9G_SOCreated filter first
            FromCompanySalesInvoiceHeaderRec.SetRange(I9G_SOCreated, true);
            if not FromCompanySalesInvoiceHeaderRec.FindSet() then begin
                // If no records found, try without I9G_SOCreated filter
                FromCompanySalesInvoiceHeaderRec.SetRange(I9G_SOCreated);
                if not FromCompanySalesInvoiceHeaderRec.FindSet() then
                    exit;
            end;

            RecordCount := 0;
            repeat
                TempSalesInvoiceHeaderRec.Init();
                FromCompanySalesInvoiceHeaderRec.CalcFields(Amount, "Amount Including VAT", "Remaining Amount");
                TempSalesInvoiceHeaderRec.TransferFields(FromCompanySalesInvoiceHeaderRec);
                TempSalesInvoiceHeaderRec.Insert();
                RecordCount += 1;
            until FromCompanySalesInvoiceHeaderRec.Next() = 0;

            if RecordCount = 0 then
                Message('No sales invoice found in company %1 with the specified filters.\Date Range: %2 to %3', FilterCompanyName, StartDate, EndDate);
        end else
            Error('Unable to connect to company %1. Please verify the company name exists.', FilterCompanyName);
    end;
}