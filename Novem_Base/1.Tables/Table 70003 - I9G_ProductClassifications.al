table 70003 I9G_ProductClassifications
{
    Caption = 'Device/Product Classifications';

    fields
    {
        field(1; "I9G_ProductClassficationCode"; Code[20])
        {
            Caption = 'Device/Product Classification Code';
            NotBlank = true;
        }
        field(2; "I9G_ProductClassificationDesc"; Text[250])
        {
            Caption = 'Device/Product Classification Desc.';
        }
    }
    keys
    {
        key(PrimaryKey; I9G_ProductClassficationCode)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; I9G_ProductClassficationCode, I9G_ProductClassificationDesc) { }
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