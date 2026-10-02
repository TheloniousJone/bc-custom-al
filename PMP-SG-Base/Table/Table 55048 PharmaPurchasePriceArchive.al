table 55048 "Pharma Purchase Price Archives"
{
    Caption = 'Pharma Purchase Price Archives';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }

        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }

        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }

        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }

        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
        }

        field(6; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(7; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(8; "Line Discount %"; Integer)
        {
            Caption = 'Line Discount %';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
            MinValue = 0;
            MaxValue = 100;
        }

        field(9; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }

        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }

        field(30; Status; Enum "Price Status")
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(5400; "Unit of Measure Code"; Code[10])
        { }

        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }

        field(55000; "FOC Qty"; Decimal)
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
            Caption = 'FOC Qty';
        }

        field(55001; "RecRefID"; Code[50])
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(31; "New Cost Price"; Decimal)
        {
            // temp for page dialog
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(32; Remarks; Text[100])
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(33; "Margin Percent"; Decimal)
        {
            // temp for page dialog
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
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
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // YF 23 Dec 2021 // Fields for Revised Reflect Price Changes
        field(34; "New FOC Qty"; Decimal)
        {
            // temp for page dialog
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(35; "New Min Order Qty"; Decimal)
        {
            Caption = 'New Minimum Order Quantity';
        }

        field(36; "Average Cost"; Decimal)
        {
            Caption = 'Average Cost';
        }

        field(37; "New Average Cost"; Decimal)
        {
            Caption = 'New Average Cost';
        }

        field(38; "Margin Increase"; Decimal)
        {
            Caption = 'Margin Increase';
        }
        // YF 23 Dec 2021 // Fields for Revised Reflect Price Changes        

        // YF 02 Mar 2022
        field(39; "Country of Purchase Code"; Code[10])
        {
            Caption = 'Country of Purchase Code';
            TableRelation = "Country/Region".Code;
        }
        // YF 02 Mar 2022

    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

    }

    /*
    fieldgroups
    {
        fieldgroup(DropDown; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
    }
    */

    trigger OnInsert()
    begin
        Rec."Entry Timestamp" := CurrentDateTime;
    end;

}
