report 99005 PatchSalesTradeAgtMinQtyDef
{
    Caption = 'PatchSalesTradeAgtMinQtyDef';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    // Permissions = TableData "Sales Invoice Header" = rimd;

    dataset
    {
        dataitem("Pharma Sales Price"; "Pharma Sales Price")
        {
            trigger OnAfterGetRecord()
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                if not "Pharma Sales Price".Rename("Item No.", "Sales Type", "Sales Code", "Currency Code", "Starting Date", 1, "Unit Of Measure Code") then begin
                    "Pharma Sales Price".Status := "Pharma Sales Price".Status::Inactive;
                    "Pharma Sales Price".Modify(false);
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Minimum Quantity", 0);
                SetRange(Status, Status::Active);
            end;
        }

    }

    trigger OnPostReport()
    begin
        Message('Report Ran');
    end;

}
