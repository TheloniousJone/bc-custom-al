pageextension 57008 RepItemCardPageExt extends "Item Card"
{
    actions
    {
        addafter(Navigation_Item)
        {
            action("Sync Req Planning")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    ItemRec: Record item;
                begin
                    CurrPage.SetSelectionFilter(ItemRec);
                    Report.Run(57014, false, false, ItemRec);
                    Message('Sync completed.');
                end;
            }
        }
    }
}
