report 69002 "VersaFleet Archive Staging Rec"
{

    Caption = 'VersaFleet Archive Staging Records';
    ProcessingOnly = true;
    // RDLCLayout = './ReportLayouts/Test1.rdl';
    UseRequestPage = false;

    dataset
    {

        dataitem("Staging VF Task Header"; "Staging VF Task Header")
        {

            trigger OnAfterGetRecord()
            var
                StagingLineRec: Record "Staging VF Task Line";
                StagingLineArchRec: Record "Staging VF Task Line Archive";
                StagingHdrArchRec: Record "Staging VF Task Header Archive";
            begin
                // 1. Check if keys in header and line exists in archive
                StagingHdrArchRec.Reset;
                StagingHdrArchRec.SetRange("Entry No.", "Staging VF Task Header"."Entry No.");
                if StagingHdrArchRec.FindFirst() then begin
                    Message('Duplicated entry no. found in header archives. Entry No. ' + Format("Staging VF Task Header"."Entry No."));
                    CurrReport.Skip();
                end;

                StagingLineArchRec.Reset;
                StagingLineArchRec.SetRange("Parent Entry No.", "Staging VF Task Header"."Entry No.");
                if StagingLineArchRec.FindFirst() then begin
                    Message('Duplicated entry no. found in line archives. Entry No. ' + Format("Staging VF Task Header"."Entry No."));
                    CurrReport.Skip();
                end;

                // 2. Copy Header to archive first 
                StagingHdrArchRec.Reset;
                StagingHdrArchRec.Init();
                StagingHdrArchRec.Copy("Staging VF Task Header");
                if Not StagingHdrArchRec.Insert(true) then begin
                    Message('Fail to archive staging header for entry no. ' + Format("Staging VF Task Header"."Entry No."));
                    CurrReport.Skip();
                end;

                // 3. Copy Line to archive first
                StagingLineRec.Reset;
                StagingLineRec.SetRange("Parent Entry No.", "Staging VF Task Header"."Entry No.");
                if StagingLineRec.FindSet() then
                    repeat
                        StagingLineArchRec.Reset;
                        StagingLineArchRec.Init();
                        StagingLineArchRec.Copy(StagingLineRec);
                        if Not StagingLineArchRec.Insert(true) then begin
                            Message('Fail to archive staging line for entry no. ' + Format(StagingLineRec."Parent Entry No.") + ' and line no. ' + Format(StagingLineRec."Line No."));
                            CurrReport.Skip();
                        end;
                    until StagingLineRec.Next() = 0;

                // 4. Delete Line
                StagingLineRec.Reset;
                StagingLineRec.SetRange("Parent Entry No.", "Staging VF Task Header"."Entry No.");
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not StagingLineRec.IsEmpty then
                    StagingLineRec.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock

                // 5. Delete Header
                if not "Staging VF Task Header".Delete() then
                    Message('Fail to delete staging header for entry no. ' + Format("Staging VF Task Header"."Entry No."));
            end;
        }

    }

}

