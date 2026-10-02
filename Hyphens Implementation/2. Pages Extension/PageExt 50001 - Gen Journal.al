pageextension 50001 GenJL extends "General Journal"
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

                trigger OnAction()
                var
                    lrec_GJL: Record "Gen. Journal Line";
                begin
                    lrec_GJL.Reset();
                    lrec_GJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                    lrec_GJL.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if lrec_GJL.FindSet() then begin
                        Report.RunModal(50003, true, false, lrec_GJL);
                    end;
                end;
            }

            //KM20210315 - Start
            action(ImportBIPO)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Import BIPO';

                trigger OnAction()
                var
                    lcdu_HyphensCU: Codeunit "Hyphens CU";
                    temp: Record "Temp Table";
                    lpg_Dialog: Page ImportBIPO;
                    lrec_GJL: Record "Gen. Journal Line";
                begin
                    //KM20210405 - Start
                    // Clear(lcdu_HyphensCU);
                    // lcdu_HyphensCU.ImportBIPO(Rec."Journal Template Name", Rec."Journal Batch Name");
                    Clear(lpg_Dialog);
                    CurrPage.SetSelectionFilter(lrec_GJL);
                    lpg_Dialog.SetTableView(lrec_GJL);
                    lpg_Dialog.Run();
                    //KM20210405 - End
                end;
            }
            //KM20210315 - End
        }
    }

    var

}