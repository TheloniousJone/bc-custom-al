page 55083 "Customer Commission Group"
{

    ApplicationArea = All;
    Caption = 'Customer Commission Group';
    PageType = List;
    SourceTable = "Customer Commission Group";
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
