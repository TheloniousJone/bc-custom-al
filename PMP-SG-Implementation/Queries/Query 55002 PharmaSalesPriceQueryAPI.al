query 55002 "Pharma Sales Price List API"
{

    QueryType = API;
    APIPublisher = 'Illum9';
    APIGroup = 'BCPMP';
    APIVersion = 'v2.0';
    Caption = 'Pharma Sales Price List API', Locked = true;
    // OrderBy = Ascending(Bin_Code);
    EntityName = 'SalesTradeAgtAPIv2';
    EntitySetName = 'SalesTradeAgtAPIv2';
    DataAccessIntent = ReadOnly;        //DX        17 May 2023
    //TopNumberOfRows = 1000;

    elements
    {
        dataitem(PharmaSalesPrice; "Pharma Sales Price")
        {
            //DataItemTableFilter = Status = filter('Active'); // YF 16 Feb 2022

            DataItemTableFilter = "TA Type" = filter(All | POM); //RL 06 Apr 2022
            column(Sales_Type; "Sales Type") { }
            column(Sales_Code; "Sales Code") { }
            column(Item_No; "Item No.") { }
            column(Currency_Code; "Currency Code") { }
            column(Unit_Of_Measure_Code; "Unit Of Measure Code") { }
            column(Variant_Code; "Variant Code") { }
            column(Minimum_Quantity; "Minimum Quantity") { }
            column(Unit_Price; "Unit Price") { }
            column(FOC_Qty; "FOC Qty") { }
            column(Starting_Date; "Starting Date") { }
            column(Ending_Date; "Ending Date") { }
            column(Price_Includes_VAT; "Price Includes VAT") { }
            column(Line_Discount_Percent; "Line Discount %") { }
            column(Allow_Line_Disc; "Allow Line Disc.") { }
            column(Allow_Invoice_Disc; "Allow Invoice Disc.") { }
            column(VAT_Bus_Posting_Gr_Price; "VAT Bus. Posting Gr. (Price)") { }
            column(Status; Status) { }
            column(Rec_Ref_ID; RecRefID) { }
            column(Remarks; Remarks) { }
            column(System_Modified_At; SystemModifiedAt) { }

            // YF 18 Mar 2022
            column(TA_Type; "TA Type") { }
            column(Find_Next; "Find Next") { }
            // YF 18 Mar 2022

            dataitem(Item; Item)
            {
                DataItemLink = "No." = PharmaSalesPrice."Item No.";
                SqlJoinType = InnerJoin;

                column(ItemDesc; Description) { }

                dataitem(ItemUOM; "Item Unit of Measure")
                {
                    DataItemLink = Code = PharmaSalesPrice."Unit Of Measure Code", "Item No." = Item."No.";
                    //DX		30 Nov 2021
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = "Qty. per Unit of Measure" = filter(>= 1);
                    //DX		30 Nov 2021

                    column(ItemUOMConv; "Qty. per Unit of Measure") { }
                }
            }
        }
    }
}

