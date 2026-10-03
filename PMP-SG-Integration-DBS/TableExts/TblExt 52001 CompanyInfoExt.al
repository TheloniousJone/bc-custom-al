tableextension 52001 DBSCompanyInfoExt extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(52000; "Organization ID for DBS"; Code[12])
        {
            Caption = 'Organization ID (DBS Integration)';
            DataClassification = ToBeClassified;
        }

        field(52001; "Sender Name for DBS"; Text[140])
        {
            Caption = 'Sender Name (DBS Integration)';
            DataClassification = ToBeClassified;
        }

        field(52002; "Payment Advice Email"; Text[75])
        {
            Caption = 'Payment Advice Email (DBS Integration)';
            DataClassification = ToBeClassified;
        }
    }

}