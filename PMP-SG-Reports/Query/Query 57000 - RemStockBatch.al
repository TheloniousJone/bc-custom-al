query 57000 RemStockBatch
{
    Caption = 'RemStockBatch';
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Remaining Quantity" = filter('<>0');
            column(RemainingQuantity; "Remaining Quantity")
            {
                Method = Sum;
            }
            column(LotNo; "Lot No.")
            {
            }
            column(Item_No_; "Item No.")
            { }
            column(LocationCode; "Location Code")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {

            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
