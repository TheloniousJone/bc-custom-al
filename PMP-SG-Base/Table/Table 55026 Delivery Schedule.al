table 55026 "Delivery Schedule"
{
    Caption = 'Delivery Schedule';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cust No."; Code[20])
        {
            Caption = 'Cust No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(10; Description; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(20; "Delivery Zone"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Zone"."Delivery Zone";
        }
        field(30; Monday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; Tuesday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50; Wednesday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60; Thursday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70; Friday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80; Saturday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90; Sunday; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Cust No.")
        {
            Clustered = true;
        }
    }

}
