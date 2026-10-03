pageextension 55128 FixedAssetGLJournalExt extends "Fixed Asset G/L Journal"
{
    layout
    {
        addbefore(Amount)
        {
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = All;
            }
        }
    }
}
