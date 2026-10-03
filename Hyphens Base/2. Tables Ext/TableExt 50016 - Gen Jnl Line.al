tableextension 50016 HyphensGenJnlTblExt extends "Gen. Journal Line"
{
    fields
    {
        // Peg Rate 
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
        // Peg Rate 

        // Paid Rate // YF 23 Nov 2021
        field(50007; "Peg Rate of Invoice"; Decimal)
        {
            Caption = 'Peg Rate of Invoice';
            DataClassification = ToBeClassified;
        }

        field(50008; "VND Paid Rate"; Decimal)
        {
            Caption = 'VND Paid Rate';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalculateVNDPaidRate();
            end;
        }

        field(50009; "Paid VND"; Decimal)
        {
            Caption = 'Paid VND';
            DataClassification = ToBeClassified;
        }

        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                CalculateVNDPaidRate();
            end;
        }

        modify("Amount (LCY)")
        {
            trigger OnAfterValidate()
            begin
                CalculateVNDPaidRate();
            end;
        }

        field(50010; "Difference VND"; Decimal)
        {
            Caption = 'Difference VND';
            DataClassification = ToBeClassified;
        }

        field(50011; "Exchange Variable"; Decimal)
        {
            Caption = 'Exchange Variable';
            DataClassification = ToBeClassified;
        }

        field(50012; "Exchange Variable Settlement"; Decimal)
        {
            Caption = 'Exchange Variable Settlement';
            DataClassification = ToBeClassified;
        }
        // Paid Rate // YF 23 Nov 2021

    }

    // YF 23 Nov 2021
    procedure CalculateVNDPaidRate()
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;
        if Not CompanyInfoRec."Enable Peg Rate Module" then
            exit;

        "Paid VND" := Amount * "VND Paid Rate";
        "Difference VND" := ("Peg Rate of Invoice" - "VND Paid Rate") * Amount;
        if "VND Paid Rate" <> 0 then
            "Exchange Variable" := "Difference VND" / "VND Paid Rate";
        if "Currency Factor" <> 0 then
            "Exchange Variable Settlement" := "Exchange Variable" / "Currency Factor";

        // YF 08 Dec 2021 Rounding 
        "Exchange Variable Settlement" := Round("Exchange Variable Settlement", 0.01, '>');
        // YF 08 Dec 2021 Rounding 
    end;
    // YF 23 Nov 2021
}
