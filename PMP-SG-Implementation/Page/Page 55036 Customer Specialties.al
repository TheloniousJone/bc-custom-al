page 55036 "Customer Specialties"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Customer Specialties";

    layout
    {
        area(Content)
        {
            REpeater(General)
            {
                field("Cust No."; Rec."Cust No.")
                {
                    ApplicationArea = All;

                }
                field("Specialty Code"; Rec."Specialty Code")
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