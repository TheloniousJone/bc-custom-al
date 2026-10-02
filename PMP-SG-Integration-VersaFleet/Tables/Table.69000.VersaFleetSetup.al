table 69000 "VersaFleet Integration Setup"
{

    fields
    {
        field(1; "Primary Key"; Integer)
        {
        }

        field(10; "Client ID"; Text[150])
        {
            Caption = 'Client ID';
        }

        field(20; "Client Secret"; Text[150])
        {
            Caption = 'Client Secret';
            ExtendedDatatype = Masked;
        }

        field(30; "API Parent URL"; Text[150])
        {
            Caption = 'API Parent URL';
        }

        field(40; "Default Job Service Time"; Integer)
        {
            Caption = 'Default Job Service Time (sec)';
            InitValue = 2700;
        }

        field(50; "Default Task Service Time"; Integer)
        {
            Caption = 'Default Task Service Time (sec)';
            InitValue = 900;
        }

        field(60; "PMP VersaFleet Customer ID"; Text[20])
        {
            Caption = 'PMP VersaFleet Customer ID';
        }

        // PMP Warehouse Location Info
        field(70; "PMP-WH Name"; Text[100])
        {
            Caption = 'Name';
        }

        field(80; "PMP-WH Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }

        field(90; "PMP-WH Address"; Text[100])
        {
            Caption = 'Address';
        }

        field(100; "PMP-WH Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }

        field(110; "PMP-WH City"; Text[30])
        {
            Caption = 'City';
            InitValue = 'Singapore City';
        }

        field(120; "PMP-WH Country"; Text[30])
        {
            Caption = 'Country';
            InitValue = 'Singapore';
        }

        field(130; "PMP-WH Post Code/Zip"; Code[20])
        {
            Caption = 'Post Code/Zip';
        }

        field(140; "PMP-WH E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("PMP-WH E-Mail");
            end;
        }

        field(150; "PMP-WH Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
        }

        field(160; "PMP-WH Contact Number"; Text[30])
        {
            Caption = 'Contact Number';
            ExtendedDatatype = PhoneNo;
        }
        // PMP Warehouse Location Info

        /*
        field(80; "Delivery Job Sync Last Run"; DateTime)
        {
            Caption = 'Delivery Job Sync Last Run';
        }
        */

        // Default Check Method
        field(170; "Item Check Method"; Option)
        {
            Caption = 'Default Item Check Method';
            DataClassification = ToBeClassified;
            OptionMembers = manual,scanner;
            InitValue = manual;
        }

        field(180; "Item Unload Check Method"; Option)
        {
            Caption = 'Default Item Unload Check Method';
            DataClassification = ToBeClassified;
            OptionMembers = manual,scanner;
            InitValue = manual;
        }

        // YF 27 Jun 2022
        field(190; "Delivery Charge Field Group ID"; Integer)
        {
            Caption = 'Custom Field Group ID';
            DataClassification = ToBeClassified;
            InitValue = 545;
        }

        field(200; "Delivery Charge Field Descr ID"; Integer)
        {
            Caption = 'Delivery Charge Field Descr ID';
            DataClassification = ToBeClassified;
            InitValue = 2559;
        }
        // YF 27 Jun 2022

        // YF 21 Jul 2022
        field(210; "Def. Item for MDC"; Code[20])
        {
            Caption = 'Default Item for Misc Delivery Charge';
            TableRelation = Item."No.";
            InitValue = 'CHARGES';
        }
        // YF 21 Jul 2022

        // YF 14 Sep 2022
        field(220; "Debug Mode"; Boolean)
        {
            Caption = 'Debug Mode';
        }
        // YF 14 Sep 2022

        // YF 21 Feb 2023
        field(230; "Operating Hours Field Descr ID"; Integer)
        {
            Caption = 'Operating Hours Field Descr ID';
            DataClassification = ToBeClassified;
            InitValue = 2807;
        }
        // YF 21 Feb 2023
    }

    keys
    {
        key(PK; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

