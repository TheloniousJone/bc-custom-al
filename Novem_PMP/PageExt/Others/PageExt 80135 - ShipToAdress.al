pageextension 80135 ShipToAddressPageExt3PL extends "Ship-to Address"
{
    layout
    {
        addlast(General)
        {
            field(I9G_DeliveryZone; Rec.I9G_DeliveryZone)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Zone field.';
            }
            field(I9G_DeliveryCharge; Rec.I9G_DeliveryCharge)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Charge field.';
            }
            field(I9G_NovemCustNoOfCopies; Rec.I9G_NovemCustNoOfCopies)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Novem Cust. No. Of Copies field.';
            }
        }
    }
}