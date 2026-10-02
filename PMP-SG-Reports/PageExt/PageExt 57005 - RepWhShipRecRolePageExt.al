pageextension 57005 RepWhShipRecRolePageExt extends "Whse. WMS Role Center"
{
    layout
    {

    }
    actions
    {
        addafter("Checking List")
        {
            action("Delivery Listing")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Delivery List";

            }
        }
    }
}