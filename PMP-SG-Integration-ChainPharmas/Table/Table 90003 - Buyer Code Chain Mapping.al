table 90003 "Buyer Code Chain Mapping"
{
    Caption = 'Buyer Code Chain Mapping';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Chain Code"; Code[10])
        {
            Caption = 'Chain Code';
            DataClassification = ToBeClassified;
        }

        field(10; "Buyer Code"; Code[20])
        {
            Caption = 'Buyer Code';
            DataClassification = ToBeClassified;
        }

        field(20; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; "Chain Code", "Buyer Code")
        {
            Clustered = true;
        }
    }

}
