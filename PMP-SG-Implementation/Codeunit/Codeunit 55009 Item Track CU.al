//Documentation - Start

//I9 KM20210421 - #log1 > Get Lot 
//I9 KM20210422 - #log2 > Change Lot Logic > Not to Take 'DAMAGE' and Take 'GOOD' as priority
//I9 KM20210520 - #log3 > (Issue List #16) update lot for TO sames as Sales Doc

//Documentation - End
codeunit 55009 "Item Track CU"
{

    trigger OnRun()
    begin
    end;

    local procedure "-----------------Item Tracking Batch Functions----------------"()
    begin
    end;

    //SO - Start
    // [Scope('Internal')]
    procedure AutoPopulateTrackingSO(SONo: Code[30])
    var
        ItemRec: Record "Item";
        ILERec: Record "Item Ledger Entry";
        InputLineQty: Decimal;
        xcount: Integer;
        LotNoDim: array[500] of Code[20];
        LotNoQty: array[500] of Decimal;
        i: Integer;
        ReservEntryNo: Record "Reservation Entry";
        TempinputLineQty: Decimal;
        XVar: Decimal;
        ESRec: Record "Entry Summary";
        ResEntryRec: Record "Reservation Entry";
        SLLineRec: Record "Sales Line";
        ATOLink: Record "Assemble-to-Order Link";
        AHRec: Record "Assembly Header";
        lrec_SH: Record "Sales Header";//#log1
        ldt_PostingDate: Date; //#log1
        ILERecCheck: Record "Item Ledger Entry"; //KM20211015
        x: Integer; //KM20211015
        LotExisted: Boolean; //KM20211015
    begin

        SLLineRec.RESET;
        SLLineRec.SETRANGE(SLLineRec."Document No.", SONo);
        SLLineRec.SETRANGE(Type, SLLineRec.Type::Item);
        SLLineRec.SETFILTER("No.", '<>%1', '');
        SLLineRec.SETFILTER(Quantity, '<>0');
        //SLLineRec.SetFilter("Qty. to Assemble to Order", '=0');
        SLLineRec.SetRange("Special Order", false);//KM20200113
        IF SLLineRec.FINDSET THEN begin //#log1
            //#log1 - Start
            Clear(ldt_PostingDate);
            lrec_SH.Reset();
            lrec_SH.SetRange("Document Type", SLLineRec."Document Type");
            lrec_SH.SetRange("No.", SLLineRec."Document No.");
            if lrec_SH.FindFirst() then begin
                ldt_PostingDate := lrec_SH."Posting Date";
            end;
            //#log1 - End
            REPEAT
                ItemRec.RESET;
                ItemRec.GET(SLLineRec."No.");
                CLEAR(LotNoDim);
                CLEAR(LotNoQty);
                IF ItemRec."Item Tracking Code" <> '' THEN BEGIN
                    InputLineQty := SLLineRec."Quantity (Base)";
                    xcount := 0;
                    ILERec.RESET;
                    ILERec.SETCURRENTKEY("Item No.", "Expiration Date");
                    ILERec.SETASCENDING("Expiration Date", TRUE);
                    ILERec.SETFILTER("Expiration Date", '>=%1', ldt_PostingDate); //#log1 - Chg from '<>0D' to '>=%1',ldt_PostingDate
                    ILERec.SETRANGE("Item No.", SLLineRec."No.");
                    ILERec.SETFILTER("Lot No.", '<>%1', '');
                    ILERec.SETRANGE("Location Code", SLLineRec."Location Code"); //DX    24 July 2019
                    ILERec.SETFILTER("Remaining Quantity", '>0');
                    IF ILERec.FINDSET THEN
                        REPEAT    //Populate all the dimensions
                            //KM20211015 - Start
                            //Sum all Same Lot - Start
                            ILERecCheck.RESET;
                            ILERecCheck.SETCURRENTKEY("Item No.", "Expiration Date");
                            ILERecCheck.SETASCENDING("Expiration Date", TRUE);
                            ILERecCheck.SetRange("Expiration Date", ILERec."Expiration Date"); //#log1 - Chg from '<>0D' to '>=%1',ldt_PostingDate
                            ILERecCheck.SETRANGE("Item No.", SLLineRec."No.");
                            ILERecCheck.SETFILTER("Lot No.", ILERec."Lot No."); //#log1 - Chg from '<>%1','' to 'GOOD' //#log2 Chg from 'GOOD' to '<>%1','DAMAGE'
                            ILERecCheck.SETRANGE("Location Code", SLLineRec."Location Code"); //DX    24 July 2019
                            ILERecCheck.SETFILTER("Remaining Quantity", '>0');
                            ILERecCheck.CalcSums("Remaining Quantity");
                            //Sum all Sames Lot - End
                            //KM20211015 - End
                            xcount += 1;
                            XVar := 0;
                            ResEntryRec.RESET;
                            ResEntryRec.SETFILTER("Item No.", SLLineRec."No.");
                            ResEntryRec.SETFILTER("Lot No.", ILERec."Lot No.");
                            ResEntryRec.SETFILTER("Location Code", SLLineRec."Location Code");
                            ResEntryRec.SetFilter("Source ID", '<>%1', '');
                            IF ResEntryRec.FINDSET THEN
                                REPEAT
                                    XVar += ResEntryRec."Quantity (Base)";
                                UNTIL ResEntryRec.NEXT = 0;

                            //RL    11 Nov 2021 - Start     Change lot logic
                            /*IF ILERec."Remaining Quantity" + XVar > 0 THEN BEGIN
                                LotNoDim[xcount] := ILERec."Lot No.";
                                LotNoQty[xcount] := ILERec."Remaining Quantity" + XVar;
                            END;*/
                            IF ILERecCheck."Remaining Quantity" + XVar > 0 THEN BEGIN //KM20211015 - chg from ILERec."Remaining Quantity" to ILERecCheck."Remaining Quantity"
                                //KM20211015 - Start
                                LotExisted := false;
                                //Check Lot Existed in LotNoDim ornt >>
                                for x := 1 to xcount do begin
                                    if LotNoDim[x] = ILERec."Lot No." then begin
                                        LotExisted := true;
                                    end;
                                end;
                                //Check Lot Existed in LotNoDim ornt <<
                                if LotExisted = false then begin
                                    LotNoDim[xcount] := ILERec."Lot No.";
                                    LotNoQty[xcount] := ILERecCheck."Remaining Quantity" + XVar;
                                end;
                                //Commented >> 
                                // LotNoDim[xcount] := ILERec."Lot No.";
                                // LotNoQty[xcount] := ILERec."Remaining Quantity" + XVar;
                                //Commented <<
                                //KM20211015 - End
                                // Message('LotNo %1 --- LotQty %2', LotNoDim[xcount], LotNoQty[xcount]);
                            END;

                        //RL       1 Nov 2021 - End Change lot logic
                        UNTIL ILERec.NEXT = 0;
                    TempinputLineQty := InputLineQty;
                    FOR i := 1 TO (xcount) DO BEGIN
                        IF LotNoQty[i] <> 0 THEN BEGIN
                            IF LotNoQty[i] - TempinputLineQty >= 0 THEN BEGIN
                                InsertJnlLineTrackingSO(LotNoDim[i], TempinputLineQty, SLLineRec);
                                TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                BREAK;
                            END ELSE
                                IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                                    InsertJnlLineTrackingSO(LotNoDim[i], LotNoQty[i], SLLineRec);
                                    TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                END;
                        END;
                    END;
                END;
            UNTIL SLLineRec.NEXT = 0;
        end; //#log1

        //Loop through assembly orders in Sales Order doc
        // SLLineRec.RESET;
        // SLLineRec.SETRANGE(SLLineRec."Document No.", SONo);
        // SLLineRec.SETRANGE(Type, SLLineRec.Type::Item);
        // SLLineRec.SETFILTER("No.", '<>%1', '');
        // SLLineRec.SETFILTER(Quantity, '<>0');
        // SLLineRec.SetFilter("Qty. to Assemble to Order", '<>0');
        // IF SLLineRec.FINDSET THEN
        //     REPEAT
        //         ATOLink.RESET;
        //         ATOLink.SETRANGE("Document Type", ATOLink."Document Type"::Order);
        //         ATOLink.SETRANGE(Type, ATOLink.Type::Sale);
        //         ATOLink.SETRANGE("Document No.", SLLineRec."Document No.");
        //         ATOLink.SETRANGE("Document Line No.", SLLineRec."Line No.");
        //         IF ATOLink.FINDFIRST THEN BEGIN
        //             //InsertReservationForAO(WHShipLineRec,ATOLink."Assembly Document No.");
        //             ClearTrackingLinesAO(ATOLink."Assembly Document No.");
        //             AutoPopulateTrackingAO(ATOLink."Assembly Document No.", '');
        //         END;
        //     UNTIL SLLineRec.NEXT = 0;
    end;

    local procedure InsertJnlLineTrackingSO(LotNo: Code[20]; Qty: Decimal; SORec: Record "Sales Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        SHRec: Record "Sales Header";
    begin
        //insert negative journal for transfer
        CLEAR(ReservEntry);
        ReservEntryNo.RESET;
        ReservEntry.INIT;
        IF ReservEntryNo.FINDLAST THEN
            ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
        ELSE
            ReservEntry."Entry No." := 1;

        ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
        ReservEntry.VALIDATE("Item No.", SORec."No.");
        ReservEntry.VALIDATE("Location Code", SORec."Location Code");
        ReservEntry.VALIDATE("Source Type", 37);
        // ReservEntry.VALIDATE("Source Subtype", 1);
        ReservEntry.VALIDATE("Source Subtype", SORec."Document Type".AsInteger());
        ReservEntry.VALIDATE("Source ID", SORec."Document No.");
        ReservEntry.VALIDATE("Source Ref. No.", SORec."Line No.");
        ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
        ReservEntry.VALIDATE("Lot No.", LotNo);
        ReservEntry.VALIDATE("Qty. per Unit of Measure", SORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE(Quantity, -Qty * SORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE("Quantity (Base)", -Qty);
        SHRec.RESET;
        SHRec.SETRANGE("No.", SORec."Document No.");
        IF SHRec.FINDFIRST THEN BEGIN
            ReservEntry.VALIDATE("Shipment Date", SHRec."Posting Date");
        END;
        ReservEntry.VALIDATE("Creation Date", TODAY);
        ReservEntry.VALIDATE("Created By", USERID);
        ReservEntry.VALIDATE("Qty. to Handle (Base)", -Qty);
        ReservEntry.VALIDATE("Qty. to Invoice (Base)", -Qty);
        ReservEntry.INSERT(TRUE);

    end;

    // [Scope('Internal')]
    procedure ClearTrackingLinesSO(SOHeaderNo: Code[50])
    var
        reserveEntry: Record "Reservation Entry";
        ALRec: Record "Assembly Line";
        SLRec: Record "Sales Line";
    begin
        //Delete all existing item tracking lines
        SLRec.RESET;
        SLRec.SETRANGE("Document No.", SOHeaderNo);
        SLRec.SETFILTER("Quantity (Base)", '<>0');
        SLRec.SETRANGE(Type, SLRec.Type::Item);
        SLRec.SETFILTER("No.", '<>%1', '');
        SLRec.SetRange("Special Order", false);//KM20200113
        IF SLRec.FINDSET THEN
            REPEAT
                reserveEntry.RESET;
                reserveEntry.SETRANGE("Item No.", SLRec."No.");
                reserveEntry.SETRANGE("Source ID", SLRec."Document No.");
                reserveEntry.SETRANGE("Source Ref. No.", SLRec."Line No.");
                reserveEntry.SETRANGE("Location Code", SLRec."Location Code");
                // reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Surplus); //KM20210624
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not reserveEntry.IsEmpty then
                    reserveEntry.DELETEALL(TRUE);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            UNTIL SLRec.NEXT = 0;


    end;
    //SO - End


    //TO - Start
    // [Scope('Internal')]
    procedure AutoPopulateTrackingTO(TONo: Code[30])
    var
        ItemRec: Record "Item";
        ILERec: Record "Item Ledger Entry";
        InputLineQty: Decimal;
        xcount: Integer;
        LotNoDim: array[500] of Code[20];
        LotNoQty: array[500] of Decimal;
        i: Integer;
        ReservEntryNo: Record "Reservation Entry";
        TempinputLineQty: Decimal;
        XVar: Decimal;
        ESRec: Record "Entry Summary";
        ResEntryRec: Record "Reservation Entry";
        TLLineRec: Record "Transfer Line";
        ldt_PostingDate: Date; //#log3
        lrec_TH: Record "Transfer Header"; //#log3
    begin

        TLLineRec.RESET;
        TLLineRec.SETRANGE(TLLineRec."Document No.", TONo);
        //TLLineRec.SETRANGE(Type, TLLineRec.Type::Item);
        TLLineRec.SETFILTER("Item No.", '<>%1', '');
        TLLineRec.SETFILTER(Quantity, '<>0');
        //KM20200207 - Start
        TLLineRec.SetRange("Quantity Shipped", 0);
        TLLineRec.SetRange("Derived From Line No.", 0);
        //KM20200207 - End
        IF TLLineRec.FINDSET THEN begin
            //#log3 - Start
            Clear(ldt_PostingDate);
            lrec_TH.Reset();
            lrec_TH.SetRange("No.", TLLineRec."Document No.");
            if lrec_TH.FindFirst() then begin
                ldt_PostingDate := lrec_TH."Posting Date";
            end;
            //#log3 - End

            REPEAT
                ItemRec.RESET;
                ItemRec.GET(TLLineRec."Item No.");
                CLEAR(LotNoDim);
                CLEAR(LotNoQty);
                IF ItemRec."Item Tracking Code" <> '' THEN BEGIN
                    InputLineQty := TLLineRec."Quantity (Base)";
                    xcount := 0;
                    ILERec.RESET;
                    ILERec.SETCURRENTKEY("Item No.", "Expiration Date");
                    ILERec.SETASCENDING("Expiration Date", TRUE);
                    ILERec.SETFILTER("Expiration Date", '>=%1', ldt_PostingDate); //#log3 - Chg from '<>0D' to '>=%1',ldt_PostingDate
                    ILERec.SETRANGE("Item No.", TLLineRec."Item No.");
                    ILERec.SETFILTER("Lot No.", '<>%1', 'DAMAGE'); //#log3 - Chg from '<>%1','' to 'DAMAGE'
                    ILERec.SETRANGE("Location Code", TLLineRec."Transfer-from Code"); //DX    24 July 2019
                    ILERec.SETFILTER("Remaining Quantity", '>0');
                    IF ILERec.FINDSET THEN
                        REPEAT    //Populate all the dimensions
                            xcount += 1;
                            XVar := 0;
                            ResEntryRec.RESET;
                            ResEntryRec.SETFILTER("Item No.", TLLineRec."Item No.");
                            ResEntryRec.SETFILTER("Lot No.", ILERec."Lot No.");
                            ResEntryRec.SETFILTER("Location Code", TLLineRec."Transfer-from Code");
                            IF ResEntryRec.FINDSET THEN
                                REPEAT
                                    XVar += ResEntryRec."Quantity (Base)";
                                UNTIL ResEntryRec.NEXT = 0;
                            IF ILERec."Remaining Quantity" + XVar > 0 THEN BEGIN
                                LotNoDim[xcount] := ILERec."Lot No.";
                                LotNoQty[xcount] := ILERec."Remaining Quantity" + XVar;
                            END;
                        UNTIL ILERec.NEXT = 0;
                    TempinputLineQty := InputLineQty;
                    //#log3 - Start
                    FOR i := 1 TO (xcount) DO BEGIN
                        if LotNoDim[i] = 'GOOD' then begin
                            IF LotNoQty[i] <> 0 THEN BEGIN
                                IF LotNoQty[i] - TempinputLineQty >= 0 THEN BEGIN
                                    InsertJnlLineTrackingTO(LotNoDim[i], TempinputLineQty, TLLineRec);
                                    TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                    BREAK;
                                END ELSE
                                    IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                                        InsertJnlLineTrackingTO(LotNoDim[i], LotNoQty[i], TLLineRec);
                                        TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                    END;
                            END;
                        end;
                    END;

                    if TempinputLineQty > 0 then begin
                        FOR i := 1 TO (xcount) DO BEGIN
                            if LotNoDim[i] <> 'GOOD' then begin
                                // FOR i := 1 TO (xcount) DO BEGIN
                                //#log3 - End
                                IF LotNoQty[i] <> 0 THEN BEGIN
                                    IF LotNoQty[i] - TempinputLineQty >= 0 THEN BEGIN
                                        InsertJnlLineTrackingTO(LotNoDim[i], TempinputLineQty, TLLineRec);
                                        BREAK;
                                    END ELSE
                                        IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                                            InsertJnlLineTrackingTO(LotNoDim[i], LotNoQty[i], TLLineRec);
                                            TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                        END;
                                END;
                            end;//#log3
                        end;//#log3
                    END;
                END;

            UNTIL TLLineRec.NEXT = 0;
        end; //#log3
    end;

    local procedure InsertJnlLineTrackingTO(LotNo: Code[20]; Qty: Decimal; TORec: Record "Transfer Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        THRec: Record "Transfer Header";
    begin
        //insert negative journal for transfer
        CLEAR(ReservEntry);
        ReservEntryNo.RESET;
        ReservEntry.INIT;
        IF ReservEntryNo.FINDLAST THEN
            ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
        ELSE
            ReservEntry."Entry No." := 1;

        ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
        ReservEntry.VALIDATE("Item No.", TORec."Item No.");
        ReservEntry.VALIDATE("Location Code", TORec."Transfer-from Code");
        ReservEntry.VALIDATE("Source Type", 5741);
        ReservEntry.VALIDATE("Source Subtype", 0);
        ReservEntry.VALIDATE("Source ID", TORec."Document No.");
        ReservEntry.VALIDATE("Source Ref. No.", TORec."Line No.");
        ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
        ReservEntry.VALIDATE("Lot No.", LotNo);
        ReservEntry.VALIDATE("Qty. per Unit of Measure", TORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE(Quantity, -Qty * TORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE("Quantity (Base)", -Qty);
        THRec.RESET;
        THRec.SETRANGE("No.", TORec."Document No.");
        IF THRec.FINDFIRST THEN BEGIN
            ReservEntry.VALIDATE("Shipment Date", THRec."Posting Date");
        END;
        ReservEntry.VALIDATE("Creation Date", TODAY);
        ReservEntry.VALIDATE("Created By", USERID);
        ReservEntry.VALIDATE("Qty. to Handle (Base)", -Qty);
        ReservEntry.VALIDATE("Qty. to Invoice (Base)", -Qty);
        ReservEntry.INSERT(TRUE);

        //Transfer to Code - Start
        ReservEntryNo.RESET;
        ReservEntry.INIT;
        IF ReservEntryNo.FINDLAST THEN
            ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
        ELSE
            ReservEntry."Entry No." := 1;

        ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
        ReservEntry.VALIDATE("Item No.", TORec."Item No.");
        ReservEntry.VALIDATE("Location Code", TORec."Transfer-to Code");
        ReservEntry.VALIDATE("Source Type", 5741);
        ReservEntry.VALIDATE("Source Subtype", 1);
        ReservEntry.VALIDATE("Source ID", TORec."Document No.");
        ReservEntry.VALIDATE("Source Ref. No.", TORec."Line No.");
        ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
        ReservEntry.VALIDATE("Lot No.", LotNo);
        ReservEntry.VALIDATE("Qty. per Unit of Measure", TORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE(Quantity, Qty * TORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE("Quantity (Base)", Qty);
        ReservEntry.Validate(Positive, true);
        THRec.RESET;
        THRec.SETRANGE("No.", TORec."Document No.");
        IF THRec.FINDFIRST THEN BEGIN
            ReservEntry.VALIDATE("Expected Receipt Date", THRec."Posting Date" + 1);
        END;
        ReservEntry.VALIDATE("Creation Date", TODAY);
        ReservEntry.VALIDATE("Created By", USERID);
        ReservEntry.VALIDATE("Qty. to Handle (Base)", Qty);
        ReservEntry.VALIDATE("Qty. to Invoice (Base)", Qty);
        ReservEntry.INSERT(TRUE);
        //Transfer to Code - End

    end;

    // [Scope('Internal')]
    procedure ClearTrackingLinesTO(TOHeaderNo: Code[50])
    var
        reserveEntry: Record "Reservation Entry";
        ALRec: Record "Assembly Line";
        TLRec: Record "Transfer Line";
    begin
        //Delete all existing item tracking lines
        TLRec.RESET;
        TLRec.SETRANGE("Document No.", TOHeaderNo);
        TLRec.SETFILTER("Quantity (Base)", '<>0');
        //TLRec.SETRANGE(Type, SLRec.Type::Item);
        TLRec.SETFILTER("Item No.", '<>%1', '');
        //KM20200207 - Start
        TLRec.SetRange("Quantity Shipped", 0);
        TLRec.SetRange("Derived From Line No.", 0);
        //KM20200207 - End
        IF TLRec.FINDSET THEN
            REPEAT
                // Message('in111 %1', TLRec."Quantity Shipped");
                reserveEntry.RESET;
                reserveEntry.SETRANGE("Item No.", TLRec."Item No.");
                reserveEntry.SETRANGE("Source ID", TLRec."Document No.");
                reserveEntry.SETRANGE("Source Ref. No.", TLRec."Line No.");
                reserveEntry.SETRANGE("Location Code", TLRec."Transfer-from Code");
                // reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Surplus); //KM20210624
                //reserveEntry.SetFilter("Source Prod. Order Line", '<>0');//KM20200207
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not reserveEntry.IsEmpty then
                    reserveEntry.DELETEALL(TRUE);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            UNTIL TLRec.NEXT = 0;

        //Delete all existing item tracking lines for Transfer to code
        TLRec.RESET;
        TLRec.SETRANGE("Document No.", TOHeaderNo);
        TLRec.SETFILTER("Quantity (Base)", '<>0');
        //TLRec.SETRANGE(Type, SLRec.Type::Item);
        TLRec.SETFILTER("Item No.", '<>%1', '');
        //KM20200207 - Start
        TLRec.SetRange("Quantity Shipped", 0);
        TLRec.SetRange("Derived From Line No.", 0);
        //KM20200207 - End
        IF TLRec.FINDSET THEN
            REPEAT
                // Message('in222 %1', TLRec."Quantity Shipped");
                reserveEntry.RESET;
                reserveEntry.SETRANGE("Item No.", TLRec."Item No.");
                reserveEntry.SETRANGE("Source ID", TLRec."Document No.");
                reserveEntry.SETRANGE("Source Ref. No.", TLRec."Line No.");
                reserveEntry.SETRANGE("Location Code", TLRec."Transfer-to Code");
                // reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Surplus); //KM20210624
                //reserveEntry.SetFilter("Source Prod. Order Line", '<>0');//KM20200207
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not reserveEntry.IsEmpty then
                    reserveEntry.DELETEALL(TRUE);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            UNTIL TLRec.NEXT = 0;
    end;
    //TO - End

    //AO - Start
    // [Scope('Internal')]
    // procedure AutoPopulateTrackingAO(AONo: Code[30]; SourceType: Text[20]) // YF 11 Feb 2022
    procedure AutoPopulateTrackingAO(AONo: Code[30]) // YF 11 Feb 2022
    var
        ItemRec: Record "Item";
        ILERec: Record "Item Ledger Entry";
        InputLineQty: Decimal;
        xcount: Integer;
        LotNoDim: array[500] of Code[20];
        LotNoQty: array[500] of Decimal;
        i: Integer;
        ReservEntryNo: Record "Reservation Entry";
        TempinputLineQty: Decimal;
        XVar: Decimal;
        ESRec: Record "Entry Summary";
        ResEntryRec: Record "Reservation Entry";
        //WHShipLineRec: Record "7321";
        AOLineRec: Record "Assembly Line";
    begin
        AOLineRec.RESET;
        AOLineRec.SETRANGE(AOLineRec."Document No.", AONo);
        AOLineRec.SETRANGE(Type, AOLineRec.Type::Item);
        AOLineRec.SETFILTER("No.", '<>%1', '');
        AOLineRec.SETFILTER(Quantity, '<>0');
        IF AOLineRec.FINDSET THEN
            REPEAT
                ItemRec.RESET;
                ItemRec.GET(AOLineRec."No.");
                CLEAR(LotNoDim);
                CLEAR(LotNoQty);
                IF ItemRec."Item Tracking Code" <> '' THEN BEGIN
                    InputLineQty := AOLineRec."Quantity (Base)";
                    xcount := 0;
                    ILERec.RESET;
                    ILERec.SETCURRENTKEY("Item No.", "Expiration Date");
                    ILERec.SETASCENDING("Expiration Date", TRUE);
                    ILERec.SETFILTER("Expiration Date", '<>0D');
                    ILERec.SETRANGE("Item No.", AOLineRec."No.");
                    ILERec.SETFILTER("Lot No.", '<>%1', '');
                    ILERec.SETRANGE("Location Code", AOLineRec."Location Code"); //DX    24 July 2019
                    ILERec.SETFILTER("Remaining Quantity", '>0');
                    IF ILERec.FINDSET THEN
                        REPEAT    //Populate all the dimensions
                            xcount += 1;
                            XVar := 0;
                            ResEntryRec.RESET;
                            ResEntryRec.SETFILTER("Item No.", AOLineRec."No.");
                            ResEntryRec.SETFILTER("Lot No.", ILERec."Lot No.");
                            ResEntryRec.SETFILTER("Location Code", AOLineRec."Location Code");
                            IF ResEntryRec.FINDSET THEN
                                REPEAT
                                    XVar += ResEntryRec."Quantity (Base)";
                                UNTIL ResEntryRec.NEXT = 0;
                            IF ILERec."Remaining Quantity" + XVar > 0 THEN BEGIN
                                LotNoDim[xcount] := ILERec."Lot No.";
                                LotNoQty[xcount] := ILERec."Remaining Quantity" + XVar;
                            END;
                        UNTIL ILERec.NEXT = 0;
                    TempinputLineQty := InputLineQty;
                    FOR i := 1 TO (xcount) DO BEGIN
                        IF LotNoQty[i] <> 0 THEN BEGIN
                            IF LotNoQty[i] - TempinputLineQty >= 0 THEN BEGIN
                                InsertJnlLineTrackingAO(LotNoDim[i], TempinputLineQty, AOLineRec);
                                BREAK;
                            END ELSE
                                IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                                    InsertJnlLineTrackingAO(LotNoDim[i], LotNoQty[i], AOLineRec);
                                    TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                END;
                        END;
                    END;
                END;

            UNTIL AOLineRec.NEXT = 0;
    end;

    local procedure InsertJnlLineTrackingAO(LotNo: Code[20]; Qty: Decimal; AORec: Record "Assembly Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        AHRec: Record "Assembly Header";
    begin
        //insert negative journal for transfer
        CLEAR(ReservEntry);
        ReservEntryNo.RESET;
        ReservEntry.INIT;
        IF ReservEntryNo.FINDLAST THEN
            ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
        ELSE
            ReservEntry."Entry No." := 1;

        ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
        ReservEntry.VALIDATE("Item No.", AORec."No.");
        ReservEntry.VALIDATE("Location Code", AORec."Location Code");
        ReservEntry.VALIDATE("Source Type", 901);
        ReservEntry.VALIDATE("Source Subtype", 1);
        ReservEntry.VALIDATE("Source ID", AORec."Document No.");
        ReservEntry.VALIDATE("Source Ref. No.", AORec."Line No.");
        ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
        ReservEntry.VALIDATE("Lot No.", LotNo);
        ReservEntry.VALIDATE("Qty. per Unit of Measure", AORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE(Quantity, -Qty * AORec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE("Quantity (Base)", -Qty);
        AHRec.RESET;
        AHRec.SETRANGE("No.", AORec."Document No.");
        IF AHRec.FINDFIRST THEN BEGIN
            ReservEntry.VALIDATE("Shipment Date", AHRec."Posting Date");
        END;

        ReservEntry.VALIDATE("Creation Date", TODAY);
        ReservEntry.VALIDATE("Created By", USERID);
        ReservEntry.VALIDATE("Qty. to Handle (Base)", -Qty);
        ReservEntry.VALIDATE("Qty. to Invoice (Base)", -Qty);
        ReservEntry.INSERT(TRUE);

    end;

    // [Scope('Internal')]
    procedure ClearTrackingLinesAO(AOHeaderNo: Code[50])
    var
        reserveEntry: Record "Reservation Entry";
        ALRec: Record "Assembly Line";
    begin
        //Delete all existing item tracking lines
        ALRec.RESET;
        ALRec.SETRANGE("Document No.", AOHeaderNo);
        ALRec.SETFILTER("Quantity (Base)", '<>0');
        ALRec.SETRANGE(Type, ALRec.Type::Item);
        ALRec.SETFILTER("No.", '<>%1', '');
        IF ALRec.FINDSET THEN
            REPEAT
                reserveEntry.RESET;
                reserveEntry.SETRANGE("Item No.", ALRec."No.");
                reserveEntry.SETRANGE("Source ID", ALRec."Document No.");
                reserveEntry.SETRANGE("Source Ref. No.", ALRec."Line No.");
                reserveEntry.SETRANGE("Location Code", ALRec."Location Code");
                // reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Surplus); //KM20210624
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not reserveEntry.IsEmpty then
                    reserveEntry.DELETEALL(TRUE);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            UNTIL ALRec.NEXT = 0;


    end;
    //AO - End

    //IJL - Start
    // [Scope('Internal')]
    procedure AutoPopulateTracking(IJLTemplate: Code[10]; IJLBatch: Code[10]/*; SourceType: Integer*/)
    var
        ItemRec: Record "Item";
        ILERec: Record "Item Ledger Entry";
        InputLineQty: Decimal;
        xcount: Integer;
        LotNoDim: array[500] of Code[20];
        LotNoQty: array[500] of Decimal;
        i: Integer;
        ReservEntryNo: Record "Reservation Entry";
        TempinputLineQty: Decimal;
        XVar: Decimal;
        ESRec: Record "Entry Summary";
        ResEntryRec: Record "Reservation Entry";
        //WHShipLineRec: Record "7321";
        //AOLineRec: Record "Assembly Line";
        grec_IJL: Record "Item Journal Line";
    begin
        grec_IJL.RESET;
        grec_IJL.SETRANGE("Journal Template Name", IJLTemplate);
        grec_IJL.SETRANGE("Journal Batch Name", IJLBatch);
        grec_IJL.SETFILTER("Item No.", '<>%1', '');
        grec_IJL.SetFilter("Entry Type", '<>%1', grec_IJL."Entry Type"::Output);
        //grec_IJL.SETFILTER(Quantity, '<>0');
        IF grec_IJL.FINDSET THEN
            REPEAT
                ItemRec.RESET;
                ItemRec.GET(grec_IJL."Item No.");
                CLEAR(LotNoDim);
                CLEAR(LotNoQty);
                IF ItemRec."Item Tracking Code" <> '' THEN BEGIN
                    InputLineQty := grec_IJL."Quantity (Base)";
                    xcount := 0;
                    ILERec.RESET;
                    ILERec.SETCURRENTKEY("Item No.", "Expiration Date");
                    ILERec.SETASCENDING("Expiration Date", TRUE);
                    ILERec.SETFILTER("Expiration Date", '<>0D');
                    ILERec.SETRANGE("Item No.", grec_IJL."Item No.");
                    ILERec.SETFILTER("Lot No.", '<>%1', '');
                    ILERec.SETRANGE("Location Code", grec_IJL."Location Code"); //DX    24 July 2019
                    ILERec.SETFILTER("Remaining Quantity", '>0');
                    ILERec.SetRange("Variant Code", grec_IJL."Variant Code");

                    IF ILERec.FINDSET THEN
                        REPEAT    //Populate all the dimensions
                            xcount += 1;
                            XVar := 0;
                            ResEntryRec.RESET;
                            ResEntryRec.SETFILTER("Item No.", grec_IJL."Item No.");
                            ResEntryRec.SETFILTER("Lot No.", ILERec."Lot No.");
                            ResEntryRec.SETFILTER("Location Code", grec_IJL."Location Code");
                            IF ResEntryRec.FINDSET THEN
                                REPEAT
                                    XVar += ResEntryRec."Quantity (Base)";
                                UNTIL ResEntryRec.NEXT = 0;
                            IF ILERec."Remaining Quantity" + XVar > 0 THEN BEGIN
                                LotNoDim[xcount] := ILERec."Lot No.";
                                LotNoQty[xcount] := ILERec."Remaining Quantity" + XVar;
                            END;
                        UNTIL ILERec.NEXT = 0;
                    TempinputLineQty := InputLineQty;
                    FOR i := 1 TO (xcount) DO BEGIN
                        IF LotNoQty[i] <> 0 THEN BEGIN
                            IF LotNoQty[i] - TempinputLineQty >= 0 THEN BEGIN
                                // InsertJnlLineTracking(LotNoDim[i], TempinputLineQty, grec_IJL, SourceType);
                                InsertJnlLineTracking(LotNoDim[i], TempinputLineQty, grec_IJL);
                                BREAK;
                            END ELSE
                                IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                                    // InsertJnlLineTracking(LotNoDim[i], LotNoQty[i], grec_IJL, SourceType);
                                    InsertJnlLineTracking(LotNoDim[i], LotNoQty[i], grec_IJL);
                                    TempinputLineQty := TempinputLineQty - LotNoQty[i];
                                END;
                        END;
                    END;
                END;

            UNTIL grec_IJL.NEXT = 0;
    end;

    local procedure InsertJnlLineTracking(LotNo: Code[20]; Qty: Decimal; IJLRec: Record "Item Journal Line"/*; SourceType: Integer*/)
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
    //AHRec: Record "Assembly Header";
    begin
        //insert negative journal for transfer
        CLEAR(ReservEntry);
        ReservEntryNo.RESET;
        ReservEntry.INIT;
        IF ReservEntryNo.FINDLAST THEN
            ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
        ELSE
            ReservEntry."Entry No." := 1;

        ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Prospect);
        ReservEntry.VALIDATE("Item No.", IJLRec."Item No.");
        ReservEntry.VALIDATE("Location Code", IJLRec."Location Code");
        ReservEntry.VALIDATE("Source Type", 83);
        // ReservEntry.VALIDATE("Source Subtype", SourceType);
        ReservEntry.VALIDATE("Source Subtype", IJLRec."Entry Type");//KM20210405
        ReservEntry.VALIDATE("Source ID", IJLRec."Journal Template Name");
        ReservEntry.VALIDATE("Source Batch Name", IJLRec."Journal Batch Name");
        ReservEntry.VALIDATE("Source Ref. No.", IJLRec."Line No.");
        ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
        ReservEntry.VALIDATE("Lot No.", LotNo);
        ReservEntry.VALIDATE("Qty. per Unit of Measure", IJLRec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE(Quantity, -Qty * IJLRec."Qty. per Unit of Measure");
        ReservEntry.VALIDATE("Quantity (Base)", -Qty);
        // AHRec.RESET;
        // AHRec.SETRANGE("No.", AORec."Document No.");
        // IF AHRec.FINDFIRST THEN BEGIN
        ReservEntry.VALIDATE("Shipment Date", IJLRec."Posting Date");
        // END;

        ReservEntry.VALIDATE("Creation Date", TODAY);
        ReservEntry.VALIDATE("Created By", USERID);
        ReservEntry.VALIDATE("Qty. to Handle (Base)", -Qty);
        ReservEntry.VALIDATE("Qty. to Invoice (Base)", -Qty);
        ReservEntry.INSERT(TRUE);

    end;

    // [Scope('Internal')]
    procedure ClearTrackingLines(IJLTemplate: Code[10]; IJLBatch: Code[10])
    var
        reserveEntry: Record "Reservation Entry";
        Itemrec: Record "Item Journal Line";
    begin
        //Delete all existing item tracking lines
        Itemrec.Reset();
        Itemrec.SetRange("Journal Template Name", IJLTemplate);
        Itemrec.SetRange("Journal Batch Name", IJLBatch);
        Itemrec.SetFilter("Entry Type", '<>%1', Itemrec."Entry Type"::Output);
        if Itemrec.FindSet() then
            repeat
                reserveEntry.RESET;
                reserveEntry.SETRANGE("Item No.", Itemrec."Item No.");
                reserveEntry.SETRANGE("Source ID", Itemrec."Journal Template Name");
                reserveEntry.SETRANGE("Source Ref. No.", Itemrec."Line No.");
                reserveEntry.SETRANGE("Source Batch Name", Itemrec."Journal Batch Name");
                // reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Prospect); //KM20210624
                reserveEntry.SETRANGE("Location Code", Itemrec."Location Code");
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not reserveEntry.IsEmpty then
                    reserveEntry.DELETEALL(TRUE);
            // YF 10 Aug 2022 // To avoid unnecessary table lock
            until Itemrec.Next() = 0;
    end;
    //IJL - End

    //Assign Lot for PO - Start
    procedure AutoAssignPO(PONo: Code[20]; LotNo: Code[50]; ExpirationDate: Date) //KM20210408 - Add New Parameter > LotNo , ExpiryDate
    var
        PHRec: Record "Purchase Header";
        PLRec: Record "Purchase Line";
        ResEntry: Record "Reservation Entry";
        ItemRec: Record "Item";
        EntryNo: Integer;
        IntEntryNo: Record "Reservation Entry";

    begin
        ResEntry.RESET;
        ResEntry.SETRANGE("Source Subtype", 1);
        ResEntry.SETRANGE("Source Type", 39);
        ResEntry.SETRANGE("Source ID", PONo);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not ResEntry.IsEmpty then
            ResEntry.DELETEALL(TRUE);
        // YF 10 Aug 2022 // To avoid unnecessary table lock

        PLRec.RESET;
        PLRec.SETRANGE("Document Type", PHRec."Document Type"::Order);
        PLRec.SETRANGE("Document No.", PONo);
        PLRec.SETRANGE(Type, PLRec.Type::Item);
        PLRec.SETFILTER("No.", '<>%1', '');
        PLRec.SETFILTER(Quantity, '<>0');
        IF PLRec.FINDSET THEN
            REPEAT
                ItemRec.RESET;
                ItemRec.SETRANGE("No.", PLRec."No.");
                IF ItemRec.FINDFIRST THEN BEGIN
                    IF ItemRec."Item Tracking Code" <> '' THEN BEGIN

                        IntEntryNo.RESET;
                        IF IntEntryNo.COUNT = 0 THEN
                            EntryNo := 1
                        ELSE BEGIN
                            IF IntEntryNo.FINDLAST THEN
                                EntryNo := IntEntryNo."Entry No." + 1;
                        END;

                        ResEntry.RESET;
                        ResEntry.INIT;
                        ResEntry.VALIDATE("Entry No.", EntryNo);
                        ResEntry.VALIDATE("Item No.", PLRec."No.");
                        ResEntry.VALIDATE("Location Code", PLRec."Location Code");
                        ResEntry.VALIDATE("Quantity (Base)", PLRec."Quantity (Base)");
                        ResEntry.VALIDATE("Reservation Status", ResEntry."Reservation Status"::Surplus);
                        ResEntry.VALIDATE("Creation Date", TODAY);
                        ResEntry.VALIDATE("Source Type", 39);
                        ResEntry.VALIDATE("Source Subtype", 1);
                        ResEntry.VALIDATE("Source ID", PLRec."Document No.");
                        ResEntry.VALIDATE("Source Ref. No.", PLRec."Line No.");
                        ResEntry.VALIDATE("Expected Receipt Date", PLRec."Expected Receipt Date");
                        ResEntry.VALIDATE("Created By", USERID);
                        ResEntry.VALIDATE(Positive, TRUE);
                        ResEntry.VALIDATE("Qty. per Unit of Measure", PLRec."Qty. per Unit of Measure");
                        ResEntry.VALIDATE(Quantity, PLRec.Quantity);
                        //KM20210408 - Start
                        if ExpirationDate <> 0D then
                            ResEntry.VALIDATE("Expiration Date", ExpirationDate)
                        else
                            ResEntry.VALIDATE("Expiration Date", CALCDATE('<1Y>', TODAY));
                        if LotNo <> '' then
                            ResEntry.VALIDATE("Lot No.", LotNo)
                        else
                            ResEntry.VALIDATE("Lot No.", FORMAT(TODAY, 10, '<DAY,2><MONTH,2><Year,4>'));
                        //KM20210408 - End
                        ResEntry.VALIDATE("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                        ResEntry.INSERT(TRUE);


                    END;
                END;
            UNTIL PLRec.NEXT = 0;
    end;
    //Assign Lot for PO - End
}

