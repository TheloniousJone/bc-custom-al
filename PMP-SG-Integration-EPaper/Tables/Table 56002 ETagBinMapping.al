table 56002 "ETag Bin Mapping"
{

    fields
    {
        field(1; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code;
        }

        field(10; "ETag ID"; Code[50])
        {
            Caption = 'ETag ID';
        }

    }

    keys
    {
        key(Key1; "Bin Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

