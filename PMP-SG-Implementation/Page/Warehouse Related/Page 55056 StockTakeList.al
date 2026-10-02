page 55056 "Stock Take List"
{

    ApplicationArea = All;
    Caption = 'Stock Take List';
    PageType = List;
    SourceTable = "WH Stk Take Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field("Stock Take Doc No."; Rec."Stock Take Doc No.")
                {
                    ToolTip = 'Specifies the value of the Stock Take Doc No. field';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    ApplicationArea = All;
                }
                field("Register Date"; Rec."Register Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                    ApplicationArea = All;
                }
                field("Assigned User"; Rec."Assigned User")
                {
                    ToolTip = 'Specifies the value of the Assigned User field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
