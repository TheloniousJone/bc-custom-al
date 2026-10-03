table 55015 "Sales Area"
{
    Caption = 'Sales Area';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Area"; Code[20])
        {
            Caption = 'Sales Area Code';
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
        key(PK; "Sales Area")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sales Area", Name)
        {
        }
    }
}