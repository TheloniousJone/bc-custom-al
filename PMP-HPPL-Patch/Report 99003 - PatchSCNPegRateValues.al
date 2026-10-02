report 99003 UpdateSCNPegRateValues
{
    Caption = 'UpdateSCNPegRateValues';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = TableData "Sales Cr.Memo Header" = rimd,
                    TableData "Cust. Ledger Entry" = rimd;

    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                SalesCMHeaderRec: Record "Sales Cr.Memo Header";
                SalesCMLineRec: Record "Sales Cr.Memo Line";
                CurrXchgnRateRec: Record "Currency Exchange Rate";
                CLERec: Record "Cust. Ledger Entry";
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                if DocNoFilter <> '' then begin
                    SalesCMHeaderRec.Reset;
                    SalesCMHeaderRec.SetFilter("No.", DocNoFilter);
                    if SalesCMHeaderRec.FindSet() then
                        repeat

                            // Peg Rate = Find First from Sales Line
                            SalesCMLineRec.Reset;
                            SalesCMLineRec.SetRange("Document No.", SalesCMHeaderRec."No.");
                            SalesCMLineRec.SetRange(Type, SalesCMLineRec.Type::Item);
                            SalesCMLineRec.SetFilter("Peg Rate", '<>%1', 0); //RL 13 Jan 2022 - find first line with peg rate
                            if SalesCMLineRec.FindFirst() then begin
                                SalesCMHeaderRec."Peg Rate" := SalesCMLineRec."Peg Rate";
                                // VND Amount = SH.Amount * Peg Rate
                                SalesCMHeaderRec.CalcFields(Amount);
                                SalesCMHeaderRec."VND Amount" := SalesCMHeaderRec.Amount * SalesCMHeaderRec."Peg Rate";

                                // VND-LCY Rate = Take from Currency Table, filter by order date
                                CurrXchgnRateRec.Reset;
                                CurrXchgnRateRec.SetRange("Currency Code", 'VND');
                                CurrXchgnRateRec.SetFilter("Starting Date", '<=%1', SalesCMHeaderRec."Posting Date"); // or order date? TBC
                                CurrXchgnRateRec.SetCurrentKey("Starting Date");
                                CurrXchgnRateRec.SetAscending("Starting Date", false);
                                if CurrXchgnRateRec.FindFirst() then
                                    if CurrXchgnRateRec."Relational Exch. Rate Amount" <> 0 then // YF 06 Dec 2021
                                        SalesCMHeaderRec."VND-LCY Rate" := (CurrXchgnRateRec."Exchange Rate Amount" / CurrXchgnRateRec."Relational Exch. Rate Amount");
                                // SHRec."VND-LCY Rate" := CurrXchgnRateRec."Relational Exch. Rate Amount";

                                // Peg SGD Amount
                                // SHRec."Peg SGD Amount" := SHRec.Amount * SHRec."VND-LCY Rate"; // YF 01 Dec 2021
                                if SalesCMHeaderRec."VND-LCY Rate" <> 0 then // YF 06 Dec 2021
                                    SalesCMHeaderRec."Peg SGD Amount" := SalesCMHeaderRec."VND Amount" / SalesCMHeaderRec."VND-LCY Rate"; // YF 01 Dec 2021

                                // FCY-LCY Rate = 1 / SHRec.Currency Factor
                                if SalesCMHeaderRec."Currency Factor" <> 0 then
                                    SalesCMHeaderRec."FCY-LCY Rate" := 1 / SalesCMHeaderRec."Currency Factor"
                                else
                                    SalesCMHeaderRec."FCY-LCY Rate" := 1; //RL 14 Feb 2022

                                // LCY Amount = Amount / SHRec.Currency Factor
                                if SalesCMHeaderRec."Currency Factor" <> 0 then
                                    SalesCMHeaderRec."LCY Amount" := SalesCMHeaderRec.Amount / SalesCMHeaderRec."Currency Factor"
                                else
                                    SalesCMHeaderRec."LCY Amount" := SalesCMHeaderRec.Amount; //RL 14 Feb 2022

                                // Adjustment
                                SalesCMHeaderRec.Adjustment := SalesCMHeaderRec."Peg SGD Amount" - SalesCMHeaderRec."LCY Amount";

                                SalesCMHeaderRec."VND Amount" := SalesCMHeaderRec."VND Amount" * -1;
                                SalesCMHeaderRec."Peg SGD Amount" := SalesCMHeaderRec."Peg SGD Amount" * -1;
                                SalesCMHeaderRec."LCY Amount" := SalesCMHeaderRec."LCY Amount" * -1;
                                SalesCMHeaderRec.Adjustment := SalesCMHeaderRec."Peg SGD Amount" - SalesCMHeaderRec."LCY Amount";
                            end
                            else begin
                                SalesCMHeaderRec."Peg Rate" := 0;
                                SalesCMHeaderRec."VND Amount" := 0;
                                SalesCMHeaderRec."VND-LCY Rate" := 0;
                                SalesCMHeaderRec."Peg SGD Amount" := 0;
                                SalesCMHeaderRec."FCY-LCY Rate" := 0;
                                SalesCMHeaderRec."LCY Amount" := 0;
                                SalesCMHeaderRec.Adjustment := 0;
                            end;

                            // Update Sales CM Header
                            SalesCMHeaderRec.Modify(false);

                            CLERec.Reset;
                            CLERec.SetRange("Document No.", SalesCMHeaderRec."No.");
                            if CLERec.FindSet() then
                                repeat
                                    CLERec."FCY-LCY Rate" := SalesCMHeaderRec."FCY-LCY Rate";
                                    CLERec."LCY Amount" := SalesCMHeaderRec."LCY Amount";
                                    CLERec.Adjustment := SalesCMHeaderRec.Adjustment;
                                    CLERec."Peg Rate" := SalesCMHeaderRec."Peg Rate";
                                    CLERec."VND Amount" := SalesCMHeaderRec."VND Amount";
                                    CLERec."VND-LCY Rate" := SalesCMHeaderRec."VND-LCY Rate";
                                    CLERec."Peg SGD Amount" := SalesCMHeaderRec."Peg SGD Amount";

                                    CLERec.Modify(false);
                                until CLERec.Next() = 0;

                        until SalesCMHeaderRec.Next() = 0;

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
                        Caption = 'Posted Sales Credit Note Document No. Filter';
                    }
                }
            }
        }
    }

    var
        DocNoFilter: Text;
}
