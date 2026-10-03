report 57109 "Customer Sales Classification"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(CustomerNo; "No.")
            {
            }
            column(FirstPostingDate; FirstPostingDate)
            {
            }
            column(TotalSales; TotalSales)
            {
            }
            column(From_Date; From_Date)
            {
            }
            column(To_Date; To_Date)
            {
            }
            column(AvgSales; AvgSales)
            {
            }
            column(NumOfMonthsBetween; NumOfMonthsBetween)
            {
            }
            column(ClassificationCode; ClassificationCode)
            {
            }

            /*
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Source No." = field("No.");

                trigger OnPreDataItem()
                var
                    From_Date, To_Date : Date;
                begin
                    // From_Date := CalcDate('-6M', Today);
                    // RL 
                    From_Date := CalcDate('CM-12M', Today);
                    To_Date := CalcDate('CM', Today);
                    SetFilter("Posting Date", '%1..%2', From_Date, To_Date);
                    SetFilter("Entry Type", '%1', "Entry Type"::"Sale");

                end;

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Sales Amount (Actual)");
                    InsertIntoTemp("Item Ledger Entry");
                    CALCAVG(temp_ItemLedgEntry);


                end;
            }
            */

            trigger OnPreDataItem()
            begin
                if AsOfDate = 0D then begin
                    From_Date := CalcDate('-CM-12M', Today);
                    To_Date := CalcDate('-CM-1D', Today);
                end else begin
                    From_Date := CalcDate('-CM-12M', AsOfDate);
                    To_Date := CalcDate('-CM-1D', AsOfDate);
                end;

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(TotalSales);
                Clear(FirstPostingDate);
                Clear(NumOfMonthsBetween);
                Clear(AvgSales);
                Clear(ClassificationCode);

                ILE.Reset();
                ILE.SetCurrentKey("Source No.", "Posting Date");
                ILE.SetRange("Source No.", Customer."No.");
                ILE.SetFilter("Entry Type", '%1', ILE."Entry Type"::"Sale");
                ILE.SetFilter("Global Dimension 1 Code", '%1|%2', '3.1 WHOLESALE', '3.2 HOUSEBRAND');
                ILE.SetFilter("Posting Date", '..%1', CalcDate('-1D', From_Date));
                if ILE.FindFirst() then
                    FirstPostingDate := From_Date;

                ILE.SetFilter("Posting Date", '%1..%2', From_Date, To_Date);
                if ILE.FindSet() then begin
                    if FirstPostingDate = 0D then
                        FirstPostingDate := ILE."Posting Date";

                    repeat
                        ILE.CalcFields("Sales Amount (Actual)");
                        TotalSales := TotalSales + ILE."Sales Amount (Actual)";
                    until ILE.Next() = 0;
                end;

                if TotalSales <> 0 then begin
                    // PeriodDate.Reset();
                    // PeriodDate.SetRange("Period Type", PeriodDate."Period Type"::Month);
                    // PeriodDate.SetRange("Period Start", CalcDate('-CM', FirstPostingDate), CalcDate('-CM', To_Date));
                    // NumOfMonthsBetween := PeriodDate.Count;

                    // AvgSales := TotalSales / NumOfMonthsBetween;
                end;

                if TotalSales < 1000 then begin
                    ClassificationCode := 'D';
                end else
                    if (TotalSales >= 1000) and (TotalSales < 10000) then begin
                        ClassificationCode := 'C';
                    end else if (TotalSales >= 10000) and (TotalSales <= 30000) then begin
                        ClassificationCode := 'B';
                    end else if TotalSales > 30000 then
                            ClassificationCode := 'A';

                Customer."Customer Sales Classification" := ClassificationCode;
                Customer.Modify(false);
            end;
        }

        // dataitem(SummaryLoop; Integer)
        // {
        //     trigger OnPreDataItem()
        //     begin
        //         Clear(Total_Sales_Amount);
        //         Clear(Sales_Amount_80);
        //         Clear(Sales_Amount_95);

        //         temp_CustLedgEntry.Reset();
        //         if temp_CustLedgEntry.FindSet() then begin
        //             repeat
        //                 Total_Sales_Amount += temp_CustLedgEntry."Amount to Apply";
        //             until temp_CustLedgEntry.Next() = 0;
        //         end;

        //         Sales_Amount_80 := (Total_Sales_Amount * 80) / 100;
        //         Sales_Amount_95 := (Total_Sales_Amount * 95) / 100;

        //         temp_CustLedgEntry.Reset();
        //         temp_CustLedgEntry.SetCurrentKey(temp_CustLedgEntry."Amount to Apply");
        //         temp_CustLedgEntry.SetAscending(temp_CustLedgEntry."Amount to Apply", false);
        //         SetRange(Number, 1, temp_CustLedgEntry.Count);
        //     end;

        //     trigger OnAfterGetRecord()
        //     begin
        //         if Number = 1 then
        //             temp_CustLedgEntry.FindFirst()
        //         else
        //             temp_CustLedgEntry.Next();

        //         Loop_Sales_Amount += temp_CustLedgEntry."Amount to Apply";

        //         rec_Customer.Reset();
        //         rec_Customer.SetRange("No.", temp_CustLedgEntry."Customer No.");
        //         if rec_Customer.FindFirst() then begin
        //             if Loop_Sales_Amount < Sales_Amount_80 then begin
        //                 rec_Customer."Customer Sales Classification" := 'A';
        //                 rec_Customer.Modify(false);
        //             end else
        //                 if (Loop_Sales_Amount >= Sales_Amount_80) and (Loop_Sales_Amount < Sales_Amount_95) then begin
        //                     rec_Customer."Customer Sales Classification" := 'B';
        //                     rec_Customer.Modify(false);
        //                 end else
        //                     if Loop_Sales_Amount >= Sales_Amount_95 then begin
        //                         rec_Customer."Customer Sales Classification" := 'C';
        //                         rec_Customer.Modify(false);
        //                     end
        //         end
        //     end;

        //     trigger OnPostDataItem()
        //     begin
        //         temp_CustLedgEntry.DeleteAll();
        //     end;
        // }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AsOfDate; AsOfDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'As Of Date';
                    }
                    // field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'New Page per Vendor';
                    //     ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                    // }
                }
            }
        }

        actions
        {
        }
    }

    var
        //temp_ItemLedgEntry: Record "Item Ledger Entry" temporary;
        //Entry_No: Integer;
        //Total_Sales_Amount: Decimal;
        //Sales_Amount_80: Decimal;
        //Sales_Amount_95: Decimal;
        //Loop_Sales_Amount: Decimal;
        rec_Customer: Record Customer;
        From_Date, To_Date : Date;
        TotalSales: Decimal;
        FirstPostingDate: Date;
        AvgSales: Decimal;
        NumOfMonthsBetween: Integer;
        ClassificationCode: Code[1];
        ILE: Record "Item Ledger Entry";
        PeriodDate: Record Date;
        AsOfDate: Date;

    // local procedure InsertIntoTemp(par_CLE: Record "Cust. Ledger Entry")
    // begin
    //     temp_CustLedgEntry.Reset();
    //     temp_CustLedgEntry.SetRange("Customer No.", par_CLE."Customer No.");
    //     if not temp_CustLedgEntry.FindFirst() then begin
    //         if Entry_No = 0 then
    //             Entry_No := 1
    //         else
    //             Entry_No += 1;

    //         temp_CustLedgEntry.Reset();
    //         temp_CustLedgEntry.Init();
    //         temp_CustLedgEntry."Entry No." := Entry_No;
    //         temp_CustLedgEntry."Customer No." := par_CLE."Customer No.";
    //         temp_CustLedgEntry."Amount to Apply" := par_CLE."Amount (LCY)"; // Sales Amount
    //         temp_CustLedgEntry.Insert(false);
    //     end else begin
    //         temp_CustLedgEntry."Amount to Apply" += par_CLE."Amount (LCY)"; // Sales Amount
    //         temp_CustLedgEntry.Modify(false);
    //     end;
    // end;
}