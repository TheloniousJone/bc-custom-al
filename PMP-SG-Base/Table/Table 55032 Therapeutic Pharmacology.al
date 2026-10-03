// This table is obselete
table 55032 "Therapeutic Pharmacology"
{
    Caption = 'Therapeutic Pharmacology RET';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Therapeutic Group No."; Code[20])
        {
            Caption = 'Therapeutic Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Group"."No.";
        }
        field(10; "No."; Text[100])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Remarks"; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(30; "Is Poisonous"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Therapeutic Group No.", "No.")
        {
            Clustered = true;
        }
    }

}
