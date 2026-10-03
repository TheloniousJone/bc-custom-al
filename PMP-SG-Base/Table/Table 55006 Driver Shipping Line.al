table 55006 "Driver Shipping Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Driver Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Driver Shipping Header"."No.";
        }
        field(10; "Line No."; integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Customer Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Address 2"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Delivery Instructions"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Operating Hours"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 May 2021     Additional field to record shipping packages
        field(110; "Shipping Packacges"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Shipping Packages';
        }
        field(120; "Line Checked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 May 2021     Additional field to record shipping packages
    }

    keys
    {
        key(Key1; "Driver Doc No.", "Line No.")
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