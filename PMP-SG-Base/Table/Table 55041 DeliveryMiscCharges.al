table 55041 "Delivery Misc Charges"
{
    Caption = 'Delivery Misc Charges';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(10; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(25; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(30; Branch; Text[250])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
        field(40; Address; Text[500])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(50; "Opening Hours"; Text[250])
        {
            Caption = 'Opening Hours';
            DataClassification = ToBeClassified;
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(70; Ice; Option)
        {
            Caption = 'Ice';
            DataClassification = ToBeClassified;
            OptionMembers = No,Yes;
        }
        field(80; "COD Amount"; Decimal)
        {
            Caption = 'COD Amount';
            DataClassification = ToBeClassified;
        }
        field(90; "NCNG Amount"; Decimal)
        {
            Caption = 'NCNG Amount';
            DataClassification = ToBeClassified;
        }
        field(100; "Cheque No And Amt Coll."; Text[250])
        {
            Caption = 'Cheque No And Amt Coll.';
            DataClassification = ToBeClassified;
        }
        field(110; Instruction; Text[500])
        {
            Caption = 'Instruction';
            DataClassification = ToBeClassified;
        }
        field(120; "Delivery Charge"; Code[20])
        {
            Caption = 'Delivey Charge';
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Charge"."Delivery Charge";
        }

        field(130; Driver; Code[20])
        {
            Caption = 'Driver';
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Zone"."Delivery Zone";
        }

        field(140; "LS Account"; Code[50])
        {
            Caption = 'LS Account';
            DataClassification = ToBeClassified;
            TableRelation = "LS Account".Code;
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
