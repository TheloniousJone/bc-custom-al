table 59010 POM2DetailsTbl
{
    Caption = 'Pom2LineTbl';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PurchaseOrderID; Code[30])
        {
            Caption = 'PurchaseOrderID';
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Product Code"; Code[50])
        {
            Caption = 'Product Code';
            DataClassification = ToBeClassified;
        }
        field(20; "Product Name"; Text[250])
        {
            Caption = 'Product Name';
            DataClassification = ToBeClassified;
        }
        field(30; QuantityOrdered; Decimal)
        {
            Caption = 'QuantityOrdered';
            DataClassification = ToBeClassified;
        }
        field(40; BonusQuantity; Decimal)
        {
            Caption = 'BonusQuantity';
            DataClassification = ToBeClassified;
        }
        field(50; UnitPrice; Decimal)
        {
            Caption = 'UnitPrice';
            DataClassification = ToBeClassified;
        }
        field(60; UOMCode; Code[20])
        {
            Caption = 'UOMCode';
            DataClassification = ToBeClassified;
        }
        field(70; ExpiryDate; Date)
        {
            Caption = 'ExpiryDate';
            DataClassification = ToBeClassified;
        }
        field(80; Created; Boolean)
        {
            Caption = 'Created';
            DataClassification = ToBeClassified;
        }
        field(90; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }
        field(100; "Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; PurchaseOrderID, "Line No.")
        {
            Clustered = true;
        }
    }

}
