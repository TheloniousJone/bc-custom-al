table 52150 "Citibank Product Type"
{
    DataClassification = ToBeClassified;
    Caption = 'Citibank Product Type';
    DataCaptionFields = "Citibank Product Type", "Citibank Product Description";
    DrillDownPageID = "Citibank Product Type List";
    LookupPageID = "Citibank Product Type List";

    fields
    {
        field(1; "Citibank Product Type"; Code[3])
        {
            DataClassification = ToBeClassified;
            Caption = 'Citibank Product Type';
        }

        field(10; "Citibank Product Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Citibank Product Description';
        }
    }

    keys
    {
        key(PK; "Citibank Product Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Citibank Product Type", "Citibank Product Description")
        {
        }
    }

}