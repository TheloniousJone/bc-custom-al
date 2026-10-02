pageextension 55204 "Detailed Vend Ledg Entries Ext" extends "Detailed Vendor Ledg. Entries"
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