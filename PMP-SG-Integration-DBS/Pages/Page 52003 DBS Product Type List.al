page 52003 "DBS Product Type List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "DBS Product Type";
    Caption = 'DBS Product Type List';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("DBS Product Type"; Rec."DBS Product Type")
                {
                    ApplicationArea = All;
                }

                field("DBS Product Description"; Rec."DBS Product Description")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

}
