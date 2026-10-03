page 60115 WellySOIntegrateCuePage
{

    Caption = 'Wellaway SO Integration Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(WellySOIntegrateCueContainer)
            {
                Caption = 'Wellaway SO Integration';

                field("Wellaway SO Not Created"; Rec."Wellaway SO Not Created")
                {
                    ApplicationArea = All;
                    Caption = 'Not Created';
                    Image = Document;
                    DrillDownPageId = "Staging Purch Order List Page";
                }

                field("Wellaway SO Error"; Rec."Wellaway SO Error")
                {
                    ApplicationArea = All;
                    Caption = 'Errors';
                    Image = Document;
                    DrillDownPageId = "Staging Purch Order List Page";
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
