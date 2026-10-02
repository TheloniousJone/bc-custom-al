report 80145 "I9G_Novem3PLSalesInvoiceLines"
{
    DefaultRenderingLayout = "Novem 3PL Sales Lines Report";
    Caption = 'Novem 3PL Sales Lines Report';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(LineLoop; Integer)
        {
            DataItemTableView = sorting(Number);
            column(DocumentNo; TempSalesInvoiceLineRec."Document No.") { }
            column(ExternalDocumentNo; TempSalesInvoiceLineRec."IC Item Reference No.") { }
            column(ItemType; TempSalesInvoiceLineRec.Type) { }
            column(ItemCode; TempSalesInvoiceLineRec."No.") { }
            column(ItemDescription; TempSalesInvoiceLineRec.Description) { }
            column(Quantity; TempSalesInvoiceLineRec.Quantity) { }
            column(UOMCode; TempSalesInvoiceLineRec."Unit of Measure Code") { }
            column(UnitPrice; TempSalesInvoiceLineRec."Unit Price") { }
            column(Location_Code; TempSalesInvoiceLineRec."Location Code") { }
            column(PostingDate; TempSalesInvoiceLineRec."Posting Date") { }
            column(Amount; TempSalesInvoiceLineRec.Amount) { }

            trigger OnPreDataItem()
            begin
                LoadDataFromNovemNHC();
                TempSalesInvoiceLineRec.Reset();
                SetRange(Number, 1, TempSalesInvoiceLineRec.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempSalesInvoiceLineRec.FindFirst()
                else
                    TempSalesInvoiceLineRec.Next();
            end;

            trigger OnPostDataItem()
            begin
                TempSalesInvoiceLineRec.DeleteAll();
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
        layout("Novem 3PL Sales Lines Report")
        {
            Type = Excel;
            LayoutFile = './ReportLayout/Rpt80145-Novem3PLSalesLines.xlsx';
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        TempSalesInvoiceLineRec: Record "Sales Invoice Line" temporary;
        FilterCompanyName: Text;

    procedure LoadDataFromNovemNHC()
    var
        FromCompanySalesInvoiceHeaderRec: Record "Sales Invoice Header";
        FromCompanySalesInvoiceLineRec: Record "Sales Invoice Line";
        RecordCount: Integer;
    begin
        Clear(FilterCompanyName);
        FilterCompanyName := 'Novem-NHC';

        TempSalesInvoiceLineRec.Reset();
        TempSalesInvoiceLineRec.DeleteAll();

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
                FromCompanySalesInvoiceLineRec.Reset();
                if FromCompanySalesInvoiceLineRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesInvoiceLineRec.SetRange("Document No.", FromCompanySalesInvoiceHeaderRec."No.");
                    FromCompanySalesInvoiceLineRec.SetFilter(Quantity, '<>%1', 0);
                    if FromCompanySalesInvoiceLineRec.FindSet() then begin
                        repeat
                            TempSalesInvoiceLineRec.Init();
                            TempSalesInvoiceLineRec.TransferFields(FromCompanySalesInvoiceLineRec);
                            TempSalesInvoiceLineRec."IC Item Reference No." := FromCompanySalesInvoiceHeaderRec."External Document No.";
                            TempSalesInvoiceLineRec.Insert();
                            RecordCount += 1;
                        until FromCompanySalesInvoiceLineRec.Next() = 0;
                    end;
                end;
            until FromCompanySalesInvoiceHeaderRec.Next() = 0;

            if RecordCount = 0 then
                Message('No sales invoice lines found in company %1 with the specified filters.\Date Range: %2 to %3', FilterCompanyName, StartDate, EndDate);
        end else
            Error('Unable to connect to company %1. Please verify the company name exists.', FilterCompanyName);
    end;
}