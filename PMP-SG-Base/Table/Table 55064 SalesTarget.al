table 55064 "Sales Target"
{
    Caption = 'Sales Target';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            TableRelation = "Sales Target BU";
        }
        field(5; "Area"; Code[20])
        {
            Caption = 'Area';
            TableRelation = "Sales Area";
        }
        field(6; "Version"; Option)
        {
            Caption = 'Version';
            OptionMembers = " ","Tier 1","Tier 2";
        }
        field(7; "Forecast"; Decimal)
        {
            Caption = 'Forecast';
        }

    }
    keys
    {
        key(Primary; "Entry No.")
        {
            Clustered = true;
        }
    }

}
