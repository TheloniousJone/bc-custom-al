pageextension 66003 InventorySetup extends "Inventory Setup"
{
    layout
    {
        addlast(General)
        {
            field(I9G_SiteID; Rec.I9G_SiteID)
            {
                ApplicationArea = All;
            }
        }
    }
}