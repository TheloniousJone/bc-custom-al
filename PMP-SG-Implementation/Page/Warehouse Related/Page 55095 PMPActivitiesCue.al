page 55095 "PMP Activities Cue"
{

    Caption = 'Company Activities Cue';
    PageType = CardPart;
    SourceTable = RoleCentreCues;

    layout
    {
        area(content)
        {
            cuegroup(CueContainer)
            {
                Caption = 'Activities';
                field("Unapproved PMP SOs"; Rec."Unapproved PMP SOs")
                {
                    ApplicationArea = all;
                    Caption = 'Unapproved SOs';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }
                field("Unapproved PMP SOs no Chain"; Rec."Unapproved PMP SOs no Chain")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unapproved PMP SOs Without Chain field.';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }
                field("Approved PMP SOs"; Rec."Approved PMP SOs")
                {
                    ApplicationArea = all;
                    Caption = 'Approved SOs pending for release.';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }
                field("Released SOs For Picking"; Rec."Released SOs For Picking")
                {
                    ApplicationArea = all;
                    Caption = 'Released SOs to WH for Picking';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }
                field("Partial Delivered SO"; Rec."Partial Delivered SO")
                {
                    ApplicationArea = all;
                    Caption = 'Partial Delivered SO';
                    Image = Document;
                    DrillDownPageId = "Sales Order List";
                }
                field("Sales Return Orders"; Rec."Sales Return Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Return Orders';
                    ToolTip = 'Sales Return Orders.';
                    Image = Document;
                    DrillDownPageId = "Sales Return Order List";
                }



            }
        }
    }

}
