pageextension 60119 BusinessMgrExtRoleCentre extends 9022
{

    layout
    {

        // Add changes to page layout here

        addafter("PMP SOs")        //DX        19 May 2023
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