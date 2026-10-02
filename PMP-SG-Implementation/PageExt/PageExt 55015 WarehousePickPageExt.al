pageextension 55015 WarehousePickPageExt extends "Warehouse Pick"
{
    layout
    {

        addafter("No.")
        {
            field(PickType; PickType)
            {
                Caption = 'Pick Type';
                ApplicationArea = all;
                Editable = false;
            }
        }
        addfirst(General)
        {
            field("Basket Code"; Rec."Basket Code")
            {
                ApplicationArea = all;
                Editable = NonColdEdit;
                trigger OnValidate()
                var
                    myInt: Integer;
                    WarehouseCU: Codeunit "Warehouse CU";
                begin
                    if rec."Basket Code" <> xRec."Basket Code" then begin
                        //if xRec."Basket Code" <> '' then
                        //    error('Not allowed to change basket');
                        WarehouseCU.BasketIsUnavail(Rec."Basket Code");
                        WarehouseCU.UpdateBasketAfterPLRetrieved(Rec);
                        WarehouseCU.SetBasketUnavail(Rec."Basket Code");
                        Message('Basket updated.');
                        Rec.Modify(false);
                    end;
                end;

            }
            field("Cold Room Basket Code"; Rec."Cold Room Basket Code")
            {
                ApplicationArea = all;
                Editable = ColdEdit;
                trigger OnValidate()
                var
                    myInt: Integer;
                    WarehouseCU: Codeunit "Warehouse CU";
                    ALERec: Record "Assignment Ledger Entry";
                begin
                    //if Rec."Basket Code" = '' then
                    //    Error('Please scan non cold basket and process non cold picking first before starting cold room.');


                    ALERec.reset;
                    ALERec.SetLoadFields("Picking Doc No.", "Pick Type");     //DX        24 May 2023
                    ALERec.SetCurrentKey("Picking Doc No.", "Pick Type");     //DX        24 May 2023
                    ALERec.SetRange("Picking Doc No.", Rec."No.");
                    ALERec.SetRange("Pick Type", ALERec."Pick Type"::Combined);
                    if ALERec.FindFirst() then begin
                        if WHCU.PLColdPickHasBeenCreated(Rec) then begin
                            if rec."Cold Room Basket Code" <> xRec."Cold Room Basket Code" then begin
                                //if xRec."Basket Code" <> '' then
                                //    error('Not allowed to change basket');
                                WarehouseCU.ColdBasketIsUnavail(Rec."Cold Room Basket Code");
                                WarehouseCU.UpdateColdRoomBasketAfterPLRetrieved(Rec);
                                WarehouseCU.SetBasketUnavail(Rec."Cold Room Basket Code");
                                Message('Basket updated.');
                                Rec.Modify(false);
                            end;
                        end else begin
                            Error('Please click on complete non-cold pick first before scanning cold room basket.');
                        end;
                    end else begin
                        if rec."Cold Room Basket Code" <> xRec."Cold Room Basket Code" then begin
                            //if xRec."Basket Code" <> '' then
                            //    error('Not allowed to change basket');
                            WarehouseCU.ColdBasketIsUnavail(Rec."Cold Room Basket Code");
                            WarehouseCU.UpdateColdRoomBasketAfterPLRetrieved(Rec);
                            WarehouseCU.SetBasketUnavail(Rec."Cold Room Basket Code");
                            Message('Basket updated.');
                            Rec.Modify(false);
                        end;
                    end;
                end;
            }
            field("Priority Pick"; Priority)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //DX        06 Oct 2021
        addafter(WhseActivityLines)
        {
            group(Information)
            {
                field(Name; Name)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Address1; Address1)
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field(Address2; Address2)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PickingInstruction; PickingInstruction)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Picking Instruction';
                }
            }
        }
        //DX        06 Oct 2021
    }


    actions
    {

        // Add changes to page actions here
        addfirst("&Registering")
        {
            action(Complete)
            {
                //DX        09 July 2021
                ApplicationArea = all;
                Caption = 'Complete Non-Cold Pick';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    BasketPage: Page "Basket List";
                    BaskRec: Record Basket;
                    SelBasketRec: Record Basket;
                    ALERec: record "Assignment Ledger Entry";
                begin
                    ALERec.reset;
                    ALERec.SetRange("Picking Doc No.", Rec."No.");
                    ALERec.SetRange("Pick Type", ALERec."Pick Type"::Combined);
                    if ALERec.FindFirst() then begin
                        if NOT (WHCU.PLColdPickHasBeenCreated(Rec)) then begin
                            WHCU.CreateColdTripPickingLine(Rec, rec."Cold Room Basket Code");
                        end else begin
                            Error('Cold trip has been created already, no need to create anymore.');
                        end;
                    end else
                        error('Pick list is not a combined picking, there is no need to create cold trip.')
                end;
                //DX        09 July 2021
            }
            action("View Baskets")
            {
                ApplicationArea = all;
                Caption = 'View Available Baskets';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    BasketList: Record Basket;
                    BasketPage: Page "Basket List";
                    BasketCode: Record Basket;
                    SelBasket: Code[20];
                    WarehouseCU: Codeunit "Warehouse CU";
                    ALERec: Record "Assignment Ledger Entry";
                begin
                    BasketList.reset;
                    BasketList.SetRange(Available, true);
                    //BasketList.SetRange("Cold Room", false);
                    BasketPage.SetTableView(BasketList);
                    BasketPage.Editable := false;
                    //BasketPage.LookupMode(TRUE);
                    BasketPage.Run();
                end;
            }
            action("Reset Basket")
            {
                ApplicationArea = all;
                Caption = 'Reset Assigned Basket';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SelBasket: Code[20];
                    WarehouseCU: Codeunit "Warehouse CU";
                begin
                    if Confirm('Are you sure you wish to reset the basket?') then
                        WarehouseCU.ResetBasket(Rec."Basket Code", Rec);
                end;
            }
            action("Reset Cold Basket")
            {
                ApplicationArea = all;
                Caption = 'Reset Assigned Cold Basket';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SelBasket: Code[20];
                    WarehouseCU: Codeunit "Warehouse CU";
                begin
                    if Confirm('Are you sure you wish to reset the cold basket?') then
                        WarehouseCU.ResetColdBasket(Rec."Basket Code", Rec);
                end;
            }
            /*
                        action("Select Basket")
                        {
                            ApplicationArea = all;
                            Caption = 'Select Basket';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedOnly = true;
                            trigger OnAction()
                            var
                                myInt: Integer;
                                BasketList: Record Basket;
                                BasketPage: Page "Basket List";
                                BasketCode: Record Basket;
                                SelBasket: Code[20];
                                WarehouseCU: Codeunit "Warehouse CU";
                                ALERec: Record "Assignment Ledger Entry";
                            begin
                                //DX    30 Aug 2021
                                ALERec.reset;
                                ALERec.SetRange("Picking Doc No.", Rec."No.");
                                if ALERec.FindFirst() then begin
                                    if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                        if Rec."Cold Room Basket Code" <> '' then
                                            Error('Pick List already has a basket tagged.');
                                    end else
                                        if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then
                                            if Rec."Basket Code" <> '' then
                                                Error('Pick List already has a basket tagged.');
                                end;

                                BasketList.reset;
                                BasketList.SetRange(Available, true);
                                BasketList.SetRange("Cold Room", false);
                                BasketPage.SetTableView(BasketList);
                                BasketPage.LookupMode(TRUE);

                                IF BasketPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    BasketPage.GETRECORD(BasketCode);
                                    if Confirm('Are you sure you wish to select this option?') then begin
                                        Rec."Basket Code" := BasketCode."No.";
                                        Rec.Modify(false);
                                        WarehouseCU.UpdateBasketAfterPLRetrieved(Rec);
                                        WarehouseCU.SetBasketUnavail(Rec."Basket Code");
                                    end;
                                END;

                            end;
                        }
                        action("Select Cold Basket")
                        {
                            ApplicationArea = all;
                            Caption = 'Select Cold Basket';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedOnly = true;
                            trigger OnAction()
                            var
                                myInt: Integer;
                                BasketList: Record Basket;
                                BasketPage: Page "Basket List";
                                BasketCode: Record Basket;
                                SelBasket: Code[20];
                                WarehouseCU: Codeunit "Warehouse CU";
                                ALERec: Record "Assignment Ledger Entry";
                            begin
                                //DX    30 Aug 2021
                                ALERec.reset;
                                ALERec.SetRange("Picking Doc No.", Rec."No.");
                                if ALERec.FindFirst() then begin
                                    if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                                        if Rec."Cold Room Basket Code" <> '' then
                                            Error('Pick List already has a basket tagged.');
                                    end else
                                        if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then
                                            if Rec."Basket Code" <> '' then
                                                Error('Pick List already has a basket tagged.');
                                end;

                                BasketList.reset;
                                BasketList.SetRange(Available, true);
                                BasketList.SetRange("Cold Room", true);
                                BasketPage.SetTableView(BasketList);
                                BasketPage.LookupMode(TRUE);

                                IF BasketPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    BasketPage.GETRECORD(BasketCode);
                                    if Confirm('Are you sure you wish to select this option?') then begin
                                        Rec."Cold Room Basket Code" := BasketCode."No.";
                                        Rec.Modify(false);
                                        WarehouseCU.UpdateBasketAfterPLRetrieved(Rec);
                                        WarehouseCU.SetBasketUnavail(Rec."Basket Code");
                                    end;
                                END;

                            end;
                        }
            */
            action("Fill Qty To Pick")
            {
                ApplicationArea = all;

                Caption = 'Auto Fill Qty To Pick';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    WHActLine: Record "Warehouse Activity Line";
                begin
                    //if Rec."Basket Code" = '' then
                    //    Error('Please select Basket first before processing.');
                    WHActLine.reset;
                    WHActLine.SetCurrentKey("No."); //DX        10 May 2023
                    WHActLine.SetRange("No.", Rec."No.");
                    if WHActLine.FindSet() then
                        repeat
                            WHActLine.Validate("Qty. to Handle", WHActLine."CS Pick Qty");
                            WHActLine.Modify(TRUE);
                        until WHActLine.next = 0;
                end;
            }
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh the page to load the latest data.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    RefreshAddressInfo();
                    //CurrPage.Update(false);
                end;
            }

        }
        modify(RegisterPick)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                ALERec: Record "Assignment Ledger Entry";
            begin
                //DX        08 Sept 2021
                if (Rec."Basket Code" = '') and (Rec."Cold Room Basket Code" = '') then
                    if UserId <> 'BCADMIN' then
                        error('Please select basket before registering.');
                //DX        08 Sept 2021

                ALERec.reset;
                ALERec.SetLoadFields("Picking Doc No.", "Pick Type");    //DX        10 May 2023
                ALERec.SetRange("Picking Doc No.", Rec."No.");
                ALERec.SetRange("Pick Type", ALERec."Pick Type"::Combined);
                if ALERec.FindFirst() then
                    if NOT (WHCU.PLColdPickHasBeenCreated(Rec)) then begin
                        error('Please complete non cold pick first before proceeding to register.')
                        //if (Rec."Basket Code" = '') and (Rec."Cold Room Basket Code" = '') then
                        //    Error('Please select Basket first before processing.');
                    end;
            end;
        }
        modify("Autofill Qty. to Handle")
        {
            ApplicationArea = all;
            Visible = false;
        }

    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        PMPCU: Codeunit "PMP-Enhancements";
        PLLine: Record "Warehouse Activity Line";
        SHRec: Record "Sales Header";
        THRec: Record "Transfer Header";
    begin
        //DX        08 July 2021        Load the voucher information from sales line to warehouse for viewing.
        //DX        13 Aug 2021
        //CurrPage."Other Picking Lines".Page.LoadData(Rec);
        //DX        13 Aug 2021

        //DX        16 July 2021
        if Rec."Assigned User ID" = '' then begin
            Rec."Assigned User ID" := PMPCU.UpdateWhAssignUser(UserId);
            Rec."Assignment Date" := Today;
            Rec."Assignment Time" := Time;
            Rec.Modify(FALSE);
        end;
        ALERec.reset;
        ALERec.SetLoadFields("Picking Doc No.", "Pick Type");    //DX        02 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");    //DX        24 May 2023
        ALERec.SetAscending("Picking Doc No.", false);   //DX        24 May 2023
        ALERec.SetRange("Picking Doc No.", Rec."No.");
        if ALERec.FindFirst() then begin
            if ALERec."Pick Type" = ALERec."Pick Type"::Cold then begin
                ColdEdit := true;
                NonColdEdit := false;
                ScanEdit := true;
            end else
                if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then begin
                    ColdEdit := false;
                    NonColdEdit := true;
                    ScanEdit := true;
                end else begin
                    ColdEdit := true;
                    NonColdEdit := true;
                    ScanEdit := true;
                end;
        end;

        //DX        16 July 2021        
        //DX        30 Aug 2021
        //DX        06 Sept 2021
        PickType := '';
        ALERec.Reset();
        ALERec.SetLoadFields("Picking Doc No.", "Pick Type");    //DX        02 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");    //DX        24 May 2023
        ALERec.SetAscending("Picking Doc No.", false);   //DX        24 May 2023
        ALERec.SetRange("Picking Doc No.", Rec."No.");
        if ALERec.FindFirst() then begin
            PickType := Format(ALERec."Pick Type");
            Priority := ALERec."Priority Picking";
        end;
        //DX        06 Sept 2021

        //DX        06 Oct 2021
        // Name := '';
        // Address1 := '';
        // Address2 := '';
        // Clear(PickingInstruction);
        // PLLine.reset;
        // PLLine.SetLoadFields("No.", "Source Document", "Source No.", "Location Code", "Whse. Document No.", "Whse. Document Type"); //DX        02 May 2023
        // PLLine.SetCurrentKey("No.", "Source Document");  //DX        10 May 2023
        // PLLine.SetAscending("No.", false);  //DX        24 May 2023
        // PLLine.SetRange("No.", Rec."No.");
        // if rec."Source Doc Type" = rec."Source Doc Type"::"Sales Order" then begin

        //     PLLine.SetRange("Source Document", PLLine."Source Document"::"Sales Order");
        //     if PLLine.FindFirst() then begin
        //         SHRec.reset;
        //         SHRec.SetLoadFields("Document Type", "No.", "Sell-to Customer Name", "Sell-to Customer No.", "Sell-to Address", "Sell-to Address 2", "Picking Instructions"); //DX        02 May 2023
        //         SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
        //         SHRec.SetRange("No.", PLLine."Source No.");
        //         if SHRec.FindFirst() then begin
        //             name := SHRec."Sell-to Customer Name";
        //             Address1 := SHRec."Sell-to Address";
        //             Address2 := SHRec."Sell-to Address 2";
        //             PickingInstruction := SHrec."Picking Instructions";
        //         end;
        //     end;
        //     //DX        06 Oct 2021

        // end;
        // if rec."Source Doc Type" = rec."Source Doc Type"::"Outbound Transfer" then begin
        //     PLLine.SetRange("Source Document", PLLine."Source Document"::"Outbound Transfer");
        //     if PLLine.FindFirst() then begin
        //         THRec.reset;
        //         THRec.SetLoadFields("No.", "Transfer-to Code", "Transfer-To Bin Code", "Transfer-to Address", "Transfer-to Address 2", Remarks, "Transfer-to Name"); //DX        02 May 2023
        //         // THRec.SetRange("Document Type", THRec."Document Type"::Order);
        //         THRec.SetRange("No.", PLLine."Source No.");
        //         if THRec.FindFirst() then begin
        //             name := THRec."Transfer-to Name";
        //             Address1 := THRec."Transfer-to Address";
        //             Address2 := THRec."Transfer-to Address 2";
        //             PickingInstruction := THRec.Remarks;
        //         end;
        //     end;
        // end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        PMPCU: Codeunit "PMP-Enhancements";
    begin
        RefreshAddressInfo();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHLine: Record "WH Trip Line";
        PLRec: Record "Warehouse Activity Line";
    begin
        // if UserId <> 'BCADMIN' then //RL    21 Feb 2022
        //DX        05 Apr 2023     to allow the deletion of assembly pick list directly from the picking list screen.
        PLRec.reset;
        PLRec.SetLoadFields("No.", "Source Document");   //DX        24 May 2023
        PLRec.SetRange("No.", Rec."No.");

        //PLRec.SetFilter("Source Document", '%1|%2', PLRec."Source Document"::"Assembly Consumption", PLRec."Source Document"::"Outbound Transfer");
        if PLRec.FindFirst() then begin
            if not (PLRec."Source Document" in [PLRec."Source Document"::"Assembly Consumption", PLRec."Source Document"::"Outbound Transfer", PLRec."Source Document"::"Purchase Return Order"]) then
                Error('Please inform CS to delete warehouse documents for sales order related.');
        end;

        //DX        05 Apr 2023
        //if not (Rec."Source Doc Type" in [rec."Source Doc Type"::"Assembly Consumption", rec."Source Doc Type"::"Outbound Transfer"]) then
        //    Error('Please inform CS to delete warehouse documents.');



        PLRec.reset;
        PLRec.SetRange("No.", Rec."No.");
        PLRec.SetFilter("Source Document", '%1|%2', PLRec."Source Document"::"Assembly Consumption", PLRec."Source Document"::"Outbound Transfer");
        if PLRec.FindFirst() then begin
            WHCU.DeletePLforAOALE(Rec);
        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
        PMPCU: Codeunit "PMP-Enhancements";
        ALERec: Record "Assignment Ledger Entry";
    begin

    end;

    // YF 08 Nov 2021
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetFirstWhsePickLineDetail();
    end;

    local procedure GetFirstWhsePickLineDetail()
    var
        lWhseActivityLineRec: Record "Warehouse Activity Line";
        lPurchaseHeaderRec: Record "Purchase Header";
        lSalesHeaderRec: Record "Sales Header";
    begin
        lWhseActivityLineRec.Reset();
        lWhseActivityLineRec.SetRange("No.", Rec."No.");
        if lWhseActivityLineRec.FindFirst() then begin

            // Handle Purchase
            if lWhseActivityLineRec."Source Type" = 39 then begin
                // Process for Purchase Type
                lPurchaseHeaderRec.Reset();

                // Purchase Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Purchase Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::Order);
                end;

                // Purchase Return Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Purchase Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Purchase Return Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lPurchaseHeaderRec.SetRange("Document Type", lPurchaseHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lPurchaseHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lPurchaseHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := '';
                    Rec."Source Branch" := '';
                    Rec."Source Vend/Cust No." := lPurchaseHeaderRec."Buy-from Vendor No.";
                    Rec."Source Vend/Cust Name" := lPurchaseHeaderRec."Buy-from Vendor Name";
                end;
            end;

            // Handle Sales
            if lWhseActivityLineRec."Source Type" = 37 then begin
                // Process for Sales Type
                lSalesHeaderRec.Reset();

                // Sales Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Sales Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::Order);
                end;

                // Sales Return Order
                if lWhseActivityLineRec."Source Document" = lWhseActivityLineRec."Source Document"::"Sales Return Order" then begin
                    Rec."Source Doc Type" := Rec."Source Doc Type"::"Sales Return Order";
                    Rec."Source Doc No." := lWhseActivityLineRec."Source No.";
                    lSalesHeaderRec.SetRange("Document Type", lSalesHeaderRec."Document Type"::"Return Order");
                end;

                // Set Vendor/Customer Name
                lSalesHeaderRec.SetRange("No.", lWhseActivityLineRec."Source No.");
                if lSalesHeaderRec.FindFirst() then begin
                    Rec."Source Ext Doc No." := lSalesHeaderRec."External Document No.";
                    Rec."Source Branch" := lSalesHeaderRec."Branch/Subsidiary";
                    Rec."Source Vend/Cust No." := lSalesHeaderRec."Sell-to Customer No.";
                    Rec."Source Vend/Cust Name" := lSalesHeaderRec."Sell-to Customer Name";
                end;
            end;

            Rec.Modify(false);

        end;
    end;

    local procedure RefreshAddressInfo()
    var
        PLLine: Record "Warehouse Activity Line";
        SHRec: Record "Sales Header";
        THRec: Record "Transfer Header";
    begin
        Name := '';
        Address1 := '';
        Address2 := '';
        Clear(PickingInstruction);
        PLLine.reset;
        PLLine.SetLoadFields("No.", "Source Document", "Source No.", "Location Code", "Whse. Document No.", "Whse. Document Type");
        PLLine.SetCurrentKey("No.", "Source Document");
        PLLine.SetAscending("No.", false);
        PLLine.SetRange("No.", Rec."No.");
        if rec."Source Doc Type" = rec."Source Doc Type"::"Sales Order" then begin

            PLLine.SetRange("Source Document", PLLine."Source Document"::"Sales Order");
            if PLLine.FindFirst() then begin
                SHRec.reset;
                SHRec.SetLoadFields("Document Type", "No.", "Sell-to Customer Name", "Sell-to Customer No.", "Sell-to Address", "Sell-to Address 2", "Picking Instructions");
                SHRec.SetRange("Document Type", SHRec."Document Type"::Order);
                SHRec.SetRange("No.", PLLine."Source No.");
                if SHRec.FindFirst() then begin
                    name := SHRec."Sell-to Customer Name";
                    Address1 := SHRec."Sell-to Address";
                    Address2 := SHRec."Sell-to Address 2";
                    PickingInstruction := SHrec."Picking Instructions";
                end;
            end;

        end;
        if rec."Source Doc Type" = rec."Source Doc Type"::"Outbound Transfer" then begin
            PLLine.SetRange("Source Document", PLLine."Source Document"::"Outbound Transfer");
            if PLLine.FindFirst() then begin
                THRec.reset;
                THRec.SetLoadFields("No.", "Transfer-to Code", "Transfer-To Bin Code", "Transfer-to Address", "Transfer-to Address 2", Remarks, "Transfer-to Name");
                THRec.SetRange("No.", PLLine."Source No.");
                if THRec.FindFirst() then begin
                    name := THRec."Transfer-to Name";
                    Address1 := THRec."Transfer-to Address";
                    Address2 := THRec."Transfer-to Address 2";
                    PickingInstruction := THRec.Remarks;
                end;
            end;
        end;
    end;

    var
        WHCU: Codeunit "Warehouse CU";
        ColdDone: boolean;
        NonColdEdit: Boolean;
        CanEdit: Boolean;
        ColdEdit: Boolean;
        PickType: Text[20];
        ScanEdit: Boolean;
        Name: Text[100];
        Address1: Text[100];
        Address2: Text[100];
        PickingInstruction: Text[500];
        Priority: Boolean;
    // Shifted to EPaper Integration Extension
    /*
    var
        QRCodeParameters: Text;
    */
}