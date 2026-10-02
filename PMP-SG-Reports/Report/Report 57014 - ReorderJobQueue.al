report 57014 "Reorder Job Queue"
{
    ApplicationArea = All;
    Caption = 'Reorder Job Queue';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    //DX        01 Aug 2021;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                ILERec: Record "Item Ledger Entry";
                TotalSales: Decimal;
                SSSetup: Record "Sales & Receivables Setup";
                //DX        29 Aug 2021
                HistObRec: Record "Historical Item Sales";
                HistSales: Decimal;
                StockKeepRec: Record "Stockkeeping Unit";
                StockKeepRec2: Record "Stockkeeping Unit";
                CompanyInfo: Record "Company Information";
                InvBal: Decimal;
                CreateReport: Report "Create Stockkeeping Unit";
                PMPCU: Codeunit "PMP-Enhancements";
                DateVal: Date;
                NoOfYears: Integer;
                NoOfMonths: Integer;
            //DX        29 Aug 2021
            begin
                if Item."Reordering Policy" <> Item."Reordering Policy"::" " then begin
                    HistSales := 0;
                    HistObRec.reset;
                    HistObRec.SetRange("Item No.", Item."No.");
                    HistObRec.SetFilter("Posting Date", '%1..%2', FirstStartDate, SecondEndDate);
                    HistObRec.SetRange("Entry Type", HistObRec."Entry Type"::"Sales Shipment");
                    HistObRec.SetLoadFields(Quantity);
                    If HistObRec.Findset Then
                        Repeat
                            HistSales += HistObRec.Quantity;
                        Until HistObRec.Next = 0;


                    ILERec.reset;
                    ILERec.SetRange("Item No.", Item."No.");
                    ILERec.SetFilter("Posting Date", '%1..%2', FirstStartDate, SecondEndDate);
                    ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale); //RL 01 Dec 2021 add filter
                    ILERec.SetLoadFields(Quantity);
                    ILERec.CalcSums(Quantity);
                    TotalSales := ILERec.Quantity * -1; //RL 01Dec2021 change sign
                    TotalSales := TotalSales + HistSales;
                    if Item."Max Holding Days" <> 0 then begin
                        //Item.Validate("Reorder Point", 10);
                        if TotalSales <> 0 then
                            Item.Validate("Maximum Inventory", round((TotalSales / 2) * (Item."Max Holding Days" / 20), 1, '='));
                        Item.Modify(TRUE);
                    end;

                    if Item."Min Holding Days" <> 0 then begin
                        //Item.Validate("Reorder Point", 10);
                        if TotalSales <> 0 then
                            Item.Validate("Reorder Point", round((TotalSales / 2) * (Item."Min Holding Days" / 20), 1, '='));
                        if item."Reorder Point" < 1 then
                            item.Validate("Reorder Point", 1);
                        //Item.Validate("Minimum Order Quantity", round((TotalSales / 2) * (Item."Min Holding Days" / 20), 1, '='));
                        Item.Modify(TRUE);
                    end;

                    CompanyInfo.reset;
                    CompanyInfo.get;
                    StockKeepRec.reset;
                    StockKeepRec.SetRange("Item No.", Item."No.");
                    StockKeepRec.SetRange("Location Code", CompanyInfo."Location Code");
                    if StockKeepRec.FindFirst() then begin
                        stockkeepRec."Reordering Policy" := Item."Reordering Policy";
                        StockKeepRec."Maximum Inventory" := Item."Maximum Inventory";
                        StockKeepRec."Reorder Point" := Item."Reorder Point";
                        StockKeepRec."Order Multiple" := item."Order Multiple";
                        StockKeepRec."Vendor No." := item."Vendor No.";
                        StockKeepRec."Phys Invt Counting Period Code" := item."Phys Invt Counting Period Code";  //RL        15 Mar 2022
                        StockKeepRec.Modify(true);
                    end else begin
                        CreateReport.CreateSKU(Item, CompanyInfo."Location Code", '');
                        StockKeepRec2.reset;
                        StockKeepRec2.SetRange("Item No.", Item."No.");
                        StockKeepRec2.SetRange("Location Code", CompanyInfo."Location Code");
                        if StockKeepRec2.FindFirst() then begin
                            stockkeepRec2."Reordering Policy" := Item."Reordering Policy";
                            StockKeepRec2."Maximum Inventory" := Item."Maximum Inventory";
                            StockKeepRec2."Reorder Point" := Item."Reorder Point";
                            StockKeepRec2."Order Multiple" := item."Order Multiple";
                            StockKeepRec2."Vendor No." := item."Vendor No.";
                            StockKeepRec2."Phys Invt Counting Period Code" := item."Phys Invt Counting Period Code";  //RL        15 Mar 2022
                            StockKeepRec2.Modify(true);
                        end;

                    end;

                    /*
                                        //DX        29 Aug 2021
                                        Item.SetRange("Location Filter", CompanyInfo."Location Code");
                                        Item.CalcFields(Inventory);
                                        InvBal := Item.Inventory;
                                        if InvBal = 0 then begin
                                            Item."Item Status" := 'OUT OF STOCK - PRINCIPAL';
                                            Item.Modify(FALSE);
                                        end;
                                        */

                    dateVal := PMPCU.GetItemEarliestExpiration(Item."No.", CompanyInfo."Location Code");
                    if DateVal <> 0D then begin
                        NoOfYears := DATE2DMY(DateVal, 3) - DATE2DMY(Today, 3);
                        NoOfMonths := DATE2DMY(DateVal, 2) - DATE2DMY(Today, 2);
                        // error('%1..%2..%3', NoOfMonths, NoOfYears, (12 * NoOfYears + NoOfMonths));
                        if (12 * NoOfYears + NoOfMonths) <= 12 then begin
                            if Item."Item Status" = 'ACTIVE' then begin
                                Item."Item Status" := 'ACTIVE (SHORT-EXPIRY)';
                                Item.Modify(FALSE);
                            end;
                        end;
                    end;


                    //DX        29 Aug 2021

                end;
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
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        //DX        01 Aug 2021 : Today =  1st Aug, to get 
        //1st July - 31 July
        SecondStartDate := CalcDate('<-CM-1M>', Today);
        SecondEndDate := CalcDate('<CM-1M>', Today);
        //1st June - 30 June
        FirstStartDate := CalcDate('<-CM-2M>', Today);
        FirstEndDate := CalcDate('<CM-2M>', Today);


    end;

    var
        FirstStartDate: Date;
        FirstEndDate: Date;
        SecondStartDate: Date;
        SecondEndDate: Date;
}
