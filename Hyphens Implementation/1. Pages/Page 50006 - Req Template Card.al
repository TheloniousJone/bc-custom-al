page 50006 "Requirement Template Card"
{
    // version I9

    Caption = 'Requirement Template Card';
    PageType = Card;
    SourceTable = "Requirement Template";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                }
            }

            group(Details)
            {
                Caption = 'Details';

                field("Shelf Life Requirement"; Rec."Shelf Life Requirement")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Marking Requirement"; Rec."Marking Requirement")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Packing Requirement"; Rec."Packing Requirement")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }

                field("Document Requirement"; Rec."Document Requirement")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }

        }
    }

}

