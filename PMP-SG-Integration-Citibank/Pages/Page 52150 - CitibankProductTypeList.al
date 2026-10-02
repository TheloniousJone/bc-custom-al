page 52150 "Citibank Product Type List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Citibank Product Type";
    Caption = 'Citibank Product Type List';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("DBS Product Type"; Rec."Citibank Product Type")
                {
                    ApplicationArea = All;
                }

                field("DBS Product Description"; Rec."Citibank Product Description")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

}
