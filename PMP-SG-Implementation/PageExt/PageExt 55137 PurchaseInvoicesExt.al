pageextension 55137 PurchaseInvoicesExt extends "Purchase Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedBy; EnhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
        }
    }
    var
        EnhanceCU: Codeunit "PMP-Enhancements";
}
