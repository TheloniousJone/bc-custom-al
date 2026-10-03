report 52001 "DBS Archive H2H Staging"
{

    Caption = 'DBS Archive H2H Staging';
    ProcessingOnly = true;
    // RDLCLayout = './ReportLayouts/Test1.rdl';
    UseRequestPage = false;

    dataset
    {

        dataitem("DBS Host2Host Staging"; "DBS Host2Host Staging")
        {

            trigger OnAfterGetRecord()
            var
                StagingH2HArchive: Record "DBS Host2Host Staging Archive";
            begin
                // 1. Check if keys exist in archive
                StagingH2HArchive.Reset;
                StagingH2HArchive.SetRange("Entry No.", "DBS Host2Host Staging"."Entry No.");
                if StagingH2HArchive.FindFirst() then begin
                    Message('Duplicated entry no. found in archives. Entry No. ' + Format("DBS Host2Host Staging"."Entry No."));
                    CurrReport.Skip();
                end;

                // 2. Copy record to archive
                StagingH2HArchive.Reset;
                StagingH2HArchive.Init();
                StagingH2HArchive.Copy("DBS Host2Host Staging");
                if not StagingH2HArchive.Insert(true) then begin
                    Message('Fail to archive staging record for entry no. ' + Format("DBS Host2Host Staging"."Entry No."));
                    CurrReport.Skip();
                end;

                // 3. Delete record
                if not "DBS Host2Host Staging".Delete() then
                    Message('Fail to delete staging record for entry no. ' + Format("DBS Host2Host Staging"."Entry No."));

            end;
        }

    }

}

