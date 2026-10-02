tableextension 70009 PurchaseCreditMemoLineTableExt extends "Purch. Cr. Memo Line"
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