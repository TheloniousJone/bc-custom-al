codeunit 55004 "Driver CU"
{
    trigger OnRun()
    begin

    end;

    procedure CreateDriverCard(VAR DriverRec: Record "Driver Shipping Header")
    //DX        110521      Create the driver  card and retrieve all the information
    var
        EntryNo: Integer;
        CheckRec: Record "Checking Header";
        FlowCheckRec: Record "Checking Header";
        DriverLine: Record "Driver Shipping Line";
        SIHRec: Record "Sales Invoice Header";
        WarehouseCU: Codeunit "Warehouse CU";
        ALERec: Record "Assignment Ledger Entry";
        Qty: Decimal;
        TBACU: Codeunit tba;
        TBARec: Record "TBA Ledger Entry";
        TbaQty: Record "TBA Ledger Entry";
        QtyForTBA: Decimal;
    begin
        //Check all checking header first and see if it has been assigned to driver, need to filter by shipping bin as well
        EntryNo := 10000;
        CheckRec.reset;
        CheckRec.SetRange("Shipping Bin", DriverRec."Shipping Bin");
        CheckRec.SetRange("Assigned to Driver Card", false);
        if CheckRec.FindSet() then
            repeat
                ALERec.reset;
                ALERec.SetRange("Checking Doc No.", CheckRec."No.");
                ALERec.SetFilter("Invoice No.", '<>%1', '');        //Check if the checking doc is posted first before assigning to driver.
                if ALERec.FindFirst() then begin
                    DriverLine.reset;
                    DriverLine.Init();
                    DriverLine.Validate("Driver Doc No.", DriverRec."No.");
                    DriverLine.Validate("Line No.", EntryNo);
                    //if TBACU.IsTBA(ALERec."Picking Doc No.") then begin
                    DriverLine.Validate("Doc No.", GetTBAInvNo(DriverRec, SIHRec, CheckRec."No."));
                    //end else begin
                    DriverLine.Validate("Doc No.", GetInvNo(DriverRec, SIHRec, CheckRec."No."));
                    //end;

                    DriverLine.Validate("Customer No.", SIHRec."Sell-to Customer No.");
                    DriverLine.Validate("Customer Name", SIHRec."Sell-to Customer Name");
                    DriverLine.Validate(Address, SIHRec."Sell-to Address");
                    DriverLine.Validate("Address 2", SIHRec."Sell-to Address 2");
                    Driverline.Validate("Post Code", SIHRec."Sell-to Post Code");
                    FlowCheckRec.reset;
                    FlowCheckRec.SetRange("No.", CheckRec."No.");
                    if FlowCheckRec.FindFirst() then begin
                        FlowCheckRec.CalcFields("Shipping Packacges");
                        qty := FlowCheckRec."Shipping Packacges";
                        DriverLine.Validate("Shipping Packacges", FlowCheckRec."Shipping Packacges");
                    end;
                    DriverLine.Insert(TRUE);
                    EntryNo += 10000;

                    CheckRec."Assigned to Driver Card" := true;
                    CheckRec.Modify(TRUE);
                    //DX        120521      Update ALE information.
                    UpdateALEFromDriverCard(DriverRec, CheckRec."No.");

                    //if TBACU.IsTBA(ALERec."Picking Doc No.") then
                    //    WarehouseCU.UpdateOrderStatus(GetTBAInvNo(DriverRec, SIHRec, CheckRec."No."), 'Delivery In Progress')
                    //else
                    WarehouseCU.UpdateOrderStatus(GetInvNo(DriverRec, SIHRec, CheckRec."No."), 'Delivery In Progress');
                end else begin
                    //Message('No invoices received, please ensure invoices have been generated before creating driver card.');
                end;

            until CheckRec.next = 0;

        //DX        04 July 2021    Additional TBA records to retrieve to driver card.
        TBARec.reset;
        TBARec.SetRange("Cage No.", DriverRec."Shipping Bin");
        TBARec.SetRange("Assigned To Driver Card", false);
        if TBARec.FindSet() then begin
            DriverLine.reset;
            DriverLine.Init();
            DriverLine.Validate("Driver Doc No.", DriverRec."No.");
            DriverLine.Validate("Line No.", EntryNo);

            DriverLine.Validate("Doc No.", TBARec."Document No.");
            DriverLine.Validate("Customer No.", TBARec."Customer No.");
            DriverLine.Validate("Customer Name", TBARec."Customer Name");
            SIHRec.reset;
            SIHRec.SetRange("No.", TBARec."Apply To Doc No.");
            if SIHRec.FindFirst() then begin
                DriverLine.Validate(Address, SIHRec."Sell-to Address");
                DriverLine.Validate("Address 2", SIHRec."Sell-to Address 2");
                Driverline.Validate("Post Code", SIHRec."Sell-to Post Code");
            end;

            TbaQty.reset;
            TbaQty.SetRange("Cage No.", DriverRec."Shipping Bin");
            TbaQty.SetRange("Assigned To Driver Card", false);
            TbaQty.CalcSums("Shipping Packages");
            QtyForTBA := TbaQty."Shipping Packages";
            DriverLine.Validate("Shipping Packacges", QtyForTBA);

            DriverLine.Insert(TRUE);
            EntryNo += 10000;

            //CheckRec."Assigned to Driver Card" := true;
            TBARec."Assigned To Driver Card" := true;
            TBARec.Modify(false);
            //DX        120521      Update ALE information.
            UpdateALEFromDriverCard(DriverRec, TBARec."Document No.");


            //DX        04 July 2021    Additional TBA records to retrieve to driver card.
        end;

    end;

    local procedure GetInvNo(Driverhdr: record "Driver Shipping Header"; var salesinvhdr: Record "Sales Invoice Header"; PickListNo: Code[20]) InvNo: code[20]
    var
        myInt: Integer;
        ALE: Record "Assignment Ledger Entry";
    begin
        ALE.reset;
        ALE.SetRange("Picking Doc No.", PickListNo);
        if ALE.FindFirst() then begin
            salesinvhdr.reset;
            salesinvhdr.SetRange("Order No.", ALE."Document No.");  //Find the sales order no. then return the invoice number.
            if salesinvhdr.FindFirst() then begin
                InvNo := salesinvhdr."No.";
            end;
            ALE."Driver Doc No." := Driverhdr."No.";
            ALE."Driver Start Time" := Driverhdr."Start Time";
        end;
    end;

    local procedure GetTBAInvNo(Driverhdr: record "Driver Shipping Header"; var salesinvhdr: Record "Sales Invoice Header"; PickListNo: Code[20]) InvNo: code[20]
    var
        myInt: Integer;
        ALE: Record "Assignment Ledger Entry";
    begin
        ALE.reset;
        ALE.SetRange("Picking Doc No.", PickListNo);
        if ALE.FindFirst() then begin
            salesinvhdr.reset;
            salesinvhdr.SetRange("Order No.", ALE."Invoice No.");  //Find the sales order no. then return the invoice number.
            if salesinvhdr.FindFirst() then begin
                InvNo := salesinvhdr."No.";
            end;
            ALE."Driver Doc No." := Driverhdr."No.";
            ALE."Driver Start Time" := Driverhdr."Start Time";
        end;
    end;

    //DX        120521      Update ALE with the correct information once driver card has been created.
    local procedure UpdateALEFromDriverCard(DriverRec: Record "Driver Shipping Header"; PickDocNo: code[20])
    var
        myInt: Integer;
        ALE: Record "Assignment Ledger Entry";
    begin
        ALE.reset;
        ALE.SetRange("Picking Doc No.", PickDocNo);
        if ALE.FindFirst() then begin
            ALE."Driver Doc No." := DriverRec."No.";
            ALE."Driver Start Time" := DriverRec."Start Time";
            ALE.Status := ALE.Status::Delivering;
            ALE.Modify(TRUE);
        end;
    end;

    procedure CountInvoicesInCage(ShipCageCode: code[20]) Gotinv: Boolean
    var
        InvCount: Integer;
        CheckRec: Record "Checking Header";
        DriverLine: Record "Driver Shipping Line";
        SIHRec: Record "Sales Invoice Header";
        ALERec: Record "Assignment Ledger Entry";
        TBARec: Record "TBA Ledger Entry";
    begin
        //First retrieve all the check headers that belong to the cage code.        

        //Check all checking header first and see if it has been assigned to driver, need to filter by shipping bin as well
        InvCount := 0;
        CheckRec.reset;
        CheckRec.SetRange("Shipping Bin", ShipCageCode);
        CheckRec.SetRange("Assigned to Driver Card", false);
        if CheckRec.FindSet() then
            repeat
                ALERec.reset;
                ALERec.SetRange("Checking Doc No.", CheckRec."No.");
                ALERec.SetFilter("Invoice No.", '<>%1', '');        //Check if the checking doc is posted first before assigning to driver.
                if ALERec.FindFirst() then
                    InvCount += 1;

            until CheckRec.next = 0;

        //DX        04 July 2021    to add TBA flow to driver
        TBARec.reset;
        TBARec.SetRange("Cage No.", ShipCageCode);
        TBARec.SetRange("Assigned To Driver Card", false);
        if TBARec.FindSet() then
            repeat
                InvCount += 1;
            until TBARec.next = 0;
        //DX        04 July 2021

        if InvCount > 0 then
            exit(TRUE)
        else
            exit(false);
    end;



    var
        myInt: Integer;
}