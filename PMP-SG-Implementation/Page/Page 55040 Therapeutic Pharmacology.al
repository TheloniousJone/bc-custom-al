page 55040 "Therapeutic Pharmacology"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Therapeutic Pharmacology";

    layout
    {
        area(Content)
        {
            Repeater(General)
            {
                field("Therapeutic Group No."; Rec."Therapeutic Group No.")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                //DX        22 Aug 2021
                field("Is Poisonous"; Rec."Is Poisonous")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                //DX        22 Aug 2021
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