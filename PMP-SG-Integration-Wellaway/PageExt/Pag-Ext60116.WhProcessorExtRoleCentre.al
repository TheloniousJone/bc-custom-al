pageextension 60116 CPWhProcessorRoleCentreExt extends 9000
{

    layout
    {

        // Add changes to page layout here

        addafter(Control1903327208)
        {
            part(WellySOIntegrate; WellySOIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'Wellaway SO Integration';
                Visible = true;
            }
        }
    }
}