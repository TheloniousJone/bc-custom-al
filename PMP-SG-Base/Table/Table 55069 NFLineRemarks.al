table 55069 NFLineRemarks
{
    Caption = 'NFLineRemarks';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(20; Remarks; Text[200])
        {
            Caption = 'Remarks';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
