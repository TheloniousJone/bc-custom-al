report 57129 "GenerateW1W33ProcessOnly"
{
    ApplicationArea = All;
    Caption = 'Generate W1 W33 Process Only';
    RDLCLayout = './ReportLayouts/ReportLayout 57129 - GenerateW1W33ProcessOnly.rdl';
    UsageCategory = ReportsAndAnalysis;
    //ProcessingOnly = true;
    Permissions = tabledata "Whse. Item Tracking Line" = rimd;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = sorting(number);
            column(Item_No; IleRec."Item No.")
            {
            }
            column(Description; ItemDescription)
            {

            }
            column(ExprDate; FORMAT(IleRec."Expiration Date"))
            {

            }

            column(LotNo; IleRec."Lot No.")
            {

            }
            column(Qty; IleRec."Remaining Quantity")
            {

            }
            column(QtyBase; IleRec."Remaining Quantity")
            {

            }
            column(UOM; IleRec."Unit of Measure Code")
            {

            }


            trigger OnPreDataItem()
            begin

                RepBreak := true;
                IleRec.reset();
                IleRec.setfilter("Location Code", '%1|%2', 'W1', 'W33');
                IleRec.setfilter("Remaining Quantity", '>%1', 0);
                IleRec.SetFilter("Expiration Date", '<%1', CalcDate('3M', Today));
                if IleRec.Findset() then begin
                    RepBreak := false;
                end;

                GenerateJournals := true;


                if GenerateJournals = true then begin
                    CompInfo.reset;
                    CompInfo.get;
                    SSSetup.reset;
                    SSSetup.get;
                    SSSetup.TestField("Def. Disposal Bin");
                    SSSetup.TestField("Def. Clearance Bin")
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                // if RepBreak then
                //     CurrReport.Break();
                ItemRec.reset;
                ItemRec.SetRange("No.", IleRec."Item No.");
                ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                if not ItemRec.FindFirst() then begin
                    IleRec.Next();
                    CurrReport.skip;
                end;

                ItemDescription := IleRec.Description;


                if GenerateJournals = true then begin
                    // if (LotBal.Expiration_Date <> 0D) and (LotBal.Location_Code = CompInfo."Location Code") and (LotBal.Zone_Code <> 'RECEIVE') then begin //RL 29 Nov 2021 add location filter

                    IF LessThan3Mth(IleRec."Item No.", IleRec."Expiration Date") THEN //RL 29 Nov 2021 change to less than 2 months
                        begin
                        BatchName := 'W44';

                        if ClrTransDocNo = '' then // YF 22 Feb 2022
                            ClrTransDocNo := CreateTHRec(BatchName);

                        // YF 22 Feb 2022 // Error handling on TO Header Insert failure
                        if ClrTransDocNo = '' then begin
                            IleRec.Next();
                            CurrReport.Skip();
                        end;
                        // YF 22 Feb 2022 // Error handling on TO Header Insert failure

                        TransLine.RESET;
                        TransLine.INIT;
                        TransLine.SetRange("Document No.", ClrTransDocNo);
                        IF TransLine.FINDLAST THEN BEGIN
                            ClrLineNo := TransLine."Line No." + 10000 // YF 22 Feb 2022
                        END ELSE
                            ClrLineNo := 10000; // YF 22 Feb 2022

                        TransLine.Validate("Document No.", ClrTransDocNo);
                        TransLine.VALIDATE("Line No.", ClrLineNo);
                        TransLine.VALIDATE("Item No.", IleRec."Item No.");
                        TransLine.VALIDATE("Transfer-To Bin Code", SSSetup."Def. Clearance Bin");
                        TransLine.Validate("Unit of Measure Code", IleRec."Unit of Measure Code");
                        TransLine.VALIDATE(Quantity, IleRec."Remaining Quantity");

                        // YF 22 Feb 2022
                        if TransLine.INSERT(TRUE) then begin
                            ResEntry.RESET;
                            IF ResEntry.FINDLAST THEN BEGIN
                                EntryNo := ResEntry."Entry No." + 1
                            END ELSE BEGIN
                                EntryNo := 1;
                            END;

                            // FROM
                            ResEntry.RESET;
                            ResEntry.INIT;
                            ResEntry.VALIDATE("Entry No.", EntryNo);
                            ResEntry.VALIDATE("Item No.", IleRec."Item No.");
                            ResEntry.VALIDATE("Location Code", IleRec."Location Code");
                            ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Surplus);
                            ResEntry.VALIDATE("Source Type", 5741);
                            ResEntry.Validate("Source Subtype", 0);
                            ResEntry.VALIDATE("Source ID", ClrTransDocNo);

                            // ResEntry.VALIDATE("Source Batch Name", 'MOVEMENT');
                            ResEntry.Validate(Positive, false);
                            ResEntry.VALIDATE("Source Ref. No.", ClrLineNo);
                            ResEntry.VALIDATE("Lot No.", IleRec."Lot No.");
                            // ResEntry.VALIDATE("Expiration Date", LotBal.Expiration_Date);
                            ResEntry.VALIDATE("Quantity (Base)", -IleRec.Quantity);
                            //ResEntry.VALIDATE("Qty. to Handle",LotBal.Sum_Qty_Base);
                            ResEntry.INSERT(TRUE);

                            EntryNo := EntryNo + 1; // increment for next res. ent. line

                            // TO
                            ResEntry.RESET;
                            ResEntry.INIT;
                            ResEntry.VALIDATE("Entry No.", EntryNo);
                            ResEntry.VALIDATE("Item No.", IleRec."Item No.");
                            // ResEntry.VALIDATE("Location Code", SSSetup."Def. Clearance Bin");//RL20231117 - to hardcode to obsolete location
                            ResEntry.VALIDATE("Location Code", IleRec."Location Code");
                            ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Surplus);
                            ResEntry.VALIDATE("Source Type", 5741);
                            ResEntry.Validate("Source Subtype", 1);
                            ResEntry.VALIDATE("Source ID", ClrTransDocNo);

                            // ResEntry.VALIDATE("Source Batch Name", 'MOVEMENT');
                            ResEntry.Validate(Positive, true);
                            ResEntry.VALIDATE("Source Ref. No.", ClrLineNo);
                            ResEntry.VALIDATE("Lot No.", IleRec."Lot No.");
                            // ResEntry.VALIDATE("Expiration Date", LotBal.Expiration_Date);
                            ResEntry.VALIDATE("Quantity (Base)", IleRec.Quantity);
                            //ResEntry.VALIDATE("Qty. to Handle",LotBal.Sum_Qty_Base);
                            ResEntry.INSERT(TRUE);
                        end;
                        // YF 22 Feb 2022
                    end;

                END;
                ClrTransDocNo := '';

                if IleRec.Next() = 0 then begin
                    CurrReport.Break();
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



    local procedure LessThan2Mth(ItemCode: Code[20]; ExprDate: Date): Boolean //Less than 3mths more than 2 mths
    var
        ExprDate1: Date;
        ExprDate2: Date;
    begin
        Clear(ExprDate1);
        Clear(ExprDate2);
        ExprDate1 := CalcDate('3M', Today);

        IF ExprDate < ExprDate1 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure LessThan3Mth(ItemCode: Code[20]; ExprDate: Date): Boolean //Less than 3mths more than 2 mths
    var
        ExprDate1: Date;
        ExprDate2: Date;
    begin
        Clear(ExprDate1);
        Clear(ExprDate2);
        ExprDate1 := CalcDate('3M', Today);

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
        //THRec.Init;

        //if (TransHeader."Transfer-from Code" = TransHeader."Transfer-to Code") then begin
        thREC.RESET;
        THREC.SETRANGE("Transfer-from Code", IleRec."Location Code");
        THRec.SetRange("Transfer-to Code", 'W44');
        THRec.SetRange("Transfer-To Bin Code", SSSetup."Def. Disposal Bin");
        THREC.SETRANGE("Posting Date", Today);
        IF THRec.FINDFIRST() THEN begin
            exit(THRec."No.");
        end
        else begin
            THREC.InitRecord();
            //THRec.Validate("Transfer-from Code", CompInfo."Location Code");
            THRec.Validate("Transfer-from Code", IleRec."Location Code");
            THRec.Validate("Transfer-to Code", 'W44');
            THRec.Validate("Transfer-To Bin Code", SSSetup."Def. Disposal Bin");
            THRec.Validate("In-Transit Code", 'Transit');
            THRec.Insert(true);
            exit(THRec."No.");
        end;



        // THRec.Modify(true);

        //exit(THRec."No.");
    end;

    var
        GenerateJournals: Boolean;
        LotBal: Query "Lot Numbers by Bin Custom"; //DX     15 Jul 2023     Reference new query
        //LotBal: Query "Lot Numbers by Bin For Rpt"; //DX     15 Jul 2023     Reference new query
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
        ObsTransDocNo: Code[20]; // YF 22 Feb 2022
        ClrTransDocNo: Code[20]; // YF 22 Feb 2022
        ObsLineNo: Integer; // YF 22 Feb 2022
        ClrLineNo: Integer; // YF 22 Feb 2022

        IleRec: Record "Item Ledger Entry";//LK261223
        RepBreak: Boolean;
}
