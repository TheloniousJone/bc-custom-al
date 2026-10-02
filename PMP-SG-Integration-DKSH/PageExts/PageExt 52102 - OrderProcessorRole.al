pageextension 52102 DKSHOrderProcessorRole extends "Order Processor Role Center"
{

    layout
    {

        // Add changes to page layout here

        addbefore("User Tasks Activities")
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
