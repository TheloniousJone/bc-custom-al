pageextension 60111 WellItemListPageExt extends "Item List"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field(StockBalLoose; StockBalLoose)
            {
                ApplicationArea = all;
                Caption = 'Stock Balance (Loose)';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        WellCU: Codeunit "Wellaway CU";
    begin
        StockBalLoose := WellCU.GetTotalLooseQty(Rec."No.");
    end;

    var
        StockBalLoose: Decimal;
}
