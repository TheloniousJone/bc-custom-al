tableextension 59000 POMCustExt extends Customer
{
    fields
    {
        field(50101; "POM No."; Code[50])
        {
            Caption = 'POM No.';
            DataClassification = ToBeClassified;
        }
        field(50102; "Web User ID"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Web User Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}
