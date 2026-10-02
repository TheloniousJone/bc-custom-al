report 57121 "Delete Purchase Price Lines"
{
    Caption = 'Delete Purchase Price Lines';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                PurchPriceLine: Record "Pharma Purchase Price";
                PurchPriceArchiveLine: Record "Pharma Purchase Price Archives";
            begin
                // if UserId <> 'BCADMIN' then
                //     Error('Not allowed');

                PurchPriceLine.Reset;
                PurchPriceLine.SetFilter("Ending Date", '<=%1', InputDate);
                if PurchPriceLine.FindSet() then
                    repeat

                        // 1. Copy to archive first
                        PurchPriceArchiveLine.Reset;
                        PurchPriceArchiveLine.Init();
                        PurchPriceArchiveLine."Entry No." := 0;
                        PurchPriceArchiveLine."Item No." := PurchPriceLine."Item No.";
                        PurchPriceArchiveLine."Vendor No." := PurchPriceLine."Vendor No.";
                        PurchPriceArchiveLine."Currency Code" := PurchPriceLine."Currency Code";
                        PurchPriceArchiveLine."Starting Date" := PurchPriceLine."Starting Date";
                        PurchPriceArchiveLine."Direct Unit Cost" := PurchPriceLine."Direct Unit Cost";
                        PurchPriceArchiveLine."Price Includes VAT" := PurchPriceLine."Price Includes VAT";
                        PurchPriceArchiveLine."Allow Invoice Disc." := PurchPriceLine."Allow Invoice Disc.";
                        PurchPriceArchiveLine."Line Discount %" := PurchPriceLine."Line Discount %";
                        PurchPriceArchiveLine."Allow Line Disc." := PurchPriceLine."Allow Line Disc.";
                        PurchPriceArchiveLine."Minimum Quantity" := PurchPriceLine."Minimum Quantity";
                        PurchPriceArchiveLine."Ending Date" := PurchPriceLine."Ending Date";
                        PurchPriceArchiveLine.Status := PurchPriceLine.Status;
                        PurchPriceArchiveLine."Unit of Measure Code" := PurchPriceLine."Unit of Measure Code";
                        PurchPriceArchiveLine."Variant Code" := PurchPriceLine."Variant Code";
                        PurchPriceArchiveLine."FOC Qty" := PurchPriceLine."FOC Qty";
                        PurchPriceArchiveLine.RecRefID := PurchPriceLine.RecRefID;
                        PurchPriceArchiveLine."New Cost Price" := PurchPriceLine."New Cost Price";
                        PurchPriceArchiveLine.Remarks := PurchPriceLine.Remarks;
                        PurchPriceArchiveLine."Margin Percent" := PurchPriceLine."Margin Percent";
                        PurchPriceArchiveLine."New FOC Qty" := PurchPriceLine."New FOC Qty";
                        PurchPriceArchiveLine."New Min Order Qty" := PurchPriceLine."New Min Order Qty";
                        PurchPriceArchiveLine."Average Cost" := PurchPriceLine."Average Cost";
                        PurchPriceArchiveLine."New Average Cost" := PurchPriceLine."New Average Cost";
                        PurchPriceArchiveLine."Margin Increase" := PurchPriceLine."Margin Increase";
                        PurchPriceArchiveLine."Entry Timestamp" := CurrentDateTime;

                        if Not PurchPriceArchiveLine.Insert(true) then begin
                            Message('Fail to Archive Purchase Price for ' + PurchPriceLine."Item No." + ' ' + PurchPriceLine."Vendor No.");
                            CurrReport.Skip();
                        end;

                        // 2. Delete Purchase Price Line
                        if PurchPriceLine.Delete() then
                            DeleteCounter += 1;

                    until PurchPriceLine.Next() = 0;

                Message(Format(DeleteCounter) + ' line(s) deleted and archived');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Bulk Delete Filter")
                {
                    field(InputDate; InputDate)
                    {
                        Caption = 'Input Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = CloseAction::Cancel then
                exit(true);

            if InputDate = 0D then begin
                Message('Entered date cannot be empty');
                exit(false);
            end;

            if InputDate >= Today then begin
                Message('Entered date cannot be later than today');
                exit(false);
            end;

            exit(true);
        end;

    }

    var
        DeleteCounter: Integer;
        InputDate: Date;

}
