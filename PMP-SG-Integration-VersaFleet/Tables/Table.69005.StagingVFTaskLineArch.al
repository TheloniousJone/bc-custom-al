table 69005 "Staging VF Task Line Archive"
{

    fields
    {

        field(1; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
        }

        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(20; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
        }

        field(30; "Sales Invoice Line No."; Integer)
        {
            Caption = 'Sales Invoice Line No.';
        }

        field(40; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }

        field(50; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }

        field(60; "Qty"; Decimal)
        {
            Caption = 'Qty';
        }

        field(70; "UOM"; Code[20])
        {
            Caption = 'UOM';
        }

        field(80; "Item Check Method"; Text[50])
        {
            Caption = 'Item Check Method';
        }

        field(90; "Item Unload Check Method"; Text[50])
        {
            Caption = 'Item Unload Check Method';
        }

        field(100; "VF Task ID"; Integer)
        {
            Caption = 'VF Task ID';
        }

        field(110; "VF Task GUID"; Code[50])
        {
            Caption = 'VF Task GUID';
        }

        field(120; "VF Task Item ID"; Integer)
        {
            Caption = 'VF Task Item ID';
        }

        field(130; "VF Line ID"; Integer)
        {
            Caption = 'VF Line ID';
        }

        field(140; "VF Task Completion History ID"; Integer)
        {
            Caption = 'VF Task Completion History ID';
        }

        field(150; "VF Actual Qty Processed"; Decimal)
        {
            Caption = 'VF Actual Qty Processed';
        }

        field(160; "VF Driver Reason"; Text[250])
        {
            Caption = 'VF Driver Reason';
        }

        field(170; "Created"; Boolean)
        {
            Caption = 'Created';
        }

        field(180; "Process Remarks"; Text[150])
        {
            Caption = 'Process Remarks';
        }

        field(190; "Error"; Boolean)
        {
            Caption = 'Error';
        }

        field(200; "Created Timestamp"; DateTime)
        {
            Caption = 'Created Timestamp';
        }

        field(210; "Updated Timestamp"; DateTime)
        {
            Caption = 'Updated Timestamp';
        }

        field(220; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }

        // KP 18 Oct 2023
        field(230; "Qty. Delivered"; Decimal)
        {
            Caption = 'Qty. Delivered';
        }
        field(240; "Qty. Returned"; Decimal)
        {
            Caption = 'Qty. Returned';
            Editable = false;
        }
        // KP 18 Oct 2023
    }

    keys
    {
        key(PK; "Parent Entry No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

