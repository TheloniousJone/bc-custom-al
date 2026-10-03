page 55102 "Therapeutic Category 1 List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Therapeutic Category 1";

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