page 50005 "Requirement Template List"
{
    Caption = 'Requirement Template List';
    CardPageID = "Requirement Template Card";
    PageType = List;
    SourceTable = "Requirement Template";
    UsageCategory = Lists; // Searchable Option
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                }

                field("Shelf Life Requirement"; Rec."Shelf Life Requirement")
                {
                    ApplicationArea = All;
                    // MultiLine = true;
                }

                field("Marking Requirement"; Rec."Marking Requirement")
                {
                    ApplicationArea = All;
                    // MultiLine = true;
                }

                field("Packing Requirement"; Rec."Packing Requirement")
                {
                    ApplicationArea = All;
                    // MultiLine = true;
                }

                field("Document Requirement"; Rec."Document Requirement")
                {
                    ApplicationArea = All;
                    // MultiLine = true;
                }
            }
        }
    }

}

