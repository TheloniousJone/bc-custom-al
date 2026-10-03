table 55045 "TBA Bin"
{
    Caption = 'TBA Bin';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Bin Code"; Code[50])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Bin Code")
        {
            Clustered = true;
        }
    }
    
}
