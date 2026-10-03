page 55005 "Checking Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Checking Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(ScanBasket; ScanBasket)
                {
                    ApplicationArea = all;
                    //TableRelation = Basket."No.";
                    Caption = 'Scan Basket Code';
                    trigger OnValidate()
                    var
                        CheckRec: Record "Checking Header";
                        ALERec: Record "Assignment Ledger Entry";
                    begin

                        if Rec.Status = Rec.Status::Completed then
                            Error('Checking card is already completed.');
                        if ScanBasket <> '' then begin
                            if PMPCU.HasOpenChecking(ScanBasket) <> '' then
                                Error(StrSubstNo('Open Checking %1 exists for Basket %2, please check again.', PMPCU.HasOpenChecking(ScanBasket), ScanBasket));
                            if PMPCU.PickListExists(ScanBasket) then begin
                                CurrPage.Update(true);
                                if PMPCU.NonColdCheckAlreadyExist(ScanBasket) then begin        //DX        18 July 2021 If already have non cold pick list
                                    ALERec.reset;
                                    ALERec.SetLoadFields(Status, "2nd Checker ID", "2nd Basket Code", "Picking Doc No.");        //DX        23 May  2023
                                    ALERec.SetCurrentKey("2nd Basket Code", "Picking Doc No.");      //DX        24 May 2023
                                    ALERec.SetRange("2nd Basket Code", ScanBasket);
                                    ALERec.SetFilter("Picking Doc No.", '<>%1', '');
                                    ALERec.SetRange(Status, ALERec.Status::"Checking");
                                    if ALERec.FindFirst() then begin
                                        CheckRec.reset;
                                        CheckRec.SetRange("No.", ALERec."Checking Doc No.");
                                        if CheckRec.FindFirst() then begin
                                            CurrPage.SetRecord(CheckRec);
                                            //CheckRec."2nd Basket No." := ScanBasket;
                                            //DX        25 July 2021
                                            CheckRec."2nd Checker Start Time" := CurrentDateTime;
                                            CheckRec."2nd Checker ID" := UserId;  //RL    01 Mar 2022
                                            ALERec."2nd Checker ID" := UserId; //RL    04 Mar 2022
                                            //DX        25 July 2021
                                            CheckRec.Modify(true);
                                        end;
                                    end;
                                end else begin
                                    PMPCU.CreateCheckingCard(Rec, ScanBasket);      //DX        18 July 2021    Create Check record if no combined existing check list
                                    // //RL    02 Mar 2022
                                    // if Rec."2nd Basket No." <> '' then begin
                                    //     Rec."2nd Checker ID" := UserId;
                                    //     Rec.Modify(true);
                                    // end;
                                    // //RL    02 Mar 2022
                                end;
                                ScanBasket := '';
                            end else
                                Error('No such pick list in system, please check again.');
                        end;
                    end;
                }
                field("Basket No."; Rec."Basket No.")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("2nd Basket No."; Rec."2nd Basket No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //TableRelation = "Registered Whse. Activity Hdr."."Whse. Activity No." where(Type = const(PICK));

                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }

                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    //Editable = false;

                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    //Editable = false;
                }
                field(Picker; Rec.Picker)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Shipping Bin"; Rec."Shipping Bin")
                {
                    ApplicationArea = All;
                    Caption = 'Delivery Zone';
                    Editable = DisableInvPost;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        WHCU: Codeunit "WH-Checking";
                    begin
                        if Rec."Shipping Bin" <> xRec."Shipping Bin" then
                            WHCU.UpdateDelZoneInSO(Rec);
                    end;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ApplicationArea = All;
                    Editable = DisableInvPost;
                    //DX        20 Aug 2021
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        WHCU: Codeunit "WH-Checking";
                    begin
                        if Rec."Delivery Charge" <> xRec."Delivery Charge" then
                            WHCU.UpdateDelChargeInSO(Rec);
                    end;
                    //DX        20 Aug 2021

                }
                field(Checker; Rec.Checker)
                {
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                    end;
                }
                field("2nd Checker ID"; Rec."2nd Checker ID")
                {
                    ApplicationArea = all;
                    Caption = 'Cold Room Checker';
                    Editable = false;
                    Importance = Additional;
                }
                field("2nd Checker Start Time"; Rec."2nd Checker Start Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                }
                field("2nd Checker End Time"; REc."2nd Checker End Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                }
                field("Shipping Packacges"; Rec."Shipping Packacges")
                {
                    Caption = 'Shipping Packages';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;

                }
                field("Non-Cold Shipping Packages"; Rec."Non-Cold Shipping Packages")
                {
                    ApplicationArea = all;
                }
                field("Cold Shipping Packages"; Rec."Cold Shipping Packages")
                {
                    ApplicationArea = all;
                }


                part("Other Picking Lines"; TempWHPickList)
                {
                    Caption = 'Additional Picking Lines';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Picking Instruction"; Rec."Picking Instruction")
                {
                    ApplicationArea = all;
                    Editable = false;
                    MultiLine = true;
                }
                /*
                                part("Org Source Details"; TempSOTotalPage)
                                {
                                    Caption = 'Source Details';
                                    Editable = false;
                                    ApplicationArea = all;
                                }
                */
                field("Picker Error"; Rec."Picker Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Picker Error field.', Comment = '%';

                    trigger OnValidate()
                    begin
                        UpdateAssignmentLedger('picker');
                    end;
                }
                field("Checker Error"; Rec."Checker Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checker Error field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        UpdateAssignmentLedger('checker');
                    end;

                }
            }

            //DX        13 Aug 2021

            group(Additional)
            {

                part(Subform; "Checking Subform")
                {
                    Editable = DisableInvPost;
                    SubPageLink = "Doc No." = field("No.");
                    UpdatePropagation = Both;
                    ApplicationArea = all;
                }
            }
            //DX        13 Aug 2021

        }



    }


    actions
    {
        area(Processing)
        {
            //DX        16 July 2021        Auto complete if post invoice
            /*
            action("Complete Checking")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                image = Completed;
                trigger OnAction()
                begin
                    PMPCU.CompleteChecking(Rec);
                end;
            }
            */
            group(Tasks)
            {
                action("View Source Document")
                {

                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        ALERec: Record "Assignment Ledger Entry";
                        SORec: Page "Sales Order";
                        SHRec: Record "Sales Header";
                        SIHREC: Record "Sales Invoice Header";
                        SIPage: page "Sales Invoice";
                    begin
                        ALERec.reset;
                        ALERec.SetLoadFields("Picking Doc No.", "Document No.");
                        ALERec.SetRange("Picking Doc No.", Rec."No.");
                        if ALERec.FindFirst() then begin
                            if ALERec."Invoice No." = '' then begin
                                Clear(SORec);
                                SHRec.reset;
                                SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                                SHRec.SetRange("No.", ALERec."Document No.");
                                if SHRec.FindFirst() then begin
                                    clear(SORec);
                                    SORec.SetTableView(SHRec);
                                    SORec.Run();
                                end;
                                /*
                            end else begin
                                SIHREC.reset;
                                SIHREC.SetRange("No.", ALERec."Invoice No.");
                                if SIHREC.FindFirst() then begin
                                    clear(SIPage);
                                    SIPage.SetTableView(SIHRec);
                                    SIPage.Run();
                                end;
                                */
                            end;
                        end;
                    end;
                }
                //DX        16 July 2021

                action("View Warehouse Shipment Document")
                {

                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Post;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        ALERec: Record "Assignment Ledger Entry";
                        ShipmentDoc: Record "Warehouse Shipment Header";
                        ShipmentPage: Page "Warehouse Shipment";
                        PHRec: Record "Registered Whse. Activity Hdr.";  //RL 21 Oct 2021 - Add source table
                        PLRec: Record "Registered Whse. Activity Line";  //RL 21 Oct 2021 - change source table
                    begin
                        ALERec.reset;
                        ALERec.SetRange("Picking Doc No.", Rec."No.");
                        if ALERec.FindFirst() then begin
                            if ALERec."Invoice No." = '' then begin
                                PHRec.reset;
                                PHRec.SetRange("Whse. Activity No.", Rec."No.");
                                if PHRec.FindFirst() then begin
                                    PLRec.reset;
                                    PLRec.SetRange("No.", PHRec."No.");
                                    if PLRec.FindFirst() then begin
                                        ShipmentDoc.reset;
                                        ShipmentDoc.SetRange("No.", PLRec."Whse. Document No.");
                                        if ShipmentDoc.FindFirst then begin
                                            clear(ShipmentPage);
                                            ShipmentPage.SetTableView(ShipmentDoc);
                                            ShipmentPage.Run();
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                }
                //DX        16 July 2021
                action("Post Invoice")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    Enabled = DisableInvPost;
                    trigger OnAction()
                    var
                        WhseShptHdr: Record "Warehouse Shipment Header";
                        WhseShptLine: Record "Warehouse Shipment Line";
                        RegWhseActivityLine: Record "Registered Whse. Activity Line";
                        RegWhseHeader: Record "Registered Whse. Activity Hdr.";
                        ALERec: Record "Assignment Ledger Entry";

                        SalesHeaderRec: Record "Sales Header"; // YF 01 Dec 2021
                        SalesPost: Codeunit "Sales-Post"; // YF 01 Dec 2021
                        SalesInvHeaderRec: Record "Sales Invoice Header"; // YF 02 Dec 2021
                        SalesLineRec: Record "Sales Line"; // YF 14 Dec 2021
                    begin
                        if Confirm('Are you sure you wish to post the invoice?') then begin
                            OnCheckProofTag(Rec);

                            if PMPCU.IsAOPL(Rec) then begin
                                RegWhseHeader.reset;
                                RegWhseHeader.SetLoadFields("Whse. Activity No.", "No.");
                                RegWhseHeader.SetRange("Whse. Activity No.", Rec."No.");
                                if RegWhseHeader.FindFirst() then begin
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                    ALERec.SetRange("Invoice No.", '');
                                    if ALERec.FindFirst() then begin
                                        //DX        18 July 2021    Check that the Picking list is combined and both way bills must be printed already and checked
                                        if Rec."Customer No." <> 'WELLAWAY' THEN begin
                                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                                                if Rec."Checker" = '' then
                                                    Error('Please print Non Cold Room Waybill to confirm checking is complete before posting invoice.');
                                            end
                                            else
                                                if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                                    if Rec."2nd Checker ID" = '' then
                                                        Error('Please print Cold Room Waybill to confirm checking is complete before posting invoice.');
                                                end else
                                                    if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                                                        if (Rec.Checker = '') OR (Rec."2nd Checker ID" = '') then
                                                            Error('Both Non-Cold waybill and Cold waybill must be checked and printed before able to post invoice.\Please check again.');
                                                        Rec."2nd Checker End Time" := CurrentDateTime;
                                                    end;
                                        end;
                                        //DX        18 July 2021
                                        CurrPage.UPDATE(false);
                                        // Rec."Posting Date" := today;
                                        Rec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        Rec.Checker := UserId;
                                        Rec."End Time" := CurrentDateTime;
                                        Rec.Status := Rec.Status::Completed;
                                        Rec.Modify(false);
                                        WarehouseCU.SetBasketAvail(Rec."Basket No.");
                                        if Rec."2nd Basket No." <> '' then
                                            WarehouseCU.SetBasketAvail(Rec."2nd Basket No.");
                                        ALERec.Status := ALERec.Status::Completed;
                                        // ALERec."Posting Date" := today;
                                        ALERec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        ALERec."Invoice No." := ALERec."Document No.";
                                        ALERec.Modify(TRUE);
                                        Message('Assembly Checking completed, please hand over to production for processing.');
                                    end;
                                end;
                            end else begin
                                RegWhseHeader.reset;
                                RegWhseHeader.SetLoadFields("Whse. Activity No.", "No.");  //DX    03 May 2023
                                RegWhseHeader.SetRange("Whse. Activity No.", Rec."No.");
                                if RegWhseHeader.FindFirst() then begin
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                    ALERec.SetRange("Invoice No.", '');
                                    if ALERec.FindFirst() then begin
                                        //DX        18 July 2021    Check that the Picking list is combined and both way bills must be printed already and checked
                                        if Rec."Customer No." <> 'WELLAWAY' THEN begin
                                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                                                if Rec."Checker" = '' then
                                                    Error('Please print Non Cold Room Waybill to confirm checking is complete before posting invoice.');
                                            end
                                            else
                                                if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                                    if Rec."2nd Checker ID" = '' then
                                                        Error('Please print Cold Room Waybill to confirm checking is complete before posting invoice.');
                                                end else
                                                    if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                                                        if (Rec.Checker = '') OR (Rec."2nd Checker ID" = '') then
                                                            Error('Both Non-Cold waybill and Cold waybill must be checked and printed before able to post invoice.\Please check again.');
                                                        Rec."2nd Checker End Time" := CurrentDateTime;
                                                    end;
                                        end;
                                        //DX        18 July 2021
                                        // ALERec."Posting Date" := today;
                                        ALERec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        ALERec.Modify(TRUE);
                                    end;
                                    RegWhseActivityLine.reset;
                                    RegWhseActivityLine.SetLoadFields("No.", "Whse. Document No.");      //DX    03 May 2023
                                    RegWhseActivityLine.SetRange("No.", RegWhseHeader."No.");
                                    if RegWhseActivityLine.FindFirst() then begin
                                        //DX     14 Jun 2021     Modify the warehouse shipment header to get the current date of posting.
                                        WhseShptHdr.reset;
                                        WhseShptHdr.SetRange("No.", RegWhseActivityLine."Whse. Document No.");
                                        if WhseShptHdr.FindFirst() then begin
                                            // WhseShptHdr.Validate("Posting Date", Today);
                                            WhseShptHdr.Validate("Posting Date", WorkDate);  //RL 28 Dec 2022
                                            WhseShptHdr.Modify(TRUE);
                                        end;
                                        //DX     14 Jun 2021     
                                        WhseShptLine.reset;
                                        WhseShptLine.SetRange("No.", RegWhseActivityLine."Whse. Document No.");
                                        WhseShptLine.SetFilter("Qty. to Ship", '<>0');
                                        if WhseShptLine.FindFirst() then begin
                                            CurrPage.UPDATE(false);
                                            // Rec."Posting Date" := today;
                                            Rec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                            Rec.Checker := UserId;
                                            Rec."End Time" := CurrentDateTime;
                                            Rec.Status := Rec.Status::Completed;
                                            Rec.Modify(false);
                                            CODEUNIT.RUN(CODEUNIT::"Whse.-Post Shipment (Yes/No)", WhseShptLine);

                                            // YF 01 Dec 2021 // Post Sales Invoice
                                            if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Sales Order" then begin
                                                SalesHeaderRec.Reset;
                                                SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
                                                SalesHeaderRec.SetRange("No.", WhseShptLine."Source No.");
                                                if SalesHeaderRec.FindFirst() then begin
                                                    SalesHeaderRec.Invoice := true;
                                                    SalesHeaderRec.Ship := true;
                                                    SalesHeaderRec.Modify(false);

                                                    // YF 14 Dec 2021
                                                    /*
                                                    SalesLineRec.Reset;
                                                    SalesLineRec.SetRange("Document Type", SalesLineRec."Document Type"::Order);
                                                    SalesLineRec.SetRange("Document No.", WhseShptLine."Source No.");
                                                    SalesLineRec.SetRange("Line No.", WhseShptLine."Source Line No.");
                                                    if SalesLineRec.FindFirst() then begin
                                                        SalesLineRec."Qty To Deliver" := SalesLineRec."Order Qty" - WhseShptLine."Qty. to Ship";
                                                        SalesLineRec."FOC (Qty) To Deliver" := 0;
                                                    end;
                                                    */
                                                    // YF 14 Dec 2021

                                                    // YF 02 Dec 2021
                                                    SalesPost.Run(SalesHeaderRec);
                                                    WarehouseCU.UpdateInvoiceNo(WhseShptLine."Source No.", RegWhseHeader."Whse. Activity No.", false, WhseShptLine."Source Line No.");
                                                    // YF 02 Dec 2021

                                                    InsertProofTag(SalesHeaderRec, Rec);
                                                end;
                                            end;
                                            // YF 01 Dec 2021 // Post Sales Invoice

                                            //DX        04 July 2021        After post invoice from checking, assume checker will put on cage to ship out.
                                            if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Outbound Transfer" then
                                                WarehouseCU.UpdateOrderStatus(WhseShptLine."Source No.", 'Completed')
                                            else
                                                WarehouseCU.UpdateOrderStatus(WhseShptLine."Source No.", 'Pending Delivery');

                                            WarehouseCU.SetBasketAvail(Rec."Basket No.");
                                            if Rec."2nd Basket No." <> '' then
                                                WarehouseCU.SetBasketAvail(Rec."2nd Basket No.");
                                            //DX     05 Oct 2021                                    
                                            //DX        31 Aug 2021
                                            //DX        22 July 2021
                                            if (Rec."Customer No." = 'WELLAWAY') OR (Rec."Customer No." = 'SAMPLE') THEN begin       //Wellaway Process Only.
                                                ALERec.reset;
                                                ALERec.SetCurrentKey("Picking Doc No.");
                                                ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                                if ALERec.FindFirst() then begin
                                                    ALERec."Check End Time" := CurrentDateTime;
                                                    ALERec."Checker ID" := UserId;
                                                    ALERec.Status := ALERec.Status::Completed;
                                                    ALERec.Modify(TRUE);
                                                end;
                                            end;
                                        end else begin
                                            ;
                                            //RL    08 Dec 2021
                                            SalesHeaderRec.Reset;
                                            SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
                                            SalesHeaderRec.SetRange("No.", RegWhseActivityLine."Source No.");
                                            if SalesHeaderRec.FindFirst() then begin
                                                SalesHeaderRec.Invoice := true;
                                                SalesHeaderRec.Ship := true;
                                                SalesHeaderRec.Modify(false);

                                                // YF 02 Dec 2021
                                                SalesPost.Run(SalesHeaderRec);
                                                WarehouseCU.UpdateInvoiceNo(RegWhseActivityLine."Source No.", RegWhseHeader."Whse. Activity No.", true, RegWhseActivityLine."Source Line No.");
                                                // YF 02 Dec 2021

                                                InsertProofTag(SalesHeaderRec, Rec);
                                            end;
                                        end;
                                        //RL    08 Dec 2021
                                        //DX        22 July 201
                                    end;
                                end;
                            end;
                        end;
                    end;
                }
                //DX        21 Aug 2021
                action("Post Inv And Print")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    Enabled = DisableInvPost;
                    trigger OnAction()
                    var
                        WhseShptHdr: Record "Warehouse Shipment Header";
                        WhseShptLine: Record "Warehouse Shipment Line";
                        RegWhseActivityLine: Record "Registered Whse. Activity Line";
                        RegWhseHeader: Record "Registered Whse. Activity Hdr.";
                        ALERec: Record "Assignment Ledger Entry";

                        SalesHeaderRec: Record "Sales Header"; // YF 01 Dec 2021
                        SalesPost: Codeunit "Sales-Post"; // YF 01 Dec 2021
                        SalesInvHeaderRec: Record "Sales Invoice Header"; // YF 02 Dec 2021
                        SalesLineRec: Record "Sales Line"; // YF 14 Dec 2021
                    begin
                        if Confirm('Are you sure you wish to post the invoice?') then begin
                            if PMPCU.IsAOPL(Rec) then begin
                                RegWhseHeader.reset;
                                RegWhseHeader.SetLoadFields("Whse. Activity No.", "No.");        //DX    03 May 2023
                                RegWhseHeader.SetRange("Whse. Activity No.", Rec."No.");
                                if RegWhseHeader.FindFirst() then begin
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                    ALERec.SetRange("Invoice No.", '');
                                    if ALERec.FindFirst() then begin
                                        //DX        18 July 2021    Check that the Picking list is combined and both way bills must be printed already and checked
                                        if Rec."Customer No." <> 'WELLAWAY' THEN begin
                                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                                                if Rec."Checker" = '' then
                                                    Error('Please print Non Cold Room Waybill to confirm checking is complete before posting invoice.');
                                            end
                                            else
                                                if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                                    if Rec."2nd Checker ID" = '' then
                                                        Error('Please print Cold Room Waybill to confirm checking is complete before posting invoice.');
                                                end else
                                                    if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                                                        if (Rec.Checker = '') OR (Rec."2nd Checker ID" = '') then
                                                            Error('Both Non-Cold waybill and Cold waybill must be checked and printed before able to post invoice.\Please check again.');
                                                        Rec."2nd Checker End Time" := CurrentDateTime;
                                                    end;
                                        end;
                                        //DX        18 July 2021
                                        CurrPage.UPDATE(false);
                                        // Rec."Posting Date" := today;
                                        Rec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        Rec.Checker := UserId;
                                        Rec."End Time" := CurrentDateTime;
                                        Rec.Status := Rec.Status::Completed;
                                        Rec.Modify(false);
                                        WarehouseCU.SetBasketAvail(Rec."Basket No.");
                                        if Rec."2nd Basket No." <> '' then
                                            WarehouseCU.SetBasketAvail(Rec."2nd Basket No.");
                                        ALERec.Status := ALERec.Status::Completed;
                                        // ALERec."Posting Date" := today;
                                        ALERec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        ALERec."Invoice No." := ALERec."Document No.";
                                        ALERec.Modify(TRUE);
                                        Message('Assembly Checking completed, please hand over to production for processing.');
                                    end;
                                end;
                            end else begin
                                RegWhseHeader.reset;
                                RegWhseHeader.SetLoadFields("Whse. Activity No.", "No.");        //DX    03 May 2023
                                RegWhseHeader.SetRange("Whse. Activity No.", Rec."No.");
                                if RegWhseHeader.FindFirst() then begin
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                    ALERec.SetRange("Invoice No.", '');
                                    if ALERec.FindFirst() then begin
                                        //DX        18 July 2021    Check that the Picking list is combined and both way bills must be printed already and checked
                                        if Rec."Customer No." <> 'WELLAWAY' THEN begin
                                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                                                if Rec."Checker" = '' then
                                                    Error('Please print Non Cold Room Waybill to confirm checking is complete before posting invoice.');
                                            end
                                            else
                                                if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                                    if Rec."2nd Checker ID" = '' then
                                                        Error('Please print Cold Room Waybill to confirm checking is complete before posting invoice.');
                                                end else
                                                    if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                                                        if (Rec.Checker = '') OR (Rec."2nd Checker ID" = '') then
                                                            Error('Both Non-Cold waybill and Cold waybill must be checked and printed before able to post invoice.\Please check again.');
                                                        Rec."2nd Checker End Time" := CurrentDateTime;
                                                    end;
                                        end;
                                        //DX        18 July 2021
                                        // ALERec."Posting Date" := today;
                                        ALERec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        ALERec.Modify(TRUE);
                                    end;
                                    RegWhseActivityLine.reset;
                                    RegWhseActivityLine.SetLoadFields("No.", "Whse. Document No.");
                                    RegWhseActivityLine.SetRange("No.", RegWhseHeader."No.");
                                    if RegWhseActivityLine.FindFirst() then begin
                                        //DX     14 Jun 2021     Modify the warehouse shipment header to get the current date of posting.
                                        WhseShptHdr.reset;
                                        WhseShptHdr.SetRange("No.", RegWhseActivityLine."Whse. Document No.");
                                        if WhseShptHdr.FindFirst() then begin
                                            // WhseShptHdr.Validate("Posting Date", Today);
                                            WhseShptHdr.Validate("Posting Date", WorkDate);  //RL 28 Dec 2022
                                            WhseShptHdr.Modify(TRUE);
                                        end;
                                        //DX     14 Jun 2021     
                                        WhseShptLine.reset;
                                        WhseShptLine.SetRange("No.", RegWhseActivityLine."Whse. Document No.");
                                        WhseShptLine.SetFilter("Qty. to Ship", '<>0');
                                        if WhseShptLine.FindFirst() then begin
                                            CODEUNIT.RUN(CODEUNIT::"Whse.-Post Shipment + Print", WhseShptLine);

                                            // YF 01 Dec 2021 // Post Sales Invoice
                                            if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Sales Order" then begin
                                                SalesHeaderRec.Reset;
                                                SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
                                                SalesHeaderRec.SetRange("No.", WhseShptLine."Source No.");
                                                if SalesHeaderRec.FindFirst() then begin
                                                    SalesHeaderRec.Invoice := true;
                                                    SalesHeaderRec.Ship := true;
                                                    SalesHeaderRec.Modify(false);

                                                    // YF 14 Dec 2021
                                                    /*
                                                    SalesLineRec.Reset;
                                                    SalesLineRec.SetRange("Document Type", SalesLineRec."Document Type"::Order);
                                                    SalesLineRec.SetRange("Document No.", WhseShptLine."Source No.");
                                                    SalesLineRec.SetRange("Line No.", WhseShptLine."Source Line No.");
                                                    if SalesLineRec.FindFirst() then begin
                                                        SalesLineRec."Qty To Deliver" := SalesLineRec."Order Qty" - WhseShptLine."Qty. to Ship";
                                                        SalesLineRec."FOC (Qty) To Deliver" := 0;
                                                    end;
                                                    */
                                                    // YF 14 Dec 2021

                                                    // YF 02 Dec 2021
                                                    SalesPost.Run(SalesHeaderRec);
                                                    WarehouseCU.UpdateInvoiceNo(WhseShptLine."Source No.", RegWhseHeader."Whse. Activity No.", true, WhseShptLine."Source Line No.");
                                                    // YF 02 Dec 2021

                                                    InsertProofTag(SalesHeaderRec, Rec);
                                                end;

                                            end;
                                            // YF 01 Dec 2021 // Post Sales Invoice

                                            //DX        04 July 2021        After post invoice from checking, assume checker will put on cage to ship out.
                                            if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Outbound Transfer" then
                                                WarehouseCU.UpdateOrderStatus(WhseShptLine."Source No.", 'Completed')
                                            else
                                                WarehouseCU.UpdateOrderStatus(WhseShptLine."Source No.", 'Pending Delivery');
                                            WarehouseCU.SetBasketAvail(Rec."Basket No.");
                                            if Rec."2nd Basket No." <> '' then
                                                WarehouseCU.SetBasketAvail(Rec."2nd Basket No.");
                                            //DX     05 Oct 2021
                                            //DX        22 July 2021
                                            if (Rec."Customer No." = 'WELLAWAY') OR (Rec."Customer No." = 'SAMPLE') THEN begin       //Wellaway Process Only.
                                                ALERec.reset;
                                                ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                                if ALERec.FindFirst() then begin
                                                    ALERec."Check End Time" := CurrentDateTime;
                                                    ALERec."Checker ID" := UserId;
                                                    ALERec.Status := ALERec.Status::Completed;
                                                    ALERec.Modify(TRUE);
                                                end;
                                            end;
                                        end else begin
                                            //RL    08 Dec 2021
                                            SalesHeaderRec.Reset;
                                            SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
                                            SalesHeaderRec.SetRange("No.", RegWhseActivityLine."Source No.");
                                            if SalesHeaderRec.FindFirst() then begin
                                                SalesHeaderRec.Invoice := true;
                                                SalesHeaderRec.Ship := true;
                                                SalesHeaderRec.Modify(false);

                                                // YF 02 Dec 2021
                                                SalesPost.Run(SalesHeaderRec);
                                                WarehouseCU.UpdateInvoiceNo(RegWhseActivityLine."Source No.", RegWhseHeader."Whse. Activity No.", true, RegWhseActivityLine."Source Line No.");
                                                // YF 02 Dec 2021

                                                InsertProofTag(SalesHeaderRec, Rec);
                                            end;
                                            //RL    08 Dec 2021
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                }

                // YF 16 Dec 2021
                action("Post Shipment")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    Enabled = DisableInvPost;
                    trigger OnAction()
                    var
                        WhseShptHdr: Record "Warehouse Shipment Header";
                        WhseShptLine: Record "Warehouse Shipment Line";
                        RegWhseActivityLine: Record "Registered Whse. Activity Line";
                        RegWhseHeader: Record "Registered Whse. Activity Hdr.";
                        ALERec: Record "Assignment Ledger Entry";

                        SalesHeaderRec: Record "Sales Header"; // YF 01 Dec 2021
                        SalesPost: Codeunit "Sales-Post"; // YF 01 Dec 2021
                        SalesInvHeaderRec: Record "Sales Invoice Header"; // YF 02 Dec 2021
                        SalesLineRec: Record "Sales Line"; // YF 14 Dec 2021

                        WhsePost: Codeunit "Whse.-Post Shipment";
                    begin
                        if Confirm('Are you sure you wish to post the Shipment?') then begin
                            if PMPCU.IsAOPL(Rec) then begin
                                RegWhseHeader.reset;
                                RegWhseHeader.SetLoadFields("Whse. Activity No.", "No.");        //DX    03 May 2023
                                RegWhseHeader.SetRange("Whse. Activity No.", Rec."No.");
                                if RegWhseHeader.FindFirst() then begin
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                    ALERec.SetRange("Invoice No.", '');
                                    if ALERec.FindFirst() then begin
                                        //DX        18 July 2021    Check that the Picking list is combined and both way bills must be printed already and checked
                                        if Rec."Customer No." <> 'WELLAWAY' THEN begin
                                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                                                if Rec."Checker" = '' then
                                                    Error('Please print Non Cold Room Waybill to confirm checking is complete before posting invoice.');
                                            end
                                            else
                                                if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                                    if Rec."2nd Checker ID" = '' then
                                                        Error('Please print Cold Room Waybill to confirm checking is complete before posting invoice.');
                                                end else
                                                    if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                                                        if (Rec.Checker = '') OR (Rec."2nd Checker ID" = '') then
                                                            Error('Both Non-Cold waybill and Cold waybill must be checked and printed before able to post invoice.\Please check again.');
                                                        Rec."2nd Checker End Time" := CurrentDateTime;
                                                    end;
                                        end;
                                        //DX        18 July 2021
                                        CurrPage.UPDATE(false);
                                        // Rec."Posting Date" := today;
                                        Rec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        Rec.Checker := UserId;
                                        Rec."End Time" := CurrentDateTime;
                                        Rec.Status := Rec.Status::Completed;
                                        Rec.Modify(false);
                                        WarehouseCU.SetBasketAvail(Rec."Basket No.");
                                        if Rec."2nd Basket No." <> '' then
                                            WarehouseCU.SetBasketAvail(Rec."2nd Basket No.");
                                        ALERec.Status := ALERec.Status::Completed;
                                        // ALERec."Posting Date" := today;
                                        ALERec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        ALERec."Invoice No." := ALERec."Document No.";
                                        ALERec.Modify(TRUE);
                                        Message('Assembly Checking completed, please hand over to production for processing.');
                                    end;
                                end;
                            end else begin
                                RegWhseHeader.reset;
                                RegWhseHeader.SetLoadFields("Whse. Activity No.", "No.");      //DX    03 May 2023
                                RegWhseHeader.SetRange("Whse. Activity No.", Rec."No.");
                                if RegWhseHeader.FindFirst() then begin
                                    ALERec.reset;
                                    ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                    ALERec.SetRange("Invoice No.", '');
                                    if ALERec.FindFirst() then begin
                                        //DX        18 July 2021    Check that the Picking list is combined and both way bills must be printed already and checked
                                        if Rec."Customer No." <> 'WELLAWAY' THEN begin
                                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                                                if Rec."Checker" = '' then
                                                    Error('Please print Non Cold Room Waybill to confirm checking is complete before posting invoice.');
                                            end
                                            else
                                                if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                                    if Rec."2nd Checker ID" = '' then
                                                        Error('Please print Cold Room Waybill to confirm checking is complete before posting invoice.');
                                                end else
                                                    if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin
                                                        if (Rec.Checker = '') OR (Rec."2nd Checker ID" = '') then
                                                            Error('Both Non-Cold waybill and Cold waybill must be checked and printed before able to post invoice.\Please check again.');
                                                        Rec."2nd Checker End Time" := CurrentDateTime;
                                                    end;
                                        end;
                                        //DX        18 July 2021
                                        // ALERec."Posting Date" := today;
                                        ALERec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                        ALERec.Modify(TRUE);
                                    end;
                                    RegWhseActivityLine.reset;
                                    RegWhseActivityLine.SetLoadFields("No.", "Whse. Document No.");  //DX    03 May 2023
                                    RegWhseActivityLine.SetRange("No.", RegWhseHeader."No.");
                                    if RegWhseActivityLine.FindFirst() then begin
                                        //DX     14 Jun 2021     Modify the warehouse shipment header to get the current date of posting.
                                        WhseShptHdr.reset;
                                        WhseShptHdr.SetRange("No.", RegWhseActivityLine."Whse. Document No.");
                                        if WhseShptHdr.FindFirst() then begin
                                            // WhseShptHdr.Validate("Posting Date", Today);
                                            WhseShptHdr.Validate("Posting Date", WorkDate);  //RL 28 Dec 2022
                                            WhseShptHdr.Modify(TRUE);
                                        end;
                                        //DX     14 Jun 2021     
                                        WhseShptLine.reset;
                                        WhseShptLine.SetRange("No.", RegWhseActivityLine."Whse. Document No.");
                                        WhseShptLine.SetFilter("Qty. to Ship", '<>0');
                                        if WhseShptLine.FindFirst() then begin
                                            CurrPage.UPDATE(false);
                                            // Rec."Posting Date" := today;
                                            Rec."Posting Date" := WorkDate;  //RL 28 Dec 2022
                                            Rec.Checker := UserId;
                                            Rec."End Time" := CurrentDateTime;
                                            Rec.Status := Rec.Status::Completed;
                                            Rec.Modify(false);
                                            // CODEUNIT.RUN(CODEUNIT::"Whse.-Post Shipment (Yes/No)", WhseShptLine);

                                            Clear(WhsePost);
                                            WhsePost.SetPostingSettings(false); // dun invoice
                                            WhsePost.SetPrint(false); // dun print
                                            WhsePost.Run(WhseShptLine);

                                            // YF 11 Jan 2021 // Comment since already shipped and don't need to invoice

                                            // YF 02 Dec 2021
                                            // SalesPost.Run(SalesHeaderRec); 
                                            WarehouseCU.UpdateInvoiceNoWithShipNo(WhseShptLine."Source No.", RegWhseHeader."Whse. Activity No.", false, WhseShptLine."Source Line No.");
                                            // YF 02 Dec 2021

                                            // YF 11 Jan 2021 // Comment since already shipped and don't need to invoice

                                            // YF 01 Dec 2021 // Post Sales Invoice
                                            /*
                                            if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Sales Order" then begin
                                                SalesHeaderRec.Reset;
                                                SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
                                                SalesHeaderRec.SetRange("No.", WhseShptLine."Source No.");
                                                if SalesHeaderRec.FindFirst() then begin
                                                    SalesHeaderRec.Invoice := true;
                                                    SalesHeaderRec.Ship := true;
                                                    SalesHeaderRec.Modify(false);

                                                    // YF 14 Dec 2021

                                                    // YF 02 Dec 2021
                                                    SalesPost.Run(SalesHeaderRec);
                                                    WarehouseCU.UpdateInvoiceNo(WhseShptLine."Source No.", RegWhseHeader."Whse. Activity No.", false, WhseShptLine."Source Line No.");
                                                    // YF 02 Dec 2021
                                                end;
                                            end;
                                            */
                                            // YF 01 Dec 2021 // Post Sales Invoice

                                            //DX        04 July 2021        After post invoice from checking, assume checker will put on cage to ship out.
                                            if WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Outbound Transfer" then
                                                WarehouseCU.UpdateOrderStatus(WhseShptLine."Source No.", 'Completed')
                                            else
                                                WarehouseCU.UpdateOrderStatus(WhseShptLine."Source No.", 'Pending Delivery');

                                            WarehouseCU.SetBasketAvail(Rec."Basket No.");
                                            if Rec."2nd Basket No." <> '' then
                                                WarehouseCU.SetBasketAvail(Rec."2nd Basket No.");
                                            //DX     05 Oct 2021                                    
                                            //DX        31 Aug 2021
                                            //DX        22 July 2021
                                            if (Rec."Customer No." = 'WELLAWAY') OR (Rec."Customer No." = 'SAMPLE') THEN begin       //Wellaway Process Only.
                                                ALERec.reset;
                                                ALERec.SetRange("Picking Doc No.", RegWhseHeader."Whse. Activity No.");
                                                if ALERec.FindFirst() then begin
                                                    ALERec."Check End Time" := CurrentDateTime;
                                                    ALERec."Checker ID" := UserId;
                                                    ALERec.Status := ALERec.Status::Completed;
                                                    ALERec.Modify(TRUE);
                                                end;
                                            end;
                                            //RL 10 Jan 2021 - remove being able to invoice with this button
                                            /*
                                        end else begin
                                            ;
                                            //RL    08 Dec 2021
                                            SalesHeaderRec.Reset;
                                            SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
                                            SalesHeaderRec.SetRange("No.", RegWhseActivityLine."Source No.");
                                            if SalesHeaderRec.FindFirst() then begin
                                                SalesHeaderRec.Invoice := true;
                                                SalesHeaderRec.Ship := true;
                                                SalesHeaderRec.Modify(false);

                                                // YF 02 Dec 2021
                                                SalesPost.Run(SalesHeaderRec);
                                                WarehouseCU.UpdateInvoiceNoWithShipNo(RegWhseActivityLine."Source No.", RegWhseHeader."Whse. Activity No.", true, RegWhseActivityLine."Source Line No.");
                                                // YF 02 Dec 2021

                                            end;
                                                  */
                                            //RL 10 Jan 2021
                                        end;
                                        //RL    08 Dec 2021

                                        //DX        22 July 201

                                    end;
                                end;
                            end;
                        end;
                    end;
                }
                // YF 16 Dec 2021
            }

            group(Functions)
            {

                action("Void Checking")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Post;
                    Visible = true;
                    trigger OnAction()
                    var
                        myInt: Integer;
                        PMPEnhance: Codeunit "PMP-Enhancements";
                    begin
                        if Rec.Status = Rec.Status::Completed then
                            Error('Not allowed to void after completion.');
                        PMPEnhance.VoidChecking(Rec);
                    end;
                }

            }


            action("Add Misc Charge")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                Visible = false;
                Enabled = DisableInvPost;
                RunObject = page 55027;
                RunPageLink = "Customer No." = field("Customer No.");
                trigger OnAction()
                var
                    myInt: Integer;

                begin

                end;
            }

            // YF 26 Jul 2021 - Transferred to Report Extension
            //DX        05 Oct 2021

        }
    }

    trigger OnAfterGetRecord()
    begin
        DisableInvPost := PMPCU.DisablePostInvButton(Rec);
        if Rec.Status = Rec.Status::Completed then
            DontDisableComplete := false
        else
            DontDisableComplete := true;


        //DX        13 Aug 2021
        CheckLine.reset;
        CheckLine.SetLoadFields("Doc No."); //DX        03 May 2023
        CheckLine.SetRange("Doc No.", Rec."No.");
        if CheckLine.FindFirst() then begin
            ALERec.reset;
            ALERec.SetLoadFields("Checking Doc No.", "Picking Doc No.");       //DX        03 May 2023
            ALERec.SetRange("Checking Doc No.", CheckLine."Doc No.");
            if ALERec.FindFirst() then begin
                WHHeader.reset;
                WHHeader.SetLoadFields("Whse. Activity No.");       //DX    03 May 2023
                WHHeader.SetCurrentKey("Whse. Activity No.");       //DX    24 May 2023
                WHHeader.SetRange("Whse. Activity No.", ALERec."Picking Doc No.");
                if WHHeader.FindFirst() then begin
                    CurrPage."Other Picking Lines".Page.LoadData(WHHeader);
                    //CurrPage."Org Source Details".Page.LoadData(WHHeader);
                end;

            end;
        end;
        //DX        13 Aug 2021      
        //DX        20 Aug 2021
        if Rec."No." <> '' then begin
            EditBasket := false

        end else begin
            EditBasket := true;
        end;

        //DX        20 Aug 2021

    end;

    local procedure ALEisPosted(DocNo: Code[20]): Boolean
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Picking Doc No.", "Invoice No.");      //DX        24 May 2023
        ALERec.SetRange("Picking Doc No.", DocNo);
        ALERec.SetFilter("Invoice No.", '<>%1', '');
        if ALERec.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    local procedure BeforePrintAction()
    var
        myInt: Integer;
        WhseShptHdr: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        RegWhseActivityLine: Record "Registered Whse. Activity Line";
        RegWhseHeader: Record "Registered Whse. Activity Hdr.";
        ALERec: Record "Assignment Ledger Entry";
    begin

    end;

    local procedure InsertProofTag(SalesHeader: Record "Sales Header"; CheckingHeader: Record "Checking Header")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if SalesHeader."Last Posting No." = '' then
            exit;

        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", SalesHeader."Last Posting No.");
        if SalesInvoiceHeader.FindFirst() then
            OnInsertProofTag(SalesInvoiceHeader, CheckingHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProofTag(SalesInvoiceHeader: Record "Sales Invoice Header"; CheckingHeader: Record "Checking Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckProofTag(CheckingHeader: Record "Checking Header");
    begin
    end;

    local procedure UpdateAssignmentLedger(ErrorType: Text)
    var
        AssignmentLedgerRec: Record "Assignment Ledger Entry";
    begin
        AssignmentLedgerRec.Reset();
        AssignmentLedgerRec.SetLoadFields("Entry No.", "Checking Doc No.", "Picker Error", "Checker Error");
        AssignmentLedgerRec.SetRange("Checking Doc No.", Rec."No.");
        if AssignmentLedgerRec.FindFirst() then begin
            case ErrorType of
                'picker':
                    begin
                        AssignmentLedgerRec."Picker Error" := Rec."Picker Error";
                        AssignmentLedgerRec.Modify(false);
                    end;
                'checker':
                    begin
                        AssignmentLedgerRec."Checker Error" := Rec."Checker Error";
                        AssignmentLedgerRec.Modify(false);
                    end;
            end;
        end;
    end;

    var
        PMPCU: Codeunit "WH-Checking";
        DisableInvPost: Boolean;
        DontDisableComplete: Boolean;
        ScanBasket: code[20];
        WarehouseCU: Codeunit "Warehouse CU";
        WHHeader: Record "Registered Whse. Activity Hdr.";
        CheckLine: Record "Checking Line";
        ALERec: Record "Assignment Ledger Entry";
        EnhanceCU: Codeunit "PMP-Enhancements";
        EditBasket: Boolean;

}