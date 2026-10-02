page 70000 I9G_ItemGroupCodeList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = I9G_ItemGroups;
    Caption = 'Item Groups';

    layout
    {
        area(Content)
        {
            repeater("Item Groups")
            {
                field(I9G_ItemGroupCode; Rec.I9G_ItemGroupCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Group Code field.';
                }
                field(I9G_ItemGroupDescription; Rec.I9G_ItemGroupDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Group Description field.';
                }
            }
        }
    }
}