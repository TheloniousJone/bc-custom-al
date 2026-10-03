page 69008 VersaCues
{

    Caption = 'VersaFleet';
    PageType = CardPart;
    SourceTable = "Staging VF Task Header";
    layout
    {
        area(content)
        {
            cuegroup(VersaFleet)
            {
                field("Todays Drop"; Rec."Todays Drop")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Todays Drop field.';
                    Image = Document;
                    DrillDownPageId = "VF Staging Delivery Task List";
                }
                field("Completed Task"; Rec."Completed Task")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Completed Task field.';
                    Image = Document;
                    DrillDownPageId = "VF Staging Delivery Task List";
                }
                field("Pending Task"; Rec."Pending Task")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pending Task field.';
                    Image = Document;
                    DrillDownPageId = "VF Staging Delivery Task List";
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        // if no row in the cue table, create and save one!  Only ever one row in a table holding cue data!
        Rec.Reset();
        If not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        Rec.SetFilter("Current Date Filter", '%1', WorkDate());  // workdate is todays date in our system


    end;
}