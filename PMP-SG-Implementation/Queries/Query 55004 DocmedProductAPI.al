query 55004 "DocmedProductAPI"
{
    Caption = 'DocmedProductAPI';
    // OrderBy = Ascending(Bin_Code);
    DataAccessIntent = ReadOnly;        //DX        17 May 2023
    elements
    {
        dataitem(Item; Item)
        {

            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(BaseUnitofMeasure; "Base Unit of Measure")
            {
            }
            column(ItemStatus; "Item Status")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(ShortcutDim7Code; ShortcutDim7Code)
            {
            }
            column(ShortcutDim8Code; ShortcutDim8Code)
            {
            }
            column(POMItem; "POM Item")
            {
            }
            column(WellawayItem; "Wellaway Item")
            {
            }
            column(LogisticsService; "Logistics Service")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(CDType; "CD Type")
            {
            }
            column(Classification; Classification)
            {
            }
            column(GenericName; "Generic Name")
            {
            }
            column(ForensicGroup; "Forensic Group")
            {
            }
            column(StorageCondition; "Storage Condition")
            {
            }
            column(OtherInformation; "Other Information")
            {
            }
            column(Manufacturer; Manufacturer)
            {
            }
            column(Principal; Principal)
            {
            }
            column(CustomerInformation; "Customer Information")
            {
            }
            column(Inventory; Inventory)
            {
            }
            dataitem(Pharma_Sales_Price; "Pharma Sales Price")
            {
                DataItemLink = "Item No." = Item."No.";
                DataItemTableFilter = "Sales Code" = filter('G035HQ|W003888|Watson|NTUCHQ|NTUCBranch'), Status = filter('Active');


                column(SalesType; "Sales Type")
                {
                }
                column(SalesCode; "Sales Code")
                {
                }
                column(MinimumQuantity; "Minimum Quantity")
                {
                }
                column(FOCQty; "FOC Qty")
                {
                }
                column(UnitOfMeasureCode; "Unit Of Measure Code")
                {
                }
                column(UnitPrice; "Unit Price")
                {
                }
                column(StartingDate; "Starting Date")
                {
                }
                column(EndingDate; "Ending Date")
                {
                }
            }
        }
    }
}

