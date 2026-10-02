pageextension 55112 PostedTransferShipmentSubform extends "Posted Transfer Shipment Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Line Remarks"; Rec."Line Remarks")
            {
                ApplicationArea = All;
            }
            field("No. of Carton"; Rec."No. of Carton")
            {
                ApplicationArea = All;
            }

        }
    }

}
