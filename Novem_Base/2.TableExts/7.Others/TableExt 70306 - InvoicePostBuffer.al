tableextension 70306 InvoicePostBufferExt extends "Invoice Post. Buffer"
{
    fields
    {
        field(70002; I9G_GSTBaseAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'GST Base Amount';
        }
    }
}