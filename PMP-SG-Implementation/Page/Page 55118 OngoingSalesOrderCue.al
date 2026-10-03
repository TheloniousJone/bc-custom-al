page 55118 OngoingSalesOrderCuePage
{

    Caption = 'CuePage';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(OngoingSalesOrderCue)
            {
                Caption = 'Ongoing Sales Order';
                field("Ongoing HQ Orders"; Rec."Ongoing HQ Orders")
                {
                    ApplicationArea = all;
                    Caption = 'Ongoing HQ Orders';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }
                field("Ongoing Priority Orders"; Rec."Ongoing Priority Orders")
                {
                    ApplicationArea = all;
                    Caption = 'Ongoing Priority Orders';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";

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
