pageextension 59003 POMSalesOrderList extends "Sales Order List"
{
    layout
    {
        addafter(Amount)
        {
            field("Placed By"; Rec."Placed By")
            {
                ApplicationArea = all;
            }

            // YF 08 Sep 2022
            field("Amount Collected by POM"; Rec."Amount Collected by POM")
            {
                ApplicationArea = All;
            }
            // YF 08 Sep 2022
        }
    }
}
