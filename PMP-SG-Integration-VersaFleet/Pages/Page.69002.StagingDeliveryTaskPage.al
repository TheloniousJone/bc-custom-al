page 69002 "VF Staging Delivery Task Page"
{

    Caption = 'VF Staging Delivery Task Page';
    PageType = Document;
    SourceTable = "Staging VF Task Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field("Tracking ID"; Rec."Tracking ID")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Customer Group"; Rec."Customer Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                }

                field("Time From Text"; Rec."Time From Text")
                {
                    ApplicationArea = All;
                }

                field("Time To Text"; Rec."Time To Text")
                {
                    ApplicationArea = All;
                }

                field("Time Type"; Rec."Time Type")
                {
                    ApplicationArea = All;
                }

                field(COD; Rec.COD)
                {
                    ApplicationArea = All;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }

                // YF 27 Jun 2022
                field("Source Delivery Charge"; Rec."Source Delivery Charge")
                {
                    ApplicationArea = All;
                }
                // YF 27 Jun 2022

                field("Service Time"; Rec."Service Time")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Name"; Rec."Delivery Address Name")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Line 1"; Rec."Delivery Address Line 1")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Line 2"; Rec."Delivery Address Line 2")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address City"; Rec."Delivery Address City")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Country"; Rec."Delivery Address Country")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Zip"; Rec."Delivery Address Zip")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Email"; Rec."Delivery Address Email")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Contact Name"; Rec."Delivery Address Contact Name")
                {
                    ApplicationArea = All;
                }

                field("Delivery Address Contact No."; Rec."Delivery Address Contact No.")
                {
                    ApplicationArea = All;
                }

                field("Driver Tag"; Rec."Driver Tag")
                {
                    ApplicationArea = All;
                }

                field("Vehicle Tag"; Rec."Vehicle Tag")
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
                }

                field("VF Task State"; Rec."VF Task State")
                {
                    ApplicationArea = All;
                }

                // YF 05 Dec 2022
                field("VF Task State Type"; Rec."VF Task State Type")
                {
                    ApplicationArea = All;
                }
                // YF 05 Dec 2022

                field("VF Task State Updated"; Rec."VF Task State Updated")
                {
                    ApplicationArea = All;
                }

                field("VF Is Partial Success"; Rec."VF Is Partial Success")
                {
                    ApplicationArea = All;
                }

                field("VF Driver Notes"; Rec."VF Driver Notes")
                {
                    ApplicationArea = All;
                }

                field("VF Job ID"; Rec."VF Job ID")
                {
                    ApplicationArea = All;
                }

                field("VF Job GUID"; Rec."VF Job GUID")
                {
                    ApplicationArea = All;
                }

                field("VF Delivery Address Id"; Rec."VF Delivery Address Id")
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

                // YF 20 Jun 2022
                field("Delivered Remarks"; Rec."Delivered Remarks")
                {
                    ApplicationArea = All;
                }

                // YF 27 Jun 2022
                field("Delivered Delivery Charge"; Rec."Delivered Delivery Charge")
                {
                    ApplicationArea = All;
                }
                // YF 27 Jun 2022

                field("Delivered Driver Tag"; Rec."Delivered Driver Tag")
                {
                    ApplicationArea = All;
                }

                field("Delivered Date Text"; Rec."Delivered Date Text")
                {
                    ApplicationArea = All;
                }

                field("Delivered Date"; Rec."Delivered Date")
                {
                    ApplicationArea = All;
                }

                field("Latest Failure Reason"; Rec."Latest Failure Reason")
                {
                    ApplicationArea = All;
                }

                field("Force Delivery Status Check"; Rec."Force Delivery Status Check")
                {
                    ApplicationArea = All;
                }
                // YF 20 Jun 2022

                // YF 21 Jul 2022
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ApplicationArea = All;
                }
                // YF 21 Jul 2022

                // YF 14 Sep 2022
                field("Response Message"; Rec."Response Message")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = DebugMode;
                }
                // YF 14 Sep 2022
                // KP 18 Oct 2023
                field("Return Order Created"; Rec."Return Order Created")
                {
                    ApplicationArea = All;
                }
                field("Return Order No."; Rec."Return Order No.")
                {
                    ApplicationArea = All;
                }
                //KP 18 Oct 2023
            }
            part(StagingDeliveryLines; "VF Staging Delivery Subform")
            {
                ApplicationArea = All;
                Caption = 'Delivery Details';
                SubPageLink = "Parent Entry No." = FIELD("Entry No.");
                UpdatePropagation = Both;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if VFSetup.Get then
            DebugMode := VFSetup."Debug Mode";
    end;

    var
        VFSetup: Record "VersaFleet Integration Setup";
        DebugMode: Boolean;
}
