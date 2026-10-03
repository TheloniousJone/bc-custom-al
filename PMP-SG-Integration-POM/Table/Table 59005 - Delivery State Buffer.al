table 59005 "POM Delivery State Buffer"
{
    Caption = 'POM Delivery State Buffer';
    DataClassification = ToBeClassified;
    ReplicateData = false;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }

        field(10; "POM Reference No."; Text[35])
        {
            Caption = 'POM Reference No.';
            DataClassification = ToBeClassified;
        }

        field(20; "SO Count"; Integer)
        {
            Caption = 'SO Count';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order), "Your Reference" = field("POM Reference No.")));
        }

        field(30; "Posted Inv. Count"; Integer)
        {
            Caption = 'Posted Inv. Count';
            DataClassification = ToBeClassified;
        }

        field(40; "Posted Inv. to Process Count"; Integer)
        {
            Caption = 'Posted Inv. to Process Count';
            FieldClass = FlowField;
            CalcFormula = count("Sales Invoice Header" where("Order Status" = filter(Completed),
                                                            "Your Reference" = field("POM Reference No."),
                                                            "Processed by POM" = const(false)));
        }

        field(50; "Processed"; Boolean)
        {
            Caption = 'Processed';
            DataClassification = ToBeClassified;
        }

        field(60; "Good To Process"; Boolean)
        {
            Caption = 'Good to Process';
            DataClassification = ToBeClassified;
        }

        field(70; "Good To Process Flag"; Integer)
        {
            Caption = 'Good to Process Flag';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}
