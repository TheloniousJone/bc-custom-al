table 69001 "Staging VF Task Header"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(10; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
        }

        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(30; "Tracking ID"; Text[50])
        {
            Caption = 'Tracking ID';
        }

        field(40; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
        }

        field(50; "Time From Text"; Text[50])
        {
            Caption = 'Time From Text';
        }

        field(60; "Time To Text"; Text[50])
        {
            Caption = 'Time To Text';
        }

        field(70; "Time Type"; Text[50])
        {
            Caption = 'Time Type';
        }

        field(80; "COD"; Decimal)
        {
            Caption = 'COD';
        }

        field(90; "Remarks"; Text[1024])
        {
            Caption = 'Remarks';
        }

        field(100; "Service Time"; Integer)
        {
            Caption = 'Service Time';
        }

        field(110; "Delivery Address Name"; Text[100])
        {
            Caption = 'Delivery Address Name';
        }

        field(120; "Delivery Address Line 1"; Text[100])
        {
            Caption = 'Delivery Address Line 1';
        }

        field(130; "Delivery Address Line 2"; Text[100])
        {
            Caption = 'Delivery Address Line 2';
        }

        field(140; "Delivery Address City"; Text[50])
        {
            Caption = 'Delivery Address City';
        }

        field(150; "Delivery Address Country"; Text[50])
        {
            Caption = 'Delivery Address Country';
        }

        field(160; "Delivery Address Zip"; Text[50])
        {
            Caption = 'Delivery Address Zip';
        }

        field(170; "Delivery Address Email"; Text[150])
        {
            Caption = 'Delivery Address Email';
        }

        field(180; "Delivery Address Contact Name"; Text[100])
        {
            Caption = 'Delivery Address Contact Person';
        }

        field(190; "Delivery Address Contact No."; Text[50])
        {
            Caption = 'Delivery Address Contact No.';
        }

        field(200; "Driver Tag"; Text[50])
        {
            Caption = 'Driver Tag';
        }

        field(210; "Vehicle Tag"; Text[50])
        {
            Caption = 'Vehicle Tag';
        }

        field(220; "VF Task ID"; Integer)
        {
            Caption = 'VF Task ID';
        }

        field(230; "VF Task GUID"; Code[50])
        {
            Caption = 'VF Task GUID';
        }

        field(240; "VF Task State"; Text[50])
        {
            Caption = 'VF Task State';
        }

        field(250; "VF Task State Updated"; Text[100])
        {
            Caption = 'VF Task State Updated';
        }

        field(260; "VF Is Partial Success"; Boolean)
        {
            Caption = 'VF Is Partial Success';
        }

        field(270; "VF Driver Notes"; Text[250])
        {
            Caption = 'VF Driver Notes';
        }

        field(280; "VF Job ID"; Integer)
        {
            Caption = 'VF Job ID';
        }

        field(290; "VF Job GUID"; Code[50])
        {
            Caption = 'VF Job GUID';
        }

        field(300; "Created"; Boolean)
        {
            Caption = 'Created';
        }

        field(310; "Process Remarks"; Text[150])
        {
            Caption = 'Process Remarks';
        }

        field(320; "Error"; Boolean)
        {
            Caption = 'Error';
        }

        field(330; "Created Timestamp"; DateTime)
        {
            Caption = 'Created Timestamp';
        }

        field(340; "Updated Timestamp"; DateTime)
        {
            Caption = 'Updated Timestamp';
        }

        field(350; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }

        field(360; "VF Delivery Address Id"; Integer)
        {
            Caption = 'VF Delivery Address Id';
        }

        field(370; "Internal Job Tracking No."; Integer)
        {
            Caption = 'Internal Job Tracking No.';
        }

        // YF 20 Jun 2022
        field(380; "Delivered Remarks"; Text[1024])
        {
            Caption = 'Delivered Remarks';
        }

        field(390; "Delivered Driver Tag"; Text[50])
        {
            Caption = 'Delivered Driver Tag';
        }

        field(400; "Delivered Date Text"; Text[50])
        {
            Caption = 'Delivered Date Text';
        }

        field(410; "Delivered Date"; Date)
        {
            Caption = 'Delivered Date';
        }

        field(420; "Latest Failure Reason"; Text[1024])
        {
            Caption = 'Latest Failure Reason';
        }

        field(430; "Force Delivery Status Check"; Boolean)
        {
            Caption = 'Force Delivery Status Check';
        }
        // YF 20 Jun 2022

        // YF 27 Jun 2022
        field(440; "Source Delivery Charge"; Code[20])
        {
            Caption = 'Delivery Charge (Source)';
        }

        field(450; "Delivered Delivery Charge"; Code[20])
        {
            Caption = 'Delivery Charge (Delivered)';
        }
        // YF 27 Jun 2022

        // YF 21 Jul 2022
        field(460; "Source Document Type"; Enum "Source Document Type")
        {
            Caption = 'Source Document Type';
            InitValue = " ";
        }
        // YF 21 Jul 2022

        // YF 14 Sep 2022
        field(470; "Response Message"; Text[2048])
        {
            Caption = 'Response Message';
        }
        // YF 14 Sep 2022

        // YF 05 Dec 2022
        field(480; "VF Task State Type"; Option)
        {
            Caption = 'VF Task State Type';
            OptionCaption = ' ,unassigned, assigned, acknowledged, started ,collected, arrived, successful';
            OptionMembers = " ",unassigned,assigned,acknowledged,started,collected,arrived,successful;
        }
        // YF 05 Dec 2022
        // KP 18 Oct 2023
        field(490; "Return Order No."; Code[20])
        {
            Caption = 'Return Order No.';
            //Editable = false;
        }
        field(500; "Return Order Created"; Boolean)
        {
            Caption = 'Return Order Created';
            //Editable = false;
        }
        // KP 18 Oct 2023
        field(510; "Current Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(520; "Todays Drop"; Integer)
        {
            CalcFormula = Count("Staging VF Task Header" WHERE("Posting Date" = FIELD("Current Date Filter")));
            Caption = 'Todays Drop';
            Editable = false;
            FieldClass = FlowField;
        }
        field(530; "Completed Task"; Integer)
        {
            CalcFormula = Count("Staging VF Task Header" WHERE("Posting Date" = FIELD("Current Date Filter"),
                                                                "VF Task State Type" = const(successful)));
            Caption = 'Completed Task';
            Editable = false;
            FieldClass = FlowField;
        }
        field(540; "Pending Task"; Integer)
        {
            CalcFormula = Count("Staging VF Task Header" WHERE("Posting Date" = filter('01/10/2023..'),
                                                                Created = const(true),
                                                                "VF Task State Type" = filter(<> successful)));
            Caption = 'Pending Task';
            Editable = false;
            FieldClass = FlowField;
        }
        field(550; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
        }
        field(560; "Customer Group"; Code[20])
        {
            Caption = 'Customer Group';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.") { }
        key(AK1; "Posting Date") { } // YF 04 Dec 2023 // Added to relieve query load as requested by DX
        key(AK2; "Posting Date", "VF Task State Type") { } // YF 04 Dec 2023 // Added to relieve query load as requested by DX
        key(AK3; Created, "Posting Date", "VF Task ID") { }
    }

    fieldgroups
    {
    }
}

