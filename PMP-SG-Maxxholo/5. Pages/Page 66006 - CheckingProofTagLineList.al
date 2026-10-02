page 66006 "Checking Proof Tag Line List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checking Proof Tag Line";
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Doc Line No."; Rec."Doc Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Scan URL"; Rec."Scan URL")
                {
                    ApplicationArea = All;
                }
                field("Proof Tag Reference"; Rec."Proof Tag Reference")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
}