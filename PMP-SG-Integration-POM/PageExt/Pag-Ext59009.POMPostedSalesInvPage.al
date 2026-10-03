pageextension 59009 POMPostedSalesInvPageExt extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Samples SO")
        {
            field("Processed by POM"; Rec."Processed by POM")
            {
                ApplicationArea = all;
            }

            // YF 21 Sep 2022
            field("Last Posted Invoice in Order"; Rec."Last Posted Invoice in Order")
            {
                ApplicationArea = All;
            }
            // YF 21 Sep 2022

            //RL 12 Oct 2022
            field("Amount Collected by POM"; Rec."Amount Collected by POM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Amount Collected by POM field.';
            }
            field("Refund Date"; Rec."Refund Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Refund Date field.';
            }

            field("Refund Amount"; Rec."Refund Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Refund Amount field.';
            }
            //RL 12 Oct 2022  
        }
    }

    // YF 21 Sep 2022
    actions
    {
        addafter("Update Document")
        {
            action("Reset Last Posted Document Flag")
            {
                ApplicationArea = All;
                Caption = 'POM Payment Checked';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResetStatus;
                InFooterBar = true;

                trigger OnAction()
                var
                    POMCU: Codeunit POM2;
                begin
                    Clear(POMCU);
                    POMCU.ResetPSILastPostedFlag(Rec, false);
                    Message('POM Payment Status Reconciled');
                end;
            }
        }
    }
    // YF 21 Sep 2022
}
