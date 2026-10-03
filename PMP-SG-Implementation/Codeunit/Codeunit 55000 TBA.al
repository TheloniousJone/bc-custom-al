codeunit 55000 TBA
{
    trigger OnRun()
    begin
        //
    end;

    //DX        04 July 2021 Change all selected lines to designated shipping cage
    procedure UpdateTBALineCage(DocNo: Code[20]; CageNo: Code[20])
    var
        myInt: Integer;
        TBARec: Record "TBA Ledger Entry";
    begin
        TBARec.reset;
        TBARec.SetRange("Document No.", DocNo);
        if TBARec.FindSet() then
            repeat
                TBARec."Cage No." := CageNo;
                TBARec.Modify(TRUE);
            until TBARec.next = 0;
    end;
    //DX        04 July 2021 Change all selected lines to designated shipping cage
    procedure InsertContractLedgerByLine(SHRec: Record "Sales Invoice Header"; PostDate: Date)
    var
        myInt: Integer;
        TBARec: Record "TBA Ledger Entry";
        SILRec: Record "Sales Invoice Line";
        EntryNo: Integer;
        CustRec: Record Customer;
        VLErec: Record "Value Entry";
        ILERec: Record "Item Ledger Entry";
        LtbaRec: Record "TBA Ledger Entry";
    begin
        //DX        04 July 2021 Add item batch at TBA Ledger entry
        VLErec.reset;
        VLErec.SetRange("Document No.", SHRec."No.");
        VLErec.SetRange("Entry Type", VLErec."Entry Type"::"Direct Cost");
        VLErec.SetRange("Document Type", VLErec."Document Type"::"Sales Invoice");
        VLErec.SetRange(Adjustment, false);
        if VLErec.FindSet() then
            repeat
                ILERec.reset;
                ILERec.SetRange("Entry No.", VLErec."Item Ledger Entry No.");
                if ILERec.FindFirst() then begin
                    TBARec.RESET;
                    IF TBARec.COUNT = 0 THEN
                        EntryNo := 1
                    ELSE BEGIN
                        IF TBARec.FINDLAST THEN
                            EntryNo := TBARec."Entry No." + 1;
                    END;
                    TBARec.RESET;
                    TBARec.INIT;
                    TBARec.VALIDATE("Entry No.", EntryNo);
                    TBARec.VALIDATE("Document No.", SHRec."No.");
                    TBARec.VALIDATE("Customer No.", SHRec."Sell-to Customer No.");
                    CustRec.RESET;
                    CustRec.SETRANGE("No.", SHRec."Sell-to Customer No.");
                    IF CustRec.FINDFIRST THEN BEGIN END;
                    TBARec.VALIDATE("Customer Name", SHRec."Sell-to Customer Name");
                    TBARec.VALIDATE(Quantity, abs(ILERec.Quantity));
                    TBARec.VALIDATE("Apply To Doc No.", SHRec."No.");
                    TBARec.VALIDATE("Posting Date", PostDate);
                    TBARec.VALIDATE("Entry Type", TBARec."Entry Type"::Sale);
                    TBARec.VALIDATE("Item No.", ILERec."Item No.");
                    TBARec.Validate("Item Description", ILERec.Description);
                    TBARec.VALIDATE("Unit Of Measure Code", ILERec."Unit of Measure Code");
                    //DX        04 July 2021    new fields
                    TBARec.Validate("Batch No.", ILERec."Lot No.");
                    TBARec.Validate("Expiration Date", ILERec."Expiration Date");
                    TBARec.Validate("Delivery Charge", SHRec."Delivery Charge");
                    TBARec.Validate("Cage No.", SHRec."Delivery Zone");
                    TBARec.Validate("Sales Order No.", SHRec."Order No.");
                    //DX        04 July 2021
                    TBARec.INSERT(TRUE);

                    //DX        03 Sept 2021
                    LtbaRec.reset;
                    LtbaRec.SetRange("Item No.", ILERec."Item No.");
                    LtbaRec.SetRange("Sales Order No.", SHRec."Order No.");
                    LtbaRec.SetRange("Entry Type", LtbaRec."Entry Type"::"Pending Delivery"); // YF 02 Nov 2021 // Bug Fix
                    if LtbaRec.FindFirst() then begin
                        LtbaRec.Validate("Batch No.", ILERec."Lot No.");
                        LtbaRec.Validate("Apply To Doc No.", SHRec."No.");
                        LtbaRec.Validate("Expiration Date", ILERec."Expiration Date");
                        LtbaRec.Validate("Entry Type", LtbaRec."Entry Type"::Delivery);
                        LtbaRec.Modify(FALSE);
                    end;
                    //DX        03 Sept 2021
                end;
            until VLErec.next = 0;
        //DX        04 July 2021
    end;

    procedure InsertDeliveryLine(AdjDate: Date; AdjQty: Decimal; Remarks: Text[100]; ContractRec: Record "TBA Ledger Entry"; DelZone: Code[50]; DelCharge: Code[50])
    var
        myInt: Integer;
        ContractLERec: Record "TBA Ledger Entry";
        EntryNo: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        InitDocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        CustRec: Record customer;
    begin
        ContractLERec.RESET;
        IF ContractLERec.COUNT = 0 THEN
            EntryNo := 1
        ELSE BEGIN
            IF ContractLERec.FINDLAST THEN
                EntryNo := ContractLERec."Entry No." + 1;
        END;
        SSSetup.GET;
        SSSetup.TESTFIELD("TBA Adjustment No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."TBA Adjustment No. Series", SSSetup."TBA Adjustment No. Series", TODAY, InitDocNo, SSSetup."TBA Adjustment No. Series");
        InitDocNo := NoSeries.GetNextNo(SSSetup."TBA Adjustment No. Series", Today);

        ContractLERec.RESET;
        ContractLERec.INIT;
        ContractLERec.VALIDATE("Entry No.", EntryNo);
        ContractLERec.VALIDATE("Document No.", InitDocNo);
        ContractLERec.VALIDATE("Posting Date", AdjDate);
        ContractLERec.VALIDATE("Customer No.", ContractRec."Customer No.");
        ContractLERec.VALIDATE("Customer Name", ContractRec."Customer Name");
        ContractLERec.VALIDATE(Quantity, -AdjQty);
        ContractLERec.VALIDATE("Entry Type", ContractRec."Entry Type"::Delivery);
        ContractLERec.VALIDATE("Item No.", ContractRec."Item No.");
        ContractLERec.Validate("Item Description", ContractRec."Item Description");
        ContractLERec.VALIDATE(Remarks, Remarks);
        ContractLERec.VALIDATE("Unit Of Measure Code", ContractRec."Unit Of Measure Code");
        ContractLERec.VALIDATE("Apply To Doc No.", ContractRec."Document No.");
        //DX        04 July 2021 Addiitonal fields
        ContractLERec.VALIDATE("Batch No.", ContractRec."Batch No.");
        ContractLERec.Validate("Expiration Date", ContractRec."Expiration Date");
        ContractLERec.Validate("Bin Remarks", ContractRec."Bin Remarks");
        ContractLERec.Validate("Sales Order No.", ContractRec."Sales Order No.");
        //DX        04 July 2021 Addiitonal fields
        //DX        28 Aug 2021
        ContractLERec.Validate("Cage No.", DelZone);
        ContractLERec.Validate("Delivery Charge", DelCharge);
        //DX        28 Aug 2021
        ContractLERec.INSERT(TRUE);

        MESSAGE('TBA Delivery Ledger inserted');
        //DX        31 Aug 2021 No need to create TBA, cause no need to pick from warheouse.
        //CreateALEforTBA(ContractLERec);
        //DX        31 Aug 2021
    end;

    procedure InsertAdjLine(SIHRecNo: Code[20])
    var
        myInt: Integer;
        ContractLERec: Record "TBA Ledger Entry";
        EntryNo: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        SILRec: Record "Sales Invoice Line";
        SIHRec: Record "Sales Invoice Header";
        InitDocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        CustRec: Record customer;
        VLERec: Record "Value Entry";
        ILERec: Record "Item Ledger Entry";
    begin
        SIHRec.reset;
        SIHRec.SetRange("No.", SIHRecNo);
        if SIHRec.findfirst() then begin
            //DX        04 July 2021 Changing of code to retrieve from Vale Entry.
            VLErec.reset;
            VLErec.SetRange("Document No.", SIHRec."No.");
            VLErec.SetRange("Entry Type", VLErec."Entry Type"::"Direct Cost");
            VLErec.SetRange("Document Type", VLErec."Document Type"::"Sales Invoice");
            VLErec.SetRange(Adjustment, false);

            //SILRec.RESET;
            //SILRec.SETRANGE("Document No.", SIHRec."No.");
            //SILRec.SETRANGE(Type, SILRec.Type::Item);
            IF VLERec.FINDSET THEN
                REPEAT
                    ILERec.reset;
                    ILERec.SetRange("Entry No.", VLERec."Item Ledger Entry No.");
                    if ILERec.FindFirst() then begin
                        ContractLERec.RESET;
                        IF ContractLERec.COUNT = 0 THEN
                            EntryNo := 1
                        ELSE BEGIN
                            IF ContractLERec.FINDLAST THEN
                                EntryNo := ContractLERec."Entry No." + 1;
                        END;
                        ContractLERec.RESET;
                        ContractLERec.INIT;
                        ContractLERec.VALIDATE("Entry No.", EntryNo);
                        ContractLERec.VALIDATE("Document No.", SIHRec."No.");
                        ContractLERec.VALIDATE("Posting Date", SIHRec."Posting Date");
                        ContractLERec.VALIDATE("Customer No.", SIHRec."Sell-to Customer No.");
                        ContractLERec.VALIDATE("Customer Name", SIHrec."Sell-to Customer Name");
                        ContractLERec.VALIDATE(Quantity, abs(ILERec.Quantity));
                        ContractLERec.VALIDATE("Entry Type", ContractLERec."Entry Type"::Sale);
                        ContractLERec.VALIDATE("Item No.", ILERec."Item No.");
                        ContractLERec.Validate("Item Description", ILERec.Description);
                        ContractLERec.VALIDATE("Unit Of Measure Code", ILERec."Unit of Measure Code");
                        ContractLERec.VALIDATE("Apply To Doc No.", SIHRec."No.");
                        ContractLERec.Validate("Sales Order No.", SIHRec."Order No.");
                        //DX        04 July 2021 Addiitonal fields
                        ContractLERec.VALIDATE("Batch No.", ILERec."Lot No.");
                        ContractLERec.Validate("Expiration Date", ILERec."Expiration Date");
                        ContractLERec.Validate("Delivery Charge", SIHRec."Delivery Charge");
                        ContractLERec.Validate("Cage No.", SIHRec."Delivery Zone");
                        //DX        04 July 2021 Addiitonal fields
                        ContractLERec.INSERT(TRUE);
                    end;



                UNTIL VLERec.NEXT = 0;
            MESSAGE('New TBA Sales Ledger inserted, Please refresh the page');
        end;
    end;

    //DX        04 July 2021
    procedure InsertAdjSalesLine(TBARec: Record "TBA Ledger Entry"; Qty: Decimal; AdjDate: Date; Remarks: Text[100])
    var
        myInt: Integer;
        ContractLERec: Record "TBA Ledger Entry";
        EntryNo: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        SILRec: Record "Sales Invoice Line";
        SIHRec: Record "Sales Invoice Header";
        InitDocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        CustRec: Record customer;
    begin

        ContractLERec.RESET;
        IF ContractLERec.COUNT = 0 THEN
            EntryNo := 1
        ELSE BEGIN
            IF ContractLERec.FINDLAST THEN
                EntryNo := ContractLERec."Entry No." + 1;
        END;
        ContractLERec.RESET;
        ContractLERec.INIT;
        ContractLERec.VALIDATE("Entry No.", EntryNo);
        ContractLERec.VALIDATE("Document No.", TBARec."Document No.");
        ContractLERec.VALIDATE("Posting Date", AdjDate);
        ContractLERec.VALIDATE("Customer No.", TBARec."Customer No.");
        ContractLERec.VALIDATE("Customer Name", TBARec."Customer Name");
        ContractLERec.VALIDATE(Quantity, -Qty);
        ContractLERec.VALIDATE("Entry Type", ContractLERec."Entry Type"::Adjustment);
        ContractLERec.VALIDATE("Item No.", TBARec."Item No.");
        ContractLERec.Validate("Item Description", TBARec."Item Description");
        ContractLERec.VALIDATE("Unit Of Measure Code", TBARec."Unit Of Measure Code");
        ContractLERec.VALIDATE("Apply To Doc No.", TBARec."Apply To Doc No.");
        //DX        04 July 2021 Addiitonal fields
        ContractLERec.VALIDATE("Batch No.", TBARec."Batch No.");
        ContractLERec.Validate("Expiration Date", TBARec."Expiration Date");
        ContractLERec.Validate(Remarks, Remarks);
        ContractLERec.Validate("Delivery Charge", TBARec."Delivery Charge");
        ContractLERec.Validate("Sales Order No.", TBARec."Sales Order No.");
        ContractLERec.Validate("Cage No.", TBARec."Cage No.");
        //DX        04 July 2021 Addiitonal fields
        ContractLERec.INSERT(TRUE);

        MESSAGE('New TBA Adjustment created, Please refresh the page');
    end;
    //DX        04 July 2021

    procedure InserPendDeliveryLine(SLRec: Record "Sales Line"; Qty: Decimal; AdjDate: Date; Remarks: Text[100])
    var
        myInt: Integer;
        ContractLERec: Record "TBA Ledger Entry";
        EntryNo: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        SILRec: Record "Sales Invoice Line";
        SIHRec: Record "Sales Invoice Header";
        SHRec: Record "Sales Header";
        InitDocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        CustRec: Record customer;
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
    begin

        SSSetup.GET;
        SSSetup.TESTFIELD("TBA Adjustment No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."TBA Adjustment No. Series", SSSetup."TBA Adjustment No. Series", TODAY, InitDocNo, SSSetup."TBA Adjustment No. Series");
        InitDocNo := NoSeries.GetNextNo(SSSetup."TBA Adjustment No. Series", Today);

        ContractLERec.RESET;
        IF ContractLERec.COUNT = 0 THEN
            EntryNo := 1
        ELSE BEGIN
            IF ContractLERec.FINDLAST THEN
                EntryNo := ContractLERec."Entry No." + 1;
        END;
        SHRec.reset;
        SHRec.SetRange("No.", SLRec."Document No.");
        SHRec.SetRange("Document Type", SLRec."Document Type");
        if SHRec.FindFirst() then begin
            ContractLERec.RESET;
            ContractLERec.INIT;
            ContractLERec.VALIDATE("Entry No.", EntryNo);
            ContractLERec.VALIDATE("Document No.", InitDocNo);
            ContractLERec.VALIDATE("Posting Date", AdjDate);
            ContractLERec.VALIDATE("Customer No.", shrec."Sell-to Customer No.");
            ContractLERec.VALIDATE("Customer Name", shrec."Sell-to Customer Name");
            ContractLERec.VALIDATE(Quantity, -Qty);
            ContractLERec.Validate("Entry Type", ContractLERec."Entry Type"::"Pending Delivery");
            ContractLERec.VALIDATE("Item No.", SLRec."No.");
            ContractLERec.Validate("Item Description", SLRec."Description");
            ContractLERec.VALIDATE("Unit Of Measure Code", SLRec."Unit Of Measure Code");
            ContractLERec.Validate("Sales Order No.", SLRec."Document No.");
            ContractLERec.Validate("Delivery Charge", SHRec."Delivery Charge");
            ContractLERec.Validate("Cage No.", SHRec."Delivery Zone");
            //ContractLERec.VALIDATE("Apply To Doc No.", SLRec."Apply To Doc No.");
            //DX        04 July 2021 Addiitonal fields
            //ContractLERec.VALIDATE("Batch No.", TBARec."Batch No.");
            //ContractLERec.Validate("Expiration Date", TBARec."Expiration Date");
            ContractLERec.Validate(Remarks, Remarks);
            //DX        04 July 2021 Addiitonal fields
            ContractLERec.INSERT(TRUE);

            MESSAGE('New pending delivery created for sales order in TBA.');
        end;

    end;
    //DX        04 July 2021


    procedure InsertDeliveryLineToDO(AdjQty: decimal; DODocNo: Code[20]; ContractRec: Record "TBA Ledger Entry"; DelZone: Code[50])
    var
        myInt: Integer;
        ContractLERec: Record "TBA Ledger Entry";
        EntryNo: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        InitDocNo: Code[20];
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        CustRec: Record customer;
        DOContractRec: Record "TBA Ledger Entry";
    begin

        //DX        120521      Check that DO has not been checked yet by  warehouse.
        if TBAHasBeenChecked(DODocNo) then begin
            Error('Cannot add new lines to existing DO, DO has already been checked by Warehouse.');
        end;

        ContractLERec.RESET;
        IF ContractLERec.COUNT = 0 THEN
            EntryNo := 1
        ELSE BEGIN
            IF ContractLERec.FINDLAST THEN
                EntryNo := ContractLERec."Entry No." + 1;
        END;
        ContractLERec.RESET;
        ContractLERec.INIT;
        ContractLERec.VALIDATE("Entry No.", EntryNo);

        //RL        23 Nov 2022 shift document no. logic
        // IF DODocNo <> '' THEN BEGIN
        //     DOContractRec.RESET;
        //     DOContractRec.SETRANGE("Document No.", DODocNo);
        //     IF DOContractRec.FINDFIRST THEN BEGIN
        //         ContractLERec.VALIDATE("Document No.", DOContractRec."Document No.");
        //         ContractLERec.VALIDATE("Posting Date", DOContractRec."Posting Date");
        //     END;
        // END;

        ContractLERec.VALIDATE("Customer No.", ContractRec."Customer No.");
        ContractLERec.VALIDATE("Customer Name", CustRec.Name);
        ContractLERec.VALIDATE(Quantity, -AdjQty);
        ContractLERec.VALIDATE("Entry Type", ContractRec."Entry Type"::Delivery);
        ContractLERec.VALIDATE("Item No.", ContractRec."Item No.");
        ContractLERec.VALIDATE("Item Description", ContractRec."Item Description");
        ContractLERec.VALIDATE("Unit Of Measure Code", ContractRec."Unit Of Measure Code");
        ContractLERec.VALIDATE("Apply To Doc No.", ContractRec."Document No.");
        //DX        04 July 2021 Addiitonal fields
        ContractLERec.VALIDATE("Batch No.", ContractRec."Batch No.");
        ContractLERec.Validate("Expiration Date", ContractRec."Expiration Date");
        ContractLERec.Validate("Bin Remarks", ContractRec."Bin Remarks");
        //DX        04 July 2021 Addiitonal fields
        //DX        28 Aug 2021
        ContractLERec.Validate("Cage No.", DelZone);
        ContractLERec.Validate("Delivery Charge", ContractRec."Delivery Charge");

        //RL        23 Nov 2022 - Shift document no. logic
        IF DODocNo <> '' THEN BEGIN
            DOContractRec.RESET;
            DOContractRec.SETRANGE("Document No.", DODocNo);
            IF DOContractRec.FINDFIRST THEN BEGIN
                ContractLERec.VALIDATE("Document No.", DOContractRec."Document No.");
                ContractLERec.VALIDATE("Posting Date", DOContractRec."Posting Date");
            END;
        END ELSE
            ContractLERec.Validate("Document No.", ContractRec."Sales Order No.");
        //RL        23 Nov 2022 - End

        ContractLERec.Validate("Sales Order No.", ContractRec."Sales Order No.");
        //DX        28 Aug 2021
        ContractLERec.INSERT(TRUE);
        MESSAGE('Delivery TBA Sales Ledger added to existing Delivery Order');
    end;
    //DX        120521      Create Assignment ledger entry after DO is created to maintain consistency of tracking all picking
    procedure CreateALEforTBA(TBARec: Record "TBA Ledger Entry")
    var
        myInt: Integer;
        ALE: Record "Assignment Ledger Entry";
        ALE2: Record "Assignment Ledger Entry";
        SIHRec: Record "Sales Invoice Header";
    begin
        ALE.reset;
        ALE.SetRange("Picking Doc No.", TBARec."Document No.");
        ALE.SetRange("Document No.", TBARec."Apply To Doc No.");
        if NOT (ALE.FindFirst()) then begin
            SIHRec.reset;
            SIHRec.SetRange("No.", TBARec."Apply To Doc No.");
            if SIHRec.FindFirst() then begin end;
            ALE2.reset;
            if ALE2.FindLast() then begin
                myInt := ALE2."Entry No." + 1;
            end else
                myInt := 1;

            ale.reset;
            ALE.init;
            ALE."Entry No." := myInt;
            ALE."Document No." := TBARec."Apply To Doc No.";
            ALE."Picking Doc No." := TBARec."Document No.";
            ALE."Posting Date" := TBARec."Posting Date";
            ALE."Check Start Time" := CreateDateTime(Today, time());
            ALE."Check End Time" := CreateDateTime(Today, time());
            ale."Customer No." := SIHRec."Sell-to Customer No.";
            ALE."Customer Name" := SIHRec."Sell-to Customer Name";
            ALE."Invoice No." := TBARec."Apply To Doc No.";
            ALE.Status := ALE.Status::"Pending Delivery";
            ALE.Insert(TRUE);
        end;
    end;
    //DX        120521      Check that TBA DO has not been checked yet, if checking is started, means cannot create new entry to the existing DO.
    local procedure TBAHasBeenChecked(DONo: code[20]) HasbeenChecked: Boolean;
    var
        myInt: Integer;
        CheckingRec: Record "Checking Header";
    begin
        CheckingRec.reset;
        CheckingRec.SetRange("No.", DONo);
        if CheckingRec.FindFirst() then
            exit(TRUE)
        else
            exit(FALSE);
    end;


    //040521 DX        After creating a warehouse shipment, to auto create the assignment list ledger
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    procedure OnAfterPostSalesLine(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    var
        SSSetup: Record "Sales & Receivables Setup";
    begin
        if (SalesHeader."TBA Order" = true) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            InsertContractLedgerByLine(SalesInvoiceHeader, SalesHeader."Posting Date");
        end;
    end;

    procedure IsTBA(DocNo: Code[20]) IsTrue: Boolean
    var
        myInt: Integer;
        TBALedger: Record "TBA Ledger Entry";
    begin
        TBALedger.reset;
        TBALedger.SetRange("Document No.", DocNo);
        if TBALedger.count > 0 then
            exit(TRUE)
        else
            exit(false);
    end;

    //DX        04 July 2021    Allow swapping and change of batch number if batch selected was wrong.
    procedure SwapBatch(VAR TBAREc: Record "TBA Ledger Entry"; BatchNo: code[50])
    var
        myInt: Integer;
        lTBARec: Record "TBA Ledger Entry";
    begin


        lTBARec.reset;
        lTBARec.SetRange("Item No.", TBAREc."Item No.");
        //lTBARec.SetRange("Entry Type", lTBARec."Entry Type"::Delivery);
        lTBARec.SetRange("Apply To Doc No.", TBAREc."Document No.");
        if lTBARec.FindSet() then
            repeat
                lTBARec."Batch No." := BatchNo;
                lTBARec.Modify(False);
            until lTBARec.Next = 0;



    end;
    //DX        04 July 2021

    // YF 17 Feb 2022
    procedure ArchiveTBALedgerEntries()
    var
        TBAFilterRec: Record "TBA Ledger Entry";
        TBADeleteRec: Record "TBA Ledger Entry";
        TBAArchiveRec: Record "TBA Ledger Entry Archive";
        ArchiveCounter: Integer;
        ArchiveInsertError: Boolean;
        CountSubEntries: Integer;
        ErrorMessage: Text;
    begin
        ArchiveCounter := 0;
        ErrorMessage := '';

        TBAFilterRec.Reset;
        // TBAFilterRec.SetRange("Entry No.", 12); // for debug and test filter only
        TBAFilterRec.SetRange("Entry Type", TBAFilterRec."Entry Type"::Sale);
        TBAFilterRec.SetFilter("Remaining Qty", '=0');
        if TBAFilterRec.FindSet() then
            repeat

                CountSubEntries := 0;
                ArchiveInsertError := false;

                TBADeleteRec.Reset;
                TBADeleteRec.SetRange("Item No.", TBAFilterRec."Item No.");
                TBADeleteRec.SetRange("Apply To Doc No.", TBAFilterRec."Apply To Doc No.");
                if TBADeleteRec.FindSet() then
                    repeat
                        // copy to archive
                        TBADeleteRec.CalcFields("Remaining Qty");

                        TBAArchiveRec.Reset;
                        TBAArchiveRec.Init();
                        TBAArchiveRec.TransferFields(TBADeleteRec);
                        if not TBAArchiveRec.Insert() then
                            ArchiveInsertError := true;

                        CountSubEntries += 1;

                    until TBADeleteRec.Next() = 0;

                // delete archived entry from actual ledger
                if not ArchiveInsertError then begin
                    // delete
                    TBADeleteRec.Reset;
                    TBADeleteRec.SetRange("Item No.", TBAFilterRec."Item No.");
                    TBADeleteRec.SetRange("Apply To Doc No.", TBAFilterRec."Apply To Doc No.");
                    // YF 10 Aug 2022 // To avoid unnecessary table lock
                    if not TBADeleteRec.IsEmpty then
                        TBADeleteRec.DeleteAll();
                    // YF 10 Aug 2022 // To avoid unnecessary table lock
                    ArchiveCounter += CountSubEntries;
                end
                else begin
                    // roll back of archival insert
                    TBAArchiveRec.Reset;
                    TBAArchiveRec.SetRange("Item No.", TBAFilterRec."Item No.");
                    TBAArchiveRec.SetRange("Apply To Doc No.", TBAFilterRec."Apply To Doc No.");
                    // YF 10 Aug 2022 // To avoid unnecessary table lock
                    if not TBAArchiveRec.IsEmpty then
                        TBAArchiveRec.DeleteAll();
                    // YF 10 Aug 2022 // To avoid unnecessary table lock

                    ErrorMessage := ' with error(s)';
                end;

            until TBAFilterRec.Next() = 0;

        Message(Format(ArchiveCounter) + ' entries archived' + ErrorMessage);
    end;
    // YF 17 Feb 2022

    var
        myInt: Integer;
}