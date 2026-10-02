page 69007 "VF Staging Arch Subform"
{
    // AutoSplitKey = true;
    Caption = 'VF Staging Delivery Archive Details';
    // DelayedInsert = true;
    LinksAllowed = false;
    // MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Staging VF Task Line Archive";

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Details)
            {
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }

                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                }

                field("Sales Invoice Line No."; Rec."Sales Invoice Line No.")
                {
                    ApplicationArea = All;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }

                field(Qty; Rec.Qty)
                {
                    ApplicationArea = All;
                }

                // KP 18 Oct 2023
                field("Qty. Delivered"; Rec."Qty. Delivered")
                {
                    ApplicationArea = All;
                }
                field("Qty. Returned"; Rec."Qty. Returned")
                {
                    ApplicationArea = All;
                }
                //KP 18 Oct 2023
                field(UOM; Rec.UOM)
                {
                    ApplicationArea = All;
                }

                field("Item Check Method"; Rec."Item Check Method")
                {
                    ApplicationArea = All;
                }

                field("Item Unload Check Method"; Rec."Item Unload Check Method")
                {
                    ApplicationArea = All;
                }

                field("VF Task ID"; Rec."VF Task ID")
                {
                    ApplicationArea = All;
                }

                field("VF Task GUID"; Rec."VF Task GUID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("VF Line ID"; Rec."VF Line ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("VF Task Item ID"; Rec."VF Task Item ID")
                {
                    ApplicationArea = All;
                }

                field("VF Task Completion History ID"; Rec."VF Task Completion History ID")
                {
                    ApplicationArea = All;
                }

                field("VF Actual Qty Processed"; Rec."VF Actual Qty Processed")
                {
                    ApplicationArea = All;
                }

                field("VF Driver Reason"; Rec."VF Driver Reason")
                {
                    ApplicationArea = All;
                }

                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                }

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }

                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                }

                field("Created Timestamp"; Rec."Created Timestamp")
                {
                    ApplicationArea = All;
                }

                field("Updated Timestamp"; Rec."Updated Timestamp")
                {
                    ApplicationArea = All;
                }

                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
