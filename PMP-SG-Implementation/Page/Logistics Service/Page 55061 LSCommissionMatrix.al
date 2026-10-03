page 55061 "LS Commission Matrix"
{

    ApplicationArea = All;
    Caption = 'LS Commission Matrix';
    PageType = List;
    SourceTable = "LS Commission Matrix";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field';
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}
