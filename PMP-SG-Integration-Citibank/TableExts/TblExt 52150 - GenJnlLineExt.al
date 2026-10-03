tableextension 52150 CitiGenJnlLineExt extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(52150; "Citibank Product Type"; Code[3])
        {
            Caption = 'Payment Type (Citibank)';
            DataClassification = ToBeClassified;
            TableRelation = "Citibank Product Type"."Citibank Product Type";
        }

        // YF 24 Aug 2022
        field(52151; "Citibank Charge Indicator"; Option)
        {
            Caption = 'Charge Indicator (Citibank)';
            DataClassification = ToBeClassified;
            OptionMembers = " ",OUR,SHR,BEN;
        }
        // YF 24 Aug 2022
    }

}