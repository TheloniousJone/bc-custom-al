pageextension 57015 ItemJournalExt extends "Item Journal"
{
    actions
    {

        addafter("&Print")
        {
            action("Print Inventory Movement with Lot")
            {
                ApplicationArea = all;
                PromotedCategory = Category5;
                Promoted = true;
                Image = Print;

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RunModal(57125, true, true, ItemJnlLine);
                end;
            }
        }
    }
}
