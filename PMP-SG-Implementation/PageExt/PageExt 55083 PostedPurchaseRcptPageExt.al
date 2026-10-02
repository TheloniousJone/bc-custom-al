pageextension 55083 PostedPurchaseRcptPageExt extends "Posted Purchase Receipt"
{
    layout
    {
        addbefore("Shipment Method Code")
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
            }
        }

        // YF 03 Mar 2022
        addafter("Purchaser Code")
        {
            field("Country of Purchase Code"; Rec."Country of Purchase Code")
            {
                ApplicationArea = All;
            }
            field("Ship From Country"; Rec."Ship From Country")
            {
                ApplicationArea = all;
            }
        }
        // YF 03 Mar 2022

        addlast(General)
        {
            field("Internal Remarks"; Rec."Internal Remarks")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }        
    }
}
