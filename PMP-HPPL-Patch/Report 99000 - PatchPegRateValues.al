report 99000 UpdatePegRateValues
{
    Caption = 'UpdatePegRateValues';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = TableData "Sales Invoice Header" = rimd,
                    TableData "Cust. Ledger Entry" = rimd;

    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                SalesInvHeaderRec: Record "Sales Invoice Header";
                CLERec: Record "Cust. Ledger Entry";
            begin
                if UserId <> 'BCADMIN' then
                    Error('Not allowed');

                if DocNoFilter <> '' then begin
                    SalesInvHeaderRec.Reset;
                    SalesInvHeaderRec.SetFilter("No.", DocNoFilter);
                    if SalesInvHeaderRec.FindSet() then
                        repeat
                            SalesInvHeaderRec.CalcFields(Amount);

                            // FCY-LCY Rate = 1 / SHRec.Currency Factor
                            if SalesInvHeaderRec."Currency Factor" <> 0 then
                                SalesInvHeaderRec."FCY-LCY Rate" := 1 / SalesInvHeaderRec."Currency Factor"
                            else
                                SalesInvHeaderRec."FCY-LCY Rate" := 1; //RL 14 Feb 2022  // LCY Amount = Amount / SHRec.Currency Factor

                            if SalesInvHeaderRec."Currency Factor" <> 0 then
                                SalesInvHeaderRec."LCY Amount" := SalesInvHeaderRec.Amount / SalesInvHeaderRec."Currency Factor"
                            else
                                SalesInvHeaderRec."LCY Amount" := SalesInvHeaderRec.Amount; //RL 14 Feb 2022  // Adjustment

                            SalesInvHeaderRec.Adjustment := SalesInvHeaderRec."Peg SGD Amount" - SalesInvHeaderRec."LCY Amount";

                            SalesInvHeaderRec.Modify(false);

                            CLERec.Reset;
                            CLERec.SetRange("Document No.", SalesInvHeaderRec."No.");
                            if CLERec.FindSet() then
                                repeat
                                    CLERec."FCY-LCY Rate" := SalesInvHeaderRec."FCY-LCY Rate";
                                    CLERec."LCY Amount" := SalesInvHeaderRec."LCY Amount";
                                    CLERec.Adjustment := SalesInvHeaderRec.Adjustment;
                                    CLERec."Peg Rate" := SalesInvHeaderRec."Peg Rate";
                                    CLERec."VND Amount" := SalesInvHeaderRec."VND Amount";
                                    CLERec."VND-LCY Rate" := SalesInvHeaderRec."VND-LCY Rate";
                                    CLERec."Peg SGD Amount" := SalesInvHeaderRec."Peg SGD Amount";

                                    CLERec.Modify(false);
                                until CLERec.Next() = 0;

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
