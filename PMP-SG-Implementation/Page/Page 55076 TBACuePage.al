page 55076 TBACuePage
{

    Caption = 'TBA Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(TBACueContainer)
            {
                Caption = 'TBA';
                field(UnprintedTBADel; Rec.UnprintedTBADel)
                {
                    ApplicationArea = all;
                    Caption = 'Unprinted TBA DOs.';
                    Image = Document;
                    DrillDownPageId = "TBA Ledger Entry";

                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.get then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}
