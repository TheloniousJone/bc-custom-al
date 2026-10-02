table 55011 "Forensic Group"
{
    Caption = 'Forensic Group';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Forensic Group"; Code[20])
        {
            Caption = 'Forensic Group Code';
            DataClassification = ToBeClassified;
        }
        field(10; "Controlled Drug"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        28 Aug 2021
        field(20; "Poison"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        28 Aug 2021

        // YF 24 Mar 2025
        field(30; I9G_STBio; Boolean)
        {
            Caption = 'ST Bio';
            DataClassification = ToBeClassified;
        }
        // YF 24 Mar 2025
    }

    keys
    {
        key(PK; "Forensic Group")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Forensic Group")
        {
        }
    }
}