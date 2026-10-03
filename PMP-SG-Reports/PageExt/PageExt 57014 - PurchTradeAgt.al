pageextension 57014 PurchTradeAgtExt extends PharmaPurchasePriceList
{
    actions
    {
        addlast(Processing)
        {
            action("Delete Purchase Trade Agreement Lines")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                Caption = 'Bulk Delete Lines';
                RunObject = report "Delete Purchase Price Lines";
            }
        }
    }
}