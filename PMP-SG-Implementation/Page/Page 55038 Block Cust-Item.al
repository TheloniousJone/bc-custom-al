page 55038 "Block Cust-Item"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Blocked Cust-Item";
    Caption = 'Blocked Customer-Item Mapping';

    layout
    {
        area(Content)
        {
            Repeater(General)
            {
                field("Cust No."; Rec."Cust No.")
                {
                    ApplicationArea = All;

                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
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

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}