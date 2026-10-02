query 59002 "POM Payt Recon PSI Query"
{
    Caption = 'POM Payt Recon PSI Query';
    QueryType = Normal;
    OrderBy = ascending(No_);
    // TopNumberOfRows = 10;
    DataAccessIntent = ReadOnly;      //DX        29 May 2023
    // Part 1: See Query 59000
    // Part 2: For Posted Sales Invoices with difference in amount

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {

            DataItemTableFilter = "Last Posted Invoice in Order" = filter(true), "Your Reference" = filter('P3-*' | 'W1-*');

            filter(Payment_Method_Code; "Payment Method Code") { }

            column(No_; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Order_No_; "Order No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Amount_Collected_by_POM; "Amount Collected by POM") { }
            // YF 07 Nov 2022
            // column(Amount_Including_VAT; "Amount Including VAT") { Method = Sum; } 
            dataitem(Sales_Invoice_Header_Child; "Sales Invoice Header")
            {
                DataItemLink = "Your Reference" = Sales_Invoice_Header."Your Reference";
                SqlJoinType = LeftOuterJoin;

                column(Amount_Including_VAT; "Amount Including VAT") { Method = Sum; }
            }
            // YF 07 Nov 2022
        }
    }

}
