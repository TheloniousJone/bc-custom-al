page 90002 "Cust. Chain Location Mapping"
{

    ApplicationArea = All;
    Caption = 'Cust. Chain Location Mapping';
    PageType = List;
    SourceTable = "Cust. Chain Location Mapping";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field';
                    ApplicationArea = All;
                    DrillDownPageId = "Customer List";
                }
                field("Chain Code"; Rec."Chain Code")
                {
                    ToolTip = 'Specifies the value of the Chain Code field';
                    ApplicationArea = All;
                }
                field("Item Ref Customer No."; Rec."Item Ref Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer Code for Item Reference usage';
                    ApplicationArea = All;
                }
                field("Chain Location Code"; Rec."Chain Location Code")
                {
                    ToolTip = 'Specifies the value of the Chain Location Code field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
