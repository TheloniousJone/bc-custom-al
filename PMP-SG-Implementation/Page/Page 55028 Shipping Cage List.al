page 55028 "Shipping Cage List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shipping Cages";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field(Rec; Rec."Shipping Cage Code")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}