page 55024 "Accpac List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Accpac;
    Caption = 'Accpac List';
    InsertAllowed = true;
    PromotedActionCategories = 'New';

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Accpac Code"; Rec."Accpac Code")
                {
                    ToolTip = 'Specifies the value of the Accpac Code field';
                    ApplicationArea = All;
                }
                field("Accpac Name"; Rec."Accpac Name")
                {
                    ToolTip = 'Specifies the value of the Accpac Name field';
                    ApplicationArea = All;

                }
            }
        }

    }
}