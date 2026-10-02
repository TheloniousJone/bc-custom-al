table 90000 "Chain PO Header"
{
    Caption = 'Chain PO Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;

        }
        field(2; Chain; Code[10])
        {
            Caption = 'Chain';
            DataClassification = ToBeClassified;
        }
        field(3; "Document Type"; Code[10])
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(4; "Invoice Number"; Code[20]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Invoice Number ';
            DataClassification = ToBeClassified;
        }
        field(5; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            DataClassification = ToBeClassified;
        }
        field(6; "PO Number"; Code[20])
        {
            Caption = 'PO Number';
            DataClassification = ToBeClassified;
        }
        field(7; "PO Date"; Date)
        {
            Caption = 'PO Date';
            DataClassification = ToBeClassified;
        }
        field(8; "DO Number"; Code[20]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'DO Number ';
            DataClassification = ToBeClassified;
        }
        field(9; "DO Date"; Date)
        {
            Caption = 'DO Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Delivery Start Date"; Date)
        {
            Caption = 'Delivery Start Date';
            DataClassification = ToBeClassified;
        }
        field(11; "Delivery End Date"; Date)
        {
            Caption = 'Delivery End Date';
            DataClassification = ToBeClassified;
        }
        field(12; "Buyer Code"; Code[20])
        {
            Caption = 'Buyer Code';
            DataClassification = ToBeClassified;
        }
        field(13; "Buyer Name"; Text[100])
        {
            Caption = 'Buyer Name';
            DataClassification = ToBeClassified;
        }
        field(14; "Supplier Code"; Code[20])
        {
            Caption = 'Supplier Code';
            DataClassification = ToBeClassified;
        }
        field(15; "Supplier Name"; Text[100])
        {
            Caption = 'Supplier Name';
            DataClassification = ToBeClassified;
        }
        field(16; "Line Item Count"; Integer) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Line Item Count ';
            DataClassification = ToBeClassified;
        }
        field(17; "Invoice Amount Without Tax"; Decimal)
        {
            Caption = 'Invoice Amount Without Tax';
            DataClassification = ToBeClassified;
        }
        field(18; "Invoice Amount With Tax"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Invoice Amount With Tax ';
            DataClassification = ToBeClassified;
        }
        field(19; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            DataClassification = ToBeClassified;
        }
        field(20; "Tax Percent"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Tax Percent ';
            DataClassification = ToBeClassified;
        }
        field(21; "Store Code"; Code[20])
        {
            Caption = 'Store Code';
            DataClassification = ToBeClassified;
        }
        field(22; "Store Name"; Text[100])
        {
            Caption = 'Store Name';
            DataClassification = ToBeClassified;
        }
        field(23; "Store Delivery Quantity"; Decimal)
        {
            Caption = 'Store Delivery Quantity';
            DataClassification = ToBeClassified;
        }
        field(24; "Store FOC Quantity"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Store FOC Quantity ';
            DataClassification = ToBeClassified;
        }
        field(25; ChainPOHeaderTimestamp; DateTime)
        {
            Caption = 'ChainPOHeaderTimestamp';
            DataClassification = ToBeClassified;
        }
        field(26; "SO Created"; Boolean)
        {
            Caption = 'SO Created';
            DataClassification = ToBeClassified;
        }
        field(27; "SO Error"; Boolean)
        {
            Caption = 'SO Error';
            DataClassification = ToBeClassified;
        }
        field(28; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(29; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }
        field(30; "Ready to Process SO"; Boolean)
        {
            Caption = 'Ready to Process SO';
            DataClassification = ToBeClassified;
        }
        field(31; "Push to Open SO"; Boolean)
        {
            Caption = 'Push to Open SO';
            DataClassification = ToBeClassified;
        }
        field(32; "Last Error Message"; Text[250])
        {
            Caption = 'Last Error Message';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.", "PO Number")
        {
            Clustered = true;
        }
    }
}
