codeunit 55008 "PMP-Enhancements"
{
    //DX        27 June 2021
    // This codeunit will containt all the autoamted / enhancement tweaks requested by PMP during training and testing.
    // It will contain all the functions that are not related to warehouse / other modules.
    Permissions = TableData "Item Ledger Entry" = rimd,
        TableData "Sales Invoice Header" = rimd,
        TableData "Sales Invoice Line" = rimd,
        TableData "Sales Cr.Memo Header" = rimd,
        TableData "Gen. Journal Line" = rimd,
        Tabledata "Whse. Item Tracking Line" = rimd;

    trigger OnRun()
    begin

    end;

    procedure GetItemEarliestExpiration(ItemNo: Code[20]; LocCode: Code[20]): Date
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";
        FoundDate: Date;
        Earliest: Date;
    begin
        ItemRec.reset;
        ItemRec.SetLoadFields("No.", "Item Tracking Code");  //DX        06 May 2023
        ItemRec.SetRange("No.", ItemNo);
        ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
        if ItemRec.FindFirst() then begin
            myInt := 1;
            FoundDate := 0D;
            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Location Code", "Expiration Date", "Lot No.", "Remaining Quantity", "Variant Code"); //DX        06 May 2023
            ILERec.SetCurrentKey("Item No.", "Location Code", "Expiration Date");
            ILERec.SetAscending("Expiration Date", true);
            ILERec.SetRange("Location Code", locCode);
            ILERec.SetRange("Item No.", ItemNo);
            ILERec.SetFilter("Lot No.", '<>%1', '');
            ILERec.SetFilter("Expiration Date", '<>%1', 0D);
            ILERec.SetFilter("Remaining Quantity", '>0');
            ILERec.SetFilter("Variant Code", '%1', '');  //RL 10 May 2022 - add another filter to exclude variant code from calculation.
            if ILERec.FindFirst() then
                exit(ILERec."Expiration Date");
        end;
    end;

    procedure ExpirationLessThan12Mths(ItemNo: Code[20]): Boolean
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";
    begin
        ItemRec.reset;
        ItemRec.SetCurrentKey("No.", "Item Tracking Code");
        ItemRec.SetLoadFields("No.", "Item Tracking Code");
        ItemRec.SetRange("No.", ItemNo);
        ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
        if ItemRec.FindFirst() then begin
            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Expiration Date", "Remaining Quantity");        //DX        24 May 2023
            ILERec.SetCurrentKey("Item No.", "Expiration Date");
            ILERec.SetAscending("Expiration Date", true);
            //ILERec.SetRange("Location Code", locCode);
            ILERec.SetRange("Item No.", ItemNo);
            ILERec.SetFilter("Remaining Quantity", '<>0');
            if ILERec.FindFirst() then begin
                if (ILERec."Expiration Date" - WorkDate()) < 365 then
                    Message('Earliest expiration date for %1 is less than a year', ILERec."Item No.");
            end;
        end;
    end;

    procedure ExpirationLessThan12MthsWithLoc(ItemNo: Code[20]; LocCode: Code[20]): Boolean
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";
    begin
        ItemRec.reset;
        ItemRec.SetCurrentKey("No.", "Item Tracking Code");
        ItemRec.SetLoadFields("No.", "Item Tracking Code");
        ItemRec.SetRange("No.", ItemNo);
        ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
        if ItemRec.FindFirst() then begin
            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Location Code", "Expiration Date", "Remaining Quantity");        //DX        24 May 2023
            ILERec.SetCurrentKey("Item No.", "Location Code", "Expiration Date");
            ILERec.SetAscending("Expiration Date", true);
            ILERec.SetRange("Location Code", locCode);
            ILERec.SetRange("Item No.", ItemNo);
            ILERec.SetFilter("Remaining Quantity", '<>0');
            if ILERec.FindFirst() then begin
                if ILERec."Expiration Date" <> 0D then
                    if (ILERec."Expiration Date" - WorkDate()) < 365 then
                        Message('Earliest expiration date for %1 is less than a year', ILERec."Item No.");
            end;
        end;
    end;

    procedure ExpirationLessThan12MthsWithLocForChain(ItemNo: Code[20]; LocCode: Code[20]): Boolean
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";
    begin
        ItemRec.reset;
        ItemRec.SetCurrentKey("No.", "Item Tracking Code");
        ItemRec.SetLoadFields("No.", "Item Tracking Code");
        ItemRec.SetRange("No.", ItemNo);
        ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
        if ItemRec.FindFirst() then begin
            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Location Code", "Expiration Date", "Remaining Quantity");        //DX        24 May 2023
            ILERec.SetCurrentKey("Item No.", "Location Code", "Expiration Date");
            ILERec.SetAscending("Expiration Date", true);
            ILERec.SetRange("Location Code", locCode);
            ILERec.SetRange("Item No.", ItemNo);
            ILERec.SetFilter("Remaining Quantity", '<>0');
            if ILERec.FindFirst() then begin
                if ILERec."Expiration Date" <> 0D then
                    if (ILERec."Expiration Date" - WorkDate()) < 365 then
                        Exit(true)
            end;
        end;
        exit(False);
    end;

    //DX        01 July 2021
    procedure CustItemIsBlocked(CustCode: code[20]; ItemCode: Code[20])
    var
        myInt: Integer;
        BlockCustItem: Record "Blocked Cust-Item";
    begin
        BlockCustItem.reset;
        BlockCustItem.SetRange("Cust No.", CustCode);
        BlockCustItem.SetRange("Item Code", ItemCode);
        If BlockCustItem.FindFirst() then begin
            if GuiAllowed then
                Error('Customer and item sale has been blocked, please check with admin.');
        end;
    end;

    procedure GetLastItemPurchaseQuantity(ItemNo: Code[20]): Decimal;
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        PRRec: Record "Purch. Rcpt. Line";
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "posting Date", "Document Type", "Document No.", "Document Line No.");        //DX        24 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date", "Document Type");
        ILERec.SetRange("Item No.", ItemNo);
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Purchase Receipt");
        if ILERec.FindFirst() then begin
            //DX        17 Aug 2021
            PRRec.reset;
            PRRec.SetLoadFields("Document No.", "Line No.", "Order Qty"); //DX        08 June 2023
            PRRec.SetRange("Document No.", ILERec."Document No.");
            PRRec.SetRange("Line No.", ILERec."Document Line No.");
            if PRRec.FindFirst() then
                exit(PRRec."Order Qty");
            //DX        17 Aug 2021
        end;

    end;

    procedure GetLastItemPurchaseFOCQuantity(ItemNo: Code[20]): Decimal;
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        PRRec: Record "Purch. Rcpt. Line";
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "posting Date", "Document Type", "Document No.", "Document Line No.");        //DX        24 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date", "Document Type");
        ILERec.SetRange("Item No.", ItemNo);
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Purchase Receipt");
        if ILERec.FindFirst() then begin
            //DX        17 Aug 2021
            PRRec.reset;
            PRRec.SetLoadFields("Document No.", "Line No.", "FOC Qty"); //DX        08 June 2023
            PRRec.SetRange("Document No.", ILERec."Document No.");
            PRRec.SetRange("Line No.", ILERec."Document Line No.");
            if PRRec.FindFirst() then
                exit(PRRec."FOC Qty");
            //DX        17 Aug 2021
        end;

    end;

    //DX        08 Aug 2021
    procedure GetLastPurchasePriceBeforeFOC(ItemNo: Code[20]): Decimal
    var
        ILERec: Record "Item Ledger Entry";
        PRLRec: Record "Purch. Rcpt. Line";
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "posting Date", "Document Type", "Document No.", "Document Line No.");        //DX        24 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date");
        ILERec.SetRange("Item No.", ItemNo);
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Purchase Receipt");
        if ILERec.FindFirst() then begin
            PRLRec.reset;
            PRLRec.SetLoadFields("Document No.", "Line No.", "Purchase Price"); //DX        08 June 2023
            PRLRec.SetRange("Document No.", ILERec."Document No.");
            PRLRec.SetRange("Line No.", ILERec."Document Line No.");
            if PRLRec.FindFirst() then begin
                exit(PRLRec."Purchase Price");
            end;
        end;
    end;

    //DX        08 Aug 2021
    procedure GetLastPurchaseDate(ItemNo: Code[20]): Date;
    var
        ILERec: Record "Item Ledger Entry";
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "posting Date", "Document Type");        //DX        24 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date", "Document Type");
        ILERec.SetRange("Item No.", ItemNo);
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Purchase Receipt");
        if ILERec.FindFirst() then
            exit(ILERec."Posting Date");
    end;
    //DX        01 July 2021

    // YF        12 Nov 2021
    procedure GetLastPurchasePrice(ItemNo: Code[20]): Decimal;
    var
        ILERec: Record "Item Ledger Entry";
        PILRec: Record "Purch. Rcpt. Line";
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "posting Date", "Document Type", "Document No.", "Document Line No.");        //DX        24 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date");
        ILERec.SetRange("Item No.", ItemNo);
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Purchase Receipt");
        if ILERec.FindFirst() then begin
            PILRec.Reset;
            PILRec.SetLoadFields("Document No.", "Line No.", "Purchase Price");       //DX        24 May 2023
            PILRec.SetRange("Document No.", ILERec."Document No.");
            PILRec.SetRange("Line No.", ILERec."Document Line No.");
            if PILRec.FindFirst() then begin
                exit(PILRec."Purchase Price");
            end;
        end;

        exit(0);
    end;
    // YF        12 Nov 2021


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnMaintainPlanningLineOnAfterReqLineInsert', '', false, false)]
    local procedure OnMaintainPlanningLineOnAfterReqLineInsert(var RequisitionLine: Record "Requisition Line")
    // Custom Price List Implementation
    // YF 21 Dec 2021 // Update also on local procedure MaintainPlanningLineOnAfterReqLineInsert(var RequisitionLine: Record "Requisition Line")
    var
        PriceListLineRec: Record "Pharma Purchase Price";
        LowestMinQty: Decimal;
        LowestUnitCostPrice: Decimal;
        LowestFOCQty: Decimal;
        LowestUnitCostPerQty: Decimal;
        CurrentUnitCostPerQty: Decimal;
        RevisedFOCQty: Decimal;
        PurchasePrice: Decimal;
        TradeAgreementCU: Codeunit "Trade Agreement CU";
        LineDiscountPercent: Decimal;
    begin
        // Find Lowest Price
        LowestMinQty := 0;
        LowestUnitCostPrice := 0;
        LowestFOCQty := 0;
        LowestUnitCostPerQty := 0;
        CurrentUnitCostPerQty := 0;

        PriceListLineRec.Reset;
        PriceListLineRec.SetRange("Vendor No.", RequisitionLine."Vendor No.");
        PriceListLineRec.SetRange("Item No.", RequisitionLine."No.");
        PriceListLineRec.SetRange("Unit of Measure Code", RequisitionLine."Unit of Measure Code");
        PriceListLineRec.SetRange(Status, PriceListLineRec.Status::Active);

        PriceListLineRec.SetFilter("Starting Date", '<=%1', WorkDate());
        PriceListLineRec.SetFilter("Ending Date", '>=%1', WorkDate());

        // PriceListLineRec.SetFilter("Starting Date", '<=%1', RequisitionLine."Order Date");
        // PriceListLineRec.SetFilter("Ending Date", '>=%1', RequisitionLine."Order Date");       

        if PriceListLineRec.FindSet() then
            repeat
                if PriceListLineRec."Direct Unit Cost" > 0 then begin
                    // CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty") / PriceListLineRec."Direct Unit Cost";

                    // YF 15 Oct 2021 // Extra Checks for Division by Zero
                    if (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty") = 0 then
                        CurrentUnitCostPerQty := 0 // Error('Sum of Min Qty and FOC Qty cannot be zero');
                    else
                        CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty");

                    // CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty");
                    // YF 15 Oct 2021 // Extra Checks for Division by Zero

                    if CurrentUnitCostPerQty < LowestUnitCostPerQty then begin
                        LowestUnitCostPerQty := CurrentUnitCostPerQty;
                        LowestMinQty := PriceListLineRec."Minimum Quantity";
                        LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                        LowestFOCQty := PriceListLineRec."FOC Qty";
                    end;

                    if CurrentUnitCostPerQty = LowestUnitCostPerQty then begin
                        if PriceListLineRec."Minimum Quantity" > LowestMinQty then begin
                            LowestUnitCostPerQty := CurrentUnitCostPerQty;
                            LowestMinQty := PriceListLineRec."Minimum Quantity";
                            LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                            LowestFOCQty := PriceListLineRec."FOC Qty";
                        end;
                    end;

                    if LowestUnitCostPerQty = 0 then begin
                        LowestUnitCostPerQty := CurrentUnitCostPerQty;
                        LowestMinQty := PriceListLineRec."Minimum Quantity";
                        LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                        LowestFOCQty := PriceListLineRec."FOC Qty";
                    end;

                end;
            until PriceListLineRec.Next() = 0;

        // Get and Set Default values
        CalculatePurchPriceFOCQty_PMPCustomized(RequisitionLine."Vendor No.", WorkDate(), RequisitionLine."No.", RequisitionLine."Unit of Measure Code", RequisitionLine.Quantity, PurchasePrice, RevisedFOCQty, LineDiscountPercent);

        RequisitionLine."Min Qty" := LowestMinQty;
        RequisitionLine."Unit Cost Price" := LowestUnitCostPrice;
        RequisitionLine."FOC Qty" := LowestFOCQty;
        RequisitionLine."Direct Unit Cost" := PurchasePrice;
        RequisitionLine."Revised FOC Qty" := RevisedFOCQty;
        // RequisitionLine."Line Discount %" := LineDiscountPercent;
        RequisitionLine."Line Discount Percent" := LineDiscountPercent;
        RequisitionLine.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInsertPurchOrderHeader', '', false, false)]
    local procedure OnAfterInsertPurchOrderHeader(var RequisitionLine: Record "Requisition Line"; var PurchaseOrderHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean)
    begin
        // update status // address issue #20 // YF 28 Jul 2021
        PurchaseOrderHeader."Created From Req. Wksht." := true;
        PurchaseOrderHeader.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInsertPurchOrderLine', '', false, false)]
    local procedure OnAfterInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; var NextLineNo: Integer; var RequisitionLine: Record "Requisition Line"; var PurchOrderHeader: Record "Purchase Header")
    // Custom Price List Implementaiton
    var
        TradeCU: Codeunit "Trade Agreement CU";
        // PriceListLineRec: Record "Pharma Purchase Price";
        OrgLineAmt: Decimal;
        InclFOCUnitPrice: Decimal;
        PurchasePrice: Decimal;
        RevisedFOCQty: Decimal;
        ItemRec: Record Item;
        ItemUOM: Record "Item Unit of Measure";
    begin
        // YF 17 Feb 2022
        if not RequisitionLine."Ad Hoc Entry" then begin
            // YF 19 Aug 2021 // Hacky workaround for issue #128        
            CalculatePurchPriceFOCQty_PMPCustomized(RequisitionLine."Vendor No.", WorkDate(), RequisitionLine."No.", RequisitionLine."Unit of Measure Code", RequisitionLine.Quantity, PurchasePrice, RevisedFOCQty);
        end
        else begin
            PurchasePrice := RequisitionLine."Direct Unit Cost";
            RevisedFOCQty := RequisitionLine."Revised FOC Qty";
        end;
        // YF 17 Feb 2022

        if PurchOrderLine.Type = PurchOrderLine.Type::Item then begin

            // YF 06 Oct 2021 // Update Principal Field
            ItemRec.Reset;
            ItemRec.SetRange("No.", PurchOrderLine."No.");
            if ItemRec.FindFirst() then
                PurchOrderLine.Principal := ItemRec.Principal;
            // YF 06 Oct 2021 // Update Principal Field

            // YF 11 Oct 2021 // Item Unit of Measure Alternate Descr Customization
            ItemUOM.Reset;
            ItemUOM.SetRange("Item No.", PurchOrderLine."No.");
            ItemUOM.SetRange(Code, PurchOrderLine."Unit of Measure Code");
            if ItemUOM.FindFirst() then begin
                if StrLen(ItemUOM."Alternate Description") > 0 then
                    PurchOrderLine.Description := ItemUOM."Alternate Description";
            end;
            // YF 11 Oct 2021 // Item Unit of Measure Alternate Descr Customization

            if RequisitionLine.Quantity <> 0 then begin
                //DX        27 Aug 2021     Need to set tiered price to actual purchase price
                //PurchOrderLine.Validate("Purchase Price", RequisitionLine."Unit Cost Price");
                PurchOrderLine.Validate("Purchase Price", PurchasePrice);
                //DX        27 Aug 2021
                PurchOrderLine.Validate("Order Qty", PurchOrderLine.Quantity);
                PurchOrderLine.Validate(Quantity, PurchOrderLine.Quantity + RequisitionLine."Revised FOC Qty");
                PurchOrderLine.Validate("FOC Qty", RequisitionLine."Revised FOC Qty");
                //DX        27 Aug 2021
                InclFOCUnitPrice := (PurchasePrice * PurchOrderLine."Order Qty") / PurchOrderLine.Quantity;
                //PurchOrderLine.Validate("Direct Unit Cost", RequisitionLine."Direct Unit Cost");
                PurchOrderLine.Validate("Direct Unit Cost", InclFOCUnitPrice);
                //DX        27 Aug 2021
                // PurchOrderLine.Validate("Line Discount %", PriceListLineRec."Line Discount %"); // YF 21 Oct 2010
                PurchOrderLine.Validate("Line Discount %", RequisitionLine."Line Discount Percent"); // YF 27 Oct 2010
                // PurchOrderLine.Modify(true);
            end
            else begin
                PurchOrderLine.Validate(Quantity, PurchOrderLine."Order Qty");
                PurchOrderLine.Validate("FOC Qty", 0);
                PurchOrderLine.Validate("Purchase Price", 0);
                PurchOrderLine.Validate("Direct Unit Cost", 0);
                PurchOrderLine.Validate("Line Discount %", 0); // YF 21 Oct 2010
                // PurchOrderLine.Modify(true);
            end;

            PurchOrderLine.Modify(true);
        end;
        // YF 19 Aug 2021 // Hacky workaround for issue #128
        // YF 02 Mar 2025
        if RequisitionLine."Approval Required" then
            if not PurchOrderHeader."Approval Required" then begin
                PurchOrderHeader."Approval Required" := RequisitionLine."Approval Required";
                PurchOrderHeader.Modify(false);
            end;
        // YF 02 Mar 2025
    end;

    //DX    09 July 2021        To address issue 29.
    procedure ScanInvoice(DocNO: Code[20])
    var
        myInt: Integer;
        SIHRec: Record "Sales Invoice Header";
        WarehouseCU: codeunit "Warehouse CU";
    begin
        if DocNO <> '' then begin
            SIHRec.reset;
            //RL    31 Jan 2022 - Change scanning due to barcode change

            // SIHRec.SetRange("No.", 'SI-' + DocNO);
            SIHRec.SetRange("No.", DocNO);

            //RL    31 Jan 2022
            if SIHRec.FindFirst() then begin
                WarehouseCU.UpdateOrderStatus(SIHRec."No.", 'Completed');
            end else begin
                SIHRec.SetRange("No.", 'SI-' + DocNO);
                if SIHRec.FindFirst() then begin
                    WarehouseCU.UpdateOrderStatus(SIHRec."No.", 'Completed');

                end else begin
                    Message('No such invoice number.');
                end;
            end;
        end;
    end;
    //DX    09 July 2021

    //DX        14 July 2021
    //DX        17 Aug 2021     Obselete
    /*
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure ItemTrackingLinesOnRegisterChangeOnAfterCreateReservEntry(var ReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry.Exchangeable := OldTrackingSpecification."Exchangeable";
        ReservEntry.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure ItemTrackingLinesOnAfterCopyTrackingSpec(var DestTrkgSpec: Record "Tracking Specification"; var SourceTrackingSpec: Record "Tracking Specification")
    begin
        DestTrkgSpec."Exchangeable" := SourceTrackingSpec."Exchangeable";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure ItemTrackingLinesOnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[2] := IdenticalArray[2] and (ReservEntry1."Exchangeable" = ReservEntry2."Exchangeable");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure ItemTrackingLinesOnAfterMoveFields(var ReservEntry: Record "Reservation Entry"; var TrkgSpec: Record "Tracking Specification")
    begin
        ReservEntry."Exchangeable" := TrkgSpec."Exchangeable";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure ItemJnlPostLineOnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification"; var TempItemJournalLine: Record "Item Journal Line")
    begin
        TempItemJournalLine."Exchangeable" := TempTrackingSpecification."Exchangeable"
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure ItemJnlPostLineOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."Exchangeable" := ItemJournalLine."Exchangeable";
    end;

    local procedure TrackingSpecificationLotNoOnAfterValidateEvent(var Rec: Record "Tracking Specification")
    begin
        rec."Exchangeable" := GetExchangeable(Rec);
    end;

    local procedure GetExchangeable(TrackingSpecication: Record "Tracking Specification"): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", "Lot No.", "Posting Date", "Entry No.");
        ItemLedgerEntry.SetRange("Item No.", TrackingSpecication."Item No.");
        ItemLedgerEntry.SetRange("Lot No.", TrackingSpecication."Lot No.");
        if ItemLedgerEntry.FindFirst() then
            exit(ItemLedgerEntry."Exchangeable");
    end;

    procedure IsExchangeable(TrackSpec: Record "Tracking Specification"): Boolean
    var
        myInt: Integer;
        VendRec: Record vendor;
        VendCode: Code[20];
        ItemRec: Record Item;
        ItemCode: Code[20];
        DateCalculation: Integer;
        PORec: Record "Purchase Header";
    begin

        if (TrackSpec."Expiration Date" - Today) <= 365 THEN begin      //Check that it's less than one year first.
            if (TrackSpec."Source Type" = 39) and (TrackSpec."Source Subtype" = 1) then begin    //If From GRN
                PORec.reset;
                PORec.SetRange("No.", TrackSpec."Source ID");
                if PORec.FindFirst() then begin
                    Vendcode := PORec."Buy-from Vendor No.";
                end;
            end;
            ItemCode := TrackSpec."Item No.";

            if VendCode <> '' then begin
                VendRec.Reset();
                VendRec.SetRange("No.", VendCode);
                VendRec.SetRange(Exchangeable, true);
                if VendRec.FindFirst() then
                    exit(true);

            end;
            if ItemCode <> '' then begin
                ItemRec.reset;
                ItemRec.SetRange("No.", ItemCode);
                ItemRec.SetRange(Exchangeable, true);
                if ItemRec.FindFirst() then
                    exit(TRUE);
            end;
        end else
            exit(false);
    end;
*/
    procedure UpdateExchangeable(ItemCode: code[20]; ItemBatch: Code[50]; ExchangeBool: Boolean)
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
    begin
        myInt := 0;
        ILERec.reset;
        ILERec.SetRange("Item No.", ItemCode);
        ILERec.SetRange("Lot No.", ItemBatch);
        if ILERec.FindSet() then
            repeat
                ILERec.Exchangeable := ExchangeBool;
                ILERec.Modify(false);
                myInt += 1;
            until ILERec.next = 0;
        if myInt <> 0 then
            Message('%1 Entries have been updated.', myInt);
    end;


    procedure IsNewCustomerOrItem(SLRec: Record "Sales Line"): Boolean      //If created in the same year, counted as new customer / item
    var
        CustRec: record customer;
        ItemRec: record Item;
    begin
        CustRec.Reset();
        CustRec.SetLoadFields(SystemCreatedAt);
        CustRec.SetRange("No.", SLRec."Sell-to Customer No.");
        if CustRec.FindFirst() then begin
            if IsSameCalendarYear(CustRec.SystemCreatedAt) then
                exit(true);
        end;

        if (SLRec.Type = SLRec.Type::Item) and (SLRec."No." <> '') then begin
            ItemRec.Reset();
            ItemRec.SetLoadFields(SystemCreatedAt);
            ItemRec.SetRange("No.", SLRec."No.");
            if CustRec.FindFirst() then begin
                if IsSameCalendarYear(ItemRec.SystemCreatedAt) then
                    exit(true);
            end;
        end;

    end;

    procedure IsSameCalendarYear(Created: DateTime): Boolean
    var
        myInt: Integer;
        CreatedDate: Date;
        StartYear: Date;
        EndYear: Date;
    begin
        StartYear := CalcDate('<-CY>', today);
        EndYear := CalcDate('<CY>', today);
        CreatedDate := DT2Date(Created);
        if (CreatedDate > StartYear) and (CreatedDate < EndYear) then
            exit(true)
        else
            exit(false);
    end;
    //DX        14 July 2021

    //DX        16 July 2021
    procedure UpdateWhAssignUser(lUserID: Code[50]): Code[50];
    var
        myInt: Integer;
        WHEmp: Record "Warehouse Employee";
    begin
        WHEmp.reset;
        WHEmp.SetRange("User ID", UserID);
        if WHEmp.FindFirst() then
            exit(lUserID)
        else
            exit('');
    end;
    //DX        16 July 2021
    //DX        01 Aug 2021
    procedure SyncCurrencies(var CurrExchRate: Record "Currency Exchange Rate")
    var
        CurrRec: Record Currency;
        CompanyRec: Record Company;
        lCurrExchRec: Record "Currency Exchange Rate";
        CurrentCurrRec: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrGLSetup: Record "General Ledger Setup";
    // DebugText: Text[500];
    begin

        // YF 09 Jan 2022 // Troubleshooting Debug
        /*
        CompanyRec.Reset;
        // CompanyRec.SetRange(Name, '<>%1', CompanyName);
        CompanyRec.SetFilter(Name, '<>%1', CompanyName);
        if CompanyRec.FindSet() then
            repeat
                DebugText += ' | ' + CompanyRec.Name + ' | ';
            until CompanyRec.Next() = 0;
        Message(DebugText);
        */
        // YF 09 Jan 2022 // Troubleshooting Debug

        // YF 09 Jan 2022 // Fixed
        GLSetup.Get; // Get current company GLSetup
        CompanyRec.Reset;
        CompanyRec.SetFilter(Name, '<>%1', CompanyName);
        if CompanyRec.FindSet() then
            repeat
                // Get selected company GLSetup
                CurrGLSetup.Reset;
                CurrGLSetup.ChangeCompany(CompanyRec.Name);
                CurrGLSetup.Get;

                if GLSetup."LCY Code" = CurrGLSetup."LCY Code" then begin
                    CurrRec.Reset;
                    CurrRec.ChangeCompany(CompanyRec.Name);
                    CurrRec.SetRange(Code, CurrExchRate."Currency Code");
                    if Not (CurrRec.FindFirst()) then begin
                        CurrentCurrRec.Reset;
                        CurrentCurrRec.SetRange(Code, CurrExchRate."Currency Code");
                        if CurrentCurrRec.FindFirst() then begin
                            CurrRec.ChangeCompany(CompanyRec.Name);
                            CurrRec.Init;
                            CurrRec.Copy(CurrentCurrRec);
                            CurrRec.Insert(true);
                        end;
                    end;

                    lCurrExchRec.Reset;
                    lCurrExchRec.ChangeCompany(CompanyRec.Name);
                    lCurrExchRec.SetRange("Currency Code", CurrExchRate."Currency Code");
                    lCurrExchRec.SetRange("Starting Date", CurrExchRate."Starting Date");
                    if not (lCurrExchRec.FindFirst()) then begin
                        lCurrExchRec.Reset;
                        lCurrExchRec.ChangeCompany(CompanyRec.Name);
                        lCurrExchRec.Init;
                        lCurrExchRec.Copy(CurrExchRate);
                        lCurrExchRec.Insert(true);
                    end //; // YF 21 Apr 2022 // Start
                    else begin
                        lCurrExchRec.Validate("Exchange Rate Amount", CurrExchRate."Exchange Rate Amount");
                        lCurrExchRec.Validate("Relational Exch. Rate Amount", CurrExchRate."Relational Exch. Rate Amount");
                        lCurrExchRec.Validate("Adjustment Exch. Rate Amount", CurrExchRate."Adjustment Exch. Rate Amount");
                        lCurrExchRec.Validate("Relational Adjmt Exch Rate Amt", CurrExchRate."Relational Adjmt Exch Rate Amt");
                        lCurrExchRec.Modify(true);
                    end;
                    // YF 21 Apr 2022 // End
                end;

            until CompanyRec.next = 0;
        // YF 09 Jan 2022 // Fixed

        // Previous
        /*
        CompanyRec.reset;
        CompanyRec.SetRange(Name, '<>%1', CompanyName);
        if CompanyRec.FindSet() then
            repeat
                CurrRec.reset;
                CurrRec.ChangeCompany(CompanyRec.Name);
                CurrRec.SetRange(Code, CurrExchRate."Currency Code");
                if not (CurrRec.FindFirst()) then begin
                    CurrentCurrRec.reset;
                    CurrentCurrRec.SetRange(Code, CurrExchRate."Currency Code");
                    if CurrentCurrRec.FindFirst() then begin
                        CurrRec.init;
                        CurrRec.ChangeCompany(CompanyRec.Name);
                        CurrRec.Copy(CurrentCurrRec);
                        currrec.Insert(TRUE);
                    end;
                end;

                lCurrExchRec.reset;
                lCurrExchRec.ChangeCompany(CompanyRec.Name);
                lCurrExchRec.SetRange("Currency Code", CurrExchRate."Currency Code");
                lCurrExchRec.SetRange("Starting Date", CurrExchRate."Starting Date");
                if not (lCurrExchRec.FindFirst()) then begin
                    lCurrExchRec.reset;
                    lCurrExchRec.init;
                    lCurrExchRec.Copy(CurrExchRate);
                    lCurrExchRec.Insert(TRUE);
                end;

            until CompanyRec.next = 0;
        */
        // Previous
    end;
    //DX        01 Aug 2021
    //DX        21 July 2021
    procedure LsItemCannotEnter(SLRec: Record "Sales Line")
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        ItemRec: Record item;
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        SHRec.SetRange("Logistics Service", true);
        if SHRec.FindFirst() then begin
            if (SLRec.Type = SLRec.Type::Item) AND (SLRec."No." <> '') then begin
                ItemRec.reset;
                ItemRec.Get(SLRec."No.");
                if ItemRec."Logistics Service" = false then begin
                    if GuiAllowed then
                        Error('You can only sell LS Items for LS Orders, please reselect.');
                end;
            end;
        end;
    end;
    //DX        21 July 2021

    // YF  23 July 2021
    procedure CalculatePurchPriceFOCQty(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal): Decimal
    var
        TradeAgreementCU: Codeunit "Trade Agreement CU";
        PriceListLineRec: Record "Price List Line";
        FOCQty: Decimal;
    begin
        TradeAgreementCU.GetPriceTierForPurchaseAgreement(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty, PriceListLineRec);
        if PriceListLineRec."Minimum Quantity" <> 0 then
            FOCQty := (AssetOrderQty DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
        FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15    
        exit(FOCQty);
    end;
    // YF  23 July 2021

    //DX        07 Sept 2021        To cater for transfer order posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]

    local procedure OnAfterTransferOrderPostShipment(var TransferShipmentHeader: Record "Transfer Shipment Header"; var TransferHeader: Record "Transfer Header")
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALEREc.reset;
        ALEREc.SetRange("Document No.", TransferHeader."No.");
        ALEREc.SetRange(Status, ALEREc.Status::Checking);
        if ALEREc.FindFirst() then begin
            ALEREc."Invoice No." := TransferShipmentHeader."No.";
            ALEREc.Modify(FALSE);
        end;
    end;
    //DX        07 Sept 2021
    //DX        28 JUly 2021

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]

    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
        ALEREc: Record "Assignment Ledger Entry";
        RSHRec: Record "Sales Header";
        RSLRec: Record "Sales Line";
        SCHRec: Record "Sales Cr.Memo Header";
        SCLRec: Record "Sales Cr.Memo Line";
        SIHREC: Record "Sales Invoice Header";
        QtySend: Decimal;
        CheckRec: Record "Checking Header";
        WHCU: Codeunit "Warehouse CU";
        CustRec: Record Customer;
    begin
        SHRec.Reset();
        SHRec.SetRange("No.", SalesHeader."No.");
        SHRec.SetRange("Document Type", SalesHeader."Document Type");
        if SHRec.FindFirst() then begin

            // YF 09 Nov 2021
            if CustRec.Get(SHRec."Sell-to Customer No.") then begin
                SHRec.Archived := CustRec."Single PO";
                SHRec.Modify(false);
            end;
            // YF 09 Nov 2021

            // YF 28 Dec 2021
            SLRec.Reset;
            SLRec.SetRange("Document Type", SHRec."Document Type");
            SLRec.SetRange("Document No.", SHRec."No.");
            if SLRec.FindSet() then
                repeat
                    // Trigger change if invoiced only (hacky)
                    if SalesInvHdrNo <> '' then begin
                        SLRec."FOC Qty Delivered" := SLRec."FOC Qty Delivered" + SLRec."FOC (Qty) To Deliver";
                        SLRec."Qty Delivered" := SLRec."Qty Delivered" + SLRec."Qty To Deliver";
                        SLRec."FOC (Qty) To Deliver" := SLRec."FOC Qty" - SLRec."FOC Qty Delivered";
                        SLRec."Qty To Deliver" := SLRec."Order Qty" - SLRec."Qty Delivered";
                    end;

                    // Reset Sales Line Unit Price
                    if SLRec.Quantity <> 0 then begin
                        SLRec."Unit Price" := (SLRec."Order Qty" * SLRec."Selling Price") / SLRec.Quantity;
                        SLRec."Line Amount" := SLRec."Order Qty" * SLRec."Selling Price";
                    end
                    else begin
                        SLRec."Unit Price" := 0;
                        SLRec."Line Amount" := 0;
                    end;
                    /*
                    if SLRec.Quantity <> 0 then
                        SLRec.Validate("Unit Price", (SLRec."Order Qty" * SLRec."Selling Price") / SLRec.Quantity)
                    else
                        SLRec.Validate("Unit Price", 0);
                    */

                    SLRec.Modify(FALSE);

                until SLRec.Next() = 0;

            /*
            SLRec.reset;
            SLRec.SetRange("Document Type", SHRec."Document Type");
            SLRec.SetRange("Document No.", SHRec."No.");
            if SLRec.FindFirst() then begin
                //DX        12 Sept 2021
                SLRec."FOC Qty Delivered" := SLRec."FOC Qty Delivered" + SLRec."FOC (Qty) To Deliver";
                SLRec."Qty Delivered" := SLRec."Qty Delivered" + SLRec."Qty To Deliver";
                SLRec."FOC (Qty) To Deliver" := SLRec."FOC Qty" - SLRec."FOC Qty Delivered";
                SLRec."Qty To Deliver" := SLRec."Order Qty" - SLRec."Qty Delivered";
                SLRec.Modify(FALSE);
            end;
            */
            // YF 28 Dec 2021

        end;

        //DX        20 Aug 2021
        ALEREc.reset;
        ALEREc.SetCurrentKey("Document No.", Status, "Customer No.");
        //ALEREc.SetCurrentKey();
        ALEREc.SetRange("Document No.", SalesHeader."No.");
        ALEREc.SetRange(Status, ALEREc.Status::Checking);
        //ALEREc.SetRange("Customer No.", '<>%1', 'Deleted Document');
        ALEREc.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        if ALEREc.FindFirst() then begin
            //DX        12 Oct 2021
            if whcu.GetPickListTypeFromSalesInv(SalesInvHdrNo) = 1 then
                ALEREc."Pick Type" := ALEREc."Pick Type"::"Non-Cold"
            else
                if whcu.GetPickListTypeFromSalesInv(SalesInvHdrNo) = 2 then
                    ALEREc."Pick Type" := ALEREc."Pick Type"::Cold
                else
                    if whcu.GetPickListTypeFromSalesInv(SalesInvHdrNo) = 3 then
                        ALEREc."Pick Type" := ALEREc."Pick Type"::Combined;
            //DX        12 Oct 2021
            ALEREc."Invoice No." := SalesInvHdrNo;
            ALEREc.Modify(FALSE);
            //DX        05 OCt 2021
            CheckRec.reset;
            CheckRec.SetRange("No.", ALEREc."Checking Doc No.");
            if CheckRec.FindFirst() then begin
                CheckRec."Posting Date" := today;
                CheckRec.Checker := UserId;
                CheckRec."End Time" := CurrentDateTime;
                CheckRec.Status := CheckRec.Status::Completed;
                CheckRec.Modify(false);
            end;

            //DX        05 OCt 2021
        end;
        //DX        20 Aug 2021
        //DX        25 Aug 2021
        SIHREC.reset;
        SIHREC.SetRange("No.", SalesInvHdrNo);
        if SIHRec.FindFirst() then begin
            SIHREC."Order Status" := SIHREC."Order Status"::"Pending Delivery";
            SIHREC.Modify(true);
        end;
        //DX        25 Aug 2021
    end;
    //DX        28 July 2021


    //DX        14 Sept 2021
    local procedure CreateSOReservationEntry(SORec: Record "Sales Cr.Memo Line"; SLRec: Record "Sales Line")
    var
        myInt: Integer;
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        SHRec: Record "Sales Header";
        VLERec: Record "Value Entry";
    begin
        VLERec.reset;
        VLERec.SetLoadFields("Entry Type", "Document No.", "Document Line No.", "Item Ledger Entry No.");
        VLERec.SetCurrentKey("Entry Type", "Document No.", "Document Line No.");
        VLERec.SetRange("Entry Type", VLERec."Entry Type"::"Direct Cost");
        VLERec.SetRange("Document No.", SORec."Document No.");
        VLERec.SetRange("Document Line No.", SORec."Line No.");
        if VLERec.findfirst then begin
            ILERec.reset;
            ILERec.SetLoadFields("Lot No.", "Qty. per Unit of Measure", Quantity);
            ILERec.SetRange("Entry No.", VLERec."Item Ledger Entry No.");
            if ILERec.FindFirst() then begin
                CLEAR(ReservEntry);
                ReservEntryNo.RESET;
                ReservEntry.INIT;
                IF ReservEntryNo.FINDLAST THEN
                    ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
                ELSE
                    ReservEntry."Entry No." := 1;

                ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
                ReservEntry.VALIDATE("Item No.", SLRec."No.");
                ReservEntry.VALIDATE("Location Code", SLRec."Location Code");
                ReservEntry.VALIDATE("Source Type", 37);
                // ReservEntry.VALIDATE("Source Subtype", 1);
                ReservEntry.VALIDATE("Source Subtype", 1);
                ReservEntry.VALIDATE("Source ID", SLRec."Document No.");
                ReservEntry.VALIDATE("Source Ref. No.", SLRec."Line No.");
                ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
                ReservEntry.VALIDATE("Lot No.", ILERec."Lot No.");
                ReservEntry.VALIDATE("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                ReservEntry.VALIDATE(Quantity, -ILERec.Quantity);
                ReservEntry.VALIDATE("Quantity (Base)", -ILERec.Quantity);
                SHRec.RESET;
                SHRec.SETRANGE("No.", SLRec."Document No.");
                SHRec.SetRange("Document Type", SHRec."Document Type"::order);
                IF SHRec.FINDFIRST THEN BEGIN
                    ReservEntry.VALIDATE("Shipment Date", SHRec."Posting Date");
                END;
                ReservEntry.VALIDATE("Creation Date", TODAY);
                ReservEntry.VALIDATE("Created By", USERID);
                ReservEntry.VALIDATE("Qty. to Handle (Base)", -ILERec.Quantity);
                ReservEntry.VALIDATE("Qty. to Invoice (Base)", -ILERec.Quantity);
                ReservEntry.INSERT(TRUE);
            end;
        end;

    end;
    //DX        13 Sept 2021
    //DX        14 Sept 2021

    // YF  29 July 2021
    // Pending Obselete
    /*
    procedure CalculatePurchPriceFOCQty_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal): Decimal
    var
        TradeAgreementCU: Codeunit "Trade Agreement CU";
        PriceListLineRec: Record "Pharma Purchase Price";
        FOCQty: Decimal;
    begin
        TradeAgreementCU.GetPriceTierForPurchaseAgreement_PMPCustomized(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty, PriceListLineRec);
        if PriceListLineRec."Minimum Quantity" <> 0 then
            FOCQty := (AssetOrderQty DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
        FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15    
        exit(FOCQty);
    end;
    */
    // YF  29 July 2021

    // YF  30 July 2021
    procedure CalculatePurchPriceFOCQty_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal;
                                                        var RetPurchPrice: Decimal; var RetFOCQty: Decimal)
    var
        TradeAgreementCU: Codeunit "Trade Agreement CU";
        PriceListLineRec: Record "Pharma Purchase Price";
        FOCQty: Decimal;
        ItemRec: Record Item;
    begin
        TradeAgreementCU.GetPriceTierForPurchaseAgreement_PMPCustomized(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty, PriceListLineRec);

        if PriceListLineRec.IsEmpty then begin
            // use item card last direct unit cost
            if ItemRec.Get(AssetNo) then begin
                // assign back parameters from Item card record
                RetFOCQty := 0;
                RetPurchPrice := ItemRec."Last Direct Cost";
            end;
        end
        else begin
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (AssetOrderQty DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15    

            // assign back parameters
            RetFOCQty := FOCQty;
            RetPurchPrice := PriceListLineRec."Direct Unit Cost";
        end;
    end;
    // YF  30 July 2021

    // YF  21 Oct 2021
    procedure CalculatePurchPriceFOCQty_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal;
                                                        var RetPurchPrice: Decimal; var RetFOCQty: Decimal; var RetLineDiscountPercent: Decimal)
    var
        TradeAgreementCU: Codeunit "Trade Agreement CU";
        PriceListLineRec: Record "Pharma Purchase Price";
        FOCQty: Decimal;
        ItemRec: Record Item;
    begin
        TradeAgreementCU.GetPriceTierForPurchaseAgreement_PMPCustomized(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty, PriceListLineRec);

        if PriceListLineRec.IsEmpty then begin
            // use item card last direct unit cost
            if ItemRec.Get(AssetNo) then begin
                // assign back parameters from Item card record
                RetFOCQty := 0;
                RetPurchPrice := ItemRec."Last Direct Cost";
                RetLineDiscountPercent := 0;
            end;
        end
        else begin
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (AssetOrderQty DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15    

            // assign back parameters
            RetFOCQty := FOCQty;
            RetPurchPrice := PriceListLineRec."Direct Unit Cost";
            if PriceListLineRec."Allow Line Disc." then
                RetLineDiscountPercent := PriceListLineRec."Line Discount %";
        end;
    end;
    // YF  21 Oct 2021


    //DX        08 Aug 2021 : For issue #75.
    procedure CreatePrincipalPOs(PORec: Record "Purchase Header")
    var
        myInt: Integer;
        LineNO: integer;
        lPORec: Record "Purchase Header";
        lPLRec: Record "Purchase Line";
        PLRec: Record "Purchase Line";
        TempPLRec: Record Principal temporary;
        TempPLRec2: Record Principal temporary;
        ItemRec: Record item;
    begin
        if POHasMultiplePrincipal(PORec) then begin
            lPLRec.reset;
            lPLRec.SetRange("Document Type", PORec."Document Type");
            lPLRec.SetRange("Document No.", PORec."No.");
            lPLRec.SetRange(Type, lPLRec.Type::Item);
            lPLRec.SetFilter("No.", '<>%1', '');
            lPLRec.SetFilter(Quantity, '<>0');
            if lPLRec.FindSet() then                //DX        08 Aug 2021     Get unique combination of Principal list first.
                repeat
                    TempPLRec.reset;
                    TempPLRec.SetRange(TempPLRec.Code, lPLRec.Principal);
                    if not TempPLRec.FindFirst() then begin
                        TempPLRec2.reset;
                        TempPLRec2.init;
                        TempPLRec2.Code := lPLRec.Principal;
                        TempPLRec2.Insert(FALSE);
                        TempPLRec.reset;
                        TempPLRec.Copy(TempPLRec2);
                        TempPLRec.Insert(FALSE);
                    end;
                until lPLRec.next = 0;
            TempPLRec2.reset;
            myInt := 1;
            if TempPLRec2.FindSet() then
                repeat
                    if myInt > 1 then begin
                        lPORec.reset;
                        lPORec.init;
                        lPORec.Validate("Document Type", PORec."Document Type");
                        lPORec.validate("Buy-from Vendor No.", PORec."Buy-from Vendor No.");
                        lPORec.validate("Posting Date", PORec."Posting Date");
                        lPORec.Validate("Document Date", PORec."Document Date");
                        lPORec.Insert(TRUE);
                        LineNO := 10000;
                        lPLRec.reset;
                        lPLRec.SetRange("Document Type", PORec."Document Type");
                        lPLRec.SetRange("Document No.", PORec."No.");
                        lPLRec.SetRange(Type, lPLRec.Type::Item);
                        lPLRec.SetFilter("No.", '<>%1', '');
                        lPLRec.SetFilter(Quantity, '<>0');
                        lPLRec.SetRange(Principal, TempPLRec.Code);
                        if lPLRec.FindSet() then
                            repeat
                                PLRec.reset;
                                PLRec.init;
                                PLRec.Validate("Document Type", lPORec."Document Type");
                                PLRec.Validate("Document No.", lPORec."No.");
                                PLRec.validate("Line No.", LineNO);
                                PLrec.Validate(Type, lPLRec.Type);
                                PLRec.Validate("No.", lPLRec."No.");
                                PLRec.Validate("Order Qty", lPLRec."Order Qty");
                                PLRec.Validate("Purchase Price", lPLRec."Purchase Price");
                                PLRec.validate(Principal, lPLRec.Principal);
                                PLRec.validate(Quantity, lPLRec.Quantity);
                                PLRec.Validate("Direct Unit Cost", lPLRec."Direct Unit Cost");
                                PLRec.Insert(TRUE);
                                LineNO += 10000;
                            until lPLRec.next = 0;
                        lPLRec.Delete(TRUE);
                    end else begin      //Skip first row so no need to run through first row.
                        myInt += 1;
                    end;
                until TempPLRec2.next = 0;
            Message('%1 Purchase Orders created.', myInt - 1);
        end else begin
            Message('This PO does not have multiple principals in the lines. Please check again');
        end;
    end;

    local procedure POHasMultiplePrincipal(PORec: Record "Purchase Header"): Boolean
    var
        PLRec: Record "Purchase Line";
        Principal: Code[50];
    begin

        PLRec.reset;
        PLRec.SetRange("Document Type", PORec."Document Type");
        PLRec.SetRange("Document No.", PORec."No.");
        PLRec.SetRange(Type, PLRec.Type::Item);
        PLRec.SetFilter("No.", '<>%1', '');
        PLRec.SetFilter(Quantity, '<>0');
        if PLRec.FindSet() then
            repeat
                if Principal = '' then
                    Principal := PLRec.Principal
                else
                    if Principal <> PLRec.Principal then
                        exit(true);
            until PLRec.next = 0;
        exit(false);

    end;
    //DX        08 Aug 2021



    //DX        13 Aug 2021
    //DX        Check that there is outstanding sales orders in use before allowing to create another sales order.
    //Pending on final version
    /*
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckCreditLimitIfLineNotInsertedYet', '', true, true)]
    local procedure OnBeforeCheckCreditLimitIfLineNotInsertedYet(var SalesHeader: Record "Sales Header")
    var
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
    begin
        SHRec.reset;
        SHRec.SetRange("Order Status", SHRec."Order Status"::Open);
        SHRec.SetRange("Document Type", SalesHeader."Document Type");
        SHRec.SetRange("No.", SalesHeader."No.");
        if SHRec.count > 0 then begin
            if Confirm('There is already an existing open sales order that is not released yet, do you want to use back this order?') then begin

            end;

        end;
    end;
*/
    //DX        13 Aug 2021     To check for poison / non poisonous first 
    procedure CustItemForensicIsTrue(SLRec: Record "Sales Line")
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        CustRec: Record customer;
        ItemRec: Record item;
        ForensicRec: Record "Forensic Group";
    begin
        if (SLRec.Type = SLRec.Type::Item) and (SLRec."No." <> '') then begin       //Check first if customer is poison/non poison
            CustRec.reset;
            CustRec.SetRange("No.", SLRec."Sell-to Customer No.");
            CustRec.SetFilter("Forensic Permmission Group", '<>%1', CustRec."Forensic Permmission Group"::Poison);
            if CustRec.FindFirst() then begin
                ItemRec.reset;
                ItemRec.SetRange("No.", SLRec."No.");
                if ItemRec.FindFirst() then begin
                    //Confirmed this 2 are poisionous as mentioned by customer
                    ForensicRec.reset;
                    ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                    ForensicRec.SetRange(Poison, true);
                    if ForensicRec.FindFirst() then
                        if GuiAllowed then
                            Error('Item cannot be sold to customer, item is rated as poisonous.');
                end;
            end;
        end;
    end;

    procedure CustIsInAllowed(SLRec: Record "Sales Line")
    var
        SHRec: Record "Sales Header";
        CustRec: Record customer;
        ItemRec: Record item;
        AllowedList: Record "Allowed Cust-Item";
        AllowedListItem: Record "Allowed Cust-Item";
    begin
        SHRec.reset;
        SHRec.SetLoadFields("Document Type", "No.", "Bill-to Customer No.");
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin
            AllowedList.reset;
            AllowedList.SetRange("Cust No.", SHRec."Bill-to Customer No.");
            if AllowedList.FindFirst() then begin
                //If customer is in list of allowed sales, then need to check the item list if it's allowed
                AllowedListItem.reset;
                AllowedListItem.SetRange("Cust No.", SHRec."Bill-to Customer No.");
                AllowedListItem.SetRange("Item No.", SLRec."No.");
                if NOT (AllowedListItem.FindFirst()) then begin
                    if GuiAllowed then
                        Error(StrSubstNo('Selected item % is not within allowed item set for this customer.', SLRec."No.", SHRec."Bill-to Customer No."));
                end;
            end;                //If not in list, then just allow the sale.
        end;

    end;
    //DX        13 Aug 2021
    //DX        15 Aug 2021
    procedure PMPPOApproval(Var PHRec: Record "Purchase Header")
    var
        myInt: Integer;
        PLRec: Record "Purchase Line";
    begin
        PLRec.reset;
        PLRec.SetRange("Document Type", PHRec."Document Type");
        PLRec.SetRange("Document No.", PHRec."No.");
        PLRec.SetFilter("Line Amount", '<>0');
        PLRec.SetRange("Special Order", false);     //Only trigger for non special orders
        if PLRec.FindSet() then
            repeat
                if PLRec.Amount > 5000 then begin
                    PLRec.Validate(PLRec.">5K", true);
                    if PHRec.">5K" = false then
                        PHRec.">5K" := true;
                end;

                if PLRec.Amount > 300000 then begin
                    PLRec.Validate(PLRec.">300K", true);
                    if PHRec.">300K" = false then
                        PHRec.">300K" := true;
                end;

                // if IsMoreThan6MthInv(PLRec) > 6 then begin
                if PLRec.">6 Mth Inventory" = true then begin
                    PHRec.">6 Mth Inventory" := true;
                    // PHRec.Modify(TRUE);
                end;


                PLRec.Modify(TRUE);
                PHRec.Modify(TRUE);

            //DX        Pending more than 6 mth inv formula
            until PLRec.next = 0;
    end;
    // YF 02 March 2025
    procedure IsMoreThan3MthInv(var PLRec: record "Purchase Line"): Decimal
    var
        myInt: Integer;
        ItemRec: Record item;
        OnHandStock: Decimal;
        OpenPOStock: Decimal;
        ILEAMQ3: Decimal;
        OpenSOStock: Decimal;

        PHRec: Record "Purchase Header";
        ILERec: Record "Item Ledger Entry";
        lPLRec: Record "Purchase Line";
        lSLRec: Record "Sales Line";
        AMQ3: Decimal;      //Average monthly sales for 3 months
        POPeriod: Integer;
        estStocks: Decimal;
        HisOB: Record "Historical Item Sales";
        AMQ3X: Decimal;
        X: Decimal;
    begin
        /*
        * Defined as:
         Stocks on hand
        + Open PO incl current one
        - Open SO 
        - AMQ3 x period from PO date to ETA date
        = Est stocks at ETA (X)
        Divide (X) by AMQ3
        = Mths holding on ETA
        */
        if (PLRec."No." <> '') and (PLRec.Quantity <> 0) and (PLRec.Type = PLRec.Type::Item) then begin

            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Location Code", "Entry Type", "Posting Date", Quantity);
            ILERec.SetRange("Item No.", PLRec."No.");
            ILERec.SetRange("Location Code", PLRec."Location Code");
            ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
            ILERec.SetFilter("Posting Date", '%1..%2', CalcDate('<-cm-3M>', Today), CalcDate('<-cm-1d>', Today));
            ILERec.CalcSums(ILERec.Quantity);
            if ILERec.Quantity <> 0 then
                ILEAMQ3 := ILERec.Quantity * -1;

            ItemRec.reset;
            ItemRec.Get(PLRec."No.");
            ItemRec.SetFilter("Location Filter", PLRec."Location Code");
            ItemRec.CalcFields("Qty. on Sales Order", "Qty. on Purch. Order", Inventory);
            OpenSOStock := ItemRec."Qty. on Sales Order";
            OpenPOStock := ItemRec."Qty. on Purch. Order";
            OnHandStock := ItemRec.Inventory;

            HisOB.reset;
            HisOB.SetLoadFields("Item No.", "Location Code", "Entry Type", "Posting Date", Quantity);
            HisOB.SetRange("Item No.", PLRec."No.");
            HisOB.SetRange("Location Code", PLRec."Location Code");
            HisOB.SetRange("Entry Type", HisOB."Entry Type"::"Sales Shipment");
            HisOB.SetFilter("Posting Date", '%1..%2', CalcDate('<-cm-3M>', Today), CalcDate('<-cm-1d>', Today));
            HisOB.CalcSums(HisOB.Quantity);

            PHRec.reset;
            PHRec.SetLoadFields("Document Type", "No.", "Order Date", "Expected Receipt Date");
            PHRec.SetRange("Document Type", PLRec."Document Type");
            PHRec.SetRange("No.", PLRec."Document No.");
            if PHRec.FindFirst() then begin
                if (PHRec."Order Date" = 0D) OR (PHRec."Expected Receipt Date" = 0D) then
                    POPeriod := 1
                else begin
                    POPeriod := PHRec."Expected Receipt Date" - PHRec."Order Date";
                    if POPeriod = 0 then
                        poperiod := 1;
                end;
            end;

            if ILEAMQ3 + HisOB.Quantity <> 0 then
                AMQ3 := ((ILEAMQ3 + HisOB.Quantity) / 6)
            else
                AMQ3 := 1;
            //Total quantity of sales / 3 average months first, then divide by 20 working days * by PO date to ETA date
            X := Round((AMQ3 / 20) * POPeriod, 1);

            estStocks := OnHandStock + OpenPOStock - OpenSOStock - X;
            if AMQ3 <> 0 then
                AMQ3X := estStocks / AMQ3;

            if AMQ3X > 3 then begin
                PLRec.">3 Mth Inventory" := true;
                PLRec.Modify(FALSE);

            end else begin
                PLRec.">3 Mth Inventory" := false;
                PLRec.Modify(FALSE);

            end;
            Commit();
            exit(AMQ3X);
        end else
            exit(0);
    end;
    // YF 02 March 2025
    procedure IsMoreThan6MthInv(var PLRec: record "Purchase Line"): Decimal
    var
        myInt: Integer;
        ItemRec: Record item;
        OnHandStock: Decimal;
        OpenPOStock: Decimal;
        ILEAMQ6: Decimal;
        OpenSOStock: Decimal;

        PHRec: Record "Purchase Header";
        ILERec: Record "Item Ledger Entry";
        lPLRec: Record "Purchase Line";
        lSLRec: Record "Sales Line";
        AMQ6: Decimal;      //Average monthly sales for 6 months
        POPeriod: Integer;
        estStocks: Decimal;
        HisOB: Record "Historical Item Sales";
        AMQ6X: Decimal;
        X: Decimal;
    begin
        /*
        * Defined as:
         Stocks on hand
        + Open PO incl current one
        - Open SO 
        - AMQ6 x period from PO date to ETA date
        = Est stocks at ETA (X)
        Divide (X) by AMQ6
        = Mths holding on ETA
        */
        if (PLRec."No." <> '') and (PLRec.Quantity <> 0) and (PLRec.Type = PLRec.Type::Item) then begin

            ILERec.reset;
            ILERec.SetLoadFields("Item No.", "Location Code", "Entry Type", "Posting Date", Quantity); //DX        06 May 2023
            ILERec.SetRange("Item No.", PLRec."No.");
            ILERec.SetRange("Location Code", PLRec."Location Code");
            ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
            ILERec.SetFilter("Posting Date", '%1..%2', CalcDate('<-cm-6M>', Today), CalcDate('<-cm-1d>', Today));//RL  8Nov2021 change date range to previous 6 months
            ILERec.CalcSums(ILERec.Quantity);
            if ILERec.Quantity <> 0 then
                ILEAMQ6 := ILERec.Quantity * -1; //RL    20 Dec 21   to reverse the sign.
            // Message('ILE-%1', ILERec.Quantity);

            ItemRec.reset;
            ItemRec.Get(PLRec."No.");
            ItemRec.SetFilter("Location Filter", PLRec."Location Code");
            ItemRec.CalcFields("Qty. on Sales Order", "Qty. on Purch. Order", Inventory);
            OpenSOStock := ItemRec."Qty. on Sales Order";
            OpenPOStock := ItemRec."Qty. on Purch. Order";
            OnHandStock := ItemRec.Inventory;
            // Message('so-%1,po-%2,hand-%3', OpenSOStock, OpenPOStock, OnHandStock);
            //OnHandStock := 10;
            //DX        21 Aug 2021
            HisOB.reset;
            HisOB.SetLoadFields("Item No.", "Location Code", "Entry Type", "Posting Date", Quantity);    //DX        06 May 2023
            HisOB.SetRange("Item No.", PLRec."No.");
            HisOB.SetRange("Location Code", PLRec."Location Code");
            HisOB.SetRange("Entry Type", HisOB."Entry Type"::"Sales Shipment"); //RL    1Nov2021 - change from Purchase to Sales
            HisOB.SetFilter("Posting Date", '%1..%2', CalcDate('<-cm-6M>', Today), CalcDate('<-cm-1d>', Today));//RL  8Nov2021 change date range to previous 6 months
            HisOB.CalcSums(HisOB.Quantity);
            //DX        21 Aug 2021
            // Message('OB-%1', HisOB.Quantity);

            PHRec.reset;
            PHRec.SetLoadFields("Document Type", "No.", "Order Date", "Expected Receipt Date");     //DX        06 May 2023
            PHRec.SetRange("Document Type", PLRec."Document Type");
            PHRec.SetRange("No.", PLRec."Document No.");
            if PHRec.FindFirst() then begin
                if (PHRec."Order Date" = 0D) OR (PHRec."Expected Receipt Date" = 0D) then
                    POPeriod := 1
                else begin
                    POPeriod := PHRec."Expected Receipt Date" - PHRec."Order Date";
                    if POPeriod = 0 then
                        poperiod := 1;
                end;
            end;

            if ILEAMQ6 + HisOB.Quantity <> 0 then
                AMQ6 := ((ILEAMQ6 + HisOB.Quantity) / 6)
            else
                AMQ6 := 1;
            //Total quantity of sales / 6 average months first, then divide by 20 working days * by PO date to ETA date
            X := Round((AMQ6 / 20) * POPeriod, 1);

            estStocks := OnHandStock + OpenPOStock - OpenSOStock - X;
            if AMQ6 <> 0 then
                AMQ6X := estStocks / AMQ6;

            if AMQ6X > 6 then begin
                PLRec.">6 Mth Inventory" := true;
                PLRec.Modify(FALSE);

            end else begin
                PLRec.">6 Mth Inventory" := false;
                PLRec.Modify(FALSE);

            end;
            Commit();
            exit(AMQ6X);
        end else
            exit(0);

    end;    //DX        15 Aug 2021

    //DX        17 Aug 2021
    procedure GetColourCode(SLRec: Record "Sales Line"): Text[250]
    var
        myInt: Integer;
    begin
        /*        
        Green - online orders   :   Favorable
        Blue - promo items      :   StrongAccent
        Orange - Housebrands products       :Ambiguous
        Yellow - Differences for Chain usage only   : Unfavorable
        */


    end;


    procedure GetOrderNo(ILERec: Record "Item Ledger Entry"): Code[20]
    var
        myInt: Integer;
        PRRec: Record "Purch. Rcpt. Line";
        SHRec: Record "Sales Shipment Header";
        SLRec: Record "Sales Shipment Line";
        PHRec: Record "Purch. Rcpt. Header";
    begin
        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then begin
            SHRec.reset;
            SHRec.SetLoadFields("No.", "Order No."); //DX    24 May 2023
            SHRec.SetRange("No.", ILERec."Document No.");
            if SHRec.FindFirst() then BEGIN
                exit(SHRec."Order No.");
            end;
        end else
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then begin
                PHRec.reset;
                PHRec.SetLoadFields("No.", "Order No."); //DX    24 May 2023
                PHRec.SetRange("No.", ILERec."Document No.");
                if PHRec.FindFirst() then begin
                    exit(PHRec."Order No.");
                end;
            end else begin
                exit('');
            end;
    end;

    procedure GetOrderQty(ILERec: Record "Item Ledger Entry"): Decimal
    var
        myInt: Integer;
        PRRec: Record "Purch. Rcpt. Line";
        SLRec: Record "Sales Shipment Line";
    begin
        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then begin
            SLRec.reset;
            SLRec.SetLoadFields("Document No.", "Line No.", "Order Qty"); //DX    24 May 2023
            SLRec.SetRange("Document No.", ILERec."Document No.");
            SLRec.SetRange("Line No.", ILERec."Document Line No.");
            if SLRec.FindFirst() then begin
                exit(SLRec."Order Qty");
            end;
        end else
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then begin
                PRRec.reset;
                PRRec.SetLoadFields("Document No.", "Line No.", "Order Qty"); //DX    24 May 2023
                PRRec.SetRange("Document No.", ILERec."Document No.");
                PRRec.SetRange("Line No.", ILERec."Document Line No.");
                if PRRec.FindFirst() then begin
                    exit(PRRec."Order Qty");
                end;
            end else begin
                exit(0);
            end;
    end;

    procedure GetFOCQty(ILERec: Record "Item Ledger Entry"): Decimal
    var
        myInt: Integer;
        PRRec: Record "Purch. Rcpt. Line";
        SLRec: Record "Sales Shipment Line";
    begin
        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then begin
            SLRec.reset;
            SLRec.SetLoadFields("Document No.", "Line No.", "FOC Qty"); //DX      06 May 2023
            SLRec.SetRange("Document No.", ILERec."Document No.");
            SLRec.SetRange("Line No.", ILERec."Document Line No.");
            if SLRec.FindFirst() then begin
                exit(SLRec."FOC Qty");
            end;
        end else
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then begin
                PRRec.reset;
                PRRec.SetLoadFields("Document No.", "Line No.", "FOC Qty"); //DX      06 May 2023
                PRRec.SetRange("Document No.", ILERec."Document No.");
                PRRec.SetRange("Line No.", ILERec."Document Line No.");
                if PRRec.FindFirst() then begin
                    exit(PRRec."FOC Qty");
                end;
            end else begin
                exit(0);
            end;
    end;
    //RL        11 Jan 2022
    procedure GetActualPrice(ILERec: Record "Item Ledger Entry"): Decimal
    var
        myInt: Integer;
        PRRec: Record "Purch. Rcpt. Line";
        SLRec: Record "Sales Shipment Line";
    begin
        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then begin
            SLRec.reset;
            SLRec.SetLoadFields("Document No.", "Line No.", "Selling Price"); //DX    24 May 2023
            SLRec.SetRange("Document No.", ILERec."Document No.");
            SLRec.SetRange("Line No.", ILERec."Document Line No.");
            if SLRec.FindFirst() then begin
                exit(SLRec."Selling Price");
            end;
        end else
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then begin
                PRRec.reset;
                PRRec.SetLoadFields("Document No.", "Line No.", "Purchase Price");        //DX    24 May 2023
                PRRec.SetRange("Document No.", ILERec."Document No.");
                PRRec.SetRange("Line No.", ILERec."Document Line No.");
                if PRRec.FindFirst() then begin
                    exit(PRRec."Purchase Price");
                end;
            end else begin
                exit(0);
            end;
    end;
    //RL        11 Jan 2022
    procedure GetInvNo(ILERec: Record "Item Ledger Entry"): Code[20]
    var
        myInt: Integer;
        VLERec: Record "Value Entry";
    begin
        VLERec.reset;
        VLERec.SetLoadFields("Item Ledger Entry No.", "Document Type", "External Document No.");      //DX        24 May 2023
        VLERec.SetCurrentKey("Item Ledger Entry No.");      //DX    24 May 2023
        VLERec.SetRange("Item Ledger Entry No.", ILERec."Entry No.");
        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then begin
            VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
        end else
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then begin
                VLERec.SetRange("Document Type", VLERec."Document Type"::"Purchase Invoice");
            end;
        if VLERec.findfirst then begin
            exit(VLERec."Document No.");
        end;
        exit('');
    end;

    procedure GetExtDocNo(ILERec: Record "Item Ledger Entry"): Code[35]
    var
        VLERec: Record "Value Entry";
    begin
        VLERec.reset;
        VLERec.SetLoadFields("Item Ledger Entry No.", "Document Type", "External Document No.");      //DX        24 May 2023
        VLERec.SetCurrentKey("Item Ledger Entry No.");//DX    24 May 2023
        VLERec.SetRange("Item Ledger Entry No.", ILERec."Entry No.");
        if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then begin
            VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
        end else
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then begin
                VLERec.SetRange("Document Type", VLERec."Document Type"::"Purchase Invoice");
            end;
        if VLERec.findfirst then begin
            exit(VLERec."External Document No.");
        end;
        exit('');
    end;

    /*
        [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
        local procedure OnAfterCopyItemJnlLineFromPurchLine(PurchLine: Record "Purchase Line"; var ItemJnlLine: Record "Item Journal Line")
        begin
            ItemJnlLine.Exchangeable := PurchLine.Exchangeable;
        end;

        [EventSubscriber(ObjectType::Codeunit, codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
        local procedure OnBeforeInsertItemLedgEntry(ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry")
        begin
            ItemLedgerEntry.Exchangeable := ItemJournalLine.Exchangeable;
        end;
        //DX        17 Aug 2021

    */
    // YF        18 Aug 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnAfterInsertSalesOrderLine', '', false, false)]
    local procedure OnAfterInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; BlanketOrderSalesLine: Record "Sales Line"; BlanketOrderSalesHeader: Record "Sales Header")
    var
        InclPrice: Decimal;
        TotalQty: Decimal;
        ItemUOM: Record "Item Unit of Measure";

    begin
        //DX        21 May 2025
        if (SalesOrderLine.Type = SalesOrderLine.Type::Item) and (SalesOrderLine."No." <> '') then begin
            ItemUOM.reset;
            ItemUOM.SetLoadFields("Item No.", Code, I9G_BlockUOM);
            ItemUOM.SetRange("Item No.", SalesOrderLine."No.");
            ItemUOM.SetRange(Code, SalesOrderLine."Unit of Measure Code");
            if ItemUOM.FindFirst() then begin
                if ItemUOM.I9G_BlockUOM = true then
                    Error('Item UOM has been set to blocked for Sales, please check on this before trying to create the sales');
            end;
        end;

        //DX        21 May 2025
        TotalQty := BlanketOrderSalesLine."Qty To Deliver" + BlanketOrderSalesLine."FOC (Qty) To Deliver";
        if TotalQty <> 0 then begin
            InclPrice := (BlanketOrderSalesLine."Qty To Deliver" * BlanketOrderSalesLine."Selling Price") / TotalQty;
        end;
        /*
        SalesOrderLine.Validate("Order Qty", BlanketOrderSalesLine."Qty To Deliver");
        SalesOrderLine.Validate("FOC Qty", BlanketOrderSalesLine."FOC (Qty) To Deliver");
        SalesOrderLine.Validate("Selling Price", BlanketOrderSalesLine."Selling Price");
        SalesOrderLine.Validate("Qty To Deliver", SalesOrderLine."Order Qty");
        SalesOrderLine.Validate("FOC (Qty) To Deliver", SalesOrderLine."FOC Qty");
        */

        SalesOrderLine."Order Qty" := BlanketOrderSalesLine."Qty To Deliver";
        SalesOrderLine."FOC Qty" := BlanketOrderSalesLine."FOC (Qty) To Deliver";
        SalesOrderLine."Selling Price" := BlanketOrderSalesLine."Selling Price";
        SalesOrderLine."Qty To Deliver" := SalesOrderLine."Order Qty";
        SalesOrderLine."FOC (Qty) To Deliver" := SalesOrderLine."FOC Qty";
        SalesOrderLine.Validate(Quantity, TotalQty);
        SalesOrderLine.Validate("Unit Price", InclPrice);
        SalesOrderLine.Modify(true);
    end;
    // YF        18 Aug 2021


    //DX        18 Aug 2021


    procedure GetLastItemSoldQuantity(SLRec: Record "Sales Line"): Decimal;
    var
        ILERec: Record "Item Ledger Entry";
        PRRec: Record "Sales Shipment Line";
        HistRec: Record "Historical Item Sales"; // YF        19 Aug 2021
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type", "Document No.", "Document Line No.");   //DX        06 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type");        //DX        24 May 2023
        ILERec.SetRange("Item No.", SLRec."No.");
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
        ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Shipment");
        if ILERec.FindFirst() then begin
            //DX        17 Aug 2021
            PRRec.reset;
            PRRec.SetLoadFields("Document No.", "Line No.", "Order Qty");  //DX        06 May 2023
            PRRec.SetRange("Document No.", ILERec."Document No.");
            PRRec.SetRange("Line No.", ILERec."Document Line No.");
            if PRRec.FindFirst() then
                exit(PRRec."Order Qty");
            //DX        17 Aug 2021
        end
        // YF        19 Aug 2021
        else begin
            // get from historical ob data
            HistRec.reset;
            HistRec.SetLoadFields("Item No.", "Posting Date", "Source No.", "Entry Type", Description, Quantity);     //DX        06 May 2023
            HistRec.SetCurrentKey("Item No.", "Posting Date");
            HistRec.SetRange("Item No.", SLRec."No.");
            HistRec.SetAscending("Posting Date", false);
            HistRec.SetRange("Source No.", SLRec."Sell-to Customer No.");
            HistRec.SetRange("Entry Type", HistRec."Entry Type"::"Sales Shipment");
            HistRec.SetRange(Description, 'Normal');
            if HistRec.FindFirst() then
                exit(HistRec.Quantity);
        end;
        // YF        19 Aug 2021
    end;


    procedure GetLastItemSoldFOCQuantity(SLRec: Record "Sales Line"): Decimal;
    var
        ILERec: Record "Item Ledger Entry";
        PRRec: Record "Sales Shipment Line";
        HistRec: Record "Historical Item Sales"; // YF        19 Aug 2021
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type", "Document No.", "Document Line No.");   //DX        06 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type");        //DX        24 May 2023
        ILERec.SetRange("Item No.", SLRec."No.");
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
        ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Shipment");
        if ILERec.FindFirst() then begin
            //DX        17 Aug 2021
            PRRec.reset;
            PRRec.SetLoadFields("Document No.", "Line No.", "FOC Qty");    //DX        06 May 2023
            PRRec.SetRange("Document No.", ILERec."Document No.");
            PRRec.SetRange("Line No.", ILERec."Document Line No.");
            if PRRec.FindFirst() then
                exit(PRRec."FOC Qty");
            //DX        17 Aug 2021
        end
        // YF        19 Aug 2021
        else begin
            // get from historical ob data

            HistRec.reset;
            HistRec.SetLoadFields("Item No.", "Posting Date", "Source No.", "Entry Type", Description, Quantity);     //DX        06 May 2023
            HistRec.SetCurrentKey("Item No.", "Posting Date", "Source No.", "Entry Type");        //DX        24 May 2023
            HistRec.SetRange("Item No.", SLRec."No.");
            HistRec.SetAscending("Posting Date", false);
            HistRec.SetRange("Source No.", SLRec."Sell-to Customer No.");
            HistRec.SetRange("Entry Type", HistRec."Entry Type"::"Sales Shipment");
            HistRec.SetRange(Description, 'Bonus');
            if HistRec.FindFirst() then
                exit(HistRec.Quantity);
        end;
        // YF        19 Aug 2021
    end;

    //DX        08 Aug 2021
    procedure GetLastSoldPriceBeforeFOC(SLRec: Record "Sales Line"): Decimal
    var
        ILERec: Record "Item Ledger Entry";
        PRLRec: Record "Sales Shipment Line";
        HistRec: Record "Historical Item Sales"; // YF        19 Aug 2021
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type", "Document No.", "Document Line No.");   //DX        06 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type");        //DX        24 May 2023
        ILERec.SetRange("Item No.", SLRec."No.");
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
        ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Shipment");
        if ILERec.FindFirst() then begin
            PRLRec.reset;
            PRLRec.SetLoadFields("Document No.", "Line No.", "Selling Price");     //DX        06 May 2023
            PRLRec.SetCurrentKey("Document No.", "Line No.");        //DX        29 May 2023
            PRLRec.SetRange("Document No.", ILERec."Document No.");
            PRLRec.SetRange("Line No.", ILERec."Document Line No.");
            if PRLRec.FindFirst() then begin
                exit(PRLRec."Selling Price");
            end;
        end
        // YF        19 Aug 2021
        else begin
            // get from historical ob data
            HistRec.reset;
            HistRec.SetLoadFields("Item No.", "Posting Date", "Source No.", "Entry Type", Description, "Sales Amount", Quantity);  //DX        06 May 2023
            HistRec.SetCurrentKey("Item No.", "Posting Date", "Source No.", "Entry Type");       //DX        24 May 2023
            HistRec.SetRange("Item No.", SLRec."No.");
            HistRec.SetAscending("Posting Date", false);
            HistRec.SetRange("Source No.", SLRec."Sell-to Customer No.");
            HistRec.SetRange("Entry Type", HistRec."Entry Type"::"Sales Shipment");
            HistRec.SetRange(Description, 'Normal');
            if HistRec.FindFirst() then begin
                if (histrec."Sales Amount" <> 0) and (HistRec.Quantity <> 0) then
                    exit(HistRec."Sales Amount" / HistRec.Quantity);
            end

        end;
        // YF        19 Aug 2021

    end;
    //DX        08 Aug 2021
    procedure GetLastSoldDate(SLRec: Record "Sales Line"): Date;
    var
        PRRec: Record "Sales Shipment Line";
        ILERec: Record "Item Ledger Entry";
        HistRec: Record "Historical Item Sales"; // YF        19 Aug 2021
    begin
        ILERec.reset;
        ILERec.SetLoadFields("Item No.", "Posting Date", "Source Type", "Source No.", "Document Type");  //DX        06 May 2023
        ILERec.SetCurrentKey("Item No.", "Posting Date");
        ILERec.SetRange("Item No.", SLRec."No.");
        ILERec.SetAscending("Posting Date", false);
        ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
        ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Shipment");
        if ILERec.FindFirst() then
            exit(ILERec."Posting Date")
        // YF        19 Aug 2021
        else begin
            // get from historical ob data
            HistRec.reset;
            HistRec.SetLoadFields("Item No.", "Posting Date", "Source No.", "Entry Type");  //DX        06 May 2023
            HistRec.SetCurrentKey("Item No.", "Posting Date");
            HistRec.SetRange("Item No.", SLRec."No.");
            HistRec.SetAscending("Posting Date", false);
            HistRec.SetRange("Source No.", SLRec."Sell-to Customer No.");
            HistRec.SetRange("Entry Type", HistRec."Entry Type"::"Sales Shipment");
            if HistRec.FindFirst() then
                exit(HistRec."Posting Date");
        end;
        // YF        19 Aug 2021

    end;
    //DX        18 Aug 2021
    //DX        22 Aug 2021


    procedure ItemIsInVendorTradeAgreement(ItemCode: Code[20]; VendorCode: Code[20])

    var
        myInt: Integer;
        PTradeAgree: Record "Pharma Purchase Price";
    begin
        PTradeAgree.reset;
        PTradeAgree.SetRange("Item No.", ItemCode);
        PTradeAgree.SetRange("Vendor No.", VendorCode);
        if NOT (PTradeAgree.FindFirst()) then begin
            if GuiAllowed then
                Error('Item is not in purchase trade agreement with vendor, please check again.');
        end;

    end;
    //DX        22 Aug 2021

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', false, false)]
    local procedure OnAfterPostSalesLine(var SalesLine: Record "Sales Line")
    var
        SHRec: Record "Sales Header";
        PMPCU: Codeunit "Trade Agreement CU";
        OrgLineAmt: Decimal;
        InclFOCUnitPrice: Decimal;
    begin

        //DX        If partial invoice to take selling price
        //SHRec.reset;
        //SHRec.SetRange("Document Type", SalesLine."Document type");
        //SHRec.SetRange("No.", SalesLine."Document No.");
        //if SHRec.FindFirst() then begin
        //SHRec.Status := SHRec.Status::Open;
        //SHRec.MODIFY(FALSE);]

        //end;
        //SHRec.Status := SHRec.Status::Released;
        //SHRec.MODIFY(false);

        /*
        OrgLineAmt := abs(SalesLine."Order Qty") * SalesLine."Selling Price";
        InclFOCUnitPrice := OrgLineAmt / (ABS(SalesLine."Order Qty") + abs(SalesLine."FOC Qty"));
        SalesLine."Unit Price" := InclFOCUnitPrice;
        SalesLine."Line Amount" := OrgLineAmt;
        SalesLine.MODIFY(false);
        */

    end;
    //DX        26 Aug 2021

    procedure CheckMixofCDandNonCD(var SLRec: Record "Sales Line")
    var
        myInt: Integer;
        lslRec: Record "Sales Line";
        CurrCDType: Boolean;
        ForensicGrp: Record "Forensic Group";
        ItemRec: Record item;
    begin
        if (SLRec.Type = SLRec.Type::Item) and (SLRec."No." <> '') then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", SLRec."No.");
            if ItemRec.FindFirst() then begin
                ForensicGrp.reset;
                ForensicGrp.SetRange("Forensic Group", ItemRec."Forensic Group");
                if ForensicGrp.FindFirst() then begin
                    CurrCDType := ForensicGrp."Controlled Drug";
                end;
            end;
        end;

        lslRec.reset;
        lslRec.SetRange("Document Type", SLRec."Document Type");
        lslRec.SetRange("Document No.", SLRec."Document No.");
        lslRec.SetRange(Type, lslRec.Type::Item);
        lslRec.SetFilter("No.", '<>%1', '');
        if lslRec.FindSet() then
            repeat
                if (lslRec.Type = lslRec.Type::Item) and (lslRec."No." <> '') then begin
                    ItemRec.reset;
                    ItemRec.SetRange("No.", lslRec."No.");
                    if ItemRec.FindFirst() then begin
                        ForensicGrp.reset;
                        ForensicGrp.SetRange("Forensic Group", ItemRec."Forensic Group");
                        if ForensicGrp.FindFirst() then begin
                            if CurrCDType <> ForensicGrp."Controlled Drug" then
                                if GuiAllowed then
                                    Error('No mixture of Controlled Drug and Non Controlled Drug order allowed.');
                        end;
                    end;
                end;
            until lslRec.next = 0;
    end;

    // YF 24 Mar 2025
    procedure CheckMixofSTBioandNonSTBio(var SLRec: Record "Sales Line")
    var
        lslRec: Record "Sales Line";
        CurrCDType: Boolean;
        ForensicGrp: Record "Forensic Group";
        ItemRec: Record item;
    begin
        if (SLRec.Type = SLRec.Type::Item) and (SLRec."No." <> '') then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", SLRec."No.");
            if ItemRec.FindFirst() then begin
                ForensicGrp.reset;
                ForensicGrp.SetRange("Forensic Group", ItemRec."Forensic Group");
                if ForensicGrp.FindFirst() then begin
                    CurrCDType := ForensicGrp.I9G_STBio;
                end;
            end;
        end;

        lslRec.reset;
        lslRec.SetRange("Document Type", SLRec."Document Type");
        lslRec.SetRange("Document No.", SLRec."Document No.");
        lslRec.SetRange(Type, lslRec.Type::Item);
        lslRec.SetFilter("No.", '<>%1', '');
        if lslRec.FindSet() then
            repeat
                if (lslRec.Type = lslRec.Type::Item) and (lslRec."No." <> '') then begin
                    ItemRec.reset;
                    ItemRec.SetRange("No.", lslRec."No.");
                    if ItemRec.FindFirst() then begin
                        ForensicGrp.reset;
                        ForensicGrp.SetRange("Forensic Group", ItemRec."Forensic Group");
                        if ForensicGrp.FindFirst() then begin
                            if CurrCDType <> ForensicGrp.I9G_STBio then
                                if GuiAllowed then
                                    Error('No mixture of ST Bio and Non ST Bio order allowed.');
                        end;
                    end;
                end;
            until lslRec.next = 0;
    end;
    // YF 24 Mar 2025

    procedure AutoupdateSTO(var SLRec: Record "Sales Line")
    var
        myInt: Integer;
        ItemRec: Record Item;
    begin
        if (SLRec.Type = SLRec.Type::Item) and (SLRec."No." <> '') then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", SLRec."No.");
            ItemRec.SetRange("Item Status", 'SPECIAL-TO-ORDER');
            if ItemRec.FindFirst() then begin
                SLRec.Validate("Purchasing Code", 'STO');
                SLRec.Modify(TRUE);
            end else begin
                SLRec.Validate("Purchasing Code", '');
                SLRec.Modify(TRUE);

            end;
        end;
    end;

    procedure GetUserGUID(): Guid
    var
        myInt: Integer;
        UserID: Guid;
        UserRec: Record User;
    begin
        UserRec.reset;
        UserRec.SetRange("User Name", UserID);
        if UserRec.FindFirst() then
            exit(UserRec."User Security ID");
    end;

    procedure GetBCAdminGUID(): Guid
    var
        myInt: Integer;
        UserID: Guid;
        UserRec: Record User;
    begin
        UserRec.reset;
        UserRec.SetRange("User Name", 'BCADMIN');
        if UserRec.FindFirst() then
            exit(UserRec."User Security ID");
    end;

    //RL    30 Mar 2022 - Start
    procedure GetBCIntegrationVendorGUID(): Guid
    var
        myInt: Integer;
        UserID: Guid;
        UserRec: Record User;
    begin
        UserRec.reset;
        UserRec.SetLoadFields("User Security ID");
        UserRec.SetRange("User Name", 'BC INTEGRATION FOR VENDOR');
        if UserRec.FindFirst() then
            exit(UserRec."User Security ID");
    end;
    //RL    30 Mar 2022 - End

    procedure GetUsername(GUserID: Guid): Text
    var
        myInt: Integer;
        UserID: Guid;
        UserRec: Record User;
    begin
        UserRec.reset;
        UserRec.SetLoadFields("User Name");
        UserRec.SetRange(UserRec."User Security ID", GUserID);
        if UserRec.FindFirst() then
            exit(UserRec."User Name");
    end;


    //DX        31 Aug 2021     Auto release warehouse picking list after release

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        SSSetup: record "Sales & Receivables Setup";
        compRec: Record "Company Information";
    begin
    end;
    /*
        //DX        31 Aug 2021
        //DX        26 Aug 2021
        procedure MoreThan100(SHRec: Record "Sales Header"): Boolean
        var
            myInt: Integer;
        begin
            SHRec.CalcFields(Amount);
            if SHRec.Amount >= 100 then
                exit(true)
            else begin
                if GotMultipleSOMoreThan100(SHRec) then
                    exit(true)
                else
                    exit(false);
            end;
        end;

        local procedure GotMultipleSOMoreThan100(SHRec: Record "Sales Header"): Boolean
        var
            myInt: Integer;
            LSHRec: Record "Sales Header";
            TotalAmt: Decimal;
        begin
            TotalAmt := 0;
            LSHRec.reset;
            LSHRec.SetRange("Document Type", LSHRec."Document Type"::Order);
            LSHRec.SetFilter("Ship-to Address", '%1', SHRec."Ship-to Address");
            LSHRec.SetFilter("Ship-to Address 2", '%1', SHRec."Ship-to Address 2");
            if LSHRec.FindSet() then
                repeat
                    LSHRec.CalcFields(Amount);
                    TotalAmt += LSHRec.Amount;
                until LSHRec.next = 0;
            if TotalAmt >= 100 then
                exit(true)
            else
                exit(false);
        end;
        //DX        02 Sept 2021
        //DX        31 Aug 2021     Auto release warehouse picking list after release
        [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', false, false)]
        local procedure OnAfterPurchInvLineInsert(PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer)
        var
            GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
            SSSetup: record "Sales & Receivables Setup";
            ILERec: Record "Item Ledger Entry";
        begin
            if PurchLine.Exchangeable = true then begin
                ILERec.reset;
                ILERec.SetRange("Entry No.", ItemLedgShptEntryNo);
                if ILERec.FindFirst() then begin
                    ILERec.Exchangeable := true;
                    ILERec.Modify(FALSE);
                end;

            end;

        end;
        //DX        31 Aug 2021
    */

    //DX        07 Sept 2021            Had to remove first, causing problems when posting.

    // YF 06 Sept 2021 // Issue #170

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforePostSalesLineEndLoop', '', false, false)]
    local procedure OnRunOnBeforePostSalesLineEndLoop(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var LastLineRetrieved: Boolean; SalesInvHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; RecSalesHeader: Record "Sales Header"; xSalesLine: Record "Sales Line")
    var
        OrgLineAmt: Decimal;
        InclFOCUnitPrice: Decimal;
    begin
        OrgLineAmt := abs(SalesLine."Order Qty") * SalesLine."Selling Price";
        InclFOCUnitPrice := OrgLineAmt / (ABS(SalesLine."Order Qty") + abs(SalesLine."FOC Qty"));
        SalesLine."Unit Price" := InclFOCUnitPrice;
        SalesLine."Line Amount" := OrgLineAmt;
        SalesLine.MODIFY(false);
    end;
    */

    //DX        26 Aug 2021 
    /* YF 28 Dec 2021 
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnPostSalesLineOnAfterTestSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnAfterTestSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        SHRec: Record "Sales Header";
        currency: Record Currency;
        glsetup: Record "General Ledger Setup";
        DelFOCQty: Decimal;
        DelQty: Decimal;
        RunningBal: Decimal;
    begin

        //DX        If partial invoice to take selling price
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
        (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then begin
            if (SalesLine."Qty To Deliver" = 0) and (SalesLine."FOC (Qty) To Deliver" <> 0) then begin        //Means totally send only FOC Qty
                                                                                                              //      DX      Need to check if got alternative to still use validate for line when satatus is released.   
                                                                                                              //SalesHeader.Status := SalesHeader.Status::Open;
                                                                                                              //SalesHeader.Modify(FALSE);
                                                                                                              //Commit();
                                                                                                              //SalesLine.VALIDATE("Unit Price", 0);
                                                                                                              //SalesLine.MODIFY(TRUE);
                                                                                                              
                SalesLine."Unit Price" := 0;
                SalesLine."Line Amount" := 0;
                SalesLine.Modify(FALSE);
            end else begin
                
                //SalesHeader.Status := SalesHeader.Status::Open;
                //SalesHeader.Modify(FALSE);
                //Commit();
                //SalesLine.VALIDATE("Unit Price", SalesLine."Selling Price");
                //SalesLine.MODIFY(TRUE);
                
                //2 FOC 1 $4  each              $8 line amount unit price = 8/3

                //DX        12 Sept 2021        To cater for partial registering at the pick list after SO has been shipped.
                DelQty := SalesLine."Qty To Deliver";           //Del 5
                DelFOCQty := SalesLine."FOC (Qty) To Deliver";      //FOC 2
                                                                    //Message(format(SalesLine."Qty. To Ship"));
                if abs(SalesLine."Qty. to Ship") < DelQty + DelFOCQty then begin        //To check for any partial picking, if pick more than cs req qty
                    if DelQty + DelFOCQty > abs(SalesLine."Qty. to Ship") then begin //If del = 5 + 2 , qty picked = 4
                                                                                     //  Message('in here');                                       //If picked qty is lesser than required deliver qty, then assign all to invoice straight.
                        if DelQty >= ABS(SalesLine."Qty. to Ship") then begin        //del = 5+2        qty shipped = 4
                            SalesLine."Qty To Deliver" := ABS(SalesLine."Qty. to Ship");
                            SalesLine."FOC (Qty) To Deliver" := 0;
                            SalesLine.Modify(false);
                            // Message('test');
                        end else
                            //if picked qty > req del qty
                            if DelQty < ABS(SalesLine."Qty. to Ship") then begin
                                SalesLine."FOC (Qty) To Deliver" := abs(SalesLine."Qty. to Ship") - DelQty;
                                SalesLine.Modify(false);
                                //  Message('test2');
                            end;
                    end;
                end;
                //Message(format(SalesLine."Qty To Deliver"));
                // Commit();

                //DX        12 Sept 2021
                if (SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver") <> 0 then // Quicky YF Fix 17 Sept 2021
                    SalesLine."Unit Price" := (SalesLine."Qty To Deliver" * SalesLine."Selling Price") / (SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver");
                SalesLine."To Del. Amt" := SalesLine."Qty To Deliver" * SalesLine."Selling Price";
                SalesLine."Line Amount" := SalesLine."Qty To Deliver" * SalesLine."Selling Price";
                currency.reset;
                currency.SetRange(Code, SalesLine."Currency Code");
                if currency.FindFirst() then begin
                    if ROUND(SalesLine.Quantity * SalesLine."Unit Price", Currency."Amount Rounding Precision") * SalesLine."Line Discount %" <> 0 then
                        SalesLine."Line Discount Amount" := ROUND(ROUND(SalesLine.Quantity * SalesLine."Unit Price", Currency."Amount Rounding Precision") *
                        SalesLine."Line Discount %" / 100, Currency."Amount Rounding Precision");
                end else begin
                    glsetup.reset;
                    glsetup.get;
                    if ROUND(SalesLine.Quantity * SalesLine."Unit Price", glsetup."Amount Rounding Precision") * SalesLine."Line Discount %" <> 0 then
                        SalesLine."Line Discount Amount" := ROUND(ROUND(SalesLine.Quantity * SalesLine."Unit Price", glsetup."Amount Rounding Precision") *
                        SalesLine."Line Discount %" / 100, glsetup."Amount Rounding Precision");
                end;

                SalesLine.Modify(FALSE);
            end;
        end;

    end;
    // YF 28 Dec 2021
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostUpdateOrderLineOnBeforeInitOutstanding', '', false, false)]
    local procedure OnPostUpdateOrderLineOnBeforeInitOutstanding(var SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary)
    var
        SSSetup: Record "Sales & Receivables Setup";
        OrgLineAmt: Decimal;
        InclFOCUnitPrice: Decimal;
    begin
        SSSetup.Get;

        if SSSetup."SO Line Qty Quick Fix" then begin
            // override qty to ship and invoice and shipped and invoiced // reverse sign
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                TempSalesLine."Qty. to Ship" := Abs(TempSalesLine."Qty. to Ship");
                TempSalesLine."Qty. to Invoice" := Abs(TempSalesLine."Qty. to Invoice");
                TempSalesLine."Quantity Shipped" := Abs(TempSalesLine."Quantity Shipped");
                TempSalesLine."Quantity Invoiced" := Abs(TempSalesLine."Quantity Invoiced");

                TempSalesLine."Qty. to Ship (Base)" := Abs(TempSalesLine."Qty. to Ship (Base)");
                TempSalesLine."Qty. to Invoice (Base)" := Abs(TempSalesLine."Qty. to Invoice (Base)");
                TempSalesLine."Qty. Shipped (Base)" := Abs(TempSalesLine."Qty. Shipped (Base)");
                TempSalesLine."Qty. Invoiced (Base)" := Abs(TempSalesLine."Qty. Invoiced (Base)");

                // Resolve issue with negative incorrect totals and unit price
                OrgLineAmt := abs(TempSalesLine."Order Qty") * TempSalesLine."Selling Price";
                if (ABS(TempSalesLine."Order Qty") + abs(TempSalesLine."FOC Qty")) <> 0 then // Quicky YF Fix 17 Sept 2021
                    InclFOCUnitPrice := OrgLineAmt / (ABS(TempSalesLine."Order Qty") + abs(TempSalesLine."FOC Qty"));
                TempSalesLine."Unit Price" := InclFOCUnitPrice;
                TempSalesLine."Line Amount" := OrgLineAmt;
            end;

        end;
    end;
    // YF 06 Sept 2021 // Issue #170


    //DX        06 Sept 2021
    procedure AllLinesHaveBeenReserved(SHRec: Record "Sales Header"): Boolean
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        ResEntry: Record "Reservation Entry";
    begin
        SLRec.reset;
        SLRec.SetCurrentKey("Document Type", "Document No.", "No.", Quantity, Type);
        SLRec.SetLoadFields("Document Type", "Document No.", "No.", Quantity, Type, "Location Code");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetFilter("No.", '<>%1', '');
        SLRec.SetFilter(Quantity, '<>0');
        SLRec.SetRange(Type, SLRec.Type::Item);
        if SLRec.FindSet() then
            repeat
                ResEntry.RESET;
                ResEntry.SETRANGE("Item No.", slRec."No.");
                ResEntry.SETRANGE("Location Code", SLRec."Location Code");
                ResEntry.SETRANGE("Source ID", SLRec."Document No.");
                ResEntry.SETRANGE("Source Type", 37);
                ResEntry.SETRANGE("Source Subtype", 1);
                ResEntry.SETRANGE("Source Ref. No.", SLRec."Line No.");
                ResEntry.SETRANGE("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                if ResEntry.IsEmpty then
                    exit(false);
            until SLRec.next = 0;
        exit(true);
    end;
    //DX        06 Sept 2021


    //DX      13 Sept 2021
    procedure UpdateInvoiceToDelivery(DocNo: Code[20])
    var
        myInt: Integer;
        SHRec: Record "Sales Invoice Header";
    begin
        SHRec.reset;
        SHRec.SetRange("No.", DocNo);
        if SHRec.FindFirst() then begin
            SHRec."Order Status" := SHRec."Order Status"::"Delivery In Progress";
            SHRec.Modify(FALSE);
        end;
    end;
    //DX      13 Sept 2021

    //DX        20 Sept 2021

    procedure SHHasEnoughStock(SHRec: Record "Sales Header"): Boolean
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        IsEnough: Boolean;
    begin
        myInt := 0;
        IsEnough := true;
        SLRec.reset;
        SLRec.SetLoadFields("Document Type", "Document No.", "No.", Type, Quantity, "Location Code", "Unit of Measure Code", "FOC (Qty) To Deliver", "Qty To Deliver");   //DX        12 Jun 2023
        SLRec.SetCurrentKey("Document Type", "Document No.", Type, Quantity);       //DX        16 May 2023
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat
                //if GetNetAvailQty(SLRec) - SLRec."Quantity (Base)" >= 0 then
                //    myInt += 1;
                if GetNetAvailQty(SLRec) - GetUOMBase(SLRec) >= 0 then
                    myInt += 1;
            until SLRec.next = 0;
        if myInt = SLRec.count then
            exit(true)
        else
            exit(false);
    end;

    local procedure GetUOMBase(var SLRec: Record "Sales Line"): Decimal;        //DX        12 Jun 2023     Added Var to local parameter
    var
        myInt: Integer;
        ItemUom: Record "Item Unit of Measure";
    begin
        ItemUom.reset;
        ItemUom.SetLoadFields("Item No.", Code, "Qty. per Unit of Measure");     //DX        02 May 2023
        ItemUom.SetRange("Item No.", SLRec."No.");
        ItemUom.SetRange(Code, SLRec."Unit of Measure Code");
        if ItemUom."Qty. per Unit of Measure" <> 1 then begin
            exit((SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver") * ItemUom."Qty. per Unit of Measure");
        end else
            if ItemUom."Qty. per Unit of Measure" = 1 then
                exit(SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver")

    end;

    procedure GetNetAvailQty(var SLRec: Record "Sales Line"): Decimal
    var
        myInt: Integer;
        BinContent: Record "Bin Content";
        CompInfo: Record "Company Information";
        AvailQty: Decimal;
    begin
        CompInfo.reset;
        CompInfo.SetLoadFields("Location Code"); //DX        02 May 2023
        CompInfo.get;

        if (SLRec."Location Code" = CompInfo."Location Code") AND
        (SLRec.Type = SLRec.Type::Item) and
        (SLRec."No." <> '') then begin
            BinContent.reset;
            //DX        05 Dec 2023
            BinContent.SetLoadFields("Item No.", "Location Code", "Bin Type Code", "Quantity (Base)", "Pick Quantity (Base)", "Put-away Quantity (Base)", "ATO Components Pick Qty (Base)", "Positive Adjmt. Qty. (Base)", "Negative Adjmt. Qty. (Base)");
            //DX        05 Dec 2023
            BinContent.SetRange("Item No.", SLRec."No.");
            BinContent.SetRange("Location Code", SLRec."Location Code");
            //DX        01 Oct 2021
            //BinContent.SetRange("Zone Code", 'PICK');
            BinContent.setfilter("Bin Type Code", '%1|%2', 'PICK', 'PUTPICK');
            //DX        01 Oct 2021
            BinContent.SetAutoCalcFields("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)"); //DX        08 Jun 2023
            if BinContent.FindSet() then
                repeat
                    //DX        08 June 2023     refactor to improve performance
                    //BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
                    AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";
                until BinContent.next = 0;
            //BinContent.CalcSums("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
            exit(AvailQty);
        end;
    end;


    procedure ReleaseChainOrders()
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        TempCustRec: Record customer temporary;
        TempCustRec2: Record Customer temporary;
        Temp2CustRec: Record customer temporary;
        TotalCustAmt: Decimal;
        TempSHRec: Record "Sales Header" temporary;
        ReleaseSHRec: Record "Sales Header" temporary;
        FinalSHRec: Record "Sales Header" temporary;
        SLRec: Record "Sales Line";
        CustTotal: Record Customer temporary;
        Cust2Total: Record customer temporary;
        LessThan12: Boolean;
        diaBox: Dialog;
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        ProgressMsg: Label 'Progress: #1#####';
        StartProgressMsg: Text;
        releaseSalesDoc: Codeunit "Release Sales Document";
        CustList: page "Customer List";
        custFilter: Record customer;          // Filter by item transactions only
        CustSelect: record Customer;
    begin
        //DX                  20 Sept 2021
        //Fo          r chain, must have >$100 delivery first, group by sell to customer
        //Mu          st have > 1 year expiration of item, else cannot release.
        //To manual release if < 1 year
        if Confirm('Are you sure you wish to release chain pharmacy orders?') then begin
            custFilter.RESET;
            // Filter by item transactions only
            custFilter.SetRange("Chain Pharmacy", true);
            CustList.LOOKUPMODE := true;
            CustList.SetTableView(custFilter);
            CustList.CAPTION := 'Select a branch of chain customer';
            if CustList.RunModal() = Action::LookupOK then begin

                CustList.SetSelection(CustSelect);
                if CustSelect.Count <> 1 then
                    Error('Please select only 1 customer to release.');

                StartProgressMsg := 'Processing and checking.......';
                diaBox.Open(ProgressMsg, StartProgressMsg);
                SHRec.reset;
                SHRec.SetRange("TBA Order", false);
                SHRec.SetRange("Sell-to Customer No.", CustSelect."No.");
                SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                SHRec.SetRange("Logistics Service", false);
                SHRec.SetRange("Chain Pharmacy", true);
                SHRec.SetRange(Status, SHRec.Status::Open);
                SHRec.SetRange("Order Status", SHRec."Order Status"::Open);
                //DX		30 Sept 2021
                SHRec.SetFilter("External Document No.", '<>%1', '');
                //DX		30 Sept 2021
                if SHRec.FindSet() then     //Get unique sell to customer combinations first

                    repeat
                        /*
                            TempCustRec.reset;
                            TempCustRec.SetRange("No.", SHRec."Sell-to Customer No.");
                            if not (TempCustRec.FindFirst()) then begin
                                Temp2CustRec.reset;
                                Temp2CustRec."No." := SHRec."Sell-to Customer No.";
                                Temp2CustRec.Insert(false);
                                TempCustRec.Copy(Temp2CustRec);
                                TempCustRec.Insert(FALSE);
                            end;*/
                        SHRec.CalcFields(Amount);
                        TotalCustAmt += SHRec.Amount;
                    until SHRec.next = 0;

                if TotalCustAmt > 100 then begin
                    LessThan12 := false;
                    SHRec.reset;
                    SHRec.SetRange("TBA Order", false);
                    SHRec.SetRange("Sell-to Customer No.", TempCustRec2."No.");
                    SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                    SHRec.SetRange("Logistics Service", false);
                    SHRec.SetRange("Chain Pharmacy", true);
                    SHRec.SetRange(Status, SHRec.Status::Open);
                    SHRec.SetRange("Order Status", SHRec."Order Status"::Open);
                    //DX		30 Sept 2021
                    SHRec.SetFilter("External Document No.", '<>%1', '');
                    //DX		30 Sept 2021
                    if SHRec.FindSet() then
                        repeat
                            LessThan12 := false;
                            SLRec.reset;
                            SLRec.SetRange("Document No.", SHRec."No.");
                            SLRec.SetRange("Document Type", SHRec."Document Type");
                            SLRec.SetRange(Type, SLRec.Type::Item);
                            SLRec.SetFilter(Quantity, '<>0');
                            if SLRec.FindSet() then
                                repeat
                                    if ExpirationLessThan12MthsWithLocForChain(SLRec."No.", SLRec."Location Code") then begin
                                        LessThan12 := true;
                                    end;
                                until SLRec.next = 0;
                            if LessThan12 = false then begin        //If whole sales order don't have any less than 1 year expiration, then add to list of correct orders.
                                Clear(ReleaseSHRec);
                                ReleaseSHRec."No." := SHRec."No.";
                                ReleaseSHRec."Sell-to Customer No." := SHRec."Sell-to Customer No.";
                                ReleaseSHRec.Insert(false);
                            end;
                        until SHRec.Next() = 0;
                end;

                if ReleaseSHRec.Count <> 0 then begin
                    if ReleaseSHRec.FindSet() then
                        repeat
                            diaBox.Update(1, 'Releasing to warehouse........');
                            SLRec.reset;
                            SLRec.SetRange("Document Type", ReleaseSHRec."Document Type");
                            SLRec.SetRange("Document No.", ReleaseSHRec."No.");
                            SLRec.SetRange(Type, SLRec.Type::Item);
                            SLRec.SetFilter(Quantity, '<>0');
                            if SLRec.Count <> 0 then begin
                                SHRec.reset;
                                SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                                SHRec.SetRange("No.", ReleaseSHRec."No.");
                                if SHRec.FindFirst() then begin
                                    releaseSalesDoc.PerformManualRelease(SHRec);
                                    GetSourceDocOutbound.CreateFromSalesOrder(SHRec);
                                end;
                            end;
                        until ReleaseSHRec.next = 0;
                    diaBox.Close();
                end;
            end;


        end;
    end;
    //DX        20 Sept 2021

    // YF        21 Sept 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure OnBeforeInsertSalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; var BlanketOrderSalesHeader: Record "Sales Header")
    begin
        SalesOrderHeader."Customer Instructions" := BlanketOrderSalesHeader."Customer Instructions";
        SalesOrderHeader."Picking Instructions" := BlanketOrderSalesHeader."Picking Instructions";
        SalesOrderHeader."Delivery Instructions" := BlanketOrderSalesHeader."Delivery Instructions";
        SalesOrderHeader."Delivery Charge" := BlanketOrderSalesHeader."Delivery Charge";
        SalesOrderHeader."Delivery Zone" := BlanketOrderSalesHeader."Delivery Zone";
        SalesOrderHeader."Priority Picking" := BlanketOrderSalesHeader."Priority Picking";
        SalesOrderHeader."Chain Pharmacy" := BlanketOrderSalesHeader."Chain Pharmacy";
        SalesOrderHeader."Sales Area" := BlanketOrderSalesHeader."Sales Area";
        SalesOrderHeader."Logistics Service" := BlanketOrderSalesHeader."Logistics Service";
        SalesOrderHeader."Branch/Subsidiary" := BlanketOrderSalesHeader."Branch/Subsidiary";
        SalesOrderHeader."WS Membership" := BlanketOrderSalesHeader."WS Membership";
        SalesOrderHeader.I9G_ContractRef := BlanketOrderSalesHeader.I9G_ContractRef;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeSalesOrderHeaderModify', '', false, false)]
    local procedure OnBeforeSalesOrderHeaderModify(var SalesOrderHeader: Record "Sales Header"; BlanketOrderSalesHeader: Record "Sales Header")
    begin
        SalesOrderHeader."Customer Instructions" := BlanketOrderSalesHeader."Customer Instructions";
        SalesOrderHeader."Picking Instructions" := BlanketOrderSalesHeader."Picking Instructions";
        SalesOrderHeader."Delivery Instructions" := BlanketOrderSalesHeader."Delivery Instructions";
        SalesOrderHeader."Delivery Charge" := BlanketOrderSalesHeader."Delivery Charge";
        SalesOrderHeader."Delivery Zone" := BlanketOrderSalesHeader."Delivery Zone";
        SalesOrderHeader."Priority Picking" := BlanketOrderSalesHeader."Priority Picking";
        SalesOrderHeader."Chain Pharmacy" := BlanketOrderSalesHeader."Chain Pharmacy";
        SalesOrderHeader."Sales Area" := BlanketOrderSalesHeader."Sales Area";
        SalesOrderHeader."Logistics Service" := BlanketOrderSalesHeader."Logistics Service";
        SalesOrderHeader."Branch/Subsidiary" := BlanketOrderSalesHeader."Branch/Subsidiary";
        SalesOrderHeader."WS Membership" := BlanketOrderSalesHeader."WS Membership";
        SalesOrderHeader.I9G_ContractRef := BlanketOrderSalesHeader.I9G_ContractRef;
    end;
    // YF        21 Sept 2021

    //DX        21 Sept 2021
    procedure IsCSLead(): Boolean;
    var
        SSSetup: Record "Sales & Receivables Setup";
        // UserGrpMemberRec: Record "User Group Member"; // YF 2024-10-11 // BC 25 Upgrade
        AccessControlRec: Record "Access Control"; // YF 2024-10-11 // BC 25 Upgrade
    begin
        SSSetup.reset;
        SSSetup.get;
        //SSSetup.TestField("Def. LS User Group");

        if SSSetup."Def. CS Lead Role" <> '' then begin
            // YF 2024-10-11 // BC 25 Upgrade
            AccessControlRec.reset;
            AccessControlRec.SetLoadFields("User Name", "Role ID");
            AccessControlRec.SetRange("User Name", UserId);
            AccessControlRec.SetFilter("Role ID", '%1|%2|%3', SSSetup."Def. CS Lead Role", SSSetup."Def. LS User Group", 'PMP-WELLAWAY');
            if not (AccessControlRec.IsEmpty()) then
                exit(true)
            else
                exit(false);
            /*
            UserPerm.reset;
            UserPerm.SetRange("User Name", UserId);
            //UserPerm.SetRange("User Group Code", SSSetup."Def. CS Lead Role");
            //DX        15 Oct 2021     allow wellaway users to modify unit price.
            UserPerm.SetFilter("User Group Code", '%1|%2|%3', SSSetup."Def. CS Lead Role", SSSetup."Def. LS User Group", 'PMP-WELLAWAY');
            //DX        15 Oct 2021
            if UserPerm.FindFirst() then
                exit(true)
            else
                exit(false);
            */
            // YF 2024-10-11 // BC 25 Upgrade
        end else
            exit(FALSE);
    end;
    //DX        21 Sept 2021

    //DX        24 Sept 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnRecalculateSalesLineOnAfterValidateQuantity', '', false, false)]
    local procedure OnRecalculateSalesLineOnAfterValidateQuantity(FromSalesLine: Record "Sales Line"; var ToSalesLine: Record "Sales Line")
    var
        TradeCU: Codeunit "Trade Agreement CU";
    begin

        //    if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
        //TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(Rec);
        ToSalesLine."Order Qty" := FromSalesLine."Order Qty";
        ToSalesLine."FOC Qty" := FromSalesLine."FOC Qty";
        ToSalesLine."Selling Price" := FromSalesLine."Selling Price";
        ToSalesLine."FOC (Qty) To Deliver" := FromSalesLine."FOC (Qty) To Deliver";
        ToSalesLine."Qty To Deliver" := FromSalesLine."Qty To Deliver";
        ToSalesLine.Validate(Quantity, FromSalesLine.Quantity);
        ToSalesLine.Validate("Unit Price", FromSalesLine."Unit Price");
        //ToSalesLine.Modify(TRUE);
        //if TradeCU.IsValidSalesAgreement_PMPCustomized(ToSalesLine) then begin
        //    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(ToSalesLine);

    end;

    [EventSubscriber(ObjectType::Table, DAtabase::"Sales Header", 'OnCreateSalesLineOnBeforeValidateQuantity', '', false, false)]
    local procedure OnCreateSalesLineOnBeforeValidateQuantity(SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line")
    var
        TradeCU: Codeunit "Trade Agreement CU";
    begin
        TempSalesLine.Quantity := 0;
        //TempSalesLine.Modify(false);
        //if TradeCU.IsValidSalesAgreement_PMPCustomized(TempSalesLine) then begin
        //    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(TempSalesLine);

    end;

    procedure ReqWorkSheetCombination(ReqWkSht: Record "Requisition Line")
    var
        lReqWksheet: Record "Requisition Line";
        lReqwksheet2: Record "Requisition Line";
        tReqwkSheet: Record "Requisition Line" temporary;
        tReqwkSheet2: Record "Requisition Line" temporary;
        PriceListLineRec: Record "Pharma Purchase Price";
        LowestMinQty: Decimal;
        LowestUnitCostPrice: Decimal;
        LowestFOCQty: Decimal;
        LowestUnitCostPerQty: Decimal;
        CurrentUnitCostPerQty: Decimal;
        RevisedFOCQty: Decimal;
        PurchasePrice: Decimal;
        TradeAgreementCU: Codeunit "Trade Agreement CU";
    begin
        lReqWksheet.Reset;
        lReqWksheet.SetRange("Worksheet Template Name", ReqWkSht."Worksheet Template Name");
        lReqWksheet.SetRange("Journal Batch Name", ReqWkSht."Journal Batch Name");
        lReqWksheet.SetRange(Type, lReqWksheet.Type::Item);
        lReqWksheet.SetRange("Action Message", lReqWksheet."Action Message"::New);
        lReqWksheet.SetFilter("Quantity (Base)", '<>0');
        if lReqWksheet.FindSet() then
            repeat
                lReqwksheet2.reset;
                lReqWksheet2.SetRange("Worksheet Template Name", ReqWkSht."Worksheet Template Name");
                lReqWksheet2.SetRange("Journal Batch Name", ReqWkSht."Journal Batch Name");
                lReqWksheet2.SetRange("Action Message", lReqWksheet."Action Message"::New);
                lReqWksheet2.SetFilter("Quantity (Base)", '<>0');
                lReqWksheet2.SetRange(Type, lReqWksheet.Type::Item);
                lReqwksheet2.SetRange("No.", lReqWksheet."No.");
                lReqwksheet2.SetFilter("Line No.", '<>%1', lReqWksheet."Line No.");
                if lReqwksheet2.FindSet() then
                    repeat
                        lReqWksheet.Validate(Quantity, lReqWksheet.Quantity + lReqwksheet2.Quantity);
                        lReqWksheet.Modify(TRUE);
                        lReqwksheet2.Delete(TRUE);
                    until lReqwksheet2.next = 0;

                // Find Lowest Price
                LowestMinQty := 0;
                LowestUnitCostPrice := 0;
                LowestFOCQty := 0;
                LowestUnitCostPerQty := 0;
                CurrentUnitCostPerQty := 0;

                PriceListLineRec.Reset;
                PriceListLineRec.SetRange("Vendor No.", lReqWksheet."Vendor No.");
                PriceListLineRec.SetRange("Item No.", lReqWksheet."No.");
                PriceListLineRec.SetRange("Unit of Measure Code", lReqWksheet."Unit of Measure Code");
                PriceListLineRec.SetRange(Status, PriceListLineRec.Status::Active);

                PriceListLineRec.SetFilter("Starting Date", '<=%1', WorkDate());
                PriceListLineRec.SetFilter("Ending Date", '>=%1', WorkDate());

                PriceListLineRec.SetFilter("Direct Unit Cost", '>%1', 0); // YF 14 Jan 2022

                if PriceListLineRec.FindSet() then
                    repeat
                        // YF 14 Jan 2022
                        if PriceListLineRec."Minimum Quantity" = 0 then
                            CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (1 + PriceListLineRec."FOC Qty")
                        else
                            CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty");

                        if CurrentUnitCostPerQty < LowestUnitCostPerQty then begin
                            LowestUnitCostPerQty := CurrentUnitCostPerQty;
                            LowestMinQty := PriceListLineRec."Minimum Quantity";
                            LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                            LowestFOCQty := PriceListLineRec."FOC Qty";
                        end;

                        if CurrentUnitCostPerQty = LowestUnitCostPerQty then begin
                            if PriceListLineRec."Minimum Quantity" > LowestMinQty then begin
                                LowestUnitCostPerQty := CurrentUnitCostPerQty;
                                LowestMinQty := PriceListLineRec."Minimum Quantity";
                                LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                                LowestFOCQty := PriceListLineRec."FOC Qty";
                            end;
                        end;

                        if LowestUnitCostPerQty = 0 then begin
                            LowestUnitCostPerQty := CurrentUnitCostPerQty;
                            LowestMinQty := PriceListLineRec."Minimum Quantity";
                            LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                            LowestFOCQty := PriceListLineRec."FOC Qty";
                        end;

                    /*
                        if PriceListLineRec."Direct Unit Cost" > 0 then begin

                            CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty");

                            if CurrentUnitCostPerQty < LowestUnitCostPerQty then begin
                                LowestUnitCostPerQty := CurrentUnitCostPerQty;
                                LowestMinQty := PriceListLineRec."Minimum Quantity";
                                LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                                LowestFOCQty := PriceListLineRec."FOC Qty";
                            end;

                            if CurrentUnitCostPerQty = LowestUnitCostPerQty then begin
                                if PriceListLineRec."Minimum Quantity" > LowestMinQty then begin
                                    LowestUnitCostPerQty := CurrentUnitCostPerQty;
                                    LowestMinQty := PriceListLineRec."Minimum Quantity";
                                    LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                                    LowestFOCQty := PriceListLineRec."FOC Qty";
                                end;
                            end;

                            if LowestUnitCostPerQty = 0 then begin
                                LowestUnitCostPerQty := CurrentUnitCostPerQty;
                                LowestMinQty := PriceListLineRec."Minimum Quantity";
                                LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                                LowestFOCQty := PriceListLineRec."FOC Qty";
                            end;

                        end;
                    */
                    // YF 14 Jan 2022
                    until PriceListLineRec.Next() = 0;

                CalculatePurchPriceFOCQty_PMPCustomized(lReqWksheet."Vendor No.", WorkDate(), lReqWksheet."No.", lReqWksheet."Unit of Measure Code", lReqWksheet.Quantity, PurchasePrice, RevisedFOCQty);

                lReqWksheet."Min Qty" := LowestMinQty;
                lReqWksheet."Unit Cost Price" := LowestUnitCostPrice;
                lReqWksheet."FOC Qty" := LowestFOCQty;
                lReqWksheet."Direct Unit Cost" := PurchasePrice;
                lReqWksheet."Revised FOC Qty" := RevisedFOCQty;
                lReqWksheet.Modify();

            until lReqWksheet.next = 0;

        Message('Requisition lines combined.');

    end;
    //DX        24 Sept 2021

    // YF 24 Sept 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    var
        GenJnlBatchRec: Record "Gen. Journal Batch";
    begin
        if GenJnlBatchRec.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            CustLedgerEntry."Journal Batch Description" := GenJnlBatchRec.Description;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure OnAfterInitVendLedgEntry(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    var
        GenJnlBatchRec: Record "Gen. Journal Batch";
    begin
        if GenJnlBatchRec.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            VendorLedgerEntry."Journal Batch Description" := GenJnlBatchRec.Description;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure OnAfterInitBankAccLedgEntry(VAR BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    var
        GenJnlBatchRec: Record "Gen. Journal Batch";
    begin
        if GenJnlBatchRec.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            BankAccountLedgerEntry."Journal Batch Description" := GenJnlBatchRec.Description;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(VAR GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line");
    var
        GenJnlBatchRec: Record "Gen. Journal Batch";
        VATPostingSetup: Record "VAT Posting Setup";
        IsTaxGLAccount: Boolean;
    begin
        if GenJnlBatchRec.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            GLEntry."Journal Batch Description" := GenJnlBatchRec.Description;
        end;

        // YF 18 May 2022
        GLEntry."Foreign Currency Code" := GenJournalLine."Source Currency Code";

        IsTaxGLAccount := false;

        // Check Sales VAT Account
        VATPostingSetup.Reset;
        VATPostingSetup.SetRange("Sales VAT Account", GLEntry."G/L Account No.");
        IsTaxGLAccount := VATPostingSetup.FindFirst();

        // Check Purchase VAT Account
        if not IsTaxGLAccount then begin
            VATPostingSetup.Reset;
            VATPostingSetup.SetRange("Purchase VAT Account", GLEntry."G/L Account No.");
            IsTaxGLAccount := VATPostingSetup.FindFirst();
        end;

        //if equal to GST account and // Exchange Rate Calculation // Exchn Rate = FCY Amount / Amount
        if IsTaxGLAccount then
            GLEntry."Foreign Currency Amount" := GenJournalLine."Source Curr. VAT Amount"
        else
            GLEntry."Foreign Currency Amount" := GenJournalLine."Source Curr. VAT Base Amount";

        if GLEntry."Foreign Currency Amount" = 0 then
            GLEntry."Foreign Currency Amount" := GenJournalLine."Source Currency Amount";

        if GenJournalLine."Currency Factor" <> 0 then
            GLEntry."Foreign Currency Exchange Rate" := 1 / GenJournalLine."Currency Factor"
        else begin
            if GLEntry."Foreign Currency Amount" <> 0 then
                GLEntry."Foreign Currency Exchange Rate" := GLEntry.Amount / GLEntry."Foreign Currency Amount";
        end;
        // YF 18 May 2022
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Make FA Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(var FALedgerEntry: Record "FA Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlBatchRec: Record "Gen. Journal Batch";
    begin
        if GenJnlBatchRec.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            FALedgerEntry."Journal Batch Description" := GenJnlBatchRec.Description;
        end;
    end;

    // EventSub for Posted Gen Jnl not working at all, doing at dynamic generation on Posted General Journal worksheet page

    // YF 24 Sept 2021

    //DX        02 Oct 2021
    procedure VoidChecking(var CheckRec: Record "Checking Header")
    var
        myInt: Integer;
        PMPWH: Codeunit "Warehouse CU";
        ALERec: Record "Assignment Ledger Entry";
        SHREc: Record "Sales Header";
    begin
        if Confirm('Are you sure you wish to void this checking?') then begin
            ALERec.Reset();
            ALERec.SetRange("Checking Doc No.", CheckRec."No.");
            if ALERec.FindFirst() then begin
                SHREc.reset;
                SHREc.SetRange("Document Type", SHREc."Document Type"::Order);
                SHREc.SetRange("No.", ALERec."Document No.");
                if SHREc.FindFirst() then begin
                    PMPWH.DeleteWHShipmentAndPicking(SHREc);
                    PMPWH.SetBasketAvail(ALERec.Basket);
                    PMPWH.SetBasketAvail(ALERec."2nd Basket Code");
                    SHREc."Order Status" := SHREc."Order Status"::Open;
                    SHREc.Modify(TRUE);
                end;
                CheckRec.Status := CheckRec.Status::Error;
                CheckRec.Modify(false);
            end;

        end;
    end;
    //DX        02 Oct 2021

    //DX        03 Oct 2021
    procedure DeleteItemTrackSO(WHLine: Record "Warehouse Activity Line")
    var
        myInt: Integer;
        ResEntry: Record "Reservation Entry";
        SLRec: Record "Sales Line";
        WhseItemTrack: Record "Whse. Item Tracking Line";
    begin
        if WHLine."Action Type" <> WHLine."Action Type"::Take then
            Error('Please select only the take line before executing this action.');

        SLRec.reset;
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetRange("Document No.", WHLine."Source No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter("No.", WHLine."Item No.");
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat
                ResEntry.reset;
                ResEntry.SetRange("Location Code", SLRec."Location Code");
                ResEntry.SetRange("Source Type", 37);
                ResEntry.SetRange("Source Subtype", 1);
                ResEntry.SetRange("Item No.", SLRec."No.");
                ResEntry.SetRange("Source ID", SLRec."Document No.");
                ResEntry.SetRange("Source Ref. No.", SLRec."Line No.");
                ResEntry.SetRange("Quantity Invoiced (Base)", 0);
                ResEntry.SetFilter("Lot No.", '<>%1', WHLine."Lot No.");
                if ResEntry.FindFirst() then
                    ResEntry.Delete(true);
            until SLRec.next = 0;

        WhseItemTrack.reset;
        WhseItemTrack.SetRange("Source ID", WHLine."Whse. Document No.");
        WhseItemTrack.SetRange("Source Ref. No.", WHLine."Whse. Document Line No.");
        WhseItemTrack.SetRange("Item No.", WHLine."Item No.");
        WhseItemTrack.SetRange("Source Type", 7321);
        WhseItemTrack.SetFilter("Quantity (Base)", '%1', WHLine."Qty. (Base)");
        WhseItemTrack.SetRange("Quantity Handled (Base)", WHLine."Qty. (Base)");
        WhseItemTrack.SetRange("Location Code", WHLine."Location Code");
        WhseItemTrack.SetFilter("Lot No.", '<>%1', WHLine."Lot No.");
        if WhseItemTrack.FindFirst() then begin
            WhseItemTrack."Lot No." := WHLine."Lot No.";
            WhseItemTrack.Modify(FALSE);
        end;
        Message('SO batches have been reset, please try registering the pick list again.');

    end;
    //DX        03 Oct 2021

    // YF        06 Oct 2021 // should be resolved together with the commit issue already
    /*
    // YF        04 Oct 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnBeforeCheckQtyAvailToInsertBase', '', false, false)]
    local procedure OnBeforeCheckQtyAvailToInsertBase(var TempWhseActivLine: Record "Warehouse Activity Line" temporary; var QtyAvailToInsertBase: Decimal)
    var
        TradeCU: Codeunit "Trade Agreement CU";
    begin

        if UserId = 'BCADMIN' then
            Message('Line No : ' + Format(TempWhseActivLine."Line No.") + ' Qty Available to Insert : ' + Format(QtyAvailToInsertBase));

        if QtyAvailToInsertBase < 0 then
            QtyAvailToInsertBase := 0;
    end;
    // YF        04 Oct 2021
    */
    // YF        06 Oct 2021 // should be resolved together with the commit issue already

    // YF        06 Oct 2021 : Revised Create Principal PO
    procedure CreatePrincipalPOsV2(PORec: Record "Purchase Header")
    var
        FullPOLines: Record "Purchase Line";
        PrincipalFirstInstance: Code[20];
        PrincipalCurrentState: Code[20];
        POCreatedCounter: Integer;
        NewPOHeader: Record "Purchase Header";
        NewPOLine: Record "Purchase Line";
        NewPONo: Code[20];
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        FromDocType: Enum "Purchase Document Type From";
    begin

        if POHasMultiplePrincipal(PORec) then begin

            PrincipalFirstInstance := 'I9XBLANKXI9';
            PrincipalCurrentState := 'I9XBLANKXI9';

            FullPOLines.Reset;
            FullPOLines.SetRange("Document Type", PORec."Document Type");
            FullPOLines.SetRange("Document No.", PORec."No.");
            FullPOLines.SetRange(Type, FullPOLines.Type::Item);
            FullPOLines.SetFilter("No.", '<>%1', '');
            FullPOLines.SetFilter(Quantity, '<>0');
            FullPOLines.SetCurrentKey(Principal);
            FullPOLines.SetAscending(Principal, true);
            if FullPOLines.FindSet() then
                repeat

                    if PrincipalFirstInstance = 'I9XBLANKXI9' then
                        PrincipalFirstInstance := FullPOLines.Principal;

                    if PrincipalCurrentState = 'I9XBLANKXI9' then
                        PrincipalCurrentState := FullPOLines.Principal;

                    if FullPOLines.Principal <> PrincipalFirstInstance then begin

                        if FullPOLines.Principal <> PrincipalCurrentState then begin
                            // insert PO and line
                            NewPOHeader.Init();
                            NewPOHeader.TransferFields(PORec);
                            NewPOHeader."No." := '';
                            NewPOHeader.Insert(true);
                            CopyDocMgt.CopyPurchDoc(FromDocType::Order, PORec."No.", NewPOHeader);

                            NewPOLine.Reset;
                            NewPOLine.SetRange("Document Type", NewPOHeader."Document Type");
                            NewPOLine.SetRange("Document No.", NewPOHeader."No.");
                            NewPOLine.SetRange(Type, NewPOLine.Type::Item);
                            NewPOLine.SetFilter("No.", '<>%1', '');
                            NewPOLine.SetFilter(Quantity, '<>0');
                            NewPOLine.SetFilter(Principal, '<>%1', FullPOLines.Principal);
                            // YF 10 Aug 2022 // To avoid unnecessary table lock
                            if not NewPOLine.IsEmpty then
                                NewPOLine.DeleteAll();
                            // YF 10 Aug 2022 // To avoid unnecessary table lock

                            PrincipalCurrentState := FullPOLines.Principal;
                            POCreatedCounter += 1;
                        end;

                    end;

                until FullPOLines.Next() = 0;

            if PrincipalFirstInstance <> 'I9XBLANKXI9' then begin
                FullPOLines.Reset;
                FullPOLines.SetRange("Document Type", PORec."Document Type");
                FullPOLines.SetRange("Document No.", PORec."No.");
                FullPOLines.SetRange(Type, FullPOLines.Type::Item);
                FullPOLines.SetFilter("No.", '<>%1', '');
                FullPOLines.SetFilter(Quantity, '<>0');
                FullPOLines.SetFilter(Principal, '<>%1', PrincipalFirstInstance);
                // YF 10 Aug 2022 // To avoid unnecessary table lock
                if not FullPOLines.IsEmpty then
                    FullPOLines.DeleteAll();
                // YF 10 Aug 2022 // To avoid unnecessary table lock
            end;

            Message('%1 Purchase Orders created.', POCreatedCounter);

        end else begin
            Message('This PO does not have multiple principals in the lines. Please check again');
        end;

    end;
    // YF        06 Oct 2021 : Revised Create Principal PO

    // YF        14 Oct 2021 : Stock Availability Calculations
    procedure CheckSOEnoughStockAll(SHRec: Record "Sales Header"): Boolean
    var
        SLRec: Record "Sales Line";
        IsLineEnough: Boolean;
        IsOrderEnough: Boolean;
        ItemRec: Record Item; // YF 17 Nov 2021 // Check if Item is Inventory Type
    begin
        IsLineEnough := true;
        IsOrderEnough := true;
        // IsOrderEnough := SHRec."Out of Stock";

        SLRec.Reset;
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat

                // YF 17 Nov 2021 // Check if Item is Inventory Type
                ItemRec.Reset;
                ItemRec.SetLoadFields("No.", Type);//DX      06 May 2023
                ItemRec.SetRange("No.", SLRec."No.");
                ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                if ItemRec.FindFirst() then begin
                    if GetNetAvailQtyFromAll(SLRec) - GetUOMBase(SLRec) >= 0 then begin
                        // enough stock for this line
                        IsLineEnough := true;
                    end
                    else begin
                        // not enough stock for this line
                        IsLineEnough := false;
                        IsOrderEnough := false;
                    end;
                    // Message(SLRec."No." + ' ' + Format(IsLineEnough) + ' ' + Format(GetNetAvailQty(SLRec)) + ' ' + Format(GetUOMBase(SLRec)) + ' X');
                    SLRec."Out of Stock" := Not IsLineEnough;
                    SLRec.Modify(false);
                end;
            // YF 17 Nov 2021 // Check if Item is Inventory Type

            until SLRec.next = 0;

        exit(IsOrderEnough);
    end;

    procedure CheckSOEnoughStockPickArea(SHRec: Record "Sales Header"): Boolean
    var
        SLRec: Record "Sales Line";
        IsLineEnough: Boolean;
        IsOrderEnough: Boolean;
        ItemRec: Record Item; // YF 17 Nov 2021 // Check if Item is Inventory Type
    begin
        IsLineEnough := true;
        IsOrderEnough := true;
        // IsOrderEnough := SHRec."Out of Stock";

        SLRec.Reset;
        SLRec.SetCurrentKey("Document Type", "Document No.", Type, Quantity);
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat

                // YF 17 Nov 2021 // Check if Item is Inventory Type
                ItemRec.Reset;
                ItemRec.SetLoadFields("No.", Type);//DX      06 May 2023
                ItemRec.SetRange("No.", SLRec."No.");
                ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                if ItemRec.FindFirst() then begin
                    if GetNetAvailQtyFromPickArea(SLRec) - GetUOMBase(SLRec) >= 0 then begin
                        // enough stock for this line
                        IsLineEnough := true;
                    end
                    else begin
                        // not enough stock for this line
                        IsLineEnough := false;
                        IsOrderEnough := false;
                    end;
                    SLRec."Insufficient Stocks in Pick" := Not IsLineEnough;
                    SLRec.Modify(false);
                end;
            // YF 17 Nov 2021 // Check if Item is Inventory Type

            until SLRec.next = 0;

        exit(IsOrderEnough);
    end;

    procedure GetNetAvailQtyFromAll(SLRec: Record "Sales Line"): Decimal
    var
        myInt: Integer;
        BinContent: Record "Bin Content";
        CompInfo: Record "Company Information";
        AvailQty: Decimal;
    begin
        CompInfo.reset;
        CompInfo.get;

        // if (SLRec."Location Code" = CompInfo."Location Code") AND
        // (SLRec.Type = SLRec.Type::Item) and
        // (SLRec."No." <> '') then begin
        if (SLRec.Type = SLRec.Type::Item) and  ////RL 01 Mar 2022 - remove compinfo.location check
            (SLRec."No." <> '') then begin
            BinContent.reset;
            BinContent.SetCurrentKey("Item No.", "Location Code", "Bin Type Code");
            BinContent.SetRange("Item No.", SLRec."No.");
            BinContent.SetRange("Location Code", SLRec."Location Code");
            BinContent.setfilter("Bin Type Code", '%1|%2|%3|%4', 'PICK', 'PUTPICK', 'PUT', '');//RL 01 Mar 2022 - Added Blank Bin type
            if BinContent.FindSet() then
                repeat
                    BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
                    AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";
                until BinContent.next = 0;
            //BinContent.CalcSums("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
            exit(AvailQty);
        end;
    end;

    procedure GetNetAvailQtyFromPickArea(SLRec: Record "Sales Line"): Decimal
    var
        myInt: Integer;
        BinContent: Record "Bin Content";
        CompInfo: Record "Company Information";
        AvailQty: Decimal;
    begin
        CompInfo.reset;
        CompInfo.get;

        // if (SLRec."Location Code" = CompInfo."Location Code") AND
        // (SLRec.Type = SLRec.Type::Item) and
        // (SLRec."No." <> '') then begin
        if (SLRec.Type = SLRec.Type::Item) and  ////RL 01 Mar 2022 - remove compinfo.location check
            (SLRec."No." <> '') then begin
            BinContent.reset;
            BinContent.SetCurrentKey("Item No.", "Location Code", "Bin Type Code");
            BinContent.SetRange("Item No.", SLRec."No.");
            BinContent.SetRange("Location Code", SLRec."Location Code");
            BinContent.setfilter("Bin Type Code", '%1|%2|%3', 'PICK', 'PUTPICK', ''); //RL 01 Mar 2022 - Added Blank Bin type

            if BinContent.FindSet() then
                repeat
                    BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
                    AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";
                until BinContent.next = 0;
            //BinContent.CalcSums("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
            exit(AvailQty);
        end;
    end;
    // YF        14 Oct 2021 : Stock Availability Calculations

    // YF        15 Oct 2021 : Stock Availability Calculations
    procedure UpdateSOStockStatusFlags(ItemCode: Code[20]; LocationCode: Code[20])
    var
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
        BinContent: Record "Bin Content";
        AvailQtyAll: Decimal;
        AvailQtyPick: Decimal;
        ItemUom: Record "Item Unit of Measure";
        SLQty: Decimal;
        SLCheckRec: Record "Sales Line";
    begin
        SLRec.Reset;
        SLRec.SetLoadFields("Document Type", "Document No.", Type, "No.", "Location Code", "Unit of Measure Code", "FOC (Qty) To Deliver", "Qty To Deliver"
        , "Out of Stock", "Insufficient Stocks in Pick");      //DX        12 Jun 2023  Performance tuning
        SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetRange("No.", ItemCode);
        SLRec.SetRange("Location Code", LocationCode);
        if SLRec.FindSet() then
            repeat
                SHRec.Reset;
                SHRec.SetLoadFields("Document Type", "No.", "Out of Stock", "Insufficient Stocks in Pick"); //DX        03 May 2023
                SHRec.SetRange("Document Type", SLRec."Document Type");
                SHRec.SetRange("No.", SLRec."Document No.");
                // SHRec.SetRange(Status, SHRec.Status::Open);
                if SHRec.FindFirst() then begin
                    // Get Sales Line Qty
                    ItemUom.reset;
                    ItemUom.SetRange("Item No.", SLRec."No.");
                    ItemUom.SetRange(Code, SLRec."Unit of Measure Code");
                    if ItemUom."Qty. per Unit of Measure" <> 1 then begin
                        SLQty := ((SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver") * ItemUom."Qty. per Unit of Measure");
                    end else
                        if ItemUom."Qty. per Unit of Measure" = 1 then
                            SLQty := (SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver");

                    BinContent.Reset;
                    BinContent.SetRange("Item No.", SLRec."No.");
                    BinContent.SetRange("Location Code", SLRec."Location Code");
                    BinContent.setfilter("Bin Type Code", '%1|%2|%3', 'PICK', 'PUTPICK', 'PUT');

                    if BinContent.FindSet() then
                        repeat
                            BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");

                            AvailQtyAll += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";

                            if BinContent."Bin Type Code" <> 'PUT' then
                                AvailQtyPick += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";

                            // Check out of stock for line
                            SLRec."Out of Stock" := Not ((AvailQtyAll - SLQty) >= 0);

                            // Check insufficient stock for line
                            SLRec."Insufficient Stocks in Pick" := Not ((AvailQtyPick - SLQty) >= 0);

                            // Update Lines First
                            SLRec.Modify(false);

                        until BinContent.next = 0;

                    // Update Header
                    SHRec."Out of Stock" := false;
                    SHRec."Insufficient Stocks in Pick" := false;

                    SLCheckRec.Reset;
                    SLCheckRec.SetLoadFields("Document Type", "Document No.", Type, "No.", Quantity, "Out of Stock", "Insufficient Stocks in Pick"); //DX        06 May 2023
                    SLCheckRec.SetRange("Document Type", SHRec."Document Type");
                    SLCheckRec.SetRange("Document No.", SHRec."No.");
                    SLCheckRec.SetRange(Type, SLCheckRec.Type::Item);
                    SLCheckRec.SetRange("No.", '<>%1', '');
                    SLCheckRec.SetFilter(Quantity, '<>0');
                    if SLCheckRec.FindSet() then
                        repeat
                            if SLCheckRec."Out of Stock" then
                                SHRec."Out of Stock" := true;

                            if SLCheckRec."Insufficient Stocks in Pick" then
                                SHRec."Insufficient Stocks in Pick" := true;

                        until SLCheckRec.Next() = 0;

                    SHRec.Modify(false);
                end;

            until SLRec.Next() = 0;
    end;

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Register (Yes/No)", 'OnAfterCode', '', false, false)]
    local procedure OnAfterCode(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        if (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Movement) Or (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::"Put-away") then
            UpdateSOStockStatusFlags(WarehouseActivityLine."Item No.", WarehouseActivityLine."Location Code");
    end;
    */

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnAfterRegisterWhseActivityLines', '', false, false)]
    local procedure OnAfterRegisterWhseActivityLines(var WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        if (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Movement) Or (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::"Put-away") then
                UpdateSOStockStatusFlags(WarehouseActivityLine."Item No.", WarehouseActivityLine."Location Code");
    end;
    */

    /*
    procedure HasSufficientStock(var SHRec: Record "Sales Header"): Boolean
    var
        SLRec: Record "Sales Line";
    begin
        SLRec.Reset;
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetRange("No.", '<>%1', '');
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat
                if SLRec."Out of Stock" then
                    exit(false);

                if SLRec."Insufficient Stocks in Pick" then
                    exit(false);

            until SLRec.Next() = 0;

        exit(true);
    end;
    */

    // YF        15 Oct 2021 : Stock Availability Calculations
    //DX        17 Oct 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnCreateWhseDocumentOnBeforeShowError', '', false, false)]
    local procedure OnCreateWhseDocumentOnBeforeShowError(var ShowError: Boolean)
    begin
        //ShowError := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnBeforeShowResult', '', false, false)]
    local procedure OnBeforeShowResult(var IsHandled: Boolean; WhseShipmentCreated: Boolean)
    begin
        //IsHandled := true;
    end;
    //DX        17 Oct 2021

    // YF 15 Dec 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean);
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
            DefaultOption := 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var SendReportAsEmail: Boolean; var DefaultOption: Integer);
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
            DefaultOption := 1;
    end;
    // YF 15 Dec 2021

    //RL 15 Dec 2021
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Document Lines", 'OnCopyLineToDocOnBeforeMessage', '', false, false)]
    local procedure OnCopyLineToDocOnBeforeMessage(ToSalesHeader: Record "Sales Header"; var IsHandled: Boolean);
    var
        SLRec: Record "Sales Line";
    begin
        if ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::"Return Order" then begin
            SLRec.Reset();
            SLRec.SetFilter("Document No.", ToSalesHeader."No.");
            SLRec.SETFILTER("No.", '<>%1', '');

            if SLRec.FindSet() then begin
                repeat
                    SLRec.validate("Inv. Discount Amount", 0);
                    SLRec.validate("Line Discount Amount", 0);
                    //SLRec.Validate("Order Qty", SLRec."Qty To Deliver"); // RL 19 Sep 2022 - tried but not working
                    SLRec.Modify(false);
                until SLRec.Next() = 0;
            end;
        end;
    end;
    //RL 15 Dec 2021



    // YF 21 Dec 2021
    // Changes to refer to [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnMaintainPlanningLineOnAfterReqLineInsert', '', false, false)]
    procedure MaintainPlanningLineOnAfterReqLineInsert(var RequisitionLine: Record "Requisition Line")
    // Custom Price List Implementation
    var
        PriceListLineRec: Record "Pharma Purchase Price";
        LowestMinQty: Decimal;
        LowestUnitCostPrice: Decimal;
        LowestFOCQty: Decimal;
        LowestUnitCostPerQty: Decimal;
        CurrentUnitCostPerQty: Decimal;
        RevisedFOCQty: Decimal;
        PurchasePrice: Decimal;
        TradeAgreementCU: Codeunit "Trade Agreement CU";
        LineDiscountPercent: Decimal;
    begin
        // Find Lowest Price
        LowestMinQty := 0;
        LowestUnitCostPrice := 0;
        LowestFOCQty := 0;
        LowestUnitCostPerQty := 0;
        CurrentUnitCostPerQty := 0;

        PriceListLineRec.Reset;
        PriceListLineRec.SetRange("Vendor No.", RequisitionLine."Vendor No.");
        PriceListLineRec.SetRange("Item No.", RequisitionLine."No.");
        PriceListLineRec.SetRange("Unit of Measure Code", RequisitionLine."Unit of Measure Code");
        PriceListLineRec.SetRange(Status, PriceListLineRec.Status::Active);

        PriceListLineRec.SetFilter("Starting Date", '<=%1', WorkDate());
        PriceListLineRec.SetFilter("Ending Date", '>=%1', WorkDate());

        // PriceListLineRec.SetFilter("Starting Date", '<=%1', RequisitionLine."Order Date");
        // PriceListLineRec.SetFilter("Ending Date", '>=%1', RequisitionLine."Order Date");       

        if PriceListLineRec.FindSet() then
            repeat
                if PriceListLineRec."Direct Unit Cost" > 0 then begin
                    // CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty") / PriceListLineRec."Direct Unit Cost";

                    // YF 15 Oct 2021 // Extra Checks for Division by Zero
                    if (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty") = 0 then
                        CurrentUnitCostPerQty := 0 // Error('Sum of Min Qty and FOC Qty cannot be zero');
                    else
                        CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty");

                    // CurrentUnitCostPerQty := (PriceListLineRec."Minimum Quantity" * PriceListLineRec."Direct Unit Cost") / (PriceListLineRec."Minimum Quantity" + PriceListLineRec."FOC Qty");
                    // YF 15 Oct 2021 // Extra Checks for Division by Zero

                    if CurrentUnitCostPerQty < LowestUnitCostPerQty then begin
                        LowestUnitCostPerQty := CurrentUnitCostPerQty;
                        LowestMinQty := PriceListLineRec."Minimum Quantity";
                        LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                        LowestFOCQty := PriceListLineRec."FOC Qty";
                    end;

                    if CurrentUnitCostPerQty = LowestUnitCostPerQty then begin
                        if PriceListLineRec."Minimum Quantity" > LowestMinQty then begin
                            LowestUnitCostPerQty := CurrentUnitCostPerQty;
                            LowestMinQty := PriceListLineRec."Minimum Quantity";
                            LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                            LowestFOCQty := PriceListLineRec."FOC Qty";
                        end;
                    end;

                    if LowestUnitCostPerQty = 0 then begin
                        LowestUnitCostPerQty := CurrentUnitCostPerQty;
                        LowestMinQty := PriceListLineRec."Minimum Quantity";
                        LowestUnitCostPrice := PriceListLineRec."Direct Unit Cost";
                        LowestFOCQty := PriceListLineRec."FOC Qty";
                    end;

                end;
            until PriceListLineRec.Next() = 0;

        // Get and Set Default values
        CalculatePurchPriceFOCQty_PMPCustomized(RequisitionLine."Vendor No.", WorkDate(), RequisitionLine."No.", RequisitionLine."Unit of Measure Code", RequisitionLine.Quantity, PurchasePrice, RevisedFOCQty, LineDiscountPercent);

        RequisitionLine."Min Qty" := LowestMinQty;
        RequisitionLine."Unit Cost Price" := LowestUnitCostPrice;
        RequisitionLine."FOC Qty" := LowestFOCQty;
        RequisitionLine."Direct Unit Cost" := PurchasePrice;
        RequisitionLine."Revised FOC Qty" := RevisedFOCQty;
        // RequisitionLine."Line Discount %" := LineDiscountPercent;
        RequisitionLine."Line Discount Percent" := LineDiscountPercent;
        // RequisitionLine.Modify();
    end;
    // YF 21 Dec 2021

    // YF 28 Dec 2021 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterTestSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnAfterTestSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        SHRec: Record "Sales Header";
        currency: Record Currency;
        glsetup: Record "General Ledger Setup";
        DelFOCQty: Decimal;
        DelQty: Decimal;
        RunningBal: Decimal;
        ShipAmount: Decimal;
    begin

        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
        (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then begin

            ShipAmount := SalesLine."Qty. to Ship";

            if SalesHeader.Invoice And Not SalesHeader.Ship then begin
                if SalesLine."Qty. Shipped Not Invoiced" <> 0 then
                    ShipAmount := SalesLine."Qty. Shipped Not Invoiced";
            end;

            DelQty := SalesLine."Qty To Deliver";
            DelFOCQty := SalesLine."FOC (Qty) To Deliver";

            // if only foc qty then
            if (SalesLine."Qty To Deliver" = 0) and (SalesLine."FOC (Qty) To Deliver" <> 0) then begin
                SalesLine."FOC (Qty) To Deliver" := Abs(ShipAmount);
                SalesLine."Unit Price" := 0;
                SalesLine."Line Amount" := 0;
            end
            else begin
                // handle the rest
                if Abs(ShipAmount) > (DelQty + DelFOCQty) then // underpicked?
                    begin
                    // Do nothing
                end;

                if Abs(ShipAmount) < (DelQty + DelFOCQty) then // overpicked?
                    begin
                    if DelQty >= Abs(ShipAmount) then begin        //del = 5+2        qty shipped = 4
                        SalesLine."Qty To Deliver" := Abs(ShipAmount);
                        SalesLine."FOC (Qty) To Deliver" := 0;
                    end
                    else begin //if picked qty > req del qty
                        SalesLine."FOC (Qty) To Deliver" := Abs(ShipAmount) - DelQty;
                    end;
                end;

                SalesLine.Modify(false);

                if ShipAmount <> 0 then begin
                    // SalesLine.Validate("Unit Price", (SalesLine."Qty To Deliver" * SalesLine."Selling Price") / (SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver"));

                    // YF 30 Dec 2021 // Hacky fix
                    if (SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver") <> 0 then
                        SalesLine."Unit Price" := (SalesLine."Qty To Deliver" * SalesLine."Selling Price") / (SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver")
                    else
                        // SalesLine."Unit Price" := (SalesLine."Qty To Deliver" * SalesLine."Selling Price") / ShipAmount;
                        SalesLine."Unit Price" := SalesLine."Selling Price";
                    // YF 30 Dec 2021 // Hacky fix

                    // SalesLine."Unit Price" := (SalesLine."Qty To Deliver" * SalesLine."Selling Price") / (SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver"); // YF 30 Dec 2021 // Hacky fix
                    SalesLine."To Del. Amt" := SalesLine."Qty To Deliver" * SalesLine."Selling Price";
                    SalesLine."Line Amount" := SalesLine."Qty To Deliver" * SalesLine."Selling Price";

                    Currency.reset;
                    Currency.SetRange(Code, SalesLine."Currency Code");
                    if Currency.FindFirst() then begin
                        if ROUND(SalesLine.Quantity * SalesLine."Unit Price", Currency."Amount Rounding Precision") * SalesLine."Line Discount %" <> 0 then
                            SalesLine."Line Discount Amount" := ROUND(ROUND(SalesLine.Quantity * SalesLine."Unit Price", Currency."Amount Rounding Precision") *
                            SalesLine."Line Discount %" / 100, Currency."Amount Rounding Precision");
                    end else begin
                        glsetup.reset;
                        glsetup.get;
                        if ROUND(SalesLine.Quantity * SalesLine."Unit Price", glsetup."Amount Rounding Precision") * SalesLine."Line Discount %" <> 0 then
                            SalesLine."Line Discount Amount" := ROUND(ROUND(SalesLine.Quantity * SalesLine."Unit Price", glsetup."Amount Rounding Precision") *
                            SalesLine."Line Discount %" / 100, glsetup."Amount Rounding Precision");
                    end;
                end;
            end;

            SalesLine.Modify(false);
        end;
    end;
    // YF 28 Dec 2021   


    //RL 31 Dec 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptHeader', '', false, false)]
    local procedure OnAfterInsertTransShptHeader(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header");
    begin
        TransferShipmentHeader.Remarks := TransferHeader.Remarks;
        TransferShipmentHeader."No. of Carton" := TransferHeader."No. of Carton";
        TransferShipmentHeader."TO Created By" := TransferHeader."TO Created By";
        TransferShipmentHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptHeader', '', false, false)]
    local procedure OnAfterInsertTransRcptHeader(var TransRcptHeader: Record "Transfer Receipt Header"; var TransHeader: Record "Transfer Header");
    begin
        TransRcptHeader.Remarks := TransHeader.Remarks;
        TransRcptHeader."No. of Carton" := TransHeader."No. of Carton";
        TransRcptHeader."TO Created By" := TransHeader."TO Created By";
        TransRcptHeader.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', false, false)]
    local procedure OnAfterInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransShptHeader: Record "Transfer Shipment Header");
    begin
        TransShptLine."No. of Carton" := TransLine."No. of Carton";
        TransShptLine."Line Remarks" := TransLine."Line Remarks";
        TransShptLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptLine', '', false, false)]
    local procedure OnAfterInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransferReceiptHeader: Record "Transfer Receipt Header");
    begin
        TransRcptLine."No. of Carton" := TransLine."No. of Carton";
        TransRcptLine."Line Remarks" := TransLine."Line Remarks";
        TransRcptLine.Modify();
    end;

    //RL 31 Dec 2021

    //RL 12 Jan 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    begin
        NewItemLedgEntry.Remarks := ItemJournalLine.Remarks;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnInitWhseEntryCopyFromWhseJnlLine', '', false, false)]
    local procedure OnInitWhseEntryCopyFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line"; OnMovement: Boolean; Sign: Integer; Location: Record Location; BinCode: Code[20]; var IsHandled: Boolean);
    begin
        WarehouseEntry.Remarks := WarehouseJournalLine.Remarks;
        WarehouseEntry."Qty. Calculated" := WarehouseJournalLine."Qty. (Calculated)";
        WarehouseEntry."Qty. Phy Count" := WarehouseJournalLine."Qty. (Phys. Inventory)";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnInitWhseJnlLineCopyFromItemJnlLine', '', false, false)]
    local procedure OnInitWhseJnlLineCopyFromItemJnlLine(var WarehouseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line");
    begin
        WarehouseJournalLine.Remarks := ItemJournalLine.Remarks;
    end;

    //RL 12 Jan 2022

    // YF 11 Jan 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterUpdatePurchLineBeforePost', '', false, false)]
    local procedure OnAfterUpdatePurchLineBeforePost(var PurchaseLine: Record "Purchase Line"; WhseShip: Boolean; WhseReceive: Boolean; PurchaseHeader: Record "Purchase Header"; RoundingLineInserted: Boolean)
    var
        AvDelFOCQty: Decimal;
        AvDelQty: Decimal;
        RunningBal: Decimal;
        RecdAmount: Decimal;
        RollOutPurchPostChanges: Boolean;
        TempRecdAmount: Decimal;
    begin
        RollOutPurchPostChanges := true;
        if RollOutPurchPostChanges then begin
            // if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) Or
            //     (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) then begin

            if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin  //RL    18 Jan 2022 - remove invoice
                RecdAmount := PurchaseLine."Qty. to Receive";

                if PurchaseHeader.Invoice And Not PurchaseHeader.Receive then begin

                    // YF 12 Jan 2022
                    RecdAmount := 0;
                    /*
                    if PurchaseLine."Qty. Rcd. Not Invoiced" <> 0 then
                        RecdAmount := PurchaseLine."Qty. Rcd. Not Invoiced";
                    */
                    // YF 12 Jan 2022
                end;

                // 0. Calculate available Qty
                TempRecdAmount := RecdAmount;
                AvDelQty := PurchaseLine."Order Qty" - PurchaseLine."Qty To Deliver" - PurchaseLine."Qty Delivered";
                AvDelFOCQty := PurchaseLine."FOC Qty" - PurchaseLine."FOC (Qty) To Deliver" - PurchaseLine."FOC Qty Delivered";

                // 1. Deduct RecdAmount from Order Qty First 
                if (AvDelQty >= 0) and (TempRecdAmount >= AvDelQty) then begin
                    PurchaseLine."Qty To Deliver" += AvDelQty;
                    TempRecdAmount -= AvDelQty;
                    AvDelQty := 0;
                end
                else begin
                    PurchaseLine."Qty To Deliver" += TempRecdAmount;
                    AvDelQty -= TempRecdAmount;
                    TempRecdAmount := 0;
                end;

                // 2. Leftover RecdAmount from FOC Qty
                if (AvDelFOCQty >= 0) and (TempRecdAmount >= AvDelFOCQty) then begin
                    PurchaseLine."FOC (Qty) To Deliver" += AvDelFOCQty;
                    TempRecdAmount -= AvDelFOCQty;
                    AvDelFOCQty := 0;
                end
                else begin
                    PurchaseLine."FOC (Qty) To Deliver" += TempRecdAmount;
                    AvDelFOCQty -= TempRecdAmount;
                    TempRecdAmount := 0;
                end;

                // Message('%1,%2', PurchaseLine."Qty To Deliver", PurchaseLine."FOC (Qty) To Deliver");
                // 3. Update Price
                if (PurchaseLine."Qty To Deliver" = 0) and (PurchaseLine."FOC (Qty) To Deliver" <> 0) then begin
                    // PurchaseLine."Unit Cost" := 0; // YF 13 Jan 2022
                    PurchaseLine."Direct Unit Cost" := 0; // YF 13 Jan 2022
                    PurchaseLine."Line Amount" := 0;
                    // Message('%1', PurchaseLine."Direct Unit Cost");
                end
                else begin
                    // YF 13 Jan 2022
                    if (PurchaseLine."Qty To Deliver" + PurchaseLine."FOC (Qty) To Deliver") <> 0 then
                        PurchaseLine."Direct Unit Cost" := (PurchaseLine."Qty To Deliver" * PurchaseLine."Purchase Price") / (PurchaseLine."Qty To Deliver" + PurchaseLine."FOC (Qty) To Deliver")
                    else
                        PurchaseLine."Direct Unit Cost" := PurchaseLine."Purchase Price";

                    /*
                    if (PurchaseLine."Qty To Deliver" + PurchaseLine."FOC (Qty) To Deliver") <> 0 then
                        PurchaseLine."Unit Cost" := (PurchaseLine."Qty To Deliver" * PurchaseLine."Purchase Price") / (PurchaseLine."Qty To Deliver" + PurchaseLine."FOC (Qty) To Deliver")
                    else
                        PurchaseLine."Unit Cost" := PurchaseLine."Purchase Price";
                    */
                    // YF 13 Jan 2022

                    PurchaseLine."Line Amount" := PurchaseLine."Qty To Deliver" * PurchaseLine."Purchase Price";
                end;

                PurchaseLine.Modify(false);

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PHRec: Record "Purchase Header";
        PLRec: Record "Purchase Line";
        PPILRec: Record "Purch. Inv. Line"; // YF 26 Oct 2022
    begin
        PHRec.Reset();
        PHRec.SetRange("No.", PurchaseHeader."No.");
        PHRec.SetRange("Document Type", PurchaseHeader."Document Type");
        if PHRec.FindFirst() then begin

            PLRec.Reset;
            PLRec.SetRange("Document Type", PHRec."Document Type");
            PLRec.SetRange("Document No.", PHRec."No.");
            if PLRec.FindSet() then
                repeat
                    // Trigger change if invoiced only (hacky)
                    if (PurchInvHdrNo <> '') and (PLRec."Qty. to Invoice" <> 0) then begin //RL 21 Oct added qty to invoice condition

                        // YF 26 Oct 2022
                        PPILRec.Reset;
                        PPILRec.SetRange("Document No.", PurchInvHdrNo);
                        PPILRec.SetRange("Line No.", PLRec."Line No.");
                        PPILRec.SetRange("No.", PLRec."No.");
                        PPILRec.SetFilter(Quantity, '>0');
                        if PPILRec.FindFirst() then begin
                            PLRec."FOC Qty Delivered" := PLRec."FOC Qty Delivered" + PLRec."FOC (Qty) To Deliver";
                            PLRec."Qty Delivered" := PLRec."Qty Delivered" + PLRec."Qty To Deliver";
                            PLRec."FOC (Qty) To Deliver" := 0;
                            PLRec."Qty To Deliver" := 0;

                        end;
                        // YF 26 Oct 2022

                        // YF 13 Jan 2022
                        // PLRec."FOC (Qty) To Deliver" := PLRec."FOC Qty" - PLRec."FOC Qty Delivered";
                        // PLRec."Qty To Deliver" := PLRec."Order Qty" - PLRec."Qty Delivered";
                        // PLRec."FOC (Qty) To Deliver" := 0;
                        // PLRec."Qty To Deliver" := 0;
                        // YF 13 Jan 2022
                    end;

                    // Reset Sales Line Unit Price
                    if PLRec.Quantity <> 0 then begin
                        // PLRec."Unit Cost" := (PLRec."Order Qty" * PLRec."Purchase Price") / PLRec.Quantity; // YF 13 Jan 2022
                        PLRec."Direct Unit Cost" := (PLRec."Order Qty" * PLRec."Purchase Price") / PLRec.Quantity; // YF 13 Jan 2022
                        PLRec."Line Amount" := PLRec."Order Qty" * PLRec."Purchase Price";
                    end
                    else begin
                        // PLRec."Unit Cost" := 0; // YF 13 Jan 2022
                        PLRec."Direct Unit Cost" := 0; // YF 13 Jan 2022
                        PLRec."Line Amount" := 0;
                    end;

                    PLRec.Modify(FALSE);

                until PLRec.Next() = 0;

        end;
    end;
    // YF 11 Jan 2022

    // YF 14 Feb 2022
    // Create PO from AO
    procedure CreatePOFromAO(AONum: Code[20]; AODocType: Enum "Assembly Document Type"): Code[20]
    var
        POHeaderRec: Record "Purchase Header";
        POLineRec: Record "Purchase Line";
        PONum: Code[20];
        AOHeaderRec: Record "Assembly Header";
        AOLineRec: Record "Assembly Line";
        ReservEntryRec: Record "Reservation Entry";
        LineNo: Integer;
    begin
        Clear(PONum);
        Clear(POHeaderRec);
        Clear(POLineRec);
        LineNo := 10000;

        AOHeaderRec.Reset;
        AOHeaderRec.SetRange("Document Type", AODocType);
        AOHeaderRec.SetRange("No.", AONum);
        if AOHeaderRec.FindFirst() then begin

            // Check if PO already created for this AO
            if AOHeaderRec."PO No." <> '' then begin
                Message('Purchase Order already created from this Assembly Order');
                exit(PONum);
            end;

            // Check if Vendor No. exists for PO creation
            if AOHeaderRec."Vendor No" = '' then begin
                Message('Vendor No. required');
                exit(PONum);
            end;

            POHeaderRec.Reset;
            POHeaderRec.Init();
            POHeaderRec.Validate("Document Type", POHeaderRec."Document Type"::Order);
            POHeaderRec.Validate("Buy-from Vendor No.", AOHeaderRec."Vendor No");
            POHeaderRec.Validate("Posting Date", WorkDate());

            // Additional Information Insert
            ReservEntryRec.Reset;
            ReservEntryRec.SetRange("Item No.", AOHeaderRec."Item No.");
            ReservEntryRec.SetRange("Source Type", 900);
            ReservEntryRec.SetRange("Source Subtype", 1);
            ReservEntryRec.SetRange("Source ID", AOHeaderRec."No.");
            if Not ReservEntryRec.FindFirst() then begin
                Message('Assembled Item Batch and Expiry Date cannot be found');
                exit(PONum);
            end;

            POHeaderRec."Is From Assembly Order" := true;
            POHeaderRec."AO Item No." := AOHeaderRec."Item No.";
            POHeaderRec."AO Item Descr" := AOHeaderRec.Description;
            POHeaderRec."AO Item Qty" := AOHeaderRec.Quantity;
            POHeaderRec."AO Item UOM" := AOHeaderRec."Unit of Measure Code";
            POHeaderRec."AO Item Batch" := ReservEntryRec."Lot No.";
            POHeaderRec."AO Item Expiry Date" := ReservEntryRec."Expiration Date";
            POHeaderRec."AO Item Packing Instruction" := AOHeaderRec."Packing Instructions";
            POHeaderRec."AO No." := AOHeaderRec."No.";
            // Additional Information Insert

            if POHeaderRec.Insert(true) then begin
                PONum := POHeaderRec."No.";

                AOLineRec.Reset;
                AOLineRec.SetRange("Document Type", AODocType);
                AOLineRec.SetRange("Document No.", AONum);
                AOLineRec.SetRange(Type, AOLineRec.Type::Resource);
                if AOLineRec.FindSet() then
                    repeat
                        POLineRec.Reset;
                        POLineRec.Init;
                        POLineRec.Validate("Document Type", POLineRec."Document Type"::Order);
                        POLineRec.Validate("Document No.", PONum);
                        POLineRec.Validate("Line No.", LineNo);
                        POLineRec.Validate(Type, POLineRec.Type::Resource);
                        POLineRec.Validate("No.", AOLineRec."No.");
                        POLineRec.Validate("Unit of Measure Code", AOLineRec."Unit of Measure Code");
                        POLineRec.Validate(Quantity, AOLineRec.Quantity);
                        POLineRec.Validate("Direct Unit Cost", AOLineRec."Unit Cost");
                        POLineRec."Order Qty" := AOLineRec.Quantity;
                        POLineRec."Purchase Price" := AOLineRec."Unit Cost";
                        POLineRec.Insert(true);

                        // Update Descr
                        POLineRec.Description := AOLineRec.Description;

                        LineNo += 10000;
                    until AOLineRec.Next() = 0;

            end;
        end;

        exit(PONum);
    end;
    // YF 14 Feb 2022

    // YF 18 Feb 2022
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterSetupNewLine', '', true, true)]
    local procedure OnAfterSetupNewLine(var ItemJournalLine: Record "Item Journal Line"; var LastItemJournalLine: Record "Item Journal Line"; ItemJournalTemplate: Record "Item Journal Template"; ItemJnlBatch: Record "Item Journal Batch")
    begin
        if ItemJnlBatch."Gen. Prod. Posting Group" <> '' then
            ItemJournalLine.Validate("Gen. Prod. Posting Group", ItemJnlBatch."Gen. Prod. Posting Group");
    end;
    // YF 18 Feb 2022

    //RL 21 Apr 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-SetAppl.ID", 'OnBeforeUpdateCustLedgerEntry', '', false, false)]
    local procedure OnBeforeUpdateCustLedgerEntry(var TempCustLedgerEntry: Record "Cust. Ledger Entry"; ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50]; var IsHandled: Boolean; var CustEntryApplID: Code[50]);
    begin
        if TempCustLedgerEntry.Open = false then
            Error('Document No. %1 must be open', TempCustLedgerEntry."Document No.");
    end;
    //RL 21 Apr 2022


    //RL 02 Jun 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptHeaderInsert', '', false, false)]
    local procedure OnRunOnBeforeInvtShptHeaderInsert(var InvtShptHeader: Record "Invt. Shipment Header"; InvtDocHeader: Record "Invt. Document Header");
    begin
        InvtShptHeader."Customer No." := InvtDocHeader."Customer No.";
        InvtShptHeader."Gen. Bus. Posting Group" := InvtDocHeader."Gen. Bus. Posting Group";
        InvtShptHeader."Gen. Prod. Posting Group" := InvtDocHeader."Gen. Prod. Posting Group";
        InvtShptHeader."Bin Code" := InvtDocHeader."Bin Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Receipt", 'OnRunOnBeforeInvtRcptHeaderInsert', '', false, false)]
    local procedure OnRunOnBeforeInvtRcptHeaderInsert(var InvtRcptHeader: Record "Invt. Receipt Header"; InvtDocHeader: Record "Invt. Document Header");
    begin
        // InvtRcptHeader.I9G_InvShpType := InvtDocHeader.I9G_InvShpType;
    end;
    //RL 02 Jun 2022

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptLineInsert', '', false, false)]
    local procedure OnRunOnBeforeInvtShptLineInsert(var InvtShptLine: Record "Invt. Shipment Line"; InvtDocLine: Record "Invt. Document Line"; var InvtShipmentHeader: Record "Invt. Shipment Header"; InvtDocumentHeader: Record "Invt. Document Header");
    begin
        InvtShptLine."Customer No." := InvtDocLine."Customer No.";
    end;

    //RL 27 Jul 2022 - Start - pass links over to posted
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnAfterInvtShptHeaderInsert', '', false, false)]
    local procedure OnRunOnAfterInvtShptHeaderInsert(var InvtShipmentHeader: Record "Invt. Shipment Header"; InvtDocumentHeader: Record "Invt. Document Header");
    var
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        if InvtDocumentHeader.HasLinks then
            RecordLinkManagement.CopyLinks(InvtDocumentHeader, InvtShipmentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Receipt", 'OnRunOnAfterInvtRcptHeaderInsert', '', false, false)]
    local procedure OnRunOnAfterInvtRcptHeaderInsert(var InvtReceiptHeader: Record "Invt. Receipt Header"; InvtDocumentHeader: Record "Invt. Document Header");
    var
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        if InvtDocumentHeader.HasLinks then
            RecordLinkManagement.CopyLinks(InvtDocumentHeader, InvtReceiptHeader);
    end;
    //RL 27 Jul 2022 - End - pass links over to posted

    // YF 28 Jun 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeInsertGLEntry', '', false, false)]
    local procedure OnReverseGLEntryOnBeforeInsertGLEntry(var GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    begin
        GLEntry."Foreign Currency Amount" := -GLEntry."Foreign Currency Amount";
    end;
    // YF 28 Jun 2022
    //DX        31 May 2023     new event from Microsoft, shifted to the new event
    /*
    //RL 21 Jul 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
        GenJnlLine.I9G_YourReference := PurchHeader."Your Reference";
    end;
*/
    //RL 21 Jul 2022    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure PurchOnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
        GenJnlLine.I9G_YourReference := PurchHeader."Your Reference";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    begin
        VendorLedgerEntry.I9G_YourReference := GenJournalLine.I9G_YourReference;
    end;
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
        local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
        begin
            GenJnlLine.I9G_YourReference := SalesHeader."Your Reference";
        end;
        */
    //DX        31 May 2023     New Codeunit to overwrite existing
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
        GenJnlLine.I9G_YourReference := SalesHeader."Your Reference";
    end;
    //DX        31 May 2023
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    begin
        CustLedgerEntry.I9G_YourReference := GenJournalLine.I9G_YourReference;
    end;
    //RL 21 Jul 2022
    //RL 29 Sep 2022
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        GLEntry.I9G_YourReference := GenJournalLine.I9G_YourReference;
    end;
    //RL 29 Sep 2022

    // YF 22 Sep 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertToSalesLine', '', false, false)]
    local procedure OnBeforeInsertToSalesLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line"; FromDocType: Option; RecalcLines: Boolean; var ToSalesHeader: Record "Sales Header"; DocLineNo: Integer; var NextLineNo: Integer; RecalculateAmount: Boolean)
    var
        FromSalesDocType: Enum "Sales Document Type From";
    begin
        if FromDocType = FromSalesDocType::"Posted Shipment".AsInteger() then begin
            ToSalesLine."Order Qty" := FromSalesLine."Qty To Deliver";
            ToSalesLine."FOC Qty" := FromSalesLine."FOC (Qty) To Deliver";
        end;
    end;
    // YF 22 2Sep 2022

    //DX        04 Sept 2023

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterPickAccordingToFEFO', '', false, false)]
    local procedure OnAfterPickAccordingToFEFO(LocationCode: Code[10]; var PickAccordingToFEFO: Boolean; ItemTrackingSetup: Record "Item Tracking Setup" temporary)
    var
        itemRec: Record item;  //DX        04 Sept 2023
    begin
        //itemRec.reset;
        //itemRec.SetLoadFields(SkipFEFOPicking);
        //itemRec.SetRange("No.",);
        //PickAccordingToFEFO := false;

        //For testing
    end;
    //DX        04 Sept 2023

    procedure ResetPOM(DocNo: Code[20])
    var
        SILRec: Record "Sales Invoice Line";
    begin
        SILRec.Reset();
        SILRec.SetRange("Document No.", DocNo);
        if SILRec.FindSet() then begin
            repeat
                SILRec."I9G Line Export" := false;
                SILRec.Modify(false);
            until SILRec.next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCopySelltoCustomerAddressFieldsFromCustomerOnBeforeAssignRespCenter', '', false, false)]
    local procedure OnCopySelltoCustomerAddressFieldsFromCustomerOnBeforeAssignRespCenter(var SalesHeader: Record "Sales Header"; var SellToCustomer: Record Customer; var IsHandled: Boolean)
    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order] then begin
            SalesHeader.I9G_RequirementApproval := SellToCustomer.I9G_RequirementApproval;
        end;
    end;

    //DX        06 march 2025
    procedure UpdatePOForApproval(PORec: code[20]);
    var
        myInt: Integer;
        PHRec: Record "Purchase Header";
    begin

        // PHRec.reset;
        // PHRec.SetRange("Document Type", PHRec."Document Type"::Order);
        // PHRec.SetRange("No.", PORec);
        // if PHRec.FindFirst() then begin
        //     PHRec."Approval Required" := true;
        //     PHRec.Modify(false);
        // end;
    end;
    //DX        06 march 2025

    // YF 24 Mar 2025
    procedure IsPMPCompany(): Boolean
    var
        CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        exit((CompInfo.Name = 'Pan-Malayan Pharmaceuticals Pte Ltd') Or (CompInfo."Custom System Indicator Text" = 'PMP'));
    end;
    // YF 24 Mar 2025
}
