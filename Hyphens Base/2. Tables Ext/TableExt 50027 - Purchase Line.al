tableextension 50027 PurchaseLine extends "Purchase Line"
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

            trigger OnValidate()
            begin
                CalculateForecastETA();
            end;
        }
        field(50003; "Forecast ETD"; Date)
        {
            Caption = 'Forecast ETD';
            trigger OnValidate()
            begin
                CalculateForecastETA();
            end;
        }
        field(50004; "Forecast ETA"; Date)
        {
            Caption = 'Forecast ETA';
        }
        modify("Planned Receipt Date")
        {
            trigger OnAfterValidate()
            begin
                if CurrFieldNo = FieldNo("Planned Receipt Date") then
                    "Expected Receipt Date" := xRec."Expected Receipt Date";
            end;
        }
    }

    procedure CalculateForecastETA()
    var
        ShipmentMethod: Record "Shipment Method";
        TransitDays: Integer;
    begin
        if "Forecast ETD" = 0D then begin
            "Forecast ETA" := 0D;
            exit;
        end;

        TransitDays := 0;

        ShipmentMethod.Reset();
        if ShipmentMethod.Get("Shipment Method Code") then begin
            TransitDays := ShipmentMethod.I9G_TransitDays;
        end;

        "Forecast ETA" := "Forecast ETD" + TransitDays;
    end;
}
