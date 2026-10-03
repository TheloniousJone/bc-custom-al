query 59001 "POM Ref Distinct Query"
{
    Caption = 'POM Ref Distinct Query';
    QueryType = Normal;
    OrderBy = ascending(Your_Reference);
    // TopNumberOfRows = 250;

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {
            DataItemTableFilter = "Your Reference" = filter('P3-*' | 'W1-*'), "Processed by POM" = const(false)/*, "Last Posted Invoice in Order" = const(true)*/;

            // filters
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Your_Reference_Filter; "Your Reference") { }
            filter(Order_Status_Filter; "Order Status") { }
            filter(Processed_by_POM; "Processed by POM") { }

            // fields
            column(Your_Reference; "Your Reference") { }
            column(Count) { Method = Count; }
        }
    }
}
