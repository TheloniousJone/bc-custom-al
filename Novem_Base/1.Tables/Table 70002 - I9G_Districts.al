table 70002 I9G_Districts
{
    Caption = 'Districts';

    fields
    {
        field(1; "I9G_DistrictCode"; Code[20])
        {
            Caption = 'District Code';
            NotBlank = true;
        }
        field(2; "I9G_DistrictpDescription"; Text[250])
        {
            Caption = 'District Description';
        }
    }
    keys
    {
        key(PrimaryKey; I9G_DistrictCode)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; I9G_DistrictCode, I9G_DistrictpDescription) { }
    }
    trigger OnInsert()
    var
    begin

    end;

    trigger OnModify()
    var
    begin

    end;

    trigger OnDelete()
    var
    begin

    end;

    trigger OnRename()
    var
    begin

    end;
}