report 57032 "Balance On Hand Report"
{
    ApplicationArea = All;
    Caption = 'Balance On Hand Report';
    RDLCLayout = './ReportLayouts/ReportLayout 57032 - BalanceOnHandreport.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = sorting(number);
            column(Item_No; LotBal.Item_No_)
            {
            }
            column(Description; ItemDescription)
            {

            }
            column(ExprDate; FORMAT(LotBal.ExpirationDate))
            {

            }
            column(LocCode; LotBal.LocationCode)
            {

            }

            column(LotNo; LotBal.LotNo)
            {

            }
            column(Qty; LotBal.RemainingQuantity)
            {

            }
            column(UOM; LotBal.UnitofMeasureCode)
            {

            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                LotBal.Open();
                if ItemFilter <> '' then
                    LotBal.SetFilter(LotBal.Item_No_, ItemFilter);

            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if not LotBal.Read() then
                    CurrReport.Break();

                ItemRec.reset;
                ItemRec.SetRange("No.", LotBal.Item_No_);
                if ItemRec.FindFirst() then begin
                    ItemDescription := ItemRec.Description;
                end else
                    ItemDescription := '';

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

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var

        LotBal: Query RemStockBatch;
        lineNo: integer;

        EntryNo: Integer;
        CompInfo: Record "Company Information";
        SSSetup: Record "Sales & Receivables Setup";
        ItemDescription: Text[100];
        ItemRec: Record item;

        ItemFilter: Code[20];

}
