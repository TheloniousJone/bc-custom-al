table 56100 "Zuellig Integration Setup"
{

    fields
    {
        field(1; "Primary Key"; Integer)
        {
        }

        field(10; "Enable EC-Web Customer ID"; Boolean)
        {
            Caption = 'Enable EC-Web Customer ID';
        }

        field(20; "Assigned EC-Web Customer ID"; Code[20])
        {
            Caption = 'Assigned EC-Web Customer ID';
        }

        field(30; "BC Vendor Code"; Code[20])
        {
            Caption = 'ZP BC Vendor Code';
            TableRelation = Vendor;
        }

        field(40; "Location/Store Code"; Code[20])
        {
            Caption = 'Location/Store Code';
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

