codeunit 56200 "Hyphens PMP Interco CU"
{
    Permissions = tabledata "transfer Shipment Header" = rimd, tabledata "Item Ledger Entry" = rimd, tabledata "Return Shipment Header" = rimd;
    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Dist. Integration", 'OnBeforeInsertPurchLine', '', false, false)]
    local procedure OnBeforeInsertPurchLine(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    begin
        // codes here
    end;
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Dist. Integration", 'OnAfterInsertPurchLine', '', false, false)]
    local procedure OnAfterInsertPurchLine(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    var
        TradeCU: Codeunit "Trade Agreement CU";
        ItemRec: Record Item;
    begin
        // Transfer customized data from Sales Line to Purchase Line
        // PurchaseLine."Order Qty" := SalesLine."Order Qty";
        PurchaseLine."Order Qty" := SalesLine.Quantity;
        PurchaseLine.Modify(false);

        // Recompute Purchase Line
        if (PurchaseLine.Type = PurchaseLine.Type::Item) And (PurchaseLine."Order Qty" <> 0) then begin
            if TradeCU.IsValidPurchaseAgreement_PMPCustomized(PurchaseLine) then begin
                TradeCU.UpdatePLLineFOCQtyAndAmt_PMPCustomized(PurchaseLine);
            end else begin
                // take from item card price
                if ItemRec.Get(PurchaseLine."No.") then begin
                    PurchaseLine.Validate(Quantity, PurchaseLine."Order Qty");
                    PurchaseLine.Validate("FOC Qty", 0);
                    PurchaseLine.Validate("Purchase Price", ItemRec."Last Direct Cost");
                    PurchaseLine.Validate("Direct Unit Cost", ItemRec."Last Direct Cost");
                end;
            end;

            PurchaseLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesDocTransOnAfterICOutBoxSalesLineInsert', '', false, false)]
    local procedure OnCreateOutboxSalesDocTransOnAfterICOutBoxSalesLineInsert(var ICOutboxSalesLine: Record "IC Outbox Sales Line"; SalesLine: Record "Sales Line")
    begin
        // Transfer SO Line custom data
        ICOutboxSalesLine."Order Qty" := SalesLine."Order Qty";
        ICOutboxSalesLine."FOC Qty" := SalesLine."FOC Qty";
        ICOutboxSalesLine."Selling Price" := SalesLine."Selling Price";
        // ICOutboxSalesLine."Qty To Deliver" := SalesLine."Qty To Deliver";
        // ICOutboxSalesLine."FOC Qty To Deliver" := SalesLine."FOC (Qty) To Deliver";
        ICOutboxSalesLine.Modify(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeHandledICOutboxSalesLineInsert', '', false, false)]
    local procedure OnBeforeHandledICOutboxSalesLineInsert(var HandledICOutboxSalesLine: Record "Handled IC Outbox Sales Line"; ICOutboxSalesLine: Record "IC Outbox Sales Line")
    begin
        // Transfer SO Line custom data
        HandledICOutboxSalesLine."Order Qty" := ICOutboxSalesLine."Order Qty";
        HandledICOutboxSalesLine."FOC Qty" := ICOutboxSalesLine."FOC Qty";
        HandledICOutboxSalesLine."Selling Price" := ICOutboxSalesLine."Selling Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeICInboxPurchLineInsert', '', false, false)]
    local procedure OnBeforeICInboxPurchLineInsert(var ICInboxPurchaseLine: Record "IC Inbox Purchase Line"; ICOutboxSalesLine: Record "IC Outbox Sales Line")
    begin
        // Transfer SO Line to PO Line custom data
        ICInboxPurchaseLine."Order Qty" := ICOutboxSalesLine."Order Qty";
        ICInboxPurchaseLine."FOC Qty" := ICOutboxSalesLine."FOC Qty";
        ICInboxPurchaseLine."Purchase Price" := ICOutboxSalesLine."Selling Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchDocumentOnBeforeHandledICInboxPurchLineInsert', '', false, false)]
    local procedure OnCreatePurchDocumentOnBeforeHandledICInboxPurchLineInsert(ICInboxPurchLine: Record "IC Inbox Purchase Line"; var HandledICInboxPurchLine: Record "Handled IC Inbox Purch. Line")
    begin
        // Line custom fields
        HandledICInboxPurchLine."Order Qty" := ICInboxPurchLine."Order Qty";
        HandledICInboxPurchLine."FOC Qty" := ICInboxPurchLine."FOC Qty";
        HandledICInboxPurchLine."Purchase Price" := ICInboxPurchLine."Purchase Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchLinesOnBeforeModify', '', false, false)]
    local procedure OnCreatePurchLinesOnBeforeModify(var PurchaseLine: Record "Purchase Line"; ICInboxPurchLine: Record "IC Inbox Purchase Line");
    begin
        // Line custom fields
        PurchaseLine."Order Qty" := ICInboxPurchLine."Order Qty";
        PurchaseLine."FOC Qty" := ICInboxPurchLine."FOC Qty";
        PurchaseLine."Purchase Price" := ICInboxPurchLine."Purchase Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxPurchDocTransOnAfterICOutBoxPurchLineInsert', '', false, false)]
    local procedure OnCreateOutboxPurchDocTransOnAfterICOutBoxPurchLineInsert(var ICOutboxPurchaseLine: Record "IC Outbox Purchase Line"; PurchaseLine: Record "Purchase Line")
    begin
        ICOutboxPurchaseLine."Order Qty" := PurchaseLine."Order Qty";
        ICOutboxPurchaseLine."FOC Qty" := PurchaseLine."FOC Qty";
        ICOutboxPurchaseLine."Purchase Price" := PurchaseLine."Purchase Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeHandledICOutboxPurchLineInsert', '', false, false)]
    local procedure OnBeforeHandledICOutboxPurchLineInsert(var HandledICOutboxPurchLine: Record "Handled IC Outbox Purch. Line"; ICOutboxPurchLine: Record "IC Outbox Purchase Line")
    begin
        HandledICOutboxPurchLine."Order Qty" := ICOutboxPurchLine."Order Qty";
        HandledICOutboxPurchLine."FOC Qty" := ICOutboxPurchLine."FOC Qty";
        HandledICOutboxPurchLine."Purchase Price" := ICOutboxPurchLine."Purchase Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeICInboxSalesLineInsert', '', false, false)]
    local procedure OnBeforeICInboxSalesLineInsert(var ICInboxSalesLine: Record "IC Inbox Sales Line"; ICOutboxPurchaseLine: Record "IC Outbox Purchase Line")
    begin
        ICInboxSalesLine."Order Qty" := ICOutboxPurchaseLine."Order Qty";
        ICInboxSalesLine."FOC Qty" := ICOutboxPurchaseLine."FOC Qty";
        ICInboxSalesLine."Selling Price" := ICOutboxPurchaseLine."Purchase Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeHandledICInboxSalesLineInsert', '', false, false)]
    local procedure OnBeforeHandledICInboxSalesLineInsert(var HandledICInboxSalesLine: Record "Handled IC Inbox Sales Line"; ICInboxSalesLine: Record "IC Inbox Sales Line")
    begin
        HandledICInboxSalesLine."Order Qty" := ICInboxSalesLine."Order Qty";
        HandledICInboxSalesLine."FOC Qty" := ICInboxSalesLine."FOC Qty";
        HandledICInboxSalesLine."Selling Price" := ICInboxSalesLine."Selling Price";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnAfterCreateSalesLines', '', false, false)]
    local procedure OnAfterCreateSalesLines(ICInboxSalesLine: Record "IC Inbox Sales Line"; var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header")
    begin
        SalesLine."Order Qty" := ICInboxSalesLine."Order Qty";
        SalesLine."FOC Qty" := ICInboxSalesLine."FOC Qty";
        SalesLine."Selling Price" := ICInboxSalesLine."Selling Price";
    end;

    //DX        17 Apr 2023
    //To create PO in PMP when TO is being raised in OH.
    procedure CreatePOinPMP(THRec: Code[20])
    var
        myInt: Integer;
        TSRec: Record "Transfer Shipment Header";
        PHRec: Record "Purchase Header";
        PLRec: Record "Purchase Line";
        ResEntry: Record "Reservation Entry";
        PHRec2: Record "Purchase Header";
        PLRec2: Record "Purchase Line";
        ILERec: Record "Item Ledger Entry";
        LineNo: Integer;
        EntryNo: Integer;
        ResEntry2: Record "Reservation Entry";
        SSSetup: Record "Sales & Receivables Setup";
    begin
        SSSetup.reset;
        SSSetup.get;
        SSSetup.TestField("Default OH Vendor Code");
        SSSetup.TestField("Def PMP WH Location");

        clear(LineNo);
        LineNo := 10000;
        PHRec.reset;
        PHRec.SetRange("Interco Order No", THRec);
        if PHRec.FindFirst() then begin     //If found the same TO Number in PMP entity already
            Error('TO has already been transferred to PO %1 in PMP. Please amend the PO Interco No. if you wish to transfer again.', PHRec."No.");
        end else begin
            PHRec2.reset;
            phrec2.init;
            PHRec2.Validate("Document Type", PHRec2."Document Type"::Order);
            phrec2.Validate("Buy-from Vendor No.", SSSetup."Default OH Vendor Code");
            phrec2.validate("Interco Order No", THRec);       //Record the transfer shipment number in the created PO for reference.
            phrec2.Insert(TRUE);

            //Update the Transfer shipment number in OHPL.
            TSRec.reset;
            tsrec.ChangeCompany('OHPL');
            tsrec.SetRange("No.", THRec);
            if tsrec.FindFirst() then begin
                tsrec.Validate("Interco Order No", PHRec2."No.");
                tsrec.Modify(FALSE);    //Record the created PO Number in OH
            end;
            ILERec.reset;
            ILERec.ChangeCompany('OHPL');
            ILERec.SetRange("Entry Type", ILERec."Entry Type"::Transfer);
            ILERec.SetRange("Document No.", THRec);
            ILERec.SetRange("Document Type", ILERec."Document Type"::"Transfer Shipment");
            ILERec.SetFilter(Quantity, '>0');
            if ILERec.FindSet() then //loop through all posted item ledger entries in OH
                repeat

                    plrec2.reset;
                    plrec2.init;
                    plrec2.Validate("Document Type", PHRec2."Document Type"::Order);
                    plrec2.Validate("Document No.", PHRec2."No.");
                    plrec2.Validate("Line No.", LineNo);
                    plrec2.Validate(Type, plrec2.Type::Item);
                    plrec2.Validate("No.", ILERec."Item No.");
                    PLRec2."Order Qty" := ILERec.Quantity;
                    plrec2.Validate(Quantity, ILERec.Quantity);
                    PLRec2.Validate("Direct Unit Cost", 0);
                    plrec2.Insert(true);

                    ResEntry2.reset;
                    if ResEntry2.FindLast() then
                        EntryNo := ResEntry2."Entry No." + 1
                    else
                        EntryNo := 1;
                    ResEntry.reset;
                    ResEntry.Init();
                    ResEntry.Validate("Entry No.", EntryNo);
                    ResEntry.Validate("Source Type", 39);
                    ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Surplus);
                    ResEntry.Validate("Source Subtype", 1);
                    ResEntry.Validate("Source ID", PHRec2."No.");
                    ResEntry.Validate("Source Ref. No.", PLRec2."Line No.");
                    ResEntry.Validate("Item No.", ILERec."Item No.");
                    ResEntry.Validate("Location Code", SSSetup."Def PMP WH Location");
                    ResEntry.Validate(Quantity, ABS(ILERec.Quantity));
                    ResEntry.Validate("Creation Date", today);
                    ResEntry.Validate("Created By", UserId);
                    ResEntry.Validate("Expected Receipt Date", PHRec2."Expected Receipt Date");
                    ResEntry.Validate("Quantity (Base)", ABS(ILERec.Quantity));
                    ResEntry.Validate("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                    ResEntry.Validate("Qty. to Handle (Base)", ABS(ILERec.Quantity));
                    ResEntry.Validate("Qty. to Invoice (Base)", ABS(ILERec.Quantity));
                    ResEntry.Validate(Positive, true);
                    ResEntry.Validate("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                    ResEntry.Validate("Lot No.", ILERec."Lot No.");
                    ResEntry.Validate("Expiration Date", ILERec."Expiration Date");
                    ResEntry.insert(true);
                    LineNo += 10000;
                until ILERec.next = 0;
        end;
    end;

    procedure CreateTOinOH(THRec: Code[20])
    var
        myInt: Integer;
        TSRec: Record "Transfer Header";
        PHRec: Record "Return Shipment Header";
        PLRec: Record "Purchase Line";
        ResEntry: Record "Reservation Entry";
        THRec2: Record "Transfer Header";
        TLRec2: Record "Transfer Line";
        ILERec: Record "Item Ledger Entry";
        LineNo: Integer;
        EntryNo: Integer;
        ResEntry2: Record "Reservation Entry";
        SSSetup: Record "Sales & Receivables Setup";
    begin
        SSSetup.reset;
        SSSetup.get;
        //SSSetup.TestField("Default OH Vendor Code");
        SSSetup.TestField("Def PMP WH Location");

        clear(LineNo);
        LineNo := 10000;
        TSRec.reset;
        TSRec.SetRange("Interco Order No", THRec);
        if NOT (TSRec.FindFirst()) then begin     //If found the same return order number in OH

            THRec2.reset;
            THRec2.init;
            THRec2.Validate("Transfer-from Code", SSSetup."Def PMP WH Location");
            THRec2.Validate("Transfer-to Code", 'W1');
            THRec2.Validate("In-Transit Code", 'TRANSIT');
            THRec2.validate("Interco Order No", THRec);       //Record the transfer shipment number in the created PO for reference.
            THRec2.Insert(TRUE);

            //Update the Transfer shipment number in OHPL.
            PHRec.reset;
            PHRec.ChangeCompany('PMP');
            PHRec.SetRange("No.", THRec);
            if PHRec.FindFirst() then begin
                PHRec.Validate("Interco Order No.", THRec2."No.");
                PHRec.Modify(FALSE);    //Record the created PO Number in OH
            end;
            ILERec.reset;
            ILERec.ChangeCompany('PMP');
            ILERec.SetRange("Entry Type", ILERec."Entry Type"::Purchase);
            ILERec.SetRange("Document No.", THRec);
            ILERec.SetRange("Document Type", ILERec."Document Type"::"Purchase Return Shipment");
            ILERec.SetFilter(Quantity, '<0');
            if ILERec.FindSet() then //loop through all posted item ledger entries in OH
                repeat

                    TLRec2.reset;
                    TLRec2.init;
                    TLRec2.Validate("Document No.", THRec2."No.");
                    TLRec2.Validate("Line No.", LineNo);
                    TLRec2.Validate("Item No.", ILERec."Item No.");
                    TLRec2.Validate(Quantity, abs(ILERec.Quantity));
                    TLRec2.Insert(true);

                    ResEntry2.reset;
                    if ResEntry2.FindLast() then
                        EntryNo := ResEntry2."Entry No." + 1
                    else
                        EntryNo := 1;

                    //Create Negative line first as per default BC
                    ResEntry.reset;
                    ResEntry.Init();
                    ResEntry.Validate("Entry No.", EntryNo);
                    ResEntry.Validate("Source Type", 5741);
                    ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Surplus);
                    ResEntry.Validate("Source Subtype", 0);
                    ResEntry.Validate("Source ID", THRec2."No.");
                    ResEntry.Validate("Source Ref. No.", TLRec2."Line No.");
                    ResEntry.Validate("Item No.", ILERec."Item No.");
                    ResEntry.Validate("Location Code", THRec2."Transfer-from Code");
                    ResEntry.Validate(Quantity, ABS(ILERec.Quantity));
                    ResEntry.Validate("Creation Date", today);
                    ResEntry.Validate("Created By", UserId);
                    ResEntry.Validate("Shipment Date", THRec2."Shipment Date");
                    ResEntry.Validate("Quantity (Base)", ABS(ILERec.Quantity) * -1);
                    ResEntry.Validate("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                    ResEntry.Validate("Qty. to Handle (Base)", ABS(ILERec.Quantity) * -1);
                    ResEntry.Validate("Qty. to Invoice (Base)", ABS(ILERec.Quantity) * -1);
                    ResEntry.Validate(Positive, false);
                    ResEntry.Validate("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                    ResEntry.Validate("Lot No.", ILERec."Lot No.");
                    ResEntry.Validate("Expiration Date", ILERec."Expiration Date");
                    ResEntry.insert(true);
                    LineNo += 10000;

                    //Create Postive line next as per default BC
                    ResEntry.reset;
                    ResEntry.Init();
                    ResEntry.Validate("Entry No.", EntryNo + 1);
                    ResEntry.Validate("Source Type", 5741);
                    ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Surplus);
                    ResEntry.Validate("Source Subtype", 1);
                    ResEntry.Validate("Source ID", THRec2."No.");
                    ResEntry.Validate("Source Ref. No.", TLRec2."Line No.");
                    ResEntry.Validate("Item No.", ILERec."Item No.");
                    ResEntry.Validate("Location Code", THRec2."Transfer-to Code");
                    ResEntry.Validate(Quantity, ABS(ILERec.Quantity));
                    ResEntry.Validate("Creation Date", today);
                    ResEntry.Validate("Created By", UserId);
                    ResEntry.Validate("Expected Receipt Date", THRec2."Shipment Date");
                    ResEntry.Validate("Quantity (Base)", ABS(ILERec.Quantity));
                    ResEntry.Validate("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                    ResEntry.Validate("Qty. to Handle (Base)", ABS(ILERec.Quantity));
                    ResEntry.Validate("Qty. to Invoice (Base)", ABS(ILERec.Quantity));
                    ResEntry.Validate(Positive, true);
                    ResEntry.Validate("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                    ResEntry.Validate("Lot No.", ILERec."Lot No.");
                    ResEntry.Validate("Expiration Date", ILERec."Expiration Date");
                    ResEntry.insert(true);
                    LineNo += 10000;
                until ILERec.next = 0;
        end else begin
            Error('Purchase Return has already been transferred to %1 in OHPL. Please amend the Interco No. if you wish to transfer again.', TSRec."No.");
        end;
    end;

    procedure isOHItemInPMPEntity(Itemno: Code[20]): Boolean;
    var
        myInt: Integer;
        itemRec: Record item;
        SSSetup: Record "Sales & Receivables Setup";
    begin
        SSSetup.reset;
        SSSetup.ChangeCompany('PMP');
        SSSetup.get;
        SSSetup.TestField("Def. OH Item Gen Prod");
        itemRec.reset;
        itemRec.ChangeCompany('PMP');
        itemRec.SetRange("No.", Itemno);
        if itemRec.FindFirst() then begin
            if itemRec."Gen. Prod. Posting Group" <> SSSetup."Def. OH Item Gen Prod" then
                exit(false)
            else
                exit(true);
        end;
    end;

    procedure ResetTransferStatus(var ILERec: Record "Item Ledger Entry")
    var
        myInt: Integer;
    begin
        ILERec."Transferred to OH" := false;
        ILERec.Modify(FALSE);
    end;

    procedure ResetInvoiceStatus(var ILERec: Record "Item Ledger Entry")
    var
        myInt: Integer;
    begin
        ILERec."Invoiced to OH" := false;
        ILERec.Modify(FALSE);
    end;

    procedure ResetOHTransfer(var RetShip: Record "Return Shipment Header")
    var
        myInt: Integer;
    begin
        RetShip."Interco Order No." := '';
        RetShip.Modify(FALSE);
    end;

    procedure UpdateTransferStatus(EntryNo: Integer)
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
    begin
        ILERec.reset;
        ILERec.ChangeCompany('PMP');
        ILERec.SetRange("Entry No.", EntryNo);
        if ILERec.FindFirst() then begin
            ILERec."Transferred to OH" := true;
            ILERec.Modify(FALSE);
        end;
    end;

    procedure UpdateOHInvoiceStatus(EntryNo: Integer)
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
    begin
        ILERec.reset;
        ILERec.ChangeCompany('PMP');
        ILERec.SetRange("Entry No.", EntryNo);
        if ILERec.FindFirst() then begin
            ILERec."Invoiced to OH" := true;
            ILERec.Modify(FALSE);
        end;
    end;


    procedure CheckItemLotNo(ItemNo: code[20]; LotNo: Code[100])
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";
    begin
        ItemRec.reset;
        ItemRec.SetRange("No.", ItemNo);
        if not (ItemRec.FindFirst()) then begin
            Error('Item %1 does not exist in the current company, please create first before processing.', ItemNo);
        end else begin
            ILERec.reset;
            ILERec.SetRange("Item No.", ItemNo);
            ILERec.SetRange("Lot No.", LotNo);
            if not (ILERec.FindFirst()) then
                Error('Lot No. %1 does not exist for Item %2, please check again.', LotNo, ItemNo);
        end;

    end;


    //DX        17 Apr 2023

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnCheckWarehouseOnBeforeShowDialog', '', false, false)]
    // local procedure "Sales Line_OnCheckWarehouseOnBeforeShowDialog"(var SalesLine: Record "Sales Line"; Location: Record Location; var ShowDialog: Option; var DialogText: Text[50])
    // begin
    //     DialogText := DialogText + '-' + SalesLine."No.";
    // end;

}