codeunit 59000 POM2
{
    Permissions = TableData "Sales Invoice Header" = rimd;

    procedure CreateOrder(PurchaseOrderID: Code[50])
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
        LSHRec: Record "Sales Header";
        POMHdr: Record POM2HeaderTbl;
        POMLine: Record POM2DetailsTbl;
        SHexist: Boolean;
    begin

        if PurchOrderHdrIDisValid(PurchaseOrderID) then begin       //Scan through all POM  headers first
            LSHRec.reset;
            LSHRec.SetRange("External Document No.", PurchaseOrderID);
            if LSHRec.FindFirst() then begin
                if GuiAllowed then begin
                    Message('Purchase Order ID already exists, the order will not be created again');
                    SHexist := true;
                end;

                // CreateSOHeader(PurchaseOrderID, SHRec);
            end else begin
                CreateSOHeader(PurchaseOrderID, SHRec);
                SHexist := false;
            end;

            //DX        25 Aug 2021     To cater for line recreation.
            POMLine.reset;
            POMLine.SetRange(POMLine.PurchaseOrderID, PurchaseOrderID);
            POMLine.SetRange(Created, false);
            if POMLine.FindSet() then
                repeat
                    if GetSONo(POMLine.PurchaseOrderID) <> '' then begin        //Check that the header has been created first.                        
                        CreateSOLine(PurchaseOrderID, POMLine."Line No.");
                    end;
                until POMLine.next = 0;
            //DX        25 Aug 2021

            if SHexist = false then
                HandleInvoiceDiscount(PurchaseOrderID, SHRec) // Update Invoice Discount // YF 24 Sep 2021
            else begin
                HandleInvoiceDiscount(PurchaseOrderID, LSHRec);
            end;


        end else begin
            POMHdr.reset;
            POMHdr.SetRange(PurchaseOrderID, PurchaseOrderID);
            if POMHdr.FindFirst() then begin
                POMHdr."Process Remarks" := GetLastErrorText();
                POMHdr.Modify(FALSE);
            end;


        end;
    end;

    // YF 24 Sep 2021
    local procedure HandleInvoiceDiscount(PurchaseOrderID: Code[50]; var SHRec: Record "Sales Header")
    var
        POMHdr: Record POM2HeaderTbl;
        DocumentTotals: Codeunit "Document Totals";
        AmountWithDiscountAllowed: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        Currency: Record Currency;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
    begin
        InvoiceDiscountAmount := 0;
        InvoiceDiscountPct := 0;
        Currency.Initialize(SHRec."Currency Code");

        POMHdr.Reset;
        POMHdr.SetRange(PurchaseOrderID, PurchaseOrderID);
        if POMHdr.FindFirst() then begin
            if POMHdr.OnlineDiscountAmount <> 0 then begin
                InvoiceDiscountAmount := POMHdr.OnlineDiscountAmount;
                DocumentTotals.SalesDocTotalsNotUpToDate();
                SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SHRec);
                DocumentTotals.SalesDocTotalsNotUpToDate();
            end
            else begin
                if POMHdr.OnlineDiscountPercent <> 0 then begin
                    InvoiceDiscountPct := POMHdr.OnlineDiscountPercent;
                    DocumentTotals.SalesDocTotalsNotUpToDate();
                    AmountWithDiscountAllowed := CalcTotalSalesAmountOnlyDiscountAllowedThruHeader(SHRec);
                    InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                    SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SHRec);
                    DocumentTotals.SalesDocTotalsNotUpToDate();
                end;
            end;
        end;
    end;

    local procedure CalcTotalSalesAmountOnlyDiscountAllowedThruHeader(SalesHeader: Record "Sales Header"): Decimal
    var
        TotalSalesLine: Record "Sales Line";
    begin
        TotalSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        TotalSalesLine.SetRange("Document No.", SalesHeader."No.");
        TotalSalesLine.SetRange("Allow Invoice Disc.", true);
        TotalSalesLine.CalcSums("Line Amount");
        exit(TotalSalesLine."Line Amount");
    end;

    // YF 24 Sep 2021

    local procedure CreateSOHeader(PurchaseOrderID: Code[50]; Var SHRec: Record "Sales Header")
    var
        myInt: Integer;
        POMHdr: Record POM2HeaderTbl;
    begin
        POMHdr.reset;
        POMHdr.SetRange(PurchaseOrderID, PurchaseOrderID);
        if POMHdr.FindFirst() then begin
            SHRec.reset;
            SHRec.Init();
            SHRec.Validate("Document Type", SHRec."Document Type"::Order);
            SHRec.Validate("Sell-to Customer No.", POMHdr."Customer Account");
            // SHRec.Validate("Posting Date", POMHdr.TransactionDate);
            SHRec.Validate("Order Date", POMHdr.TransactionDate);
            if POMHdr.OnlineDiscountAmount <> 0 then begin
                SHRec.Validate("Invoice Discount Calculation", SHRec."Invoice Discount Calculation"::Amount);
                SHRec.Validate("Invoice Discount Value", POMHdr.OnlineDiscountAmount);
            end else
                if POMHdr.OnlineDiscountPercent <> 0 then begin
                    SHRec.Validate("Invoice Discount Calculation", SHRec."Invoice Discount Calculation"::"%");
                    SHRec.Validate("Invoice Discount Value", POMHdr.OnlineDiscountPercent);
                end;
            SHRec.Validate("External Document No.", PurchaseOrderID);
            // SHRec.Validate("Your Reference", POMHdr.OrderBy); // YF 29 Nov 2021
            SHRec.Validate("Your Reference", CopyStr(POMHdr.OrderBy, 1, 35)); // YF 29 Nov 2021
            SHRec.Validate("Customer Instructions", POMHdr.Remarks);
            SHRec."SO Placed By" := POMHdr.OrderBy;

            SHRec.Insert(TRUE);

            SHRec.Validate("Order Date", POMHdr.TransactionDate);
            //RL 31 Dec 2021
            if POMHdr."Terms Of Payment" = 'COD' then
                SHRec.Validate("Payment Terms Code", POMHdr."Terms Of Payment");
            //RL 31 Dec 2021
            SHRec.Modify(true);

            NoOfOrders += 1;
            POMHdr.Created := true;
            POMHdr."Process Remarks" := '';
            POMHdr."Doc No." := SHRec."No.";
            POMHdr.Modify(FALSE);
        end;
    end;

    local procedure CreateSOLine(PurchaseOrderID: Code[50]; LineNo: Integer)
    var
        myInt: Integer;
        POMLine: Record POM2DetailsTbl;
        SLRec: Record "Sales Line";
        UnitPrice: Decimal;
        SHRec: Record "Sales Header";
        ItemTrackCU: Codeunit "Item Track CU";
    begin
        SHRec.reset;
        SHRec.SetRange("No.", GetSONo(PurchaseOrderID));
        if SHRec.FindFirst() then begin
            POMLine.reset;
            POMLine.SetRange(PurchaseOrderID, PurchaseOrderID);
            POMLine.SetRange("Line No.", LineNo);
            if POMLine.FindFirst() then
                if PurchOrderLineIDisValid(POMLine.PurchaseOrderID, POMLine."Line No.") then begin      //Create new SO LIne
                    if NOT (SOLineExists(SHRec."No.", POMLine."Product Code", POMLine."Line No.")) then begin       //If SO Line has not been created yet.                                                    
                        SLRec.reset;
                        SLRec.init;
                        SLRec.Validate("Document Type", SHRec."Document Type");
                        SLRec.Validate("Document No.", SHRec."No.");
                        SLRec.Validate("Line No.", POMLine."Line No." * 10000);
                        SLRec.Validate(Type, SLRec.Type::Item);
                        slrec.Validate("No.", POMLine."Product Code");
                        SLRec.Validate("Order Qty", POMLine.QuantityOrdered);
                        SLRec.Validate("FOC Qty", POMLine.BonusQuantity);
                        SLRec.Validate("Selling Price", POMLine.UnitPrice);
                        slrec.Validate("Unit of Measure Code", POMLine.UOMCode);
                        SLRec.Validate("Qty To Deliver", POMLine.QuantityOrdered);
                        SLRec.Validate("FOC (Qty) To Deliver", POMLine.BonusQuantity);
                        if ((POMLine.QuantityOrdered + POMLine.BonusQuantity) <> 0) AND ((POMLine.UnitPrice * POMLine.QuantityOrdered) <> 0) then
                            UnitPrice := (POMLine.UnitPrice * POMLine.QuantityOrdered) / (POMLine.QuantityOrdered + POMLine.BonusQuantity);
                        SLRec.Validate(Quantity, POMLine.QuantityOrdered + POMLine.BonusQuantity);
                        SLRec.Validate("Unit Price", UnitPrice);
                        SLRec.Validate("PO Import Price", POMLine.UnitPrice);
                        SLRec.insert(TRUE);
                        //DX        25 Aug 2021
                        //ClearTrackingLinesSO(SLRec);
                        //AutoPopulateTrackingSO(SLRec);
                        //DX        25 Aug 2021
                        POMLine.Created := true;
                        POMLine."Process Remarks" := '';
                        POMLine."Doc No." := SHRec."No.";
                        POMLine.Modify(FALSE);
                        NoOfLines += 1;
                    end else begin
                        SLRec.reset;
                        SLRec.SetRange("Document Type", SHRec."Document Type");
                        SLRec.SetRange("Document No.", SHRec."No.");
                        SLRec.SetRange("Line No.", POMLine."Line No.");
                        if SLRec.FindFirst() then begin
                            SLRec.Validate(Type, SLRec.Type::Item);
                            slrec.Validate("No.", POMLine."Product Code");
                            SLRec.Validate("Order Qty", POMLine.QuantityOrdered);
                            SLRec.Validate("FOC Qty", POMLine.BonusQuantity);
                            SLRec.Validate("Selling Price", POMLine.UnitPrice);
                            slrec.Validate("Unit of Measure Code", POMLine.UOMCode);
                            SLRec.Validate("Qty To Deliver", POMLine.QuantityOrdered);
                            SLRec.Validate("FOC (Qty) To Deliver", POMLine.BonusQuantity);
                            if ((POMLine.QuantityOrdered + POMLine.BonusQuantity) <> 0) AND ((POMLine.UnitPrice * POMLine.QuantityOrdered) <> 0) then
                                UnitPrice := (POMLine.UnitPrice * POMLine.QuantityOrdered) / (POMLine.QuantityOrdered + POMLine.BonusQuantity);
                            SLRec.Validate(Quantity, POMLine.QuantityOrdered + POMLine.BonusQuantity);
                            SLRec.Validate("Unit Price", UnitPrice);
                            SLRec.Validate("PO Import Price", POMLine.UnitPrice);
                            SLRec.Modify(TRUE);
                            //DX        25 Aug 2021
                            //ClearTrackingLinesSO(SLRec);
                            //AutoPopulateTrackingSO(SLRec);
                            //DX        25 Aug 2021
                            POMLine.Created := true;
                            POMLine."Process Remarks" := '';
                            POMLine."Doc No." := SHRec."No.";
                            POMLine.Modify(FALSE);
                            NoOfLines += 1;
                        end;
                    end;
                end else begin
                    if NOT (SOLineExists(SHRec."No.", POMLine."Product Code", POMLine."Line No.")) then begin
                        SLRec.reset;
                        SLRec.init;
                        SLRec.Validate("Document Type", SHRec."Document Type");
                        SLRec.Validate("Document No.", SHRec."No.");
                        SLRec.Validate("Line No.", LineNo * 10000);
                        SLRec.Validate(Type, SLRec.Type::" ");
                        SLRec.Validate(Description, CopyStr(StrSubstNo('%1 : item error : ', POMLine."Product Name", GetLastErrorText()), 1, 100));
                        SLRec.insert(TRUE);
                        POMLine.Created := false;
                        POMLine."Process Remarks" := GetLastErrorText();
                        POMLine."Doc No." := SHRec."No.";
                        POMLine.Modify(FALSE);
                        NoOfLines += 1;
                    end;
                end;
        end;
    end;

    [TryFunction]
    local procedure PurchOrderHdrIDisValid(PurchOrderID: Code[50])
    var
        myInt: Integer;
        ItemRec: Record item;
        CustRec: Record customer;
        ItemUOM: Record "Item Unit of Measure";
        PomHdr: Record POM2HeaderTbl;
    begin
        PomHdr.reset;
        PomHdr.SetRange(PurchaseOrderID, PurchOrderID);
        if PomHdr.FindFirst() then begin
            CustRec.reset;
            CustRec.SetRange("No.", PomHdr."Customer Account");
            if not (CustRec.FindFirst()) then
                Error('No such customer record.')
        end;
    end;

    [TryFunction]
    local procedure PurchOrderLineIDisValid(PurchOrderID: Code[50]; lineNo: Integer)
    var
        myInt: Integer;
        ItemRec: Record item;
        ItemUOM: Record "Item Unit of Measure";
        PomLine: Record POM2DetailsTbl;
    begin
        PomLine.reset;
        PomLine.SetRange(PurchaseOrderID, PurchOrderID);
        PomLine.SetRange("Line No.", lineNo);
        if PomLine.findset() then
            repeat
                ItemRec.reset;
                ItemRec.SetRange("No.", PomLine."Product Code");
                if not (ItemRec.FindFirst()) then
                    Error('No such item code.');

                ItemUOM.reset;
                ItemUOM.SetRange("Item No.", PomLine."Product Code");
                ItemUOM.SetRange(Code, PomLine.UOMCode);
                if not (ItemUOM.FindFirst()) then
                    Error('No such item UOM code.');
            until PomLine.next = 0;

    end;

    local procedure GetSONo(PurchOrderID: Code[100]): Code[20]
    var
        myInt: Integer;
        PomHdr: Record POM2HeaderTbl;
    begin
        PomHdr.reset;
        PomHdr.SetRange(PurchaseOrderID, PurchOrderID);
        if PomHdr.FindFirst() then begin
            exit(PomHdr."Doc No.")
        end else
            exit('');
    end;

    procedure NoOfOrdersCreated(): Integer
    var
        myInt: Integer;
    begin
        exit(NoOfOrders);
    end;

    procedure NoOfLinesCreated(): Integer
    var
        myInt: Integer;
    begin
        exit(NoOfLines);
    end;


    local procedure SOLineExists(SONo: Code[20]; ItemCode: Code[20]; LineNo: Integer): Boolean
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
    begin
        SLRec.reset;
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetRange("Document No.", SONo);
        SLRec.SetRange("Line No.", LineNo * 10000);
        SLRec.SetRange(Type, SLRec.Type::" ");
        SLRec.SetFilter(Description, '<>%1', '');
        if SLRec.FindFirst() then begin
            exit(TRUE)
        end else
            exit(FALSE);
    end;




    procedure AutoPopulateTrackingSO(SLLineRec: Record "Sales Line")
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
        //SLLineRec: Record "Sales Line";
        ATOLink: Record "Assemble-to-Order Link";
        AHRec: Record "Assembly Header";
        lrec_SH: Record "Sales Header";//#log1
        ldt_PostingDate: Date; //#log1
    begin


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
            ILERec.SETFILTER("Expiration Date", '<>0D');
            ILERec.SETRANGE("Item No.", SLLineRec."No.");
            ILERec.SETFILTER("Lot No.", '<>%1', '');
            ILERec.SETRANGE("Location Code", SLLineRec."Location Code"); //DX    24 July 2019
            ILERec.SETFILTER("Remaining Quantity", '>0');
            IF ILERec.FINDSET THEN
                REPEAT    //Populate all the dimensions
                    xcount += 1;
                    XVar := 0;
                    ResEntryRec.RESET;
                    ResEntryRec.SETFILTER("Item No.", SLLineRec."No.");
                    ResEntryRec.SETFILTER("Lot No.", ILERec."Lot No.");
                    ResEntryRec.SETFILTER("Location Code", SLLineRec."Location Code");
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
                        InsertJnlLineTrackingSO(LotNoDim[i], TempinputLineQty, SLLineRec);
                        BREAK;
                    END ELSE
                        IF LotNoQty[i] - TempinputLineQty < 0 THEN BEGIN
                            InsertJnlLineTrackingSO(LotNoDim[i], LotNoQty[i], SLLineRec);
                            TempinputLineQty := TempinputLineQty - LotNoQty[i];
                        END;
                END;
            END;
        END;
    end;

    procedure InsertJnlLineTrackingSO(LotNo: Code[20]; Qty: Decimal; SORec: Record "Sales Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        SHRec: Record "Sales Header";

    begin
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
        ReservEntry.VALIDATE("Source Subtype", 1);
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
    //insert negative journal for transfer


    procedure ClearTrackingLinesSO(SLRec: Record "Sales Line")
    var
        reserveEntry: Record "Reservation Entry";
    begin

        reserveEntry.RESET;
        reserveEntry.SETRANGE("Item No.", SLRec."No.");
        reserveEntry.SETRANGE("Source ID", SLRec."Document No.");
        reserveEntry.SETRANGE("Source Ref. No.", SLRec."Line No.");
        reserveEntry.SETRANGE("Location Code", SLRec."Location Code");
        reserveEntry.SETRANGE("Reservation Status", reserveEntry."Reservation Status"::Surplus);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not reserveEntry.IsEmpty then
            reserveEntry.DELETEALL(TRUE);
        // YF 10 Aug 2022 // To avoid unnecessary table lock

    end;
    //Delete all existing item tracking lines


    procedure ImportPOMPOHeader()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        CSVBuffer: Record "CSV Buffer" temporary;
        LinesMod: integer;
        IncomingPOHeader: Record POM2HeaderTbl;
    begin

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);
        LinesMod := 0;

        CSVBuffer.DeleteAll();
        CSVBuffer.LoadDataFromStream(ImportStream, ',');

        if CSVBuffer.FindSet() then
            repeat
                if CSVBuffer."Line No." > 1 then begin // ignore header line

                    if Not (DocNoExists(CSVBuffer.GetValueOfLineAt(1))) then begin
                        // CSVBuffer.GetValue(LineNo, FieldNo); // sample
                        IncomingPOHeader.Init;
                        IncomingPOHeader.PurchaseOrderID := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(1));
                        IncomingPOHeader.TransactionDate := GetCSVDateValue(CSVBuffer.GetValueOfLineAt(2), WorkDate());
                        IncomingPOHeader.PhysicalPOID := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(3));
                        IncomingPOHeader."Customer Account" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(4));
                        IncomingPOHeader."Customer Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(5));
                        IncomingPOHeader.LoginID := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(6));
                        IncomingPOHeader.OrderBy := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(7));
                        IncomingPOHeader."Currency" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(8));
                        IncomingPOHeader."Terms of Payment" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(9));
                        IncomingPOHeader.ContactPerson := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(10));
                        IncomingPOHeader.StreetName := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(11));
                        IncomingPOHeader."Country/Region" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(12));
                        IncomingPOHeader."Zip Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(13));
                        IncomingPOHeader.Email := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(14));
                        IncomingPOHeader.Telephone := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(15));
                        IncomingPOHeader.Fax := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(16));
                        IncomingPOHeader.OnlineDiscountAmount := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(17), 0);
                        IncomingPOHeader.OnlineDiscountPercent := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(18), 0);
                        IncomingPOHeader."Remarks" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(19));

                        if not IncomingPOHeader.Insert(true) then IncomingPOHeader.Modify(true);

                        if CSVBuffer."Field No." = 1 then
                            LinesMod += 1;
                    end;
                end;
            until CSVBuffer.Next() = 0;

        if LinesMod <> 0 then
            Message('%1 headers imported.', LinesMod);

    end;

    procedure ImportPOMPOLine()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        CSVBuffer: Record "CSV Buffer" temporary;
        LinesMod: integer;
        IncomingPOLine: Record POM2DetailsTbl;
    begin

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);
        LinesMod := 0;

        CSVBuffer.DeleteAll();
        CSVBuffer.LoadDataFromStream(ImportStream, ',');

        if CSVBuffer.FindSet() then
            repeat
                if CSVBuffer."Line No." > 1 then begin // ignore header line

                    // CSVBuffer.GetValue(LineNo, FieldNo); // sample

                    IncomingPOLine.Init;
                    IncomingPOLine.PurchaseOrderID := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(1));
                    //IncomingPOLine."Line No." := CSVBuffer."Line No." * 10000;
                    //DX        27 Sept 2021 Cater the 10000 when create order
                    IncomingPOLine."Line No." := CSVBuffer."Line No.";
                    IncomingPOLine."Product Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(2));
                    IncomingPOLine."Product Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(3));
                    IncomingPOLine.QuantityOrdered := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(4), 0);
                    IncomingPOLine.BonusQuantity := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(5), 0);
                    IncomingPOLine.UnitPrice := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(6), 0);
                    IncomingPOLine.UOMCode := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(7));
                    IncomingPOLine.ExpiryDate := GetCSVDateValue(CSVBuffer.GetValueOfLineAt(8), 0D);

                    if not IncomingPOLine.Insert() then IncomingPOLine.Modify();

                    if CSVBuffer."Field No." = 1 then
                        LinesMod += 1;

                end;

            until CSVBuffer.Next() = 0;

        if LinesMod <> 0 then
            Message('%1 lines imported.', LinesMod);

    end;

    local procedure DocNoExists(DocNo: Code[20]) doesExist: Boolean
    var
        IncomingPOHeader: Record POM2HeaderTbl;
    begin
        IncomingPOHeader.reset;
        IncomingPOHeader.SetRange(PurchaseOrderID, DocNo);
        if IncomingPOHeader.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(String, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(String, FindPos) + ReplaceWith;
            String := COPYSTR(String, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(String, FindWhat);
        END;
        NewString += String;
    end;

    local procedure GetCSVTextValue(String: Text[250]): Text
    begin
        exit(String.TrimStart('"').TrimEnd('"'));
    end;

    local procedure GetCSVDateValue(String: Text[250]; DefaultValue: Date): Date
    var
        DateText: Text;
        DateValue: Date;
    begin
        DateValue := DefaultValue;
        DateText := GetCSVTextValue(String);
        if DateText = '' then
            DateValue := DefaultValue
        else
            if not Evaluate(DateValue, DateText) then
                DateValue := DefaultValue;
        exit(DateValue);
    end;

    local procedure GetCSVDecimalValue(String: Text[250]; DefaultValue: Decimal): Decimal
    var
        DecimalText: Text;
        DecimalValue: Decimal;
    begin
        DecimalValue := DefaultValue;
        DecimalText := GetCSVTextValue(String);
        if DecimalText = '' then
            DecimalValue := DefaultValue
        else
            if not Evaluate(DecimalValue, DecimalText) then
                DecimalValue := DefaultValue;
        exit(DecimalValue);
    end;

    // YF 21 Sep 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPosting(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    begin
        // Set flag in Posted Sales Invoice Header to state it is the last posted invoice for the set of parent sales order
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order] then begin // YF 22 Sep 2022
            if EverythingInvoiced then begin
                if not SalesInvoiceHeader.IsEmpty then begin
                    SalesInvoiceHeader."Last Posted Invoice in Order" := true;
                    SalesInvoiceHeader.Modify(false);
                end;
            end;
        end; // YF 22 Sep 2022
    end;

    procedure ResetPSILastPostedFlag(var SalesInvoiceHeader: Record "Sales Invoice Header"; ResetFlag: Boolean)
    begin
        if not SalesInvoiceHeader.IsEmpty then begin
            SalesInvoiceHeader."Last Posted Invoice in Order" := ResetFlag;
            SalesInvoiceHeader.Modify(false);
        end;
    end;
    // YF 21 Sep 2022

    // YF 23 Sep 2022
    procedure RetirePOMReference(POMReferenceID: Text[35]; StartDate: Date; EndDate: Date)
    var
        POMSRSetup: Record "Sales & Receivables Setup";
        SalesHdrRec: Record "Sales Header";
        PostedSalesInvHdrRec: Record "Sales Invoice Header";
    begin
        POMSRSetup.Get();

        // if POMSRSetup."Retire POM Prefix" = '' then
        // exit;

        if (POMReferenceID = '') And (StartDate = 0D) And (EndDate = 0D) then
            exit;

        // SalesHdrRec.Reset;
        // if POMReferenceID <> '' then
        //     SalesHdrRec.SetRange("Your Reference", POMReferenceID);
        // if (StartDate <> 0D) And (EndDate <> 0D) then
        //     SalesHdrRec.SetRange("Posting Date", StartDate, EndDate);
        // if SalesHdrRec.FindSet() then
        //     repeat
        //         SalesHdrRec."Your Reference" := POMSRSetup."Retire POM Prefix" + SalesHdrRec."Your Reference";
        //         SalesHdrRec.Modify(false);
        //     until SalesHdrRec.Next() = 0;

        PostedSalesInvHdrRec.Reset;
        PostedSalesInvHdrRec.SetRange("Processed by POM", false);
        if POMReferenceID <> '' then
            PostedSalesInvHdrRec.SetRange("Your Reference", POMReferenceID);
        if (StartDate <> 0D) And (EndDate <> 0D) then
            PostedSalesInvHdrRec.SetRange("Posting Date", StartDate, EndDate);
        if PostedSalesInvHdrRec.FindSet() then
            repeat
                // PostedSalesInvHdrRec."Your Reference" := POMSRSetup."Retire POM Prefix" + PostedSalesInvHdrRec."Your Reference";
                PostedSalesInvHdrRec."Processed by POM" := true;
                PostedSalesInvHdrRec."Order Status" := PostedSalesInvHdrRec."Order Status"::Completed;
                PostedSalesInvHdrRec.Modify(false);
            until PostedSalesInvHdrRec.Next() = 0;
    end;
    // YF 23 Sep 2022

    //RL 12 Oct 2022
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean);
    begin
        if (SalesInvoiceHeader."Refund Amount" <> xSalesInvoiceHeader."Refund Amount") or
              (SalesInvoiceHeader."Refund Date" <> xSalesInvoiceHeader."Refund Date") then
            IsChanged := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnRunOnBeforeAssignValues', '', false, false)]
    local procedure OnRunOnBeforeAssignValues(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header");
    begin
        SalesInvoiceHeader."Refund Date" := SalesInvoiceHeaderRec."Refund Date";
        SalesInvoiceHeader."Refund Amount" := SalesInvoiceHeaderRec."Refund Amount";
        If (SalesInvoiceHeader."Refund Amount" <> 0) or (SalesInvoiceHeader."Refund Date" <> 0D) then
            SalesInvoiceHeader."Last Posted Invoice in Order" := False;

    end;
    //RL 12 Oct 2022

    var
        NoOfOrders: Integer;
        NoOfLines: Integer;
}
