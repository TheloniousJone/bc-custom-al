pageextension 50048 ShipmentMethods extends "Shipment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field(I9G_TransitDays; Rec.I9G_TransitDays)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}