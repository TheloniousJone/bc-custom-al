pageextension 52001 SalesOrderExt extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addbefore("No.")
        {
            field("No. Series"; Rec."No. Series")
            {
                ApplicationArea = all;
            }

        }
    }

}