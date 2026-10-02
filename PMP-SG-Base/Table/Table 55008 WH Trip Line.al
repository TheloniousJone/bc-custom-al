table 55008 "WH Trip Line"
{
    Caption = 'WH Trip Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Doc No."; Code[20])
        {
            Caption = 'Doc No.';
            DataClassification = ToBeClassified;
            TableRelation = "WH Trip Header"."No.";
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }

        field(12; "Basket No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Basket."No.";
        }
        field(15; "Trolley No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Pick Doc No."; Code[20])
        {
            Caption = 'Pick Doc No.';
            DataClassification = ToBeClassified;
            //TableRelation = "Warehouse Activity Line"."No.";

        }
        field(30; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
        }
        field(40; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
            DataClassification = ToBeClassified;
        }
        field(50; "Line Completed"; Boolean)
        {
            Caption = 'Line Completed';
            DataClassification = ToBeClassified;
        }
        field(70; "Priority Picking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "2nd Pick"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = '2nd Pick for Cold Store';
        }
    }
    keys
    {
        key(PK; "Doc No.", "Line No.")
        {
            Clustered = true;
        }

        //DX    30 May 2023
        key(key2; "Pick Doc No.")
        {

        }
        //DX    30 May 2023
    }

}
