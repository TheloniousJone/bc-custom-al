pageextension 90002 BusinessMgrExtRoleCentre extends "Business Manager Role Center"
{
    layout
    {

        // Add changes to page layout here

        addafter(Control1903327208)
        {
            part(ChainSOIntegrate; ChainSOIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'ChainPharma SO Integration';
                Visible = true;
            }
        }
    }
}
