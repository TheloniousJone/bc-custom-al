page 56001 "Event Log"
{

    SourceTable = "EPaper API Event Log";
    Caption = 'EPaper API Event Log';
    ApplicationArea = All;
    UsageCategory = Administration;
    // DelayedInsert = false;
    PageType = Worksheet;
    // AutoSplitKey = true;
    // SaveValues = true;
    InsertAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                }
                field("API URL"; Rec."API URL")
                {
                    ApplicationArea = All;
                }
                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                }
                field("Error Code"; Rec."Error Code")
                {
                    ApplicationArea = All;
                }
                field("Event Date Time"; Rec."Event Date Time")
                {
                    ApplicationArea = All;
                }
                field("Data ID"; Rec."Data ID")
                {
                    ApplicationArea = All;
                }
                field("Colour ID"; Rec."Colour ID")
                {
                    ApplicationArea = All;
                }
                field("Timer in Seconds"; Rec."Timer in Seconds")
                {
                    ApplicationArea = All;
                }
                field("Data Type"; Rec."Data Type")
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
                field(UserId; Rec.UserId)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Delete All Entries")
                {
                    ApplicationArea = all;
                    Caption = 'Delete All Entries';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Delete;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "EPaper Integrations";
                    begin
                        IntegrationCU.DeleteAllEventLogEntries(false);
                    end;
                }

            }

        }
    }

}
