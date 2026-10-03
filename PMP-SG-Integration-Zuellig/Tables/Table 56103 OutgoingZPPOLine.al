table 56103 "Outgoing ZP PO Line"
{

    fields
    {
        // Purchase Order / Purchase Return Order No.
        field(1; "Document No."; Code[15])
        {
            Caption = 'No.';
        }

        field(10; "Document Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        // Purchase Document Type - Blank for Normal and R for Return
        field(20; "Document Type Code"; Code[1])
        {
            Caption = 'Purchase Document Type';
        }

        // Record Type - Default D for Detail
        field(30; "Record Type"; Code[1])
        {
            Caption = 'Record Type';
            InitValue = 'D';
        }

        // Customer Item Code
        field(40; "Customer Item Code"; Code[20])
        {
            Caption = 'Customer Item Code';
        }

        // Customer Item Description
        field(50; "Customer Item Descr"; Text[80])
        {
            Caption = 'Customer Item Descr';
        }

        // Customer Item UOM
        field(60; "Customer Item UOM"; Code[10])
        {
            Caption = 'Customer Item UOM';
        }

        // ZP Item Code
        field(70; "ZP Item Code"; Code[20])
        {
            Caption = 'ZP Item Code';
        }

        // Commercial Qty
        field(80; "Commercial Qty"; Text[8])
        {
            Caption = 'Commercial Qty';
        }

        // Unit Price
        field(90; "Unit Price"; Text[13])
        {
            Caption = 'Unit Price';
        }

        // Bonus Item 1 - Customer Item Code
        field(100; "Bonus 1 Cust Item Code"; Code[20])
        {
            Caption = 'Bonus Item 1 - Customer Item Code';
        }

        // Bonus Item 1 - ZP Item Code
        field(110; "Bonus 1 ZP Item Code"; Code[20])
        {
            Caption = 'Bonus Item 1 - ZP Item Code';
        }

        // Bonus Item 1 - Qty
        field(120; "Bonus 1 Qty"; Text[8])
        {
            Caption = 'Bonus Item 1 - Qty';
        }

        // Bonus Item 2 - Customer Item Code
        field(130; "Bonus 2 Cust Item Code"; Code[20])
        {
            Caption = 'Bonus Item 2 - Customer Item Code';
        }

        // Bonus Item 2 - ZP Item Code
        field(140; "Bonus 2 ZP Item Code"; Code[20])
        {
            Caption = 'Bonus Item 2 - ZP Item Code';
        }

        // Bonus Item 2 - Qty
        field(150; "Bonus 2 Qty"; Text[8])
        {
            Caption = 'Bonus Item 2 - Qty';
        }

        // Bonus Item 3 - Customer Item Code
        field(160; "Bonus 3 Cust Item Code"; Code[20])
        {
            Caption = 'Bonus Item 3 - Customer Item Code';
        }

        // Bonus Item 3 - ZP Item Code
        field(170; "Bonus 3 ZP Item Code"; Code[20])
        {
            Caption = 'Bonus Item 3 - ZP Item Code';
        }

        // Bonus Item 3 - Qty
        field(180; "Bonus 3 Qty"; Text[8])
        {
            Caption = 'Bonus Item 3 - Qty';
        }

        // Processed - flag to be updated by middleware
        field(190; Processed; Boolean)
        {
            Caption = 'Processed';

            trigger OnValidate()
            begin
                if Processed then
                    "Processed Timestamp" := CurrentDateTime;
            end;
        }

        // Processed Timestamp
        field(200; "Processed Timestamp"; DateTime)
        {
            Caption = 'Processed Timestamp';
        }

        // Has Error Flag - flag to be updated by middleware
        field(210; "Has Error"; Boolean)
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
        key(PK; "Document No.", "Document Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

