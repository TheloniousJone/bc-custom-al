page 55125 ItemRestrictions
{
    ApplicationArea = All;
    Caption = 'ItemRestrictions';
    PageType = List;
    SourceTable = ItemRestrictions;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(RestrictionName; Rec.RestrictionName)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
