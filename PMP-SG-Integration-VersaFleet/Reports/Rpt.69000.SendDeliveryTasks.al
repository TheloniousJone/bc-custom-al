report 69000 "VersaFleet Send Delivery Tasks"
{

    Caption = 'VersaFleet Send Delivery Tasks';
    ProcessingOnly = true;
    // RDLCLayout = './ReportLayouts/Test.rdl';
    UseRequestPage = false;

    dataset
    {

        dataitem("Staging VF Task Header"; "Staging VF Task Header")
        {
            column(Entry_No_; "Entry No.") { }

            trigger OnPreDataItem()
            begin
                "Staging VF Task Header".SetRange(Created, false);
            end;

            trigger OnAfterGetRecord()
            var
                IntegrationCU: Codeunit "VersaFleet Integrations";
                JobID: Integer;
                ProcessMessage: Text[150];
                HasErrors: Boolean;
                TaskID: Integer;
                ResponseMessage: Text;
            begin
                ProcessMessage := '';
                JobID := 0;
                TaskID := 0;
                HasErrors := false;
                ResponseMessage := '';

                // Check Tracking Code Length
                if StrLen("Staging VF Task Header"."Tracking ID") < 11 then begin
                    UpdateHeaderErrorState("Staging VF Task Header", 'Tracking is too short (minimum is 11 characters)'); // Call Update Error State Functions
                    CurrReport.Skip();
                end;

                if IntegrationCU.CheckDeliveryJobExist("Staging VF Task Header"."Posting Date", JobID, ProcessMessage, HasErrors) then begin
                    // 1. Check if Job Exists for the date (Posting Date), store job data to variables if exist

                    if HasErrors then begin
                        UpdateHeaderErrorState("Staging VF Task Header", ProcessMessage); // Call Update Error State Functions
                        CurrReport.Skip();
                    end;
                end
                else begin
                    // 2. If does not exists, Create Job, store job data to variables (whatever needed for task creation)

                    if HasErrors then begin
                        UpdateHeaderErrorState("Staging VF Task Header", ProcessMessage); // Call Update Error State Functions
                        CurrReport.Skip();
                    end;

                    // Create Job (send posting date as parameter)
                    IntegrationCU.CreateDeliveryJob("Staging VF Task Header"."Posting Date", JobID, ProcessMessage, HasErrors);

                    if HasErrors then begin
                        UpdateHeaderErrorState("Staging VF Task Header", ProcessMessage); // Call Update Error State Functions
                        CurrReport.Skip();
                    end;

                    /*
                    if IntegrationCU.CreateDeliveryJob("Staging VF Task Header"."Posting Date", JobID, ProcessMessage, HasErrors) then begin
                        if HasErrors then begin
                            UpdateHeaderErrorState("Staging VF Task Header", ProcessMessage); // Call Update Error State Functions
                            CurrReport.Skip();
                        end;
                    end;
                    */

                end;

                // 3. Create new task and assign to job
                if JobID = 0 then begin
                    // Error
                    UpdateHeaderErrorState("Staging VF Task Header", 'Job ID does not exist'); // Call Update Error State Functions
                    CurrReport.Skip();
                end
                else begin

                    // Update Job ID State
                    "Staging VF Task Header"."VF Job ID" := JobID;
                    "Staging VF Task Header".Modify(false);

                    // Start process, pass in parameter Job ID, Staging Header Entry No. // CreateNewTaskForJob 
                    // IntegrationCU.CreateNewTaskForJob("Staging VF Task Header"."Entry No.", JobID, TaskID, ProcessMessage, HasErrors); // YF 10 Mar 2022
                    IntegrationCU.CreateNewTaskForJobV2("Staging VF Task Header"."Entry No.", JobID, TaskID, ProcessMessage, ResponseMessage, HasErrors); // YF 10 Mar 2022

                    if HasErrors then begin

                        "Staging VF Task Header"."Response Message" := ResponseMessage;

                        // YF 13 Jun 2022
                        if ("Staging VF Task Header"."VF Task ID" = 0) And (TaskID <> 0) then begin
                            "Staging VF Task Header"."VF Task ID" := TaskID;
                            "Staging VF Task Header".Modify(false);
                        end;
                        // YF 13 Jun 2022

                        UpdateHeaderErrorState("Staging VF Task Header", ProcessMessage); // Call Update Error State Functions
                        CurrReport.Skip();
                    end;

                end;

                // 4. Update Reference Data for Staging Header (Job and Task IDs)
                "Staging VF Task Header"."VF Job ID" := JobID;
                "Staging VF Task Header"."VF Task ID" := TaskID;
                "Staging VF Task Header"."VF Task State" := 'unassigned'; // default task state (hardcoded)

                if (JobID <> 0) And (TaskID <> 0) then begin
                    "Staging VF Task Header".Created := true;
                    "Staging VF Task Header".Error := false;
                    "Staging VF Task Header"."Process Remarks" := '';
                end
                else begin
                    "Staging VF Task Header".Created := false;
                    "Staging VF Task Header".Error := true;

                    if TaskID = 0 then
                        "Staging VF Task Header"."Process Remarks" := 'Missing Task ID';

                    if JobID = 0 then
                        "Staging VF Task Header"."Process Remarks" := 'Missing Job ID';
                end;

                "Staging VF Task Header".Modify(false);

                ProcessMessage := '';
                JobID := 0;
                TaskID := 0;
                HasErrors := false;

            end;
        }

    }

    local procedure UpdateHeaderErrorState(var StagingHeader: Record "Staging VF Task Header"; ProcessRemarks: Text[150])
    begin
        // YF 10 Mar 2022 // Bypass for valid tracking id exits
        if (StagingHeader."VF Task ID" <> 0) And (ProcessRemarks = 'Tracking ID exists in VF') then begin
            StagingHeader.Created := true;
            StagingHeader.Error := false;
            StagingHeader."Process Remarks" := '';
        end
        else begin
            StagingHeader.Error := true;
            StagingHeader."Process Remarks" := ProcessRemarks;
        end;

        // YF 10 Mar 2022 // Bypass for valid tracking id exits

        StagingHeader.Modify(false);
    end;

}

