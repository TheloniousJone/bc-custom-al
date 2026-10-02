page 55054 "WH Stock Take Card"
{
    
    Caption = 'WH Stock Take Card';
    PageType = Card;
    SourceTable = "WH Stk Take Header";
    
    layout
    {
        area(content)
        {
            group(General)
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
