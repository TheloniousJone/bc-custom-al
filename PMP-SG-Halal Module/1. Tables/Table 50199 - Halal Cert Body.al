table 50199 "Halal Certification Bodies"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Halal Certification Body"; Code[100])
        {

        }
        field(3; "Address"; Text[100])
        {

        }
        field(4; "Address 2"; Text[50])
        {

        }
        field(5; "City"; Text[30])
        {

        }
        field(6; "Country/Region Code"; Code[10])
        {

        }
        field(7; "Phone No."; Text[30])
        {

        }
        field(8; "Fax No."; Text[30])
        {

        }
        field(9; "Email"; Text[80])
        {

        }
        field(10; "Contact Person"; Text[100])
        {

        }
        field(11; "Halal Body Logo"; Blob)
        {
            Subtype = Bitmap;
        }
        field(12; "Slaughtering"; Boolean)
        {

        }
        field(13; "Raw Material"; Boolean)
        {

        }
        field(14; "Flavor"; Boolean)
        {

        }
        field(15; "Country Of Origin"; Code[20])
        {

        }
        field(16; "Expiration Date"; Date)
        {

        }
        field(17; "Expired"; Boolean)
        {

        }
    }

    keys
    {
        key(PK; "Halal Certification Body")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}