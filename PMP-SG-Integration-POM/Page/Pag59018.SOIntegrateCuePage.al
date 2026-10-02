page 59018 POMSOIntegrateCuePage
{

    Caption = 'POM SO Integration Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(POMSOIntegrateCueContainer)
            {
                Caption = 'POM SO Integration';

                field("POM SO Not Created"; Rec."POM SO Not Created")
                {
                    ApplicationArea = All;
                    Caption = 'Not Created';
                    Image = Document;
                    DrillDownPageId = "POM2 Order List";
                }

                field("POM SO Error"; Rec."POM SO Error")
                {
                    ApplicationArea = All;
                    Caption = 'SO Errors';
                    Image = Document;
                    DrillDownPageId = "POM2 Order List";
                }
                //DX        27 Sept 2021
                field("POM SO Lines Error"; Rec."POM SO Error")
                {
                    ApplicationArea = All;
                    Caption = 'Line Errors';
                    Image = Document;
                    DrillDownPageId = "POM2 Detail List";
                }
                //DX        27 Sept 2021
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
