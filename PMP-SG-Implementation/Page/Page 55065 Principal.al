page 55065 Princpal
{

    ApplicationArea = All;
    Caption = 'Principal';
    PageType = List;
    SourceTable = Principal;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("NO EDI"; Rec."NO EDI")
                {
                    ToolTip = 'To Disable EDI for this Principal';
                    ApplicationArea = All; // YF 07 Oct 2022
                }
            }
        }
    }

}
