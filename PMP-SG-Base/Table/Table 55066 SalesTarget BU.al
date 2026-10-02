table 55066 "Sales Target BU"
{
    Caption = 'Sales Target BU';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "BU Code"; Code[20])
        {
            Caption = 'BU Code';
            // AutoIncrement = true;
        }
        field(2; "BU Name"; Text[100])
        {
            Caption = 'BU Name';
            // TableRelation = Customer;
        }
        // field(3; "Date"; Date)
        // {
        //     Caption = 'Date';
        // }
        // field(4; "Business Unit"; Code[20])
        // {
        //     Caption = 'Business Unit';
        //     TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
        //                                                   Blocked = const(false));
        // }
        // field(5; "Area"; Code[20])
        // {
        //     Caption = 'Area';
        //     TableRelation = "Sales Area";
        // }
        // field(6; "Version"; Option)
        // {
        //     Caption = 'Version';
        //     OptionMembers = " ","Tier 1","Tier 2";
        // }
        // field(7; "Forecast"; Decimal)
        // {
        //     Caption = 'Forecast';
        // }

    }
    keys
    {
        key(Primary; "BU Code")
        {
            Clustered = true;
        }
    }

}
