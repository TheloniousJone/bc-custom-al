table 55012 "Administration"
{
    Caption = 'Administration Route';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Administration"; Code[20])
        {
            Caption = 'Administration Route Code';
            DataClassification = ToBeClassified;

        }
        field(10; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Administration")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Administration)
        {
        }
    }
}