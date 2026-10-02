table 55047 "Sales Price Change Staging"
{
    Caption = 'Sales Price Change Staging';
    DataClassification = ToBeClassified;

    fields
    {

        // Autonumber Primary Key for Staging
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        // Primary Key of Sales Trade Agreement Records
        // "Item No.", "Sales Type", "Sales Code", "Currency Code", "Starting Date", "Minimum Quantity", "Unit Of Measure Code"
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(3; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionMembers = "Customer","Customer Price Group","All Customers","Campaign";
        }

        field(4; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(5; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(6; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(7; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }

        field(8; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }


        // Operational Fields
        field(9; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }

        field(10; "FOC Qty"; Decimal)
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
            Caption = 'FOC Qty';
        }

        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Original Cost Price
        field(12; "Original Cost Price"; Decimal)
        {
            Caption = 'Original Cost Price';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // New Cost Price
        field(13; "New Cost Price"; Decimal)
        {
            Caption = 'New Cost Price';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Markup Percent
        field(14; "Markup Percent"; Decimal)
        {
            Caption = 'Markup Percent';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Original Selling Proce
        field(15; "Original Selling Price"; Decimal)
        {
            Caption = 'Original Selling Price';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Suggested Selling Price
        field(16; "Suggested Selling Price"; Decimal)
        {
            Caption = 'Suggested Selling Price';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }


        // Audit and Status

        // Option - Pending / Rejected / Applied
        field(17; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Pending","Rejected","Applied","Failed";
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(18; "Status Descr"; Text[50])
        {
            Caption = 'Status Description';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // User ID
        field(19; "Processed By"; Text[50])
        {
            Caption = 'Processed By';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Timestamp
        field(20; "Processed On"; DateTime)
        {
            Caption = 'Processed On';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Entry Timestamp
        field(30; "Entry Timestamp"; DateTime)
        {
            Caption = 'Entry Timestamp';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // Additional date fields to handle existing and new sales prices start and end dates
        field(40; "Revised Price Start Date"; Date)
        {
            Caption = 'Revised Price Start Date';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(50; "Revised Price End Date"; Date)
        {
            Caption = 'Revised Price End Date';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(60; "New Price Start Date"; Date)
        {
            Caption = 'New Price Start Date';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(70; "New Price End Date"; Date)
        {
            Caption = 'New Price End Date';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }
        // Additional date fields to handle existing and new sales prices start and end dates

        // YF 23 Dec 2021 // Fields for Revised Reflect Price Changes  
        field(80; "New Suggested Selling Price"; Decimal)
        {
            Caption = 'New Suggested Selling Price';
        }
        // YF 23 Dec 2021 // Fields for Revised Reflect Price Changes  

        // YF 07 Mar 2022
        field(90; "Requested By"; Text[50])
        {
            Caption = 'Requested By';
        }
        // YF 07 Mar 2022

        // YF 18 Mar 2022
        field(100; "TA Type"; Option)
        {
            Caption = 'TA Type';
            OptionMembers = "All","Wellaway","POM";
            // InitValue = "All";
        }

        field(110; "Find Next"; Boolean)
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
        key(AltKey1; "Item No.", "Sales Type", "Sales Code", "Currency Code", "Starting Date", "Minimum Quantity", "Unit Of Measure Code")
        {
        }
        */
    }

    trigger OnInsert()
    begin
        Rec."Entry Timestamp" := CurrentDateTime;
    end;

    procedure CalcPriceDateRevision()
    begin
        // 1. Set Revised Start Date same as Original Start Date
        Rec."Revised Price Start Date" := Rec."Starting Date";

        // 2. Calculate New Price Start Date // +2M from Starting Date
        Rec."New Price Start Date" := CalcDate('<+2M>', Rec."Starting Date");

        // 3. Calculate Revised End Date // 1 day before the new end date
        Rec."Revised Price End Date" := CalcDate('<-1D>', Rec."New Price Start Date");

        // 4. Calculate New Price End Date // 2m from revised end date
        Rec."New Price End Date" := CalcDate('<+2M>', "Revised Price End Date");
    end;

}
