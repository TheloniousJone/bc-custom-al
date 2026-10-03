pageextension 57013 SalesTradeAgtExt extends PharmaSalesPriceList
{
    actions
    {
        addlast(Processing)
        {
            action("Delete Sales Trade Agreement Lines")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                Caption = 'Bulk Delete Lines';
                RunObject = report "Delete Sales Price Lines";
            }
        }
    }
}