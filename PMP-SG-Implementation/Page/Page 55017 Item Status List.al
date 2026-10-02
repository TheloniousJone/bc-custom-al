page 55017 "Item Status List"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Item Status List';
    UsageCategory = Lists;
    SourceTable = "Item Status";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Status Code"; Rec."Status Code")
                {
                    ToolTip = 'Specifies the value of the Status Code field';
                    ApplicationArea = All;
                }
                field("Status Remarks"; Rec."Status Remarks")
                {
                    ToolTip = 'Specifies the value of the Status Remarks field';
                    ApplicationArea = All;
                }
                field("POM2 Status"; Rec."POM2 Status")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("POM2 Status V2"; Rec."POM2 Status V2")
                {
                    ApplicationArea = All;
                    Caption = 'POM2 Status';
                }
                field("POM3 Remarks"; Rec."POM3 Remarks")
                {
                    ApplicationArea = all;
                    Caption = 'POM3 Status';
                }
            }
        }
    }
}