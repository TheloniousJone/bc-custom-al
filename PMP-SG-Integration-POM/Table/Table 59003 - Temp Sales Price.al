table 59003 "Temp Sales Price"
{
    CaptionML = ENU = 'Temp Sales Price', ENA = 'Temp Sales Price';
    DataPerCompany = true;

    fields
    {
        field(1; "ID"; Integer)
        {
            Caption = 'ID';
            Description = 'ID';
            AutoIncrement = true;
        }

        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = 'Document No.';
        }

        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Description = 'Posting Date';
        }

        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'Customer No.';
        }

        field(5; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            Description = 'Quantity';
        }

        field(6; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
            Description = 'Unit of Measure';
        }

        field(7; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Description = 'Customer Name';
        }

        field(8; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            Description = 'Company Name';
        }

        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'Item No.';
        }

        field(10; "Start Date"; Date)
        {
            Caption = 'Start Date';
            Description = 'Start Date';
        }

        field(11; "End Date"; Date)
        {
            Caption = 'End Date';
            Description = 'End Date';
        }

        field(12; "Description"; Text[100])
        {
            Caption = 'Description';
            Description = 'Description';
        }

        field(13; "Address Code"; Text[50])
        {
            Caption = 'Address Code';
            Description = 'Address Code';
        }

        field(14; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            Description = 'Line Amount';
        }

        field(15; "Inventory Posting Group"; Text[50])
        {
            Caption = 'Inventory Posting Group';
            Description = 'Inventory Posting Group';
        }

        field(16; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            Description = 'Description 2';
        }

        field(17; "Branch"; Text[250])
        {

        }

        field(18; "Address 1"; Text[100])
        {

        }
        field(19; "Address 2"; Text[50])
        {

        }
        field(20; "Cust Price Group"; Text[20])
        {

        }

        field(21; "Qty Per Measure"; Decimal)
        {

        }

        field(22; "Sales Code"; code[20])
        {

        }

        field(23; "Currency Code"; code[10])
        {

        }

        field(24; "Unit Price"; Decimal)
        {

        }

        field(25; "Price Includes VAT"; Boolean)
        {

        }
        field(26; "Allow Invoice Disc."; Boolean)
        {

        }
        field(27; "Line Discount %"; Integer)
        {

        }
        field(28; "Sales Type"; Option)
        {
            OptionMembers = "Customer","Customer Price Group","All Customers","Campaign";
        }
        field(29; "Minimum Quantity"; Decimal)
        {

        }

        field(30; "Unit Of Measure Code"; Code[10])
        {

        }
        field(31; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {

        }
        field(32; "Allow Line Disc."; Boolean)
        {

        }
        field(33; "Variant Code"; Code[10])
        {

        }
        field(34; "FOC Qty"; Decimal)
        {

        }
        field(35; Status; Enum "Price Status")
        {

        }
        field(36; "RecRefID"; Code[50])
        {

        }

        field(37; Remarks; Text[100])
        {

        }
        field(38; "Have Bonus"; Code[10])
        {

        }

    }

    keys
    {

        key(PrimaryKey; "ID")
        {
            Clustered = true;
        }

    }

}