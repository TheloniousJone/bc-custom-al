query 55006 "Bin Avail. for Pick VivoMixx"
{

    QueryType = API;
    APIPublisher = 'Illum9';
    APIGroup = 'BCPMP';
    APIVersion = 'v1.0';
    Caption = 'Bin Content Avail. for Pick Vivomixx', Locked = true;
    OrderBy = Ascending(Bin_Code);
    EntityName = 'LotNoBinExtended';
    EntitySetName = 'LotNoBinExtendeds';
    DataAccessIntent = ReadOnly;        //DX        17 May 2023
    ReadState = ReadUncommitted;      //DF        03 June 2023

    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {
            DataItemTableFilter = "Location Code" = filter('PMP-WH'), "Variant Code" = filter(''), "Bin Type Code" = filter('PICK|PUTPICK');

            // filter(LocationCodeFilter; "Location Code") { }

            column(Location_Code; "Location Code")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Bin_Code; "Bin Code")
            {
            }
            column(Bin_Type_Code; "Bin Type Code") { }
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

            column(Sum_Qty_Base; "Qty. (Base)")
            {
                ColumnFilter = Sum_Qty_Base = FILTER(<> 0);
                Method = Sum;
            }

            dataitem(Item; Item)
            {
                DataItemLink = "No." = Warehouse_Entry."Item No.";
                DataItemTableFilter = ShortcutDim4Code = filter('VIVOMIXX');
                column(ItemDescription; Description)
                { }

                dataitem(Item_Ledger_Entry; "Item Ledger Entry")
                {
                    DataItemLink = "Lot No." = Warehouse_Entry."Lot No.", "Item No." = Warehouse_Entry."Item No.";
                    DataItemTableFilter = Open = filter(= true);

                    column(Expiration_Date; "Expiration Date") { }

                    /*
                    dataitem(Bin_Content;"Bin Content")
                    {
                        DataItemLink = "Location Code" = Warehouse_Entry."Location Code",
                                        "Bin Code" = Warehouse_Entry."Bin Code",
                                        "Item No." = Warehouse_Entry."Item No.",
                                        "Variant Code" = Warehouse_Entry."Variant Code",
                                        "Unit of Measure Code" = Warehouse_Entry."Unit of Measure Code";

                        column(CalcQtyAvailToTakeUOM) 
                        { 
                            Method = Count;
                            // ColumnFilter = CalcQtyAvailToTakeUOM = FILTER(<> 0);
                            // Method = Sum;
                        }
                    }
                    */
                }
            }

        }
    }
}

