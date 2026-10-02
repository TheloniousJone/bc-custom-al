table 55038 WHStkTakeLine
{
    Caption = 'WHStkTakeLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Stk Take Header No."; Code[20])
        {
            Caption = 'Stk Take Header No.';
            DataClassification = ToBeClassified;
            TableRelation = "WH Stk Take Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Zone Code"; Code[20])
        {
            Caption = 'Zone Code';
            DataClassification = ToBeClassified;
        }
        field(6; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
        field(7; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        field(8; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = ToBeClassified;
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(10; "Quantity (Calc)"; Decimal)
        {
            Caption = 'Quantity (Calc)';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Stk Take Header No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
