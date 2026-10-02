report 99007 PatchPOMStatus
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header" = rimd;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date", "No.";

            trigger OnPreDataItem()
            begin
                // Additional Filterse Here
            end;

            trigger OnAfterGetRecord()
            begin
                if UserId = 'BCADMIN' then begin
                    "Sales Invoice Header"."Order Status" := "Sales Invoice Header"."Order Status"::Completed;
                    "Sales Invoice Header"."Processed by POM" := true;
                    "Sales Invoice Header".Modify(false);
                end;
            end;
        }
    }

}