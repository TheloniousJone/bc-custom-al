pageextension 59006 POMWhProcessorRoleCentreExt extends 9000
{

    layout
    {

        // Add changes to page layout here

        addafter(Control1903327208)
        {
            part(POMSOIntegrate; POMSOIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'POM SO Integration';
                Visible = true;
            }
        }
    }
}