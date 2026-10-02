table 90001 "Chain PO Line"
{
    Caption = 'Chain PO Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "PO Entry No."; Integer)
        {
            Caption = 'PO Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "PO Number"; Code[20])
        {
            Caption = 'PO Number';
            DataClassification = ToBeClassified;
        }
        field(3; "Item Line No."; Integer)
        {
            Caption = 'Item Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Buyer Item Code"; Code[20]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Buyer Item Code ';
            DataClassification = ToBeClassified;
        }
        field(5; "Supplier Item Code"; Code[20]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Supplier Item Code ';
            DataClassification = ToBeClassified;
        }
        field(6; Barcode; Text[100])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
        }
        field(7; "Item Description"; Text[100]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Item Description ';
            DataClassification = ToBeClassified;
        }
        field(8; UOM; Code[10])
        {
            Caption = 'UOM';
            DataClassification = ToBeClassified;
        }
        field(9; "Pack Size"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Pack Size ';
            DataClassification = ToBeClassified;
        }
        field(10; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(11; "Order Quantity"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Order Quantity ';
            DataClassification = ToBeClassified;
        }
        field(12; "Invoice Quantity"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Invoice Quantity ';
            DataClassification = ToBeClassified;
        }
        field(13; "FOC Quantity"; Decimal)
        {
            Caption = 'FOC Quantity';
            DataClassification = ToBeClassified;
        }
        field(14; "Line Item Total"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Line Item Total Amount';
            DataClassification = ToBeClassified;
        }
        field(15; ChainPOLineTimestamp; DateTime)
        {
            Caption = 'ChainPOLineTimestamp';
            DataClassification = ToBeClassified;
        }
        field(16; "SO Created"; Boolean) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'SO Created ';
            DataClassification = ToBeClassified;
        }
        field(17; "SO Error"; Boolean)
        {
            Caption = 'SO Error';
            DataClassification = ToBeClassified;
        }
        field(18; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(19; "Sales Line No."; Integer)
        {
            Caption = 'Sales Line No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Total Discount Amount"; Decimal)
        {
            Caption = 'Line Item Total Discount Amount';
        }
        field(21; "Total Discount Percentage"; Decimal)
        {
            Caption = 'Line Item Total Discount Percentage';
        }
        field(22; "Total Amount After Discount"; Decimal)
        {
            Caption = 'Total Amount After Discount';
        }
        field(29; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }
        field(30; "Last Error Message"; Text[250])
        {
            Caption = 'Last Error Message';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "PO Entry No.", "PO Number", "Item Line No.")
        {
            Clustered = true;
        }
    }

}
