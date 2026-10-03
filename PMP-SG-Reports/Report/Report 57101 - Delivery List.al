report 57101 "Delivery List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Reportlayout 57101 - Delivery List.rdl';
    CaptionML = ENU = 'Delivery List',
                ENA = 'Delivery List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Check; Integer)
        {
            DataItemTableView = sorting(Number) where("Number" = const(1));
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                SRORec: Record "Sales Header";
            begin
                //DX        14 Sept 2021
                SRORec.reset;
                SRORec.SetRange("Document Type", SRORec."Document Type"::"Return Order");
                SRORec.SETFILTER("Posting Date", '%1', SDate);
                SRORec.SetRange("Return Status", SRORec."Return Status"::"Checker to verify");
                SRORec.SetRange(Rebill, true);
                if SRORec.Count > 0 then
                    Error('There are %1 outstanding return orders for checker to verify, please clear before printing delivery list.', SRORec.Count);


                //DX        14 Sept 2021
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            //DataItemTableView = SORTING("No.") where("TBA Order" = const(false), "No." = const('103110'));
            DataItemTableView = SORTING("No.") where("TBA Order" = const(false), "Logistics Service" = const(false), "No." = filter('SI*')); //RL  01 Nov 2021, print only SI

            //DX        08 Sept 2021        Return order to retrieve based on the posting date of the invoice
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST("Return Order"), Status = const(released), rebill = const(FALSE));
                //DataItemLink = "Sell-to Customer No." = field("Sell-to Customer No.");
                // DataItemLink = "Sell-to Address" = field("Sell-to Address"), "Sell-to Address 2" = field("Sell-to Address 2");

                trigger OnPreDataItem();
                begin
                    //SetRange("Sales Header"."Sell-to Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                    SetRange("Sales Header"."Sell-to Address", "Sales Invoice Header"."Sell-to Address");
                    SetRange("Sales Header"."Sell-to Address 2", "Sales Invoice Header"."Sell-to Address 2");
                    SETFILTER("Sales Header"."Posting Date", '%1..%2', GetSROStartDate("Sales Invoice Header"), "Sales Invoice Header"."Posting Date");
                    if Driver <> '' then
                        SetFilter("Sales Header"."Delivery Zone", Driver);
                end;

                trigger OnAfterGetRecord();
                begin

                    TempSHLine.reset;
                    TempSHLine.SetRange("Document No.", "Sales Header"."No.");
                    if not (TempSHLine.FindFirst()) then begin
                        CheckingDeliveryCharge := "Sales Header"."Delivery Charge";
                        // insert to temp table
                        IDCounter := IDCounter + 1;
                        TempSHLine.Init;
                        TempSHLine.ID := IDCounter;
                        TempSHLine."Document No." := "Sales Header"."No.";
                        TempSHLine."Sell-to Customer No." := "Sales Header"."Sell-to Customer No.";
                        TempSHLine."Customer Name" := "Sales Header"."Sell-to Customer Name";
                        TempSHLine."Start Date" := "Sales Header"."Posting Date";
                        TempSHLine.Branch := CustRec."Branch/Subsidiary";
                        TempSHLine."Address 1" := "Sales Header"."Sell-to Address";
                        TempSHLine."Address 2" := "Sales Header"."Sell-to Address 2";
                        TempSHLine."Delivery Zone" := "Sales Header"."Delivery Zone"; //RL 2 Nov 2021 - change from custrec to salesheader
                        TempSHLine."Delivery Instructions" := "Sales Header"."Delivery Instructions";
                        TempSHLine."Company Name" := CompanyInfo.Name;
                        //DX        21 Aug 2021
                        // TempSHLine."Delivery Charge" := "Sales Header"."Delivery Charge";
                        TempSHLine."Delivery Charge" := '';//RL 24 Feb 2022
                        //DX        21 Aug 2021
                        TempSHLine."Working Hours" := CustRec."Working Hours";
                        TempSHLine."Inventory Posting Group" := 'SRO';
                        TempSHLine.Insert;


                    end;

                end;

            }


            trigger OnPreDataItem();
            begin
                if (SDate = 0D) OR (EDate = 0D) then
                    Error('Please enter start and end date.');

                IF (SDate <> 0D) OR (EDate <> 0D) THEN // An underfined or blank date is specified by 0D 
                    begin
                    SETFILTER("Sales Invoice Header"."Posting Date", '%1..%2', SDate, EDate);
                end;
                if Driver <> '' then
                    SetFilter("Sales Invoice Header"."Delivery Zone", Driver);

                if OnlyMisc = true then
                    SetFilter("Sales Invoice Header"."No.", 'GGGGGGGGGGG');  //to skip Sales Invoice Header for OnlyMisc
                //RL        30 May 2022
            end;

            trigger OnAfterGetRecord();
            begin

                if "Sales Invoice Header"."Sell-to Customer No." <> '' then begin

                    CustRec.Get("Sales Invoice Header"."Sell-to Customer No.");

                end;

                AssignementLegerRec.Reset();
                AssignementLegerRec.SetRange("Invoice No.", "Sales Invoice Header"."No.");

                if AssignementLegerRec.findfirst then begin
                    CheckingHeader.Reset();
                    CheckingHeader.SetRange("No.", AssignementLegerRec."Picking Doc No.");

                    if CheckingHeader.findfirst then begin
                        //Message(CheckingHeader."No.");
                        CheckingDeliveryCharge := CheckingHeader."Delivery Charge";
                    end;
                end;

                // insert to temp table
                IDCounter := IDCounter + 1;
                TempSHLine.Init;
                TempSHLine.ID := IDCounter;
                TempSHLine."Document No." := "Sales Invoice Header"."No.";
                TempSHLine."Sell-to Customer No." := "Sales Invoice Header"."Sell-to Customer No.";
                TempSHLine."Customer Name" := "Sales Invoice Header"."Sell-to Customer Name";
                TempSHLine."Start Date" := "Sales Invoice Header"."Posting Date";
                TempSHLine.Branch := "Sales Invoice Header"."Branch/Subsidiary";
                TempSHLine."Address 1" := "Sales Invoice Header"."Sell-to Address";
                TempSHLine."Address 2" := "Sales Invoice Header"."Sell-to Address 2";
                TempSHLine."Delivery Zone" := "Sales Invoice Header"."Delivery Zone";  //RL 2 Nov 2021 - change from Custrec to Salesinvoiceheader
                TempSHLine."Delivery Instructions" := "Sales Invoice Header"."Delivery Instructions";
                TempSHLine."Company Name" := CompanyInfo.Name;
                //DX        21 Aug 2021
                TempSHLine."Delivery Charge" := "Sales Invoice Header"."Delivery Charge";
                //DX        21 Aug 2021
                TempSHLine."Working Hours" := CustRec."Working Hours";
                TempSHLine.Description := "Sales Invoice Header"."Sell-to Phone No.";
                TempSHLine.Insert;
                //DX        13 Sept 2021
                if "Sales Invoice Header"."Order Status" <> "Sales Invoice Header"."Order Status"::"Delivery In Progress" then
                    REnhanceCU.UpdateInvoiceToDelivery("Sales Invoice Header"."No.");
                //DX        13 Sept 2021
            end;
        }
        /*
                dataitem("TBA Ledger Entry"; "TBA Ledger Entry")
                {
                    DataItemTableView = SORTING("Entry No.")
                                        Where("Entry Type" = Filter(Delivery));

                    trigger OnPreDataItem();
                    begin

                        IF (SDate <> 0D) OR (EDate <> 0D) THEN // An underfined or blank date is specified by 0D 
                            begin
                            SETFILTER("TBA Ledger Entry"."Posting Date", '%1..%2', SDate, EDate);
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
                */
        //DX        21 Aug 2021
        //DX        22 Aug 2021
        dataitem(DelMiscCharge; "Delivery Misc Charges")
        {
            DataItemTableView = sorting("Entry No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                DelMiscCharge.SetFilter(Date, '%1..%2', SDate, EDate);
                DelMiscCharge.SetFilter("LS Account", '%1', '');
                if Driver <> '' then
                    DelMiscCharge.SetFilter(DelMiscCharge.Driver, Driver);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                CustRec: Record customer;
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
                TempSHLine."Delivery Charge" := DelMiscCharge."Delivery Charge";
                TempSHLine."Delivery Zone" := DelMiscCharge.Driver;//RL 2 nov 2021 - change from custrec to delmisccharge
                TempSHLine.Insert(false);
            end;
        }
        //DX        22 Aug 2021

        //DX        07 Sep 2021
        //Add unposted sales return order to the delivery listing, only if released.        

        //DX        07 Sep 2021
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
            column(DocumentNo; TempSHLine."Document No.")
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
            column(Phone; tempshline.Description)
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

            trigger OnPostDataItem()
            begin
                TempSHLine.SetCurrentKey("Sell-to Customer No.");
                TempSHLine.SetAscending("Sell-to Customer No.", true);
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
                    field("Start Date"; SDate)
                    {
                        ApplicationArea = All;

                    }
                    field("End Date"; EDate)
                    {
                        ApplicationArea = All;

                    }
                    field(Driver; Driver)
                    {
                        ApplicationArea = all;
                        TableRelation = "Delivery Zone"."Delivery Zone";
                    }
                    field(PrintSRO; PrintSRO)
                    {
                        ApplicationArea = all;
                        Caption = 'Print SROs';
                    }
                    field(OnlyMisc; OnlyMisc)
                    {
                        ApplicationArea = all;
                        Caption = 'Print Misc only';
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
        EDate := today;
        CompanyInfo.reset;
        CompanyInfo.get;
    end;

    trigger OnPostReport()
    var
        myInt: Integer;
        InvRange: Code[2048];
        RecRun: Integer;
        RecordCount: Integer;
        SROReport: report 57018;
        SHRec: Record "Sales Header";
    begin
        if PrintSRO = true then begin
            RecRun := 1;
            InvRange := '';
            //ERROR('Please select up to a maximum of 20 items only');
            TempSHLine.reset;
            TempSHLine.SetRange("Inventory Posting Group", 'SRO');

            RecordCount := TempSHLine.Count;
            IF TempSHLine.FINDSET THEN
                REPEAT
                    IF RecRun < RecordCount THEN
                        InvRange := InvRange + TempSHLine."Document No." + '|'
                    ELSE
                        InvRange := InvRange + TempSHLine."Document No.";
                    RecRun += 1;
                UNTIL TempSHLine.NEXT = 0;
            SHRec.reset;
            SHRec.SetRange("Document Type", SHRec."Document Type"::"Return Order");
            SHRec.SetRange("No.", InvRange);
            Report.Run(57018, true, false, SHRec);

            /*
        IF TempSHLine.FindSet() THEN
            repeat
                SHRec.reset;
                SHRec.SetRange("Document Type", SHRec."Document Type"::"Return Order");
                SHRec.SetFilter("No.", '%1', TempSHLine."Document No.");
                if AutoPrint = false then
                    Report.Run(57018, true, false, SHRec)
                else
                    Report.Run(57018, false, false, SHRec);
            UNTil TempSHLine.next = 0;
*/
            //SROReport.SetTableView(SHRec);


        end;
    end;

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
        OnlyMisc: Boolean;

}