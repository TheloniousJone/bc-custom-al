table 55001 "LS Ledger Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Unit Of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(90; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(110; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Amount Incl GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(130; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        21 July 2021
        field(140; "Closed By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Ext. Doc No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(160; "FOC Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(170; "Calculation Method"; Option)
        {
            OptionMembers = Line,Percentage;
        }
        field(180; "Commission Amount"; Decimal)

        {
            DataClassification = ToBeClassified;
        }
        //DX        21 July 2021

        field(190; "LS Account"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LS Account".Code;
            Caption = 'LS Account';
        }

    }

    keys
    {
        key(Primary; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}