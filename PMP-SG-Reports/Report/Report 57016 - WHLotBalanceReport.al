report 57016 "WH Lot Balance Report"
{
    ApplicationArea = All;
    Caption = 'WH Lot Balance Report';
    RDLCLayout = './ReportLayouts/ReportLayout 57016 - LotBalance Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata "Whse. Item Tracking Line" = rimd;
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = sorting(number);
            column(Item_No; LotBal.Item_No)
            {
            }
            column(Description; ItemDescription)
            {

            }
            column(ExprDate; FORMAT(LotBal.Expiration_Date))
            {

            }
            column(Bin_Code; LotBal.Bin_Code)
            {

            }
            column(LotNo; LotBal.Lot_No)
            {

            }
            column(Qty; LotBal.Sum_Qty)
            {

            }
            column(QtyBase; LotBal.Sum_Qty_Base)
            {

            }
            column(UOM; LotBal.Unit_of_Measure_Code)
            {

            }
            column(ZoneCode; LotBal.Zone_Code)
            {

            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                LotBal.Open();
                if GenerateJournals = true then begin
                    // if Confirm('Are you sure you wish to generate warehouse journals?') then begin
                    CompInfo.reset;
                    CompInfo.get;
                    SSSetup.reset;
                    SSSetup.get;
                    SSSetup.TestField("Def. Disposal Bin");
                    SSSetup.TestField("Def. Clearance Bin")
                    // end else
                    //     CurrReport.Break();

                end;

            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if not LotBal.Read() then
                    CurrReport.Break();

                ItemRec.reset;
                ItemRec.SetRange("No.", LotBal.Item_No);
                if ItemRec.FindFirst() then begin
                    ItemDescription := ItemRec.Description;
                end else
                    ItemDescription := '';


                if GenerateJournals = true then begin
                    if (LotBal.Expiration_Date <> 0D) and (LotBal.Location_Code = CompInfo."Location Code") and (LotBal.Zone_Code <> 'RECEIVE') then begin //RL 29 Nov 2021 add location filter
                        IF LessThan2Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN BEGIN
                            BatchName := 'Obsolete';
                            WhseMovementLine.RESET;
                            WhseMovementLine.SETRANGE("Worksheet Template Name", 'MOVEMENT');
                            WhseMovementLine.SETRANGE(Name, BatchName);
                            WhseMovementLine.SETRANGE("Location Code", CompInfo."Location Code");
                            IF WhseMovementLine.FINDLAST THEN BEGIN
                                LineNo := WhseMovementLine."Line No." + 10000
                            END ELSE
                                LineNo := 10000;
                            WhseMovementLine.RESET;
                            WhseMovementLine.INIT;
                            WhseMovementLine.VALIDATE("Worksheet Template Name", 'MOVEMENT');
                            WhseMovementLine.VALIDATE(Name, BatchName);
                            WhseMovementLine.VALIDATE("Location Code", CompInfo."Location Code");
                            WhseMovementLine.VALIDATE("Line No.", LineNo);
                            WhseMovementLine.VALIDATE("Item No.", LotBal.Item_No);
                            WhseMovementLine.VALIDATE("From Zone Code", LotBal.Zone_Code);
                            WhseMovementLine.VALIDATE("From Bin Code", LotBal.Bin_Code);
                            WhseMovementLine.VALIDATE("To Zone Code", getzonecode(SSSetup."Def. Disposal Bin"));
                            WhseMovementLine.VALIDATE("To Bin Code", SSSetup."Def. Disposal Bin");
                            WhseMovementLine.Validate("Unit of Measure Code", LotBal.Unit_of_Measure_Code);
                            WhseMovementLine.VALIDATE(Quantity, LotBal.Sum_Qty);
                            WhseMovementLine.Validate("Qty. to Handle", LotBal.Sum_Qty);
                            if WhseMovementLine.CheckAvailQtytoMove < LotBal.Sum_Qty then
                                WhseMovementLine.Validate("Qty. to Handle", WhseMovementLine.CheckAvailQtytoMove);
                            WhseMovementLine.INSERT(TRUE);

                            WhseResEntry.RESET;
                            IF WhseResEntry.FINDLAST THEN BEGIN
                                entryNo := WhseResEntry."Entry No." + 1
                            END ELSE BEGIN
                                entryNo := 1;
                            END;

                            WhseResEntry.RESET;
                            WhseResEntry.INIT;
                            WhseResEntry.VALIDATE("Entry No.", entryNo);
                            WhseResEntry.VALIDATE("Item No.", LotBal.Item_No);
                            WhseResEntry.VALIDATE("Location Code", LotBal.Location_Code);
                            WhseResEntry.VALIDATE("Source Type", 7326);
                            WhseResEntry.VALIDATE("Source ID", BatchName);
                            WhseResEntry.VALIDATE("Source Batch Name", 'MOVEMENT');
                            WhseResEntry.VALIDATE("Source Ref. No.", LineNo);
                            WhseResEntry.VALIDATE("Lot No.", LotBal.Lot_No);
                            WhseResEntry.VALIDATE("Expiration Date", LotBal.Expiration_Date);
                            WhseResEntry.VALIDATE("Quantity (Base)", LotBal.Sum_Qty_Base);
                            //WhseResEntry.VALIDATE("Qty. to Handle",LotBal.Sum_Qty_Base);
                            WhseResEntry.INSERT(TRUE);

                        END ELSE
                            // IF AlreadyExpired(LotBal.Item_No, LotBal.Expiration_Date) THEN BEGIN
                            IF LessThan3Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN BEGIN //RL 29 Nov 2021 change to less than 2 months
                                BatchName := 'Clearance';//Change to obsolete
                                WhseMovementLine.RESET;
                                WhseMovementLine.SETRANGE("Worksheet Template Name", 'MOVEMENT');
                                WhseMovementLine.SETRANGE(Name, BatchName);
                                WhseMovementLine.SETRANGE("Location Code", CompInfo."Location Code");
                                IF WhseMovementLine.FINDLAST THEN BEGIN
                                    LineNo := WhseMovementLine."Line No." + 10000
                                END ELSE
                                    LineNo := 10000;

                                WhseMovementLine.RESET;
                                WhseMovementLine.INIT;
                                WhseMovementLine.VALIDATE("Worksheet Template Name", 'MOVEMENT');
                                WhseMovementLine.VALIDATE(Name, BatchName);
                                WhseMovementLine.VALIDATE("Location Code", CompInfo."Location Code");
                                WhseMovementLine.VALIDATE("Line No.", LineNo);
                                WhseMovementLine.VALIDATE("Item No.", LotBal.Item_No);
                                WhseMovementLine.VALIDATE("From Zone Code", LotBal.Zone_Code);
                                WhseMovementLine.VALIDATE("From Bin Code", LotBal.Bin_Code);
                                WhseMovementLine.VALIDATE("To Zone Code", GetZoneCode(SSSetup."Def. Clearance Bin"));
                                WhseMovementLine.VALIDATE("To Bin Code", SSSetup."Def. Clearance Bin");
                                WhseMovementLine.Validate("Unit of Measure Code", LotBal.Unit_of_Measure_Code);
                                WhseMovementLine.VALIDATE(Quantity, LotBal.Sum_Qty);
                                WhseMovementLine.Validate("Qty. to Handle", LotBal.Sum_Qty);
                                if WhseMovementLine.CheckAvailQtytoMove < LotBal.Sum_Qty then
                                    WhseMovementLine.Validate("Qty. to Handle", WhseMovementLine.CheckAvailQtytoMove);
                                WhseMovementLine.INSERT(TRUE);

                                WhseResEntry.RESET;
                                IF WhseResEntry.FINDLAST THEN BEGIN
                                    entryNo := WhseResEntry."Entry No." + 1
                                END ELSE BEGIN
                                    entryNo := 1;
                                END;

                                WhseResEntry.RESET;
                                WhseResEntry.INIT;
                                WhseResEntry.VALIDATE("Entry No.", entryNo);
                                WhseResEntry.VALIDATE("Item No.", LotBal.Item_No);
                                WhseResEntry.VALIDATE("Location Code", LotBal.Location_Code);
                                WhseResEntry.VALIDATE("Source Type", 7326);
                                WhseResEntry.VALIDATE("Source ID", BatchName);
                                WhseResEntry.VALIDATE("Source Batch Name", 'MOVEMENT');
                                WhseResEntry.VALIDATE("Source Ref. No.", LineNo);
                                WhseResEntry.VALIDATE("Lot No.", LotBal.Lot_No);
                                WhseResEntry.VALIDATE("Expiration Date", LotBal.Expiration_Date);
                                WhseResEntry.VALIDATE("Quantity (Base)", LotBal.Sum_Qty_Base);
                                //WhseResEntry.VALIDATE("Qty. to Handle",LotBal.Sum_Qty_Base);
                                WhseResEntry.INSERT(TRUE);
                            END;
                    end;

                END;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(GenerateJournals; GenerateJournals)
                    {
                        ApplicationArea = all;
                        Caption = 'Generate Journals';
                        ToolTip = 'Check this to generate the warehouse journals';
                    }
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
    local procedure LessThan12Mth(ItemCode: Code[20]; ExprDate: Date): Boolean
    var
        myInt: Integer;
    begin

        IF (ExprDate - TODAY) <= 365 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    // local procedure LessThan2Mth(ItemCode: Code[20]; ExprDate: Date): Boolean
    // var
    //     myInt: Integer;
    // begin
    //     IF ((ExprDate - TODAY) <= 60) and (ExprDate - Today > 0) THEN
    //         EXIT(TRUE)
    //     ELSE
    //         EXIT(FALSE);
    // end;
    local procedure LessThan2Mth(ItemCode: Code[20]; ExprDate: Date): Boolean //Less than 3mths more than 2 mths
    var
        myInt: Integer;
        ExprDate1: Date;
        ExprDate2: Date;
    begin
        Clear(ExprDate1);
        Clear(ExprDate2);
        ExprDate1 := CalcDate('2M', Today);
        // ExprDate2 := CalcDate('-2M', ExprDate1);
        // IF (ExprDate<ExprDate1) and (ExprDate>=ExprDate2) THEN
        IF ExprDate < ExprDate1 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure LessThan3Mth(ItemCode: Code[20]; ExprDate: Date): Boolean //Less than 3mths more than 2 mths
    var
        myInt: Integer;
        ExprDate1: Date;
        ExprDate2: Date;
    begin
        Clear(ExprDate1);
        Clear(ExprDate2);
        ExprDate1 := CalcDate('3M', Today);
        // ExprDate2 := CalcDate('-2M', ExprDate1);
        // IF (ExprDate < ExprDate1) and (ExprDate >= ExprDate2) THEN
        IF ExprDate < ExprDate1 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure AlreadyExpired(ItemCode: Code[20]; ExprDate: Date): Boolean
    var
        myInt: Integer;
    begin
        IF (ExprDate - TODAY) < 0 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure GetZoneCode(BinCode: Code[20]): Code[20]
    var
        myInt: Integer;
        BinRec: Record Bin;
    begin
        BinRec.Reset();
        Binrec.SetRange(Code, BinCode);
        if BinRec.FindFirst() then
            exit(BinRec."Zone Code");
    end;

    var
        GenerateJournals: Boolean;
        LotBal: Query "Lot Numbers by Bin For Rpt";     //DX        15 Jul 2023, use duplicate query to allow MS Update
        WhseMovementLine: Record "Whse. Worksheet Line";
        lineNo: integer;
        WhseResEntry: Record "Whse. Item Tracking Line";
        EntryNo: Integer;
        CompInfo: Record "Company Information";
        SSSetup: Record "Sales & Receivables Setup";
        ItemDescription: Text[100];
        ItemRec: Record item;
        BatchName: Code[50];
}
