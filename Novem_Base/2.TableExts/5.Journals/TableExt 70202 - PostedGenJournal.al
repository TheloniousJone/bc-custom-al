tableextension 70202 PostedGeneralJournalExt extends "Posted Gen. Journal Line"
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
        field(70003; I9G_AccountDetails; Text[200])
        {
            Caption = 'Account Details';
        }
    }
}