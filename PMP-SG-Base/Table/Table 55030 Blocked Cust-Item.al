table 55030 "Blocked Cust-Item"
{
    Caption = 'Blocked Customer - Item Mapping';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cust No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(10; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(20; Remarks; text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Cust No.", "Item Code")
        {
            Clustered = true;
        }
    }

}
