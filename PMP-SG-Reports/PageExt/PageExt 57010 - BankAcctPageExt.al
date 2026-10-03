pageextension 57010 BankAcctPageExt extends "Bank Account Card"
{
    layout
    {


    }
    actions
    {
        addfirst(Reporting)
        {
            action("Bank Recon")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Report.Run(57041);
                end;
            }
        }
    }

}
