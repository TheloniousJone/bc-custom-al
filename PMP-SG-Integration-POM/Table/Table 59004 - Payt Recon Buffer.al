table 59004 "POM Payt Recon Buffer"
{
    Caption = 'POM Payment Reconciliation Buffer';
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

        field(10; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
        }

        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }

        field(30; "POM Reference No."; Text[35])
        {
            Caption = 'POM Reference No.';
            DataClassification = ToBeClassified;
        }

        field(40; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }

        field(50; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            DataClassification = ToBeClassified;
        }

        field(60; "Invoiced Amount"; Decimal)
        {
            Caption = 'Invoiced Amount';
            DataClassification = ToBeClassified;
        }

        field(70; "Amount Difference"; Decimal)
        {
            Caption = 'Amount Difference';
            DataClassification = ToBeClassified;
        }

        field(80; "Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Order No.';
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
