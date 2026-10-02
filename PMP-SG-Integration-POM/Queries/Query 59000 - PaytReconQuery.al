query 59000 "POM Payt Recon Query"
{
    Caption = 'POM Payt Recon Query';
    QueryType = Normal;
    OrderBy = ascending(No_);
    // TopNumberOfRows = 10;
    DataAccessIntent = ReadOnly;      //DX        29 May 2023
    // Part 1: For Sales Order, matching relevant Posted Sales Invoices
    // Part 2: See Query 59002

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {

            DataItemTableFilter = "Document Type" = filter('Order'), "Your Reference" = filter('P3-*' | 'W1-*');

            filter(Payment_Method_Code; "Payment Method Code") { }

            column(No_; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Posting_Date; "Posting Date") { }
            column(Amount_Collected_by_POM; "Amount Collected by POM") { }

            dataitem(Sales_Invoice_Header; "Sales Invoice Header")
            {
                DataItemLink = "Your Reference" = Sales_Header."Your Reference";
                SqlJoinType = LeftOuterJoin;

                column(Amount_Including_VAT; "Amount Including VAT") { Method = Sum; }
            }

        }
    }

}
