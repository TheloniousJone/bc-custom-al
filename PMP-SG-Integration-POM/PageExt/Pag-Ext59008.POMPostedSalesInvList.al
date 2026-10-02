pageextension 59008 POMPostedSalesInvList extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Order Status")
        {
            field("Processed by POM"; Rec."Processed by POM")
            {
                ApplicationArea = All;
            }
            field("Amount Collected by POM"; Rec."Amount Collected by POM")
            {
                ApplicationArea = All;
            }
            // YF 21 Sep 2022
            field("Last Posted Invoice in Order"; Rec."Last Posted Invoice in Order")
            {
                ApplicationArea = All;
            }
            // YF 21 Sep 2022
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
                    CurrRec: Record "Sales Invoice Header";
                    POMCU: Codeunit POM2;
                begin
                    Clear(CurrRec);
                    CurrPage.SetSelectionFilter(CurrRec);
                    if CurrRec.FindSet() then
                        repeat
                            Clear(POMCU);
                            POMCU.ResetPSILastPostedFlag(CurrRec, false);
                        until CurrRec.Next() = 0;
                    Message('POM Payment Status Reconciled');
                end;
            }

        }
    }
    // YF 21 Sep 2022
}
