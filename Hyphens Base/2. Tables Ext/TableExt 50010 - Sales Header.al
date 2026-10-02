tableextension 50010 HyphensSalesHeaderExt extends "Sales Header"
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
        // YF 18 Jan 2022
        modify("Currency Factor")
        {
            trigger OnAfterValidate()
            begin
                Rec.CalcFields(Amount);

                // FCY-LCY Rate = 1 / SHRec.Currency Factor
                if Rec."Currency Factor" <> 0 then
                    Rec."FCY-LCY Rate" := 1 / Rec."Currency Factor"
                else
                    Rec."FCY-LCY Rate" := 1; //RL 14 Feb 2022

                // LCY Amount = Amount / SHRec.Currency Factor
                if Rec."Currency Factor" <> 0 then
                    Rec."LCY Amount" := Rec.Amount / Rec."Currency Factor"
                else
                    Rec."LCY Amount" := Rec.Amount; //RL 14 Feb 2022

                // Adjustment
                Rec.Adjustment := Rec."Peg SGD Amount" - Rec."LCY Amount";
            end;
        }
        // YF 18 Jan 2022
    }

}