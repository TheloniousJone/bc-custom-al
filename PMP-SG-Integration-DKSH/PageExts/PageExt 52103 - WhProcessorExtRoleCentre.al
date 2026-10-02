pageextension 52103 DKSHWhProcessorRoleCentreExt extends 9000
{

    layout
    {

        // Add changes to page layout here

        addafter(Control1903327208)
        {
            part(DKSHIntegrate; DKSHIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'DKSH Integration';
                Visible = true;
            }
        }
    }
}