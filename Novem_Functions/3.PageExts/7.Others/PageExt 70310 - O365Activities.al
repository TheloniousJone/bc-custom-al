pageextension 70310 O365ActivitiesExt extends "O365 Activities"
{
    layout
    {
        addafter("Ongoing Sales Invoices")
        {
            field(I9G_OngoingPostedSalesInvoices; Rec.I9G_OngoingPostedSalesInvoices)
            {
                ApplicationArea = All;
                Caption = 'Posted Sales Invoices';
                DrillDownPageID = "Posted Sales Invoices";
            }

        }
        addafter("Purch. Invoices Due Next Week")
        {
            field(I9G_OngoingPostedPurchInv; Rec.I9G_OngoingPostedPurchInv)
            {
                ApplicationArea = All;
                Caption = 'Posted Purchase Invoices';
                DrillDownPageID = "Posted Purchase Invoices";
            }
        }
    }
}