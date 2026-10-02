pageextension 57012 PhyInvenList extends "Phys. Inventory Journal"
{
    actions
    {
        modify(Print)
        {
            Visible = False;
        }
        addafter(Print)
        {
            action("Print Stock List")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ItemJournalBatch: Record "Item Journal Batch";
                begin
                    ItemJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                    REPORT.RunModal(57113, true, false, ItemJournalBatch);
                end;
            }
            action("Reset Qty. (Phys. Inventory)")
            {
                ApplicationArea = All;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ItemJournalBatch: Record "Item Journal Batch";
                    ItemJournalLine: Record "Item Journal Line";
                begin
                    ItemJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if ItemJournalLine.FindSet() then begin
                        repeat
                            ItemJournalLine.Validate("Qty. (Phys. Inventory)", 0);
                            ItemJournalLine.Modify(false);
                        until ItemJournalLine.Next() = 0;
                        message('Qty Reset to 0');
                    end;
                end;
            }
            action("Insert Lot No.")
            {
                ApplicationArea = All;
                Image = LotInfo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lcdu_IT: Codeunit "Item Track CU";
                begin
                    lcdu_IT.ClearTrackingLines(Rec."Journal Template Name", Rec."Journal Batch Name");
                    lcdu_IT.AutoPopulateTracking(Rec."Journal Template Name", Rec."Journal Batch Name");
                    message('Item Tracking lines inserted');
                end;
            }
            action("Clear Lot No.")
            {
                ApplicationArea = All;
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lcdu_IT: Codeunit "Item Track CU";
                begin
                    lcdu_IT.ClearTrackingLines(Rec."Journal Template Name", Rec."Journal Batch Name");

                    message('Item Tracking lines Cleared');
                end;
            }

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