table 59000 POM2HeaderTbl
{
    Caption = 'POM2HeaderTbl';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PurchaseOrderID; Code[30])
        {
            Caption = 'PurchaseOrderID';
            DataClassification = ToBeClassified;
        }
        field(10; TransactionDate; Date)
        {
            Caption = 'TransactionDate';
            DataClassification = ToBeClassified;
        }
        field(20; PhysicalPOID; Code[50])
        {
            Caption = 'PhysicalPOID';
            DataClassification = ToBeClassified;
        }
        field(30; "Customer Account"; Code[20])
        {
            Caption = 'Customer Account';
            DataClassification = ToBeClassified;
        }
        field(40; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(50; LoginID; Code[50])
        {
            Caption = 'lOGINid';
            DataClassification = ToBeClassified;
        }
        field(60; OrderBy; Text[50])
        {
            Caption = 'OrderBy';
            DataClassification = ToBeClassified;
        }
        field(70; Currency; Code[20])
        {
            Caption = 'Currency';
            DataClassification = ToBeClassified;
        }
        field(80; "Terms Of Payment"; Code[20])
        {
            Caption = 'Terms Of Payment';
            DataClassification = ToBeClassified;
        }
        field(90; ContactPerson; Text[250])
        {
            Caption = 'ContactPerson';
            DataClassification = ToBeClassified;
        }
        field(100; StreetName; Text[250])
        {
            Caption = 'StreetName';
            DataClassification = ToBeClassified;
        }
        field(110; "Country/Region"; Code[200])
        {
            Caption = 'Country/Region';
            DataClassification = ToBeClassified;
        }
        field(120; "Zip Code"; Code[20])
        {
            Caption = 'Zip Code';
            DataClassification = ToBeClassified;
        }
        field(130; Email; Text[250])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
        }
        field(140; Telephone; Text[250])
        {
            Caption = 'Telephone';
            DataClassification = ToBeClassified;
        }
        field(150; Fax; Text[100])
        {
            Caption = 'Fax';
            DataClassification = ToBeClassified;
        }
        field(160; OnlineDiscountAmount; Decimal)
        {
            Caption = 'OnlineDiscountAmount';
            DataClassification = ToBeClassified;
        }
        field(170; OnlineDiscountPercent; Decimal)
        {
            Caption = 'OnlineDiscountPercent';
            DataClassification = ToBeClassified;
        }
        field(180; Remarks; Text[500])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(190; Created; Boolean)
        {
            Caption = 'Created';
            DataClassification = ToBeClassified;
        }
        field(200; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }
        field(210; "Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; PurchaseOrderID)
        {
            Clustered = true;
        }
    }

}
