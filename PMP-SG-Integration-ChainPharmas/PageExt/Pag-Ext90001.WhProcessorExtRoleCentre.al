pageextension 90001 CPWhProcessorRoleCentreExt extends 9000
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