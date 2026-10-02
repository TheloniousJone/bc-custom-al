table 56102 "Outgoing ZP PO Header"
{

    fields
    {
        // Purchase Order / Purchase Return Order No.
        field(1; "No."; Code[15])
        {
            Caption = 'No.';
        }

        // Purchase Document Type - Blank for Normal and R for Return
        field(10; "Document Type Code"; Code[1])
        {
            Caption = 'Purchase Document Type';
        }

        // ZP Customer ID
        field(20; "ZP Customer ID"; Code[10])
        {
            Caption = 'ZP Customer ID';
        }

        // Record Type - Default H for Header
        field(30; "Record Type"; Code[1])
        {
            Caption = 'Record Type';
            InitValue = 'H';
        }

        // Location/Store Code
        field(40; "Location Store Code"; Code[10])
        {
            Caption = 'Location/Store Code';
        }

        // Tender No.
        field(50; "Tender No."; Code[15])
        {
            Caption = 'Tender No.';
        }

        // Contract No.
        field(60; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }

        // Order Date in YYYYMMDD
        field(70; "Order Date"; Text[8])
        {
            Caption = 'Order Date';
        }

        // Delivery Date in YYYYMMDD
        field(80; "Delivery Date"; Text[8])
        {
            Caption = 'Delivery Date';
        }

        // Special Instruction
        field(90; "Special Instruction"; Text[60])
        {
            Caption = 'Special Instruction';
        }

        // Total Line Items
        field(100; "Total Line Items"; Integer)
        {
            Caption = 'Total Line Items';
        }

        // Sales Order No.
        field(110; "Sales Order No."; Code[12])
        {
            Caption = 'Sales Order No.';
        }

        // Processed - flag to be updated by middleware
        field(120; Processed; Boolean)
        {
            Caption = 'Processed';

            trigger OnValidate()
            begin
                if Processed then
                    "Processed Timestamp" := CurrentDateTime;
            end;
        }

        // Processed Timestamp
        field(130; "Processed Timestamp"; DateTime)
        {
            Caption = 'Processed Timestamp';
        }

        // Has Error Flag - flag to be updated by middleware
        field(140; "Has Error"; Boolean)
        {
            Caption = 'Has Error';

            /*
            trigger OnValidate()
            begin 
                if "Has Error" then
                    "Processed Timestamp" := CurrentDateTime;
            end;
            */
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

