table 69003 "VF Job Tracking"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(10; "Job Type"; Text[50])
        {
            Caption = 'Job Type';
        }

        field(20; Remarks; Text[500])
        {
            Caption = 'Remarks';
        }

        field(30; "Customer ID"; Integer)
        {
            Caption = 'Customer ID';
        }

        field(40; "Base Task Time From Text"; Text[50])
        {
            Caption = 'Base Task Time From Text';
        }

        field(50; "Base Task Time To Text"; Text[50])
        {
            Caption = 'Base Task Time To Text';
        }

        field(60; "Base Task Time Type"; Text[50])
        {
            Caption = 'Base Task Time Type';
        }

        field(70; "Base Task Service Time"; Integer)
        {
            Caption = 'Base Task Service Time';
        }

        field(80; "PMP VersaFleet Customer ID"; Text[20])
        {
            Caption = 'PMP VersaFleet Customer ID';
        }

        // PMP Warehouse Location Info
        field(90; "PMP-WH Name"; Text[100])
        {
            Caption = 'Name';
        }

        field(100; "PMP-WH Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }

        field(110; "PMP-WH Address"; Text[100])
        {
            Caption = 'Address';
        }

        field(120; "PMP-WH Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }

        field(130; "PMP-WH City"; Text[30])
        {
            Caption = 'City';
            InitValue = 'Singapore City';
        }

        field(140; "PMP-WH Country"; Text[30])
        {
            Caption = 'Country';
            InitValue = 'Singapore';
        }

        field(150; "PMP-WH Post Code/Zip"; Code[20])
        {
            Caption = 'Post Code/Zip';
        }

        field(160; "PMP-WH E-Mail"; Text[80])
        {
            Caption = 'Email';
        }

        field(170; "PMP-WH Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
        }

        field(180; "PMP-WH Contact Number"; Text[30])
        {
            Caption = 'Contact Number';
        }
        // PMP Warehouse Location Info

        field(190; "VF Job ID"; Integer)
        {
            Caption = 'VF Job ID';
        }

        field(200; "VF Job GUID"; Text[50])
        {
            Caption = 'VF Job GUID';
        }

        field(210; "VF Job State"; Text[50])
        {
            Caption = 'VF Job State';
        }

        field(220; "VF Job Archived"; Boolean)
        {
            Caption = 'VF Job Archived';
        }

        field(230; "VF Task ID"; Integer)
        {
            Caption = 'VF Task ID';
        }

        field(240; "VF Task GUID"; Text[50])
        {
            Caption = 'VF Task GUID';
        }

        field(250; "VF Task State"; Text[50])
        {
            Caption = 'VF Task State';
        }

        field(260; "Base Job Service Time"; Integer)
        {
            Caption = 'Base Job Service Time';
        }

    }

    keys
    {
        key(PK; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

