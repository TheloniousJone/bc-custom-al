report 70044 "SalesAnalysRpByItems&Cust"
{
    DefaultLayout = RDLC;
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Analysis Report by Items and Customer ';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './6.ReportLayouts/Rpt70044-SalesAnalysRpByItems&Cust.rdl';

    dataset
    {
        dataitem(ItemLedEntry; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Entry Type", "Item No.") WHERE("Entry Type" = filter('Sale'));
            RequestFilterFields = "Source No.", "Item No.";
            column(Source_Type; "Source Type") { }
            column(Source_No_; "Source No.") { }
            column(SourceName; SourceName) { }
            column(Item_No_; "Item No.") { }
            column(Description; ItemDescr) { }
            column(Qty; Qty) { }
            column(FOCQty; FOCQty) { }
            column(Invoiced_Quantity; "Invoiced Quantity") { }
            column(Sales_Amount_Actual_; "Sales Amount (Actual)") { }
            column(AnnualTotalQty; "Invoiced Quantity") { }
            column(AnnualTotalSales; "Sales Amount (Actual)") { }
            column(Posting_Date; "Posting Date") { }
            column(Monthly; Monthly) { }
            column(Year; Year) { }
            column(StartDate; StartDate) { }
            Column(EndDate; EndDate) { }
            column(GenBusPostingGrp; GenBusPostingGrp) { }

            trigger OnPreDataItem()
            begin
                ItemLedEntry.CalcFields("Shortcut Dimension 7 Code");

                ItemLedEntry.SetCurrentKey("Item No.", "Posting Date");
                ItemLedEntry.SetFilter("Last Invoice Date", '%1..%2', StartDate, EndDate);
                if ProdCode <> '' then
                    ItemLedEntry.SetRange("Shortcut Dimension 7 Code", ProdCode);

            end;

            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
                Item: Record Item;
            begin
                Clear(SourceName);
                Clear(Monthly);
                Clear(Year);
                Clear(Qty);
                Clear(FOCQty);

                Cust.Reset();
                if Cust.Get("Source No.") then begin
                    SourceName := Cust.Name;

                    if GenBusPostingGrp <> '' then begin
                        if GenBusPostingGrp <> Cust."Gen. Bus. Posting Group" then
                            CurrReport.Skip();
                    end;
                end;

                Monthly := Format(ItemLedEntry."Last Invoice Date", 0, '<Month Text>');
                Year := Format(ItemLedEntry."Last Invoice Date", 0, '<Year4>');

                Item.Reset();
                if Item.Get("Item No.") then begin
                    ItemDescr := Item.Description;
                end;

                if "Sales Amount (Actual)" <> 0 then
                    Qty := "Invoiced Quantity"
                else
                    FOCQty := "Invoiced Quantity";
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                    field(ProdCode; ProdCode)
                    {
                        Caption = 'Product Code';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code;
                    }
                    field(GenBusPostingGrp; GenBusPostingGrp)
                    {
                        Caption = 'Gen. Bus. Posting Group';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Error('Please fill in the start date and end date.');

        if StartDate > EndDate then
            Error('Start date cannot be later than the end date..');
    end;

    var
        StartDate: Date;
        EndDate: Date;
        Monthly: Text[10];
        Year: Text[5];
        SourceName: Text[100];
        Duration: Duration;
        ItemDescr: Text[100];
        Qty: Decimal;
        FOCQty: Decimal;
        ProdCode: Code[20];
        GenBusPostingGrp: Code[20];
}

