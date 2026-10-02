pageextension 50002 itemlist extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Unit Price")
        {
            field("Hyphens Item Group"; Rec."Hyphens Item Group")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Bin Contents")
        {
            action(Inventorylot)
            {
                ApplicationArea = All;
                Caption = 'Inventory value with Lot';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = report 50013;
            }
        }
    }

}