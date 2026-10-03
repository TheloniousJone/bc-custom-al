table 55020 "Waybill Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Waybill Header"."No.";
        }
        field(10; "Line No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Description 2"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Qty. Base"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Qty. Per Unit Of Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        //DX        11 May 2021     Additional field to record shipping packages
        field(110; "Shipping Packages"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 May 2021     Additional field to record shipping packages
    }

    keys
    {
        key(Key1; "Doc No.", "Line No.")
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