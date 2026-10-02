page 90006 ChainSOIntegrateCuePage
{

    Caption = 'ChainPharma SO Integration Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(ChainSOIntegrateCueContainer)
            {
                Caption = 'ChainPharma SO Integration';

                field("ChainPharma SO Not Created"; Rec."ChainPharma SO Not Created")
                {
                    ApplicationArea = All;
                    Caption = 'Not Created';
                    Image = Document;
                    DrillDownPageId = "Chain Pharma. PO List";
                }

                field("ChainPharma SO Error"; Rec."ChainPharma SO Error")
                {
                    ApplicationArea = All;
                    Caption = 'Errors';
                    Image = Document;
                    DrillDownPageId = "Chain Pharma. PO List";
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
