pageextension 55134 SalesCreditMemosExt extends "Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedBy; EnhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
        }
    }
    var
        EnhanceCU: Codeunit "PMP-Enhancements";
}
