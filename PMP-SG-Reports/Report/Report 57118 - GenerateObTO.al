report 57118 "GenerateObTO"
{
    ApplicationArea = All;
    Caption = 'Generate OB Transfer Order';
    RDLCLayout = './ReportLayouts/ReportLayout 57118 - GenerateObTO.rdl';
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
            begin
                LotBal.Open();
                if GenerateJournals = true then begin
                    CompInfo.reset;
                    CompInfo.get;
                    SSSetup.reset;
                    SSSetup.get;
                    SSSetup.TestField("Def. Disposal Bin");
                    SSSetup.TestField("Def. Clearance Bin");
                    SSSetup.TestField("Spec Clearance Bin");
                    SSSetup.TestField("Spec Disposal Bin");
                    SSSetup.TestField("Exchange Disposal Bin");
                end;
            end;

            trigger OnAfterGetRecord()
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
                    // if (LotBal.Expiration_Date <> 0D) and (LotBal.Location_Code = CompInfo."Location Code") and (LotBal.Zone_Code <> 'RECEIVE') then begin //RL 29 Nov 2021 add location filter
                    if (LotBal.Expiration_Date <> 0D)
                        and (LotBal.Location_Code = CompInfo."Location Code")
                        and (LotBal.Zone_Code <> 'RECEIVE')
                        and (LotBal.Sum_Qty > 0) then begin //RL 29 Nov 2021 add location filter // YF 08 Dec 2022 Make sure Qty Positive
                        if LotBal.Exchangeable = true then begin
                            IF LessThan6Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN begin
                                BatchName := 'Exchange';

                                if ExchangeTransDocNo = '' then // YF 22 Feb 2022
                                    ExchangeTransDocNo := CreateTHRec(BatchName);

                                // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                if ExchangeTransDocNo = '' then
                                    CurrReport.Skip();
                                // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                CreateTHLine(ExchangeTransDocNo, LotBal.Item_No, LotBal.Unit_of_Measure_Code, SSSetup."Exchange Disposal Bin", LotBal.Sum_Qty, LotBal.Sum_Qty_Base, LotBal.Lot_No);
                            end else begin
                                CurrReport.Skip();
                            end;
                        end else begin
                            if LotBal.Global_Dimension_1_Code in ['1 PROPRIETARY BRAND', '2 SPECIALTY PHARMA'] then begin
                                IF LessThan3Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN begin

                                    BatchName := 'Specialty 3mth';

                                    if SP3mthTransDocNo = '' then // YF 22 Feb 2022
                                        SP3mthTransDocNo := CreateTHRec(BatchName);

                                    // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                    if SP3mthTransDocNo = '' then
                                        CurrReport.Skip();
                                    // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                    CreateTHLine(SP3mthTransDocNo, LotBal.Item_No, LotBal.Unit_of_Measure_Code, SSSetup."Spec Disposal Bin", LotBal.Sum_Qty, LotBal.Sum_Qty_Base, LotBal.Lot_No);
                                end else begin
                                    IF LessThan6Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN begin
                                        BatchName := 'Specialty 6mth';

                                        if SP6mthTransDocNo = '' then // YF 22 Feb 2022
                                            SP6mthTransDocNo := CreateTHRec(BatchName);

                                        // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                        if SP6mthTransDocNo = '' then
                                            CurrReport.Skip();
                                        // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                        CreateTHLine(SP6mthTransDocNo, LotBal.Item_No, LotBal.Unit_of_Measure_Code, SSSetup."Spec Clearance Bin", LotBal.Sum_Qty, LotBal.Sum_Qty_Base, LotBal.Lot_No);
                                    end;
                                end;
                            end else begin
                                if LotBal.Global_Dimension_1_Code in ['3.1 WHOLESALE', '3.2 HOUSEBRAND'] then begin
                                    IF LessThan3Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN begin

                                        BatchName := 'Housebrand 3mth';

                                        if HB3mthTransDocNo = '' then // YF 22 Feb 2022
                                            HB3mthTransDocNo := CreateTHRec(BatchName);

                                        // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                        if HB3mthTransDocNo = '' then
                                            CurrReport.Skip();
                                        // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                        CreateTHLine(HB3mthTransDocNo, LotBal.Item_No, LotBal.Unit_of_Measure_Code, SSSetup."Def. Disposal Bin", LotBal.Sum_Qty, LotBal.Sum_Qty_Base, LotBal.Lot_No);
                                    end else begin
                                        IF LessThan6Mth(LotBal.Item_No, LotBal.Expiration_Date) THEN begin
                                            BatchName := 'Housebrand 6mth';

                                            if HB6mthTransDocNo = '' then // YF 22 Feb 2022
                                                HB6mthTransDocNo := CreateTHRec(BatchName);

                                            // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                            if HB6mthTransDocNo = '' then
                                                CurrReport.Skip();
                                            // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                                            CreateTHLine(HB6mthTransDocNo, LotBal.Item_No, LotBal.Unit_of_Measure_Code, SSSetup."Def. Clearance Bin", LotBal.Sum_Qty, LotBal.Sum_Qty_Base, LotBal.Lot_No);
                                        end;
                                    end;
                                end;

                            end;
                        end;
                    end;
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
                group(Options)
                {
                    field(GenerateJournals; GenerateJournals)
                    {
                        ApplicationArea = all;
                        Caption = 'Generate Transfer Orders';
                        ToolTip = 'Check this to generate the transfer orders';
                    }
                }
            }
        }
    }

    // YF 22 Feb 2022
    trigger OnInitReport()
    begin
        ObsTransDocNo := '';
        ClrTransDocNo := '';
        ObsLineNo := 0;
        ClrLineNo := 0;
    end;
    // YF 22 Feb 2022

    local procedure LessThan12Mth(ItemCode: Code[20]; ExprDate: Date): Boolean
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

    local procedure LessThan3Mth(ItemCode: Code[20]; ExprDate: Date): Boolean //Less than 3mths
    var
        ExprDate1: Date;
        ExprDate2: Date;
    begin
        Clear(ExprDate1);
        Clear(ExprDate2);
        //ExprDate1 := CalcDate('2M', Today);//RL 20231117 to change to 3 months
        ExprDate1 := CalcDate('3M', Today);
        // ExprDate2 := CalcDate('-2M', ExprDate1);
        // IF (ExprDate<ExprDate1) and (ExprDate>=ExprDate2) THEN
        IF ExprDate < ExprDate1 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure LessThan6Mth(ItemCode: Code[20]; ExprDate: Date): Boolean //Less than 6mths
    var
        ExprDate1: Date;
        ExprDate2: Date;
    begin
        Clear(ExprDate1);
        Clear(ExprDate2);
        //ExprDate1 := CalcDate('3M', Today);//RL 20231117 to change to 6 months
        ExprDate1 := CalcDate('6M', Today);
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

    local procedure GetLocationCode(BinCode: Code[20]): Code[20]
    var
        myInt: Integer;
        BinRec: Record Bin;
    begin
        BinRec.Reset();
        Binrec.SetRange(Code, BinCode);
        if BinRec.FindFirst() then
            exit(BinRec."Location Code");
    end;

    local procedure CreateTHRec(BatchName: Code[50]) DocNo: code[20]
    var
        SSSetup: Record "Sales & Receivables Setup";
        THRec: Record "Transfer Header";
        CompInfo: Record "Company Information";
    begin
        SSSetup.Reset;
        SSSetup.Get;
        CompInfo.Reset;
        CompInfo.Get;
        THRec.Reset;
        THRec.Init;
        case BatchName of
            'Housebrand 3mth':
                begin
                    THRec.Validate("Transfer-from Code", CompInfo."Location Code");
                    THRec.Validate("Transfer-to Code", GetLocationCode(SSSetup."Def. Disposal Bin"));
                    THRec.Validate("Transfer-To Bin Code", SSSetup."Def. Disposal Bin");

                end;
            'Housebrand 6mth':
                begin
                    THRec.Validate("Transfer-from Code", CompInfo."Location Code");
                    THRec.Validate("Transfer-to Code", GetLocationCode(SSSetup."Def. Clearance Bin"));
                    THRec.Validate("Transfer-To Bin Code", SSSetup."Def. Clearance Bin");
                end;
            'Specialty 3mth':
                begin
                    THRec.Validate("Transfer-from Code", CompInfo."Location Code");
                    THRec.Validate("Transfer-to Code", GetLocationCode(SSSetup."Spec Disposal Bin"));
                    THRec.Validate("Transfer-To Bin Code", SSSetup."Spec Disposal Bin");
                end;
            'Specialty 6mth':
                begin
                    THRec.Validate("Transfer-from Code", CompInfo."Location Code");
                    THRec.Validate("Transfer-to Code", GetLocationCode(SSSetup."Spec Clearance Bin"));
                    THRec.Validate("Transfer-To Bin Code", SSSetup."Spec Clearance Bin");
                end;
            'Exchange':
                begin
                    THRec.Validate("Transfer-from Code", CompInfo."Location Code");
                    THRec.Validate("Transfer-to Code", GetLocationCode(SSSetup."Exchange Disposal Bin"));
                    THRec.Validate("Transfer-To Bin Code", SSSetup."Exchange Disposal Bin");
                end;

        end;

        THRec.Insert(true);
        // THRec.Modify(true);

        exit(THRec."No.");
    end;

    local procedure CreateTHLine(par_DocNo: Code[20]; par_ItemNo: code[20]; par_uom: Code[20]; par_ToBin: code[20]; par_Qty: Decimal; par_QtyBase: Decimal; par_lotno: Code[50])

    var
        lrec_TransLine: Record "Transfer Line";
        lrec_ResEntry: Record "Reservation Entry";

        lrec_lineno: Integer;
    begin
        lrec_TransLine.RESET;
        lrec_TransLine.INIT;
        lrec_TransLine.SetRange("Document No.", par_DocNo);
        IF lrec_TransLine.FINDLAST THEN BEGIN
            lrec_lineno := lrec_TransLine."Line No." + 10000 // YF 22 Feb 2022
        END ELSE
            lrec_lineno := 10000; // YF 22 Feb 2022



        lrec_TransLine.Validate("Document No.", par_DocNo);
        lrec_TransLine.VALIDATE("Line No.", lrec_lineno);
        lrec_TransLine.VALIDATE("Item No.", par_ItemNo);
        lrec_TransLine.VALIDATE("Transfer-To Bin Code", par_ToBin);
        lrec_TransLine.Validate("Unit of Measure Code", par_uom);
        lrec_TransLine.VALIDATE(Quantity, par_Qty);

        // YF 22 Feb 2022
        if lrec_TransLine.INSERT(TRUE) then begin
            lrec_ResEntry.RESET;
            IF lrec_ResEntry.FINDLAST THEN BEGIN
                EntryNo := lrec_ResEntry."Entry No." + 1
            END ELSE BEGIN
                EntryNo := 1;
            END;

            // FROM
            lrec_ResEntry.RESET;
            lrec_ResEntry.INIT;
            lrec_ResEntry.VALIDATE("Entry No.", EntryNo);
            lrec_ResEntry.VALIDATE("Item No.", par_ItemNo);
            lrec_ResEntry.VALIDATE("Location Code", CompInfo."Location Code");
            lrec_ResEntry.Validate("Reservation Status", lrec_ResEntry."Reservation Status"::Surplus);
            lrec_ResEntry.VALIDATE("Source Type", 5741);
            lrec_ResEntry.Validate("Source Subtype", 0);
            lrec_ResEntry.VALIDATE("Source ID", par_DocNo);

            // ResEntry.VALIDATE("Source Batch Name", 'MOVEMENT');
            lrec_ResEntry.Validate(Positive, false);
            lrec_ResEntry.VALIDATE("Source Ref. No.", lrec_lineno);
            lrec_ResEntry.VALIDATE("Lot No.", par_lotno);
            // ResEntry.VALIDATE("Expiration Date", LotBal.Expiration_Date);
            lrec_ResEntry.VALIDATE("Quantity (Base)", -par_QtyBase);
            //ResEntry.VALIDATE("Qty. to Handle",LotBal.Sum_Qty_Base);
            lrec_ResEntry.INSERT(TRUE);

            EntryNo := EntryNo + 1; // increment for next res. ent. line

            // TO
            lrec_ResEntry.RESET;
            lrec_ResEntry.INIT;
            lrec_ResEntry.VALIDATE("Entry No.", EntryNo);
            lrec_ResEntry.VALIDATE("Item No.", par_ItemNo);
            // ResEntry.VALIDATE("Location Code", SSSetup."Def. Disposal Bin");//RL20231117 hardcode to obsolete location

            lrec_ResEntry.VALIDATE("Location Code", GetLocationCode(par_ToBin));
            lrec_ResEntry.Validate("Reservation Status", lrec_ResEntry."Reservation Status"::Surplus);
            lrec_ResEntry.VALIDATE("Source Type", 5741);
            lrec_ResEntry.Validate("Source Subtype", 1);
            lrec_ResEntry.VALIDATE("Source ID", par_DocNo);

            // ResEntry.VALIDATE("Source Batch Name", 'MOVEMENT');
            lrec_ResEntry.Validate(Positive, true);
            lrec_ResEntry.VALIDATE("Source Ref. No.", lrec_lineno);
            lrec_ResEntry.VALIDATE("Lot No.", par_lotno);
            // ResEntry.VALIDATE("Expiration Date", LotBal.Expiration_Date);
            lrec_ResEntry.VALIDATE("Quantity (Base)", par_QtyBase);
            //ResEntry.VALIDATE("Qty. to Handle",LotBal.Sum_Qty_Base);
            lrec_ResEntry.INSERT(TRUE);
        end;
    end;

    var
        GenerateJournals: Boolean;
        //LotBal: Query "Lot Numbers by Bin Custom"; //DX     15 Jul 2023     Reference new query
        LotBal: Query "Lot Numbers by Bin For Rpt"; //DX     15 Jul 2023     Reference new query
        WhseMovementLine: Record "Whse. Worksheet Line";
        WhseResEntry: Record "Whse. Item Tracking Line";
        EntryNo: Integer;
        CompInfo: Record "Company Information";
        SSSetup: Record "Sales & Receivables Setup";
        ItemDescription: Text[100];
        ItemRec: Record item;
        BatchName: Code[50];
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        ResEntry: Record "Reservation Entry";
        ObsTransDocNo, ExchangeTransDocNo, HB3mthTransDocNo, HB6mthTransDocNo, SP3mthTransDocNo, SP6mthTransDocNo : Code[20]; // YF 22 Feb 2022
        ClrTransDocNo: Code[20]; // YF 22 Feb 2022
        ObsLineNo: Integer; // YF 22 Feb 2022
        ClrLineNo: Integer; // YF 22 Feb 2022

}
