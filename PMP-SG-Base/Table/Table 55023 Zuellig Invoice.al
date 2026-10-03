table 55023 "Zuellig Invoices"
{
    DataClassification = ToBeClassified;
    Caption = 'Zuellig Invoices';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Doc No.';
        }
        field(3; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'PO No.';
        }
        field(4; "Recorded Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date';
        }
        field(5; "New Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'New Customer No.';
        }
        field(6; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
        }
        field(7; "Customer Name"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
        }
        field(8; "Type 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "New Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'New Item No.';
        }
        field(10; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item No.';
        }
        field(11; "Item Description"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item Description';
        }
        field(12; "Trans Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Trans Qty';
        }
        field(13; "Selling Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Selling Price';
        }
        field(14; "Trans Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Trans Value';
        }
        field(15; SP; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'SP';
        }
        field(16; "Detailman"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Detailman';
        }
        field(17; "Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Year';
        }
        field(18; "Month"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month';
        }
        field(19; "Quarter"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Quarter';
        }
        field(20; "Lot No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lot No.';
        }
        field(21; "Lot Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Lot Expiry Date';
        }
        field(22; "Reason For Return"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason For Return';
        }
        field(23; "Business Division 4"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Business Division 4';
        }
        field(24; "Business Division 5"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Business Division 5';
        }
        field(25; "Distributor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Distributor';
        }
        field(26; "Invoice Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice Created';
        }

        field(30; "Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(40; "BC Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'BC Invoice No.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
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