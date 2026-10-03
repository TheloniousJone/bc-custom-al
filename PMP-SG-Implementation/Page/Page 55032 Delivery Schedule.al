page 55032 "Delivery Schedule"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Delivery Schedule";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {

                field("Cust No."; Rec."Cust No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ApplicationArea = all;
                }
                field(Monday; Rec.Monday)
                {
                    ApplicationArea = all;
                }

                field(Tuesday; Rec.Tuesday)
                {
                    ApplicationArea = all;
                }
                field(Wednesday; Rec.Wednesday)
                {
                    ApplicationArea = all;
                }
                field(Thursday; Rec.Thursday)
                {
                    ApplicationArea = all;
                }
                field(Friday; Rec.Friday)
                {
                    ApplicationArea = all;
                }
                field(Saturday; Rec.Saturday)
                {
                    ApplicationArea = all;
                }
                field(Sunday; Rec.Sunday)
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