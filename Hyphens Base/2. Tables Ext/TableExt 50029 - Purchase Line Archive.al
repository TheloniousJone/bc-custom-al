tableextension 50029 HyphensPurchInvLnArchive extends "Purchase Line Archive"
{

    fields
    {
        field(50000; "No. of Pallets"; Decimal)
        {
            Caption = 'No. of Pallets';
            DecimalPlaces = 0 : 5;
        }
        field(50001; "Remarks"; Text[500])
        {
            Caption = 'Remarks';
        }
        field(50002; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(50003; "Forecast ETD"; Date)
        {
            Caption = 'Forecast ETD';
        }
        field(50004; "Forecast ETA"; Date)
        {
            Caption = 'Forecast ETA';
        }
    }

}