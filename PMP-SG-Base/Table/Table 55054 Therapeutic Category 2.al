table 55054 "Therapeutic Category 2"
{
    Caption = 'Therapeutic Category 2';
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
