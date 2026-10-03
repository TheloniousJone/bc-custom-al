pageextension 57003 RepItemListPageExt extends "Item List"
{
    layout
    {

    }
    actions
    {
        addafter(Reports)
        {
            action("SP Inventory Balance")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Salesperson Balance Report";
            }
            action("Item Transactions")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Item Transaction";
            }
            action("Sales Report")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "PMP Sales Report";
            }
            action("On Hand Report")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Balance On Hand Report";
            }
            action("Bin Content as of Date")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Item Bin Content As Of Date";
            }
        }
    }
}
