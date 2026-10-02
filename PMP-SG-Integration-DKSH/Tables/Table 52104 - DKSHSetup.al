table 52104 "DKSH Integration Setup"
{

    fields
    {
        field(1; "Primary Key"; Integer) { }

        field(10; "BC Vendor Code"; Code[20])
        {
            Caption = 'DKSH BC Vendor Code';
            TableRelation = Vendor;
        }

        field(20; "DKSH Buyer Code"; Code[20])
        {
            Caption = 'DKSH Buyer Code';
        }

        field(30; "DKSH Buyer Given Supplier Code"; Code[20])
        {
            Caption = 'DKSH Buyer Given Supplier Code';
        }

        field(40; "PO Document Status"; Code[20])
        {
            Caption = 'Document Status';
            InitValue = 'COPY';
        }

        field(50; "PO Type of Order"; Code[20])
        {
            Caption = 'Type of Order';
            InitValue = 'MULTI_SHIP';
        }

        field(60; "PO Specs Version"; Code[10])
        {
            Caption = 'Specification Version';
            InitValue = '1.1';
        }

        field(70; "PO Movement Data Type"; Code[20])
        {
            Caption = 'Movement Data Type';
            InitValue = 'REQUESTED_DELIVERY';
        }

        field(80; "PO Entity Type"; Code[20])
        {
            Caption = 'Entity Type';
            InitValue = 'ORDER';
        }

        field(90; "PO Role of Buyer"; Code[20])
        {
            Caption = 'Role of Buyer';
            InitValue = 'BUYER';
        }

        /*
        field(95; "PO Seller Code From Buyer"; Code[20])
        {
            Caption = 'Code of Seller Given By Buyer';
        }
        */

        field(100; "PO Seller Alt. Party ID"; Code[50])
        {
            Caption = 'Seller Alternate Party ID';
            InitValue = 'BUYER_ASSIGNED_IDENTIFIER_FOR_PARTY';
        }

        field(110; "PO Role of Seller"; Code[20])
        {
            Caption = 'Role of Seller';
            InitValue = 'SUPPLIER';
        }

        field(120; "PO Delivery Party ID Type"; Code[20])
        {
            Caption = 'Delivery Party ID Type';
            InitValue = 'SHIP_TO';
        }

        field(125; "PO Deliver to Location ID"; Code[20])
        {
            Caption = 'Deliver to Location Identifier';
        }

        field(130; "PO Delivery Alt. Party ID"; Code[50])
        {
            Caption = 'Delivery Alternate Party ID';
            InitValue = 'BUYER_ASSIGNED_IDENTIFIER_FOR_PARTY';
        }

        field(140; "PO Role of Delivery"; Code[20])
        {
            Caption = 'Role of Delivery';
            InitValue = 'CORPORATE_IDENTITY';
        }

        field(150; "PO Allowance Level Type"; Code[20])
        {
            Caption = 'Type of Allowance Level';
            InitValue = 'ALLOWANCE_GLOBAL';
        }

        field(160; "PO Allow Or Charge"; Code[20])
        {
            Caption = 'Allowance or Charge';
            InitValue = 'ALLOWANCE';
        }

        field(170; "PO Allowance Settle Type"; Code[20])
        {
            Caption = 'Allowance Settlement Type';
            InitValue = 'OFF_INVOICE';
        }

        field(180; "PO Buyer Item Identifier"; Code[20])
        {
            Caption = 'Buyer Item Identifier';
            InitValue = 'BUYER_ITEM_CODE';
        }

        field(190; "PO Seller Item Identifier"; Code[20])
        {
            Caption = 'Seller Item Identifier';
            InitValue = 'SUPPLIER_ITEM_CODE';
        }

        field(200; "PO Location Type Attribute"; Code[50])
        {
            Caption = 'Location Type Attribute';
            InitValue = 'BUYER_ASSIGNED_IDENTIFIER_FOR_PARTY';
        }

        field(210; "PO Location ID Attribute"; Code[50])
        {
            Caption = 'Location ID Attribute';
            InitValue = 'BUYER_ASSIGNED_IDENTIFIER_FOR_PARTY';
        }

        field(220; "PO Role of PO Line Delivery"; Code[20])
        {
            Caption = 'Role of PO Line Delivery';
            InitValue = 'SHIP_TO';
        }

        // YF 17 Nov 2022
        field(230; "PO EDI Email Address"; Text[150])
        {
            Caption = 'PO EDI Email Address';
        }
        // YF 17 Nov 2022
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

