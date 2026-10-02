report 99001 UpdateInvPegRateValues
{
    Caption = 'UpdateInvPegRateValues';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = TableData "Sales Invoice Header" = rimd;

    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                SalesInvHeaderRec: Record "Sales Invoice Header";
                SalesInvLineRec: Record "Sales Invoice Line";
                CurrXchgnRateRec: Record "Currency Exchange Rate";
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                if DocNoFilter <> '' then begin
                    SalesInvHeaderRec.Reset;
                    SalesInvHeaderRec.SetFilter("No.", DocNoFilter);
                    if SalesInvHeaderRec.FindSet() then
                        repeat

                            // Peg Rate = Find First from Sales Line
                            SalesInvLineRec.Reset;
                            SalesInvLineRec.SetRange("Document No.", SalesInvHeaderRec."No.");
                            SalesInvLineRec.SetRange(Type, SalesInvLineRec.Type::Item);
                            SalesInvLineRec.SetFilter("Peg Rate", '<>%1', 0); //RL 13 Jan 2022 - find first line with peg rate
                            if SalesInvLineRec.FindFirst() then begin
                                SalesInvHeaderRec."Peg Rate" := SalesInvLineRec."Peg Rate";
                                // VND Amount = SH.Amount * Peg Rate
                                SalesInvHeaderRec.CalcFields(Amount);
                                SalesInvHeaderRec."VND Amount" := SalesInvHeaderRec.Amount * SalesInvHeaderRec."Peg Rate";

                                // VND-LCY Rate = Take from Currency Table, filter by order date
                                CurrXchgnRateRec.Reset;
                                CurrXchgnRateRec.SetRange("Currency Code", 'VND');
                                CurrXchgnRateRec.SetFilter("Starting Date", '<=%1', SalesInvHeaderRec."Posting Date"); // or order date? TBC
                                CurrXchgnRateRec.SetCurrentKey("Starting Date");
                                CurrXchgnRateRec.SetAscending("Starting Date", false);
                                if CurrXchgnRateRec.FindFirst() then
                                    if CurrXchgnRateRec."Relational Exch. Rate Amount" <> 0 then // YF 06 Dec 2021
                                        SalesInvHeaderRec."VND-LCY Rate" := (CurrXchgnRateRec."Exchange Rate Amount" / CurrXchgnRateRec."Relational Exch. Rate Amount");
                                // SHRec."VND-LCY Rate" := CurrXchgnRateRec."Relational Exch. Rate Amount";

                                // Peg SGD Amount
                                // SHRec."Peg SGD Amount" := SHRec.Amount * SHRec."VND-LCY Rate"; // YF 01 Dec 2021
                                if SalesInvHeaderRec."VND-LCY Rate" <> 0 then // YF 06 Dec 2021
                                    SalesInvHeaderRec."Peg SGD Amount" := SalesInvHeaderRec."VND Amount" / SalesInvHeaderRec."VND-LCY Rate"; // YF 01 Dec 2021

                                // FCY-LCY Rate = 1 / SHRec.Currency Factor
                                if SalesInvHeaderRec."Currency Factor" <> 0 then
                                    SalesInvHeaderRec."FCY-LCY Rate" := 1 / SalesInvHeaderRec."Currency Factor"
                                else
                                    SalesInvHeaderRec."FCY-LCY Rate" := 1; //RL 14 Feb 2022
                                // LCY Amount = Amount / SHRec.Currency Factor
                                if SalesInvHeaderRec."Currency Factor" <> 0 then
                                    SalesInvHeaderRec."LCY Amount" := SalesInvHeaderRec.Amount / SalesInvHeaderRec."Currency Factor"
                                else
                                    SalesInvHeaderRec."LCY Amount" := SalesInvHeaderRec.Amount; //RL 14 Feb 2022
                                // Adjustment
                                SalesInvHeaderRec.Adjustment := SalesInvHeaderRec."Peg SGD Amount" - SalesInvHeaderRec."LCY Amount";
                            end
                            else begin
                                SalesInvHeaderRec."Peg Rate" := 0;
                                SalesInvHeaderRec."VND Amount" := 0;
                                SalesInvHeaderRec."VND-LCY Rate" := 0;
                                SalesInvHeaderRec."Peg SGD Amount" := 0;
                                SalesInvHeaderRec."FCY-LCY Rate" := 0;
                                SalesInvHeaderRec."LCY Amount" := 0;
                                SalesInvHeaderRec.Adjustment := 0;
                            end;

                            // Update Sales Invoice Header
                            SalesInvHeaderRec.Modify(false);

                        until SalesInvHeaderRec.Next() = 0;

                end;

                Message('Report Ran');
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(DocNoFilter; DocNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Sales Invoice Document No. Filter';
                    }
                }
            }
        }
    }

    var
        DocNoFilter: Text;
}
