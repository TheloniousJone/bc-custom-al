pageextension 57009 VLEPageExt extends "Vendor Ledger Entries"
{
    actions
    {
        addafter("Create Payment")
        {
            action("Vendor Payment Receipts AL")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    VLERec: Record "Vendor Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(VLERec);
                    report.Run(411, true, true, VLERec);
                end;
            }
        }
    }
}
