pageextension 55201 "Sales Order Arch Subform Ext" extends "Sales Order Archive Subform"
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