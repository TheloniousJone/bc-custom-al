query 59003 "POM Ref SO Distinct Query"
{
    Caption = 'POM Ref SO Distinct Query';
    QueryType = Normal;
    OrderBy = ascending(Your_Reference);
    // TopNumberOfRows = 250;

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Your Reference" = filter('P3-*' | 'W1-*'), "Document Type" = const(Order);

            // filters
            filter(Posting_Date_Filter; "Posting Date") { }
            filter(Your_Reference_Filter; "Your Reference") { }

            // fields
            column(Your_Reference; "Your Reference") { }
            column(Count) { Method = Count; }
        }
    }
}
