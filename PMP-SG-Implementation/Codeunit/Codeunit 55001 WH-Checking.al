codeunit 55001 "WH-Checking"
{

    //DX        16 July 2021        After post warehouse invoice, then auto complete checking
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterSalesPost', '', true, true)]
    // procedure OnAfterSalesPost(SalesHeader: Record "Sales Header"; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    // var
    //     PMPCU: Codeunit "WH-Checking";
    //     ALERec: Record "Assignment Ledger Entry";
    //     CheckRec: Record "Checking Header";
    // begin
    //     ALERec.reset;
    //     ALERec.SetLoadFields("Document No.", Status, "Checking Doc No.");    //DX    03 May 2023
    //     ALERec.SetCurrentKey("Document No.");       //DX        29 May 2023
    //     ALERec.SetAscending("Document No.", false);      //DX        29 May 2023
    //     ALERec.SetRange("Document No.", SalesHeader."No.");
    //     ALERec.SetRange(Status, ALERec.Status::Checking);
    //     if ALERec.FindFirst() then begin
    //         CheckRec.reset;
    //         CheckRec.SetRange("No.", ALERec."Checking Doc No.");
    //         if CheckRec.FindFirst() then
    //             PMPCU.CompleteChecking(CheckRec);
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Whse. Post Shipment", 'OnAfterSalesPost', '', true, true)]
    local procedure SalesWhsePostShipment_OnAfterSalesPost(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SalesHeader: Record "Sales Header"; WhsePostParameters: Record "Whse. Post Parameters")
    var
        PMPCU: Codeunit "WH-Checking";
        ALERec: Record "Assignment Ledger Entry";
        CheckRec: Record "Checking Header";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Document No.", Status, "Checking Doc No.");    //DX    03 May 2023
        ALERec.SetCurrentKey("Document No.", Status);       //DX        29 May 2023
        ALERec.SetAscending("Document No.", false);      //DX        29 May 2023
        ALERec.SetRange("Document No.", SalesHeader."No.");
        ALERec.SetRange(Status, ALERec.Status::Checking);
        if ALERec.FindFirst() then begin
            CheckRec.reset;
            CheckRec.SetRange("No.", ALERec."Checking Doc No.");
            if CheckRec.FindFirst() then
                PMPCU.CompleteChecking(CheckRec);
        end;
    end;

    //DX        19 Oct 2021
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterPurchPost', '', true, true)]
    // procedure OnAfterPurchPost(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; PurchaseHeader: Record "Purchase Header")
    // var
    //     PMPCU: Codeunit "WH-Checking";
    //     ALERec: Record "Assignment Ledger Entry";
    //     CheckRec: Record "Checking Header";
    // begin

    //     ALERec.reset;
    //     ALERec.SetLoadFields("Document No.", Status, "Checking Doc No.");     //DX        29 May 2023
    //     ALERec.SetRange("Document No.", PurchaseHeader."No.");
    //     ALERec.SetCurrentKey("Document No.");       //DX        29 May 2023
    //     ALERec.SetAscending("Document No.", false);      //DX        29 May 2023
    //     ALERec.SetRange(Status, ALERec.Status::Checking);
    //     if ALERec.FindFirst() then begin
    //         CheckRec.reset;
    //         CheckRec.SetRange("No.", ALERec."Checking Doc No.");
    //         if CheckRec.FindFirst() then
    //             PMPCU.CompleteChecking(CheckRec);
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Whse. Post Shipment", 'OnAfterPurchPost', '', true, true)]
    local procedure PurchWhsePostShipment_OnAfterPurchPost(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; PurchaseHeader: Record "Purchase Header"; WhsePosrParameters: Record "Whse. Post Parameters"; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        PMPCU: Codeunit "WH-Checking";
        ALERec: Record "Assignment Ledger Entry";
        CheckRec: Record "Checking Header";
    begin

        ALERec.reset;
        ALERec.SetLoadFields("Document No.", Status, "Checking Doc No.");     //DX        29 May 2023
        ALERec.SetRange("Document No.", PurchaseHeader."No.");
        ALERec.SetCurrentKey("Document No.", Status);       //DX        29 May 2023
        ALERec.SetAscending("Document No.", false);      //DX        29 May 2023
        ALERec.SetRange(Status, ALERec.Status::Checking);
        if ALERec.FindFirst() then begin
            CheckRec.reset;
            CheckRec.SetRange("No.", ALERec."Checking Doc No.");
            if CheckRec.FindFirst() then
                PMPCU.CompleteChecking(CheckRec);
        end;
    end;

    //DX        19 Oct 2021
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterTransferPostShipment', '', true, true)]
    // procedure OnAfterTransferPostShipment(TransferHeader: Record "Transfer Header"; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    // var
    //     PMPCU: Codeunit "WH-Checking";
    //     ALERec: Record "Assignment Ledger Entry";
    //     CheckRec: Record "Checking Header";
    // begin

    //     ALERec.reset;
    //     ALERec.SetLoadFields("Document No.", Status, "Checking Doc No.");     //DX        29 May 2023
    //     ALERec.SetCurrentKey("Document No.");       //DX        29 May 2023
    //     ALERec.SetRange("Document No.", TransferHeader."No.");
    //     ALERec.SetRange(Status, ALERec.Status::Checking);
    //     if ALERec.FindFirst() then begin
    //         CheckRec.reset;
    //         CheckRec.SetRange("No.", ALERec."Checking Doc No.");
    //         if CheckRec.FindFirst() then
    //             PMPCU.CompleteChecking(CheckRec);
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Whse. Post Shipment", 'OnAfterTransferPostShipment', '', true, true)]
    local procedure TransferWhsePostShipment_OnAfterTransferPostShipment(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; TransferHeader: Record "Transfer Header"; WhsePostParameters: Record "Whse. Post Parameters")
    var
        PMPCU: Codeunit "WH-Checking";
        ALERec: Record "Assignment Ledger Entry";
        CheckRec: Record "Checking Header";
    begin

        ALERec.reset;
        ALERec.SetLoadFields("Document No.", Status, "Checking Doc No.");     //DX        29 May 2023
        ALERec.SetCurrentKey("Document No.", Status);       //DX        29 May 2023
        ALERec.SetRange("Document No.", TransferHeader."No.");
        ALERec.SetRange(Status, ALERec.Status::Checking);
        if ALERec.FindFirst() then begin
            CheckRec.reset;
            CheckRec.SetRange("No.", ALERec."Checking Doc No.");
            if CheckRec.FindFirst() then
                PMPCU.CompleteChecking(CheckRec);
        end;
    end;
    //DX        16 July 2021

    procedure IscoldPickList(BasketCode: Code[20]): Boolean
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetLoadFields(Basket, "Checking Doc No.", "Picking Doc No.", "Driver Doc No.");  //DX        06 May 2023
        ALERec.SetRange(Basket, BasketCode);
        //ALERec.SetRange("2nd Basket Code", '');
        ALERec.SetFilter("Checking Doc No.", '');
        ALERec.SetFilter("Picking Doc No.", '<>%1', '');
        ALERec.SetFilter("Driver Doc No.", '');
        if NOT (ALERec.IsEmpty()) then begin
            exit(false);
        end else begin
            ALERec.reset;
            ALERec.SetLoadFields("2nd Basket Code", "Checking Doc No.", "Picking Doc No.", "Driver Doc No.");   //DX        06 May 2023
            //ALERec.SetRange(Basket, '');
            ALERec.SetRange("2nd Basket Code", BasketCode);
            ALERec.SetFilter("Checking Doc No.", '');
            ALERec.SetFilter("Picking Doc No.", '<>%1', '');
            ALERec.SetFilter("Driver Doc No.", '');
            if not (ALERec.IsEmpty) then begin
                exit(true);
            end;
        end;
    end;

    procedure CreateCheckingCard(var CheckRec: Record "Checking Header"; BasketCode: Code[20])
    var
        myInt: Integer;
        DocNo: code[20];
        CheckLineRec: Record "Checking Line";
        RegWhseActRec: Record "Registered Whse. Activity Hdr.";
        WhseActLineRec: Record "Registered Whse. Activity Line";
        AssignmentLedger: Record "Assignment Ledger Entry";
        SHRec: Record "Sales Header";
        TORec: Record "Transfer Header";
        PHRec: Record "Purchase Header";
        TBARec: Record "TBA Ledger Entry";
        CustRec: Record customer;
        LocRec: Record location;
        ALERec: Record "Assignment Ledger Entry";
        ItemRec: Record Item;
        EnhanceCU: Codeunit "PMP-Enhancements";
        ColdExist: Boolean;
        NonColdExist: Boolean;
        AORec: Record "Assembly Header";
    begin
        ALERec.reset;
        ALERec.SetLoadFields(Basket, "2nd Basket Code", "Checking Doc No.", "Picking Doc No.", "Driver Doc No.", Status, Picker); //DX        06 May 2023
        if NOT (IscoldPickList(BasketCode)) then
            ALERec.SetRange(Basket, BasketCode)
        else
            ALERec.SetRange("2nd Basket Code", BasketCode);

        ALERec.SetFilter("Checking Doc No.", '');
        ALERec.SetFilter("Picking Doc No.", '<>%1', '');
        ALERec.SetFilter("Driver Doc No.", '');
        ALERec.SetRange(Status, ALERec.Status::"Pending Checking");     //DX        16 July 2021
        if ALERec.FindFirst() then begin
            CheckRec.init;
            CheckRec.Validate("No.", ALERec."Picking Doc No.");
            DocNo := ALERec."Picking Doc No.";
            //DX        07 Sept 2021
            CheckRec.Validate("Basket No.", AleRec.Basket);
            CheckRec.Validate(Picker, ALERec.Picker);
            CheckRec.Validate("2nd Basket No.", ALERec."2nd Basket Code");
            CheckRec."Cold Shipping Packages" := 1;
            checkrec."Non-Cold Shipping Packages" := 1;
            //DX        07 Sept 2021
            CheckRec.Validate("Start Time", CurrentDateTime);

            CheckRec.Insert(true);

        end;
        RegWhseActRec.reset;
        RegWhseActRec.SetRange("Whse. Activity No.", DocNo);
        if not (RegWhseActRec.FindFirst()) then begin
        end else begin
            LocRec.reset;
            LocRec.SetRange(Code, RegWhseActRec."Location Code");
            if LocRec.FindFirst() then begin end;
            WhseActLineRec.reset;
            WhseActLineRec.SetRange("No.", RegWhseActRec."No.");
            //DX        17 Oct 2021 If assemblhy PL, den filter by place, to avoid break bulk
            if IsAOPL(CheckRec) then
                WhseActLineRec.SetRange("Action Type", WhseActLineRec."Action Type"::Place)
            else
                WhseActLineRec.SetRange("Bin Code", LocRec."Shipment Bin Code");
            //DX        17 Oct 2021

            if WhseActLineRec.FindFirst() then begin
                if WhseActLineRec."Source Document" = WhseActLineRec."Source Document"::"Sales Order" then begin
                    SHRec.reset;
                    SHRec.SetLoadFields("Sell-to Customer No.", "Sell-to Customer Name", "Picking Instructions", "Posting Date", "Delivery Zone", "Delivery Charge"); //DX        06 May 2023
                    SHRec.SetRange("No.", WhseActLineRec."Source No.");
                    if SHRec.FindFirst() then begin
                        CheckRec."Customer No." := SHRec."Sell-to Customer No.";
                        checkrec."Customer Name" := SHRec."Sell-to Customer Name";
                        CheckRec."Picking Instruction" := SHRec."Picking Instructions"; //RL 20 Dec 2021
                        // CheckRec.Checker := UserId;       //DX        18 July 2021 : Change to update checker ID when printing waybill slip instead
                        //RL    04 Mar 2022 - Start
                        if CheckRec."Basket No." <> '' then
                            CheckRec.Checker := UserId;
                        if CheckRec."2nd Basket No." <> '' then
                            CheckRec."2nd Checker ID" := UserId;
                        //RL    04 Mar 2022 - End
                        AssignmentLedger.reset;
                        AssignmentLedger.SetCurrentKey("Document No.", Status, "Invoice No.");
                        AssignmentLedger.SetRange("Document No.", WhseActLineRec."Source No.");
                        AssignmentLedger.SetRange(Status, AssignmentLedger.Status::"Pending Checking");
                        AssignmentLedger.SetRange("Invoice No.", '');
                        if AssignmentLedger.FindFirst() then begin
                            CheckRec.Picker := AssignmentLedger.Picker;
                            AssignmentLedger."Check Start Time" := CheckRec."Start Time";
                            AssignmentLedger."Checking Doc No." := CheckRec."No.";
                            AssignmentLedger.Status := AssignmentLedger.Status::Checking;
                            //RL    04 Mar 2022 - Start
                            if CheckRec."Basket No." <> '' then
                                AssignmentLedger."Checker ID" := UserId;
                            if CheckRec."2nd Basket No." <> '' then
                                AssignmentLedger."2nd Checker ID" := UserId;
                            //RL    04 Mar 2022 - End
                            AssignmentLedger.Modify(TRUE);
                        end;

                        CheckRec."Posting Date" := SHRec."Posting Date";
                        CheckRec.Status := CheckRec.Status::Checking;
                        //CheckRec."Start Time" := CurrentDateTime;
                        //DX       06 Oct 2021                 
                        CheckRec."Shipping Bin" := SHRec."Delivery Zone";
                        CheckRec."Delivery Charge" := SHRec."Delivery Charge";
                        //DX       06 Oct 2021

                        //YT - 07/10/2025 - Add event for Novem-PMP interco usage
                        OnInsertOnBeforeModifySalesDetails(CheckRec, SHRec);
                        //YT - 07/10/2025 - Add event for Novem-PMP interco usage

                        CheckRec.Modify(true);
                        WarehouseCU.UpdateOrderStatus(CheckRec."No.", 'Checking');

                    end;
                end else
                    if WhseActLineRec."Source Document" = WhseActLineRec."Source Document"::"Outbound Transfer" then begin
                        TORec.reset;
                        TORec.SetLoadFields("No.", "Transfer-to Code", "Transfer-to Name", "Posting Date"); //DX        06 May 2023
                        TORec.SetRange("No.", WhseActLineRec."Source No.");
                        if TORec.FindFirst() then begin
                            CheckRec."Customer No." := TORec."Transfer-to Code";
                            checkrec."Customer Name" := TORec."Transfer-to Name";
                            // CheckRec.Checker := UserId;       //DX        18 July 2021 : Change to update checker ID when printing waybill slip instead
                            //RL    04 Mar 2022 - Start
                            if CheckRec."Basket No." <> '' then
                                CheckRec.Checker := UserId;
                            if CheckRec."2nd Basket No." <> '' then
                                CheckRec."2nd Checker ID" := UserId;
                            //RL    04 Mar 2022 - End
                            CheckRec."Posting Date" := TORec."Posting Date";
                            CheckRec.Status := CheckRec.Status::Checking;
                            AssignmentLedger.reset;
                            AssignmentLedger.SetCurrentKey("Document No.", Status);
                            AssignmentLedger.SetRange("Document No.", WhseActLineRec."Source No.");
                            AssignmentLedger.SetRange(Status, AssignmentLedger.Status::"Pending Checking");
                            //AssignmentLedger.SetRange("Invoice No.", '');
                            if AssignmentLedger.FindFirst() then begin
                                CheckRec.Picker := AssignmentLedger.Picker;
                                AssignmentLedger."Check Start Time" := CheckRec."Start Time";
                                AssignmentLedger."Checking Doc No." := CheckRec."No.";
                                AssignmentLedger.Status := AssignmentLedger.Status::Checking;
                                //RL    04 Mar 2022 - Start
                                if CheckRec."Basket No." <> '' then
                                    AssignmentLedger."Checker ID" := UserId;
                                if CheckRec."2nd Basket No." <> '' then
                                    AssignmentLedger."2nd Checker ID" := UserId;
                                //RL    04 Mar 2022 - End
                                AssignmentLedger.Modify(TRUE);
                            end;
                            CheckRec."Start Time" := CurrentDateTime;

                            //YT - 07/10/2025 - Add event for Novem-PMP interco usage
                            OnInsertOnBeforeModifyTransferDetails(CheckRec, TORec);
                            //YT - 07/10/2025 - Add event for Novem-PMP interco usage

                            CheckRec.Modify(true);
                            WarehouseCU.UpdateOrderStatus(CheckRec."No.", 'Checking');
                        end;
                    end else
                        if WhseActLineRec."Source Document" = WhseActLineRec."Source Document"::"Assembly Consumption" then begin
                            AORec.reset;
                            AORec.SetRange("No.", WhseActLineRec."Source No.");
                            if AORec.FindFirst() then begin
                                CheckRec."Customer No." := AORec."No.";
                                checkrec."Customer Name" := 'Assembly';
                                // CheckRec.Checker := UserId;       //DX        18 July 2021 : Change to update checker ID when printing waybill slip instead
                                //RL    04 Mar 2022 - Start
                                if CheckRec."Basket No." <> '' then
                                    CheckRec.Checker := UserId;
                                if CheckRec."2nd Basket No." <> '' then
                                    CheckRec."2nd Checker ID" := UserId;
                                //RL    04 Mar 2022 - End
                                CheckRec."Posting Date" := AORec."Posting Date";
                                CheckRec.Status := CheckRec.Status::Checking;
                                AssignmentLedger.reset;
                                AssignmentLedger.SetRange("Document No.", WhseActLineRec."Source No.");
                                AssignmentLedger.SetRange(Status, AssignmentLedger.Status::"Pending Checking");
                                //AssignmentLedger.SetRange("Invoice No.", '');
                                if AssignmentLedger.FindFirst() then begin
                                    CheckRec.Picker := AssignmentLedger.Picker;
                                    AssignmentLedger."Check Start Time" := CheckRec."Start Time";
                                    AssignmentLedger."Checking Doc No." := CheckRec."No.";
                                    AssignmentLedger.Status := AssignmentLedger.Status::Checking;
                                    //RL    04 Mar 2022 - Start
                                    if CheckRec."Basket No." <> '' then
                                        AssignmentLedger."Checker ID" := UserId;
                                    if CheckRec."2nd Basket No." <> '' then
                                        AssignmentLedger."2nd Checker ID" := UserId;
                                    //RL    04 Mar 2022 - End
                                    AssignmentLedger.Modify(TRUE);
                                end;
                                CheckRec."Start Time" := CurrentDateTime;

                                CheckRec.Modify(true);
                                WarehouseCU.UpdateOrderStatus(CheckRec."No.", 'Checking');
                            end;
                        end else
                            if WhseActLineRec."Source Document" = WhseActLineRec."Source Document"::"Purchase Return Order" then begin
                                PHRec.reset;
                                PHRec.SetRange("No.", WhseActLineRec."Source No.");
                                if PHRec.FindFirst() then begin
                                    CheckRec."Customer No." := PHRec."Buy-from Vendor No.";
                                    checkrec."Customer Name" := PHRec."Buy-from Vendor Name";
                                    // CheckRec.Checker := UserId;       //DX        18 July 2021 : Change to update checker ID when printing waybill slip instead
                                    //RL    04 Mar 2022 - Start
                                    if CheckRec."Basket No." <> '' then
                                        CheckRec.Checker := UserId;
                                    if CheckRec."2nd Basket No." <> '' then
                                        CheckRec."2nd Checker ID" := UserId;
                                    //RL    04 Mar 2022 - End
                                    CheckRec."Posting Date" := PHRec."Posting Date";
                                    CheckRec.Status := CheckRec.Status::Checking;
                                    AssignmentLedger.reset;
                                    AssignmentLedger.SetRange("Document No.", WhseActLineRec."Source No.");
                                    AssignmentLedger.SetRange(Status, AssignmentLedger.Status::"Pending Checking");
                                    //AssignmentLedger.SetRange("Invoice No.", '');
                                    if AssignmentLedger.FindFirst() then begin
                                        CheckRec.Picker := AssignmentLedger.Picker;
                                        AssignmentLedger."Check Start Time" := CheckRec."Start Time";
                                        AssignmentLedger."Checking Doc No." := CheckRec."No.";
                                        AssignmentLedger.Status := AssignmentLedger.Status::Checking;
                                        //RL    04 Mar 2022 - Start
                                        if CheckRec."Basket No." <> '' then
                                            AssignmentLedger."Checker ID" := UserId;
                                        if CheckRec."2nd Basket No." <> '' then
                                            AssignmentLedger."2nd Checker ID" := UserId;
                                        //RL    04 Mar 2022 - End
                                        AssignmentLedger.Modify(TRUE);
                                    end;
                                    CheckRec."Start Time" := CurrentDateTime;

                                    CheckRec.Modify(true);
                                    WarehouseCU.UpdateOrderStatus(CheckRec."No.", 'Checking');
                                end;
                            end;
                ColdExist := false;
                NonColdExist := false;
                If WhseActLineRec.FindSet() then
                    repeat
                        CheckLineRec.reset;
                        CheckLineRec."Doc No." := CheckRec."No.";
                        CheckLineRec."Line No." := WhseActLineRec."Line No.";
                        CheckLineRec."Item No." := WhseActLineRec."Item No.";
                        CheckLineRec.Description := WhseActLineRec.Description;
                        CheckLineRec.Quantity := WhseActLineRec.Quantity;
                        CheckLineRec."Qty. Per Unit Of Measure" := WhseActLineRec."Qty. per Unit of Measure";
                        CheckLineRec."Unit of Measure Code" := WhseActLineRec."Unit of Measure Code";
                        CheckLineRec.Cubage := WhseActLineRec.Cubage;
                        CheckLineRec.Weight := WhseActLineRec.Weight;
                        CheckLineRec."Qty. Base" := WhseActLineRec."Qty. (Base)";
                        //DX        18 Jul 2021
                        ItemRec.reset;
                        ItemRec.SetLoadFields("Storage Condition");
                        ItemRec.SetRange("No.", WhseActLineRec."Item No.");
                        if ItemRec.FindFirst() then begin
                            if ItemRec."Storage Condition" = ItemRec."Storage Condition"::Fridge then begin

                                ColdExist := true;
                                CheckLineRec."Cold Room Item" := true
                            end else begin
                                NonColdExist := true;
                                CheckLineRec."Cold Room Item" := false;
                            end;

                        end;
                        //DX        18 Jul 2021
                        //DX            28 July 2021
                        CheckLineRec."Lot No." := WhseActLineRec."Lot No.";
                        CheckLineRec."Expiration Date" := WhseActLineRec."Expiration Date";
                        //DX            28 July 2021
                        CheckLineRec.Insert(TRUE);
                    until WhseActLineRec.next = 0;
            end;

        end;
    end;

    //YT - 07/10/2025 - Add event for Novem-PMP interco usage
    [IntegrationEvent(false, false)]
    local procedure OnInsertOnBeforeModifySalesDetails(var CheckRec: Record "Checking Header"; SalesHeaderRec: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertOnBeforeModifyTransferDetails(var CheckRec: Record "Checking Header"; TransferHeaderRec: Record "Transfer Header")
    begin
    end;
    //YT - 07/10/2025 - Add event for Novem-PMP interco usage

    procedure CompleteChecking(var CheckRec: Record "Checking Header")
    var
        myInt: Integer;
        ALE: Record "Assignment Ledger Entry";
        WHCU: Codeunit "Warehouse CU";
    begin
        //if CheckRec."Shipping Bin" = '' then
        //    Error('Please ensure shipping cage is entered before completing the checking');

        CheckRec.Status := CheckRec.Status::Completed;
        CheckRec."End Time" := CreateDateTime(today, Time);
        CheckRec.Modify(TRUE);

        //DX        120521      Update ALE to reflect the correct information.
        ALE.Reset();
        ALE.SetCurrentKey("Picking Doc No.");       //DX        30 May 2023
        ALE.SetRange("Picking Doc No.", CheckRec."No.");
        if ALE.FindFirst() then begin
            ALE."Check End Time" := CheckRec."End Time";
            ALE.Modify(TRUE);
            //DX        120521      Upodate order status to picking after trip has been created.
            WHCU.UpdateOrderStatus(CheckRec."No.", 'Pending Delivery');

        end;
    end;

    procedure CreateTBACheckingLinesInCheckRec(var CheckRec: Record "Checking Header")
    var
        LineNo: Integer;
        TBALedger: Record "TBA Ledger Entry";
        CheckLineRec: Record "Checking Line";
        ALERec: Record "Assignment Ledger Entry";
        TBACU: Codeunit TBA;
    begin
        LineNo := 10000;

        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", CheckRec."No.");     //TBA DO No. is the same Picking doc no. for ALE Table
        if ALERec.FindFirst() then begin
            ALERec."Checking Doc No." := CheckRec."No.";
            ALERec."Check Start Time" := CheckRec."Start Time";
            ALERec.Status := ALERec.Status::Checking;
            //RL    04 Mar 2022 - Start
            if CheckRec."Basket No." <> '' then
                ALERec."Checker ID" := UserId;
            if CheckRec."2nd Basket No." <> '' then
                ALERec."2nd Checker ID" := UserId;
            //RL    04 Mar 2022 - End
            ALERec.Modify(TRUE);

            CheckRec."Customer No." := ALERec."Customer No.";
            CheckRec."Customer Name" := ALERec."Customer Name";
            CheckRec.Picker := ALERec.Picker;
            // CheckRec.Checker := UserId;       //DX        18 July 2021 : Change to update checker ID when printing waybill slip instead
            //RL    04 Mar 2022 - Start
            if CheckRec."Basket No." <> '' then
                CheckRec.Checker := UserId;
            if CheckRec."2nd Basket No." <> '' then
                CheckRec."2nd Checker ID" := UserId;
            //RL    04 Mar 2022 - End
            CheckRec.Status := CheckRec.Status::Checking;
            CheckRec.Modify(TRUE);
        end;
    end;

    procedure PickListExists(DocNo: code[20]) DoesExist: Boolean
    var
        myInt: Integer;
        TBARec: Record "TBA Ledger Entry";
        RegWhseActRec: Record "Registered Whse. Activity Hdr.";
        ALERec: Record "Assignment Ledger Entry";
        ALERec2: Record "Assignment Ledger Entry";
    begin
        //DX        01 JUly 2021        No Need for TBA in checking
        /*
        TBARec.reset;       //Check TBA ledger first before going on to warehouse header
        TBARec.SetRange("Document No.", DocNo);
        if TBARec.Count > 0 then
            exit(true)
        else begin  //Start checking warehouse headers if TBA doesn't exist
        */
        //DX        18 July 2021 assuming no concurrent pick and check.
        ALERec.reset;
        ALERec.SetCurrentKey(Basket, "Checking Doc No.", "Picking Doc No.", "Driver Doc No.", Status);
        ALERec.SetLoadFields(Basket, "Checking Doc No.", "Picking Doc No.", "Driver Doc No.", Status);   //DX        06 May 2023
        ALERec.SetRange(Basket, DocNo);
        ALERec.SetFilter("Checking Doc No.", '');
        ALERec.SetFilter("Picking Doc No.", '<>%1', '');
        ALERec.SetFilter("Driver Doc No.", '');
        ALERec.SetRange(Status, ALERec.Status::"Pending Checking");     //DX        16 July 2021
        if ALERec.FindFirst() then begin
            RegWhseActRec.reset;
            RegWhseActRec.SetLoadFields("Whse. Activity No.");   //DX        06 May 2023
            RegWhseActRec.SetRange("Whse. Activity No.", ALERec."Picking Doc No.");
            if RegWhseActRec.count > 0 then
                exit(TRUE);
        end;

        ALERec.reset;
        ALERec.SetCurrentKey("2nd Basket Code", "Checking Doc No.", "Picking Doc No.", "Driver Doc No.", Status);
        ALERec.SetLoadFields("2nd Basket Code", "Checking Doc No.", "Picking Doc No.", "Driver Doc No.", Status);    //DX        06 May 2023
        ALERec.SetRange("2nd Basket Code", DocNo);
        ALERec.SetFilter("Checking Doc No.", '');
        ALERec.SetFilter("Picking Doc No.", '<>%1', '');
        ALERec.SetFilter("Driver Doc No.", '');
        ALERec.SetRange(Status, ALERec.Status::"Pending Checking");     //DX        16 July 2021
        if ALERec.FindFirst() then begin
            RegWhseActRec.reset;
            RegWhseActRec.SetLoadFields("Whse. Activity No.");   //DX        06 May 2023
            RegWhseActRec.SetRange("Whse. Activity No.", ALERec."Picking Doc No.");
            if RegWhseActRec.count > 0 then
                exit(TRUE);
        end;

        ALERec2.reset;
        ALERec2.SetCurrentKey("2nd Basket Code", "Picking Doc No.", "Driver Doc No.", Status);
        ALERec2.SetLoadFields("2nd Basket Code", "Picking Doc No.", "Driver Doc No.", Status);  //DX        06 May 2023
        ALERec2.SetRange("2nd Basket Code", DocNo);
        ALERec2.SetFilter("Picking Doc No.", '<>%1', '');
        ALERec2.SetFilter("Driver Doc No.", '');
        ALERec2.SetRange(Status, ALERec.Status::"Checking");     //DX        16 July 2021
        if ALERec2.count > 0 then
            exit(true);

        exit(false);

    end;

    //DX        18 July 2021 
    procedure NonColdCheckAlreadyExist(BkNo: Code[20]): Boolean
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Pick Type", "2nd Basket Code", "Picking Doc No.", Status);    //DX        06 May 2023
        ALERec.SetCurrentKey("2nd Basket Code", "Pick Type", "Picking Doc No.", Status);      //DX        30 May 2023
        ALERec.SetRange("2nd Basket Code", BkNo);
        //DX        06 OCt 2021
        ALERec.SetRange("Pick Type", ALERec."Pick Type"::Combined);
        //DX        06 OCt 2021
        ALERec.SetFilter("Picking Doc No.", '<>%1', '');
        ALERec.SetRange(Status, ALERec.Status::"Checking");
        if not (ALERec.IsEmpty()) then begin
            exit(true)
        end else
            exit(false);
    end;
    //DX        18 July 2021 

    procedure GetOrgQty(CheckLineRec: Record "Checking Line") Qty: Decimal;
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        ALERec: Record "Assignment Ledger Entry";
        TBARec: Record "TBA Ledger Entry";
        TLRec: Record "Transfer Line";
        ALRec: Record "Assembly Line";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Checking Doc No.", "Document No.");   //DX        03 May 2023
        ALERec.SetCurrentKey("Checking Doc No.");       //DX        03 May 2023
        ALERec.SetRange("Checking Doc No.", CheckLineRec."Doc No.");
        if NOT (ALERec.IsEmpty()) then begin
            SLRec.reset;
            SLRec.SetLoadFields("Document Type", "Document No.", "No.", Quantity);  //DX    03 May 2023
            SLRec.SetRange("Document Type", SLRec."Document Type"::Order);
            SLRec.SetRange("Document No.", ALERec."Document No.");
            SLRec.SetRange("No.", CheckLineRec."Item No.");
            //SLRec.SetRange("Line No.", CheckLineRec."Line No.");
            if SLRec.FindFirst() then begin
                exit(SLRec.Quantity);
            end else begin
                TLRec.reset;
                TLRec.SetLoadFields("Document No.", "Item No.", Quantity); //DX        03 May 2023
                TLRec.SetRange("Document No.", ALERec."Document No.");
                TLRec.SetRange("Item No.", CheckLineRec."Item No.");
                //SLRec.SetRange("Line No.", CheckLineRec."Line No.");
                if TLRec.FindFirst() then begin
                    exit(TLRec.Quantity);
                end else begin
                    ALRec.reset;
                    ALRec.SetLoadFields("Document No.", "No.", Quantity);   //DX        03 May 2023
                    ALRec.SetRange("Document No.", ALERec."Document No.");
                    ALRec.SetRange("No.", CheckLineRec."Item No.");
                    //SLRec.SetRange("Line No.", CheckLineRec."Line No.");
                    if ALRec.FindFirst() then begin
                        exit(ALRec.Quantity);
                    end;
                end;
            end;
        end;
    end;

    procedure DisablePostInvButton(CheckRec: Record "Checking Header") Disable: Boolean
    var
        myInt: Integer;
        TBARec: Record "TBA Ledger Entry";
        CLERec: Record "Cust. Ledger Entry";
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Checking Doc No.", "Invoice No."); //DX        06 May 2023
        ALERec.SetCurrentKey("Checking Doc No.");   //DX        30 May 2023
        ALERec.SetRange("Checking Doc No.", CheckRec."No.");
        if ALERec.FindFirst() then begin
            if ALERec."Invoice No." = '' then
                exit(TRUE)
            else
                exit(FALSE);

        end;

    end;

    //DX    20 Aug 2021
    procedure UpdateDelChargeInSO(CheckRec: Record "Checking Header")
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        RegWHAct: Record "Registered Whse. Activity Line";
        RegWhHdr: Record "Registered Whse. Activity Hdr.";
    begin
        RegWhHdr.reset;
        RegWhHdr.SetRange("Whse. Activity No.", CheckRec."No.");
        if RegWhHdr.FindFirst() then begin
            RegWHAct.reset;
            RegWHAct.SetRange("No.", RegWhHdr."No.");
            if RegWHAct.FindFirst() then begin
                SHRec.reset;
                SHRec.SetRange("No.", RegWHAct."Source No.");
                if SHRec.FindFirst() then begin
                    SHRec."Delivery Charge" := CheckRec."Delivery Charge";
                    SHRec.Modify(FALSE);
                end;
            end;
        end;
    end;

    procedure UpdateDelZoneInSO(CheckRec: Record "Checking Header")
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        RegWHAct: Record "Registered Whse. Activity Line";
        RegWhHdr: Record "Registered Whse. Activity Hdr.";
    begin
        RegWhHdr.reset;
        RegWhHdr.SetLoadFields("Whse. Activity No.");
        RegWhHdr.SetRange("Whse. Activity No.", CheckRec."No.");
        if RegWhHdr.FindFirst() then begin
            RegWHAct.reset;
            RegWHAct.SetLoadFields("No.");
            RegWHAct.SetRange("No.", RegWhHdr."No.");
            if RegWHAct.FindFirst() then begin
                SHRec.reset;
                SHRec.SetRange("No.", RegWHAct."Source No.");
                if SHRec.FindFirst() then begin
                    SHRec."Delivery Zone" := CheckRec."Shipping Bin";
                    SHRec.Modify(FALSE);
                end;
            end;
        end;
    end;
    //DX    20 Aug 2021


    // DX        25 August 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment (Yes/No)", 'OnBeforeConfirmWhseShipmentPost', '', true, true)]
    local procedure OnBeforeConfirmWhseShipmentPost(var WhseShptLine: Record "Warehouse Shipment Line"; var HideDialog: Boolean; var Invoice: Boolean; var IsPosted: Boolean; var Selection: Integer)
    begin
        //DX        Default the selection to ship and invoice.
        // YF 02 Dec 2021 
        if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Sales Order" then begin
            HideDialog := true;
            Selection := 1;
            Invoice := false;
        end
        else begin
            HideDialog := true;
            Selection := 2;
            Invoice := true;
        end;
        // YF 02 Dec 2021 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment + Print", 'OnBeforeCode', '', true, true)]
    local procedure OnBeforeCode(var WhseShptLine: Record "Warehouse Shipment Line"; var HideDialog: Boolean; var Invoice: Boolean; var IsPosted: Boolean; var Selection: Integer)
    begin
        //DX        Default the selection to ship and invoice.
        // YF 02 Dec 2021 
        if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Sales Order" then begin
            HideDialog := true;
            Selection := 1;
            Invoice := false;
        end
        else begin
            HideDialog := true;
            Selection := 2;
            Invoice := true;
        end;
        // YF 02 Dec 2021 
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostSourceDocumentOnBeforePrintSalesShipment', '', true, true)]
    // local procedure OnPostSourceDocumentOnBeforePrintSalesShipment(var IsHandled: Boolean)
    // begin
    //     //DX        Default the selection to ship and invoice.
    //     IsHandled := true;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Whse. Post Shipment", 'OnPostSourceDocumentOnBeforePrintSalesShipment', '', true, true)]
    local procedure SalesWhsePostShipment_OnPostSourceDocumentOnBeforePrintSalesShipment(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SalesShptHeader: Record "Sales Shipment Header"; WhseShptHeader: Record "Warehouse Shipment Header")
    begin
        //DX        Default the selection to ship and invoice.
        IsHandled := true;
    end;

    // DX        26 August 2021
    var
        myInt: Integer;
        WarehouseCU: Codeunit "Warehouse CU";


    //DX        05 Sept 2021
    procedure HasOpenChecking(BasketCode: Code[20]): Code[50]
    var
        myInt: Integer;
        CheckRec: Record "Checking Header";
        ALEREc: Record "Assignment Ledger Entry";
    begin

        CheckRec.reset;
        CheckRec.SetCurrentKey("Basket No.", Status);
        CheckRec.SetLoadFields("Basket No.", Status, "No."); //DX        06 May 2023
        CheckRec.SetRange("Basket No.", BasketCode);
        CheckRec.SetRange(Status, CheckRec.Status::Checking);
        if CheckRec.FindFirst() then begin
            ALEREc.reset;
            ALEREc.SetCurrentKey("Checking Doc No.");
            ALEREc.SetLoadFields("Checking Doc No.", "Pick Type");    //DX        06 May 2023
            ALEREc.SetRange("Checking Doc No.", CheckRec."No.");
            if ALEREc.FindFirst() then begin
                if ALEREc."Pick Type" <> ALEREc."Pick Type"::Combined then
                    exit(CheckRec."No.")
                else
                    exit('');
            end;
        end else begin
            CheckRec.reset;
            CheckRec.SetCurrentKey("2nd Basket No.", Status);
            CheckRec.SetLoadFields("2nd Basket No.", Status, "No.");   //DX        06 May 2023
            CheckRec.SetRange("2nd Basket No.", BasketCode);
            CheckRec.SetRange(Status, CheckRec.Status::Checking);
            if CheckRec.FindFirst() then begin
                ALEREc.reset;
                ALEREc.SetCurrentKey("Checking Doc No.");
                ALEREc.SetLoadFields("Checking Doc No.", "Pick Type");    //DX        06 May 2023
                ALEREc.SetRange("Checking Doc No.", CheckRec."No.");
                if ALEREc.FindFirst() then begin
                    if ALEREc."Pick Type" <> ALEREc."Pick Type"::Combined then
                        exit(CheckRec."No.")
                    else
                        exit('');
                end;
            end;
        end;
    end;

    local procedure UpdatePickTypeAtALE(ColdExist: Boolean; NonColdExist: Boolean; CheckNo: Code[20])
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetCurrentKey("Checking Doc No.");
        ALERec.SetRange("Checking Doc No.", CheckNo);
        if ALERec.findfirst then begin
            if NonColdExist = true and ColdExist = false then begin
                ALERec."Pick Type" := ALERec."Pick Type"::"Non-Cold"
            end else
                if NonColdExist = false and ColdExist = true then begin
                    ALERec."Pick Type" := ALERec."Pick Type"::Cold
                end else
                    if NonColdExist = true and ColdExist = true then begin
                        ALERec."Pick Type" := ALERec."Pick Type"::Combined;
                    end;
            ALERec.Modify(FALSE);
        end;
    end;
    //DX        05 Sept 2021

    //DX        17 Oct 2021
    procedure IsAOPL(CheckRec: Record "Checking Header"): Boolean
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        AORec: Record "Assembly Header";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Picking Doc No.");        //DX    03 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");        //DX    30 May 2023
        ALERec.SetRange("Picking Doc No.", CheckRec."No.");
        if ALERec.FindFirst() then begin
            AORec.reset;
            AORec.SetLoadFields("No.");     //DX        30 May 2023
            AORec.SetRange("No.", ALERec."Document No.");
            if AORec.FindFirst() then
                exit(true)
            else
                exit(false);
        end else begin
            exit(false);
        end;
        exit(false);
    end;
    //DX        17 Oct 2021
}