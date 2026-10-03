table 57000 "Temp Sales Report Line"
{
    CaptionML = ENU = 'Temp Sales Report Line', ENA = 'Temp Sales Report Line';
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

        field(4; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Description = 'Sell-to Customer No.';
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

        field(9; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'No.';
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

        field(17; "Branch"; Text[500])
        {

        }

        field(18; "Address 1"; Text[100])
        {

        }
        field(19; "Address 2"; Text[50])
        {

        }

        field(20; "Delivery Zone"; Code[20])
        {

        }

        field(21; "Operating Hours"; Text[500])
        {

        }

        field(22; "Cold Room Item"; Boolean)
        {

        }


        field(23; "COD Amount"; Decimal)
        {


        }

        field(24; "Delivery Instructions"; Text[500])
        {

        }

        field(25; "Delivery Charge"; Code[20])
        {

        }

        field(26; "Working Hours"; Text[500])
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