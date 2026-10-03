page 55093 "SO No Stock Qty List"
{

    ApplicationArea = All;
    Caption = 'Sales Line Out of Stock List';
    PageType = List;
    SourceTable = "Sales Line";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }

                field("Out of Stock"; Rec."Out of Stock")
                {
                    ApplicationArea = All;
                }

                field("Insufficient Stocks in Pick"; Rec."Insufficient Stocks in Pick")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetRange("Out of Stock", true);
        // Rec.SetFilter("No.", '<>%1', '');
        // Rec.SetFilter(Quantity, '<>%1', 0);
    end;

}
