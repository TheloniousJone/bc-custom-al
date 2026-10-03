pageextension 50047 HyphensPostedPurchaseInvoices extends "Posted Purchase Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("Freight Forwarder"; Rec."Freight Forwarder")
            {
                ApplicationArea = All;
            }
            field("Freight Forwarder Invoice No."; Rec."Freight Forwarder Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Actual ETD"; Rec."Actual ETD")
            {
                ApplicationArea = All;
            }
            field("Actual ETA-Port"; Rec."Actual ETA-Port")
            {
                ApplicationArea = All;
            }
            field("Shipment Temperature Status"; Rec."Shipment Temperature Status")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}