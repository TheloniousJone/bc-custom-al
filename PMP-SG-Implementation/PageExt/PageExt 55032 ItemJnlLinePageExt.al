pageextension 55032 ItemJnlLinePageExt extends "Item Journal Lines"
{
    layout
    {
        addafter("Location Code")
        {
            field(Exchangeable; Rec.Exchangeable)
            {
                ApplicationArea = all;
            }
        }
    }
}