table 55010 "Item Status"
{
    Caption = 'Item Status';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Status Code"; Code[35])
        {
            Caption = 'Item Status Code';
            DataClassification = ToBeClassified;

        }

        field(10; "Status Remarks"; Text[100])
        {
            Caption = 'Status Remarks';
            DataClassification = ToBeClassified;
        }
        field(20; "POM2 Status"; code[35])
        {
            Caption = 'POM2 Status';
            DataClassification = ToBeClassified;
        }
        field(30; "POM3 Remarks"; code[100])
        {
            Caption = 'POM3 Status';
            DataClassification = ToBeClassified;
        }

        field(40; "POM2 Status V2"; Text[35])
        {
            Caption = 'POM2 Status';
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(PK; "Status Code")
        {
            Clustered = true;
        }
    }
}