table 55017 Accpac
{
    Caption = 'Accpac';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Accpac Code"; Code[20])
        {
            Caption = 'Accpac Code';
            DataClassification = ToBeClassified;

        }
        field(10; "Accpac Name"; Text[50])
        {
            Caption = 'Accpac Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Accpac Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Accpac Code", "Accpac Name")
        {
        }
    }
}