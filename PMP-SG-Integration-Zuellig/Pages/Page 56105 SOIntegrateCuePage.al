page 56105 ZPIntegrateCuePage
{

    Caption = 'ZP Integration Cue Page';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(ZPIntegrateCueContainer)
            {
                Caption = 'ZP Integration';

                field("ZP PO PRO Not Processed"; Rec."ZP PO PRO Not Processed")
                {
                    ApplicationArea = All;
                    Caption = 'PO Not Processed';
                    Image = Document;
                    DrillDownPageId = "Outgoing ZP PO Header Endpoint";
                }

                field("ZP PO PRO Error"; Rec."ZP PO PRO Error")
                {
                    ApplicationArea = All;
                    Caption = 'PO Error';
                    Image = Document;
                    DrillDownPageId = "Outgoing ZP PO Header Endpoint";
                }

                field("ZP ASN Not Processed"; Rec."ZP ASN Not Processed")
                {
                    ApplicationArea = All;
                    Caption = 'PO Batch Not Processed';
                    Image = Document;
                    DrillDownPageId = "Zuellig Invoice ASN Entries";
                }

                field("ZP ASN Error"; Rec."ZP ASN Error")
                {
                    ApplicationArea = All;
                    Caption = 'PO Batch Error';
                    Image = Document;
                    DrillDownPageId = "Zuellig Invoice ASN Entries";
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
