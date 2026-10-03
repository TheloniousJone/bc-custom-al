table 55035 "Historical Item Sales"
{
    Caption = 'Historical Item Sales';
    DataClassification = ToBeClassified;
    //DX    04 July 2021    Additional ledger entry table to tack historical item sales.
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = "","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Return";
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(8; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(10; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        field(11; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = ToBeClassified;
        }
        field(12; "External Doc No."; Code[35])
        {
            Caption = 'External Doc No.';
            DataClassification = ToBeClassified;
        }
        field(13; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            DataClassification = ToBeClassified;
        }
        field(14; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
            DataClassification = ToBeClassified;
        }
        field(15; "Unit Of Measure Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        //DX        08 Jun 2023
        key(key2; "Item No.", "Entry Type", "Source No.", Description)
        {

        }
        key(key3; "Item No.", "Entry Type", "Source No.")
        {

        }
        key(key4; "Item No.", "Entry Type", "Location Code")
        {

        }
        //DX        08 Jun 2023
    }

}
