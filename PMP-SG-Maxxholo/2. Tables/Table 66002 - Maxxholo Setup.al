table 66002 MaxxholoSetup
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; I9G_EntryNo; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }
        field(2; I9G_MerchantID; Text[2000])
        {
            Caption = 'Merchat ID';
        }
        field(3; I9G_MaxxholoNos; Code[10])
        {
            Caption = 'Maxxholo Nos.';
            TableRelation = "No. Series";
        }
        field(4; I9G_URL; Text[2000])
        {
            Caption = 'URL';
        }
    }

    keys
    {
        key(Key1; I9G_EntryNo)
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