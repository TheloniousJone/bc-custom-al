pageextension 59005 POMOrderProcessorRolePageExt extends "Order Processor Role Center"
{

    layout
    {

        // Add changes to page layout here

        addbefore("User Tasks Activities")
        {
            part(POMSOIntegrate; POMSOIntegrateCuePage)
            {
                ApplicationArea = All;
                Caption = 'POM SO Integration';
                Visible = true;
            }
        }
    }

    actions
    {
        addafter(SalesOrders)
        {
            action("POM2 Orders")
            {
                ApplicationArea = all;
                //TN        21 Sept 2026
                //AL0729: promoted properties are invalid on a RoleCenter page (warning becomes an error
                //in a future release). They have no effect here - the Role Center renders this as a
                //navigation action - so commenting them out does not change behaviour.
                // Promoted = true;
                // PromotedCategory = New;
                // PromotedIsBig = true;
                // PromotedOnly = true;
                //TN        21 Sept 2026
                Image = Document;
                RunObject = page "POM2 Order List";
            }
        }
    }
}
