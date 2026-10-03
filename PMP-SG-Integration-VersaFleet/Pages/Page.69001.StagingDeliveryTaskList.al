page 69001 "VF Staging Delivery Task List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'VersaFleet Staging Delivery List';
    CardPageID = "VF Staging Delivery Task Page";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    SourceTable = "Staging VF Task Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Response Message"; Rec."Response Message")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Response Message field.';
                    Visible = false;
                }
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

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Created At';
                    Editable = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Modified At';
                    Editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Modified By';
                    Editable = false;
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

                field("Internal Job Tracking No."; Rec."Internal Job Tracking No.")
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


            }
        }
    }

    actions
    {
        // actions here
        area(Processing)
        {
            group(Process)
            {
                action("Run Delivery Task Job Queue")
                {
                    ApplicationArea = all;
                    Caption = 'Run Delivery Task Job Queue';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Delivery;
                    PromotedCategory = Process;
                    // RunObject = report 69000;

                    trigger OnAction()
                    var
                        StagingRec: Record "Staging VF Task Header";
                        SyncReport: Report "VersaFleet Send Delivery Tasks";
                    begin
                        /*
                        CurrPage.SetSelectionFilter(StagingRec);
                        Report.RunModal(69000, true, false, StagingRec);
                       */
                        CurrPage.SetSelectionFilter(StagingRec);
                        SyncReport.SetTableView(StagingRec);
                        SyncReport.Run();
                        CurrPage.Update(false);
                        Message('Run completed');

                    end;
                }

                action("Check Delivery Status Job Queue")
                {
                    ApplicationArea = all;
                    Caption = 'Check Delivery Status Job Queue';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Delivery;
                    PromotedCategory = Process;
                    // RunObject = report 69000;

                    trigger OnAction()
                    var
                        StagingRec: Record "Staging VF Task Header";
                        SyncReport: Report "VersaFleet Check Task Status";
                    begin
                        Clear(StagingRec); // YF 29 Sep 2022
                        Clear(SyncReport); // YF 29 Sep 2022
                        CurrPage.SetSelectionFilter(StagingRec);
                        SyncReport.SetTableView(StagingRec);
                        SyncReport.Run();
                        CurrPage.Update(false);
                        Message('Run completed');
                    end;
                }

                // //RL 12 Oct 2022
                action("Force Check Delivery Status Job Queue")
                {
                    ApplicationArea = all;
                    Caption = 'Force Check Delivery Status Job Queue';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Delivery;
                    PromotedCategory = Process;
                    // RunObject = report 69000;

                    trigger OnAction()
                    var
                        StagingRec: Record "Staging VF Task Header";
                        SyncReport: Report "VersaFleet ForceCheck Status";
                    begin
                        Clear(StagingRec); // YF 29 Sep 2022
                        Clear(SyncReport); // YF 29 Sep 2022
                        CurrPage.SetSelectionFilter(StagingRec);
                        SyncReport.SetTableView(StagingRec);
                        SyncReport.Run();
                        CurrPage.Update(false);
                        Message('Run completed');
                    end;
                }
                // action("Set Forcecheck to True")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Set Forcecheck to True';
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     PromotedOnly = true;
                //     Image = Archive;
                //     PromotedCategory = Process;
                //     // RunObject = report 69000;

                //     trigger OnAction()
                //     var
                //         StagingRec: Record "Staging VF Task Header";
                //         SyncReport: Report "VersaFleet Archive Staging Rec";
                //     begin
                //         CurrPage.SetSelectionFilter(StagingRec);
                //         StagingRec.ModifyAll("Force Delivery Status Check", true, true);
                //         // CurrPage.Update(false);
                //         Message('Run completed');
                //     end;
                // }
                // //RL 12 Oct 2022

                // YF 15 Mar 2022
                action("Archive Staging Records Job Queue")
                {
                    ApplicationArea = all;
                    Caption = 'Archive Staging Records Job Queue';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Archive;
                    PromotedCategory = Process;
                    // RunObject = report 69000;

                    trigger OnAction()
                    var
                        StagingRec: Record "Staging VF Task Header";
                        SyncReport: Report "VersaFleet Archive Staging Rec";
                    begin
                        CurrPage.SetSelectionFilter(StagingRec);
                        SyncReport.SetTableView(StagingRec);
                        SyncReport.Run();
                        CurrPage.Update(false);
                        Message('Run completed');
                    end;
                }
                // YF 15 Mar 2022

                // YF 14 Sep 2022
                action("Debug API Message")
                {
                    ApplicationArea = all;
                    Caption = 'Debug API Message';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Debug;
                    PromotedCategory = Process;
                    Visible = DebugMode;

                    trigger OnAction()
                    var
                        SyncCU: Codeunit "VersaFleet Integrations";
                        TaskID: Integer;
                        ProcessMessage: Text;
                        HasErrors: Boolean;
                    begin
                        Clear(SyncCU);
                        SyncCU.DebugAPIMessage(Rec."Entry No.", Rec."VF Job ID", TaskID, ProcessMessage, HasErrors);
                        Message(ProcessMessage);
                    end;
                }
                // YF 14 Sep 2022
            }

        }
    }

    trigger OnOpenPage()
    begin
        if VersafleetSetup.Get then
            DebugMode := VersafleetSetup."Debug Mode";
    end;

    var
        VersafleetSetup: Record "VersaFleet Integration Setup";
        DebugMode: Boolean;

}

