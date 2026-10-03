page 90009 "Buyer Code Chain Mapping"
{

    ApplicationArea = All;
    Caption = 'Buyer Code Chain Mapping';
    PageType = List;
    SourceTable = "Buyer Code Chain Mapping";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Chain Code"; Rec."Chain Code")
                {
                    ApplicationArea = All;
                }

                field("Buyer Code"; Rec."Buyer Code")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
