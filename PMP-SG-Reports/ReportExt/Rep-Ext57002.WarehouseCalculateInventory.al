reportextension 57002 WarehouseCalculateInventory extends "Whse. Calculate Inventory"
{
    dataset
    {
    }
    // requestpage
    // {
    //     layout
    //     {
    //         addafter(ZeroQty)
    //         {
    //             field(ForcePhysicalZero; ForcePhysicalZero)
    //             {
    //                 Caption = 'Force Physical Zero';
    //                 ApplicationArea = All;
    //             }
    //         }
    //     }
    // }

    var
        ForcePhysicalZero: Boolean;
}
