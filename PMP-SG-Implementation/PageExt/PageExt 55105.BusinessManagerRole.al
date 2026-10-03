pageextension 55105 BusinessManagerRole extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
        addafter(Control16)
        {
            part("PMP SOs"; "PMP Activities Cue")
            {
                ApplicationArea = all;
                Caption = 'PMP';
                Visible = true;
            }
            part(Control1903327208; "WMS Ship & Receive Activities")
            {
                ApplicationArea = Warehouse;
            }
            part(OngoingSalesOrderCuePage; OngoingSalesOrderCuePage)
            {
                ApplicationArea = All;
                Caption = 'Ongoing Sales Order';
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