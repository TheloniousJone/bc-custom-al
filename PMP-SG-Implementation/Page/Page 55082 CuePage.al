page 55082 CuePage
{

    Caption = 'CuePage';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(CueContainer)
            {
                Caption = 'Dashboard';
                field(UnpickedPL; Rec.UnpickedPL)
                {
                    ApplicationArea = all;
                    Caption = 'Unprocessed Pick Lists';
                    Image = Document;
                    DrillDownPageId = "Assignment List";
                }
                field("Wellaway TO"; Rec."Wellaway TO")
                {
                    ApplicationArea = all;
                    Caption = 'Unprocessed Wellaway Transfers.';
                    Image = Document;
                    DrillDownPageId = "Transfer Orders";
                }
                field("Pending Wellaway TO to receive"; Rec."Pending Wellaway TO to receive")
                {
                    ApplicationArea = all;
                    Caption = 'Pending Wellaway Receipts';
                    Image = Document;
                    DrillDownPageId = "Transfer Orders";
                }
                field("SRO Returns for Rebill"; Rec."SRO Returns for Rebill")
                {
                    ApplicationArea = all;
                    Caption = 'Unprocessed Rebill SROs';
                    DrillDownPageId = "Sales Return Order List";
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
