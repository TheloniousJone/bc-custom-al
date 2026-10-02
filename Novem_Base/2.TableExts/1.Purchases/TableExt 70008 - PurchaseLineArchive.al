tableextension 70008 PurchaseLineArchiveTableExt extends "Purchase Line Archive"
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
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'GST Base Amount';
        }
    }
}