pageextension 69001 PostedSalesInvoicePageExt extends "Posted Sales Invoice"
{
    layout
    {
        // add fields
        addbefore("Work Description")
        {
            field("Customer Instructions"; Rec."Customer Instructions")
            {
                ApplicationArea = All;
                MultiLine = true;
            }

            field("Delivery Instructions"; Rec."Delivery Instructions")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }

    actions
    {
        // add actions
        addafter("&Invoice")
        {
            group("Versafleet")
            {
                action("Queue for Delivery Task")
                {
                    ApplicationArea = All;
                    Caption = 'Queue for Delivery Task';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SIHRec: Record "Sales Invoice Header";
                        VersafleetCU: Codeunit "VersaFleet Integrations";
                    begin
                        if Confirm('Send Posted Sales Invoice(s) to Staging Delivery Queue', false) then begin
                            CurrPage.SetSelectionFilter(SIHRec);
                            VersafleetCU.InsertOrUpdateStagingInvoiceRecords(SIHRec);
                        end;
                    end;
                }

                /*
                action("Send Immediate for Delivery Task")
                {
                    ApplicationArea = All;
                    Caption = 'Send Immediate for Delivery Task';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        SIHRec: Record "Sales Invoice Header";
                        VersafleetCU: Codeunit "VersaFleet Integrations";
                        EntryNo: Integer;
                        JobID: Integer;
                        ProcessMessage: Text[150];
                        HasErrors: Boolean;
                        TaskID: Integer;
                        VFStagingHeader: Record "Staging VF Task Header";
                    begin
                        if Confirm('Send Posted Sales Invoice(s) to Staging Delivery Queue', false) then begin

                            CurrPage.SetSelectionFilter(SIHRec);

                            // 1. Check Tracking ID (Pending)
                            // 2. Insert SIH to Staging and Get Entry No.
                            EntryNo := VersafleetCU.InsertOrUpdateStagingInvoiceRecords(SIHRec, true);

                            if Not VFStagingHeader.Get(EntryNo) then
                                Error('Cannot find Staging Header record');

                            Clear(VersafleetCU);
                            ProcessMessage := '';
                            JobID := 0;
                            TaskID := 0;
                            HasErrors := false;

                            // 3. Handle Job
                            // Check Tracking Code Length
                            if StrLen(VFStagingHeader."Tracking ID") < 11 then begin
                                VersafleetCU.UpdateHeaderErrorState(VFStagingHeader, 'Tracking is too short (minimum is 11 characters)'); // Call Update Error State Functions
                                Error('Tracking is too short (minimum is 11 characters)');
                            end;

                            if VersafleetCU.CheckDeliveryJobExist(VFStagingHeader."Posting Date", JobID, ProcessMessage, HasErrors) then begin
                                // Check if Job Exists for the date (Posting Date), store job data to variables if exist

                                if HasErrors then begin
                                    VersafleetCU.UpdateHeaderErrorState(VFStagingHeader, ProcessMessage); // Call Update Error State Functions
                                    Error(ProcessMessage);
                                end;
                            end
                            else begin
                                // If does not exists, Create Job, store job data to variables (whatever needed for task creation)

                                if HasErrors then begin
                                    VersafleetCU.UpdateHeaderErrorState(VFStagingHeader, ProcessMessage); // Call Update Error State Functions
                                    Error(ProcessMessage);
                                end;

                                // Create Job (send posting date as parameter)
                                VersafleetCU.CreateDeliveryJob(VFStagingHeader."Posting Date", JobID, ProcessMessage, HasErrors);

                                if HasErrors then begin
                                    VersafleetCU.UpdateHeaderErrorState(VFStagingHeader, ProcessMessage); // Call Update Error State Functions
                                    Error(ProcessMessage);
                                end;
                            end;

                            // 4. Handle Task
                            // Create new task and assign to job
                            if JobID = 0 then begin
                                // Error
                                VersafleetCU.UpdateHeaderErrorState(VFStagingHeader, 'Job ID does not exist'); // Call Update Error State Functions
                                Error(ProcessMessage);
                            end
                            else begin

                                // Start process, pass in parameter Job ID, Staging Header Entry No. // CreateNewTaskForJob 
                                // VersafleetCU.CreateNewTaskForJob(VFStagingHeader."Entry No.", JobID, TaskID, ProcessMessage, HasErrors); // YF 10 Mar 2022
                                VersafleetCU.CreateNewTaskForJobV2(VFStagingHeader."Entry No.", JobID, TaskID, ProcessMessage, HasErrors); // YF 10 Mar 2022

                                if HasErrors then begin
                                    VersafleetCU.UpdateHeaderErrorState(VFStagingHeader, ProcessMessage); // Call Update Error State Functions
                                    // Update Job ID State
                                    VFStagingHeader."VF Job ID" := JobID;
                                    VFStagingHeader.Modify(false);
                                    Error(ProcessMessage);
                                end;

                            end;

                            // 5. Update Reference Data for Staging Header (Job and Task IDs)
                            VFStagingHeader."VF Job ID" := JobID;
                            VFStagingHeader."VF Task ID" := TaskID;

                            if (JobID <> 0) And (TaskID <> 0) then begin
                                VFStagingHeader.Created := true;
                                VFStagingHeader.Error := false;
                                VFStagingHeader."Process Remarks" := '';
                            end
                            else begin
                                VFStagingHeader.Created := false;
                                VFStagingHeader.Error := true;

                                if TaskID = 0 then
                                    VFStagingHeader."Process Remarks" := 'Missing Task ID';

                                if JobID = 0 then
                                    VFStagingHeader."Process Remarks" := 'Missing Job ID';
                            end;

                            VFStagingHeader.Modify(false);

                            // 5. Return end result via message
                            ProcessMessage := '';
                            JobID := 0;
                            TaskID := 0;
                            HasErrors := false;
                            Message('Sent to Versafleet');

                        end;
                    end;
                }
                */
            }
        }
    }
}
