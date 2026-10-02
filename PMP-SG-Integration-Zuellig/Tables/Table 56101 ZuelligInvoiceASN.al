table 56101 "Zuellig Invoice ASN Import Log"
{

    fields
    {
        field(1; "Entry No"; BigInteger)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }

        /*
        field(10; "Is Simulation"; Boolean)
        {
            Caption = 'Is Simulation';
        }
        */

        field(20; "PO Number"; Text[20])
        {
            Caption = 'Customer PO Number';
        }

        field(30; "Invoice Date Text"; Text[10])
        {
            Caption = 'Invoice Date (Text)';
        }

        field(35; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }

        field(40; "Invoice Number"; Text[10])
        {
            Caption = 'Zuellig Invoice Number';
        }

        field(50; "Customer Item Code"; Text[20])
        {
            Caption = 'Customer Item Code';
        }

        field(60; "Bill Qty Text"; Text[10])
        {
            Caption = 'Invoice Bill Qty (Text)';
        }

        field(65; "Bill Qty"; Decimal)
        {
            Caption = 'Invoice Bill Qty';
        }

        field(70; "Selling Price Text"; Text[15])
        {
            Caption = 'Invoice Selling Price (Text)';
        }

        field(75; "Selling Price"; Decimal)
        {
            Caption = 'Invoice Selling Price';
        }

        field(80; "Batch Expiry Date Text"; Text[10])
        {
            Caption = 'Batch Expiry Date (Text)';
        }

        field(85; "Batch Expiry Date"; Date)
        {
            Caption = 'Batch Expiry Date';
        }

        field(90; "Batch Number"; Text[50])//RL 04 May - change from text[10] to text[50]
        {
            Caption = 'Batch Number';
        }

        field(100; "Item Description"; Text[100])
        {
            Caption = 'Zuellig Item Description';
        }

        field(110; "Conversion Factor"; Text[10])
        {
            Caption = 'Converstion Factor Text';
        }

        field(115; "Convert. Factor"; Integer)
        {
            Caption = 'Conversion Factor Int';
        }

        field(116; "Conversion Factor Decimal"; Decimal)
        {
            Caption = 'Conversion Factor';
        }

        field(120; UserId; Code[50])
        {
            Caption = 'User ID';
        }

        field(130; "Entry Date Time"; DateTime)
        {
            Caption = 'Entry Date Time';
        }

        field(140; "PO Updated"; Boolean)
        {
            Caption = 'PO Updated';
            DataClassification = ToBeClassified;
        }

        field(150; "Purchase Order No. Updated"; Code[20])
        {
            Caption = 'Purchase Order No. Updated';
            DataClassification = ToBeClassified;
        }
        field(160; "Purchase Line No. Updated"; Integer)
        {
            Caption = 'Purchase Line No. Updated';
            DataClassification = ToBeClassified;
        }

        field(170; "PO Error"; Boolean)
        {
            Caption = 'PO Error';
            DataClassification = ToBeClassified;
        }

        field(180; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

