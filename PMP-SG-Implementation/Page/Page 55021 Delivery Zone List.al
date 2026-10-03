page 55021 "Delivery Zone List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Delivery Zone";
    Caption = 'Delivery Zone List';

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ToolTip = 'Specifies the value of the Delivery Zone field';
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
            }
        }
    }
}