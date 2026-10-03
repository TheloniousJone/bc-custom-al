tableextension 70059 SalesCrMmLineTableExt extends "Sales Cr.Memo Line"
{
    fields
    {
        field(70000; "I9G_OpenQuantity"; Decimal)
        {
            Caption = 'Open Quantity';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(70002; I9G_GSTBaseAmount; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'GST Base Amount';
        }
    }
}