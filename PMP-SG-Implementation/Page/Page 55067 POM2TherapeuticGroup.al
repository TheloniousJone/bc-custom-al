page 55067 "POM2 Therapeutic Group"
{
    
    ApplicationArea = All;
    Caption = 'POM2 Therapeutic Group';
    PageType = List;
    SourceTable = "POM2 Therapeutic";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Therapeutic ID"; Rec."Therapeutic ID")
                {
                    ToolTip = 'Specifies the value of the Therapeutic ID field';
                    ApplicationArea = All;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
