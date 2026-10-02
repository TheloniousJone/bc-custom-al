table 70001 I9G_ItemGroups
{
    Caption = 'Item Groups';

    fields
    {
        field(1; "I9G_ItemGroupCode"; Code[100])
        {
            Caption = 'Item Group Code';
            NotBlank = true;
        }
        field(2; "I9G_ItemGroupDescription"; Text[250])
        {
            Caption = 'Item Group Description';
        }
    }
    keys
    {
        key(PrimaryKey; I9G_ItemGroupCode)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; I9G_ItemGroupCode, I9G_ItemGroupDescription) { }
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