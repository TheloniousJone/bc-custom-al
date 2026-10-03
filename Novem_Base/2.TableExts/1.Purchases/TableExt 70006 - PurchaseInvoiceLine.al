tableextension 70006 PurchaseInvoiceLineTableExt extends "Purch. Inv. Line"
{
    fields
    {
        field(70000; I9G_CompletelyReceived; Boolean)
        {
            Caption = 'Completely Received';
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