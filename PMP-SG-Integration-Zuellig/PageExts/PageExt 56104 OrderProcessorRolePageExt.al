pageextension 56104 ZPOrderProcessorRolePageExt extends "Order Processor Role Center"
{

    layout
    {

        // Add changes to page layout here

        addbefore("User Tasks Activities")
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
