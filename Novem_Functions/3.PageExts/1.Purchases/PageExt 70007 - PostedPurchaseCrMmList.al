pageextension 70007 PostedPurchaseCrMmListExt extends "Posted Purchase Credit Memos"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action(PostedPurchaseCreditNote)
            {
                Caption = 'Purchase Credit Note';
                Image = CreditMemo;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    PurchCrMmHdrRec: Record "Purch. Cr. Memo Hdr.";
                begin
                    PurchCrMmHdrRec.Reset();
                    CurrPage.SetSelectionFilter(PurchCrMmHdrRec);
                    Report.RunModal(70012, true, false, PurchCrMmHdrRec);
                end;
            }
        }
        addlast(Category_Category6)
        {
            actionref(PostedPurchaseCreditNote_Promoted; PostedPurchaseCreditNote) { }
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