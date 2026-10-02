query 57001 ItemBinContentAsOf
{
    Caption = 'ItemBinContentAsOf';
    QueryType = Normal;
    OrderBy = ascending(Item_No), ascending(Location_Code), ascending(Bin_Code);
    
    // TopNumberOfRows = 10;

    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {
            DataItemTableFilter = "Qty. (Base)" = filter('<>0')/*, "Item No." = const('3M01Z')*/;

            filter(Item_No_Filter; "Item No.") { }
            filter(Registering_Date; "Registering Date") { }

            column(Base_Qty; "Qty. (Base)")
            {
                Method = Sum;
            }

            column(Item_No; "Item No.") { }
            column(Location_Code; "Location Code") { }
            column(Bin_Code; "Bin Code") { }
            column(Lot_No_; "Lot No.") { }
            column(Variant_Code; "Variant Code") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }

            // column(Expiration_Date; "Expiration Date") { }

            dataitem(Item; Item)
            {
                DataItemLink = "No." = Warehouse_Entry."Item No.";
                SqlJoinType = InnerJoin;

                column(ItemDesc; Description) { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            }


        }
    }

}
