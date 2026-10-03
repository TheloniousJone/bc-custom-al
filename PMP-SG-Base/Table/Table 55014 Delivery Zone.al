table 55014 "Delivery Zone"
{
    Caption = 'Delivery Zone';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Delivery Zone"; Code[20])
        {
            Caption = 'Delivery Zone Code';
            DataClassification = ToBeClassified;

        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Delivery Zone")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Delivery Zone", Name)
        {
        }
    }
}