tableextension 70309 InvoicePostingBufferExt extends "Invoice Posting Buffer"
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