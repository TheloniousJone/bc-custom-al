query 55000 "Lot Numbers by Bin Custom"
{
    QueryType = api;
    Caption = 'Lot Numbers by Bin - Custom';
    APIPublisher = 'Illum9';
    APIGroup = 'BCPMP';
    APIVersion = 'v1.0';
    EntityName = 'LotNoBinExtended';
    EntitySetName = 'LotNoBinExtendeds';
    OrderBy = Ascending(Bin_Code);
    DataAccessIntent = ReadOnly;        //DX        17 May 2023
    ReadState = ReadUncommitted;      //DF        03 June 2023
    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {
            column(Location_Code; "Location Code")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Zone_Code; "Zone Code")
            {
            }
            column(Bin_Code; "Bin Code")
            {
                ColumnFilter = Bin_Code = filter('<>ADJUSTMENT');//RL 25 Nov 2021
            }
            column(Lot_No; "Lot No.")
            {
            }
            // column(Serial_No; "Serial No.")
            // {
            // }
            // column(Package_No; "Package No.")
            // {
            // }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {
            }
            column(Expiration_Date; "Expiration Date")
            {
            }
            // column(Description; Description)
            // {
            // }
            column(Sum_Qty_Base; "Qty. (Base)")
            {
                ColumnFilter = Sum_Qty_Base = FILTER(<> 0);
                Method = Sum;
            }
            /*
            column(Sum_Qty; Quantity)
            {
                ColumnFilter = Sum_Qty = FILTER(<> 0);
                Method = Sum;
            }
            */

            //DX        28 Jun 2023
            dataitem(Item; "Item")
            {
                DataItemLink = "No." = Warehouse_Entry."Item No.";
                SqlJoinType = InnerJoin;      //DX        23  May  2023

                column(ItemDescription; Description)
                { }

            }
            //DX        28 Jun 2023 
        }
    }
}

