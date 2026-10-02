page 50004 "Peg Rate"
{

    ApplicationArea = All;
    Caption = 'Peg Rate';
    PageType = List;
    SourceTable = "Peg Rate";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Type"; Rec."Item Type")
                {
                    ToolTip = 'Specifies the value of the Item Relation field';
                    ApplicationArea = All;
                }

                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field';
                    ApplicationArea = All;
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer Code field';
                    ApplicationArea = All;
                }

                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }

                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }

                field("Peg Rate"; Rec."Peg Rate")
                {
                    ApplicationArea = All;
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Wholesale Price"; Rec."Wholesale Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
