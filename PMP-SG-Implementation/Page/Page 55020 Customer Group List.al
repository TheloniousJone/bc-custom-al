page 55020 "Customer Group List"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Customer Group List';
    UsageCategory = Lists;
    SourceTable = "Customer Group";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Customer Group"; Rec."Customer Group")
                {
                    ToolTip = 'Specifies the value of the Customer Group field';
                    ApplicationArea = All;

                }
            }
        }
    }
}