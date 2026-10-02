page 55109 "TBA Ledger Entry Archive"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TBA Ledger Entry Archive";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field("Apply To Doc No."; Rec."Apply To Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Remaining Qty"; Rec."Remaining Qty")
                {
                    ApplicationArea = all;
                }
                //DX        01 July 2021
                field("Bin Remarks"; Rec."Bin Remarks")
                {
                    ApplicationArea = all;
                }
                //DX        01 July 2021
                //DX        04 July 2021
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = all;
                }
                field("Cage No."; Rec."Cage No.")
                {
                    ApplicationArea = all;
                    Caption = 'Delivery Zone';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }
                field("Shipping Packages"; Rec."Shipping Packages")
                {
                    ApplicationArea = all;
                }
                //DX        04 July 2021
                //DX        31 Aug 2021
                field("TBA Printed"; Rec."TBA Printed")
                {
                    ApplicationArea = all;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ApplicationArea = all;
                }
                //DX        31 Aug 2021

            }
        }
    }

}