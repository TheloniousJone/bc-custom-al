table 60104 "Incoming Wellaway PO Header"
{
    Caption = 'Incoming Wellaway PO Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Purchase Order ID"; Code[20])
        {
            Caption = 'Purchase Order ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Physical PO ID"; Text[50])
        {
            Caption = 'Physical PO ID';
            DataClassification = ToBeClassified;
        }
        field(4; "Customer Code"; Code[20])
        {
            Caption = 'Patient Code';
            DataClassification = ToBeClassified;
        }
        field(5; "Customer Name"; Text[250])
        {
            Caption = 'Patient Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Login ID"; Text[50])
        {
            Caption = 'Login ID';
            DataClassification = ToBeClassified;
        }
        field(7; "Order by"; Text[100]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Order by ';
            DataClassification = ToBeClassified;
        }
        field(8; "Currency"; Code[10]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Currency ';
            DataClassification = ToBeClassified;
        }
        field(9; "Terms of Payment"; Code[10]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Terms of Payment ';
            DataClassification = ToBeClassified;
        }
        field(10; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
            DataClassification = ToBeClassified;
        }
        field(11; "Street Name"; Text[100])
        {
            Caption = 'Street Name';
            DataClassification = ToBeClassified;
        }
        field(12; "Country/Region"; Text[30])
        {
            Caption = 'Country/Region';
            DataClassification = ToBeClassified;
        }
        field(13; "Zip Code"; Text[20])
        {
            Caption = 'Zip Code';
            DataClassification = ToBeClassified;
        }
        field(14; Email; Text[80])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
        }
        field(15; Telephone; Text[30])
        {
            Caption = 'Telephone';
            DataClassification = ToBeClassified;
        }
        field(16; Fax; Text[30])
        {
            Caption = 'Fax';
            DataClassification = ToBeClassified;
        }
        field(17; "Online Discount Amount"; Decimal)
        {
            Caption = 'Online Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(18; "Online Discount Percent"; Decimal)
        {
            Caption = 'Online Discount Percent';
            DataClassification = ToBeClassified;
        }
        field(19; "Remarks 1"; Text[500]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Remarks 1 ';
            DataClassification = ToBeClassified;
        }
        field(20; "Order Date"; Date) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Order Date ';
            DataClassification = ToBeClassified;
        }
        field(21; "Patient Date of Birth"; Date)
        {
            Caption = 'Patient Date of Birth';
            DataClassification = ToBeClassified;
        }
        field(22; "Patient Gender"; Option)
        {
            Caption = 'Patient Gender';
            OptionMembers = Male,Female;
            DataClassification = ToBeClassified;
        }
        field(23; "Patient NRIC/FIN/Passport No."; Code[20])
        {
            Caption = 'Patient NRIC/FIN/Passport No.';
            DataClassification = ToBeClassified;
        }
        field(24; "Drug Allergies"; Text[250]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Drug Allergies ';
            DataClassification = ToBeClassified;
        }
        field(25; "Clinic ID"; Code[20])
        {
            Caption = 'Clinic ID';
            DataClassification = ToBeClassified;
        }
        field(26; "Clinic Full Name"; Text[100])
        {
            Caption = 'Clinic Full Name';
            DataClassification = ToBeClassified;
        }
        field(27; "Clinic Branch"; Text[100])
        {
            Caption = 'Clinic Branch';
            DataClassification = ToBeClassified;
        }
        field(28; "Clinic Address Line 1"; Text[100]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Clinic Address Line 1 ';
            DataClassification = ToBeClassified;
        }
        field(29; "Clinic Address Line 2"; Text[100])
        {
            Caption = 'Clinic Address Line 2';
            DataClassification = ToBeClassified;
        }
        field(30; "Clinic Postal Code"; Text[10])
        {
            Caption = 'Clinic Postal Code';
            DataClassification = ToBeClassified;
        }
        field(31; "Clinic Country"; Text[50]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Clinic Country ';
            DataClassification = ToBeClassified;
        }
        field(32; "Doctor Full Name"; Text[100])
        {
            Caption = 'Doctor Full Name';
            DataClassification = ToBeClassified;
        }
        field(33; "Doctor Mobile Country Code"; Text[10])
        {
            Caption = 'Doctor Mobile Country Code';
            DataClassification = ToBeClassified;
        }
        field(34; "Doctor Mobile No."; Text[30])
        {
            Caption = 'Doctor Mobile No.';
            DataClassification = ToBeClassified;
        }
        field(35; "Remarks 2"; Text[100])
        {
            Caption = 'Remarks 2';
            DataClassification = ToBeClassified;
        }
        field(36; POHeaderTimestamp; DateTime)
        {
            Caption = 'Timestamp';
            DataClassification = ToBeClassified;
        }
        field(37; "SO Created"; Boolean)
        {
            Caption = 'SO Created';
            DataClassification = ToBeClassified;
        }
        field(38; "SO Error"; Boolean) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'SO Error ';
            DataClassification = ToBeClassified;
        }
        field(39; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(40; "Process Remarks"; text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Purchase Order ID")
        {
            Clustered = true;
        }
    }


    trigger OnDelete()
    var
        myInt: Integer;
        WellLines: Record "Incoming Wellaway PO Line";
    begin
        WellLines.Reset();
        WellLines.SetRange("Purchase Order ID", Rec."Purchase Order ID");
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not WellLines.IsEmpty then
            WellLines.DeleteAll(true);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
    end;
}
