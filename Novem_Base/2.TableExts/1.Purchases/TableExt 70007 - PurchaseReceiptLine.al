tableextension 70007 PurchaseReceiptLineTableExt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(70000; I9G_CompletelyReceived; Boolean)
        {
            Caption = 'Completely Received';
            Editable = false;
        }
    }
}