pageextension 70006 PostedPurchaseReceiptListExt extends "Posted Purchase Receipts"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action(PostedPurchaseReceipt)
            {
                Caption = 'Good Receipt Note';
                Image = PostedShipment;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    PurchRcptHdrRec: Record "Purch. Rcpt. Header";
                begin
                    PurchRcptHdrRec.Reset();
                    CurrPage.SetSelectionFilter(PurchRcptHdrRec);
                    Report.RunModal(70011, true, false, PurchRcptHdrRec);
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(PostedPurchaseReceipt_Promoted; PostedPurchaseReceipt) { }
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