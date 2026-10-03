pageextension 55203 "Sales Order Archives Ext" extends "Sales Order Archives"
{
    layout
    {
        addlast(Control1)
        {
            field(I9G_SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'I9G System Modified At';
                Visible = false;
            }
        }
    }
}