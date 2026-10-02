tableextension 70304 CompanyInformationTableExt extends "Company Information"
{
    fields
    {
        field(70000; "I9G_DocumentRequired"; Text[200])
        {
            Caption = 'Document Required';
        }
        field(70002; "I9G_Paynow"; Code[50])
        {
            Caption = 'Paynow';
        }
        field(70003; "I9G_BankCode"; Code[20])
        {
            Caption = 'Bank Code';
        }
        field(70004; "I9G_QRCode"; Blob)
        {
            Caption = 'QR Code';
            Subtype = Bitmap;
        }
        field(70005; "I9G_BankAddress"; Text[50])
        {
            Caption = 'Bank Address';
        }
        field(71999; "I9G_Novem"; Boolean)
        {
            Caption = 'Novem';
        }
    }
}