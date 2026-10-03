pageextension 90000 ChainOrderProcessorRolePageExt extends "Order Processor Role Center"
{

    layout
    {

        // Add changes to page layout here

        addbefore("User Tasks Activities")
        {
            part(ChainSOIntegrate; ChainSOIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'ChainPharma SO Integration';
                Visible = true;
            }
        }
    }


    actions
    {
        addafter(SalesOrders)
        {
            action("Chain Pharma Orders")
            {
                ApplicationArea = all;
                // Promoted = true;
                // PromotedCategory = New;
                // PromotedIsBig = true;
                // PromotedOnly = true; I9070423 - Update Version
                Image = Document;
                RunObject = page "Chain Pharma. PO List";
            }
        }

    }
}
