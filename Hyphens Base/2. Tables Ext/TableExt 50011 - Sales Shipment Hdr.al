tableextension 50011 HyphensSalesShipmentHdrExt extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Peg Rate"; Decimal)
        {
            Caption = 'Peg Rate';
            DataClassification = ToBeClassified;
        }

        field(50001; "VND Amount"; Decimal)
        {
            Caption = 'VND Amount';
            DataClassification = ToBeClassified;
        }

        field(50002; "VND-LCY Rate"; Decimal)
        {
            Caption = 'VND-LCY Rate';
            DataClassification = ToBeClassified;
        }

        field(50003; "Peg SGD Amount"; Decimal)
        {
            Caption = 'Peg SGD Amount';
            DataClassification = ToBeClassified;
        }

        field(50004; "FCY-LCY Rate"; Decimal)
        {
            Caption = 'FCY-LCY Rate';
            DataClassification = ToBeClassified;
        }

        field(50005; "LCY Amount"; Decimal)
        {
            Caption = 'LCY Amount';
            DataClassification = ToBeClassified;
        }

        field(50006; Adjustment; Decimal)
        {
            Caption = 'Adjustment';
            DataClassification = ToBeClassified;
        }
        //LK141123
        field(50007; I9_ContractDate; Date)
        {
            Caption = 'Contract Date';
            DataClassification = ToBeClassified;

        }

        field(50008; I9_ContractNo; Text[50])
        {
            Caption = 'Contract No';
            DataClassification = ToBeClassified;
        }

        field(50009; I9_ContractAmount; Decimal)
        {
            Caption = 'Contract Amount';
            DataClassification = ToBeClassified;
        }
        //LK141123
    }
}