page 56103 "Outgoing ZP PO Line Endpoint"
{

    SourceTable = "Outgoing ZP PO Line";
    Caption = 'Outgoing ZP PO Detail Staging';
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
                field("No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type Code"; Rec."Document Type Code")
                {
                    ApplicationArea = All;
                }
                field("Record Type"; Rec."Record Type")
                {
                    ApplicationArea = All;
                }
                field("Customer Item Code"; Rec."Customer Item Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Item Descr"; Rec."Customer Item Descr")
                {
                    ApplicationArea = All;
                }
                field("Customer Item UOM"; Rec."Customer Item UOM")
                {
                    ApplicationArea = All;
                }
                field("ZP Item Code"; Rec."ZP Item Code")
                {
                    ApplicationArea = All;
                }
                field("Commercial Qty"; Rec."Commercial Qty")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Bonus 1 Cust Item Code"; Rec."Bonus 1 Cust Item Code")
                {
                    ApplicationArea = All;
                }
                field("Bonus 1 ZP Item Code"; Rec."Bonus 1 ZP Item Code")
                {
                    ApplicationArea = All;
                }
                field("Bonus 1 Qty"; Rec."Bonus 1 Qty")
                {
                    ApplicationArea = All;
                }
                field("Bonus 2 Cust Item Code"; Rec."Bonus 2 Cust Item Code")
                {
                    ApplicationArea = All;
                }
                field("Bonus 2 ZP Item Code"; Rec."Bonus 2 ZP Item Code")
                {
                    ApplicationArea = All;
                }
                field("Bonus 2 Qty"; Rec."Bonus 2 Qty")
                {
                    ApplicationArea = All;
                }
                field("Bonus 3 Cust Item Code"; Rec."Bonus 3 Cust Item Code")
                {
                    ApplicationArea = All;
                }
                field("Bonus 3 ZP Item Code"; Rec."Bonus 3 ZP Item Code")
                {
                    ApplicationArea = All;
                }
                field("Bonus 3 Qty"; Rec."Bonus 3 Qty")
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
