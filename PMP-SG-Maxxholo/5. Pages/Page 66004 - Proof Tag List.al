page 66004 "Proof Tag List"
{
    /*
    PageType = API;
    APIPublisher = 'I9';
    APIGroup = 'api';
    APIVersion = 'v1.0';

    EntityName = 'prooftag';
    EntitySetName = 'prooftags';
    EntityCaption = 'Proof Tag';
    EntitySetCaption = 'Proof Tags';
    */

    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Proof Tag";
    PageType = List;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(EN; Rec.EN)
                {
                    ApplicationArea = All;
                }
                field(EV_DATE; Rec.EV_DATE)
                {
                    ApplicationArea = All;
                }
                field(TARGET_SITE_ID; Rec.TARGET_SITE_ID)
                {
                    ApplicationArea = All;
                }
                field(REFERENCE; Rec.REFERENCE)
                {
                    ApplicationArea = All;
                }
                field(EVT_DATA1; Rec.EVT_DATA1)
                {
                    ApplicationArea = All;
                }
                field(EVT_DATA2; Rec.EVT_DATA2)
                {
                    ApplicationArea = All;
                }
                field(EVT_DATA3; Rec.EVT_DATA3)
                {
                    ApplicationArea = All;
                }
                field(EVT_DATA4; Rec.EVT_DATA4)
                {
                    ApplicationArea = All;
                }
                field(EVT_DATA5; Rec.EVT_DATA5)
                {
                    ApplicationArea = All;
                }
                field(EVT_DATA6; Rec.EVT_DATA6)
                {
                    ApplicationArea = All;
                }
                field(EXPORTED; Rec.EXPORTED)
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}