page 55030 "Basket List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Basket;
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = all;
                    //Editable = false;
                }
                field("Cold Room"; Rec."Cold Room")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
    var
        PMPCU: Codeunit "Warehouse CU";
}