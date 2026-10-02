table 55013 "Customer Group"
{
    Caption = 'Customer Group';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Customer Group"; Code[20])
        {
            Caption = 'Customer Group Code';
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; "Customer Group")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Customer Group")
        {
        }
    }

}