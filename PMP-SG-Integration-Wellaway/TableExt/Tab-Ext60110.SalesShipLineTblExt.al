tableextension 60110 SalesShipLineTblExt extends "Sales Shipment Line"
{
    fields
    {
        //DX        25 July 2021
        field(60101; "Presc. Desc"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prescription 1';
        }

        field(60102; "Presc. Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prescription 2';
        }
        //DX        25 July 2021
    }
}
