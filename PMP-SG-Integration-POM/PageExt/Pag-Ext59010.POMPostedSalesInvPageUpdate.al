pageextension 59010 POMPostedSalesInvPageUpdate extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter(Payment)
        {
            group(POM)
            {
                field("Refund Amount"; Rec."Refund Amount")
                {
                    ApplicationArea = All;
                }
                field("Refund Date"; Rec."Refund Date")
                {
                    ApplicationArea = All;
                }
            }
        }

    }


}
