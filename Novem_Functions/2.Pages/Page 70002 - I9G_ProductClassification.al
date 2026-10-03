page 70002 I9G_ProductClassificationList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = I9G_ProductClassifications;
    Caption = 'Device/Product Classifications';

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(I9G_ProductClassficationCode; Rec.I9G_ProductClassficationCode)
                {
                    ApplicationArea = All;
                }
                field(I9G_ProductClassificationDesc; Rec.I9G_ProductClassificationDesc)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}