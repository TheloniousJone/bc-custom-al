codeunit 60100 "Wellaway CU"
{
    Permissions = TableData "Sales Shipment Header" = rimd, tabledata "Dimension Set Entry" = RIMD;
    //DX        25 July 2021
    [EventSubscriber(ObjectType::Codeunit, codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', true, true)]
    procedure OnAfterTransferOrderPostReceipt(var TransferReceiptHeader: Record "Transfer Receipt Header")
    var
        ILERec: Record "Item Ledger Entry";
        SSSetup: Record "Sales & Receivables Setup";
        IJRec: Record "Item Journal Line";
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        EntryNo: integer;
        CompInfo: Record "Company Information";

    begin

        if IsPMPCompany() then begin
            //DX        08 Oct 2021
            if TransferReceiptHeader."Transfer-to Code" = GetWellLocCode() then begin
                SSSetup.reset;
                SSSetup.ChangeCompany(GetWellawayCompany());
                SSSetup.get;
                CompInfo.reset;
                CompInfo.ChangeCompany(GetWellawayCompany());
                CompInfo.get;

                ILERec.reset;
                ILERec.SetRange("Document No.", TransferReceiptHeader."No.");
                ILERec.SetRange("Entry Type", ILERec."Entry Type"::Transfer);
                ILERec.SetRange("Location Code", GetWellLocCode());
                ILERec.SetRange("Posting Date", TransferReceiptHeader."Posting Date");
                if ILERec.FindSet() then
                    repeat
                        ResEntry2.reset;
                        ResEntry2.ChangeCompany(GetWellawayCompany());
                        if ResEntry2.FindLast() then begin
                            EntryNo := ResEntry2."Entry No." + 1;
                        end else begin
                            EntryNo := 1;
                        end;

                        ResEntry.reset;
                        ResEntry.ChangeCompany(GetWellawayCompany());
                        ResEntry.init;
                        ResEntry."Entry No." := EntryNo;
                        ResEntry."Item No." := ILERec."Item No.";
                        ResEntry."Location Code" := CompInfo."Location Code";
                        ResEntry."Quantity (Base)" := ILERec.Quantity;
                        ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
                        ResEntry."Creation Date" := today;
                        ResEntry."Source Type" := 83;
                        ResEntry."Source Subtype" := 2;
                        ResEntry."Source ID" := 'ITEM';
                        ResEntry."Source Batch Name" := SSSetup."Def Item. Journal Batch";
                        ResEntry."Source Ref. No." := GetSourceLineNo(ILERec."Item No.", TransferReceiptHeader."Transfer Order No.");
                        ResEntry."Expected Receipt Date" := Today;
                        ResEntry."Created By" := UserId;
                        ResEntry.Positive := true;
                        ResEntry."Qty. per Unit of Measure" := 1;
                        ResEntry.Quantity := ILERec.Quantity;
                        ResEntry."Expiration Date" := ILERec."Expiration Date";
                        ResEntry."Qty. to Handle (Base)" := ILERec.Quantity;
                        ResEntry."Qty. to Invoice (Base)" := ILERec.Quantity;
                        ResEntry."Lot No." := ILERec."Lot No.";
                        ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
                        ResEntry.Insert(FALSE);

                    until ILERec.next = 0;
            end;
            //DX        08 Oct 2021

        end;
    end;

    procedure GetSourceLineNo(ItemNo: Code[20]; DocNo: Code[20]): integer
    var
        IJRec: Record "Item Journal Line";
        SSSetup: Record "Sales & Receivables Setup";
        myInt: Integer;
    begin
        SSSetup.Reset();
        SSSetup.ChangeCompany(GetWellawayCompany());
        SSSetup.get;
        IJRec.reset;
        IJRec.ChangeCompany(GetWellawayCompany());
        IJRec.SetRange("Journal Template Name", 'ITEM');
        IJRec.SetRange("Journal Batch Name", SSSetup."Def Item. Journal Batch");
        IJRec.SetRange("Document No.", DocNo);
        IJRec.SetRange("Item No.", ItemNo);
        if IJRec.FindFirst() then
            exit(IJRec."Line No.")
        else
            exit(0);
    end;
    //DX        25 July 2021
    procedure CheckWellAwayCompany()
    var
        myInt: Integer;
        CompRec: Record Company;
        CompInfoRec: Record "Company Information";
    begin
        CompRec.reset;
        myInt := 0;
        if CompRec.FindSet() then
            repeat
                CompInfoRec.reset;
                CompInfoRec.ChangeCompany(CompRec.Name);
                if CompInfoRec.FindFirst() then begin
                    if CompInfoRec."Wellaway Company" = true then
                        myInt += 1;
                end;
            until CompRec.next = 0;
        if myInt > 1 then
            Message('There can only be one Wellaway company enabled, please check again.');
    end;

    procedure GetWellawayCompany(): Text[250]
    var
        myInt: Integer;
        CompRec: Record Company;
        CompInfoRec: Record "Company Information";
    begin

        CompInfoRec.reset;
        CompInfoRec.get;
        CompInfoRec.TestField("Wellaway Name");
        exit(CompInfoRec."Wellaway Name");
    end;

    procedure CheckPMPCompany()
    var
        myInt: Integer;
        CompRec: Record Company;
        CompInfoRec: Record "Company Information";
    begin
        CompRec.reset;
        myInt := 0;
        if CompRec.FindSet() then
            repeat
                CompInfoRec.reset;
                CompInfoRec.ChangeCompany(CompRec.Name);
                if CompInfoRec.FindFirst() then begin
                    if CompInfoRec."PMP Company" = true then
                        myInt += 1;
                end;
            until CompRec.next = 0;
        if myInt > 1 then
            Message('There can only be one PMP company enabled, please check again.');
    end;

    procedure GetPMPCompanyName(): Text[250]
    var
        myInt: Integer;
        CompRec: Record company;
        CompInfoRec: Record "Company Information";
    begin
        CompInfoRec.reset;
        CompInfoRec.get;
        CompInfoRec.TestField("PMP Name");
        exit(CompInfoRec."PMP Name");
        /*
        CompRec.reset;
        if CompRec.FindSet() then
            repeat

                CompInfoRec.reset;
                CompInfoRec.ChangeCompany(CompRec.Name);
                CompInfoRec.SetRange("PMP Company", true);
                if CompInfoRec.FindFirst() then
                    exit(compRec.Name);
            until CompRec.next = 0;
        */

    end;

    procedure IsWellawayCompany(): Boolean
    var
        myInt: Integer;
        CompInfoRec: Record "Company Information";
    begin
        CompInfoRec.reset;
        CompInfoRec.get;
        if CompanyName = CompInfoRec."Wellaway Name" then
            exit(true)
        else
            exit(false);
    end;

    procedure GetWellLocCode(): Code[20]
    var
        myInt: Integer;
        LocRec: Record Location;
    begin
        LocRec.Reset();
        LocRec.ChangeCompany(GetPMPCompanyName());
        LocRec.SetLoadFields(Code, "Wellaway Location");
        LocRec.SetRange("Wellaway Location", true);
        if LocRec.FindFirst() then
            exit(LocRec.Code)
        else
            exit('');
    end;

    procedure IsPMPCompany(): Boolean
    var
        myInt: Integer;
        CompInfoRec: Record "Company Information";
    begin
        /*
        CompInfoRec.reset;
        CompInfoRec.get;      
        if CompInfoRec."PMP Company" = true
        
        if CompanyName = 'PMP'
        then
            exit(true)
        else
            exit(false);
            */
        CompInfoRec.reset;
        CompInfoRec.get;
        if CompanyName = CompInfoRec."PMP Name" then
            exit(true)
        else
            exit(false);
    end;


    procedure CreateOrder()
    var
        myInt: Integer;
        TOHdr: Code[20];
        TORec: Record "Transfer Header";
        IJRec: Record "Item Journal Line";
        SSSetup: Record "Sales & Receivables Setup";
    begin
        //CheckCustRec(SHrec."Sell-to Customer No.");
        SSSetup.reset;
        SSSetup.get;
        CreateTOHeader(TORec);
        UpdateIJDocNoWithTORec(TORec."No.");
    end;

    local procedure CheckCustRec(CustNo: Code[20])
    var
        myInt: Integer;
        PMPCustRec: Record Customer;
        CustRec: Record customer;
        GenBusPG: Record "Gen. Business Posting Group";
        VATBusPG: Record "VAT Business Posting Group";
        CustPG: Record "Customer Posting Group";

    begin
        CustRec.reset;
        CustRec.SetRange("No.", CustNo);
        If Custrec.FindFirst() then begin
            GenBusPG.reset;
            GenBusPG.ChangeCompany(GetPMPCompanyName());
            GenBusPG.SetRange(Code, CustRec."Gen. Bus. Posting Group");
            if not GenBusPG.FindFirst() then begin
                GenBusPG.reset;
                GenBusPG.Init();
                GenBusPG.Validate(Code, CustRec."Gen. Bus. Posting Group");
                GenBusPG.Insert(TRUE);
            end;

            VATBusPG.reset;
            VATBusPG.ChangeCompany(GetPMPCompanyName());
            VATBusPG.SetRange(Code, CustRec."VAT Bus. Posting Group");
            if not VATBusPG.FindFirst() then begin
                VATBusPG.reset;
                VATBusPG.Init();
                VATBusPG.Validate(Code, CustRec."VAT Bus. Posting Group");
                VATBusPG.Insert(TRUE);
            end;

            CustPG.reset;
            CustPG.ChangeCompany(GetPMPCompanyName());
            CustPG.SetRange(Code, CustRec."Customer Posting Group");
            if not CustPG.FindFirst() then begin
                CustPG.reset;
                CustPG.Init();
                CustPG.Validate(Code, CustRec."Customer Posting Group");
                CustPG.Insert(TRUE);
            end;

            PMPCustRec.reset;
            PMPCustRec.ChangeCompany(GetPMPCompanyName());
            PMPCustRec.SetRange("No.", CustRec."No.");
            if not (PMPCustRec.FindFirst()) then begin
                PMPCustRec.Reset();
                PMPCustRec.Init();
                PMPCustRec.copy(CustRec);
                PMPCustRec.Insert(TRUE);
            end;
        end;
    end;

    procedure CreateTOHeader(Var TORec: Record "Transfer Header")
    var
        myInt: Integer;
        LocRec: Record Location;
        CompInfo: Record "Company Information";
    begin

        CompInfo.reset;
        CompInfo.ChangeCompany(GetPMPCompanyName());
        CompInfo.get;

        clear(TORec);
        TORec.ChangeCompany(GetPMPCompanyName());
        TORec.Init();
        TORec.Validate("Transfer-from Code", CompInfo."Location Code");
        TORec.validate("Transfer-to Code", GetWellLocCode());
        TORec.Validate("In-Transit Code", 'TRANSIT');
        //TORec.Validate("External Document No.", SORec);
        TORec.Insert(true);
    end;

    procedure CreateTOLineByItemCode(ItemCode: code[20]; ItemQty: Decimal; TORec: Record "Transfer Header")
    var
        myInt: Integer;
        TLRec: Record "Transfer Line";
        SLrec: Record "Sales Line";
        LTLrec: Record "Transfer Line";
        LocRec: Record Location;
        CompInfo: Record "Company Information";
        LLineNo: Integer;
        Item: Record item;
        DimMgt: Codeunit DimensionManagement;
    begin


        LTLrec.reset;
        LTLrec.SetRange("Document No.", TORec."No.");
        if LTLrec.FindLast() then
            LLineNo := LTLrec."Line No." + 10000
        else
            LLineNo := 10000;

        // if StockIsEnoughInPMP(SLRec) <> 0 then begin        //Check if got enough stock first.
        TLRec.reset;
        TLRec.init();
        TLRec.Validate("Document No.", TORec."No.");
        TLRec.Validate("Line No.", LLineNo);
        TLRec."Item No." := ItemCode;
        Item.reset;
        Item.get(ItemCode);
        TLRec.Description := Item.Description;
        TLRec."Description 2" := Item."Description 2";
        TLRec.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
        TLRec.VALIDATE("Inventory Posting Group", Item."Inventory Posting Group");
        TLRec.VALIDATE("Quantity (Base)", ItemQty);
        TLRec.VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
        TLRec.VALIDATE("Gross Weight", Item."Gross Weight");
        TLRec.VALIDATE("Net Weight", Item."Net Weight");
        TLRec.VALIDATE("Unit Volume", Item."Unit Volume");
        TLRec.VALIDATE("Units per Parcel", Item."Units per Parcel");
        TLRec."Item Category Code" := Item."Item Category Code";
        //                    TLRec.Validate(Quantity, StockIsEnoughInPMP(SLRec));        //Return the difference in stock required then create the TO based on stock difference
        //              TLRec.Validate(Quantity, SLRec.Quantity);
        TLRec."Dimension Set ID" := TORec."Dimension Set ID";
        TLRec.Insert(true);
    end;

    //DX        15 July 2021
    procedure CreateTOLineFromIJ(var TORec: Record "Transfer Header")   //DX        15 July 2021    Supposed to perform this action in PMP Entity
    var
        myInt: Integer;
        TLRec: Record "Transfer Line";
        IJRec: Record "Item Journal Line";
        SLRec: Record "Sales Line";
        LocRec: Record Location;
        CompInfo: Record "Company Information";
        LineNo: Integer;
        Item: Record item;
        DimMgt: Codeunit DimensionManagement;
        SSSetup: Record "Sales & Receivables Setup";
    begin
        LineNo := 10000;
        SSSetup.reset;
        SSSetup.ChangeCompany(GetWellawayCompany());
        SSSetup.Get();
        IJRec.reset;
        IJRec.ChangeCompany(GetWellawayCompany());
        IJRec.SetRange("Journal Template Name", 'ITEM');
        IJRec.SetRange("Journal Batch Name", SSSetup."Def Item. Journal Batch");
        IJRec.SetRange("Document No.", TORec."No.");
        if IJRec.FindSet() then
            repeat
                TLRec.Validate("Document No.", TORec."No.");
                TLRec.Validate("Line No.", LineNo);
                TLRec.Validate("Item No.", IJRec."Item No.");
                //TLRec.Validate("Unit of Measure Code", IJRec."Unit of Measure Code");
                //Item.reset;
                //if IJRec."Item No." <> '' then
                //    Item.get(IJRec."Item No.");
                //TLRec.Validate(Description, Item.Description);
                //TLRec.Validate("Description 2", Item."Description 2");
                //TLRec.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
                //TLRec.VALIDATE("Inventory Posting Group", Item."Inventory Posting Group");
                tlrec.Validate(Quantity, IJRec.Quantity);
                //TLRec.VALIDATE("Unit of Measure Code", item."Base Unit of Measure");        //Get base UOM at PMP warehouse.
                //TLRec.VALIDATE("Gross Weight", Item."Gross Weight");
                //TLRec.VALIDATE("Net Weight", Item."Net Weight");
                //TLRec.VALIDATE("Unit Volume", Item."Unit Volume");
                //TLRec.VALIDATE("Units per Parcel", Item."Units per Parcel");
                //TLRec."Item Category Code" := Item."Item Category Code";
                //TLRec."Dimension Set ID" := TORec."Dimension Set ID";
                TLRec.Insert(true);
                LineNo += 10000;
            until IJRec.next = 0;
        TORec."Retrieved SO from Wellaway" := true;
        TORec.Modify(false);

    end;
    //DX        15 July 2021

    procedure GetStockDiff(ItemCode: code[20]; QtyCalc: Decimal): Decimal
    var
        WellQtyBal: Decimal;
        PMPItemRec: Record item;
        WellItemRec: Record item;
        QtyBal: Decimal;
        SLRec: Record "Sales Line";
        PMPItemUOM: Record "Item Unit of Measure";
    begin
        PMPItemRec.reset;
        PMPItemRec.ChangeCompany(GetPMPCompanyName());
        PMPItemRec.SetRange("No.", ItemCode);
        PMPItemRec.SetFilter("Location Filter", GetWellLocCode());
        PMPItemRec.CalcFields(Inventory);
        QtyBal := PMPItemRec.Inventory;
        exit(ROUND(QtyCalc - QtyBal, 1, '>'));
    end;

    local procedure StockIsEnoughInPMP(LSLRec: Record "Sales Line"): Decimal
    var
        WellQtyBal: Decimal;
        PMPItemRec: Record item;
        WellItemRec: Record item;
        QtyBal: Decimal;
        SLRec: Record "Sales Line";
        PMPItemUOM: Record "Item Unit of Measure";
    begin
        PMPItemRec.reset;
        PMPItemRec.ChangeCompany(GetPMPCompanyName());
        PMPItemRec.SetRange("No.", LSLRec."No.");
        PMPItemRec.CalcFields(Inventory);
        QtyBal := PMPItemRec.Inventory;
        SLRec.Reset();
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetRange("No.", LSLRec."No.");
        SLRec.SetFilter(Quantity, '<>0');
        SLRec.CalcSums(SLRec."Quantity (Base)");
        WellQtyBal := SLRec."Quantity (Base)";


        PMPItemUOM.reset;
        PMPItemUOM.ChangeCompany(GetPMPCompanyName());
        PMPItemUOM.SetRange("Item No.", LSLRec."No.");
        PMPItemUOM.SetRange(Code, LSLRec."Unit of Measure Code");
        if PMPItemUOM.FindFirst() then begin
            WellQtyBal := Round(WellQtyBal * PMPItemUOM."Qty. per Unit of Measure", 1, '>');
        end;

        if (QtyBal > WellQtyBal) then begin     //if PMP stock is 10 > 6
            exit(0);
        end else begin                          //if PMP stock is 6 < 10
            exit(WellQtyBal - QtyBal);          //Return the difference and create transfer order for this item line.
        end;
    end;


    procedure AllStockisSufficient(SHRec: Record "Sales Header"): Boolean
    var
        WellQtyBal: Decimal;
        PMPItemRec: Record item;
        WellItemRec: Record item;
        QtyBal: Decimal;
        SLRec: Record "Sales Line";
        PMPItemUOM: Record "Item Unit of Measure";
        SLRecLoop: Record "Sales Line";
    begin

        SLRecLoop.reset;
        SLRecLoop.SetRange("Document Type", SHRec."Document Type");
        SLRecLoop.SetRange("Document No.", SHRec."No.");
        SLRecLoop.SetRange(Type, SLRec.Type::Item);
        SLRecLoop.SetFilter("No.", '<>%1', '');
        SLRecLoop.SetFilter(Quantity, '<>0');
        if SLRecLoop.FindSet() then
            repeat
                PMPItemRec.reset;
                PMPItemRec.ChangeCompany(GetPMPCompanyName());
                PMPItemRec.SetRange("No.", SLRecLoop."No.");
                PMPItemRec.CalcFields(Inventory);
                QtyBal := PMPItemRec.Inventory;
                SLRec.Reset();
                SLRec.SetRange(Type, SLRec.Type::Item);
                SLRec.SetRange("No.", SLRecLoop."No.");
                SLRec.SetFilter(Quantity, '<>0');
                SLRec.CalcSums(SLRec."Quantity (Base)");
                WellQtyBal := SLRec."Quantity (Base)";


                PMPItemUOM.reset;
                PMPItemUOM.ChangeCompany(GetPMPCompanyName());
                PMPItemUOM.SetRange("Item No.", SLRecLoop."No.");
                PMPItemUOM.SetRange(Code, SLRecLoop."Unit of Measure Code");
                if PMPItemUOM.FindFirst() then begin
                    WellQtyBal := Round(WellQtyBal * PMPItemUOM."Qty. per Unit of Measure", 1, '>');
                end;

                if (QtyBal < WellQtyBal) then begin     //if PMP stock is 10 > 6                
                    exit(false);          //Return the difference and create transfer order for this item line.
                end;
            until SLRecLoop.next = 0;



    end;

    //DX    18 Aug 2021
    procedure UpdateInvoicedStatus(DoNo: code[20])
    var
        myInt: Integer;
        SHRec: Record "Sales Shipment Header";
    begin
        SHRec.reset;
        SHRec.ChangeCompany(GetWellawayCompany());
        SHRec.SetRange("No.", DoNo);
        if SHRec.FindFirst() then begin
            SHRec."Order Invoiced in PMP" := false;
            SHRec.Modify(FALSE);
        end;
    end;


    local procedure CreateDimensions4(DimensionCode: Code[20]; DimensionSetValue: Code[20]; DimensionSetID: Integer): Integer
    var
        DimSetEntry1: Record "Dimension Set Entry";
        recDimSet: Record "Dimension Set Entry" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        DM: Codeunit DimensionManagement;
        dimSetID: Integer;
        dimSetIDn: Integer;
        TryV: Integer;
    begin
        dimSetID := 0;
        recDimSet.RESET();
        IF recDimSet.FINDSET() THEN
            recDimSet.DELETEALL();
        recDimSet.RESET();
        recDimSet.INIT();
        recDimSet.VALIDATE(recDimSet."Dimension Code", DimensionCode);
        recDimSet.VALIDATE(recDimSet."Dimension Value Code", DimensionSetValue);
        recDimSet.INSERT();
        if DimensionSetID = 0 then begin
            dimSetIDn := 0;
            dimSetIDn := DM.GetDimensionSetID(recDimSet);
        end
        else
            dimSetIDn := DimensionSetID;
        DimSetEntry1.RESET();
        // DimSetEntry1.SETFILTER(DimSetEntry1."Dimension Set ID", '%1', dimSetIDn);
        IF DimSetEntry1.Get(dimSetIDn, recDimSet."Dimension Code") THEN
            TryV := 1
        ELSE
            IF recDimSet.FINDFIRST() THEN
                REPEAT
                    DimSetEntry.RESET();
                    DimSetEntry.INIT();
                    DimSetEntry.VALIDATE(DimSetEntry."Dimension Set ID", dimSetIDn);
                    DimSetEntry.VALIDATE(DimSetEntry."Dimension Code", recDimSet."Dimension Code");
                    DimSetEntry.VALIDATE(DimSetEntry."Dimension Value Code", recDimSet."Dimension Value Code");
                    DimSetEntry.INSERT();
                UNTIL recDimSet.NEXT() = 0;
        exit(dimSetIDn)
    end;

    procedure GenConsolidatedInv(CustCode: code[20])
    var
        LineNo: Integer;
        SLRec: Record "Sales Shipment Line";
        WellSORec: Record "Sales Header";
        PMPSLRec: Record "Sales Line";
        CurrDocNo: code[20];
        PMPSHRec: Record "Sales Header";
        WellSHRec: Record "Sales Shipment Header";
        SSSetup: Record "Sales & Receivables Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        DocNo: Code[20];
        DimSetID: Integer;
        ItemRec: Record Item;

    begin
        LineNo := 10000;
        //DX        18 Aug 2021     Create sales invoice headers by customer codes
        //DX        18 Aug 2021     Create consolidated invoices by sales shipment header instead of unposted sales orders
        //DX        23 Sept 2021
        SSSetup.RESET;
        SSSetup.GET;
        SSSetup.TESTFIELD("Def. Wellaway Inv. No. Series");
        // NoSeriesMgt.InitSeries(SSSetup."Def. Wellaway Inv. No. Series", SSSetup."Def. Wellaway Inv. No. Series", WORKDATE(), DocNo, SSSetup."Def. Wellaway Inv. No. Series");
        if NoSeries.AreRelated(SSSetup."Def. Wellaway Inv. No. Series", SSSetup."Def. Wellaway Inv. No. Series") then;
        DocNo := NoSeries.GetNextNo(SSSetup."Def. Wellaway Inv. No. Series", WorkDate());
        //DX        23 Sept 2021
        PMPSHRec.reset;
        PMPSHRec.init;
        PMPSHRec.validate("Document Type", PMPSHRec."Document Type"::Invoice);
        PMPSHRec.Validate("No.", DocNo);
        PMPSHRec.Validate("Posting No.", DocNo);
        PMPSHRec.Validate("Sell-to Customer No.", CustCode);
        // PMPSHRec.Validate("Dimension Set ID", CreateDimensions4('DEPARTMENT', 'WELLAWAY', PMPSHRec."Dimension Set ID")); // YF 07 Jul 2022
        PMPSHRec.Validate("Location Code", GetWellLocCode);
        PMPSHRec.Insert(true);

        // YF 07 Jul 2022
        PMPSHRec.Validate("Shortcut Dimension 2 Code", 'WELLAWAY');
        PMPSHRec.Modify();
        // YF 07 Jul 2022

        //DX        23 Sept 2021

        WellSHRec.reset;
        WellSHRec.ChangeCompany(GetWellawayCompany());
        WellSHRec.SetCurrentKey("Order Invoiced in PMP", "Sell-to Customer No.");
        WellSHRec.SetRange("Order Invoiced in PMP", false);
        WellSHRec.SetRange("Sell-to Customer No.", CustCode);
        if WellSHRec.FindSet() then
            repeat
                SLRec.reset;
                SLRec.ChangeCompany(GetWellawayCompany());      //Get all the wellaway transactions                
                SLRec.SetCurrentKey("Document No.", Type, Correction, Quantity);
                SLRec.SetRange("Document No.", WellSHRec."No.");
                SLRec.SetRange(Type, SLRec.Type::Item);
                SLRec.SetRange(Correction, false);       //RL    03 Mar 2022 - filter undo shipment lines
                SLRec.SetFilter(Quantity, '<>0');    //RL    05 May 2022 - filter undelivered lines.
                if SLRec.FindSet() then
                    repeat
                        if LineNo = 10000 then begin
                            //Insert DO Advice No.
                            PMPSLRec.reset;
                            PMPSLRec.init;
                            PMPSLRec.Validate("Document Type", PMPSLRec."Document Type"::Invoice);
                            PMPSLRec.Validate("Document No.", PMPSHRec."No.");
                            PMPSLRec.Validate("Line No.", LineNo);
                            PMPSLRec.Validate(Type, SLRec.Type::" ");
                            PMPSLRec.validate("Location Code", GetWellLocCode());
                            PMPSLRec.Validate(Description, CopyStr(StrSubstNo('%1 %2 %3 %4', 'SO. ', WellSHRec."Order No.", 'RX.', WellSHRec."External Document No."), 1, 100));
                            PMPSLRec.insert(TRUE);
                            // Insert detail line
                            LineNo += 10000;
                            PMPSLRec.reset;
                            PMPSLRec.init;
                            PMPSLRec.Validate("Document Type", PMPSLRec."Document Type"::Invoice);
                            PMPSLRec.Validate("Document No.", PMPSHRec."No.");
                            PMPSLRec.Validate("Line No.", LineNo);
                            PMPSLRec.Validate(Type, SLRec.Type);
                            PMPSLRec.Validate("No.", SLRec."No.");
                            PMPSLRec.Validate(Description, SLRec.Description);
                            PMPSLRec.validate("Location Code", GetWellLocCode());
                            PMPSLRec.Validate("Order Qty", SLRec."Order Qty");
                            PMPSLRec.Validate("Selling Price", SLRec."Selling Price");
                            PMPSLRec.Validate("FOC Qty", SLRec."FOC Qty");
                            PMPSLRec.validate(Quantity, SLRec.Quantity);
                            pmpslrec.Validate("Unit of Measure Code", SLRec."Unit of Measure Code");
                            PMPSLRec.Validate("Unit Price", SLRec."Unit Price");
                            PMPSLRec.Validate("Gen. Prod. Posting Group", SLRec."Gen. Prod. Posting Group");
                            PMPSLRec.Validate("Line Discount %", SLRec."Line Discount %"); //RL 02 Apr 2024
                            PMPSLRec.insert(TRUE);
                            CurrDocNo := SLRec."Document No.";
                            //RL    06 Apr 2022 - Start
                            if SLRec.Quantity <> 0 then begin
                                ItemRec.Reset;
                                ItemRec.SetCurrentKey("No.", "Item Tracking Code");
                                ItemRec.SetLoadFields("No.", "Item Tracking Code");
                                ItemRec.SetRange("No.", SLRec."No.");
                                ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
                                if not (ItemRec.IsEmpty()) then
                                    CreateSOReservationEntry(SLRec, PMPSLRec);
                            end;
                            //RL    06 Apr 2022 - End
                        end else begin

                            if CurrDocNo = SLRec."Document No." then begin
                                PMPSLRec.reset;
                                PMPSLRec.init;
                                PMPSLRec.Validate("Document Type", PMPSLRec."Document Type"::Invoice);
                                PMPSLRec.Validate("Document No.", PMPSHRec."No.");
                                PMPSLRec.Validate("Line No.", LineNo);
                                PMPSLRec.Validate(Type, SLRec.Type);
                                PMPSLRec.Validate("No.", SLRec."No.");
                                PMPSLRec.Validate(Description, SLRec.Description);
                                PMPSLRec.validate("Location Code", GetWellLocCode());
                                PMPSLRec.Validate("Order Qty", SLRec."Order Qty");
                                PMPSLRec.Validate("FOC Qty", SLRec."FOC Qty");
                                PMPSLRec.Validate("Selling Price", SLRec."Selling Price");
                                PMPSLRec.validate(Quantity, SLRec.Quantity);
                                pmpslrec.Validate("Unit of Measure Code", SLRec."Unit of Measure Code");
                                PMPSLRec.Validate("Unit Price", SLRec."Unit Price");
                                PMPSLRec.Validate("Gen. Prod. Posting Group", SLRec."Gen. Prod. Posting Group");
                                PMPSLRec.Validate("Line Discount %", SLRec."Line Discount %"); //RL 02 Apr 2024
                                PMPSLRec.insert(TRUE);
                                if SLRec.Quantity <> 0 then begin

                                    ItemRec.Reset;
                                    ItemRec.SetCurrentKey("No.", "Item Tracking Code");
                                    ItemRec.SetLoadFields("No.", "Item Tracking Code");
                                    ItemRec.SetRange("No.", SLRec."No.");
                                    ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
                                    if not (ItemRec.IsEmpty()) then
                                        CreateSOReservationEntry(SLRec, PMPSLRec);
                                end;
                            end else begin
                                //Insert DO Advice No.

                                PMPSLRec.reset;
                                PMPSLRec.init;
                                PMPSLRec.Validate("Document Type", PMPSLRec."Document Type"::Invoice);
                                PMPSLRec.Validate("Document No.", PMPSHRec."No.");
                                PMPSLRec.Validate("Line No.", LineNo);
                                PMPSLRec.Validate(Type, SLRec.Type::" ");
                                PMPSLRec.validate("Location Code", GetWellLocCode());
                                //PMPSLRec.Validate(Description, StrSubstNo('%1 %2', 'Sales Order', WellSHRec."Order No."));
                                PMPSLRec.Validate(Description, CopyStr(StrSubstNo('%1 %2 %3 %4', 'SO. ', WellSHRec."Order No.", 'PO.', WellSHRec."External Document No."), 1, 100));
                                PMPSLRec.insert(TRUE);
                                // Insert detail line
                                LineNo += 10000;
                                PMPSLRec.reset;
                                PMPSLRec.init;
                                PMPSLRec.Validate("Document Type", PMPSLRec."Document Type"::Invoice);
                                PMPSLRec.Validate("Document No.", PMPSHRec."No.");
                                PMPSLRec.Validate("Line No.", LineNo);
                                PMPSLRec.Validate(Type, SLRec.Type);
                                PMPSLRec.Validate("No.", SLRec."No.");
                                PMPSLRec.Validate(Description, SLRec.Description);
                                PMPSLRec.validate("Location Code", GetWellLocCode());
                                PMPSLRec.Validate("Order Qty", SLRec."Order Qty");
                                PMPSLRec.Validate("FOC Qty", SLRec."FOC Qty");
                                PMPSLRec.Validate("Selling Price", SLRec."Selling Price");
                                PMPSLRec.validate(Quantity, SLRec.Quantity);
                                pmpslrec.Validate("Unit of Measure Code", SLRec."Unit of Measure Code");
                                PMPSLRec.Validate("Unit Price", SLRec."Unit Price");
                                PMPSLRec.Validate("Gen. Prod. Posting Group", SLRec."Gen. Prod. Posting Group");
                                PMPSLRec.Validate("Line Discount %", SLRec."Line Discount %"); //RL 02 Apr 2024
                                PMPSLRec.insert(TRUE);
                                CurrDocNo := SLRec."Document No.";
                                if SLRec.Quantity <> 0 then begin
                                    ItemRec.Reset;
                                    ItemRec.SetCurrentKey("No.", "Item Tracking Code");
                                    ItemRec.SetLoadFields("No.", "Item Tracking Code");
                                    ItemRec.SetRange("No.", SLRec."No.");
                                    ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
                                    if not (ItemRec.IsEmpty()) then
                                        CreateSOReservationEntry(SLRec, PMPSLRec);
                                end;
                            end;
                        end;
                        LineNo += 10000;
                    until SLRec.next = 0;

                WellSHRec.Validate("Order Invoiced in PMP", true);      //Updated sales shipment header to invoiced
                WellSHRec.Modify(TRUE);
                WellSORec.reset;
                WellSORec.ChangeCompany(GetWellawayCompany());
                WellSORec.SetRange("No.", WellSHRec."Order No.");
                WellSORec.CalcFields("Completely Shipped");
                if WellSORec.FindFirst() then begin     //If completed shipped then tagged as invoiced already as SO level
                    if WellSORec."Completely Shipped" = true then begin
                        WellSORec."Order Invoiced in PMP" := true;
                        WellSORec.Modify(FALSE);
                    end;
                end;
            until WellSHRec.next = 0;
        //Message('Sales Invoice Generated.');
    end;

    //DX        13 Sept 2021   

    local procedure CreateSOReservationEntry(SORec: Record "Sales Shipment Line"; SLRec: Record "Sales Line")
    var
        myInt: Integer;
        ReservEntry: Record "Reservation Entry";
        ReservEntryNo: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
        SHRec: Record "Sales Header";
    begin
        ILERec.reset;
        ILERec.ChangeCompany(GetWellawayCompany());
        ILERec.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
        ILERec.SetLoadFields("Document Type", "Document No.", "Document Line No.", "Lot No.", Quantity, "Qty. per Unit of Measure");
        ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Shipment");
        ILERec.SetRange("Document No.", SORec."Document No.");
        ILERec.SetRange("Document Line No.", SORec."Line No.");
        if ILERec.FindSet() then begin //RL    06 Apr 2022 - Add loop to get all tracking lines instead of only first
            repeat
                CLEAR(ReservEntry);
                ReservEntryNo.RESET;
                ReservEntry.INIT;
                IF ReservEntryNo.FINDLAST THEN
                    ReservEntry."Entry No." := ReservEntryNo."Entry No." + 1
                ELSE
                    ReservEntry."Entry No." := 1;

                ReservEntry.VALIDATE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
                ReservEntry.VALIDATE("Item No.", SLRec."No.");
                ReservEntry.VALIDATE("Location Code", GetWellLocCode());
                ReservEntry.VALIDATE("Source Type", 37);
                // ReservEntry.VALIDATE("Source Subtype", 1);
                ReservEntry.VALIDATE("Source Subtype", 2);
                ReservEntry.VALIDATE("Source ID", SLRec."Document No.");
                ReservEntry.VALIDATE("Source Ref. No.", SLRec."Line No.");
                ReservEntry.VALIDATE("Item Tracking", ReservEntry."Item Tracking"::"Lot No.");
                ReservEntry.VALIDATE("Lot No.", ILERec."Lot No.");
                ReservEntry.VALIDATE("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                ReservEntry.VALIDATE(Quantity, ILERec.Quantity);
                ReservEntry.VALIDATE("Quantity (Base)", ILERec.Quantity);
                SHRec.RESET;
                SHRec.SETRANGE("No.", SLRec."Document No.");
                SHRec.SetRange("Document Type", SHRec."Document Type"::order);
                IF SHRec.FINDFIRST THEN BEGIN
                    ReservEntry.VALIDATE("Shipment Date", SHRec."Posting Date");
                END;
                ReservEntry.VALIDATE("Creation Date", TODAY);
                ReservEntry.VALIDATE("Created By", USERID);
                ReservEntry.VALIDATE("Qty. to Handle (Base)", ILERec.Quantity);
                ReservEntry.VALIDATE("Qty. to Invoice (Base)", ILERec.Quantity);
                ReservEntry.INSERT(TRUE);
            until ILERec.Next() = 0; //RL    06 Apr 2022 
        end;
    end;
    //DX        13 Sept 2021
    //DX        11 JUly 2021
    procedure GetWellStockBalance(SLRec: Record "Sales Line"): Decimal
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        ItemUOM: Record "Item Unit of Measure";
    begin
        if IsWellawayCompany() then begin
            ILERec.reset;
            ILERec.ChangeCompany(GetWellawayCompany());
            ILERec.SetRange("Item No.", SLRec."No.");
            ILERec.SetFilter("Location Code", GetWellLocCode());
            ILERec.CalcSums("Remaining Quantity");
            //DX        16 Aug 2021
            ItemUOM.reset;
            ItemUOM.SetRange("Item No.", SLRec."No.");
            ItemUOM.SetRange(Code, SLRec."Unit of Measure Code");
            if ItemUOM.FindFirst() then begin
                if ItemUOM."Qty. per Unit of Measure" <> 0 then
                    exit(ILERec."Remaining Quantity" / ItemUOM."Qty. per Unit of Measure")
            end;
            //DX        16 Aug 2021
            exit(ILERec."Remaining Quantity");
        end;
    end;
    //DX        11 JUly 2021

    //DX        25 July 2021
    procedure CreateTransferJournal(ItemNo: Code[20]; QtyBase: Decimal)
    var
        myInt: Integer;
        IJRec: Record "Item Journal Line";
        SSSetup: Record "Sales & Receivables Setup";
        ItemRec: Record item;
        CompInfo: Record "Company Information";
    begin
        ItemRec.reset;
        ItemRec.Get(ItemNo);
        if ItemRec.Type = ItemRec.Type::Inventory then begin
            CompInfo.reset;
            CompInfo.get;
            SSSetup.reset;
            SSSetup.get;
            SSSetup.TestField("Def Item. Journal Batch");

            IJRec.reset;
            IJRec.SetRange("Journal Template Name", 'ITEM');
            IJRec.SetRange("Journal Batch Name", SSSetup."Def Item. Journal Batch");
            if IJRec.FindLast() then
                myInt := IJRec."Line No." + 10000
            else
                myInt := 10000;

            IJRec.reset;
            IJRec.Init();
            IJRec.Validate("Journal Template Name", 'ITEM');
            IJRec.Validate("Journal Batch Name", SSSetup."Def Item. Journal Batch");
            IJRec.validate("Document No.", 'IJ00001');
            IJRec.Validate("Line No.", myInt);
            IJRec.Validate("Entry Type", IJRec."Entry Type"::"Positive Adjmt.");
            IJRec.Validate("Posting Date", Today);
            IJRec.Validate("Item No.", ItemNo);
            IJRec.Validate("Location Code", CompInfo."Location Code");
            IJRec.validate(Quantity, QtyBase);
            IJRec.Validate("Unit Cost", 0);
            IJRec.Insert(TRUE);
        end;

    end;

    procedure UpdateIJDocNoWithTORec(TONo: Code[20])
    var
        myInt: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        IJRec: record "Item Journal Line";
    begin
        SSSetup.reset;
        SSSetup.get;
        SSSetup.TestField("Def Item. Journal Batch");
        IJRec.reset;
        IJRec.SetRange("Journal Template Name", 'ITEM');
        IJRec.SetRange("Journal Batch Name", SSSetup."Def Item. Journal Batch");
        IJRec.SetRange("Document No.", 'IJ00001');
        IJRec.ModifyAll("Document No.", TONo, true);
    end;


    //DX        25 July 2021


    //DX        08 Aug 2021
    procedure GetFirstExprDate(IJRec: Record "Item Journal Line"): Date
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
    begin
        //DX        18 Aug 2021
        // ILERec.reset;
        // ILERec.SetCurrentKey("Expiration Date");
        // ILERec.SetAscending(ILERec."Expiration Date", FALSE);
        // ILERec.SetRange("Item No.", ItemNo);
        // ILERec.SetFilter("Remaining Quantity", '<>0');
        // if ILERec.FindFirst() then
        //     exit(ILERec."Expiration Date")
        // else
        //     exit(0D);
        //DX        18 Aug 2021
        ReservEntry.reset;
        ReservEntry.SetRange("Item No.", IJRec."Item No.");
        ReservEntry.SetRange("Source Batch Name", IJRec."Journal Batch Name");
        ReservEntry.SetRange("Source Ref. No.", IJRec."Line No.");
        ReservEntry.SetRange("Source Type", 83);
        ReservEntry.SetRange("Source Subtype", 2);
        if ReservEntry.FindFirst() then
            exit(ReservEntry."Expiration Date")
        else
            exit(0D);
    end;

    procedure GetFirstBatch(IJRec: Record "Item Journal Line"): Code[50]
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
    begin
        //DX        18 Aug 2021
        // ILERec.reset;
        // ILERec.SetCurrentKey("Expiration Date");
        // ILERec.SetAscending(ILERec."Expiration Date", FALSE);
        // ILERec.SetRange("Item No.", ItemNo);
        // ILERec.SetFilter("Remaining Quantity", '<>0');
        // if ILERec.FindFirst() then
        //     exit(ILERec."Lot No.")
        // else
        //     exit('');

        //   ResEntry."Entry No." := EntryNo;
        //                     ResEntry."Item No." := ILERec."Item No.";
        //                     ResEntry."Location Code" := CompInfo."Location Code";
        //                     ResEntry."Quantity (Base)" := ILERec.Quantity;
        //                     ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
        //                     ResEntry."Creation Date" := today;
        //                     ResEntry."Source Type" := 83;
        //                     ResEntry."Source Subtype" := 2;
        //                     ResEntry."Source ID" := 'ITEM';
        //                     ResEntry."Source Batch Name" := SSSetup."Def Item. Journal Batch";
        //                     ResEntry."Source Ref. No." := GetSourceLineNo(ILERec."Item No.", TransferReceiptHeader."Transfer Order No.");
        //                     ResEntry."Expected Receipt Date" := Today;
        //                     ResEntry."Created By" := UserId;
        //                     ResEntry.Positive := true;
        //                     ResEntry."Qty. per Unit of Measure" := 1;
        //                     ResEntry.Quantity := ILERec.Quantity;
        //                     ResEntry."Expiration Date" := ILERec."Expiration Date";
        //                     ResEntry."Qty. to Handle (Base)" := ILERec.Quantity;
        //                     ResEntry."Qty. to Invoice (Base)" := ILERec.Quantity;
        //                     ResEntry."Lot No." := ILERec."Lot No.";
        //                     ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
        //ResEntry.Insert(FALSE);

        ReservEntry.reset;
        ReservEntry.SetRange("Item No.", IJRec."Item No.");
        ReservEntry.SetRange("Source Batch Name", IJRec."Journal Batch Name");
        ReservEntry.SetRange("Source Ref. No.", IJRec."Line No.");
        ReservEntry.SetRange("Source Type", 83);
        ReservEntry.SetRange("Source Subtype", 2);
        if ReservEntry.FindFirst() then
            exit(ReservEntry."Lot No.")
        else
            exit('');


        //DX        18 Aug 2021
    end;

    procedure GetTotalLooseQty(ItemNo: Code[20]): Decimal
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
        ItemRec: Record item;
        ItemUom: Record "Item Unit of Measure";
        QtyBal: Decimal;
    begin
        if ItemNo <> '' then begin
            ItemRec.reset;
            ItemRec.get(ItemNo);
            ItemRec.CalcFields(Inventory);
            QtyBal := ItemRec.Inventory;

            ItemUom.reset;
            ItemUom.SetRange("Item No.", ItemRec."No.");
            ItemUom.SetFilter(Code, '<>%1', ItemRec."Base Unit of Measure");
            if ItemUom.FindFirst() then begin
                if ItemUom."Qty. per Unit of Measure" <> 0 then begin
                    exit(round(QtyBal / ItemUom."Qty. per Unit of Measure", 1, '<'));
                end;
            end;
        end;

    end;
    //DX        08 Aug 2021

    procedure ImportWellawayPOHeader()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        CSVBuffer: Record "CSV Buffer" temporary;
        LinesMod: integer;
        IncomingPOHeader: Record "Incoming Wellaway PO Header";
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
                        IncomingPOHeader."Purchase Order ID" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(1));
                        IncomingPOHeader."Transaction Date" := GetCSVDateValue(CSVBuffer.GetValueOfLineAt(2), WorkDate());
                        IncomingPOHeader."Physical PO ID" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(3));
                        IncomingPOHeader."Customer Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(4));
                        IncomingPOHeader."Customer Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(5));
                        IncomingPOHeader."Login ID" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(6));
                        IncomingPOHeader."Order by" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(7));
                        IncomingPOHeader."Currency" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(8));
                        IncomingPOHeader."Terms of Payment" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(9));
                        IncomingPOHeader."Contact Person" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(10));
                        IncomingPOHeader."Street Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(11));
                        IncomingPOHeader."Country/Region" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(12));
                        IncomingPOHeader."Zip Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(13));
                        IncomingPOHeader.Email := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(14));
                        IncomingPOHeader.Telephone := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(15));
                        IncomingPOHeader.Fax := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(16));
                        IncomingPOHeader."Online Discount Amount" := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(17), 0);
                        IncomingPOHeader."Online Discount Percent" := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(18), 0);
                        IncomingPOHeader."Remarks 1" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(19));
                        IncomingPOHeader."Order Date" := GetCSVDateValue(CSVBuffer.GetValueOfLineAt(20), 0D);
                        IncomingPOHeader."Patient Date of Birth" := GetCSVDateValue(CSVBuffer.GetValueOfLineAt(21), 0D);

                        if UpperCase(GetCSVTextValue(CSVBuffer.GetValueOfLineAt(22))) = UpperCase('Male') then
                            IncomingPOHeader."Patient Gender" := IncomingPOHeader."Patient Gender"::Male
                        else
                            IncomingPOHeader."Patient Gender" := IncomingPOHeader."Patient Gender"::Female;

                        IncomingPOHeader."Patient NRIC/FIN/Passport No." := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(23));
                        IncomingPOHeader."Drug Allergies" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(24));
                        IncomingPOHeader."Clinic ID" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(25));
                        IncomingPOHeader."Clinic Full Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(26));
                        IncomingPOHeader."Clinic Branch" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(27));
                        IncomingPOHeader."Clinic Address Line 1" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(28));
                        IncomingPOHeader."Clinic Address Line 2" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(29));
                        IncomingPOHeader."Clinic Postal Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(30));
                        IncomingPOHeader."Clinic Country" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(31));
                        IncomingPOHeader."Doctor Full Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(32));
                        IncomingPOHeader."Doctor Mobile Country Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(33));
                        IncomingPOHeader."Doctor Mobile No." := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(34));
                        IncomingPOHeader."Remarks 2" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(35));

                        if not IncomingPOHeader.Insert(true) then IncomingPOHeader.Modify(true);

                        if CSVBuffer."Field No." = 1 then
                            LinesMod += 1;
                    end;
                end;
            until CSVBuffer.Next() = 0;

        if LinesMod <> 0 then
            Message('%1 headers imported.', LinesMod);

    end;

    procedure ImportWellawayPOLine()
    var
        ImportFileName: Text;
        Buffer: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        CSVBuffer: Record "CSV Buffer" temporary;
        LinesMod: integer;
        IncomingPOLine: Record "Incoming Wellaway PO Line";
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
                    IncomingPOLine."Purchase Order ID" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(1));
                    IncomingPOLine."Purchase Line No" := CSVBuffer."Line No." * 10000;
                    IncomingPOLine."Product Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(2));
                    IncomingPOLine."Product Name" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(3));
                    IncomingPOLine."Quantity Ordered" := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(4), 0);
                    IncomingPOLine."Bonus Quantity" := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(5), 0);
                    IncomingPOLine."Unit Price" := GetCSVDecimalValue(CSVBuffer.GetValueOfLineAt(6), 0);
                    IncomingPOLine."UOM Code" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(7));
                    IncomingPOLine."Expiry Date" := GetCSVDateValue(CSVBuffer.GetValueOfLineAt(8), 0D);
                    IncomingPOLine."Instruction of Use" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(9));
                    IncomingPOLine."Precautions" := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(10));
                    IncomingPOLine.Remarks := GetCSVTextValue(CSVBuffer.GetValueOfLineAt(11));

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
        IncomingPOHeader: Record "Incoming Wellaway PO Header";
    begin
        IncomingPOHeader.reset;
        IncomingPOHeader.SetRange("Purchase Order ID", DocNo);
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

    procedure CreateDocuments(DocNo: Code[20]) DocCreated: Integer;
    var
        StagingPOHeader: Record "Incoming Wellaway PO Header";
        StagingPOLine: Record "Incoming Wellaway PO Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CanCreateSO: Boolean;
        LineNo: Integer;
        EnhanceCU: Codeunit "PMP-Enhancements";
        ItemRec: Record Item;
        TradeCU: Codeunit "Trade Agreement CU";
        PatientRec: Record Patient;
        NewPatientRec: Record Patient;
        PatientNo: Code[20];
        PatientName: Text[250];
        Errormsg: text[250];
    begin
        StagingPOHeader.Reset;
        //DX        25 Sept 2021
        StagingPOHeader.SetRange("Purchase Order ID", DocNo);
        //DX        25 Sept 2021
        StagingPOHeader.SetRange("SO Created", false);
        if StagingPOHeader.FindSet() then
            repeat

                // Handle Patient Record
                //DX        29 Oct 2025     To use PO details directly
                // PatientRec.Reset;
                // PatientRec.SetRange(NRIC, StagingPOHeader."Patient NRIC/FIN/Passport No.");
                // if PatientRec.FindFirst() then begin
                //     PatientNo := PatientRec."No.";
                //     PatientName := PatientRec.Name;
                // end
                // else begin
                //     NewPatientRec.Init();
                //     NewPatientRec.Name := StagingPOHeader."Customer Name";
                //     NewPatientRec."Address 1" := StagingPOHeader."Street Name";
                //     NewPatientRec."Address 2" := StagingPOHeader."Country/Region" + ' ' + StagingPOHeader."Zip Code";
                //     NewPatientRec.NRIC := StagingPOHeader."Patient NRIC/FIN/Passport No.";
                //     NewPatientRec.DOB := StagingPOHeader."Patient Date of Birth";
                //     NewPatientRec."Mobile No." := StagingPOHeader.Telephone;
                //     NewPatientRec."Drug Allergy" := StagingPOHeader."Drug Allergies";
                //     NewPatientRec.Insert(true);

                //     PatientNo := NewPatientRec."No.";
                //     PatientName := NewPatientRec.Name;
                // end;

                CanCreateSO := false;

                // Look for Staging PO Lines
                StagingPOLine.Reset();
                StagingPOLine.SetRange("Purchase Order ID", StagingPOHeader."Purchase Order ID");
                StagingPOLine.SetRange("SO Created", false);
                if StagingPOLine.FindFirst() then
                    CanCreateSO := true;

                CanCreateSO := Not SOCLEDocExist(StagingPOHeader."Purchase Order ID");

                if CanCreateSO then begin

                    // Create Header
                    SalesHeader.Init();
                    SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.Validate("External Document No.", StagingPOHeader."Purchase Order ID");
                    SalesHeader.Validate("Document Date", StagingPOHeader."Transaction Date");
                    SalesHeader.Validate("Order Date", StagingPOHeader."Order Date");
                    SalesHeader.Validate("Sell-to Customer No.", StagingPOHeader."Clinic ID");
                    if StagingPOHeader."Currency" <> 'SGD' then
                        SalesHeader."Currency Code" := StagingPOHeader."Currency";

                    SalesHeader.Validate("Payment Terms Code", StagingPOHeader."Terms of Payment");
                    SalesHeader.Validate("Invoice Discount Amount", StagingPOHeader."Online Discount Amount");

                    SalesHeader."Customer Instructions" := StagingPOHeader."Remarks 1";
                    SalesHeader.Validate("Ship-to Code", '');
                    SalesHeader.Validate("Ship-to Name", StagingPOHeader."Customer Name");
                    SalesHeader."Ship-to Address" := StagingPOHeader."Street Name";
                    SalesHeader."Ship-to Address 2" := '';
                    SalesHeader."Ship-to Post Code" := StagingPOHeader."Zip Code";
                    SalesHeader."Ship-to County" := '';
                    SalesHeader."Ship-to Contact" := StagingPOHeader.Telephone;
                    SalesHeader."Ship-to Country/Region Code" := StagingPOHeader."Country/Region";

                    //DX        29 Oct 2025
                    //SalesHeader."Patient No." := PatientNo;
                    //SalesHeader."Patient Name" := PatientName;
                    SalesHeader."Patient No." := StagingPOHeader."Customer Code";
                    SalesHeader."Patient Name" := StagingPOHeader."Customer Name";
                    //DX        29 Oct 2025

                    // YF 31 Oct 2025
                    SalesHeader.NRIC := StagingPOHeader."Patient NRIC/FIN/Passport No.";
                    SalesHeader.DOB := StagingPOHeader."Patient Date of Birth";
                    SalesHeader."Drug Allergy" := StagingPOHeader."Drug Allergies";
                    // YF 31 Oct 2025

                    SalesHeader."PO Integration Source" := 'WELLAWAY';
                    SalesHeader."PO Integration Source Ref No." := StagingPOHeader."Purchase Order ID";

                    if SalesHeader.Insert(true) then // must be true to trigger auto number
                        begin

                        Commit();

                        // Update Staging PO Header Status
                        StagingPOHeader."Sales Order No." := SalesHeader."No.";
                        StagingPOHeader."SO Created" := true;
                        StagingPOHeader."SO Error" := false;
                        StagingPOHeader."Process Remarks" := '';
                        StagingPOHeader.Modify();

                        DocCreated += 1;

                        LineNo := 10000;

                        if StagingPOLine.FindSet() then
                            repeat
                                // Create Lines
                                SalesLine.Init();
                                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                SalesLine.Validate("Line No.", LineNo);
                                SalesLine.Validate(Type, SalesLine.Type::Item);
                                SalesLine.Validate("No.", StagingPOLine."Product Code");
                                SalesLine.Validate("Order Qty", StagingPOLine."Quantity Ordered");
                                SalesLine.Validate("FOC Qty", StagingPOLine."Bonus Quantity");
                                SalesLine.Validate("Selling Price", StagingPOLine."Unit Price");
                                SalesLine.Validate("Unit of Measure Code", StagingPOLine."UOM Code");
                                SalesLine.Validate("PO Import Price", StagingPOLine."Unit Price");
                                SalesLine.Validate("Unit Price", StagingPOLine."Unit Price");
                                if SalesLine.Insert(true) then begin

                                    // Post Insert Sales Line Customization Logic
                                    // Start PMP sales line customization logic

                                    if (SalesLine.Type = SalesLine.Type::Item) then begin
                                        //EnhanceCU.CustItemIsBlocked(SalesLine."Sell-to Customer No.", SalesLine."No.");
                                        //DX        21 July 2021
                                        //EnhanceCU.LsItemCannotEnter(SalesLine);
                                        //DX        21 July 2021
                                        //DX        08 Aug 2021
                                        ItemRec.Reset();
                                        ItemRec.SetRange("No.", SalesLine."No.");
                                        if itemrec.FindFirst() then begin
                                            SalesLine.Principal := ItemRec.Principal;
                                        end;

                                    end;
                                    //DX        01 July 2021

                                    if (SalesLine.Type = SalesLine.Type::Item) and
                                                (SalesLine."No." <> '') and
                                                (SalesLine."Order Qty" <> 0) then begin
                                        SalesLine.Validate(Quantity, SalesLine."Order Qty" + SalesLine."FOC Qty");
                                        SalesLine.Validate("Qty To Deliver", SalesLine."Order Qty");
                                        SalesLine.Validate("FOC (Qty) To Deliver", SalesLine."FOC Qty");
                                        SalesLine.Validate("Selling Price", SalesLine."PO Import Price");
                                        SalesLine.Validate("Unit Price", SalesLine."PO Import Price");
                                        // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");

                                        /*
                                            if TradeCU.IsValidSalesAgreement_PMPCustomized(SalesLine) then begin
                                                TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(SalesLine);
                                            end else begin
                                                // take from item card price
                                                if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then begin
                                                    if ItemRec.Get(SalesLine."No.") then begin
                                                        SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                                        SalesLine.Validate("FOC Qty", 0);
                                                        SalesLine.Validate("Selling Price", SalesLine."PO Import Price");
                                                        SalesLine.Validate("Unit Price", SalesLine."PO Import Price");
                                                        // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                                                    end;
                                                end;
                                            end;
                                        */
                                        if (SalesLine."Order Qty" = 0) then begin
                                            SalesLine.Validate("Unit Price", 0);
                                            SalesLine.Validate("Selling Price", 0);
                                            SalesLine.Validate("FOC Qty", 0);
                                            // Rec.Modify(TRUE);
                                        end;
                                        //DX        27 Jun 2021
                                        //EnhanceCU.ExpirationLessThan12Mths(SalesLine."No.");
                                        //DX        27 Jun 2021
                                        //TradeCU.RequireMaxQtyApproval(SalesLine);

                                    end else begin
                                        //DX        27 Jun 2021
                                        SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                        //DX        27 Jun 2021
                                    end;

                                    // YF 06 Aug 2021 // Temp Fix for Issue #80
                                    if (SalesLine."Selling Price" = 0) Or (SalesLine."Unit Price" = 0) And (SalesLine."Order Qty" > 0) then
                                        SalesLine.Validate(Quantity, SalesLine."Order Qty");
                                    // YF 06 Aug 2021 // Temp Fix for Issue #80

                                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                                    SalesLine."Qty To Deliver" := SalesLine."Order Qty" - SalesLine."Qty Delivered";
                                    SalesLine."FOC (Qty) To Deliver" := SalesLine."FOC Qty" - SalesLine."FOC Qty Delivered";
                                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                                    // YF 25 Aug 2021 // Use Presc. to populate from import. If blank then use item card version
                                    if ItemRec.Get(SalesLine."No.") then begin
                                        if StrLen(StagingPOLine."Instruction of Use") > 0 then
                                            SalesLine."Presc. Desc" := StagingPOLine."Instruction of Use"
                                        else
                                            SalesLine."Presc. Desc" := ItemRec."Prescription 1";

                                        if StrLen(StagingPOLine."Precautions") > 0 then
                                            SalesLine."Presc. Desc 2" := StagingPOLine."Precautions"
                                        else
                                            SalesLine."Presc. Desc 2" := ItemRec."Prescription 2";
                                    end
                                    else begin
                                        SalesLine."Presc. Desc" := StagingPOLine."Instruction of Use";
                                        SalesLine."Presc. Desc 2" := StagingPOLine."Precautions";
                                    end;
                                    // YF 25 Aug 2021 // Use Presc. to populate from import. If blank then use item card version

                                    SalesLine.Modify();

                                    // End PMP sales line customization logic 

                                    // Update Staging PO Line Status
                                    StagingPOLine."Sales Order No." := SalesHeader."No.";
                                    StagingPOLine."Sales Line No." := LineNo;
                                    StagingPOLine."SO Created" := true;
                                    StagingPOLine."SO Error" := false;
                                    StagingPOLine."Process Remarks" := '';
                                    StagingPOLine.Modify();
                                end
                                else begin
                                    // Update Staging PO Line Status
                                    StagingPOLine."Sales Order No." := SalesHeader."No.";
                                    StagingPOLine."Sales Line No." := LineNo;
                                    StagingPOLine."SO Created" := false;
                                    StagingPOLine."SO Error" := true;
                                    StagingPOLine.Modify();
                                end;

                                LineNo += 10000;

                            until StagingPOLine.Next() = 0;

                    end
                    else begin
                        // Update Staging PO Header Status
                        StagingPOHeader."Sales Order No." := '';
                        StagingPOHeader."SO Created" := false;
                        StagingPOHeader."SO Error" := true;
                        StagingPOHeader.Modify();
                    end;

                end;

            until StagingPOHeader.Next = 0;
    end;

    procedure SOCLEDocExist(DocNo: Code[20]) DoesExist: Boolean
    var
        SHRec: Record "Sales Header";
        CLERec: Record "Cust. Ledger Entry";
    begin
        SHRec.reset;
        SHRec.SetRange("External Document No.", DocNo);
        if SHRec.FindFirst() then begin
            //Message('PO ' + DocNo + ' exists in Sales Order entry.');
            exit(true);
        end;


        CLERec.reset;
        CLERec.SetRange("External Document No.", DocNo);
        if CLERec.FindFirst() then begin
            //Message('PO ' + DocNo + ' exists in Cust Ledger Entry.');
            exit(true);
        end;

        exit(FALSE);
    end;

    [TryFunction]
    procedure TrySOCLEDocExist(DocNo: Code[20])
    var
        SHRec: Record "Sales Header";
        CLERec: Record "Cust. Ledger Entry";
    begin
        SHRec.reset;
        SHRec.SetRange("External Document No.", DocNo);
        if SHRec.FindFirst() then begin
            Error('PO ' + DocNo + ' exists in Sales Order entry.');
        end;

        CLERec.reset;
        CLERec.SetRange("External Document No.", DocNo);
        if CLERec.FindFirst() then begin
            Error('PO ' + DocNo + ' exists in Cust Ledger Entry.');
        end;
    end;

    procedure CreateLoosePrice(ItemNo: Code[20]; UOM: Code[20]; QtyConv: Decimal)
    var
        myInt: Integer;
        PharmaSales: Record "Pharma Sales Price";
        LoosePharma: Record "Pharma Sales Price";
        PMPSales: Record "Pharma Sales Price";
        LoosePharmaCheck: Record "Pharma Sales Price";
        ItemRec: Record item;
        UnitPrice: Decimal;
    begin
        if ItemNo <> '' then begin
            ItemRec.reset;
            ItemRec.get(ItemNo);
        end;
        PharmaSales.reset;
        PharmaSales.ChangeCompany(GetWellawayCompany());
        PharmaSales.SetRange("Item No.", ItemNo);
        PharmaSales.SetRange("Unit Of Measure Code", ItemRec."Base Unit of Measure");
        if PharmaSales.FindSet() then
            repeat
                LoosePharmaCheck.reset;
                LoosePharmaCheck.SetRange("Item No.", ItemNo);
                LoosePharmacheck.SetRange("Unit Of Measure Code", UOM);
                if not (LoosePharmaCheck.FindFirst()) then begin
                    LoosePharma.reset;
                    LoosePharma.Init();
                    LoosePharma.TransferFields(PharmaSales);
                    LoosePharma.Validate("Unit Of Measure Code", UOM);
                    LoosePharma.Validate("Minimum Quantity", 1);        //DX        Price $10 , 1 piece = $1
                    if PharmaSales."Minimum Quantity" + PharmaSales."FOC Qty" <> 0 then
                        //  1 box = $10 , $10 /1 = $10 average cost.
                        UnitPrice := (PharmaSales."Minimum Quantity" * PharmaSales."Unit Price") / (PharmaSales."Minimum Quantity" + PharmaSales."FOC Qty");    //Get average cost first.
                    if QtyConv <> 0 then
                        UnitPrice := UnitPrice * QtyConv;      //$10 / 0.01 conversion
                    LoosePharma.Validate("Unit Price", UnitPrice);
                    LoosePharma.Insert(true);

                    PMPSales.reset;
                    PMPSales.ChangeCompany(GetPMPCompanyName());
                    PMPSales.Init();
                    PMPSales.TransferFields(LoosePharma);
                    PMPSales.Insert(TRUE);
                end else begin
                    if PharmaSales."Minimum Quantity" + PharmaSales."FOC Qty" <> 0 then
                        //  1 box = $10 , $10 /1 = $10 average cost.
                        UnitPrice := (PharmaSales."Minimum Quantity" * PharmaSales."Unit Price") / (PharmaSales."Minimum Quantity" + PharmaSales."FOC Qty");    //Get average cost first.
                    if QtyConv <> 0 then
                        UnitPrice := UnitPrice * QtyConv;      //$10 / 0.01 conversion
                    LoosePharmaCheck.Validate("Unit Price", UnitPrice);
                    LoosePharmaCheck.Modify(TRUE);

                    PMPSales.reset;
                    PMPSales.ChangeCompany(GetPMPCompanyName());
                    PMPSales.SetRange("Item No.", ItemNo);
                    PMPSales.SetRange("Unit Of Measure Code", UOM);
                    if PMPSales.FindFirst() then begin
                        PMPSales."Unit Price" := UnitPrice;
                        PMPSales.Modify(FALSE);
                    end;
                end;

            until PharmaSales.next = 0;
    end;




    procedure ValidatePOInfo(POID: Code[50]): Boolean
    var
        myInt: Integer;
        ItemRec: Record item;
        CustRec: Record customer;
        ItemUOM: Record "Item Unit of Measure";
        StageHeader: Record "Incoming Wellaway PO Header";
        Stageline: Record "Incoming Wellaway PO Line";
    begin

        StageHeader.reset;
        StageHeader.SetRange("Purchase Order ID", POID);
        if StageHeader.FindFirst() then begin
            IF TrySOCLEDocExist(POID) then begin
                if CustCodeIsValid(StageHeader."Clinic ID") then begin
                    Stageline.reset;
                    Stageline.SetRange("Purchase Order ID", POID);
                    Stageline.SetRange("SO Created", false);
                    if Stageline.FindSet() then
                        repeat
                            if NOT (CheckItemDetails(Stageline)) then begin
                                Stageline."Process Remarks" := GetLastErrorText();
                                Stageline."SO Error" := true;
                                Stageline.Modify(FALSE);
                            end;

                        until Stageline.next = 0;

                end else begin
                    StageHeader."Process Remarks" := GetLastErrorText();
                    StageHeader."SO Error" := true;
                    StageHeader.Modify(FALSE);
                    exit(false);
                end;
            end else begin
                StageHeader."Process Remarks" := GetLastErrorText();
                StageHeader."SO Error" := true;
                StageHeader.Modify(FALSE);
                exit(false);
            end;
            if GetLastErrorText() <> '' then
                exit(false)
            else
                exit(true);
        end;

        Commit();
    end;

    [TryFunction]
    local procedure CustCodeIsValid(CustCode: Code[50])
    var
        myInt: Integer;
        ItemRec: Record item;
        CustRec: Record customer;
        ItemUOM: Record "Item Unit of Measure";
    begin
        CustRec.reset;
        CustRec.SetRange("No.", CustCode);
        if not (CustRec.FindFirst()) then
            Error('No such customer record.')
    end;

    [TryFunction]
    procedure CheckItemDetails(POLine: Record "Incoming Wellaway PO Line")
    var
        myInt: Integer;

        ItemUOM: Record "Item Unit of Measure";
        MissingUOM: Code[20];
        ItemRec: Record item;
    begin
        ItemRec.reset;
        ItemRec.SetRange("No.", POLine."Product Code");
        if not (ItemRec.FindFirst()) then
            Error(StrSubstNo('Missing Item Code: %1', POLine."Product Code"));

        ItemUOM.reset;
        ItemUOM.SetRange("Item No.", POLine."Product Code");
        ItemUOM.SetRange(Code, POLine."UOM Code");
        if Not (ItemUOM.FindFirst()) then
            Error(StrSubstNo('Missing UOM For Item : %1 %2', POLine."Product Code", POLine."UOM Code"));
    end;

    procedure GetUsername(GUserID: Guid): Text
    var
        myInt: Integer;
        UserID: Guid;
        UserRec: Record User;
    begin
        UserRec.reset;
        UserRec.SetRange(UserRec."User Security ID", GUserID);
        if UserRec.FindFirst() then
            exit(UserRec."User Name");
    end;
}
