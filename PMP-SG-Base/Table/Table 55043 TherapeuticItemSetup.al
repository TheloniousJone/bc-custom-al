// This table is obselete
table 55043 "Therapeutic-Item Setup"
{
    Caption = 'Therapeutic-Item Setup RET';
    DataClassification = ToBeClassified;

    fields
    {
        //DX        25 Aug 2021
        field(1; "Therapeutic Category"; Code[20])
        {
            Caption = 'Therapeutic Category';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Pharmacology"."Therapeutic Group No.";
        }
        field(10; "Therapeutic Pharmacology"; Code[100])
        {
            Caption = 'Therapeutic Pharmacology';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Pharmacology"."No.";
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        //DX        25 Aug 2021
    }
    keys
    {
        key(PK; "Therapeutic Category", "Therapeutic Pharmacology", "Item No.")
        {
            Clustered = true;
        }
    }

}
