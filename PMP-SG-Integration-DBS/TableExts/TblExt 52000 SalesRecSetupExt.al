tableextension 52000 SSDBSSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(52000; "Def. DBS CRJ Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = CONST('CASHRCPT'));
        }
        field(52001; "Def. DBS Incoming Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";
        }
    }

    var
        myInt: Integer;
}