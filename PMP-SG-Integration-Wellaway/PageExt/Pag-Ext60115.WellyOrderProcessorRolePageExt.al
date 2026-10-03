pageextension 60115 ChainOrderProcessorRolePageExt extends "Order Processor Role Center"
{

    layout
    {

        // Add changes to page layout here

        addbefore("User Tasks Activities")
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
