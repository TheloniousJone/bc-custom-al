pageextension 56105 ZPWhProcessorRoleCentreExt extends 9000
{

    layout
    {

        // Add changes to page layout here

        addafter(Control1903327208)
        {
            part(ZPSOIntegrate; ZPIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'ZP Integration';
                Visible = true;
            }
        }
    }
}