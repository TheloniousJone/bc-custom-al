codeunit 80139 I9G_CreateSalesWhseShipAndPick
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        SalesHeaderRec: Record "Sales Header";
        ResetSalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        I9G_BindSubscriptionCodeunit: Codeunit I9G_BindSubscription;
    begin
        SalesHeaderRec.Reset();
        if SalesHeaderRec.Get(Rec."Record ID to Process") then begin
            //DX        21 nov 2025 to force the record open if it is not open yet.
            //Undo this issue first
            // if SalesHeaderRec.Status <> SalesHeaderRec.Status::Open then begin
            //     SalesHeaderRec.PerformManualReopen(SalesHeaderRec);
            // end;
            //DX        21 nov 2025
            SalesLineRec.Reset();
            SalesLineRec.SetRange("Document Type", SalesHeaderRec."Document Type");
            SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
            if SalesLineRec.FindSet() then begin
                repeat
                    SalesLineRec.Validate("Order Qty");
                    SalesLineRec.Validate("Selling Price", 0);
                    SalesLineRec.Validate("Unit Price", 0);
                    SalesLineRec.Modify();
                until SalesLineRec.Next() = 0;
            end;
            SalesHeaderRec.PerformManualRelease();
            ResetSalesHeaderRec.Reset();
            ResetSalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type");
            ResetSalesHeaderRec.SetRange("No.", SalesHeaderRec."No.");
            if ResetSalesHeaderRec.FindFirst() then begin
                SalesHeaderRec.Reset();
            end;
            /*
            BindSubscription(I9G_BindSubscriptionCodeunit);
            GetSourceDocOutbound.CreateFromSalesOrder(ResetSalesHeaderRec);
            UnbindSubscription(I9G_BindSubscriptionCodeunit);
            */
            GetSourceDocOutbound.CreateFromSalesOrderHideDialog(ResetSalesHeaderRec);
            PickCreate(ResetSalesHeaderRec);
        end;
    end;

    procedure PickCreate(par_SalesHeaderRec: Record "Sales Header")
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
    begin
        WhseShptLine.Reset();
        WhseShptLine.SetRange("Source Type", par_SalesHeaderRec."Document Type");
        WhseShptLine.SetRange("Source No.", par_SalesHeaderRec."No.");
        if WhseShptLine.FindSet() then begin
            WhseShptHeader.Get(WhseShptLine."No.");
            if WhseShptHeader.Status = WhseShptHeader.Status::Open then
                ReleaseWhseShipment.Release(WhseShptHeader);
            repeat
                WhseShptLine.CreatePickDoc(WhseShptLine, WhseShptHeader)
            until WhseShptLine.Next() = 0;
        end;
    end;


    procedure CheckSOEnoughStockPickArea(SHRec: Record "Sales Header"; par_WarehouseCompanyName: Text[250])
    var
        SLRec: Record "Sales Line";
        SLrec2: Record "Sales Line";
        IsLineEnough: Boolean;
        IsOrderEnough: Boolean;
        ItemRec: Record Item; // YF 17 Nov 2021 // Check if Item is Inventory Type
        ItemTotalQty: Decimal;
    begin
        IsLineEnough := true;
        IsOrderEnough := true;
        // IsOrderEnough := SHRec."Out of Stock";

        SLRec.Reset;
        SLRec.SetLoadFields("Document Type", "Document No.", Type, Quantity);
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat
                //DX        16 Oct 2025 Get total qty by item code per SO first.
                clear(ItemTotalQty);
                SLrec2.reset;
                SLRec2.SetLoadFields("Document Type", "Document No.", Type, Quantity);
                SLRec2.SetRange("Document Type", SHRec."Document Type");
                SLRec2.SetRange("Document No.", SHRec."No.");
                SLRec2.SetRange(Type, SLRec.Type::Item);
                SLrec2.SetRange("No.", SLrec."No.");
                SLRec2.SetFilter(Quantity, '<>0');
                SLrec2.CalcSums("Quantity (Base)");
                ItemTotalQty := SLrec2."Quantity (Base)";
                //DX        16 Oct 2025 Get total qty by item code per SO first.
                // YF 17 Nov 2021 // Check if Item is Inventory Type
                ItemRec.Reset;
                ItemRec.ChangeCompany(par_WarehouseCompanyName);
                ItemRec.SetLoadFields("No.", Type);//DX      06 May 2023
                ItemRec.SetRange("No.", SLRec."No.");
                ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                if ItemRec.FindFirst() then begin
                    //DX        16 Oct 2025
                    //if GetNetAvailQtyFromPickArea(SLRec, par_WarehouseCompanyName) - GetUOMBase(SLRec, par_WarehouseCompanyName) >= 0 then begin
                    //DX        16 Oct 2025
                    if GetNetAvailQtyFromPickArea(SLRec, par_WarehouseCompanyName) - ItemTotalQty >= 0 then begin
                        // enough stock for this line

                    end else begin
                        // not enough stock for this line
                        // IsLineEnough := false;
                        // IsOrderEnough := false;
                        // Message(Format(GetUOMBase(SLRec, par_WarehouseCompanyName)));
                        Error(StrSubstNo('Insufficient stock for %1 at PMP-WH in picking area, please replenish before releasing order.', ItemRec."No."));
                    end;
                    // SLRec."Insufficient Stocks in Pick" := Not IsLineEnough;
                    // SLRec.Modify(false);
                end;
            // YF 17 Nov 2021 // Check if Item is Inventory Type
            until SLRec.next = 0;
    end;

    procedure CheckSOEnoughStockPickAreaByLot(SHRec: Record "Sales Header"; par_WarehouseCompanyName: Text[250])
    var
        SLRec: Record "Sales Line";
        SLrec2: Record "Sales Line";
        IsLineEnough: Boolean;
        IsOrderEnough: Boolean;
        ItemRec: Record Item; // YF 17 Nov 2021 // Check if Item is Inventory Type
        ItemTotalQty: Decimal;
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        AvaiLStock: Decimal;
        totalLotQty: Decimal;
    begin
        IsLineEnough := true;
        IsOrderEnough := true;
        // IsOrderEnough := SHRec."Out of Stock";

        SLRec.Reset;
        SLRec.SetLoadFields("Document Type", "Document No.", Type, Quantity);
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter(Quantity, '<>0');

        if SLRec.FindSet() then
            repeat
                //DX        16 Oct 2025 Get total qty by item code per SO first.
                // clear(ItemTotalQty);
                // SLrec2.reset;
                // SLRec2.SetLoadFields("Document Type", "Document No.", Type, Quantity);
                // SLRec2.SetRange("Document Type", SHRec."Document Type");
                // SLRec2.SetRange("Document No.", SHRec."No.");
                // SLRec2.SetRange(Type, SLRec.Type::Item);
                // SLrec2.SetRange("No.", SLrec."No.");
                // SLRec2.SetFilter(Quantity, '<>0');
                // SLrec2.CalcSums("Quantity (Base)");
                // ItemTotalQty := SLrec2."Quantity (Base)";
                //DX        16 Oct 2025 Get total qty by item code per SO first.
                // YF 17 Nov 2021 // Check if Item is Inventory Type
                ItemRec.Reset;
                ItemRec.ChangeCompany(par_WarehouseCompanyName);
                ItemRec.SetLoadFields("No.", Type);//DX      06 May 2023
                ItemRec.SetRange("No.", SLRec."No.");
                ItemRec.SetRange(Type, ItemRec.Type::Inventory);
                if ItemRec.FindFirst() then begin
                    //DX        16 Oct 2025
                    //if GetNetAvailQtyFromPickArea(SLRec, par_WarehouseCompanyName) - GetUOMBase(SLRec, par_WarehouseCompanyName) >= 0 then begin
                    //DX        16 Oct 2025
                    //DX        16 OCt 2025     Get all lot numbers per SO line then loop through to get quantity at PMP WH.
                    ResEntry.reset;
                    ResEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                    ResEntry.SetLoadFields("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                    ResEntry.SetRange("Source ID", SLRec."Document No.");
                    ResEntry.SetRange("Source Type", 37);
                    ResEntry.SetRange("Item No.", SLRec."No.");
                    ResEntry.SetRange("Source Ref. No.", SLRec."Line No.");
                    ResEntry.SetRange("Reservation Status", ResEntry."Reservation Status"::Surplus);
                    if ResEntry.FindSet() then
                        repeat
                            clear(AvaiLStock);
                            //DX        17 Oct 2025     Get unique Lot No. by item first
                            clear(totalLotQty);
                            ResEntry2.reset;
                            ResEntry2.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                            ResEntry2.SetLoadFields("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                            ResEntry2.SetRange("Source ID", SLrec."Document No.");
                            ResEntry2.SetRange("Source Type", 37);
                            ResEntry2.SetRange("Item No.", SLrec."No.");
                            //ResEntry2.SetRange("Source Ref. No.", LineNo);        //count total qty by lot by order and by item no.
                            ResEntry2.SetRange("Lot No.", ResEntry."Lot No.");
                            ResEntry2.SetRange("Reservation Status", ResEntry."Reservation Status"::Surplus);
                            ResEntry2.CalcSums("Quantity (Base)");
                            totalLotQty := Abs(ResEntry2."Quantity (Base)");

                            AvaiLStock := GetNetAvailQtyFromPickAreaByLot(SLrec."No.", SLrec."Document No.", SLrec."Line No.", ResEntry."Lot No.", par_WarehouseCompanyName);
                            //DX        17 Oct 2025     Get unique Lot No. by item first                            
                            if AvaiLStock - totalLotQty >= 0 then begin
                                // enough stock for this line

                            end else begin
                                // not enough stock for this line
                                // IsLineEnough := false;
                                // IsOrderEnough := false;
                                // Message(Format(GetUOMBase(SLRec, par_WarehouseCompanyName)));
                                Error(StrSubstNo('Insufficient stock for %1\Lot : %2\Balance : %3\Required Qty : %4\at PMP-WH in picking area, please replenish before releasing order.',
                                     ItemRec."No.", ResEntry."Lot No.", format(AvaiLStock), Format(totalLotQty)));
                            end;
                        until ResEntry.next = 0;




                    // SLRec."Insufficient Stocks in Pick" := Not IsLineEnough;
                    // SLRec.Modify(false);
                end;
            // YF 17 Nov 2021 // Check if Item is Inventory Type
            until SLRec.next = 0;
    end;



    procedure GetNetAvailQtyFromPickAreaByLot(ItemNo: code[20]; DocNo: Code[20]; LineNo: Integer; LotNo: code[50]; par_WarehouseCompanyName: Text[250]): Decimal
    var
        myInt: Integer;
        BinContent: Record "Bin Content";
        CompInfo: Record "Company Information";
        AvailQty: Decimal;
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        totalLotQty: Decimal;
    begin

        // if (SLRec."Location Code" = CompInfo."Location Code") AND
        // (SLRec.Type = SLRec.Type::Item) and
        // (SLRec."No." <> '') then begin




        BinContent.reset;
        BinContent.ChangeCompany(par_WarehouseCompanyName);
        BinContent.SetRange("Item No.", ItemNo);
        // BinContent.SetRange("Location Code", SLRec."Location Code");//DX        06 Oct 2025 hardcode first for novem
        BinContent.SetRange("Location Code", 'PMP-WH');//DX        06 Oct 2025 hardcode first for novem
        BinContent.setfilter("Bin Type Code", '%1|%2|%3', 'PICK', 'PUTPICK', ''); //RL 01 Mar 2022 - Added Blank Bin type
        BinContent.SetFilter("Lot No. Filter", LotNo);

        if BinContent.FindSet() then
            repeat
                BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)");
                //AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";
                //DX        15 Oct 2025 Only count active stock and stock to be picked.
                AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)";
            until BinContent.next = 0;
        //BinContent.CalcSums("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");       
        exit(AvailQty);

    end;

    procedure GetNetAvailQtyFromPickArea(SLRec: Record "Sales Line"; par_WarehouseCompanyName: Text[250]): Decimal
    var
        myInt: Integer;
        BinContent: Record "Bin Content";
        CompInfo: Record "Company Information";
        AvailQty: Decimal;
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        totalLotQty: Decimal;
    begin

        // if (SLRec."Location Code" = CompInfo."Location Code") AND
        // (SLRec.Type = SLRec.Type::Item) and
        // (SLRec."No." <> '') then begin
        if (SLRec.Type = SLRec.Type::Item) and  ////RL 01 Mar 2022 - remove compinfo.location check
            (SLRec."No." <> '') then begin
            //DX        17 Oct 2025     Get unique Lot No. by item first         
            BinContent.reset;
            BinContent.ChangeCompany(par_WarehouseCompanyName);
            BinContent.SetRange("Item No.", SLRec."No.");
            // BinContent.SetRange("Location Code", SLRec."Location Code");//DX        06 Oct 2025 hardcode first for novem
            BinContent.SetRange("Location Code", 'PMP-WH');//DX        06 Oct 2025 hardcode first for novem
            BinContent.setfilter("Bin Type Code", '%1|%2|%3', 'PICK', 'PUTPICK', ''); //RL 01 Mar 2022 - Added Blank Bin type

            if BinContent.FindSet() then
                repeat
                    BinContent.CalcFields("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
                    //AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)" + BinContent."Put-away Quantity (Base)" - BinContent."ATO Components Pick Qty (Base)" + BinContent."Positive Adjmt. Qty. (Base)" - BinContent."Negative Adjmt. Qty. (Base)";
                    //DX        15 Oct 2025 Only count active stock and stock to be picked.
                    AvailQty += BinContent."Quantity (Base)" - BinContent."Pick Quantity (Base)";
                until BinContent.next = 0;
            //BinContent.CalcSums("Quantity (Base)", "Pick Quantity (Base)", BinContent."Put-away Quantity (Base)", BinContent."ATO Components Pick Qty (Base)", BinContent."Positive Adjmt. Qty. (Base)", BinContent."Negative Adjmt. Qty. (Base)");
            exit(AvailQty);
        end;
    end;

    local procedure GetUOMBase(var SLRec: Record "Sales Line"; par_WarehouseCompanyName: Text[250]): Decimal;        //DX        12 Jun 2023     Added Var to local parameter
    var
        myInt: Integer;
        ItemUom: Record "Item Unit of Measure";
    begin
        ItemUom.reset;
        ItemUom.ChangeCompany(par_WarehouseCompanyName);
        ItemUom.SetLoadFields("Item No.", Code, "Qty. per Unit of Measure");     //DX        02 May 2023
        ItemUom.SetRange("Item No.", SLRec."No.");
        ItemUom.SetRange(Code, SLRec."Unit of Measure Code");
        if ItemUom."Qty. per Unit of Measure" <> 1 then begin
            exit((SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver") * ItemUom."Qty. per Unit of Measure");
        end else
            if ItemUom."Qty. per Unit of Measure" = 1 then
                exit(SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver")

    end;

}