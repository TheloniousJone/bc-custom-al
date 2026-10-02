pageextension 57011 CLEPageExt extends "Customer Ledger Entries"
{
    actions
    {
        addafter("Apply Entries")
        {
            action("Customer Payment Receipts")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CLERec: Record "Cust. Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(CLERec);
                    report.Run(211, true, true, CLERec);
                end;
            }
        }
    }
}