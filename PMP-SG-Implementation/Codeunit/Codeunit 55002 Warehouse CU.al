codeunit 55002 "Warehouse CU"
{//DX       For assignment of picker to the respective picking list based on logic
    Permissions = TableData "Item Ledger Entry" = rimd, tabledata "Sales Invoice Header" = rimd, tabledata "Sales Invoice Line" = rimd;

    procedure UpdateOrderStatus(DocNo: code[20]; Status: text[50])
    var
        WSShipRec: Record "Warehouse Shipment Line";
        ALERec: Record "Assignment Ledger Entry";
        SHRec: Record "Sales Header";
        SIHRec: Record "Sales Invoice Header";

    begin
        //OptionMembers = Open,Processing,Picking,Checking,"Delivery In Progress",Delivered,Invoiced;
        /*
        WSShipRec.reset;
        WSShipRec.SetRange("Source Type", 37);
        WSShipRec.SetRange("Source Subtype", SHRec."Document Type");
        WSShipRec.SetRange("Source No.", SHRec."No.");
        if WSShipRec.Count > 0 then begin
            SHRec."Order Status" := SHRec."Order Status"::Processing;
            SHRec.Modify(TRUE);
        end;
        */
        //DX        120521      Change in update order status to apply for all processes
        case Status of
            'Processing':
                begin
                    SHRec.reset;
                    SHRec.SetRange("No.", DocNo);
                    if SHRec.FindFirst() then begin
                        SHRec."Order Status" := SHRec."Order Status"::Processing;
                        SHRec.Modify(true);
                    end;
                    ALERec.reset;
                    ALERec.SetLoadFields("Document No.", "Customer No.", "Invoice No.");      //DX        03 May 2023
                    ALERec.SetCurrentKey("Document No.", "Customer No.", "Invoice No.");      //DX        24 May 2023
                    ALERec.SetAscending("Document No.", false);                      //DX        24 May 2023
                    ALERec.SetRange("Document No.", DocNo);
                    ALERec.SetFilter("Customer No.", '<>%1', 'Deleted Document');
                    ALERec.SetRange("Invoice No.", '');
                    if ALERec.FindFirst() then begin
                        ALERec.Status := ALERec.Status::Processing;
                        ALERec.Modify(TRUE);
                    end;
                end;
            'Picking':
                begin
                    SHRec.reset;
                    SHRec.SetRange("No.", DocNo);
                    if SHRec.FindFirst() then begin
                        SHRec."Order Status" := SHRec."Order Status"::Picking;
                        SHRec.Modify(true);
                    end;
                    /*
                    ALERec.reset;
                    ALERec.SetRange("Document No.", DocNo);
                    if ALERec.FindFirst() then begin
                        ALERec.Status := ALERec.Status::Picking;
                        ALERec.Modify(TRUE);
                    end;
                    */
                end;
            //DX        04 July 2021    Additional new status
            'Pending Checking':
                begin
                    SHRec.reset;
                    SHRec.SetRange("No.", DocNo);
                    if SHRec.FindFirst() then begin
                        SHRec."Order Status" := SHRec."Order Status"::"Pending Checking";
                        SHRec.Modify(true);
                    end;
                end;
            'Checking':
                begin
                    begin
                        ALERec.reset;
                        ALERec.SetCurrentKey("Picking Doc No.", Status);   //DX    11 May 2023
                        ALERec.SetAscending("Picking Doc No.", false);   //DX        24 May 2023
                        ALERec.SetRange("Picking Doc No.", DocNo);
                        ALERec.SetRange("Invoice No.", '');
                        ALERec.SetRange(Status, ALERec.Status::"Pending Checking");
                        if ALERec.FindFirst() then begin
                            SHRec.reset;
                            SHRec.SetCurrentKey("Document Type", "No.", "Order Status");
                            SHRec.SetRange("No.", ALERec."Document No.");
                            if SHRec.FindFirst() then begin
                                SHRec."Order Status" := SHRec."Order Status"::Checking;
                                SHRec.Modify(true);
                            end;
                            ALERec.Status := ALERec.Status::Checking;
                            ALERec.Modify(TRUE);
                        end;
                    end;
                end;
            'Pending Delivery':
                begin
                    ALERec.reset;
                    ALERec.SetCurrentKey("Picking Doc No.", Status);     //DX    24 May 2023
                    ALERec.SetAscending("Picking Doc No.", false);    //DX    24 May 2023
                    ALERec.SetRange("Picking Doc No.", DocNo);
                    ALERec.SetRange(Status, ALERec.Status::Checking);
                    if ALERec.FindFirst() then begin
                        SHRec.reset;
                        SHRec.SetRange("No.", ALERec."Document No.");
                        if SHRec.FindFirst() then begin
                            SHRec."Order Status" := SHRec."Order Status"::"Pending Delivery";
                            SHRec.Modify(false);
                        end;
                        SIHRec.reset;
                        SIHRec.SetRange("No.", ALERec."Invoice No.");
                        if SIHRec.FindFirst() then begin
                            SIHRec."Order Status" := SIHRec."Order Status"::"Pending Delivery";
                            SIHRec.Modify(FALSE);
                        end;
                        ALERec.Status := ALERec.Status::"Pending Delivery";
                        ALERec.Modify(TRUE);
                    end;
                end;
            'Delivery In Progress':
                begin
                    SIHRec.reset;
                    SIHRec.SetRange("No.", DocNo);
                    if SIHRec.FindFirst() then begin
                        SIHRec."Order Status" := SIHRec."Order Status"::"Delivery In Progress";
                        SIHRec.Modify(true);
                    end;
                    ALERec.reset;
                    ALERec.SetCurrentKey("Invoice No.");      //DX    24 May 2023
                    ALERec.SetAscending("Invoice No.", false);     //DX    24 May 2023
                    ALERec.SetRange("Invoice No.", DocNo);
                    if ALERec.FindFirst() then begin
                        ALERec.Status := ALERec.Status::"Delivery In Progress";
                        ALERec.Modify(TRUE);
                    end;
                end;
            'Delivered':
                begin
                    SIHRec.reset;
                    SIHRec.SetRange("No.", DocNo);
                    if SIHRec.FindFirst() then begin
                        SIHRec."Order Status" := SIHRec."Order Status"::Delivered;
                        SIHRec.Modify(true);
                    end;
                    ALERec.reset;
                    ALERec.SetCurrentKey("Invoice No.");      //DX    24 May 2023
                    ALERec.SetAscending("Invoice No.", false);     //DX    24 May 2023
                    ALERec.SetRange("Invoice No.", DocNo);
                    if ALERec.FindFirst() then begin
                        ALERec.Status := ALERec.Status::Delivered;
                    end;
                end;
            'Invoiced':
                begin
                    SIHRec.reset;
                    SIHRec.SetRange("No.", DocNo);
                    if SIHRec.FindFirst() then begin
                        SIHRec."Order Status" := SIHRec."Order Status"::Invoiced;
                        SIHRec.Modify(true);
                    end;
                    ALERec.reset;
                    ALERec.SetCurrentKey("Invoice No.");      //DX    24 May 2023
                    ALERec.SetAscending("Invoice No.", false);     //DX    24 May 2023
                    ALERec.SetRange("Invoice No.", DocNo);
                    if ALERec.FindFirst() then begin
                        ALERec.Status := ALERec.Status::Invoiced;
                        ALERec.Modify(TRUE);
                    end;
                end;
            'Completed':
                begin
                    SIHRec.reset;
                    SIHRec.SetRange("No.", DocNo);
                    if SIHRec.FindFirst() then begin
                        SIHRec."Order Status" := SIHRec."Order Status"::Completed;
                        SIHRec.Modify(true);
                    end;
                    ALERec.reset;
                    ALERec.SetCurrentKey("Invoice No.");      //DX    24 May 2023
                    ALERec.SetAscending("Invoice No.", false);     //DX    24 May 2023
                    ALERec.SetRange("Invoice No.", DocNo);
                    if ALERec.FindFirst() then begin
                        ALERec.Status := ALERec.Status::Completed;
                        ALERec.Modify(TRUE);
                    end;
                end;
        end;
    end;
    //110521 DX        Auto create Pick list after warehouse shipment is created.
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateWhseDocuments', '', true, true)]
    procedure OnAfterCreateWhseDocuments(var WarehouseRequest: Record "Warehouse Request"; var WhseShipmentHeader: Record "Warehouse Shipment Header"; var WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        SSSetup: Record "Sales & Receivables Setup";
    begin

        //030521 DX     Check if setup is auto create assignemnt ledger
        SSSetup.reset;
        SSSetup.get;
        if SSSetup."Auto Create Pick List" then begin
            AutoCreateSystemPickList(WhseShipmentHeader);
            //DX        120521      
            if WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Sales Order" then begin
                UpdateOrderStatus(WarehouseRequest."Source No.", 'Processing');
            end;
        end;                        //030521 DX     Check if setup is auto create assignemnt ledger
    end;

    //030521 DX        After creating a warehouse shipment, to auto create the assignment list ledger
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterCreatePickDoc', '', true, true)]
    procedure OnAfterCreatePickDoc(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WhseShptLine: Record "Warehouse Shipment Line")
    var
        SSSetup: Record "Sales & Receivables Setup";
        WSPickRec: Record "Warehouse Activity Line";
        SalesLine: Record "Sales Line"; // YF 30 Jul 2021
        TransferLine: Record "Transfer Line";   //DX        03 Sept 2021
    begin

        //030521 DX     Check if setup is auto create assignemnt ledger
        SSSetup.reset;
        SSSetup.get;
        if SSSetup."Auto Assign Picker" then begin
            WSPickRec.reset;
            //WSPickRec.SetFilter("Source Document", '%1|%2', WSPickRec."Source Document"::"Sales Order", WSPickRec."Source Document"::"Outbound Transfer");    //DX        22 July 2021
            //DX        17 Oct 2021
            WSPickRec.SetFilter("Source Document", '%1|%2|%3', WSPickRec."Source Document"::"Sales Order", WSPickRec."Source Document"::"Outbound Transfer", WSPickRec."Source Document"::"Assembly Consumption");    //DX        22 July 2021
            //DX        17 Oct 2021
            WSPickRec.SetRange("Whse. Document No.", WarehouseShipmentHeader."No.");
            if WSPickRec.FindFirst() then begin
                //DX        02 Aug 2021     //Allow the deletion of partial and creation of new PL again for partial
                CreateAssignmentLedgerWithPickList(WarehouseShipmentHeader);
                //end;
            end;
        end;
        //030521 DX     Check if setup is auto create assignemnt ledger
        // YF 30 Jul 2021 To set To Pick Qty 
        WSPickRec.reset;
        WSPickRec.SetRange("Whse. Document No.", WarehouseShipmentHeader."No.");
        //DX        05 Sept 2021
        //WSPickRec.SetRange("Source Document", WSPickRec."Source Document"::"Sales Order");
        //WSPickRec.SetFilter("Source Document", '%1|%2', WSPickRec."Source Document"::"Sales Order", WSPickRec."Source Document"::"Outbound Transfer");    //DX        22 July 2021
        //DX        17 Oct 2021
        WSPickRec.SetFilter("Source Document", '%1|%2|%3', WSPickRec."Source Document"::"Sales Order", WSPickRec."Source Document"::"Outbound Transfer", WSPickRec."Source Document"::"Assembly Consumption");    //DX        22 July 2021                                                                                                                                                                                                                  //DX        17 Oct 2021                                                                                                                                                                                                                 //DX        05 Sept 2021
        if WSPickRec.FindSet() then
            repeat
                if WSPickRec."Source Document" = WSPickRec."Source Document"::"Sales Order" then begin
                    SalesLine.Reset;
                    SalesLine.SetLoadFields("Document Type", "Document No.", "Line No.", "Qty To Deliver", "FOC (Qty) To Deliver");//DX       06 May 2023
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", WSPickRec."Source No.");
                    SalesLine.SetRange("Line No.", WSPickRec."Source Line No.");
                    if SalesLine.FindFirst() then begin
                        //WSPickRec.Validate("CS Pick Qty", SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver");
                        WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity);      //Set to same quantity as per pick list. 03 Apr 2026, According to Bernard, no cases of requested partial delivery by customer
                        WSPickRec.Modify(true);
                    end;
                end else
                    //DX        05 Sept 2021    Display the correct to pick qty when create transfer order

                    if WSPickRec."Source Document" = WSPickRec."Source Document"::"Outbound Transfer" then begin
                        WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity);
                        WSPickRec.Modify(true);
                    end else
                        if WSPickRec."Source Document" = WSPickRec."Source Document"::"Assembly Consumption" then begin
                            WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity);
                            WSPickRec.Modify(true);
                        end;

            //DX        05 Sept 2021
            until WSPickRec.next = 0;
        // YF 30 Jul 2021 To set To Pick Qty           

    end;

    //160721 DX        After creating a warehouse shipment, to auto create the assignment list ledger
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Receipt", 'OnAfterCreatePutAwayDoc', '', true, true)]
    procedure OnAfterCreatePutAwayDoc(var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        SSSetup: Record "Sales & Receivables Setup";
        WSPickRec: Record "Warehouse Activity Line";
    begin
        //DX        16 July 2021        Auto set qty to handle to 0 after creating pick list
        WSPickRec.reset;
        //WSPickRec.SetRange("Source Document", WSPickRec."Source Document"::"Sales Order");
        WSPickRec.SetCurrentKey("Whse. Document No.");      //DX        10 May 2023
        WSPickRec.SetRange("Whse. Document No.", WarehouseReceiptHeader."No.");
        if WSPickRec.FindSet() then
            repeat
                WSPickRec.Validate("Qty. to Handle", 0);
                WSPickRec.Modify(true);
            until WSPickRec.next = 0;

        //DX        16 July 2021
    end;


    //050521 DX Registering of pick list
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Register (Yes/No)", 'OnBeforeCode', '', true, true)]
    procedure OnBeforeCode(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        TripLineRec: Record "WH Trip Line";
        AssignRec: Record "Assignment Ledger Entry";
        TripRec: Record "WH Trip Header";
        UnCompTLRec: Record "WH Trip Line";
    begin
        //DX        09 July 2021    Check if picking list is combined picking before allowing to register the picking list
        //DX        06 Sept 2021
        if GetPickListTypeFromPickingList(WarehouseActivityLine) = 3 then begin   //Check the type of picking list first before deciding if need to prompt error message            
        end else begin      //If not combined pick list, just allow to register picking list            
            if (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Pick) then begin
                // 220621.0 YF Ignore if Assembly Consumption - aka - Activate checks for Sales Document only
                if (WarehouseActivityLine."Source Document" = WarehouseActivityLine."Source Document"::"Sales Order") Or
                (WarehouseActivityLine."Source Document" = WarehouseActivityLine."Source Document"::"Sales Return Order") then begin
                    UnCompTLRec.reset;
                    UnCompTLRec.SetLoadFields("Pick Doc No.");//DX       06 May 2023
                    UnCompTLRec.SetRange("Pick Doc No.", WarehouseActivityLine."No.");
                    //UnCompTLRec.SetRange("Line Completed", false);
                    if UnCompTLRec.Count = 0 then begin
                        // 220621.1 YF Replace with confirm dialog as instructed by DX
                        // Error('Please create Warehouse Trip first and include Picking List before confirming the pick.');
                        if Not Confirm('Please create Warehouse Trip first and include Picking List before confirming the pick. Continue?', false) then
                            Error('Action cancelled');
                        // 220621.1 YF
                    end;
                end;
                // 220621.0 YF
            end;
        end;
        //DX        09 July 2021
    end;
    //040521 DX Registering of pick list
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Register (Yes/No)", 'OnAfterCode', '', true, true)]
    procedure OnAfterCode(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        TripLineRec: Record "WH Trip Line";
        AssignRec: Record "Assignment Ledger Entry";
        TripRec: Record "WH Trip Header";
        UnCompTLRec: Record "WH Trip Line";
        SSSetup: Record "Sales & Receivables Setup";
        WHActHdr: Record "Warehouse Activity Header";

    begin
        if (WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Pick) then begin
            TripLineRec.reset;
            TripLineRec.SetLoadFields("Pick Doc No.", "Line Completed");      //DX        02 May 2023
            TripLineRec.SetRange("Pick Doc No.", WarehouseActivityLine."No.");
            if TripLineRec.FindSet() then
                repeat
                    TripLineRec."Line Completed" := true;
                    TripLineRec.Modify(TRUE);
                until TripLineRec.next = 0;
            //DX        01 Aug 2021
            //040521 DX Check whole trip if completed and update header if all lines are completed.
            //DX        25 May 2021
            AssignRec.reset;
            AssignRec.SetLoadFields("Picking Doc No.", "End Time", "Pick Type", Status);        //DX        02 May 2023
            AssignRec.SetCurrentKey("Picking Doc No.");   //DX        24 May 2023
            AssignRec.SetAscending("Picking Doc No.", false);    //DX        24 May 2023
            AssignRec.SetRange("Picking Doc No.", WarehouseActivityLine."No.");
            if AssignRec.FindFirst() then begin
                if GetPickListTypeFromPickingList(WarehouseActivityLine) = 1 then
                    AssignRec."Pick Type" := AssignRec."Pick Type"::"Non-Cold"
                else
                    if GetPickListTypeFromPickingList(WarehouseActivityLine) = 2 then
                        AssignRec."Pick Type" := AssignRec."Pick Type"::Cold
                    else
                        if GetPickListTypeFromPickingList(WarehouseActivityLine) = 3 then
                            AssignRec."Pick Type" := AssignRec."Pick Type"::Combined;

                AssignRec."End Time" := CreateDateTime(Today, time());
                AssignRec.Status := AssignRec.Status::"Pending Checking";
                AssignRec.Modify(TRUE);
                //DX        04 July 2021
                //After picker has picked finish, to change status to pending checking
                UpdateOrderStatus(AssignRec."Document No.", 'Pending Checking');
                //DX        04 July 2021
            end;
            //DX        25 May 2021
            UnCompTLRec.reset;
            UnCompTLRec.SetLoadFields("Pick Doc No.", "Line Completed");     //DX        02 May 2023
            UnCompTLRec.SetCurrentKey("Pick Doc No.", "Line Completed");
            UnCompTLRec.SetRange("Pick Doc No.", WarehouseActivityLine."No.");
            UnCompTLRec.SetRange("Line Completed", false);
            if UnCompTLRec.Count = 0 then begin
                TripRec.reset;
                TripRec.SetLoadFields("No.", "Trip End");        //DX        02 May 2023
                Triprec.SetRange("No.", TripLineRec."Doc No.");
                if TripRec.FindFirst() then begin
                    TripRec."Trip End" := CurrentDateTime;
                    TripRec.Modify(TRUE);
                end;
            end;
            //DX        01 Aug 2021 : automated deletion of pick list after registering for partial qty.
            SSSetup.Reset();
            SSSetup.SetLoadFields("Auto Del. PL After Reg.");   //DX        02 May 2023
            SSSetup.get;

            if SSSetup."Auto Del. PL After Reg." = true then begin
                WHActHdr.reset;
                WHActHdr.SetLoadFields("No.");      //DX        02 May 2023
                WHActHdr.SetRange("No.", WarehouseActivityLine."No.");
                if WHActHdr.FindFirst() then begin
                    WHActHdr.Delete(true);
                end;
            end;
        end;


    end;

    //DX        120521      If picking list got deleted, need to update the ALE entry correctly.
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Header", 'OnAfterDeleteWhseActivHeader', '', true, true)]
    procedure OnAfterDeleteWhseActivHeader(var WarehouseActivityHeader: Record "Warehouse Activity Header")
    var
        TripLineRec: Record "WH Trip Line";
        AssignRec: Record "Assignment Ledger Entry";
        TripRec: Record "WH Trip Header";
        UnCompTLRec: Record "WH Trip Line";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        IsPartialShipment: Boolean;
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        WarehouseActivityLine.reset;
        WarehouseActivityLine.SetLoadFields("No.", "Activity Type", "Whse. Document Type", "Whse. Document No.");       //DX        02 May 2023
        WarehouseActivityLine.SetCurrentKey("No.");    //DX        10 may 2023
        WarehouseActivityLine.SetAscending("No.", false);   //DX        24 May 2023
        WarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
        if WarehouseActivityLine.FindFirst() then begin
            // check warehouse shipment is partial // for Issue #59 YF 29 Jul 2021
            IsPartialShipment := false;
            if WarehouseActivityLine."Whse. Document Type" = WarehouseActivityLine."Whse. Document Type"::Shipment then begin
                WhseShptHeader.reset;
                WhseShptHeader.SetLoadFields("No.", "Document Status"); //DX        06 May 2023
                WhseShptHeader.SetCurrentKey("No.");        //DX 24 May 2023
                WhseShptHeader.SetRange("No.", WarehouseActivityLine."Whse. Document No.");
                if WhseShptHeader.Findfirst() then
                    if WhseShptHeader."Document Status" = WhseShptHeader."Document Status"::"Partially Picked" then
                        IsPartialShipment := true;
            end;

            // skip update is partial shipment  // for Issue #59 YF 29 Jul 2021
            if Not IsPartialShipment then begin
                AssignRec.reset;
                AssignRec.SetLoadFields("Picking Doc No.", "Start Time", "End Time", Picker);       //DX        02 May 2023
                AssignRec.SetCurrentKey("Picking Doc No.");     //DX        24 May 2023
                AssignRec.SetAscending("Picking Doc No.", false);       //DX        24 May 2023
                AssignRec.SetRange("Picking Doc No.", WarehouseActivityLine."No.");
                if AssignRec.FindFirst() then begin
                    AssignRec."Picking Doc No." := '';
                    AssignRec."Start Time" := 0DT;
                    AssignRec."End Time" := 0DT;
                    AssignRec.Picker := '';
                    AssignRec.Modify(TRUE);

                end;
            end;
        end;

    end;

    procedure CreateAssignmentLedgerWithPickList(WHShipRec: Record "Warehouse Shipment Header")
    var
        myInt: Integer;
        PickType: Integer;      //DX    11 May 2023
        AssignmentLedger: Record "Assignment Ledger Entry";
        lAssignLedger: Record "Assignment Ledger Entry";
        VendorRec: Record vendor;
        SHRec: Record "Sales Header";
        TORec: Record "Transfer Header";
        PHRec: Record "Purchase Header";
        WSPickRec: Record "Warehouse Activity Line";
        AssignCU: Codeunit "Assignment CU";
        AORec: Record "Assembly Header";
    begin
        WSPickRec.reset;
        WSPickRec.SetLoadFields("Whse. Document Line No.", "Whse. Document No.", "Whse. Document Type", "Destination Type", "Destination No.", "Source Document", "Source No.", "No.");    //DX        02 May 2023
        WSPickRec.SetCurrentKey("Whse. Document Type", "Whse. Document No.");    //DX        10 may 2023
        WSPickRec.SetAscending("Whse. Document Type", false);            //DX        10 may 2023
        WSPickRec.SetAscending("Whse. Document No.", false);  //DX        24 May 2023
        WSPickRec.SetRange("Whse. Document Type", WSPickRec."Whse. Document Type"::Shipment);
        WSPickRec.SetRange("Whse. Document No.", WHShipRec."No.");
        if WSPickRec.FindFirst() then begin
            lAssignLedger.reset;
            lAssignLedger.SetLoadFields("Entry No.");       ///DX       02 May 2023
            if lAssignLedger.FindLast() then
                myInt := lAssignLedger."Entry No." + 1
            else
                myInt := 1;

            AssignmentLedger.reset;
            AssignmentLedger.Init();
            AssignmentLedger."Entry No." := myInt;
            AssignmentLedger.Status := AssignmentLedger.Status::Processing;
            //DX        11 May 2023     Refactor code to do one time checking only
            Clear(PickType);
            PickType := GetPickListTypeFromPickingList(WSPickRec);
            if PickType = 1 then
                AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::"Non-Cold"
            else
                if PickType = 2 then
                    AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::Cold
                else
                    if PickType = 3 then
                        AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::Combined;
            //DX        11 May 2023
            // if GetPickListTypeFromPickingList(WSPickRec) = 1 then
            //     AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::"Non-Cold"
            // else
            //     if GetPickListTypeFromPickingList(WSPickRec) = 2 then
            //         AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::Cold
            //     else
            //         if GetPickListTypeFromPickingList(WSPickRec) = 3 then
            //             AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::Combined;
            //030521        DX      If picking is for customer and transfer order out bound.
            if WSPickRec."Destination Type" = WSPickRec."Destination Type"::Customer then begin
                SHRec.reset;
                SHRec.SetLoadFields("No.", "Document Type", SHRec."Sell-to Customer No.", SHRec."Sell-to Customer Name", SHRec."Shipment Date", SHRec."Posting Date", SHRec."Requested Delivery Date"); //DX        02 May 2023
                SHRec.SetCurrentKey("Document Type", "No.");
                SHRec.SetRange("Document Type", WSPickRec."Source Document");
                SHRec.SetRange("No.", WSPickRec."Source No.");
                if SHRec.FindFirst() then begin
                    //DX        22 Aug 2021 : Perform creation validation for CD, Chain, Wellaway checkboxes
                    AssignmentLedger."Controlled Drug" := IsCD(SHRec."No.");
                    AssignmentLedger."Chain Pharmacy" := IsChainPharmacy(SHRec."No.");
                    AssignmentLedger.Wellaway := false;
                    //DX        22 Aug 2021
                    AssignmentLedger.I9G_STBio := IsSTBio(SHRec."No."); // YF 24 Mar 2025
                    AssignmentLedger."Document No." := SHRec."No.";
                    AssignmentLedger."Customer No." := SHRec."Sell-to Customer No.";
                    AssignmentLedger."Customer Name" := SHRec."Sell-to Customer Name";
                    //110621    DX      Additional fields  for assignemnt
                    if SHRec."Priority Picking" = true then
                        AssignmentLedger."Priority Picking" := true
                    else
                        AssignmentLedger."Priority Picking" := false;
                    AssignmentLedger."Shipment Date" := SHRec."Shipment Date";
                    //DX        05 Sept 2021
                    if SHRec."Requested Delivery Date" <> 0D Then
                        AssignmentLedger."Pick By Date" := SHRec."Requested Delivery Date"
                    else
                        AssignmentLedger."Pick By Date" := AssignCU.GetPickByDateForSO(SHRec);
                    //DX        05 Sept 2021
                    //110621    DX      Additional fields  for assignemnt
                    AssignmentLedger."Posting Date" := SHRec."Posting Date";
                    //DX        09 July 2021        : additional pick type to differentiate cold / non cold

                    //DX        09 July 2021

                    //PK 08112023
                    AssignmentLedger."Wellaway Picks" := SHRec.I9G_Wellaway_Pick;
                    //PK 08112023

                end;
            end else        //For Transfer Order
                if WSPickRec."Destination Type" = WSPickRec."Destination Type"::Location then begin
                    TORec.reset;
                    TORec.SetLoadFields("No.", "Transfer-to Code", "Assigned User ID", "Transfer-to Name", "Posting Date", "Shipment Date"); //DX        02 May 2023                
                    TORec.SetRange("No.", WSPickRec."Source No.");
                    //TORec.SetRange("Document Type", WSPickRec."Source Document");
                    if TORec.FindFirst() then begin
                        AssignmentLedger."Document No." := TORec."No.";
                        AssignmentLedger."Customer No." := TORec."Transfer-to Code";
                        //DX        22 Aug 2021 
                        //DX        31 Aug 2021
                        AssignmentLedger.Wellaway := true;
                        AssignmentLedger."Priority Picking" := true; //RL      30 Nov 2021
                        if NOT (TORec."Transfer-to Code" = 'WELLAWAY') then begin
                            AssignmentLedger.Picker := TORec."Assigned User ID";
                            AssignmentLedger."Priority Picking" := false;  //RL      30 Nov 2021
                        end;
                        //DX        31 Aug 2021
                        AssignmentLedger."Chain Pharmacy" := false;
                        AssignmentLedger."Controlled Drug" := IsCD(TORec."No.");
                        //DX        22 Aug 2021 
                        AssignmentLedger.I9G_STBio := IsSTBio(TORec."No."); // YF 24 Mar 2025
                        AssignmentLedger."Customer Name" := TORec."Transfer-to Name";
                        AssignmentLedger."Posting Date" := TORec."Posting Date";
                        //02 Aug 2021    DX      Additional fields  for assignment
                        AssignmentLedger."Priority No." := 1;       //DX        02 Aug 2021 : Wellaway is always 1 , first .
                        AssignmentLedger."Shipment Date" := TORec."Shipment Date";
                        AssignmentLedger."Pick By Date" := AssignCU.GetPickByDateForTO(TORec);
                        //02 Aug 2021    DX      Additional fields  for assignment
                    end;
                end else        //DX        17 Oct 2021 For assembly
                    if WSPickRec."Destination Type" = WSPickRec."Destination Type"::" " then begin
                        AORec.reset;
                        AORec.SetLoadFields("No.", "Posting Date");  //DX        02 May 2023
                        AORec.SetRange("No.", WSPickRec."Source No.");
                        //TORec.SetRange("Document Type", WSPickRec."Source Document");
                        if AORec.FindFirst() then begin
                            AssignmentLedger."Document No." := AORec."No.";
                            AssignmentLedger."Customer No." := 'ASSEMBLY';
                            AssignmentLedger."Chain Pharmacy" := false;
                            AssignmentLedger."Controlled Drug" := false;
                            AssignmentLedger.I9G_STBio := false; // YF 24 Mar 2025
                            AssignmentLedger."Customer Name" := 'ASSEMBLY';
                            AssignmentLedger."Posting Date" := AORec."Posting Date";
                            //02 Aug 2021    DX      Additional fields  for assignment
                            AssignmentLedger."Priority No." := 1;       //DX        02 Aug 2021 : Wellaway is always 1 , first .
                            AssignmentLedger."Shipment Date" := AORec."Posting Date";
                            AssignmentLedger."Pick By Date" := CalcDate('<1D>', AORec."Posting Date");
                            //02 Aug 2021    DX      Additional fields  for assignment
                        end;
                    end else        //DX        19 Oct 2021 For PRO
                        if WSPickRec."Destination Type" = WSPickRec."Destination Type"::Vendor then begin
                            PHRec.reset;
                            PHRec.SetLoadFields("No.", "Document Type", "Buy-from Vendor No.", "Buy-from Vendor Name", "Posting Date", "Assigned User ID");    //DX        02 May 2023
                            PHRec.SetRange("No.", WSPickRec."Source No.");
                            PHRec.SetRange("Document Type", PHRec."Document Type"::"Return Order");
                            //TORec.SetRange("Document Type", WSPickRec."Source Document");
                            if PHRec.FindFirst() then begin
                                AssignmentLedger."Document No." := PHRec."No.";
                                AssignmentLedger."Customer No." := PHRec."Buy-from Vendor No.";
                                AssignmentLedger."Chain Pharmacy" := false;
                                AssignmentLedger."Controlled Drug" := IsCD(PHRec."No.");
                                AssignmentLedger.I9G_STBio := IsSTBio(PHRec."No."); // YF 24 Mar 2025
                                AssignmentLedger."Customer Name" := PHRec."Buy-from Vendor Name";
                                AssignmentLedger."Posting Date" := PHRec."Posting Date";
                                AssignmentLedger.Picker := PHRec."Assigned User ID";  //RL  08 Dec 2021
                                //02 Aug 2021    DX      Additional fields  for assignment
                                AssignmentLedger."Priority No." := 1;       //DX        02 Aug 2021 : Wellaway is always 1 , first .
                                AssignmentLedger."Shipment Date" := PHRec."Posting Date";
                                AssignmentLedger."Pick By Date" := CalcDate('<1D>', PHRec."Posting Date");
                                //02 Aug 2021    DX      Additional fields  for assignment
                            end;
                        end;
            AssignmentLedger."Picking Doc No." := WSPickRec."No.";
            AssignmentLedger.Insert(TRUE);


            //AssignmentLedger.Modify(TRUE);
        end;
    end;

    procedure AssignPicker(UserID: Code[20]; TripHeader: Code[20]; TrolleyCode: Code[20])
    //DX        050521      Assign picking list to the trip header when creating a trip header based on assignment criterias.
    var
        myInt: Integer;
        AssignLE: Record "Assignment Ledger Entry";
        WHEmpRec: Record "Warehouse Employee";
        TripRec: Record "WH Trip Header";
        TripLineRec: Record "WH Trip Line";
        LineNO: Integer;
        lTripLine: Record "WH Trip Line";
        AssignCU: Codeunit "Assignment CU";
        WHPickRec: Record "Warehouse Activity Header";
        Picker: Record Picker;
        SORec: Record "Sales Header";
    begin
        //110621    DX  Change in assignment of code
        //AssignCU.GetAssignLE(AssignLE, UserID);
        AssignCU.GetAssignLEByPicker(AssignLE, UserID);
        //110621    DX  Change in assignment of code
        lTripLine.reset;
        lTripLine.SetLoadFields("Doc No.", "Line No.");  //DX        06 May 2023
        lTripLine.SetRange("Doc No.", TripHeader);
        if lTripLine.FindLast() then
            LineNO := lTripLine."Line No." + 10000
        else
            LineNO := 10000;

        //Assign by priority picking first
        if AssignLE.FindFirst() then begin
            //if picker is wellaway
            TripLineRec.reset;
            TripLineRec.Init();
            TripLineRec."Doc No." := TripHeader;
            TripLineRec."Line No." := LineNO;
            TripLineRec."Pick Doc No." := AssignLE."Picking Doc No.";
            TripLineRec."Priority Picking" := AssignLE."Priority Picking";
            TripLineRec."Trolley No." := TrolleyCode;
            TripLineRec."Basket No." := '';
            TripLineRec."Source No." := AssignLE."Customer No.";
            TripLineRec."Source Name" := AssignLE."Customer Name";
            TripLineRec.Insert(TRUE);

            AssignLE."Start Time" := CurrentDateTime;
            AssignLE."Trip Doc No." := TripHeader;
            AssignLE.Basket := '';
            AssignLE.Picker := UserID;
            UpdateOrderStatus(AssignLE."Document No.", 'Picking');
            assignle.Status := AssignLE.Status::Picking;
            AssignLE.Modify(true);
            //DX        120521      Upodate order status to picking after trip has been created.

            //DX        140621      Update Pick line assignment dates details
            WHPickRec.reset;
            //DX        05 Dec 2023
            WHPickRec.SetLoadFields("No.", "Assigned User ID", "Assignment Date", "Assignment Time");
            //DX        05 Dec 2023
            WHPickRec.SetRange("No.", AssignLE."Picking Doc No.");
            if WHPickRec.FindFirst() then begin
                WHPickRec.Validate("Assignment Date", Today);
                WHPickRec.Validate("Assignment Time", Time);
                WHPickRec.Validate("Assigned User ID", UserID);
                WHPickRec.Modify(TRUE);
            end;

            //DX        140621      Update Pick line assignment dates details
        end;

        //then check he assingle.document no (SO) is wellaway
        // if not then don't insert
        //SHRec.SetRange("No.", AssignLE."Document No.")
    end;

    procedure ManualAddPickingListToTrip(UserID: Code[20]; var TripHeader: Record "WH Trip Header"; BasketCode: code[20])
    //DX        050521     Allow user to manually add a pick list to the trip header if needed
    var
        myint: Integer;
        AssignLE: Record "Assignment Ledger Entry";
        AssignPage: page "Assignment List";
        TripLineRec: Record "WH Trip Line";
        LineNO: Integer;
        lTripLine: Record "WH Trip Line";
    begin
        AssignLE.reset;
        AssignLE.SetRange(Status, AssignLE.Status::Processing);
        clear(AssignPage);
        AssignPage.LookupMode := true;
        AssignPage.SetTableView(AssignLE);
        if AssignPage.RunModal() = Action::LookupOK then begin
            AssignPage.SetSelectionFilter(AssignLE);
            if Confirm('Are you sure you wish to insert these records?') then begin
                //Get Trip Header Line No.
                lTripLine.reset;
                lTripLine.SetRange("Doc No.", TripHeader."No.");
                if lTripLine.FindLast() then
                    LineNO := lTripLine."Line No." + 10000
                else
                    LineNO := 10000;

                if AssignLE.FindSet() then
                    repeat
                        TripLineRec.reset;
                        TripLineRec.Init();
                        TripLineRec."Doc No." := TripHeader."No.";
                        TripLineRec."Line No." := LineNO;
                        TripLineRec."Pick Doc No." := AssignLE."Picking Doc No.";
                        TripLineRec."Basket No." := BasketCode;
                        TripLineRec."Priority Picking" := AssignLE."Priority Picking";
                        TripLineRec."Source No." := AssignLE."Customer No.";
                        TripLineRec."Source Name" := AssignLE."Customer Name";
                        TripLineRec.Insert(TRUE);
                        myInt += 1;

                        AssignLE."Start Time" := CurrentDateTime;
                        AssignLE."Trip Doc No." := TripHeader."No.";
                        AssignLE.Basket := BasketCode;
                        AssignLE.Picker := UserID;
                        AssignLE.Status := AssignLE.Status::Picking;
                        AssignLE.Modify(true);
                        LineNO += 10000;
                    until AssignLE.next = 0;
                Message('Trip Header details updated.');

                if TripHeader."Trip Start" = 0DT then begin
                    TripHeader."Trip Start" := CurrentDateTime;
                    TripHeader.Picker := UserID;
                    TripHeader.Modify(FALSE);
                end;
            end;
        end;
    end;

    procedure GotAvailPicks(userlogin: Code[50]) Valid: Boolean
    //DX    050521      Check if got available picking lists to assign, else it will create blank trip header.
    var
        myInt: Integer;
        AssignLE: Record "Assignment Ledger Entry";
        PickRec: Record Picker;
    begin
        PickRec.reset;
        PickRec.SetLoadFields("User ID", CD, Dedicated, I9G_STBio);//DX        06 May 2023 // YF 24 Mar 2025
        PickRec.SetRange("User ID", userlogin);
        if PickRec.FindFirst() then begin
            AssignLE.reset;
            AssignLE.SetLoadFields(Status, "Controlled Drug", I9G_STBio, "Chain Pharmacy", Status);//DX        06 May 2023 // YF 24 Mar 2025
            AssignLE.SetCurrentKey(Status, "Controlled Drug", I9G_STBio, "Chain Pharmacy"); //DX        03 May 2023 // YF 24 Mar 2025
            AssignLE.SetRange(Status, AssignLE.Status::Processing);

            if PickRec.CD = true then begin
                AssignLE.SetRange("Controlled Drug", true);
            end else
                if PickRec.Dedicated = true then begin
                    AssignLE.SetRange("Controlled Drug", false);
                end else begin
                    AssignLE.SetRange("Controlled Drug", false);
                    AssignLE.SetRange("Chain Pharmacy", false);
                end;

            // YF 24 Mar 2025
            if PickRec.I9G_STBio = true then begin
                AssignLE.SetRange(I9G_STBio, true);
            end else
                if PickRec.Dedicated = true then begin
                    AssignLE.SetRange(I9G_STBio, false);
                end else begin
                    AssignLE.SetRange(I9G_STBio, false);
                    AssignLE.SetRange("Chain Pharmacy", false);
                end;
            // YF 24 Mar 2025

            //AssignLE.SetRange(Picker, '');
            if AssignLE.Count > 0 then
                exit(TRUE)
            else
                exit(FALSE);
        end else begin
            Error('No such picker, please check again.');
        end;

    end;

    local procedure AutoCreateSystemPickList(WHRec: Record "Warehouse Shipment Header")
    var
        myInt: Integer;
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseShptLine2: Record "Warehouse Shipment Line";
        ReleaseWhseShipment: Codeunit 7310;
        WHseRec: Record 7321;
    begin
        WhseShptLine2.reset;
        WhseShptLine2.SetRange("No.", WHRec."No.");
        if WhseShptLine2.FindFirst() then begin
            WhseShptLine.COPY(WhseShptLine2);
            WhseShptHeader.GET(WhseShptLine."No.");
            IF WhseShptHeader.Status = WhseShptHeader.Status::Open THEN
                ReleaseWhseShipment.Release(WhseShptHeader);
            //WHseRec.CreatePickDoc(WhseShptLine, WhseShptHeader);
            CreatePickDoc(WhseShptLine, WhseShptHeader);        //Call duplicated function from core
            //DX        120521      Added this line cause it doesn't trigger the default subscriber event, so manual create the pick list.
            CreateAssignmentLedgerWithPickList(WhseShptHeader);
            //DX        120521      Update original SO status
        end;
    end;
    //DX        110521      Copy existing system function and replicate in BC
    local procedure CreatePickDoc(VAR WhseShptLine: Record "Warehouse Shipment Line"; WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        WhseShptHeader2.TESTFIELD(Status, WhseShptHeader2.Status::Released);
        WhseShptLine.SETFILTER(Quantity, '>0');
        WhseShptLine.SETRANGE("Completely Picked", FALSE);
        IF WhseShptLine.FIND('-') THEN
            CreatePickDocFromWhseShpt(WhseShptLine, WhseShptHeader2);
        /*
        ELSE
            IF NOT HideValidationDialog THEN
                MESSAGE(Text011);
        */
    end;

    local procedure CreatePickDocFromWhseShpt(VAR WhseShptLine: Record "Warehouse Shipment Line"; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhseShipmentCreatePick: Report 7318;
        Ishandled: Boolean;
        WSPickRec: Record "Warehouse Activity Line"; // YF 13082021
        SalesLine: Record "Sales Line"; // YF 13082021
    begin
        IsHandled := FALSE;
        IF NOT IsHandled THEN BEGIN

            Commit(); // YF 011121 // Using the legendary Commit before running report to see if it resolves table lock/deadlock issues

            WhseShipmentCreatePick.SetWhseShipmentLine(WhseShptLine, WhseShptHeader);
            WhseShipmentCreatePick.SetHideValidationDialog(FALSE);
            WhseShipmentCreatePick.Initialize('', Enum::"Whse. Activity Sorting Method"::"Action Type", false, true, false);      //DX        22 July 2021    
            WhseShipmentCreatePick.USEREQUESTPAGE(FALSE);   //DX        110521      Mainly to skip this request page prompting up for user
            WhseShipmentCreatePick.RUNMODAL;
            //WhseShipmentCreatePick.GetResultMessage;      //DX        170121      Hide away creat pick doc message
            CLEAR(WhseShipmentCreatePick);

            // YF 13082021 Codes here because this custom function doesn't trigger the default subscriber event - To set To Pick Qty
            WSPickRec.reset;
            WSPickRec.SetLoadFields("Whse. Document No.", "Source Document", "CS Pick Qty");  //DX        16 May 2023
            WSPickRec.SetCurrentKey("Whse. Document No.", "Source Document");    //DX        10 May 2023
            WSPickRec.SetRange("Whse. Document No.", WhseShptHeader."No.");
            WSPickRec.SetRange("Source Document", WSPickRec."Source Document"::"Sales Order");
            if WSPickRec.FindSet() then
                repeat
                    SalesLine.Reset;
                    SalesLine.SetLoadFields("Document No.", "Document Type", "Line No.", "Quantity (Base)", "FOC (Qty) To Deliver", "Qty To Deliver");     //DX        06 May 2023
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", WSPickRec."Source No.");
                    SalesLine.SetRange("Line No.", WSPickRec."Source Line No.");
                    if SalesLine.FindFirst() then begin
                        //DX        04 Sept 2021        work around by indicating the same if actual qty is lesser than to pick qty due to split batch.
                        if WSPickRec."Qty. (Base)" < SalesLine."Quantity (Base)" then begin
                            if SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver" < WSPickRec."Qty. (Base)" then
                                //WSPickRec.Validate("CS Pick Qty", SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver")
                                //DX        08 May 2026 to set the same quantity, no such cases as partial.
                                WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity)
                            else
                                //WSPickRec.Validate("CS Pick Qty", WSPickRec."Qty. (Base)");
                                WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity);
                        end
                        else begin
                            //WSPickRec.Validate("CS Pick Qty", SalesLine."Qty To Deliver" + SalesLine."FOC (Qty) To Deliver");
                            //DX        08 May 2026 to set the same quantity, no such cases as partial.
                            WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity)
                        end;

                        //DX        04 Sept 2021
                        WSPickRec.Modify(true);

                    end;
                until WSPickRec.next = 0;

            //DX        05 Sept 2021

            WSPickRec.reset;
            WSPickRec.SetLoadFields("Whse. Document No.", "Source Document", "CS Pick Qty");  //DX        16 May 2023
            WSPickRec.SetCurrentKey("Whse. Document No.", "Source Document");    //DX        10 May 2023
            WSPickRec.SetRange("Whse. Document No.", WhseShptHeader."No.");
            WSPickRec.SetRange("Source Document", WSPickRec."Source Document"::"Outbound Transfer");
            if WSPickRec.FindSet() then
                repeat
                    //WSPickRec.Validate("CS Pick Qty", WSPickRec."Qty. (Base)");
                    WSPickRec.Validate("CS Pick Qty", WSPickRec.Quantity);
                    //DX        04 Sept 2021
                    WSPickRec.Modify(true);
                until WSPickRec.next = 0;
            //DX        05 Sept 2021
            // YF 13082021 Codes here because this custom function doesn't trigger the default subscriber event - To set To Pick Qty
        end;
    end;

    local procedure ALEExists(SONo: code[20]) DoesExist: Boolean
    var
        ALErec: Record "Assignment Ledger Entry";
    begin
        ALErec.reset;
        ALErec.SetLoadFields("Document No.");       //DX        06 May 2023
        ALErec.SetRange("Document No.", SONo);
        if ALErec.count > 0 then
            exit(TRUE)
        else
            exit(FALSE);
    end;


    procedure UpdateTripEndDateTime(WHDoc: code[20])
    var
        TotalLine: Integer;
        LineComp: Integer;
        WHTripLine: Record "WH Trip Line";
        WHTrip: Record "WH Trip Header";
        ALERec: Record "Assignment Ledger Entry";
    begin
        WHTripLine.reset;
        WHTripLine.SetRange("Doc No.", WHDoc);
        TotalLine := WHTripLine.Count;

        WHTripLine.reset;
        WHTripLine.SetRange("Doc No.", WHDoc);
        WHTripLine.SetRange("Line Completed", True);
        LineComp := WHTripLine.Count;

        if LineComp = TotalLine then begin
            WHTrip.reset;
            WHTrip.SetRange("No.", WHDoc);
            if WHTrip.FindFirst() then begin
                WHTrip."Trip End" := CreateDateTime(Today, time());
                WHTrip.Modify(TRUE);

                ALERec.reset;
                ALERec.SetRange("Picking Doc No.", WHDoc);
                if ALERec.FindFirst() then begin
                    ALERec."End Time" := CreateDateTime(Today, time());
                    ALERec.Modify(TRUE);
                end;
            end;

        end;

    end;

    //DX        01 Jun 2021 


    procedure DeleteWHShipmentAndPickingTO(SHRec: Record "Transfer Header")
    var
        DocNo: code[20];
        WhActivityLineRec: Record "Warehouse Activity Line";
        WhActivityHeaderRec: Record "Warehouse Activity Header";
        WHShipHeaderRec: Record "Warehouse Shipment Header";
        WHShipLineRec: Record "Warehouse Shipment Line";
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        //ALERec.SetRange("Picking Doc No.", WhActivityHeaderRec."No.");
        ALERec.SetRange("Document No.", SHRec."No.");
        ALERec.SetFilter("Customer No.", '<>%1', 'Deleted Document');
        ALERec.SetFilter("Invoice No.", '%1', '');
        if ALERec.FindFirst() then begin
            ALERec."Check End Time" := 0DT;
            ALERec."Check Start Time" := 0DT;
            ALERec."Checking Doc No." := '';
            ALERec."Customer Name" := '';
            ALERec."Customer No." := 'Deleted Document';
            ALERec."Driver Doc No." := '';
            ALERec."Driver End Time" := 0DT;
            ALERec."Driver Start Time" := 0DT;
            ALERec."End Time" := 0DT;
            ALERec."Invoice No." := '';
            ALERec.Picker := '';
            ALERec."Picking Doc No." := '';
            ALERec."Posting Date" := 0D;
            ALERec."Priority Picking" := false;
            ALERec."Start Time" := 0DT;
            ALERec.Basket := '';
            //DX    04 July 2021 : change to completed status so that assignment logic will not pick deleted documents.
            ALERec.Status := ALERec.Status::Completed;
            ALERec.Modify(TRUE);
        end;


        WhActivityLineRec.reset;
        WhActivityLineRec.SetRange("Source Document", WhActivityLineRec."Source Document"::"Outbound Transfer");
        WhActivityLineRec.SetRange("Source No.", SHRec."No.");
        if WhActivityLineRec.FindFirst() then begin
            DocNo := WhActivityLineRec."Whse. Document No.";
            WhActivityHeaderRec.reset;
            WhActivityHeaderRec.SetRange("No.", WhActivityLineRec."No.");
            if WhActivityHeaderRec.FindFirst() then begin
                WhActivityHeaderRec.Delete(TRUE);       //DX        01 June 2021 : Delete the picking list first
            end;
        end;

        WHShipLineRec.reset;
        WHShipLineRec.SetRange("Source No.", SHRec."No.");
        if WHShipLineRec.FindFirst() then begin
            WHShipHeaderRec.reset;
            WHShipHeaderRec.SetRange("No.", WHShipLineRec."No.");
            if WHShipHeaderRec.FindFirst() then begin
                WHShipHeaderRec.Validate(Status, WHShipHeaderRec.Status::Open);
                WHShipHeaderRec.Modify(true);
                WHShipHeaderRec.Delete(true);     //DX        01 June 2021 : Delete the pickinn list first
            end;
        end;
        Message('Warehouse document has been deleted.');
    end;
    //DX        01 Jun 2021 
    procedure DeleteWHShipmentAndPicking(SHRec: Record "Sales Header")
    var
        DocNo: code[20];
        WhActivityLineRec: Record "Warehouse Activity Line";
        WhActivityHeaderRec: Record "Warehouse Activity Header";
        WHShipHeaderRec: Record "Warehouse Shipment Header";
        WHShipLineRec: Record "Warehouse Shipment Line";
        ALERec: Record "Assignment Ledger Entry";
        BasketRec: Record Basket;
    begin
        ALERec.reset;
        //ALERec.SetRange("Picking Doc No.", WhActivityHeaderRec."No.");
        ALERec.SetRange("Document No.", SHRec."No.");
        ALERec.SetFilter("Customer No.", '<>%1', 'Deleted Document');
        ALERec.SetFilter("Invoice No.", '%1', '');
        if ALERec.FindFirst() then begin
            SetBasketAvail(ALERec.Basket);
            SetBasketAvail(ALERec."2nd Basket Code");
            ALERec."Check End Time" := 0DT;
            ALERec."Check Start Time" := 0DT;
            ALERec."Checking Doc No." := '';
            ALERec."Customer Name" := '';
            ALERec."Customer No." := 'Deleted Document';
            ALERec."Driver Doc No." := '';
            ALERec."Driver End Time" := 0DT;
            ALERec."Driver Start Time" := 0DT;
            ALERec."End Time" := 0DT;
            ALERec."Invoice No." := '';
            ALERec.Picker := '';
            ALERec."Picking Doc No." := '';
            ALERec."Posting Date" := 0D;
            ALERec."Priority Picking" := false;
            ALERec."Start Time" := 0DT;
            ALERec.Basket := '';
            //DX    04 July 2021 : change to completed status so that assignment logic will not pick deleted documents.
            ALERec.Status := ALERec.Status::Completed;
            ALERec.Modify(TRUE);
        end;


        WhActivityLineRec.reset;
        WhActivityLineRec.SetRange("Source Document", WhActivityLineRec."Source Document"::"Sales Order");
        WhActivityLineRec.SetRange("Source No.", SHRec."No.");
        if WhActivityLineRec.FindFirst() then begin
            DocNo := WhActivityLineRec."Whse. Document No.";
            WhActivityHeaderRec.reset;
            WhActivityHeaderRec.SetRange("No.", WhActivityLineRec."No.");
            if WhActivityHeaderRec.FindFirst() then begin
                WhActivityHeaderRec.Delete(TRUE);       //DX        01 June 2021 : Delete the pickinn list first
            end;
        end;

        WHShipLineRec.reset;
        WHShipLineRec.SetRange("Source No.", SHRec."No.");
        if WHShipLineRec.FindFirst() then begin
            WHShipHeaderRec.reset;
            WHShipHeaderRec.SetRange("No.", WHShipLineRec."No.");
            if WHShipHeaderRec.FindFirst() then begin
                WHShipHeaderRec.Validate(Status, WHShipHeaderRec.Status::Open);
                WHShipHeaderRec.Modify(true);
                WHShipHeaderRec.Delete(true);     //DX        01 June 2021 : Delete the pickinn list first
                Message('Warehouse document has been deleted.');
            end;
        end;

    end;
    //DX        01 Jun 2021 

    procedure DeleteWHSalesReturnandDoc(SHRec: Record "Sales Header")
    var
        DocNo: code[20];
        WhActivityLineRec: Record "Warehouse Activity Line";
        WhActivityHeaderRec: Record "Warehouse Activity Header";
        WHShipHeaderRec: Record "Warehouse Receipt Header";
        WHShipLineRec: Record "Warehouse Receipt Line";
        ALERec: Record "Assignment Ledger Entry";
        BasketRec: Record Basket;
    begin

        WhActivityLineRec.reset;
        WhActivityLineRec.SetLoadFields("Source Document", "Source No.", "No.", "Whse. Document No.");//DX       06 May 2023
        WhActivityLineRec.SetRange("Source Document", WhActivityLineRec."Source Document"::"Sales Return Order");
        WhActivityLineRec.SetRange("Source No.", SHRec."No.");
        if WhActivityLineRec.FindFirst() then begin
            DocNo := WhActivityLineRec."Whse. Document No.";
            WhActivityHeaderRec.reset;
            WhActivityHeaderRec.SetRange("No.", WhActivityLineRec."No.");
            if WhActivityHeaderRec.FindFirst() then begin
                WhActivityHeaderRec.Delete(TRUE);       //DX        01 June 2021 : Delete the pickinn list first
            end;
        end;

        WHShipLineRec.reset;
        WHShipLineRec.SetLoadFields("Source No.", "No.");//DX       06 May 2023
        WHShipLineRec.SetRange("Source No.", SHRec."No.");
        if WHShipLineRec.FindFirst() then begin
            WHShipHeaderRec.reset;
            WHShipHeaderRec.SetRange("No.", WHShipLineRec."No.");
            if WHShipHeaderRec.FindFirst() then begin
                //WHShipHeaderRec.Validate("Document Status", WHShipHeaderRec."Document Status"::);
                //WHShipHeaderRec.Modify(true);
                WHShipHeaderRec.Delete(true);     //DX        01 June 2021 : Delete the pickinn list first
                Message('Warehouse document has been deleted.');
            end;
        end;

    end;

    //DX            11 Jun 2021
    procedure CheckTripHasMaxOf2PL(TripRec: Record "WH Trip Header"): Boolean
    var
        myInt: Integer;
        TripLineRec: Record "WH Trip Line";
    begin
        TripLineRec.Reset();
        TripLineRec.SetLoadFields("Doc No.", "Pick Doc No.");//DX       06 May 2023
        TripLineRec.SetRange("Doc No.", TripRec."No.");
        TripLineRec.SetFilter("Pick Doc No.", '<>%1', '');
        if TripLineRec.count >= 2 then
            exit(true)
        else
            exit(False);


    end;

    procedure CheckBasketIsAvailable(BasketCode: Code[20])
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.Reset();
        ALERec.SetLoadFields(Basket, "Picking Doc No.", "Trip Doc No.", "Start Time", "End Time");//DX       06 May 2023
        ALERec.SetRange(Basket, BasketCode);
        ALERec.Setfilter("Picking Doc No.", '<>%1', '');  //Check that got pick doc assigned
        ALERec.SetFilter("Trip Doc No.", '<>%1', '');// check that got trip already
        ALERec.SetFilter("Start Time", '<>%1', 0DT);
        ALERec.SetFilter("End Time", '%1', 0DT);
        if ALERec.Count > 0 then
            Message('Basket is already being assigned to an in process pick list, please change basket.');
    end;

    //DX            11 Jun 2021

    procedure DeletePickLineFromWHTrip(TripLine: Record "WH Trip Line")
    var
        myInt: Integer;
        ALErec: Record "Assignment Ledger Entry";
    begin
        ALErec.reset;
        ALErec.SetRange("Picking Doc No.", TripLine."Pick Doc No.");
        if ALErec.FindFirst() then begin
            ALErec.Basket := '';
            ALErec."Trip Doc No." := '';
            ALErec."Start Time" := 0DT;
            ALErec.Status := ALErec.Status::Processing;
            ALErec.Picker := '';
            ALErec.Modify(TRUE);
        end;
    end;


    procedure GetPickListTypeFromRegPickingList(WSline: Record "Warehouse Activity Line"): Integer
    var
        myInt: Integer;
        LWSLine: Record "Warehouse Activity Line";
        ColdExist: Boolean;
        NonColdExist: Boolean;
        ItemRec: Record item;
    begin
        ColdExist := false;
        NonColdExist := false;
        LWSLine.reset;
        LWSLine.SetRange("Whse. Document No.", WSline."Whse. Document No.");
        LWSLine.SetRange("Action Type", LWSLine."Action Type"::Take);
        LWSLine.SetFilter("Qty. to Handle", '<>0');
        if LWSLine.FindSet() then
            repeat
                ItemRec.reset;
                ItemRec.SetRange("No.", LWSLine."Item No.");
                if ItemRec.FindFirst() then begin
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::Fridge then
                        ColdExist := true;
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::"Non-Fridge" then
                        NonColdExist := true;
                end;
            until LWSLine.next() = 0;
        If (ColdExist = false) and (NonColdExist = true) then
            exit(1)
        else
            If (ColdExist = true) and (NonColdExist = false) then
                exit(2)
            else
                If (ColdExist = true) and (NonColdExist = true) then
                    exit(3);
    end;



    //DX        06 Sept 2021        : To take from pick list instead and not source document.
    procedure GetPickListTypeFromPickingList(var WSline: Record "Warehouse Activity Line"): Integer
    var
        myInt: Integer;
        LWSLine: Record "Warehouse Activity Line";
        ColdExist: Boolean;
        NonColdExist: Boolean;
        ItemRec: Record item;
    begin
        ColdExist := false;
        NonColdExist := false;
        LWSLine.reset;
        LWSLine.SetLoadFields("Whse. Document No.", "Action Type", "Item No.");  //DX        02 May 2023
        LWSLine.SetRange("Whse. Document No.", WSline."Whse. Document No.");
        LWSLine.SetRange("Action Type", LWSLine."Action Type"::Take);
        if LWSLine.FindSet() then
            repeat
                ItemRec.reset;
                ItemRec.SetLoadFields("No.", "Storage Condition");//DX       06 May 2023
                ItemRec.SetRange("No.", LWSLine."Item No.");
                if ItemRec.FindFirst() then begin
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::Fridge then
                        ColdExist := true;
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::"Non-Fridge" then
                        NonColdExist := true;
                end;
            until LWSLine.next() = 0;
        If (ColdExist = false) and (NonColdExist = true) then
            exit(1)
        else
            If (ColdExist = true) and (NonColdExist = false) then
                exit(2)
            else
                If (ColdExist = true) and (NonColdExist = true) then
                    exit(3);
    end;

    procedure GetPickListTypeFromSalesInv(SaleInvNo: Code[20]): Integer
    var
        myInt: Integer;
        LWSLine: Record "Warehouse Activity Line";
        SalesInvLine: Record "Sales Invoice Line";
        ColdExist: Boolean;
        NonColdExist: Boolean;
        ItemRec: Record item;
    begin
        ColdExist := false;
        NonColdExist := false;
        SalesInvLine.reset;
        SalesInvLine.SetLoadFields("Document No.", Type, "No.", Quantity);//DX     06 May 2023
        SalesInvLine.SetRange("Document No.", SaleInvNo);
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter("No.", '<>%1', '');
        SalesInvLine.SetFilter(Quantity, '<>0');
        if SalesInvLine.FindSet() then
            repeat
                ItemRec.reset;
                ItemRec.SetLoadFields("No.", "Storage Condition");  //DX       06 May 2023
                ItemRec.SetRange("No.", SalesInvLine."No.");
                if ItemRec.FindFirst() then begin
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::Fridge then
                        ColdExist := true;
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::"Non-Fridge" then
                        NonColdExist := true;
                end;
            until SalesInvLine.next() = 0;
        If (ColdExist = false) and (NonColdExist = true) then
            exit(1)
        else
            If (ColdExist = true) and (NonColdExist = false) then
                exit(2)
            else
                If (ColdExist = true) and (NonColdExist = true) then
                    exit(3);
    end;


    //DX        06 Sept 2021

    procedure CheckIfColdPickIsCompleted(WHActLine: Record "Warehouse Activity Line"): Boolean
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Picking Doc No.", "2nd Basket Code");//DX       06 May 2023
        ALERec.SetRange("Picking Doc No.", WHActLine."No.");
        if ALERec.FindFirst() then begin
            if ALERec."2nd Basket Code" = '' then
                exit(false)
            else
                exit(true);
        end;
    end;

    procedure CreateColdTripPickingLine(var PLRec: Record "Warehouse Activity Header"; ColdBasket: code[20])
    var
        myInt: Integer;
        LineNo: Integer;
        ALERec: Record "Assignment Ledger Entry";
        WHTripRec: Record "WH Trip Header";
        WLTripRec: Record "WH Trip Line";
    begin
        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", PLRec."No.");
        if ALERec.FindFirst() then begin
            if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                WLTripRec.reset;
                WLTripRec.SetRange("Doc No.", ALERec."Trip Doc No.");
                if WLTripRec.FindLast() then begin
                    LineNo := WLTripRec."Line No." + 10000;
                end else begin
                    LineNo := 10000;
                end;

                WLTripRec.reset;
                WLTripRec.Init();
                WLTripRec."Doc No." := ALERec."Trip Doc No.";
                WLTripRec."Line No." := LineNo;
                WLTripRec."Pick Doc No." := ALERec."Picking Doc No.";
                //WLTripRec."Trolley No." := TrolleyCode;
                WLTripRec."Basket No." := ColdBasket;
                WLTripRec."Source No." := ALERec."Customer No.";
                WLTripRec."Source Name" := ALERec."Customer Name";
                WLTripRec."2nd Pick" := true;
                WLTripRec.Insert(TRUE);

                ALERec."2nd Basket Code" := ColdBasket;
                ALERec.Modify(false);

                PLRec."Cold Room Basket Code" := ColdBasket;
                PLRec.Modify(FALSE);

                Message('Cold Store Trip created.');
            end;
        end else begin
            Error('Picking list is not a combined area pick type, there is no need to trigger complete non cold store action.');
        end;

    end;

    procedure PLColdPickHasBeenCreated(PLRec: Record "Warehouse Activity Header"): Boolean
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        WLTripRec: Record "WH Trip Line";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Picking Doc No.", "Trip Doc No.");//DX       06 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");        //DX        30 May 2023
        ALERec.SetRange("Picking Doc No.", PLRec."No.");
        if ALERec.FindFirst() then begin
            WLTripRec.reset;
            WLTripRec.SetLoadFields("Doc No.", "Pick Doc No.", "2nd Pick");       //DX        30 May 2023
            WLTripRec.SetCurrentKey("Doc No.", "Pick Doc No.", "2nd Pick");       //DX        30 May 2023
            WLTripRec.SetRange("Doc No.", ALERec."Trip Doc No.");
            WLTripRec.SetRange("Pick Doc No.", PLRec."No.");
            WLTripRec.SetRange("2nd Pick", true);
            if WLTripRec.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    //DX        09 July 2021

    //DX        13 July 2021    Create stock take card from warehouse journals
    procedure CreateStockCard(PhysJnl: Record "Warehouse Journal Line")
    var
        myInt: Integer;
        SSSetup: Record "Sales & Receivables Setup";
    begin
        SSSetup.reset;
        SSSetup.get;
        SSSetup.TestField("Def. Stock Take No. Series");
        Message('created');
    end;
    //DX        13 July 2021

    //DX        28 July 2021
    procedure AllLinesHaveStock(SHRec: Record "Sales Header"): Code[20]
    var
        myInt: Integer;
        LineCount: Integer;
        InvBal: Decimal;
        SLRec: Record "Sales Line";
        ItemRec: Record Item;
        GotStock: Boolean;
        ItemNo: Code[20];
    begin
        ItemNo := '';
        LineCount := 0;
        SLRec.reset;
        SLRec.SetLoadFields("Document Type", "Document No.", Type, "No.", Quantity);//DX       06 May 2023
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("Document No.", SHRec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter("No.", '<>%1', '');
        SLRec.SetFilter(Quantity, '<>0');
        if SLRec.FindSet() then
            repeat
                ItemRec.reset;
                ItemRec.SetLoadFields("No.", Inventory);//DX       06 May 2023
                ItemRec.SetRange("No.", SLRec."No.");
                ItemRec.SetFilter("Location Filter", SHRec."Location Code");
                if ItemRec.FindFirst() then begin
                    ItemRec.CalcFields(Inventory);
                    InvBal := ItemRec.Inventory;
                end;
                if InvBal <= 0 then begin
                    LineCount += 1;
                    ItemNo := SLRec."No.";
                end;

            until SLRec.next = 0;

        if LineCount = SLRec.Count then     //If total lines all have no stock at all.
            exit('')
        else
            exit(ItemNo);             //if have partial stock for some lines and some don't have.
    end;
    //DX        28 July 2021


    // YF        16 August 2021
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterSalesPost', '', true, true)]
    // local procedure OnAfterSalesPost(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SalesHeader: Record "Sales Header"; Invoice: Boolean)
    // var
    //     WhsePickLines: Record "Warehouse Activity Line";
    //     CanDelete: Boolean;
    // begin
    //     CanDelete := false;

    //     if not Invoice then begin
    //         // Check for related pick lines to decide deletion
    //         WhsePickLines.Reset;
    //         WhsePickLines.SetLoadFields("Whse. Document No.");  //DX        06 May 2023
    //         WhsePickLines.SetRange("Whse. Document No.", WarehouseShipmentLine."No.");
    //         if WhsePickLines.FindFirst() then
    //             CanDelete := false
    //         else
    //             CanDelete := true;
    //     end;
    //     /*
    //             if NOT (WarehouseShipmentLine.IsEmpty) then begin   //DX        20 Aug 2021     To resolve the error for after post
    //                 WarehouseShipmentLine."Delete After Post" := CanDelete;
    //                 WarehouseShipmentLine.Modify();
    //             end;
    //     */
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Whse. Post Shipment", 'OnAfterSalesPost', '', true, true)]
    local procedure SalesWhsePostShipment_OnAfterSalesPost(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SalesHeader: Record "Sales Header"; WhsePostParameters: Record "Whse. Post Parameters")
    var
        WhsePickLines: Record "Warehouse Activity Line";
        CanDelete: Boolean;
    begin
        CanDelete := false;

        if not WhsePostParameters."Post Invoice" then begin
            // Check for related pick lines to decide deletion
            WhsePickLines.Reset;
            WhsePickLines.SetLoadFields("Whse. Document No.");  //DX        06 May 2023
            WhsePickLines.SetRange("Whse. Document No.", WarehouseShipmentLine."No.");
            if WhsePickLines.FindFirst() then
                CanDelete := false
            else
                CanDelete := true;
        end;
        /*
                if NOT (WarehouseShipmentLine.IsEmpty) then begin   //DX        20 Aug 2021     To resolve the error for after post
                    WarehouseShipmentLine."Delete After Post" := CanDelete;
                    WarehouseShipmentLine.Modify();
                end;
        */
    end;
    // YF        16 August 2021
    //DX        18 Aug 2021 To handle the new exchangeable process
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostSourceDocument', '', true, true)]
    local procedure OnBeforePostSourceDocument(PurchaseHeader: Record "Purchase Header"; var WhseRcptLine: Record "Warehouse Receipt Line")
    var
        PLRec: Record "Purchase Line";
        ResEntry: Record "Reservation Entry";
        ItemRec: Record item;
    begin
        if WhseRcptLine."Source Document" = WhseRcptLine."Source Document"::"Purchase Order" then begin
            ResEntry.RESET;
            ResEntry.SetLoadFields("Item No.", "Location Code", "Source ID", "Source Type", "Source Subtype", "Source Ref. No.", "Item Tracking");    //DX        06 May 2023
            ResEntry.SETRANGE("Item No.", WhseRcptLine."Item No.");
            ResEntry.SETRANGE("Location Code", WhseRcptLine."Location Code");
            ResEntry.SETRANGE("Source ID", WhseRcptLine."Source No.");
            ResEntry.SETRANGE("Source Type", 39);
            ResEntry.SETRANGE("Source Subtype", 1);
            ResEntry.SETRANGE("Source Ref. No.", WhseRcptLine."Source Line No.");
            ResEntry.SETRANGE("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
            IF ResEntry.FINDFIRST THEN BEGIN
                ItemRec.reset;
                ItemRec.SetLoadFields("No.", Exchangeable);//DX        06 May 2023
                ItemRec.SetRange("No.", WhseRcptLine."Item No.");
                ItemRec.SetRange(Exchangeable, true);  // Check tha item is allowed for exchange first
                if ItemRec.FindFirst() then begin
                    IF (ResEntry."Expiration Date" - Today) < 365 then begin        //Check that expiration is less than 365 days from today.
                        PLRec.reset;
                        PLRec.SetRange("Document No.", WhseRcptLine."Source No.");
                        PLRec.SetRange("Line No.", WhseRcptLine."Source Line No.");
                        if PLRec.FindFirst() then begin
                            PLRec.Exchangeable := true;         //Set that the PL Line is exchangeable automatically.
                            PLRec.Modify(FALSE);
                        end;

                    end;
                end;
            END;

            //DX
        end;
    end;
    //DX        18 Aug 2021

    // YF 24 Mar 2025
    procedure IsSTBio(DocNo: Code[20]): Boolean
    var
        ItemRec: Record item;
        SHRec: Record "Sales Header";
        THRec: Record "Transfer Header";
        SLRec: Record "Sales Line";
        TLRec: Record "Transfer Line";
        ForensicRec: Record "Forensic Group";
        PHRec: Record "Purchase Header";
        PLRec: Record "Purchase Line";
    begin
        SHRec.reset;
        SHRec.SetLoadFields("No.", "Document Type");
        SHRec.SetRange("No.", DocNo);
        if SHRec.FindFirst() then begin
            SLRec.reset;
            SLRec.SetLoadFields(Type, "Document No.", "Document Type", "No.", Quantity);
            SLRec.SetRange(Type, SLRec.Type::Item);
            SLRec.SetRange("Document Type", SHRec."Document Type");
            SLRec.SetRange("Document No.", SHRec."No.");
            SLRec.SetFilter("No.", '<>%1', '');
            SLRec.SetFilter(Quantity, '<>0');
            if SLRec.FindSet() then
                repeat
                    ItemRec.reset;
                    ItemRec.SetLoadFields("No.", "Forensic Group");
                    ItemRec.SetRange("No.", SLRec."No.");
                    if ItemRec.FindFirst() then begin
                        ForensicRec.reset;
                        ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                        ForensicRec.SetRange(I9G_STBio, true);
                        if ForensicRec.FindFirst() then
                            exit(TRUE);
                    end;
                until SLRec.next = 0;
        end;

        THRec.Reset();
        THRec.SetLoadFields("No.");
        THRec.SetRange("No.", DocNo);
        if THRec.FindFirst() then begin
            TLRec.reset;
            TLRec.SetLoadFields("Document No.", "Item No.");
            TLRec.SetRange("Document No.", THRec."No.");
            if tlrec.FindSet() then
                repeat
                    ItemRec.reset;
                    ItemRec.SetLoadFields("No.", "Forensic Group");
                    ItemRec.SetRange("No.", tlrec."Item No.");
                    if ItemRec.FindFirst() then begin
                        ForensicRec.reset;
                        ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                        ForensicRec.SetRange(I9G_STBio, true);
                        if ForensicRec.FindFirst() then
                            exit(TRUE);
                    end;
                until tlrec.next = 0;
        end;

        PHRec.Reset();
        PHRec.SetLoadFields("No.");
        PHRec.SetRange("No.", DocNo);
        if PHRec.FindFirst() then begin
            PLRec.reset;
            PLRec.SetLoadFields("Document Type", "Document No.");
            PLRec.SetRange("Document No.", PHRec."No.");
            if PLRec.FindSet() then
                repeat
                    ItemRec.reset;
                    ItemRec.SetLoadFields("No.", "Forensic Group");
                    ItemRec.SetRange("No.", PLRec."No.");
                    if ItemRec.FindFirst() then begin
                        ForensicRec.reset;
                        ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                        ForensicRec.SetRange(I9G_STBio, true);
                        if ForensicRec.FindFirst() then
                            exit(TRUE);
                    end;
                until PLRec.next = 0;
        end;

        exit(false);
    end;
    // YF 24 Mar 2025

    //DX       22 Aug 2021
    procedure IsCD(DocNo: Code[20]): Boolean
    var
        myInt: Integer;
        ItemRec: Record item;
        SHRec: Record "Sales Header";
        THRec: Record "Transfer Header";
        SLRec: Record "Sales Line";
        TLRec: Record "Transfer Line";
        ForensicRec: Record "Forensic Group";
        PHRec: Record "Purchase Header";
        PLRec: Record "Purchase Line";
    begin
        SHRec.reset;
        SHRec.SetLoadFields("No.", "Document Type");//DX        06 May 2023
        SHRec.SetRange("No.", DocNo);
        if SHRec.FindFirst() then begin
            SLRec.reset;
            SLRec.SetLoadFields(Type, "Document No.", "Document Type", "No.", Quantity);//DX        06 May 2023
            SLRec.SetRange(Type, SLRec.Type::Item);
            SLRec.SetRange("Document Type", SHRec."Document Type");
            SLRec.SetRange("Document No.", SHRec."No.");
            SLRec.SetFilter("No.", '<>%1', '');
            SLRec.SetFilter(Quantity, '<>0');
            if SLRec.FindSet() then
                repeat
                    ItemRec.reset;
                    ItemRec.SetLoadFields("No.", "Forensic Group");//DX        06 May 2023
                    ItemRec.SetRange("No.", SLRec."No.");
                    if ItemRec.FindFirst() then begin
                        ForensicRec.reset;
                        ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                        ForensicRec.SetRange("Controlled Drug", true);
                        if ForensicRec.FindFirst() then
                            exit(TRUE);
                    end;
                until SLRec.next = 0;
        end;

        THRec.Reset();
        THRec.SetLoadFields("No.");//DX        06 May 2023
        THRec.SetRange("No.", DocNo);
        if THRec.FindFirst() then begin
            TLRec.reset;
            TLRec.SetLoadFields("Document No.", "Item No.");//DX        06 May 2023
            TLRec.SetRange("Document No.", THRec."No.");
            if tlrec.FindSet() then
                repeat
                    ItemRec.reset;
                    ItemRec.SetLoadFields("No.", "Forensic Group");//DX        06 May 2023
                    ItemRec.SetRange("No.", tlrec."Item No.");
                    if ItemRec.FindFirst() then begin
                        ForensicRec.reset;
                        ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                        ForensicRec.SetRange("Controlled Drug", true);
                        if ForensicRec.FindFirst() then
                            exit(TRUE);
                    end;
                until tlrec.next = 0;
        end;

        PHRec.Reset();
        PHRec.SetLoadFields("No.");//DX        06 May 2023
        PHRec.SetRange("No.", DocNo);
        if PHRec.FindFirst() then begin
            PLRec.reset;
            PLRec.SetLoadFields("Document Type", "Document No.");//DX        06 May 2023
            PLRec.SetRange("Document No.", PHRec."No.");
            if PLRec.FindSet() then
                repeat
                    ItemRec.reset;
                    ItemRec.SetLoadFields("No.", "Forensic Group");//DX        06 May 2023
                    ItemRec.SetRange("No.", PLRec."No.");
                    if ItemRec.FindFirst() then begin
                        ForensicRec.reset;
                        ForensicRec.SetRange("Forensic Group", ItemRec."Forensic Group");
                        ForensicRec.SetRange("Controlled Drug", true);
                        if ForensicRec.FindFirst() then
                            exit(TRUE);
                    end;
                until PLRec.next = 0;
        end;

        exit(false);
    end;

    procedure IsChainPharmacy(DocNo: Code[20]): Boolean
    var
        myInt: Integer;
        AllowedList: Record "Allowed Cust-Item";
        SHRec: Record "Sales Header";
    begin
        SHRec.reset;
        SHRec.SetLoadFields("No.", "Bill-to Customer No.", "Sell-to Customer No.");//DX        06 May 2023
        SHRec.SetRange("No.", DocNo);
        if SHRec.FindFirst() then begin
            AllowedList.reset;
            if SHRec."Bill-to Customer No." <> '' then
                AllowedList.SetRange("Cust No.", SHRec."Bill-to Customer No.")
            else
                AllowedList.SetRange("Cust No.", SHRec."Sell-to Customer No.");
            if AllowedList.FindFirst() then begin
                exit(true);
            end;
        end;
        exit(FALSE);
    end;

    //OnBeforeOpenWarehouseShipmentPage(GetSourceDocuments, IsHandled);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnBeforeOpenWarehouseShipmentPage', '', true, true)]
    local procedure OnBeforeOpenWarehouseShipmentPage(var IsHandled: Boolean)
    begin
        IsHandled := true;  //Skip the opening of the warehouse shipment page.
    end;
    //DX       22 Aug 2021


    procedure PLisValid(SHRec: Record "Sales Header"): Boolean
    var
        myInt: Integer;
        WHActLine: Record "Warehouse Activity Line";
    begin
        WHActLine.reset;
        WHActLine.SetLoadFields("Source Document", "Source No.");//DX        06 May 2023
        WHActLine.SetRange("Source Document", WHActLine."Source Document"::"Sales Order");
        WHActLine.SetRange("Source No.", SHRec."No.");
        if WHActLine.Count > 0 then
            exit(true)
        else
            exit(false);

    end;


    //DX        30 Aug 2021
    procedure UpdateBasketAfterPLRetrieved(PLRec: Record "Warehouse Activity Header")
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        TripRec: Record "WH Trip Line";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Picking Doc No.");        //DX        29 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");        //DX        29 May 2023
        ALERec.SetRange("Picking Doc No.", PLRec."No.");
        if ALERec.FindFirst() then begin
            ALERec.Basket := PLRec."Basket Code";
            ALERec.Modify(FALSE);
            TripRec.reset;
            TripRec.SetRange("Doc No.", ALERec."Trip Doc No.");
            TripRec.SetRange("Pick Doc No.", ALERec."Picking Doc No.");
            if TripRec.FindFirst() then begin
                TripRec."Basket No." := PLRec."Basket Code";
                TripRec.Modify(FALSE);
            end;
        end;

    end;


    procedure UpdateColdRoomBasketAfterPLRetrieved(PLRec: Record "Warehouse Activity Header")
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        TripRec: Record "WH Trip Line";
    begin
        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", PLRec."No.");
        if ALERec.FindFirst() then begin
            ALERec."2nd Basket Code" := PLRec."Cold Room Basket Code";
            ALERec.Modify(FALSE);
            if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                TripRec.reset;
                TripRec.SetRange("Doc No.", ALERec."Trip Doc No.");
                TripRec.SetRange("Pick Doc No.", ALERec."Picking Doc No.");
                TripRec.SetRange("2nd Pick", true);
                if TripRec.FindFirst() then begin
                    TripRec."Basket No." := PLRec."Cold Room Basket Code";
                    TripRec.Modify(FALSE);
                end;
            end else begin
                TripRec.reset;
                TripRec.SetRange("Doc No.", ALERec."Trip Doc No.");
                TripRec.SetRange("Pick Doc No.", ALERec."Picking Doc No.");
                //TripRec.SetRange("2nd Pick", true);
                if TripRec.FindFirst() then begin
                    TripRec."Basket No." := PLRec."Cold Room Basket Code";
                    TripRec.Modify(FALSE);
                end;

            end;
        end;

    end;



    procedure BasketIsUnavail(BasketCode: Code[20])
    var
        myInt: Integer;
        BasketRec: Record Basket;
    begin
        BasketRec.reset;
        BasketRec.SetLoadFields("No.", "Cold Room", Available); //DX        06 May 2023
        basketrec.SetRange("No.", BasketCode);
        Basketrec.SetRange("Cold Room", false);
        if BasketRec.FindFirst() then begin
            if BasketRec.Available = false then
                Error('Basket is already tagged as unavailable, please change.');
        end else
            Error('No such basket.');

    end;

    procedure ColdBasketIsUnavail(BasketCode: Code[20])
    var
        myInt: Integer;
        BasketRec: Record Basket;
    begin
        BasketRec.reset;
        BasketRec.SetLoadFields("No.", "Cold Room", Available);//DX        06 May 2023
        basketrec.SetRange("No.", BasketCode);
        BasketRec.SetRange("Cold Room", true);
        if BasketRec.FindFirst() then begin
            if BasketRec.Available = false then
                Error('Basket is already tagged as unavailable, please change.');
        end else
            Error('No such basket.');
    end;

    procedure SetBasketUnavail(BasketCode: Code[20])
    var
        myInt: Integer;
        BasketRec: Record Basket;
    begin
        BasketRec.reset;
        basketrec.SetRange("No.", BasketCode);
        if BasketRec.FindFirst() then begin
            BasketRec.Available := false;
            BasketRec.Modify(FALSE);
        end;
    end;

    procedure SetBasketAvail(var BasketCode: Code[20]) // YF 11 Jan 2022
    var
        BasketRec: Record Basket;
    begin
        BasketRec.Reset;
        BasketRec.SetRange("No.", BasketCode);
        if BasketRec.FindFirst() then begin
            BasketRec.Available := true;
            BasketRec.Modify(FALSE);
        end;
    end;

    //DX        30 Aug 2021

    var


    //DX        02 Oct 2021
    procedure DeleteWHPLforSOBatch(Var AssignRec: Record "Assignment Ledger Entry")
    var
        myInt: Integer;
        WHActLine: Record "Warehouse Activity Line";
        WHShip: Record "Warehouse Shipment Header";
        WHTrip: Record "WH Trip Line";
        SHRec: Record "Sales Header";
        BasketRec: Record Basket;
        PickHdr: Record "Warehouse Activity Header";
        PickList: Code[20];
        ShipHeader: Code[20];
    begin
        if (AssignRec.Status = AssignRec.Status::Completed) OR
        (AssignRec.Status = AssignRec.Status::"Pending Delivery") then
            Error('Not allowed to delete PL.');

        if UserId <> 'BCADMIN' then
            Error('cannot if not bc admin');
        PickList := AssignRec."Picking Doc No.";
        WHActLine.reset;
        WHActLine.SetRange("No.", PickList);
        if WHActLine.findfirst then begin
            ShipHeader := WHActLine."Whse. Document No.";
        end;

        PickHdr.reset;
        PickHdr.SetRange("No.", PickList);
        if PickHdr.FindFirst then begin
            PickHdr.Delete(TRUE);
        end;

        WHShip.reset;
        WHShip.SetRange("No.", ShipHeader);
        if WHShip.findfirst then begin
            WHShip.Validate(Status, WHShip.Status::Open);
            WHShip.Modify(true);
            WHShip.Delete(true);     //DX        01 June 2021 : Delete the pickinn list first
        end;

        WHTrip.reset;

        WHTrip.SetRange("Pick Doc No.", PickList);
        // YF 10 Aug 2022 // To avoid unnecessary table lock
        if not WHTrip.IsEmpty then
            WHTrip.DeleteAll(true);
        // YF 10 Aug 2022 // To avoid unnecessary table lock

        BasketRec.reset;
        BasketRec.SetRange("No.", AssignRec.Basket);
        if BasketRec.FindFirst() then begin
            BasketRec.Available := true;
            BasketRec.Modify(TRUE);
        end;

        BasketRec.reset;
        BasketRec.SetRange("No.", AssignRec."2nd Basket Code");
        BasketRec.SetRange("Cold Room", true);
        if BasketRec.FindFirst() then begin
            BasketRec.Available := true;
            BasketRec.Modify(TRUE);
        end;

        SHRec.reset;
        SHRec.SetRange("No.", AssignRec."Document No.");
        if SHRec.FindFirst() then begin
            SHRec."Order Status" := SHRec."Order Status"::Open;
            SHRec.Modify(FALSE);
        end;
        AssignRec."Customer No." := 'Deleted Document';
        AssignRec."Customer Name" := '';
        AssignRec."Checker ID" := '';
        AssignRec.Picker := '';
        AssignRec."Start Time" := 0DT;
        AssignRec."End Time" := 0DT;
        AssignRec.Picker := '';
        AssignRec.Status := AssignRec.Status::Completed;
        AssignRec.Modify(TRUE);

        Message('Updated.');
    end;
    //DX        02 Oct 2021


    procedure ResetBasket(BasketCode: Code[20]; var PLRec: Record "Warehouse Activity Header")
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        TripLine: Record "WH Trip Line";
    begin
        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", PLRec."No.");
        ALERec.SetRange(Basket, BasketCode);
        if ALERec.FindFirst() then begin
            ALERec.Basket := '';
            ALERec.Modify(false);
            SetBasketAvail(BasketCode);
            PLRec."Basket Code" := '';
            PLRec.Modify(FALSE);
            TripLine.reset;
            TripLine.SetRange("Pick Doc No.", PLRec."No.");
            TripLine.SetRange("2nd Pick", false);
            if TripLine.Findfirst then begin
                TripLine."Basket No." := '';
                TripLine.Modify(FALSE);
            end;
            Message('Basket has been reset.');
        end;
    end;


    procedure ResetColdBasket(BasketCode: Code[20]; var PLRec: Record "Warehouse Activity Header")
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        TripLine: Record "WH Trip Line";
    begin
        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", PLRec."No.");
        ALERec.SetRange("2nd Basket Code", BasketCode);
        if ALERec.FindFirst() then begin
            ALERec."2nd Basket Code" := '';
            ALERec.Modify(false);
            SetBasketAvail(BasketCode);
            PLRec."Cold Room Basket Code" := '';
            PLRec.Modify(FALSE);
            TripLine.reset;
            TripLine.SetRange("Pick Doc No.", PLRec."No.");
            TripLine.SetRange("2nd Pick", true);
            if TripLine.Findfirst then begin
                TripLine."Basket No." := '';
                TripLine.Modify(FALSE);
            end;

            Message('Cold Basket has been reset.');
        end;
    end;


    procedure CompleteTrip(var TripRec: Record "WH Trip Header")
    var
        myInt: Integer;
    begin
        TripRec."Trip End" := CreateDateTime(Today, time);
        TripRec.Modify(true);
        Message('Trip updated.');
    end;

    procedure CreateALEforAO(AORec: Record "Assembly Header")
    var
        myInt: Integer;
        ALRec: Record "Assembly Line";
        PLRec: Record "Warehouse Activity Line";
        AssignmentLedger: Record "Assignment Ledger Entry";
        lAssignLedger: Record "Assignment Ledger Entry";
    begin
        PLRec.reset;
        PLRec.SetRange("Source No.", AORec."No.");
        PLRec.SetRange("Source Document", PLRec."Source Document"::"Assembly Consumption");
        if PLRec.Count > 0 then begin       //Means PL is created, else no PL created.
            if PLRec.FindFirst() then begin end;
            lAssignLedger.reset;
            if lAssignLedger.FindLast() then
                myInt := lAssignLedger."Entry No." + 1
            else
                myInt := 1;

            AssignmentLedger.reset;
            AssignmentLedger.Init();
            AssignmentLedger."Entry No." := myInt;
            AssignmentLedger.Status := AssignmentLedger.Status::Processing;
            if GetPickListTypeFromPickingList(PLRec) = 1 then
                AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::"Non-Cold"
            else
                if GetPickListTypeFromPickingList(PLRec) = 2 then
                    AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::Cold
                else
                    if GetPickListTypeFromPickingList(PLRec) = 3 then
                        AssignmentLedger."Pick Type" := AssignmentLedger."Pick Type"::Combined;

            if PLRec."Destination Type" = PLRec."Destination Type"::" " then begin
                //TORec.SetRange("Document Type", WSPickRec."Source Document");
                AssignmentLedger."Document No." := AORec."No.";
                AssignmentLedger."Customer No." := 'ASSEMBLY';
                AssignmentLedger."Chain Pharmacy" := false;
                AssignmentLedger."Controlled Drug" := false;
                AssignmentLedger.I9G_STBio := false; // YF 24 Mar 2025
                AssignmentLedger."Customer Name" := 'ASSEMBLY';
                AssignmentLedger."Posting Date" := AORec."Posting Date";
                //02 Aug 2021    DX      Additional fields  for assignment
                AssignmentLedger."Priority No." := 1;       //DX        02 Aug 2021 : Wellaway is always 1 , first .
                AssignmentLedger."Shipment Date" := AORec."Posting Date";
                AssignmentLedger."Pick By Date" := CalcDate('<1D>', AORec."Posting Date");
                //02 Aug 2021    DX      Additional fields  for assignment                
            end;        //DX        17 Oct 2021
            AssignmentLedger."Picking Doc No." := PLRec."No.";
            AssignmentLedger.Insert(TRUE);
        end;
    end;

    procedure DeletePLforAOALE(WHActHdr: Record "Warehouse Activity Header")
    var
        myInt: Integer;
        AssignRec: Record "Assignment Ledger Entry";
    begin
        AssignRec.reset;
        AssignRec.SetRange("Picking Doc No.", WHActHdr."No.");
        if AssignRec.FindFirst() then begin
            if AssignRec.Basket <> '' then
                SetBasketAvail(AssignRec.Basket);
            if AssignRec."2nd Basket Code" <> '' then
                SetBasketAvail(AssignRec."2nd Basket Code");
            AssignRec.Basket := '';
            AssignRec."2nd Basket Code" := '';
            AssignRec."Customer No." := 'Deleted Document';
            AssignRec."Invoice No." := '';
            AssignRec."Customer Name" := '';
            AssignRec."Checker ID" := '';
            AssignRec.Picker := '';
            AssignRec."Start Time" := 0DT;
            AssignRec."End Time" := 0DT;
            AssignRec.Picker := '';
            AssignRec.Status := AssignRec.Status::Completed;
            AssignRec.Modify(TRUE);

            Message('Updated.');
        end;

    end;

    // YF 08 Nov 2021
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Receipt", 'OnBeforePostedWhseRcptHeaderInsert', '', true, true)]
    local procedure OnBeforePostedWhseRcptHeaderInsert(var PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header"; WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        PostedWhseReceiptHeader."Source Doc Type" := WarehouseReceiptHeader."Source Doc Type";
        PostedWhseReceiptHeader."Source Doc No." := WarehouseReceiptHeader."Source Doc No.";
        PostedWhseReceiptHeader."Source Ext Doc No." := WarehouseReceiptHeader."Source Ext Doc No.";
        PostedWhseReceiptHeader."Source Vend/Cust No." := WarehouseReceiptHeader."Source Vend/Cust No.";
        PostedWhseReceiptHeader."Source Vend/Cust Name" := WarehouseReceiptHeader."Source Vend/Cust Name";
        PostedWhseReceiptHeader."Source Branch" := WarehouseReceiptHeader."Source Branch";
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Activity-Register", 'OnBeforeRegisteredWhseActivHeaderInsert', '', true, true)]
    local procedure OnBeforeRegisteredWhseActivHeaderInsert(var RegisteredWhseActivityHdr: Record "Registered Whse. Activity Hdr."; WarehouseActivityHeader: Record "Warehouse Activity Header")
    begin
        RegisteredWhseActivityHdr."Source Doc Type" := WarehouseActivityHeader."Source Doc Type";
        RegisteredWhseActivityHdr."Source Doc No." := WarehouseActivityHeader."Source Doc No.";
        RegisteredWhseActivityHdr."Source Ext Doc No." := WarehouseActivityHeader."Source Ext Doc No.";
        RegisteredWhseActivityHdr."Source Vend/Cust No." := WarehouseActivityHeader."Source Vend/Cust No.";
        RegisteredWhseActivityHdr."Source Vend/Cust Name" := WarehouseActivityHeader."Source Vend/Cust Name";
        RegisteredWhseActivityHdr."Source Branch" := WarehouseActivityHeader."Source Branch";
    end;
    // YF 08 Nov 2021

    // YF 02 Dec 2021
    procedure UpdateInvoiceNo(OrderNo: Code[20]; PickingNo: Code[20]; Print: Boolean; LineNo: Integer) // YF 07 Dec 2021 // Add print parameter // YF 14 Dec 2021 // Add source line para
    var
        ALERec: Record "Assignment Ledger Entry";
        SalesInvHeaderRec: Record "Sales Invoice Header";
        SalesInvLineRec: Record "Sales Invoice Line"; // YF 14 Dec 2021
        SalesShipHeaderRec: Record "Sales Shipment Header"; // YF 14 Dec 2021
        SalesShipLineRec: Record "Sales Shipment Line"; // YF 14 Dec 2021
        SalesInvNo: Code[20]; // YF 14 Dec 2021
    begin
        SalesInvHeaderRec.Reset;
        SalesInvHeaderRec.SetRange("Order No.", OrderNo);
        SalesInvHeaderRec.SetCurrentKey("No.");
        SalesInvHeaderRec.SetAscending("No.", true);
        if SalesInvHeaderRec.FindLast() then begin
            ALERec.Reset;
            ALERec.SetRange("Picking Doc No.", PickingNo);
            ALERec.SetFilter(Status, '<>%1', ALERec.Status::Completed);
            ALERec.SetCurrentKey("Entry No.");
            ALERec.SetAscending("Entry No.", true);
            if ALERec.FindLast() then begin
                ALERec."Invoice No." := SalesInvHeaderRec."No.";
                ALERec.Modify(false);
            end;
            SalesInvHeaderRec.Mark(true);
            SalesInvNo := SalesInvHeaderRec."No."; // YF 14 Dec 2021
        end;

        // YF 28 Dec 2021 // Disabled
        /*
        // YF 14 Dec 2021 
        SalesShipHeaderRec.Reset;
        SalesShipHeaderRec.SetRange("Order No.", OrderNo);
        SalesShipHeaderRec.SetCurrentKey("No.");
        SalesShipHeaderRec.SetAscending("No.", true);
        if SalesShipHeaderRec.FindLast() then begin
            SalesShipLineRec.Reset();
            SalesShipLineRec.SetRange("Document No.", SalesShipHeaderRec."No.");
            SalesShipLineRec.SetRange("Line No.", LineNo);
            if SalesShipLineRec.FindFirst() then begin
                SalesInvLineRec.Reset();
                SalesInvLineRec.SetRange("Document No.", SalesInvNo);
                SalesInvLineRec.SetRange("Line No.", LineNo);
                if SalesInvLineRec.FindFirst() then begin
                    SalesInvLineRec."Qty To Deliver" := SalesShipLineRec."Qty To Deliver";
                    SalesInvLineRec."FOC Qty To Deliver" := SalesShipLineRec."FOC (Qty) To Deliver";
                    SalesInvLineRec.Modify(false);
                end;
            end;
        end;
        // YF 14 Dec 2021
        */
        // YF 28 Dec 2021 // Disabled

        // YF 07 Dec 2021
        SalesInvHeaderRec.MarkedOnly(true);
        if not SalesInvHeaderRec.IsEmpty() then
            if Print then
                SalesInvHeaderRec.PrintRecords(false);
        // YF 07 Dec 2021                
    end;
    // YF 02 Dec 2021

    // YF 16 Dec 2021
    procedure UpdateInvoiceNoWithShipNo(OrderNo: Code[20]; PickingNo: Code[20]; Print: Boolean; LineNo: Integer) // YF 07 Dec 2021 // Add print parameter // YF 14 Dec 2021 // Add source line para
    var
        ALERec: Record "Assignment Ledger Entry";
        SalesShipHeaderRec: Record "Sales Shipment Header"; // YF 14 Dec 2021
        SalesShipLineRec: Record "Sales Shipment Line"; // YF 14 Dec 2021
        SalesShptNo: Code[20]; // YF 14 Dec 2021
    begin
        SalesShipHeaderRec.Reset;
        SalesShipHeaderRec.SetRange("Order No.", OrderNo);
        SalesShipHeaderRec.SetCurrentKey("No.");
        SalesShipHeaderRec.SetAscending("No.", true);
        if SalesShipHeaderRec.FindLast() then begin
            ALERec.Reset;
            ALERec.SetRange("Picking Doc No.", PickingNo);
            ALERec.SetFilter(Status, '<>%1', ALERec.Status::Completed);
            ALERec.SetCurrentKey("Entry No.");
            ALERec.SetAscending("Entry No.", true);
            if ALERec.FindLast() then begin
                ALERec."Invoice No." := SalesShipHeaderRec."No.";
                ALERec.Modify(false);
            end;
            SalesShipHeaderRec.Mark(true);
            SalesShptNo := SalesShipHeaderRec."No."; // YF 14 Dec 2021
        end;

        // YF 07 Dec 2021
        SalesShipHeaderRec.MarkedOnly(true);
        if not SalesShipHeaderRec.IsEmpty() then
            if Print then
                SalesShipHeaderRec.PrintRecords(false);
        // YF 07 Dec 2021                
    end;
    // YF 02 Dec 2021    


    // YF 27 Apr 2022
    [EventSubscriber(ObjectType::Report, Report::"Calculate Whse. Adjustment", 'OnAfterInsertItemJnlLine', '', true, true)]
    local procedure OnAfterInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Reset;
        ItemJnlBatch.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
        ItemJnlBatch.SetRange(Name, ItemJournalLine."Journal Batch Name");
        if ItemJnlBatch.FindFirst() then begin
            if ItemJnlBatch."Gen. Prod. Posting Group" <> '' then begin
                ItemJournalLine.Validate("Gen. Prod. Posting Group", ItemJnlBatch."Gen. Prod. Posting Group");
                ItemJournalLine.Modify(true);
            end;
        end;
    end;
    // YF 27 Apr 2022

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnAfterCreateWhseShipmentHeaderFromWhseRequest', '', true, true)]
    local procedure OnAfterCreateWhseShipmentHeaderFromWhseRequest(var WarehouseRequest: Record "Warehouse Request"; var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseActivityLine: Record "Warehouse Activity Line";
        SalesLine: Record "Sales Line";
        ItemNoList: Text;
    begin
        Clear(ItemNoList);

        WhseShptLine.Reset();
        WhseShptLine.SetRange("No.", WhseShptHeader."No.");
        if WhseShptLine.FindSet() then begin
            repeat
                if (WhseShptLine."Source Type" = Database::"Sales Line") and (WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Sales Order") then begin
                    SalesLine.Reset();
                    if SalesLine.Get(WhseShptLine."Source Subtype", WhseShptLine."Source No.", WhseShptLine."Source Line No.") then begin
                        WhseActivityLine.Reset();
                        WhseActivityLine.SetRange("Action Type", WhseActivityLine."Action Type"::Take);
                        WhseActivityLine.SetRange("Whse. Document Type", WhseActivityLine."Whse. Document Type"::Shipment);
                        WhseActivityLine.SetRange("Whse. Document No.", WhseShptLine."No.");
                        WhseActivityLine.SetRange("Whse. Document Line No.", WhseShptLine."Line No.");
                        WhseActivityLine.CalcSums(Quantity);

                        if SalesLine.Quantity <> WhseActivityLine.Quantity then begin
                            if ItemNoList = '' then begin
                                ItemNoList := WhseShptLine."Item No.";
                            end else begin
                                ItemNoList := ItemNoList + ', ' + WhseShptLine."Item No.";
                            end;
                        end;
                    end;
                end;
            until WhseShptLine.Next() = 0;
        end;

        if ItemNoList <> '' then begin
            Message('Quantity for Item No.: %1 in Warehouse Pick is insufficient.', ItemNoList);
        end;
    end;
}