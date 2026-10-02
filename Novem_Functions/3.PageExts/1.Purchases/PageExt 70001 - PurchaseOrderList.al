pageextension 70001 PurchaseOrderListExt extends "Purchase Order List"
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
    actions
    {
        addafter(Print)
        {
            action(PurchaseOrder)
            {
                Caption = 'Purchase Order';
                Image = PurchaseInvoice;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    PurchaseHeaderRec: Record "Purchase Header";
                begin
                    PurchaseHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(PurchaseHeaderRec);
                    Report.RunModal(70010, true, false, PurchaseHeaderRec);
                end;
            }
        }
        addlast(Category_Category5)
        {
            actionref(PurchaseOrder_Promoted; PurchaseOrder) { }
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