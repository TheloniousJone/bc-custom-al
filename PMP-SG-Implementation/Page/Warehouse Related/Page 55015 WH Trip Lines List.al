page 55015 "WH Trip Lines List"
{

    ApplicationArea = all;
    Caption = 'WH Trip Lines List';
    PageType = List;
    SourceTable = "WH Trip Line";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Line No,"; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Pick Doc No."; Rec."Pick Doc No.")
                {
                    ToolTip = 'Specifies the value of the Pick Doc No. field';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        myInt: Integer;
                        PickCard: Page 5779;
                        PickRec: Record "Warehouse Activity Header";
                    begin
                        PickRec.reset;
                        PickRec.SetRange("No.", Rec."Pick Doc No.");
                        PickCard.SetTableView(PickRec);
                        PickCard.Run();
                    end;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ToolTip = 'Specifies the value of the Source Name field';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field';
                    ApplicationArea = All;
                }
                field("Trolley No."; Rec."Trolley No.")
                {
                    ToolTip = 'Specifies the value of the Trolley No. field';
                    ApplicationArea = All;
                }
                field("Priority Picking"; Rec."Priority Picking")
                {
                    ToolTip = 'Specifies the value of the Priority Picking field';
                    ApplicationArea = All;
                }
                field("Line Completed"; Rec."Line Completed")
                {
                    ToolTip = 'Specifies the value of the Line Completed field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
