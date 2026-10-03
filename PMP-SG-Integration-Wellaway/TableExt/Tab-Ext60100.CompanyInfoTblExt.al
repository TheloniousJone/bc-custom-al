tableextension 60100 CompanyInfoTblExt extends "Company Information"
{
    fields
    {
        field(60100; "Wellaway Company"; Boolean)
        {
            Caption = 'Wellaway Company';
            DataClassification = ToBeClassified;
        }
        field(60101; "PMP Company"; Boolean)
        {
            Caption = 'PMP Company';
            DataClassification = ToBeClassified;
        }
        field(60102; "PMP Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60103; "Wellaway Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }

        // YF 06 May 2022
        field(60104; "WhatsApp QR Phone No."; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(60105; "WhatsApp QR Message"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        // YF 06 May 2022
    }
}