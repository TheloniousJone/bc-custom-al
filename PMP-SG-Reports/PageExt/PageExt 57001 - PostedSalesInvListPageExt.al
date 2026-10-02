pageextension 57001 PostedSalesInvListPageExt extends "Posted Sales Invoices"
{
    layout
    {
        // layout changes here
    }

    actions
    {
        addafter(Print)
        {
            action("Print Delivery List")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Report.Run(57101);
                end;
            }
            action("Print LS Delivery List")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Report.Run(57111);
                end;
            }
            action("Print LS Delivery Order")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57025, true, false, SIHRec);
                    //Report.Run(57101);
                end;
            }
            action("Print Sales Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57001, true, false, SIHRec);
                end;
            }
            action("Print Sales GL Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57023, true, false, SIHRec);
                end;
            }
            action("Print Rebill Sales Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57027, true, false, SIHRec);
                end;
            }
            action("Print Posted Waybill")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57013, true, false, SIHRec);
                    //Report.Run(57101);
                end;
            }
        }
    }
}