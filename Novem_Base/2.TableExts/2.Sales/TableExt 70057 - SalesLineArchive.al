tableextension 70057 SalesLineArchiveTableExt extends "Sales Line Archive"
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
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'GST Base Amount';
        }
    }
}