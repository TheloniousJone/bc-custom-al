report 57119 "Delete SO after 30D"
{
    Caption = 'Delete Sales Order after 30D Due Date';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesHeaderRec; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));

            trigger OnPreDataItem()
            begin
                SalesHeaderRec.SetFilter(Status, '<>%1', SalesHeaderRec.Status::"Pending Approval");
                SalesHeaderRec.SetFilter("Order Date", '<=%1', CalcDate('-30D', Today));
            end;

            trigger OnAfterGetRecord()
            var
                ReleaseSalesDoc: Codeunit "Release Sales Document";
                WhseRqst: Record "Warehouse Request";
            begin
                // Message(SalesHeaderRec."No." + '|' + Format(SalesHeaderRec."Order Date"));

                if SalesHeaderRec.Status = SalesHeaderRec.Status::Released then
                    ReleaseSalesDoc.PerformManualReopen(SalesHeaderRec); // reopen SO and Whse Request

                // Delete Whse Request first
                WhseRqst.Reset();
                WhseRqst.SetCurrentKey("Source Type", "Source Subtype", "Source No.");
                WhseRqst.SetSourceFilter(DATABASE::"Sales Line", SalesHeaderRec."Document Type".AsInteger(), SalesHeaderRec."No.");
                if not WhseRqst.IsEmpty() then
                    WhseRqst.DeleteAll();

                // Delete Sales Order
                if SalesHeaderRec.Delete() then
                    CountRecords += 1;

            end;
        }
    }

    trigger OnInitReport()
    var
        PMPCU: Codeunit "PMP-Enhancements";
    begin
        // if UserId <> 'BCADMIN' then
        //     Error('Not allowed');
        if NOT (PMPCU.IsCSLead()) then begin
            Error('You are not allowed to delete sales price, please check with CS team lead.');

        end;
    end;

    trigger OnPostReport()
    begin
        Message(Format(CountRecords) + ' SO Deleted');
    end;

    var
        CountRecords: Integer;

}
