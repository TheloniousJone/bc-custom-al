pageextension 50043 PurchaseOrderLine extends "Purchase Order Subform"
{
    layout
    {
        addafter("Location Code")
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
        addbefore("Blanket Order No.")
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
