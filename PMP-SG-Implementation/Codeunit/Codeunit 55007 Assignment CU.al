codeunit 55007 "Assignment CU"
{
    //DX        11 Jun 2021
    //DX        Some businessscenarios, +7 days delivery to pick by
    //DX        To allocate based on pick by date.
    //DX        Wellaway to be priority 1, straight must process when creating the wellaway SO

    trigger OnRun()
    begin

    end;

    procedure GetAssignLE(var ALERec: Record "Assignment Ledger Entry"; PickerID: Code[20])
    var
        PickerList: Record Picker;
    begin
        //Find the picker list first

        //DX        29 Aug 2021     Find wellaway picking lists first.
        ALERec.reset;
        ALERec.SetLoadFields(Status, Picker);        //DX        03 May 2023
        ALERec.SetRange(Status, ALERec.Status::Processing);
        ALERec.SetRange(Picker, '');
        if ALERec.FindFirst() then begin    //if can find then return this pick list
        end;
    end;

    procedure GetAssignLEByPicker(var ALERec: Record "Assignment Ledger Entry"; PickerID: Code[20])
    var
        PMPCU: Codeunit "PMP-Enhancements"; // YF 25 Mar 2025
        PickerList: Record Picker;
    begin
        //Find the picker list first
        if GetPriorityAssignLEByPicker(ALERec, PickerID) then begin     //If can find priority first, then get priority, else 
        end else begin
            PickerList.reset;
            PickerList.SetRange("User ID", PickerID);
            if PickerList.FindFirst() then begin        //Check for Controlled drug, wellaway first, and dedicated / Chain Pharamcy            
                ALERec.reset;
                ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                ALERec.SetRange(Status, ALERec.Status::Processing);
                ALERec.SetRange("On Hold", false);
                ALERec.SetRange(Picker, UserId);      //Check if got any manual assigned first.
                if ALERec.FindFirst() then begin
                end else begin
                    if PickerList.Wellaway = true then begin
                        ALERec.reset;
                        ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                        ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                        ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                        ALERec.SetRange(Status, ALERec.Status::Processing);
                        ALERec.SetRange(Picker, '');
                        ALERec.SetRange("Wellaway Picks", true);
                        ALERec.SetRange("On Hold", false);
                        // ALERec.SetRange("Chain Pharmacy", false);
                        // ALERec.SetRange("Controlled Drug", false);
                        if ALERec.FindFirst() then begin    //if can find then return this pick list
                        end;
                    end;

                    if PickerList.Normal = true then begin  //Normal picker for non chain and non cd picking lists.
                                                            //DX        29 Aug 2021     Find wellaway picking lists first.
                        ALERec.reset;
                        ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                        ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                        ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                        ALERec.SetRange(Status, ALERec.Status::Processing);
                        ALERec.SetRange(Picker, '');
                        ALERec.SetRange(Wellaway, true);
                        ALERec.SetRange("On Hold", false);
                        ALERec.SetRange("Chain Pharmacy", false);
                        ALERec.SetRange("Controlled Drug", false);
                        // YF 24 Mar 2025
                        if PMPCU.IsPMPCompany() then
                            ALERec.SetRange(I9G_STBio, false);
                        // YF 24 Mar 2025
                        if ALERec.FindFirst() then begin    //if can find then return this pick list
                        end else begin  //If cannot find any wellaway orders, then just get normal orders.
                            ALERec.reset;
                            ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                            ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                            ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                            ALERec.SetRange(Status, ALERec.Status::Processing);
                            ALERec.SetRange(Picker, '');
                            ALERec.SetRange(Wellaway, false);
                            ALERec.SetRange("On Hold", false);
                            ALERec.SetRange("Chain Pharmacy", false);
                            ALERec.SetRange("Controlled Drug", false);
                            // YF 24 Mar 2025
                            if PMPCU.IsPMPCompany() then
                                ALERec.SetRange(I9G_STBio, false);
                            // YF 24 Mar 2025
                            if ALERec.FindFirst() then begin end;
                        end;
                    end else
                        if PickerList.CD = true then begin      //if CD picker only
                            ALERec.reset;
                            ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                            ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                            ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                            ALERec.SetRange(Status, ALERec.Status::Processing);
                            ALERec.SetRange(Picker, '');
                            ALERec.SetRange("Controlled Drug", true);
                            ALERec.SetRange("On Hold", false);
                            ALERec.SetRange("Chain Pharmacy", false);
                            ALERec.SetRange("Wellaway", false);
                            if ALERec.FindFirst() then begin end;
                        end else                                //If Chain pharmacy picker only for CD, wellaway, non chain
                            // YF 24 Mar 2025
                            if PickerList.I9G_STBio And PMPCU.IsPMPCompany then // if ST Bio picker only
                                begin
                                ALERec.reset;
                                ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug");   //DX        03 May 2023
                                ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                                ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                                ALERec.SetRange(Status, ALERec.Status::Processing);
                                ALERec.SetRange(Picker, '');
                                ALERec.SetRange("Controlled Drug", false);
                                ALERec.SetRange(I9G_STBio, true);
                                ALERec.SetRange("On Hold", false);
                                ALERec.SetRange("Chain Pharmacy", false);
                                ALERec.SetRange("Wellaway", false);
                                if ALERec.FindFirst() then begin end;
                            end
                            else begin
                                if PickerList.Dedicated = true then begin
                                    ALERec.reset;
                                    ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug");   //DX        03 May 2023
                                    ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                                    ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                                    ALERec.SetRange(Status, ALERec.Status::Processing);
                                    ALERec.SetRange(Picker, '');
                                    ALERec.SetRange(Wellaway, false);
                                    ALERec.SetRange("Chain Pharmacy", true);
                                    ALERec.SetRange("On Hold", false);
                                    ALERec.SetRange("Controlled Drug", false);
                                    // YF 24 Mar 2025
                                    if PMPCU.IsPMPCompany then
                                        ALERec.SetRange(I9G_STBio, false);
                                    // YF 24 Mar 2025
                                    if ALERec.FindFirst() then begin
                                    end else begin      // take any remaining pick lists that is not CD and assign
                                        ALERec.reset;
                                        ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug");   //DX        03 May 2023
                                        ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                                        ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                                        ALERec.SetRange(Status, ALERec.Status::Processing);
                                        ALERec.SetRange(Picker, '');
                                        ALERec.SetRange("On Hold", false);
                                        ALERec.SetRange("Controlled Drug", false);
                                        // YF 24 Mar 2025
                                        if PMPCU.IsPMPCompany then
                                            ALERec.SetRange(I9G_STBio, false);
                                        // YF 24 Mar 2025
                                        if ALERec.FindFirst() then begin end;
                                    end;
                                end;
                            end;
                    // YF 24 Mar 2025
                end;
            end else
                Error('User ID is not registered in Picker list, please check again.');
        end;
    end;


    procedure GetPriorityAssignLEByPicker(var ALERec: Record "Assignment Ledger Entry"; PickerID: Code[20]): Boolean;
    var
        PMPCU: Codeunit "PMP-Enhancements"; // YF 25 Mar 2025
        PickerList: Record Picker;
    begin
        //Find the picker list first
        PickerList.reset;
        PickerList.SetRange("User ID", UserId);
        if PickerList.FindFirst() then begin        //Check for Controlled drug, wellaway first, and dedicated / Chain Pharamcy            
            ALERec.reset;
            ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
            ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
            ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
            ALERec.SetRange(Status, ALERec.Status::Processing);
            ALERec.SetRange("On Hold", false);
            ALERec.SetRange(Picker, UserId);      //Check if got any manual assigned first.
            ALERec.SetRange("Priority Picking", true);
            if ALERec.FindFirst() then begin
                exit(TRUE);
            end else begin
                if PickerList.Wellaway = true then begin
                    ALERec.reset;
                    ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                    ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                    ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                    ALERec.SetRange(Status, ALERec.Status::Processing);
                    ALERec.SetRange(Picker, '');
                    ALERec.SetRange("Wellaway Picks", true);
                    ALERec.SetRange("On Hold", false);
                    // ALERec.SetRange("Chain Pharmacy", false);
                    // ALERec.SetRange("Controlled Drug", false);
                    if ALERec.FindFirst() then begin
                        exit(TRUE);
                    end;
                end;
                if PickerList.Normal = true then begin  //Normal picker for non chain and non cd picking lists.
                                                        //DX        29 Aug 2021     Find wellaway picking lists first.
                    ALERec.reset;
                    ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                    ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                    ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                    ALERec.SetRange(Status, ALERec.Status::Processing);
                    ALERec.SetRange(Picker, '');
                    ALERec.SetRange(Wellaway, true);
                    ALERec.SetRange("Chain Pharmacy", false);
                    ALERec.SetRange("On Hold", false);
                    ALERec.SetRange("Controlled Drug", false);
                    // YF 24 Mar 2025
                    if PMPCU.IsPMPCompany() then
                        ALERec.SetRange(I9G_STBio, false);
                    // YF 24 Mar 2025
                    ALERec.SetRange("Priority Picking", true);
                    if ALERec.FindFirst() then begin    //if can find then return this pick list
                        exit(TRUE);
                    end else begin  //If cannot find any wellaway orders, then just get normal orders.
                        ALERec.reset;
                        ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                        ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                        ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                        ALERec.SetRange(Status, ALERec.Status::Processing);
                        ALERec.SetRange(Picker, '');
                        ALERec.SetRange(Wellaway, false);
                        ALERec.SetRange("Chain Pharmacy", false);
                        ALERec.SetRange("On Hold", false);
                        ALERec.SetRange("Controlled Drug", false);
                        // YF 24 Mar 2025
                        if PMPCU.IsPMPCompany() then
                            ALERec.SetRange(I9G_STBio, false);
                        // YF 24 Mar 2025
                        ALERec.SetRange("Priority Picking", true);
                        if ALERec.FindFirst() then begin
                            exit(TRUE);
                        end else
                            exit(false);
                    end;
                end else
                    if PickerList.CD = true then begin      //if CD picker only
                        ALERec.reset;
                        ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                        ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                        ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                        ALERec.SetRange(Status, ALERec.Status::Processing);
                        ALERec.SetRange(Picker, '');
                        ALERec.SetRange("Controlled Drug", true);
                        // YF 24 Mar 2025
                        if PMPCU.IsPMPCompany() then
                            ALERec.SetRange(I9G_STBio, false);
                        // YF 24 Mar 2025
                        ALERec.SetRange("Chain Pharmacy", false);
                        ALERec.SetRange("On Hold", false);
                        ALERec.SetRange("Wellaway", false);
                        ALERec.SetRange("Priority Picking", true);
                        if ALERec.FindFirst() then begin
                            exit(TRUE);
                        end else
                            exit(false);
                    end else begin
                        // YF 24 Mar 2025
                        if PickerList.I9G_STBio And PMPCU.IsPMPCompany() then begin
                            // if ST Bio picker only
                            ALERec.reset;
                            ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);
                            ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                            ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                            ALERec.SetRange(Status, ALERec.Status::Processing);
                            ALERec.SetRange(Picker, '');
                            ALERec.SetRange("Controlled Drug", false);
                            ALERec.SetRange(I9G_STBio, true);
                            ALERec.SetRange("Chain Pharmacy", false);
                            ALERec.SetRange("On Hold", false);
                            ALERec.SetRange("Wellaway", false);
                            ALERec.SetRange("Priority Picking", true);
                            if ALERec.FindFirst() then begin
                                exit(TRUE);
                            end else
                                exit(false);
                        end
                        else begin
                            //If Chain pharmacy picker only for CD, wellaway, non chain
                            if PickerList.Dedicated = true then begin
                                ALERec.reset;
                                ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug", I9G_STBio);   //DX        03 May 2023 // YF 24 Mar 2025
                                ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                                ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                                ALERec.SetRange(Status, ALERec.Status::Processing);
                                ALERec.SetRange(Picker, '');
                                ALERec.SetRange(Wellaway, false);
                                ALERec.SetRange("On Hold", false);
                                ALERec.SetRange("Chain Pharmacy", true);
                                ALERec.SetRange("Controlled Drug", false);
                                // YF 24 Mar 2025
                                if PMPCU.IsPMPCompany() then
                                    ALERec.SetRange(I9G_STBio, false);
                                // YF 24 Mar 2025
                                ALERec.SetRange("Priority Picking", true);
                                if ALERec.FindFirst() then begin
                                    exit(TRUE);
                                end else begin      // take any remaining pick lists that is not CD and assign
                                    ALERec.reset;
                                    ALERec.SetLoadFields(Status, Picker, "Pick By Date", "On Hold", "Priority Picking", "Chain Pharmacy", Wellaway, "Controlled Drug");   //DX        03 May 2023
                                    ALERec.SetCurrentKey(ALERec.Status, ALERec.Picker, ALERec."Pick By Date");
                                    ALERec.SetAscending(ALERec."Pick By Date", true);    //Start from earliest date first then go to later date, get wellaway first.
                                    ALERec.SetRange(Status, ALERec.Status::Processing);
                                    ALERec.SetRange(Picker, '');
                                    ALERec.SetRange("On Hold", false);
                                    ALERec.SetRange("Controlled Drug", false);
                                    // YF 24 Mar 2025
                                    if PMPCU.IsPMPCompany() then
                                        ALERec.SetRange(I9G_STBio, false);
                                    // YF 24 Mar 2025
                                    ALERec.SetRange("Priority Picking", true);
                                    if ALERec.FindFirst() then begin
                                        exit(TRUE);
                                    end else
                                        exit(FALSE);
                                end;
                            end;
                        end;
                        // YF 24 Mar 2025
                    end;
            end;

        end else
            Error('User ID is not registered in Picker list, please check again.');
    end;

    procedure DeterminePriority(SHRec: Record "Sales Header"): Boolean
    var
        myInt: Integer;
        //Get default wellaway priority
        CustRec: Record customer;
    begin

    end;

    procedure GetPickByDateForSO(SHRec: Record "Sales Header") PickDate: Date;
    var
        myInt: Integer;
        shipdate: Date;
        AllowedRec: Record "Allowed Cust-Item";
        DayOfWeek: integer;
    begin
        //DX        08 sept 2021
        if SHRec."Requested Delivery Date" <> 0D then
            if SHRec."Order Date" <> SHRec."Requested Delivery Date" then begin
                exit(SHRec."Requested Delivery Date");
            end;
        //DX        08 sept 2021
        if SHRec."Priority Picking" = true then begin
            shipdate := CalcDate('<1D>', SHRec."Order Date");
            exit(shipdate);
        end;
        if SHRec."Bill-to Customer No." <> '' then begin        //DX        29 Aug 2021 Means is Chain pharmacy + 4 Days by default
            AllowedRec.reset;
            AllowedRec.SetRange("Cust No.", SHRec."Bill-to Customer No.");
            if AllowedRec.FindFirst() then begin
                shipdate := CalcDate('<4D>', SHRec."Order Date");
                //if DayIsValid(DayOfWeek, SHRec."Sell-to Customer No.") then         //if the date falls on the sames allowed delivery date.
                //    exit(shipdate)
                //else begin
                //shipdate := CalcDate(GetEarliestValidDate(shipdate, SHRec."Sell-to Customer No.", DayOfWeek), SHRec."Order Date");
                shipdate := GetEarliestValidDate(shipdate, SHRec."Sell-to Customer No.");
                exit(shipdate);
                //end;
            end else begin
                shipdate := CalcDate('<1D>', SHRec."Order Date");
                exit(shipdate);
            end;
        end else begin
            shipdate := CalcDate('<1D>', SHRec."Order Date");
            exit(shipdate);
        end;
    end;

    local procedure GetEarliestValidDate(ShipDate: Date; SellToCust: Code[20]): Date
    var
        myInt: Integer;
        DelSchedule: Record "Delivery Schedule";
        ScheduleDay: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        //If proposed 4D date has a shipment date already, then just take same date.
        ALERec.reset;
        ALERec.SetLoadFields("Customer No.", "Pick By Date", Status); //DX        03 May 2023
        ALERec.SetRange("Customer No.", SellToCust);
        ALERec.SetRange("Pick By Date", ShipDate);
        ALERec.SetRange(Status, ALERec.Status::Processing);
        if ALERec.FindFirst() then
            exit(ShipDate);

        ALERec.reset;
        ALERec.SetLoadFields("Customer No.", "Pick By Date", Status); //DX        03 May 2023
        ALERec.SetRange("Customer No.", SellToCust);
        ALERec.SetRange("Pick By Date", CalcDate('<-1D>', ShipDate));
        ALERec.SetRange(Status, ALERec.Status::Processing);
        if ALERec.FindFirst() then
            exit(CalcDate('<-1D>', ShipDate));


        ALERec.reset;
        ALERec.SetLoadFields("Customer No.", "Pick By Date", Status); //DX        03 May 2023
        ALERec.SetRange("Customer No.", SellToCust);
        ALERec.SetRange("Pick By Date", CalcDate('<-2D>', ShipDate));
        ALERec.SetRange(Status, ALERec.Status::Processing);
        if ALERec.FindFirst() then
            exit(CalcDate('<-2D>', ShipDate));

        ALERec.reset;
        ALERec.SetLoadFields("Customer No.", "Pick By Date", Status); //DX        03 May 2023
        ALERec.SetRange("Customer No.", SellToCust);
        ALERec.SetRange("Pick By Date", CalcDate('<-3D>', ShipDate));
        ALERec.SetRange(Status, ALERec.Status::Processing);
        if ALERec.FindFirst() then
            exit(CalcDate('<-3D>', ShipDate));

        exit(ShipDate);     //If don't have any record, just use 4D proposed date.

    End;

    local procedure PickByDateExist(ReqPickByDate: Date; CustNo: Code[20]): Boolean
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Customer No.", "Pick By Date", Status); //DX        03 May 2023
        ALERec.SetRange("Customer No.", CustNo);
        ALERec.SetRange("Pick By Date", ReqPickByDate);
        if ALERec.FindFirst() then
            exit(true)
        else
            exit(FALSE);
    end;

    local procedure DayIsValid(ShipDate: date; Day: Integer; SellToCust: Code[20]): Boolean;
    var
        myInt: Integer;
        DelSchedule: Record "Delivery Schedule";
    begin
        case Day of
            '1':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Monday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
            '2':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Tuesday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
            '3':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Wednesday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
            '4':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Thursday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
            '5':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Friday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
            '6':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Saturday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
            '7':
                begin
                    DelSchedule.reset;
                    DelSchedule.SetRange(Sunday, true);
                    DelSchedule.SetRange("Cust No.", SellToCust);
                    if DelSchedule.FindFirst() then
                        exit(true);
                end;
        end
    end;

    procedure GetPickByDateForTO(THRec: Record "Transfer Header") PickDate: Date;
    var
        myInt: Integer;
        shipdate: Date;
    begin

        shipdate := CalcDate('<1D>', Today);
        exit(shipdate);
    end;

    var
        myInt: Integer;


    procedure AssignPickerToPL(VAR ALERec: Record "Assignment Ledger Entry"; Picker: Code[20])
    var
        myInt: Integer;
    begin
        ALERec.Picker := Picker;
        ALERec.Modify(FALSE);
    end;
    /*

        local procedure GetEarliestValidDate(SellToCust: Code[20]; DayOfWeek: Integer): Text
        var
            myInt: Integer;
            DelSchedule: Record "Delivery Schedule";
            ScheduleDay: Integer;
        begin
            case DayOfWeek of       //If the calculated date falls on the respective day
                '1':        //Assume today is thursday
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Sunday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Saturday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');
                    end;
                '2':
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Saturday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Friday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');
                    end;
                '3':
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Friday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Thursday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');
                    end;
                '4':
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Thursday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Wednesday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');
                    end;
                '5':
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Wednesday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Tuesday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');

                    end;
                '6':
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Tuesday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Monday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');

                    end;
                '7':
                    begin
                        DelSchedule.reset;
                        DelSchedule.SetRange(Monday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<2D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        DelSchedule.reset;
                        DelSchedule.SetRange(Sunday, true);
                        DelSchedule.SetRange("Cust No.", SellToCust);   //If schedule falls on sunday, then return -1D + 1 D for buffer date as per required
                        if DelSchedule.FindFirst() then begin
                            exit('<1D>');      //Return 2 days earlier for saturday delivery, if sunday delivery is allowed.
                        end;
                        exit('<1D');
                    end
            end;
        End;*/

    // YF 28 Feb 2022
    procedure ArchiveCompletedALE()
    var
        ALEFilteredRec: Record "Assignment Ledger Entry";
        ALEArchivedRec: Record "ALE Archive";
        ArchiveCounter: Integer;
    begin
        ArchiveCounter := 0;

        ALEFilteredRec.Reset;
        // ALEFilteredRec.SetRange(Status, ALEFilteredRec.Status::Completed);        
        ALEFilteredRec.SetFilter(Status, '%1|%2', ALEFilteredRec.Status::Completed, ALEFilteredRec.Status::"Pending Delivery");
        ALEFilteredRec.SetFilter("Posting Date", '<%1', CalcDate('<CM-30D>', Today));
        if ALEFilteredRec.FindSet() then
            repeat
                // copy to archive
                ALEArchivedRec.Reset;
                ALEArchivedRec.Init();
                ALEArchivedRec.TransferFields(ALEFilteredRec);
                if ALEArchivedRec.Insert() then begin
                    ArchiveCounter += 1;
                    ALEFilteredRec.Delete();
                end;
            until ALEFilteredRec.Next() = 0;

        Message(Format(ArchiveCounter) + ' entries archived');
    end;
    // YF 28 Feb 2022

}