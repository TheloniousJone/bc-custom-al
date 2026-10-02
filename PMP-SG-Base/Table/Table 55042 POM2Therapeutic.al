table 55042 "POM2 Therapeutic"
{
    Caption = 'POM2 Therapeutic';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Therapeutic ID"; Text[100])
        {
            Caption = 'Therapeutic ID';
            DataClassification = ToBeClassified;
        }
        field(10; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = ToBeClassified;
            TableRelation = item."No.";
        }
    }
    keys
    {
        key(PK; "Therapeutic ID", "Item Code")
        {
            Clustered = true;
        }
    }

}
