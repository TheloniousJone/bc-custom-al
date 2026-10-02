table 55025 Picker
{
    Caption = 'Picker';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(10; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(20; "CD"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Controlled Drugs';

        }
        field(30; Normal; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Normal';
        }
        field(40; Dedicated; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Dedicated Picker';
        }
        field(50; Logistics; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Logistics Picker';
        }
        //DX        09 July 2021
        field(60; "E Tag ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'E Tag LED ID';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
            end;
        }
        //DX        09 July 2021
        field(61; Wellaway; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Wellaway';
        }

        // YF 24 Mar 2025
        field(70; I9G_STBio; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'ST Bio';
        }
        // YF 24 Mar 2025
    }
    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }

}
