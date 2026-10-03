page 70001 I9G_DistrictList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = I9G_Districts;
    Caption = 'Districts';

    layout
    {
        area(Content)
        {
            repeater("Districts")
            {
                field(I9G_DistrictCode; Rec.I9G_DistrictCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the District Code field.';
                }
                field(I9G_DistrictpDescription; Rec.I9G_DistrictpDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the District Description field.';
                }
            }
        }
    }
}