page 55105 "Therapeutic Category 4 List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Therapeutic Category 4";

    layout
    {
        area(Content)
        {
            Repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}