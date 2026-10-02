table 55004 "Checking Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Checking Header"."No.";
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
        field(90; Cubage; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(100; Weight; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        //DX        11 May 2021     Additional field to record shipping packages
        field(110; "Shipping Packacges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 May 2021     Additional field to record shipping packages

        field(120; "Cold Room Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //DX        28 Jul 2021
        field(130; "Lot No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(140; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //DX        28 Jul 2021
        //PK19022024
        field(55084; MinShelf; Date)
        {
            Caption = 'Min Shelf Life';
        }
        //PK19022024
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