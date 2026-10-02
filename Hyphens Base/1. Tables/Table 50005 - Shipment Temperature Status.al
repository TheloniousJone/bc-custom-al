table 50005 "Shipment Temperature Status"
{
    Caption = 'Shipment Temperature Status';
    LookupPageId = "Shipment Temp. Status List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}