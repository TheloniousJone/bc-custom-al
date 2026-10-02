table 55016 "Delivery Charge"
{
    Caption = 'Delivery Charge';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Delivery Charge"; Code[20])
        {
            Caption = 'Delivery Charge Code';
            DataClassification = ToBeClassified;

        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(20; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Delivery Charge")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Delivery Charge", Name)
        {
        }
    }
}