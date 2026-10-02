table 55062 "SalesTradeAgreementStagingArch"
{
    Caption = 'Sales Trade Agreement Staging Archives';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }

        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            DataClassification = ToBeClassified;
        }

        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }

        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }

        field(5; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            MinValue = 0;
        }

        field(6; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
            DataClassification = ToBeClassified;
        }

        field(7; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc';
            DataClassification = ToBeClassified;
        }

        field(8; "Line Discount %"; Integer)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
        }

        field(9; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionMembers = "Customer","Customer Price Group","All Customers","Campaign";
        }

        field(10; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DataClassification = ToBeClassified;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }

        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;
        }

        field(12; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            DataClassification = ToBeClassified;
        }

        field(13; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            DataClassification = ToBeClassified;
        }

        field(14; "Allow Line Disc."; Boolean)
        {
            DataClassification = ToBeClassified;
            // InitValue = true;
        }

        field(15; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }

        field(16; "FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'FOC Qty';
        }

        field(17; Status; Enum "Price Status")
        {
            DataClassification = ToBeClassified;
        }

        field(55001; "RecRefID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(18; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(19; I9G_LineStatus; Enum TradeAgreementLineStatus)
        {
            Caption = 'Line Status';
        }

        // Primary Key
        field(40; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(50; "Entry Timestamp"; DateTime)
        {
            Caption = 'Entry Timestamp';
            DataClassification = ToBeClassified;
        }

        // YF 18 Mar 2022
        field(60; "TA Type"; Option)
        {
            Caption = 'TA Type';
            OptionMembers = "All","Wellaway","POM";
            // InitValue = "All";
        }

        field(70; "Find Next"; Boolean)
        {
            Caption = 'Find Next';
            // InitValue = true;
        }
        // YF 18 Mar 2022

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        /*
        key(PK; "Item No.", "Sales Type", "Sales Code", "Currency Code", "Starting Date", "Minimum Quantity", "Unit Of Measure Code")
        {
            Clustered = true;
        }
        */
    }

    trigger OnInsert()
    begin
        Rec."Entry Timestamp" := CurrentDateTime;
    end;

}
