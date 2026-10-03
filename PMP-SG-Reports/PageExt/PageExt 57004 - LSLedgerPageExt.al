pageextension 57004 LSLedgerPageExt extends "LS Ledger Entry"
{
    layout
    {

    }
    actions
    {
        addfirst(Reporting)
        {
            action("LS Report")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Report.Run(57103);
                end;
            }
        }
    }
}
