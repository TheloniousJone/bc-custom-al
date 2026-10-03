pageextension 50190 "ItemListPageExt" extends "Item List"
{
    layout
    {

    }
    actions
    {
        addfirst(Action126)
        {
            action("Halal List")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    HalalList: Page "Halal List";
                begin
                    HalalList.RunModal();

                end;

            }
        }
    }
}
