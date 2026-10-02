report 57120 "Delete Sales Price Lines"
{
    Caption = 'Delete Sales Price Lines';
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
                SalesPriceLine: Record "Pharma Sales Price";
                SalesPriceArchiveLine: Record "Pharma Sales Price Archives";
                PMPCU: Codeunit "PMP-Enhancements";
            begin
                if NOT (PMPCU.IsCSLead()) then begin
                    Error('You are not allowed to delete sales price, please check with CS team lead.');

                end;

                SalesPriceLine.Reset;
                SalesPriceLine.SetFilter("Ending Date", '<=%1', InputDate);
                if SalesPriceLine.FindSet() then
                    repeat

                        // 1. Copy to archive first
                        SalesPriceArchiveLine.Reset;
                        SalesPriceArchiveLine.Init();
                        SalesPriceArchiveLine."Entry No." := 0;
                        SalesPriceArchiveLine."Item No." := SalesPriceLine."Item No.";
                        SalesPriceArchiveLine."Sales Code" := SalesPriceLine."Sales Code";
                        SalesPriceArchiveLine."Currency Code" := SalesPriceLine."Currency Code";
                        SalesPriceArchiveLine."Starting Date" := SalesPriceLine."Starting Date";
                        SalesPriceArchiveLine."Unit Price" := SalesPriceLine."Unit Price";
                        SalesPriceArchiveLine."Price Includes VAT" := SalesPriceLine."Price Includes VAT";
                        SalesPriceArchiveLine."Allow Invoice Disc." := SalesPriceLine."Allow Invoice Disc.";
                        SalesPriceArchiveLine."Line Discount %" := SalesPriceLine."Line Discount %";
                        SalesPriceArchiveLine."Sales Type" := SalesPriceLine."Sales Type";
                        SalesPriceArchiveLine."Minimum Quantity" := SalesPriceLine."Minimum Quantity";
                        SalesPriceArchiveLine."Ending Date" := SalesPriceLine."Ending Date";
                        SalesPriceArchiveLine."Unit Of Measure Code" := SalesPriceLine."Unit Of Measure Code";
                        SalesPriceArchiveLine."VAT Bus. Posting Gr. (Price)" := SalesPriceLine."VAT Bus. Posting Gr. (Price)";
                        SalesPriceArchiveLine."Allow Line Disc." := SalesPriceLine."Allow Line Disc.";
                        SalesPriceArchiveLine."Variant Code" := SalesPriceLine."Variant Code";
                        SalesPriceArchiveLine."FOC Qty" := SalesPriceLine."FOC Qty";
                        SalesPriceArchiveLine.Status := SalesPriceLine.Status;
                        SalesPriceArchiveLine.RecRefID := SalesPriceLine.RecRefID;
                        SalesPriceArchiveLine.Remarks := SalesPriceLine.Remarks;
                        SalesPriceArchiveLine."Entry Timestamp" := CurrentDateTime;

                        if Not SalesPriceArchiveLine.Insert(true) then begin
                            Message('Fail to Archive Sales Price for ' + SalesPriceLine."Item No." + ' ' + SalesPriceLine."Sales Code");
                            CurrReport.Skip();
                        end;

                        // 2. Delete Sales Price Line
                        if SalesPriceLine.Delete() then
                            DeleteCounter += 1;

                    until SalesPriceLine.Next() = 0;

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
