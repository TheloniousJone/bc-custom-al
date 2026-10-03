page 56002 "ETag Bin Mapping"
{

    SourceTable = "ETag Bin Mapping";
    Caption = 'ETag Bin Mapping';
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    PageType = Worksheet;
    // AutoSplitKey = true;
    // SaveValues = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                // ShowCaption = false;
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field("ETag ID"; Rec."ETag ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // actions here
    }

}
