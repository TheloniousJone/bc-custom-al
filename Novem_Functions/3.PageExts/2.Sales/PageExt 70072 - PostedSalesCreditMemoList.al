pageextension 70072 PostedSalesCreditMemoListExt extends "Posted Sales Credit Memos"
{
    layout
    {

    }
    actions
    {
        addafter("&Print")
        {
            action(PostedSalesCreditNote)
            {
                Caption = 'Sales Credit Note';
                Image = Order;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    SalesCrMemoHeaderRec: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(SalesCrMemoHeaderRec);
                    Report.RunModal(70002, true, false, SalesCrMemoHeaderRec);
                end;
            }
        }
        addlast(Category_Category7)
        {
            actionref(PostedSalesCreditNote_Promoted; PostedSalesCreditNote) { }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}