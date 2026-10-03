tableextension 60106 WellItemTblExt extends Item
{
    fields
    {
        field(60100; "Prescription 1"; Text[250])
        {
            Caption = 'Prescription 1';
            DataClassification = ToBeClassified;
        }
        field(60101; "Prescription 2"; Text[250])
        {
            Caption = 'Prescription 2';
            DataClassification = ToBeClassified;
        }
    }
}
