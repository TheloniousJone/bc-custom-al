table 56000 "EPaper Integration Setup"
{

    fields
    {
        field(1; "Primary Key"; Integer)
        {
        }
        field(10; "Login API URL"; Text[150])
        {
            Caption = 'Login API URL';
        }

        field(20; "Turn On LED API URL"; Text[150])
        {
            Caption = 'Turn On LED API URL';
        }

        field(30; "Turn Off LED API URL"; Text[150])
        {
            Caption = 'Turn Off LED API URL';
        }

        field(40; "Login ID"; Text[30])
        {
            Caption = 'Login ID';
        }

        field(50; "Password"; Text[50])
        {
            Caption = 'Password';
            ExtendedDatatype = Masked;
        }

        field(60; "Token"; Text[150])
        {
            Caption = 'Token';
        }

        field(70; "Turn On LED Timer in Seconds"; Integer)
        {
            Caption = 'Turn On LED Timer in Seconds';
        }

        field(80; "Default Tag Type"; Option)
        {
            OptionMembers = " ",EAN,SHELFID,TAGID;
            // OptionCaption = ' ,Item ID Based,Location Based,Tag ID Based';
            Caption = 'Default Tag Type';
        }

        field(90; "Enable Logging"; Boolean)
        {
            Caption = 'Enable Logging';
        }
        field(100; "Enable Etag LED on Picklist"; Boolean)
        {
            Caption = 'Enable Etag Integration';

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

