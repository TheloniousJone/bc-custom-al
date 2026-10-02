page 56102 "Outgoing ZP PO Header Endpoint"
{

    SourceTable = "Outgoing ZP PO Header";
    Caption = 'Outgoing ZP PO Staging';
    ApplicationArea = All;
    UsageCategory = Lists;
    DelayedInsert = true;
    PageType = Worksheet;
    // AutoSplitKey = true;
    SaveValues = true;
    InsertAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type Code"; Rec."Document Type Code")
                {
                    ApplicationArea = All;
                }
                field("ZP Customer ID"; Rec."ZP Customer ID")
                {
                    ApplicationArea = All;
                }
                field("Record Type"; Rec."Record Type")
                {
                    ApplicationArea = All;
                }
                field("Location Store Code"; Rec."Location Store Code")
                {
                    ApplicationArea = All;
                }
                field("Tender No."; Rec."Tender No.")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Special Instruction"; Rec."Special Instruction")
                {
                    ApplicationArea = All;
                }
                field("Total Line Items"; Rec."Total Line Items")
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                }
                field("Processed Timestamp"; Rec."Processed Timestamp")
                {
                    ApplicationArea = All;
                }
                field("Has Error"; Rec."Has Error")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Actions here
    }

}
