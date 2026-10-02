table 60105 "Incoming Wellaway PO Line"
{
    Caption = 'Incoming Wellaway PO Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Purchase Order ID"; Code[20])
        {
            Caption = 'Purchase Order ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Purchase Line No"; Integer)
        {
            Caption = 'Purchase Line No';
            DataClassification = ToBeClassified;
        }
        field(3; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = ToBeClassified;
        }
        field(4; "Product Name"; Text[100]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Product Name ';
            DataClassification = ToBeClassified;
        }
        field(5; "Quantity Ordered"; Decimal)
        {
            Caption = 'Quantity Ordered';
            DataClassification = ToBeClassified;
        }
        field(6; "Bonus Quantity"; Decimal) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Bonus Quantity ';
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(8; "UOM Code"; Code[10])
        {
            Caption = 'UOM Code';
            DataClassification = ToBeClassified;
        }
        field(9; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Instruction of Use"; Text[250])
        {
            Caption = 'Instruction of Use';
            DataClassification = ToBeClassified;
        }
        field(11; "Precautions"; Text[250]) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Precautions ';
            DataClassification = ToBeClassified;
        }
        field(12; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(13; POLineTimestamp; DateTime)
        {
            Caption = 'POLineTimestamp';
            DataClassification = ToBeClassified;
        }
        field(14; "SO Created"; Boolean)
        {
            Caption = 'SO Created';
            DataClassification = ToBeClassified;
        }
        field(15; "SO Error"; Boolean) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'SO Error ';
            DataClassification = ToBeClassified;
        }
        field(16; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }
        field(17; "Sales Line No."; Integer) // YF 08 Sep 2023 // remove trailing spaces
        {
            Caption = 'Sales Line No. ';
            DataClassification = ToBeClassified;
        }
        field(20; "Process Remarks"; text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Purchase Order ID", "Purchase Line No")
        {
            Clustered = true;
        }
    }

}
