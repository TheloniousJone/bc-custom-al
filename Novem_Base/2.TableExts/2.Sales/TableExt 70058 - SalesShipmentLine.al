tableextension 70058 SalesShipmentLineTableExt extends "Sales Shipment Line"
{
    fields
    {
        field(70000; "I9G_OpenQuantity"; Decimal)
        {
            Caption = 'Open Quantity';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
    }
}