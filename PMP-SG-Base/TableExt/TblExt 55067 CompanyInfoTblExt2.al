tableextension 55067 CompanyInfoTblExt2 extends "Company Information"
{
    fields
    {
        field(55000; "Paynow QR"; Blob)
        {
            Caption = 'Paynow QR';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        // LK180523
        field(55001; "PMP Picture"; Blob)
        {
            Caption = 'PMP Picture';
            SubType = Bitmap;
        }
        field(55002; "Bank Address"; Text[100])
        {
            Caption = 'Bank Address';
        }
        field(55003; "Bank Code"; Text[20])
        {
            Caption = 'Bank Code';
        }
        field(55004; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
        }
        field(55005; "Beneficiary Address"; Text[100])
        {
            Caption = 'Beneficiary Address';
        }
        // LK180523
        field(55006; I9G_ArdencePharma; Boolean)
        {
            Caption = 'Ardence Pharma';
        }
    }
}
