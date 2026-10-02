page 55011 "WH Trip List"
{

    ApplicationArea = All;
    Caption = 'WH Trip List';
    PageType = List;
    SourceTable = "WH Trip Header";
    UsageCategory = Lists;
    CardPageId = "WH Trip Card";
    InsertAllowed = false;
    SourceTableView = sorting("No.") order(descending);
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Picker; Rec.Picker)
                {
                    ToolTip = 'Specifies the value of the Picker field';
                    ApplicationArea = All;
                }

                field("Trip Start"; Rec."Trip Start")
                {
                    ToolTip = 'Specifies the value of the Start field';
                    ApplicationArea = All;
                }
                field("Trip End"; Rec."Trip End")
                {
                    ToolTip = 'Specifies the value of the End field';
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //DX        30 Aug 2021
        //Rec.FilterGroup(2);
        //Rec.SetFilter(Picker, '%1|%2', '', EnhanceCU.GetUsername(UserSecurityId()));
        //Rec.FilterGroup(0);
        //DX        30 Aug 2021
        rec.SetFilter(SystemCreatedBy, '%1', UserSecurityId());
    end;

    var
        enhanceCU: Codeunit "PMP-Enhancements";
}
