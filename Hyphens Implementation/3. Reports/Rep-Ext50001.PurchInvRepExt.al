reportextension 50001 PurchInvRepExt extends "Purchase - Invoice"
{
    dataset
    {
        add("Purch. Inv. Header")
        {
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
            }
        }
    }
}
