report 56200 IntercoInvoiceGen
{
    ApplicationArea = All;
    Caption = 'Interco Invoice Gen';
    UsageCategory = Administration;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                sssetup: Record "Sales & Receivables Setup";
            begin

                if Choice = Choice::" " then begin
                    Error('Please select choice before executing the process.');
                end;

                clear(TotalAmt);
                Clear(LineNo);
                LineNo := 10000;

                if (StartDate = 0D) or (EndDate = 0D) then begin
                    Error('Please ensure start date and end dates are not empty.');
                end;
                //Generate breakdown of items for a sales invoice in OH first.
                //Check if item and lot exists in the current company OH.

                if Choice = Choice::Invoice then begin
                    if CompanyName = 'OHPL' THEN begin
                        sssetup.reset;
                        sssetup.get;
                        sssetup.TestField("Default PMP Customer Code");
                        //RL    19 June 2023 Disable Lot Check - Start
                        /* 
                        ILERec.reset;
                        ILERec.ChangeCompany('PMP');
                        ILERec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                        ILERec.SetRange("Transferred to OH", false);
                        ILERec.SetFilter("Lot No.", '<>%1', '');
                        if ILERec.FindSet() then
                            repeat
                                if OHCU.isOHItemInPMPEntity(ILERec."Item No.") then
                                    OHCU.CheckItemLotNo(ILERec."Item No.", ILERec."Lot No.");
                            until ILERec.next = 0;
                        */
                        //RL    19 June 2023 Disable Lot Check - End

                        //No issues, then generate sales invoice and copy item lot details.
                        SHRec.reset;
                        SHRec.Validate("Document Type", SHRec."Document Type"::Invoice);
                        SHRec.InitRecord();
                        SHRec.Validate("Sell-to Customer No.", sssetup."Default PMP Customer Code");
                        SHRec.Validate("Location Code", sssetup."Def PMP WH Location");
                        SHRec.Insert(true);
                        ILERec.reset;       //Retrieve all ILE Sales first from PMP ILE
                        ILERec.ChangeCompany('PMP');
                        ILERec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                        ILERec.SetRange("Transferred to OH", false);        //Use Transferred to OH to check that PMP ILE has been transferred to OH ILE Invoice lines
                        ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                        ILERec.SetFilter("Document Type", '%1|%2', ILERec."Document Type"::"Sales Shipment", ILERec."Document Type"::"Sales Invoice");//RL 04102023 added sales invoice
                        ILERec.SetFilter("Invoiced Quantity", '<>0'); //RL 22 June 2023 - add filter to bill only invoiced transactions
                        ILERec.SetFilter("Lot No.", '<>%1', '');

                        if ILERec.FindSet() then
                            repeat
                                ILERec.CalcFields("Sales Amount (Actual)");
                                if OHCU.isOHItemInPMPEntity(ILERec."Item No.") then begin   //Check if that ILE is OH item
                                    SLRec.reset;    //Generate in OH entity.
                                    SLRec.Init();
                                    SLRec.Validate("Document Type", SLRec."Document Type"::Invoice);
                                    SLRec.Validate("Document No.", SHRec."No.");
                                    SLRec.Validate("Line No.", LineNo);
                                    SLRec.Validate(Type, SLRec.Type::Item);
                                    SLRec.validate("No.", ILERec."Item No.");
                                    SLRec.Validate("Order Qty", ABS(ILERec.Quantity));
                                    SLRec.Validate(Quantity, ABS(ILERec.Quantity));

                                    if (ILERec."Sales Amount (Actual)" <> 0) and (ILERec.Quantity <> 0) then
                                        SLRec.Validate("Unit Price", ABS(ILERec."Sales Amount (Actual)" / ILERec.Quantity));
                                    SLRec."Selling Price" := SLRec."Unit Price";
                                    SLRec.Validate("Location Code", sssetup."Def PMP WH Location");
                                    SLRec.Validate("ZP Customer Name", GetPMPShipname(ILERec."Document No.", 1));
                                    SLRec.Validate("ZP SP", GetPMPShipname(ILERec."Document No.", 2));
                                    SLRec.Validate("Location Code", sssetup."Def PMP WH Location");
                                    BinRec.reset;
                                    BinRec.SetRange("Location Code", sssetup."Def PMP WH Location");
                                    if BinRec.FindFirst() then begin
                                        // SLRec.Validate("Bin Code", BinRec.Code);
                                        SLRec."Bin Code" := BinRec.Code;
                                    end;
                                    SLRec.insert(TRUE);
                                    TotalAmt += SLRec.Amount;

                                    ResEntry2.reset;
                                    if ResEntry2.FindLast() then
                                        EntryNo := ResEntry2."Entry No." + 1
                                    else
                                        EntryNo := 1;
                                    ResEntry.reset;
                                    ResEntry.Init();
                                    ResEntry.Validate("Entry No.", EntryNo);
                                    ResEntry.Validate("Source Type", 37);
                                    ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Prospect);
                                    ResEntry.Validate("Source Subtype", 2);
                                    ResEntry.Validate("Source ID", SHRec."No.");
                                    ResEntry.Validate("Source Ref. No.", SLRec."Line No.");
                                    ResEntry.Validate("Item No.", ILERec."Item No.");
                                    ResEntry.Validate("Location Code", sssetup."Def PMP WH Location");
                                    ResEntry.Validate("Shipment Date", today);
                                    ResEntry.Validate("Created By", UserId);
                                    ResEntry.Validate(Quantity, Abs(ILERec.Quantity / ILERec."Qty. per Unit of Measure") * -1);
                                    ResEntry.Validate("Quantity (Base)", Abs(ILERec.Quantity) * -1);
                                    ResEntry.Validate("Qty. to Handle (Base)", Abs(ILERec.Quantity) * -1);
                                    ResEntry.Validate("Qty. to Invoice (Base)", Abs(ILERec.Quantity) * -1);
                                    ResEntry.Validate("Creation Date", today);
                                    ResEntry.Validate("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                                    //ResEntry.Validate(Positive, true);     //DX       05 July 2023
                                    ResEntry.Validate(Positive, false);     //DX        05 July 2023       Change to false, Comparing with default insertion, default is false
                                    ResEntry.Validate("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                                    ResEntry.Validate("Lot No.", ILERec."Lot No.");
                                    ResEntry.Validate("Expiration Date", ILERec."Expiration Date");
                                    ResEntry.insert(true);
                                    //Tag that it's already transferred over so won't repeat.
                                    OHCU.UpdateTransferStatus(ILERec."Entry No.");
                                    LineNo += 10000;
                                end;

                            until ILERec.next = 0;

                        Message('Sales Invoice generated.');
                    end;
                    //Generate Purchase invoice in PMP to issue as a lump sum

                    if Companyname = 'PMP' then begin
                        sssetup.reset;
                        sssetup.get;
                        sssetup.TestField("Default OH Vendor Code");
                        sssetup.TestField("Def PMP Clearing Account");
                        ILERec.reset;
                        ILERec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                        ILERec.SetRange("Invoiced to OH", false);
                        ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                        // ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Shipment");
                        ILERec.SetFilter("Document Type", '%1|%2', ILERec."Document Type"::"Sales Shipment", ILERec."Document Type"::"Sales Invoice");//RL 04102023 added sales invoice
                        ILERec.SetFilter("Lot No.", '<>%1', '');
                        ILERec.SetFilter("Invoiced Quantity", '<>0'); //RL 22 June 2023 - add filter to bill only invoiced transactions
                        if ILERec.FindSet() then
                            repeat
                                if OHCU.isOHItemInPMPEntity(ILERec."Item No.") then begin
                                    ILERec.CalcFields("Sales Amount (Actual)");
                                    totalamt += ILERec."Sales Amount (Actual)";
                                    OHCU.UpdateOHInvoiceStatus(ILERec."Entry No.");
                                end;
                            until ILERec.next = 0;
                        //TotalAmt := 10000;

                        PHRec.reset;
                        PHRec.Validate("Document Type", SHRec."Document Type"::Invoice);
                        PHRec.InitRecord();
                        PHRec.Validate("Buy-from Vendor No.", sssetup."Default OH Vendor Code");
                        PHRec.Insert(true);

                        PLRec.reset;
                        PLRec.init;
                        PLRec.Validate("Document Type", PLRec."Document Type"::Invoice);
                        PLRec.Validate("Document No.", PHRec."No.");
                        PLRec.Validate("Line No.", 10000);
                        PLRec.Validate(Type, PLRec.Type::"G/L Account");
                        PLRec.validate("No.", sssetup."Def PMP Clearing Account");
                        PLRec.Validate(Quantity, 1);
                        PLRec.validate("Direct Unit Cost", TotalAmt);
                        PLRec.Insert(true);


                        PLRec.reset;
                        PLRec.init;
                        PLRec.Validate("Document Type", PLRec."Document Type"::Invoice);
                        PLRec.Validate("Document No.", PHRec."No.");
                        PLRec.Validate("Line No.", 20000);
                        PLRec.Validate(Type, PLRec.Type::" ");
                        PLRec.Validate(Description, StrSubstNo('Clearing from %1 to %2', StartDate, EndDate));
                        PLRec.Insert(true);
                        Message('Invoice generated');

                    end;        //End of invoice process
                end else
                    if Choice = Choice::Return then begin       //Begin of return process
                        if Companyname = 'PMP' then begin
                            sssetup.reset;
                            sssetup.get;
                            sssetup.TestField("Default OH Vendor Code");
                            sssetup.TestField("Def PMP Clearing Account");
                            ILERec.reset;
                            ILERec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                            ILERec.SetRange("Invoiced to OH", false);
                            ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                            // ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Return Receipt");
                            ILERec.SetFilter("Document Type", '%1|%2', ILERec."Document Type"::"Sales Return Receipt", ILERec."Document Type"::"Sales Credit Memo");
                            ILERec.SetFilter("Lot No.", '<>%1', '');
                            ILERec.SetFilter("Invoiced Quantity", '<>0'); //RL 22 June 2023 - add filter to bill only invoiced transactions
                            if ILERec.FindSet() then
                                repeat
                                    if OHCU.isOHItemInPMPEntity(ILERec."Item No.") then begin
                                        ILERec.CalcFields("Sales Amount (Actual)");
                                        totalamt += ILERec."Sales Amount (Actual)";
                                        OHCU.UpdateOHInvoiceStatus(ILERec."Entry No.");
                                    end;
                                until ILERec.next = 0;
                            //TotalAmt := 10000;

                            PHRec.reset;
                            Phrec.Init();
                            PHRec.Validate("Document Type", PHRec."Document Type"::"Credit Memo");
                            PHRec.InitRecord();
                            PHRec.Validate("Buy-from Vendor No.", sssetup."Default OH Vendor Code");
                            PHRec.Insert(true);

                            PLRec.reset;
                            PLRec.init;
                            PLRec.Validate("Document Type", PLRec."Document Type"::"Credit Memo");
                            PLRec.Validate("Document No.", PHRec."No.");
                            PLRec.Validate("Line No.", 10000);
                            PLRec.Validate(Type, PLRec.Type::"G/L Account");
                            PLRec.validate("No.", sssetup."Def PMP Clearing Account");
                            PLRec.Validate(Quantity, 1);
                            PLRec.validate("Direct Unit Cost", ABS(TotalAmt)); //RL24042023 - add ABS
                            PLRec.Insert(true);



                            PLRec.reset;
                            PLRec.init;
                            PLRec.Validate("Document Type", PLRec."Document Type"::"Credit Memo");
                            PLRec.Validate("Document No.", PHRec."No.");
                            PLRec.Validate("Line No.", 20000);
                            PLRec.Validate(Type, PLRec.Type::" ");
                            PLRec.Validate(Description, StrSubstNo('Clearing from %1 to %2', StartDate, EndDate));
                            PLRec.Insert(true);
                            Message('Purchase Credit Memo generated');

                        end;        //End of invoice process

                        //Start of OH PL Return process
                        if CompanyName = 'OHPL' THEN begin
                            sssetup.reset;
                            sssetup.get;
                            sssetup.TestField("Default PMP Customer Code");
                            //DX        05 Jun 2023     Return process no need to check for lot number existence.
                            /*
                            ILERec.reset;
                            ILERec.ChangeCompany('PMP');
                            ILERec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                            ILERec.SetRange("Transferred to OH", false);
                            ILERec.SetFilter("Lot No.", '<>%1', '');
                            if ILERec.FindSet() then
                                repeat
                                    if OHCU.isOHItemInPMPEntity(ILERec."Item No.") then
                                        OHCU.CheckItemLotNo(ILERec."Item No.", ILERec."Lot No.");
                                until ILERec.next = 0;
                                */
                            //DX        05 Jun 2023
                            //No issues, then generate sales invoice and copy item lot details.
                            SHRec.reset;
                            SHRec.Validate("Document Type", SHRec."Document Type"::"Credit Memo");
                            SHRec.InitRecord();
                            SHRec.Validate("Sell-to Customer No.", sssetup."Default PMP Customer Code");
                            SHRec.Validate("Location Code", sssetup."Def PMP WH Location");
                            SHRec.Insert(true);
                            ILERec.reset;       //Retrieve all ILE Sales first from PMP ILE
                            ILERec.ChangeCompany('PMP');
                            ILERec.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                            ILERec.SetRange("Transferred to OH", false);
                            ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                            // ILERec.SetRange("Document Type", ILERec."Document Type"::"Sales Return Receipt");
                            ILERec.SetFilter("Document Type", '%1|%2', ILERec."Document Type"::"Sales Return Receipt", ILERec."Document Type"::"Sales Credit Memo");
                            ILERec.SetFilter("Lot No.", '<>%1', '');
                            ILERec.SetFilter("Invoiced Quantity", '<>0'); //RL 22 June 2023 - add filter to bill only invoiced transactions

                            if ILERec.FindSet() then
                                repeat
                                    ILERec.CalcFields("Sales Amount (Actual)");
                                    if OHCU.isOHItemInPMPEntity(ILERec."Item No.") then begin   //Check if that ILE is OH item
                                        SLRec.reset;    //Generate in OH entity.
                                        SLRec.Init();
                                        SLRec.Validate("Document Type", SLRec."Document Type"::"Credit Memo");
                                        SLRec.Validate("Document No.", SHRec."No.");
                                        SLRec.Validate("Line No.", LineNo);
                                        SLRec.Validate(Type, SLRec.Type::Item);
                                        SLRec.validate("No.", ILERec."Item No.");
                                        SLRec.Validate("Order Qty", ABS(ILERec.Quantity));
                                        SLRec.Validate(Quantity, ABS(ILERec.Quantity));

                                        if (ILERec."Sales Amount (Actual)" <> 0) and (ILERec.Quantity <> 0) then
                                            SLRec.Validate("Unit Price", ABS(ILERec."Sales Amount (Actual)" / ILERec.Quantity));
                                        SLRec."Selling Price" := SLRec."Unit Price";
                                        SLRec.Validate("Location Code", sssetup."Def PMP WH Location");
                                        SLRec.Validate("ZP Customer Name", GetPMPReturnShipname(ILERec."Document No.", 1));
                                        SLRec.Validate("ZP SP", GetPMPReturnShipname(ILERec."Document No.", 2));
                                        SLRec.Validate("Location Code", sssetup."Def PMP WH Location");
                                        BinRec.reset;
                                        BinRec.SetRange("Location Code", sssetup."Def PMP WH Location");
                                        if BinRec.FindFirst() then begin
                                            SLRec.Validate("Bin Code", BinRec.Code);

                                        end;
                                        SLRec.insert(TRUE);
                                        TotalAmt += SLRec.Amount;

                                        ResEntry2.reset;
                                        if ResEntry2.FindLast() then
                                            EntryNo := ResEntry2."Entry No." + 1
                                        else
                                            EntryNo := 1;
                                        ResEntry.reset;
                                        ResEntry.Init();
                                        ResEntry.Validate("Entry No.", EntryNo);
                                        ResEntry.Validate("Source Type", 37);
                                        ResEntry.Validate("Reservation Status", ResEntry."Reservation Status"::Prospect);
                                        ResEntry.Validate("Source Subtype", 3);
                                        ResEntry.Validate("Source ID", SHRec."No.");
                                        ResEntry.Validate("Source Ref. No.", SLRec."Line No.");
                                        ResEntry.Validate("Item No.", ILERec."Item No.");
                                        ResEntry.Validate("Location Code", sssetup."Def PMP WH Location");
                                        ResEntry.Validate("Expected Receipt Date", today);
                                        ResEntry.Validate("Created By", UserId);
                                        ResEntry.Validate(Quantity, Abs(ILERec.Quantity / ILERec."Qty. per Unit of Measure"));
                                        ResEntry.Validate("Quantity (Base)", Abs(ILERec.Quantity));
                                        ResEntry.Validate("Qty. to Handle (Base)", Abs(ILERec.Quantity));
                                        ResEntry.Validate("Qty. to Invoice (Base)", Abs(ILERec.Quantity));
                                        ResEntry.Validate("Creation Date", today);
                                        ResEntry.Validate("Qty. per Unit of Measure", ILERec."Qty. per Unit of Measure");
                                        ResEntry.Validate(Positive, true);
                                        ResEntry.Validate("Item Tracking", ResEntry."Item Tracking"::"Lot No.");
                                        ResEntry.Validate("Lot No.", ILERec."Lot No.");
                                        ResEntry.Validate("Expiration Date", ILERec."Expiration Date");
                                        ResEntry.insert(true);
                                        //Tag that it's already transferred over so won't repeat.
                                        OHCU.UpdateTransferStatus(ILERec."Entry No.");
                                        LineNo += 10000;
                                    end;

                                until ILERec.next = 0;

                            Message('Sales Credit Memo generated.');
                        end;
                    end;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Action)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                        Caption = 'End Date';
                    }
                    field(Choice; Choice)
                    {
                        ApplicationArea = all;
                        Caption = 'Type Of Processing';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure GetPMPShipname(DONo: Code[20]; lType: integer): Text[100]
    var
        myInt: Integer;
        SHRec: Record "Sales Shipment Header";
    begin
        SHRec.reset;
        SHRec.ChangeCompany('PMP');
        SHRec.SetRange("No.", DONo);
        if SHRec.FindFirst() then begin
            if lType = 1 then
                exit(SHRec."Ship-to Name");
            if lType = 2 then
                exit(SHRec."Bill-to Name");
        end;

    end;


    local procedure GetPMPReturnShipname(DONo: Code[20]; lType: integer): Text[100]
    var
        myInt: Integer;
        SHRec: Record "Return Receipt Header";
    begin
        SHRec.reset;
        SHRec.ChangeCompany('PMP');
        SHRec.SetRange("No.", DONo);
        if SHRec.FindFirst() then begin
            if lType = 1 then
                exit(SHRec."Ship-to Name");
            if lType = 2 then
                exit(SHRec."Bill-to Name");
        end;

    end;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        StartDate := CalcDate('-CM', Today);
        EndDate := CalcDate('CM', Today);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        ILERec: Record "Item Ledger Entry";
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
        ResEntry: Record "Reservation Entry";
        TotalAmt: Decimal;

        PHRec: Record "Purchase Header";
        PLRec: Record "Purchase Line";
        LineNo: Integer;
        EntryNo: Integer;
        ResEntry2: Record "Reservation Entry";
        OHCU: Codeunit "Hyphens PMP Interco CU";
        DefBinCode: Code[20];
        BinRec: Record bin;
        Choice: Option " ",Invoice,Return;
}
