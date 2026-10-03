pageextension 70204 GeneralJournal extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(Reporting)
        {
            action(Print)
            {
                ApplicationArea = All;
                Image = Print;
                Caption = 'Print...';
                Visible = CustomizedVisible;

                trigger OnAction()
                var
                    lrec_GJL: Record "Gen. Journal Line";
                begin
                    lrec_GJL.Reset();
                    lrec_GJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                    lrec_GJL.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    lrec_GJL.SetRange("Document No.", Rec."Document No.");
                    if lrec_GJL.FindSet() then begin
                        Report.RunModal(70061, true, false, lrec_GJL);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}