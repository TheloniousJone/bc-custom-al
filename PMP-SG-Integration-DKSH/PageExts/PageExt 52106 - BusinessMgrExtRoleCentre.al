pageextension 52106 BusinessMgrExtRoleCentre extends 9022
{

    layout
    {

        // Add changes to page layout here

        addafter("PMP SOs")
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