query 55001 "Lot Nums by Bin Extended API"
{

    QueryType = API;
    APIPublisher = 'Illum9';
    APIGroup = 'BCPMP';
    APIVersion = 'v1.0';
    Caption = 'Lot Numbers by Bin Extended API', Locked = true;
    OrderBy = Ascending(Bin_Code);
    EntityName = 'LotNoBinExtended';
    EntitySetName = 'LotNoBinExtendeds';
    DataAccessIntent = ReadOnly;        //DX        17 May 2023
    ReadState = ReadUncommitted;      //DF        03 June 2023

    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {
            ;
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
            }
            column(Lot_No; "Lot No.")
            {
            }
            column(Serial_No; "Serial No.")
            {
            }
            column(Package_No; "Package No.")
            {
            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {
            }
            // column(Expiration_Date; "Expiration Date")
            // {
            // }
            // column(Description; Description)
            // {
            // }
            column(Sum_Qty_Base; "Qty. (Base)")
            {
                ColumnFilter = Sum_Qty_Base = FILTER(<> 0);
                Method = Sum;
            }

            //DX        30 May 2023     Remove one table join
            dataitem(Item_Ledger_Entry; "Item Ledger Entry")
            {
                DataItemLink = "Lot No." = Warehouse_Entry."Lot No.", "Item No." = Warehouse_Entry."Item No.";

                DataItemTableFilter = Open = filter(= true);
                SqlJoinType = InnerJoin;      //DX        23  May  2023

                dataitem(Item; "Item")
                {
                    DataItemLink = "No." = Warehouse_Entry."Item No.";
                    SqlJoinType = InnerJoin;      //DX        23  May  2023

                    column(ItemDescription; Description)
                    { }

                }
                column(Expiration_Date; "Expiration Date") { }


            }
            //DX        30 May 2023

            /*
                        dataitem(Item; Item)
                        {
                            DataItemLink = "No." = Warehouse_Entry."Item No.";

                            column(ItemDescription; Description)
                            { }

                            dataitem(Item_Ledger_Entry; "Item Ledger Entry")
                            {
                                DataItemLink = "Lot No." = Warehouse_Entry."Lot No.", "Item No." = Warehouse_Entry."Item No.";

                                DataItemTableFilter = Open = filter(= true);
                                SqlJoinType = InnerJoin;      //DX        23  May  2023

                                column(Expiration_Date; "Expiration Date") { }


                            }
                        }
                        */

        }
    }
}

