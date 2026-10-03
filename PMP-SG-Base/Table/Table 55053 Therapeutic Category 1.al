table 55053 "Therapeutic Category 1"
{
    Caption = 'Therapeutic Category 1';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(10; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

}
