page 55019 "Administration Route List"
{
    ApplicationArea = All;
    Caption = 'Administration Route List';
    PageType = List;
    SourceTable = "Administration";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field(Administration; Rec.Administration)
                {
                    ToolTip = 'Specifies the value of the Administration field';
                    ApplicationArea = All;
                }
            }
        }
    }
}