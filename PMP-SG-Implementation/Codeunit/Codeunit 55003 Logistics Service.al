codeunit 55003 LS
{

    //110521 DX Before posting of the sales invoice, check that if it is a Logistics service transaction, if it is then remove the unit price away.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeUpdateSalesLineBeforePost', '', true, true)]
    procedure OnBeforeUpdateSalesLineBeforePost(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var

    begin

        if (salesheader."Logistics Service" = true) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            //DX        21 July 2021        To set to 0 unit price due to business process

            if SalesLine."Selling Price" <> 0 then begin
                // SalesHeader.Status := SalesHeader.Status::Open;
                SalesLine."LS Unit Price" := SalesLine."Selling Price";
                SalesLine.validate("Unit Price", 0);
                SalesLine.validate("Selling Price", 0);
                // SalesHeader.Status := SalesHeader.Status::Released;


            end;
        end;
        //DX     17 Sept 2021   #293    
        if (SalesHeader."Samples SO" = true) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            if SalesLine."Selling Price" <> 0 then begin
                //SalesLine."LS Unit Price" := SalesLine."Selling Price";
                SalesLine.validate("Unit Price", 0);
                SalesLine.validate("Selling Price", 0);
            end;
        end;
        //DX     17 Sept 2021
    end;



    //DX        19 July 2021        Initialise no. series based on user permission
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInitInsert', '', true, true)]
    procedure OnAfterInitRecord(xSalesHeader: Record "Sales Header"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SSsetup: Record "Sales & Receivables Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        CompInfo: Record "Company Information";

    begin

        if IsLSLogin() then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                IsHandled := true;
                SSsetup.reset;
                SSsetup.get;
                SSsetup.TestField("Def. LS Order No. Series");
                SSsetup.TestField("Def. LS Revenue Acct.");
                SSsetup.TestField("Def. LS DO. No. Series");
                sssetup.TestField("Def. LS Inv. No. Series");
                // NoSeriesMgt.InitSeries(SSsetup."Def. LS Order No. Series", xSalesHeader."No. Series", SalesHeader."Posting Date", SalesHeader."No.", SalesHeader."No. Series");
                SalesHeader."No. Series" := SSsetup."Def. LS Order No. Series";
                if NoSeries.AreRelated(SSsetup."Def. LS Order No. Series", xSalesHeader."No. Series") then
                    SalesHeader."No. Series" := xSalesHeader."No. Series";
                SalesHeader."No." := NoSeries.GetNextNo(SSsetup."Def. LS Order No. Series", SalesHeader."Posting Date");
            end;

        end;
    end;


    //DX        31 Aug 2021
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInitRecord', '', true, true)]
    procedure POOnBeforeInitRecord(var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header")
    var

    begin
        if IsLSLogin() then begin
            PurchaseHeader."Logistics Service" := true;
        end;
    end;
    //DX        31 Aug 2021

    //DX        19 July 2021        Initialise no. series based on user permission
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInitRecord', '', true, true)]
    procedure OnBeforeInitRecord(var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    var
        SSsetup: Record "Sales & Receivables Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
    begin
        if IsLSLogin() then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                SSsetup.reset;
                SSsetup.get;
                IsHandled := true;

                // NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SSsetup."Def. LS Inv. No. Series");
                if NoSeries.IsAutomatic(SSsetup."Def. LS Inv. No. Series") then
                    SalesHeader."Posting No. Series" := SSsetup."Def. LS Inv. No. Series";
                // NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SSsetup."Def. LS DO. No. Series");
                if NoSeries.IsAutomatic(SSsetup."Def. LS DO. No. Series") then
                    SalesHeader."Shipping No. Series" := SSsetup."Def. LS DO. No. Series";

                SalesHeader."Logistics Service" := true;
                if SSSetup."Def. LS Location COde" <> '' then begin
                    SalesHeader.Validate("Location Code", SSsetup."Def. LS Location COde");
                    //rec.Modify(TRUE);
                end;
                SalesHeader."LS Account" := 'DUOPHARMA';
                SalesHeader."Delivery Charge" := 'N';

            end;
        end else
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
                SalesHeader."Logistics Service" := true;
                SSsetup.reset;
                SSsetup.get;
                if SSSetup."Def. LS Location COde" <> '' then begin
                    SalesHeader.Validate("Location Code", SSsetup."Def. LS Location COde");
                end;
            end;
    end;

    //DX        19 July 2021        Initialise no. series based on user permission

    //DX        19 July 2021        Change event to insert the lines.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    procedure OnAfterPostSalesLines(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        if SalesInvoiceHeader."Logistics Service" = true then begin
            CreateLogisticsEntry(SalesInvoiceHeader);
        end;
        if SalesCrMemoHeader."Logistics Service" = true then begin
            CreateLogisticsEntryForCN(SalesCrMemoHeader);
        end;
    end;



    procedure CreateLogisticsEntry(SIHRec: Record "Sales Invoice Header")
    var
        EntryNo: Integer;
        SILRec: Record "Sales Invoice Line";
        LSRec: Record "LS Ledger Entry";
        LSMatrix: Record "LS Commission Matrix";
        SSSetup: Record "Sales & Receivables Setup";
    begin
        //If sales order posted is a LS transaction, then create the ledger.
        LSRec.RESET;
        IF LSRec.COUNT = 0 THEN
            EntryNo := 1
        ELSE BEGIN
            IF LSRec.FINDLAST THEN
                EntryNo := LSRec."Entry No." + 1;
        END;

        SILRec.reset;
        SILRec.SetFilter("Document No.", SIHRec."No.");
        //SILRec.SetFilter("Unit Price", '<>0');
        SILRec.SetFilter(Quantity, '<>0');
        if SILRec.FindSet() then
            repeat
                LSRec.RESET;
                LSRec.INIT;
                LSRec.VALIDATE("Entry No.", EntryNo);
                LSRec.VALIDATE("Document No.", SILRec."Document No.");
                LSRec.VALIDATE("Customer No.", SILRec."Sell-to Customer No.");
                LSRec.Validate("Customer Name", SIHRec."Sell-to Customer Name");
                LSRec.VALIDATE(Quantity, SILRec."Order Qty");
                LSRec.Validate("FOC Quantity", SILRec."FOC Qty");
                LSRec.VALIDATE("Posting Date", SILRec."Posting Date");
                LSRec.VALIDATE("Item No.", SILRec."No.");
                LSRec.Validate("Item Description", SILRec.Description);
                LSRec.VALIDATE("Unit Of Measure Code", SILRec."Unit of Measure Code");
                LSRec.Validate("Unit Price", SILRec."LS Unit Price");
                LSRec.Validate("Line Amount", SILRec."LS Unit Price" * SILRec."Order Qty");
                //DX        21 July 2021
                LSRec.Validate("Ext. Doc No.", SIHRec."External Document No.");
                LSRec.Validate("LS Account", SIHRec."LS Account"); // YF 21 Sept 2021
                SSSetup.reset;
                SSSetup.get;
                if SIHRec."Shipment Method Code" = SSSetup."Def. Self Pick Method" then begin
                    LSRec.Validate("Calculation Method", LSRec."Calculation Method"::Line);
                    LSRec.Validate("Commission Amount", SSSetup."Def. LS Line Charge Amount");
                end else begin
                    LSMatrix.reset;
                    LSMatrix.SetRange("Customer Code", SILRec."Sell-to Customer No.");
                    LSMatrix.SetRange("Item Code", SILRec."No.");
                    LSMatrix.SetFilter(Percentage, '<>0');
                    if LSMatrix.FindFirst() then begin
                        LSRec.Validate("Calculation Method", LSRec."Calculation Method"::Percentage);
                        LSRec.Validate("Commission Amount", LSRec."Line Amount" * LSMatrix.Percentage / 100);
                    end else begin
                        LSRec.Validate("Calculation Method", LSRec."Calculation Method"::Line);
                        LSRec.Validate("Commission Amount", SSSetup."Def. LS Line Charge Amount");
                    end;
                end;

                //DX        21 July 2021
                LSRec.INSERT(TRUE);
                EntryNo += 1;
            until SILRec.next = 0;
        Message('LS Entry created');
    end;


    procedure CreateLogisticsEntryForCN(SCHRec: Record "Sales Cr.Memo Header")
    var
        EntryNo: Integer;
        SCLRec: Record "Sales Invoice Line";
        LSRec: Record "LS Ledger Entry";
        LSMatrix: Record "LS Commission Matrix";
        SSSetup: Record "Sales & Receivables Setup";
    begin
        //If sales order posted is a LS transaction, then create the ledger.
        LSRec.RESET;
        IF LSRec.COUNT = 0 THEN
            EntryNo := 1
        ELSE BEGIN
            IF LSRec.FINDLAST THEN
                EntryNo := LSRec."Entry No." + 1;
        END;

        SCLRec.reset;
        SCLRec.SetFilter("Document No.", SCHRec."No.");
        //SILRec.SetFilter("Unit Price", '<>0');
        SCLRec.SetFilter(Quantity, '<>0');
        if SCLRec.FindSet() then
            repeat
                LSRec.RESET;
                LSRec.INIT;
                LSRec.VALIDATE("Entry No.", EntryNo);
                LSRec.VALIDATE("Document No.", SCLRec."Document No.");
                LSRec.VALIDATE("Customer No.", SCLRec."Sell-to Customer No.");
                LSRec.Validate("Customer Name", SCHRec."Sell-to Customer Name");
                LSRec.VALIDATE(Quantity, -SCLRec."Order Qty");
                LSRec.Validate("FOC Quantity", -SCLRec."FOC Qty");
                LSRec.VALIDATE("Posting Date", SCLRec."Posting Date");
                LSRec.VALIDATE("Item No.", SCLRec."No.");
                LSRec.Validate("Item Description", SCLRec.Description);
                LSRec.VALIDATE("Unit Of Measure Code", SCLRec."Unit of Measure Code");
                LSRec.Validate("Unit Price", -SCLRec."LS Unit Price");
                LSRec.Validate("Line Amount", SCLRec."LS Unit Price" * -SCLRec."Order Qty");
                //DX        21 July 2021
                LSRec.Validate("Ext. Doc No.", SCHRec."External Document No.");
                LSRec.Validate("LS Account", SCHRec."LS Account"); // YF 21 Sept 2021
                SSSetup.reset;
                SSSetup.get;
                if SCHRec."Shipment Method Code" = SSSetup."Def. Self Pick Method" then begin
                    LSRec.Validate("Calculation Method", LSRec."Calculation Method"::Line);
                    LSRec.Validate("Commission Amount", -SSSetup."Def. LS Line Charge Amount");
                end else begin
                    LSMatrix.reset;
                    LSMatrix.SetRange("Customer Code", SCHRec."Sell-to Customer No.");
                    LSMatrix.SetRange("Item Code", SCLRec."No.");
                    LSMatrix.SetFilter(Percentage, '<>0');
                    if LSMatrix.FindFirst() then begin
                        LSRec.Validate("Calculation Method", LSRec."Calculation Method"::Percentage);
                        if (-LSRec."Line Amount" * LSMatrix.Percentage <> 0) then
                            LSRec.Validate("Commission Amount", -LSRec."Line Amount" * LSMatrix.Percentage / 100);
                    end else begin
                        LSRec.Validate("Calculation Method", LSRec."Calculation Method"::Line);
                        LSRec.Validate("Commission Amount", -SSSetup."Def. LS Line Charge Amount");
                    end;
                end;

                //DX        21 July 2021
                LSRec.INSERT(TRUE);
                EntryNo += 1;
            until SCLRec.next = 0;
        Message('LS Entry created');
    end;

    procedure CreateLSInvLine(TotalAmt: Decimal; SHRec: Record "Sales Header")
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        LineNo: Integer;
        SSsetup: Record "Sales & Receivables Setup";
        CustRec: Record customer;
    begin
        SSsetup.Reset();
        SSsetup.get;
        SSsetup.TestField("Def. LS Revenue Acct.");


        CustRec.reset;
        CustRec.SetRange("No.", SHRec."Sell-to Customer No.");
        if CustRec.FindFirst() then begin
            if CustRec."LS Percentage" = 0 then
                Error('LS Percentage is currently set at 0, please set correctly before executing this process.');
        end;
        SLRec.reset;
        SLRec.SetRange("Document Type", SHRec."Document Type");
        SLRec.SetRange("No.", SHRec."No.");
        if SLRec.FindLast() then
            LineNo := SLRec."Line No." + 10000
        else
            LineNo := 10000;

        clear(SLRec);
        SLRec.reset;
        SLRec.init;
        SLRec.Validate("Document Type", SHRec."Document Type");
        SLRec.Validate("Document No.", SHRec."No.");
        SLRec.Validate("Line No.", LineNo);
        SLRec.validate(Type, SLRec.Type::"G/L Account");
        slrec.validate("No.", SSsetup."Def. LS Revenue Acct.");
        SLRec.Validate(Quantity, 1);
        SLRec.Validate("Unit Price", TotalAmt);
        SLRec.Insert(true);

    end;


    //DX        19 July 2021
    procedure InsertAdjLine(SIHRecNo: Code[20])
    var
        myInt: Integer;
        ContractLERec: Record "LS Ledger Entry";
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
                        ContractLERec.VALIDATE(Quantity, ILERec.Quantity);
                        ContractLERec.VALIDATE("Item No.", ILERec."Item No.");
                        ContractLERec.Validate("Item Description", ILERec.Description);
                        ContractLERec.VALIDATE("Unit Of Measure Code", ILERec."Unit of Measure Code");
                        ContractLERec.Validate("Unit Price", VLERec."Cost Amount (Actual)");
                        ContractLERec.Validate("Line Amount", VLERec."Cost Amount (Actual)" * SILRec.Quantity);
                        ContractLERec.INSERT(TRUE);
                    end;

                UNTIL VLERec.NEXT = 0;
            MESSAGE('New LS Ledger inserted, Please refresh the page');
        end;
    end;
    //DX        19 July 2021

    procedure IsLSLogin(): Boolean
    var
        myInt: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        // UserGrpMemberRec: Record "User Group Member"; // YF 2024-10-11 // BC 25 Upgrade
        AccessControlRec: Record "Access Control"; // YF 2024-10-11 // BC 25 Upgrade
    begin
        SSSetup.reset;
        SSSetup.get;
        //SSSetup.TestField("Def. LS User Group");

        // YF 2024-10-11 // BC 25 Upgrade
        if SSSetup."Def. LS User Group" <> '' then begin
            AccessControlRec.Reset;
            AccessControlRec.SetRange("Role ID", SSSetup."Def. LS User Group");
            // AccessControlRec.SetRange("Company Name", CompanyName);
            AccessControlRec.SetRange("User Security ID", UserSecurityId());
            if AccessControlRec.FindFirst() then
                exit(true)
            else
                exit(false);
        end else
            exit(FALSE);

        /* 
        if SSSetup."Def. LS User Group" <> '' then begin
            UserPerm.reset;
            UserPerm.SetRange("User Name", UserId);
            UserPerm.SetRange("User Group Code", SSSetup."Def. LS User Group");
            if UserPerm.FindFirst() then
                exit(true)
            else
                exit(false);
        end else
            exit(FALSE);
        */
        // YF 2024-10-11 // BC 25 Upgrade
    end;

    //DX        01 Aug 2021
    procedure UpdateLSCalcMethod(EntryNo: Integer)
    var
        myInt: Integer;
        LSMatrix: Record "LS Commission Matrix";
        LSEntry: Record "LS Ledger Entry";
        DocNo: Code[20];
        SSSetup: Record "Sales & Receivables Setup";
        CurrCalcMethod: text[50];
    begin
        LSEntry.reset;
        LSEntry.SetRange("Entry No.", EntryNo);
        if LSEntry.FindFirst() then begin
            DocNo := LSEntry."Document No.";

            CurrCalcMethod := Format(LSEntry."Calculation Method");
        end;
        LSEntry.reset;
        LSEntry.SetRange("Document No.", DocNo);
        if LSEntry.FindSet() then
            repeat

                if CurrCalcMethod = 'Line' then begin
                    LSMatrix.reset;
                    LSMatrix.SetRange("Customer Code", LSEntry."Customer No.");
                    LSMatrix.SetRange("Item Code", LSEntry."Item No.");
                    LSMatrix.SetFilter(Percentage, '<>0');
                    if LSMatrix.FindFirst() then begin
                        LSEntry.Validate("Calculation Method", LSEntry."Calculation Method"::Percentage);
                        if (LSEntry."Line Amount" * LSMatrix.Percentage <> 0) then
                            LSEntry.Validate("Commission Amount", LSEntry."Line Amount" * LSMatrix.Percentage / 100);
                    end else begin
                        LSEntry.Validate("Calculation Method", LSEntry."Calculation Method"::Percentage);
                        LSEntry.Validate("Commission Amount", 0);
                    end;

                end else
                    if CurrCalcMethod = 'Percentage' then begin
                        LSEntry.Validate("Calculation Method", LSEntry."Calculation Method"::Line);
                        LSEntry.Validate("Commission Amount", SSSetup."Def. LS Line Charge Amount");
                    end;
                LSEntry.Modify(TRUE);
            until LSEntry.next = 0;


        Message('Calculation Method updated.');
    end;
    //DX        01 Aug 2021

    //RL        01 Jun 2022
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeTestStatusOpen', '', false, false)]
    local procedure OnBeforeTestStatusOpen(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer; var StatusCheckSuspended: Boolean);
    begin
        if (salesheader."Logistics Service" = true) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin

            StatusCheckSuspended := true;
        end;
        if (SalesHeader."Samples SO" = true) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin

            StatusCheckSuspended := true;
        end;
    end;
    //RL        01 Jun 2022
}
