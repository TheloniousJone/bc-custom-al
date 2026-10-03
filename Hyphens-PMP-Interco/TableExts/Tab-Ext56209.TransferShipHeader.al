tableextension 56209 TransferShipHeader extends "Transfer Shipment Header"
{
    fields
    {
        field(56200; "Interco Order No"; Code[20])
        {
            Caption = 'Interco Order No';
            DataClassification = ToBeClassified;
        }
    }
}
