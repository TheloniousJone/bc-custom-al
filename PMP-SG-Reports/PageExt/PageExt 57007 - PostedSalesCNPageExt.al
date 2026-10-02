pageextension 57007 PostedSalesCNPageExt extends "Posted Sales Credit Memo"
{
    actions
    {
        addafter(Print)
        {

            action("Print Sales Credit Memo")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Cr.Memo Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57002, true, false, SIHRec);
                end;
            }
            action("Print Sales GL Cr. Memo")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Cr.Memo Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57022, true, false, SIHRec);
                end;
            }
        }
    }
}
