tableextension 50007 HyphensSalesCrMemoLineExt extends "Sales Cr.Memo Line"
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
    }
}
