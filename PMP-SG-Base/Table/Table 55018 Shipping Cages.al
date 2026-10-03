table 55018 "Shipping Cages"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Shipping Cage Code"; Code[20])
        {
            Caption = 'Shipping Cage Code';
            DataClassification = ToBeClassified;

        }
        field(10; Name; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Shipping Cage Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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