pageextension 69004 TransferOrder extends "Transfer Order"
{
    layout
    {
        addlast(General)
        {
            field(I9G_DriverCode; Rec.I9G_DriverCode)
            {
                ApplicationArea = All;
            }
            field(I9G_DeliveryChargeCode; Rec.I9G_DeliveryChargeCode)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }
}