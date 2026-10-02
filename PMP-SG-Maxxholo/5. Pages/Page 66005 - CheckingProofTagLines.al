page 66005 "Checking Proof Tag Lines"
{
    AutoSplitKey = true;
    Caption = 'Checking Proof Tag Lines';
    PageType = List;
    SourceTable = "Checking Proof Tag Line";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
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