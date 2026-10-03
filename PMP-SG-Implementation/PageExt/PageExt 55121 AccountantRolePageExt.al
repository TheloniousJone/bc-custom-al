pageextension 55121 AccountantRolePageExt extends "Accountant Role Center"
{
    layout
    {
        // Add changes to page layout here
        addafter(Control1907692008)
        {
            part(Control1903327208; "WMS Ship & Receive Activities")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }


    var
        myInt: Integer;
}