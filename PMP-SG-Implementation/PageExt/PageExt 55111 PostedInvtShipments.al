pageextension 55111 PostedInvtShipments extends "Posted Invt. Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment No. field.';
            }
        }
    }
}