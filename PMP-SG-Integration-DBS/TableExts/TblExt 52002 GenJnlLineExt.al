tableextension 52002 DBSGenJnlLineExt extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(52000; "DBS Product Type"; Code[3])
        {
            Caption = 'Payment Type (DBS)';
            DataClassification = ToBeClassified;
            TableRelation = "DBS Product Type"."DBS Product Type";
        }
    }

}