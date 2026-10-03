report 57111 "LS Delivery List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Reportlayout 57111 - LS Delivery List.rdl';
    CaptionML = ENU = 'LS Delivery List',
                ENA = 'LS Delivery List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    Permissions = TableData 27 = rimd;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            //DataItemTableView = SORTING("No.") where("TBA Order" = const(false), "No." = const('103110'));
            DataItemTableView = SORTING("No.") where("TBA Order" = const(false), "Logistics Service" = const(true));

            //DX        08 Sept 2021        Return order to retrieve based on the posting date of the invoice        
            trigger OnPreDataItem();
            begin
                if (SDate = 0D) then
                    Error('Please enter start date.');

                IF (SDate <> 0D) then// An underfined or blank date is specified by 0D 
                //RL    07 Jan 2022 change to Shipment Date
                    // SETFILTER("Sales Invoice Header"."Posting Date", '%1', SDate);
                    SETFILTER("Sales Invoice Header"."Shipment Date", '%1', SDate);
                //RL    07 Jan 2022 change to Shipment Date
                if Driver <> '' then begin
                    SetFilter("Sales Invoice Header"."Delivery Zone", '%1', Driver);
                end;
                //RL        07 Oct 2021
                if LS <> '' then
                    SetFilter("Sales Invoice Header"."LS Account", '%1', LS);


                if OnlyMisc = true then
                    SetFilter("Sales Invoice Header"."No.", 'GGGGGGGGGGG');  //to skip Sales Invoice Header for OnlyMisc
                //RL        07 Oct 2021
            end;

            trigger OnAfterGetRecord();
            begin
                if "Sales Invoice Header"."Sell-to Customer No." <> '' then begin
                    CustRec.Get("Sales Invoice Header"."Sell-to Customer No.");
                end;
                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Description 2" := "Sales Invoice Header"."External Document No.";
                TempSHLine."Sell-to Customer No." := "Sales Invoice Header"."Sell-to Customer No.";
                TempSHLine."Customer Name" := CustRec.Name;
                //RL    07 Jan 2022 change to Shipment Date
                // TempSHLine."Start Date" := "Sales Invoice Header"."Posting Date";
                TempSHLine."Start Date" := "Sales Invoice Header"."Shipment Date";
                //RL    07 Jan 2022 change to Shipment Date
                // TempSHLine.Branch := CustRec."Branch/Subsidiary"; // YF 06 Oct 2021
                TempSHLine.Branch := "Sales Invoice Header"."Branch/Subsidiary"; // YF 06 Oct 2021

                TempSHLine."Address 1" := "Sales Invoice Header"."Sell-to Address";
                TempSHLine."Address 2" := "Sales Invoice Header"."Sell-to Address 2";
                TempSHLine."Delivery Zone" := "Sales Invoice Header"."Delivery Zone";
                TempSHLine."Delivery Instructions" := "Sales Invoice Header"."Delivery Instructions";
                TempSHLine."Company Name" := CompanyInfo.Name;
                //TempSHLine."Description 2" := "Sales Invoice Header"."External Document No.";
                //DX        21 Aug 2021

                TempSHLine."Delivery Charge" := "Sales Invoice Header"."Delivery Charge";
                TempSHLine.Description := "Sales Invoice Header"."LS Account";
                //DX        21 Aug 2021
                TempSHLine."Working Hours" := CustRec."Working Hours";
                TempSHLine.Insert;
                //DX        13 Sept 2021
                if "Sales Invoice Header"."Order Status" <> "Sales Invoice Header"."Order Status"::"Delivery In Progress" then
                    REnhanceCU.UpdateInvoiceToDelivery("Sales Invoice Header"."No.");
                //DX        13 Sept 2021
            end;
        }

        //DX        22 Aug 2021

        //DX        07 Sep 2021
        //Add unposted sales return order to the delivery listing, only if released.        

        dataitem("TBA Ledger Entry"; "TBA Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                        Where("Entry Type" = Filter(Delivery));

            trigger OnPreDataItem();
            begin

                IF (SDate <> 0D) OR (EDate <> 0D) THEN // An underfined or blank date is specified by 0D 
                    begin
                    SETFILTER("TBA Ledger Entry"."Posting Date", '%1', SDate);
                end;
                if Driver <> '' then
                    SetFilter("TBA Ledger Entry"."Cage No.", Driver);
            end;

            trigger OnAfterGetRecord();
            begin

                if "TBA Ledger Entry"."Customer No." <> '' then begin

                    CustRec.Get("TBA Ledger Entry"."Customer No.");

                end;

                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Document No." := "TBA Ledger Entry"."Document No.";
                TempSHLine."Sell-to Customer No." := "TBA Ledger Entry"."Customer No.";
                TempSHLine."Customer Name" := CustRec.Name;
                TempSHLine."Start Date" := "TBA Ledger Entry"."Posting Date";
                TempSHLine.Branch := CustRec."Branch/Subsidiary";
                TempSHLine."Address 1" := CustRec.Address;
                TempSHLine."Address 2" := CustRec."Address 2";
                TempSHLine."Delivery Zone" := "TBA Ledger Entry"."Cage No.";
                TempSHLine."Delivery Instructions" := '';
                TempSHLine."Company Name" := CompanyInfo.Name;
                TempSHLine."Working Hours" := CustRec."Working Hours";
                TempSHLine.Description := CustRec."Phone No.";
                TempSHLine."Delivery Charge" := CustRec."Delivery Charge";
                TempSHLine.Insert;

            end;
        }

        //DX        07 Sep 2021

        dataitem(DelMiscCharge; "Delivery Misc Charges")
        {
            DataItemTableView = sorting("Entry No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;

            begin
                DelMiscCharge.SetFilter(DelMiscCharge.Date, '%1', SDate);
                DelMiscCharge.SetFilter(DelMiscCharge."LS Account", '<>%1', '');
                //RL        07 Oct 2021
                if LS <> '' then begin
                    DelMiscCharge.SetFilter(DelMiscCharge."LS Account", '%1', LS);
                end;
                //RL        07 Oct 2021

                if Driver <> '' then
                    DelMiscCharge.SetFilter(DelMiscCharge.Driver, Driver);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                CustRec: Record customer;
                chargeRec: Record "Delivery Charge";
            begin
                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Document No." := DelMiscCharge."Document No.";
                TempSHLine."Sell-to Customer No." := DelMiscCharge."Customer No.";
                if DelMiscCharge."Customer No." <> '' then begin
                    CustRec.reset;
                    CustRec.SetRange("No.", DelMiscCharge."Customer No.");
                    if CustRec.FindFirst() then begin  //RL        07 Oct 2021
                        TempSHLine."Customer Name" := CustRec.Name;
                    end;
                end;
                TempSHLine."Start Date" := DelMiscCharge.Date;
                TempSHLine.Branch := DelMiscCharge."Branch";
                TempSHLine."Address 1" := DelMiscCharge.Address;
                TempSHLine."Address 2" := '';
                TempSHLine."Delivery Instructions" := DelMiscCharge.Instruction;
                TempSHLine."Company Name" := CompanyInfo.Name;
                TempSHLine."Working Hours" := DelMiscCharge."Opening Hours";
                //DX    07 Oct 2021
                TempSHLine.Description := DelMiscCharge."LS Account";

                TempSHLine."Delivery Charge" := DelMiscCharge."Delivery Charge";
                TempSHLine."Delivery Zone" := Driver;
                TempSHLine.Insert(false);
            end;
        }

        dataitem(RecalcTempTbl; Integer)
        {

            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                TempCombi: Record "Customer" temporary;
                LoopUnique: Record Customer temporary;
                LoopTempCombi: Record "Customer" temporary;
                DelChargeRec: Record "Delivery Charge";
                FinalCombi: Record Customer temporary;
                LoopFinalCombi: Record Customer temporary;
                FirstLine: Boolean;

            begin
                myInt := 1;
                TempSHLine.reset;
                if TempSHLine.FindSet() then
                    repeat
                        //DX        21 AUg 2021     Get the unique combination of customer and delivery charges first.                        
                        LoopTempCombi.reset;
                        LoopTempCombi.SetRange(Address, TempSHLine."Sell-to Customer No.");
                        LoopTempCombi.SetRange(Name, TempSHLine."Delivery Charge");
                        LoopTempCombi.SetRange("Last Date Modified", TempSHLine."Start Date");
                        if not (LoopTempCombi.FindFirst()) then begin
                            TempCombi.reset;
                            TempCombi."No." := format(myInt);
                            TempCombi.Address := TempSHLine."Sell-to Customer No.";
                            TempCombi.Name := TempSHLine."Delivery Charge";
                            TempCombi."Last Date Modified" := TempSHLine."Start Date";
                            DelChargeRec.reset;
                            DelChargeRec.SetRange("Delivery Charge", TempSHLine."Delivery Charge");
                            if DelChargeRec.FindFirst() then
                                TempCombi."Credit Limit (LCY)" := DelChargeRec.Amount;
                            TempCombi.Insert(FALSE);
                            LoopTempCombi.reset;
                            LoopTempCombi.copy(TempCombi);
                            LoopTempCombi.Insert(FALSE);
                            LoopUnique.reset;
                            LoopUnique.copy(TempCombi);
                            LoopUnique.Insert(false);
                        end;
                        myInt += 1;
                    until TempSHLine.next = 0;


                myInt := 1;
                if LoopUnique.FindSet() then
                    repeat
                        TempCombi.SetCurrentKey("Credit Limit (LCY)");
                        TempCombi.SetRange(Address, LoopUnique.Address);
                        TempCombi.SetAscending("Credit Limit (LCY)", false);      //Get the highest amount in the combination first
                        if TempCombi.FindFirst() then begin     //Once get the highest amount already, then insert into another temp table for looping later
                            LoopFinalCombi.reset;
                            LoopFinalCombi.SetRange(address, TempCombi.Address);
                            LoopFinalCombi.SetRange(Name, TempCombi.Name);
                            LoopFinalCombi.SetRange("Last Date Modified", TempCombi."Last Date Modified");
                            if not (LoopFinalCombi.FindFirst()) then begin
                                FinalCombi.reset;
                                FinalCombi."No." := format(myInt);
                                FinalCombi.Address := TempCombi.Address;
                                FinalCombi.Name := TempCombi.Name;
                                FinalCombi."Last Date Modified" := TempCombi."Last Date Modified";
                                DelChargeRec.reset;
                                DelChargeRec.SetRange("Delivery Charge", TempCombi."Delivery Charge");
                                if DelChargeRec.FindFirst() then
                                    FinalCombi."Credit Limit (LCY)" := DelChargeRec.Amount;
                                FinalCombi.Insert(FALSE);
                                LoopFinalCombi.reset;
                                LoopFinalCombi.copy(FinalCombi);
                                LoopFinalCombi.Insert(FALSE);
                            end;
                        end;
                        myInt += 1;
                    until LoopUnique.next = 0;

                if FinalCombi.FindSet() then        //Retrieved all the highest delivery charges by customer already, then now to loop through temp data set and reflect in report.
                    repeat
                        FirstLine := true;
                        TempSHLine.reset;
                        TempSHLine.SetRange("Sell-to Customer No.", FinalCombi.Address);
                        TempSHLine.SetRange("Start Date", FinalCombi."Last Date Modified");
                        if TempSHLine.FindSet() then
                            repeat
                                if FirstLine = true then begin
                                    TempSHLine."Delivery Charge" := FinalCombi.Name;
                                    FirstLine := false;
                                end else begin
                                    TempSHLine."Delivery Charge" := '';
                                end;
                                TempSHLine.Modify(FALSE);
                            until TempSHLine.next = 0;
                    until FinalCombi.next = 0;
            end;
        }


        //DX        21 Aug 2021
        dataitem(DataItem1000000002; 2000000026)
        {
            DataItemTableView = sorting(Number);
            column(DocumentNo; TempSHLine."Description 2")
            {
            }
            column(Posting_Date; TempSHLine."Posting Date")
            {
            }
            column(Sell_to_Customer_No_; TempSHLine."Sell-to Customer No.")
            {
            }
            column(CustName; TempSHLine."Customer Name")
            {
            }
            column(SDate; format(TempSHLine."Start Date"))
            {
            }
            column(branch; TempSHLine.Branch)
            {
            }
            column(Address1; TempSHLine."Address 1")
            {
            }
            column(Address2; TempSHLine."Address 2")
            {
            }
            column(DeliveryZone; TempSHLine."Delivery Zone")
            {
            }
            column(DeliveryInstruction; TempSHLine."Delivery Instructions")
            {
            }
            column(Companyname; TempSHLine."Company Name")
            {
            }
            column(WorkingHour; TempSHLine."Working Hours")
            {
            }
            column(Ice; Ice)
            {

            }
            column(DelCharge; TempShLine."Delivery Charge")
            {

            }
            column(DateRange; Format(Sdate) + '-' + format(EDate))
            {

            }
            column(LSAccount; TempSHLine."Description")
            {

            }


            trigger OnAfterGetRecord();
            begin

                IF Number = 1 THEN
                    TempSHLine.FIND('-') // find first record
                ELSE
                    TempSHLine.NEXT;

                if Driver <> '' then begin
                    if TempSHLine."Delivery Zone" <> Driver then
                        CurrReport.Skip();

                end;
                //RL    15 Dec 2021
                if HideSelfCollect = true then
                    if TempSHLine."Delivery Zone" = 'SELF-COLLECT' then
                        CurrReport.Skip();
                //RL    15 Dec 2021
                //DX        21 Aug 2021
                ALERec.reset;
                ALERec.SetRange("Invoice No.", TempSHLine."Document No.");
                if ALERec.FindFirst() then begin
                    if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then
                        Ice := 'No'
                    else
                        Ice := 'Yes';
                end;
                //DX        21 Aug 2021

            end;

            trigger OnPreDataItem();
            begin

                TempSHLine.RESET;
                SETRANGE(Number, 1, TempSHLine.COUNT);//tempsh.count is count no of record, e.g. 10 records, so if use setrange, it will loop from number 1 record to the tempsh.COUNT record which is 10

            end;
        }
    }




    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Filtering")
                {
                    field("Date"; SDate)
                    {
                        ApplicationArea = All;

                    }

                    field(Driver; Driver)
                    {
                        ApplicationArea = all;
                        TableRelation = "Delivery Zone"."Delivery Zone";
                    }
                    field(LS; LS)
                    {
                        ApplicationArea = all;
                        TableRelation = "LS Account".Code;
                    }
                    field(OnlyMisc; OnlyMisc)
                    {
                        ApplicationArea = all;
                        Caption = 'Print Misc only';
                    }
                    field(PrintSRO; PrintSRO)
                    {
                        ApplicationArea = all;
                        Caption = 'Print SROs';
                    }
                    field(HideSelfCollect; HideSelfCollect)
                    {
                        ApplicationArea = All;
                        Caption = 'Hide Self Collect';
                    }

                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        SDate := Today;
        CompanyInfo.reset;
        CompanyInfo.get;
    end;

    trigger OnPostReport()
    var
        myInt: Integer;
        InvRange: Code[2048];
        RecRun: Integer;
        RecordCount: Integer;
        SHRec: Record "Sales Header";
    begin


    end;
    /*
        local procedure GetSROStartDate(SIHRec: Record "Sales Invoice Header"): Date
        var
            myInt: Integer;
            SRORec: Record "Sales Header";
            LSIHRec: Record "Sales Invoice Header";
            currDate: Date;
        begin       //If Sales Inv date is 8th Sept
            currDate := 0D;
            LSIHRec.reset;
            LSIHRec.SetCurrentKey("Posting Date");
            LSIHRec.SetAscending("Posting Date", false);
            //LSIHRec.SetRange("Sell-to Address", SIHRec."Sell-to Address");
            //LSIHRec.SetRange("Sell-to Address 2", SIHRec."Sell-to Address 2");
            LSIHRec.SetRange("Sell-to Customer No.", SIHRec."Sell-to Customer No.");
            LSIHRec.SetFilter("Posting Date", '%1..%2', CalcDate('<-1M>', SIHRec."Posting Date"), SIHRec."Posting Date");
            if LSIHRec.FindSet() then
                repeat
                    if currDate = 0D then
                        currDate := LSIHRec."Posting Date"
                    else begin
                        if currDate <> LSIHRec."Posting Date" then begin
                            exit(LSIHRec."Posting Date");
                        end;
                    end;

                until LSIHRec.next = 0;
        end;
    */
    var
        TempSHLine: Record "Temp Sales Report Line" temporary;
        CustRec: Record Customer;
        CompanyInfo: record "Company Information";
        SalesHeaderRec: Record "Sales Invoice Header";
        SalesLineRec: Record "Sales Invoice Line";
        ItemRec: Record Item;
        SDate: date;
        EDate: date;
        ItemFilter: boolean;
        ShipToRec: record "Ship-to Address";
        AddressCode: Text[100];
        IDCounter: Integer;
        No: code[20];
        PostingDate: date;
        AssignementLegerRec: Record "Assignment Ledger Entry";
        CheckingHeader: Record "Checking Header";
        CheckingDeliveryCharge: code[20];

        NLocationCount: Decimal;
        S1LocationCount: Decimal;
        ss: Record "CSV Buffer";
        ALERec: Record "Assignment Ledger Entry";
        Ice: Text[100];
        Driver: Code[100];
        StartDate: date;
        PrintSRO: Boolean;
        AutoPrint: Boolean;
        REnhanceCU: Codeunit "PMP-Enhancements";
        LS: Code[50];
        OnlyMisc: Boolean;

        HideSelfCollect: Boolean;

}

