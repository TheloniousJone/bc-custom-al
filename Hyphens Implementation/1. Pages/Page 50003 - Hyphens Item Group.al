page 50003 "Hyphens Item Group"
{
    ApplicationArea = All;
    Caption = 'Hyphens Item Group';
    PageType = List;
    SourceTable = "Hyphens Item Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
