tableextension 70201 GeneralJournalTableExt extends "Gen. Journal Line"
{
    fields
    {
        field(70000; "I9G_Remarks"; Text[250])
        {
            Caption = 'Remarks';
        }
        field(70001; "I9G_ChequeDetails"; Text[250])
        {
            Caption = 'Cheque Details';
        }
        field(70002; I9G_GSTBaseAmount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'GST Base Amount';
        }
        field(70003; I9G_AccountDetails; Text[200])
        {
            Caption = 'Account Details';
        }
    }
}