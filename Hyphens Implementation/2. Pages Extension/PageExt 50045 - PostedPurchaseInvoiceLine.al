pageextension 50045 PostedPurchaseInvLn extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("No of Pallet"; Rec."No. of Pallets")
            {
                ApplicationArea = All;
            }
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Job No.")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = All;
            }
            field("Forecast ETD"; Rec."Forecast ETD")
            {
                ApplicationArea = All;
            }
            field("Forecast ETA"; Rec."Forecast ETA")
            {
                ApplicationArea = All;
            }
        }
    }
}