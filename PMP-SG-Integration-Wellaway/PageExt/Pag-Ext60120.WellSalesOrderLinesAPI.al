pageextension 60120 WellSalesOrderLinesAPI extends "Sales Order Lines API"
{
    layout
    {
        addafter(ExprDate)
        {
            field(StockBal; StockBal)
            {
                Caption = 'Wellaway Stock Bal.';
                Editable = false;
                ApplicationArea = all;
                Style = Attention;
                Visible = VisibleBool;
            }
            field("Invoiced In PMP"; Rec."Invoiced In PMP")
            {
                Caption = 'Line Invoiced in PMP';
                Editable = true;
                ApplicationArea = all;
                Visible = VisibleBool;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then
            StockBal := WellCU.GetWellStockBalance(Rec)
        else
            StockBal := 0;

        if WellCU.IsWellawayCompany() then
            VisibleBool := true else
            VisibleBool := false;
    end;



    var
        WellCU: Codeunit "Wellaway CU";
        VisibleBool: Boolean;
        StockBal: Decimal;
}
