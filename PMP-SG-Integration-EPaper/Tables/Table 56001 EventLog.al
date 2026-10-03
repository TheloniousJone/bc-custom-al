table 56001 "EPaper API Event Log"
{

    fields
    {
        field(1; "Entry No"; BigInteger)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }

        field(10; "Action Type"; Option)
        {
            OptionMembers = " ",LOGIN,TURNON,TURNOFF;
            OptionCaption = ' ,Login,Turn On,Turn Off';
            Caption = 'Action Type';
        }

        field(20; "API URL"; Text[150])
        {
            Caption = 'API URL';
        }

        field(30; "Error"; Boolean)
        {
            Caption = 'Error';
        }

        field(40; "Error Code"; Text[10])
        {
            Caption = 'Error Code';
        }

        field(50; "Event Date Time"; DateTime)
        {
            Caption = 'Event Date Time';
        }

        field(60; "Data ID"; Text[500])
        {
            Caption = 'Data ID';
        }
        /*
        field(70; "Colour ID"; Option)
        {
            OptionMembers = " ",Red,Green,Blue,Yellow,Magenta,Cyan;
            OptionCaption = ' ,Red,Green,Blue,Yellow,Magenta,Cyan';
            Caption = 'LED Tag Colour';
        }
        */
        field(70; "Colour ID"; Integer)
        {
            Caption = 'LED Tag Colour';
        }

        field(80; "Timer in Seconds"; Integer)
        {
            Caption = 'Timer in Seconds';
        }

        field(90; "Data Type"; Option)
        {
            OptionMembers = " ",EAN,SHELFID,TAGID;
            // OptionCaption = ' ,Item ID Based,Locatiom Based,Tag ID Based';
            Caption = 'Default Tag Type';
        }

        field(100; Comments; Text[250])
        {
            Caption = 'Comments';
        }

        field(110; UserId; Code[50])
        {
            Caption = 'User ID';
        }

    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

