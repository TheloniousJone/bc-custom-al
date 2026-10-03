pageextension 69008 BusinessManagerRole2 extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
        addafter(Control16)
        {
            part(VersaFleet; VersaCues)
            {
                ApplicationArea = all;
                Caption = 'VersaFleet';
                Visible = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}