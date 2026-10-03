table 55068 ItemRestrictions
{
    Caption = 'ItemRestrictions';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; RestrictionName; Code[50])
        {
            Caption = 'RestrictionName';
        }
        field(10; Description; Text[100])
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
        key(PK; RestrictionName)
        {
            Clustered = true;
        }
    }
}
