pageextension 70002 PurchaseInvoiceListExt extends "Purchase Invoices"
{
    layout
    {
        addafter("No.")
        {
            field(I9G_CompletelyReceived; Rec.I9G_CompletelyReceived)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Completely Received field.';
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}