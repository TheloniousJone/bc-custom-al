page 60103 "Prescription Line"
{

    ApplicationArea = All;
    Caption = 'Prescription Line';
    PageType = Card;
    SourceTable = "Sales Line";
    UsageCategory = Lists;
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Presc. Desc"; Rec."Presc. Desc")
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
                field("Presc. Desc 2"; Rec."Presc. Desc 2")
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }

}
