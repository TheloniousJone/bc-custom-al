page 55023 "Sales Area List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Area";
    Caption = 'Sales Area List';

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;

                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ToolTip = 'Specifies the value of the Sales Area field';
                    ApplicationArea = All;
                }
            }
        }
    }
}