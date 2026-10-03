page 55122 "Sales Target BU"
{
    ApplicationArea = All;
    Caption = 'Sales Target BU';
    PageType = List;
    SourceTable = "Sales Target BU";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BU Code"; Rec."BU Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BU Code field.';
                }
                field("BU Name"; Rec."BU Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BU Name field.';
                }
            }
        }
    }

}