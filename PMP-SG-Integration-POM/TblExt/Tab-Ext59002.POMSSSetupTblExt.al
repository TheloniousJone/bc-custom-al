tableextension 59002 POMSSSetupTblExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(59000; "POM2 Email"; Text[250])
        {
            Caption = 'POM2 Email';
            DataClassification = ToBeClassified;
        }

        // YF 08 Sep 2022
        field(59001; "POM Collect Payt Method Filter"; Code[10])
        {
            Caption = 'POM Collection Payment Method Filter';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".Code;
        }
        // YF 08 Sep 2022

        // YF 23 Sep 2022
        field(59002; "Retire POM Prefix"; Code[3])
        {
            Caption = 'Retire POM Prefix';
            DataClassification = ToBeClassified;
        }
        // YF 23 Sep 2022
    }
}
