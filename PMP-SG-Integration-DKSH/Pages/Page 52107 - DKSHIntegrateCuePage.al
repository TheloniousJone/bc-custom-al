page 52107 DKSHIntegrateCuePage
{

    Caption = 'DKSH Integration Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(DKSHIntegrateCueContainer)
            {
                Caption = 'DKSH Integration';

                field("DKSH PO Not Processed"; Rec."DKSH PO Not Processed")
                {
                    ApplicationArea = All;
                    Caption = 'PO Not Processed';
                    Image = Document;
                    DrillDownPageId = "DKSH Staging Outgoing PO List";
                }

                field("DKSH PO Error"; Rec."DKSH PO Error")
                {
                    ApplicationArea = All;
                    Caption = 'PO Error';
                    Image = Document;
                    DrillDownPageId = "DKSH Staging Outgoing PO List";
                }

                field("DKSH Rcpt. Not Processed"; Rec."DKSH Rcpt. Not Processed")
                {
                    ApplicationArea = All;
                    Caption = 'Purch. Rcpt. Not Processed';
                    Image = Document;
                    DrillDownPageId = "DKSH Staging Incoming PR List";
                }

                field("DKSH Rcpt. Error"; Rec."DKSH Rcpt. Error")
                {
                    ApplicationArea = All;
                    Caption = 'Purch. Rcpt. Error';
                    Image = Document;
                    DrillDownPageId = "DKSH Staging Incoming PR List";
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
