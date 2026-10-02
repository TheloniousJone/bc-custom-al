table 90002 "Cust. Chain Location Mapping"
{
    Caption = 'Customer Chain Location Mapping';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(2; "Chain Code"; Code[10])
        {
            Caption = 'Chain Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Chain Location Code"; Code[20])
        {
            Caption = 'Chain Location Code';
            DataClassification = ToBeClassified;
        }
        field(4; "Item Ref Customer No."; Code[20])
        {
            Caption = 'Item Ref Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Chain Code", "Chain Location Code")
        {
            Clustered = true;
        }
    }

}
