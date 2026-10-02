pageextension 57000 CheckingCardExt extends "Checking Card"
{
    layout
    {
        // layout changes here
    }

    actions
    {
        addafter("Post Invoice")
        {
            action("Print Non Cold Waybill")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    WSLine: Record "Registered Whse. Activity Line";
                    WSRec: Record "Registered Whse. Activity Hdr.";
                    SHRec: Record "Sales Header";
                    TBARec: Record "TBA Ledger Entry";
                    THRec: Record "Transfer Header";
                    AHRec: Record "Assembly Header";
                    SIHRec: Record "Sales Invoice Header";
                    ALERec: Record "Assignment Ledger Entry";
                    RptWay: Report "Waybill Label";
                    PostRptWay: Report "Posted Inv Waybill Label";
                    TORptWay: Report "TO Waybill Label";
                    AORptWay: Report "Assembly Waybill";
                begin

                    if ALEisPosted(Rec."No.") then begin          //Print way bill from posted invoice details
                        ALERec.reset;
                        ALERec.SetLoadFields("Picking Doc No.");        //DX        16 May 2023
                        ALERec.SetRange("Picking Doc No.", Rec."No.");
                        if ALERec.FindFirst() then begin
                            Clear(RptWay);
                            PostRptWay.SetPLNo(Rec."No.");
                            SIHRec.reset;
                            SIHRec.SetLoadFields("No.", "Delivery Zone"); //DX        16 May 2023
                            SIHRec.SetRange("No.", ALERec."Invoice No.");
                            if SIHRec.FindFirst() then
                                PostRptWay.setDelZone(SIHRec."Delivery Zone");
                            if GotColdItem(Rec."No.") then
                                PostRptWay.SetColdStatus(true)
                            else
                                PostRptWay.SetColdStatus(false);
                            PostRptWay.SetTableView(SIHRec);
                            PostRptWay.Run();
                        end;

                    end else begin          //If not posted yet
                                            //DX        18 July 2021
                        ALERec.reset;
                        ALERec.SetLoadFields("Picking Doc No.", "Pick Type");    //DX        16 May 2023
                        ALERec.SetRange("Picking Doc No.", Rec."No.");
                        if ALERec.FindFirst() then begin
                            if ALERec."Pick Type" = ALERec."Pick Type"::Cold then
                                Error('Please print Cold way bill for Cold Room Items.');
                        end;
                        WSRec.reset;
                        WSRec.SetLoadFields("Whse. Activity No.", "No.");    //DX        16 May 2023
                        WSRec.SetRange("Whse. Activity No.", Rec."No.");
                        if WSRec.FindFirst() then begin
                            WSLine.reset;
                            WSLine.SetLoadFields("No.", "Source Document", "Source No.");   //DX        16 May 2023
                            WSLine.SetRange("No.", WSRec."No.");
                            if WSLine.FindFirst() then begin
                                if WSLine."Source Document" = WSLine."Source Document"::"Sales Order" then begin            // If source is a sales order
                                    SHRec.reset;
                                    SHRec.SetRange("No.", WSLine."Source No.");
                                    if SHRec.FindFirst() then begin
                                        Clear(RptWay);
                                        RptWay.SetPLNo(Rec."No.");
                                        RptWay.setDelZone(Rec."Shipping Bin");
                                        if GotColdItem(Rec."No.") then
                                            RptWay.SetColdStatus(true)
                                        else
                                            RptWay.SetColdStatus(false);
                                        RptWay.SetTableView(SHRec);
                                        RptWay.Run();
                                        //DX        25 July 2021
                                        if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin     //If pick type is combined, only update non cold end time.
                                            Rec."End Time" := CurrentDateTime;
                                            Rec.Modify(true);
                                        end;
                                    end
                                end else
                                    if (WSLine."Source Document" = WSLine."Source Document"::"Inbound Transfer") OR             // if source is a transfer order
                                         (WSLine."Source Document" = WSLine."Source Document"::"Outbound Transfer") then begin
                                        THRec.reset;
                                        THRec.SetRange("No.", WSLine."Source No.");
                                        if THRec.FindFirst() then begin
                                            Clear(RptWay);
                                            TORptWay.SetPLNo(Rec."No.");
                                            TORptWay.setDelZone(Rec."Shipping Bin");
                                            if GotColdItem(Rec."No.") then
                                                TORptWay.SetColdStatus(true)
                                            else
                                                TORptWay.SetColdStatus(false);
                                            TORptWay.SetTableView(THRec);
                                            TORptWay.Run();
                                        end;
                                    end else
                                        if (WSLine."Source Document" = WSLine."Source Document"::"Assembly Consumption") OR
                                          (WSLine."Source Document" = WSLine."Source Document"::"Assembly Order") then begin
                                            AHRec.reset;
                                            AHRec.SetRange("No.", WSLine."Source No.");
                                            if AHRec.FindFirst() then begin
                                                Clear(RptWay);
                                                AORptWay.SetPLNo(Rec."No.");
                                                AORptWay.setDelZone(Rec."Shipping Bin");
                                                if GotColdItem(Rec."No.") then
                                                    AORptWay.SetColdStatus(true)
                                                else
                                                    AORptWay.SetColdStatus(false);
                                                AORptWay.SetTableView(AHRec);
                                                AORptWay.Run();
                                            end;
                                        end;
                            end;
                        end else begin      //if not a pick list, then go check from TBA.
                            TBARec.reset;
                            TBARec.SetRange("Document No.", Rec."No.");
                            if TBARec.FindFirst() then begin
                                SIHRec.reset;
                                SIHRec.SetRange("No.", TBARec."Apply To Doc No.");
                                if SIHRec.FindFirst() then begin
                                    Clear(RptWay);
                                    PostRptWay.SetPLNo(Rec."No.");
                                    PostRptWay.SetColdStatus(false);
                                    PostRptWay.setDelZone(Rec."Shipping Bin");
                                    if GotColdItem(Rec."No.") then
                                        PostRptWay.SetColdStatus(true)
                                    else
                                        PostRptWay.SetColdStatus(false);
                                    PostRptWay.Run();

                                end;
                            end;

                        end;
                        //DX        18 July 2021    Update the checker id after the waybill is printed
                        Rec.Checker := UserId;
                        Rec.Modify(true);
                        ALERec."Checker ID" := UserId;
                        ALERec.Modify(true);
                        //DX        18 July 2021    Update the checker id after the waybill is printed
                        //DX        18 July 2021
                    end;
                end;

            }
            action("Print Cold Waybill")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    WSLine: Record "Registered Whse. Activity Line";
                    WSRec: Record "Registered Whse. Activity Hdr.";
                    SHRec: Record "Sales Header";
                    TBARec: Record "TBA Ledger Entry";
                    SIHRec: Record "Sales Invoice Header";
                    ALERec: Record "Assignment Ledger Entry";
                    RptWay: Report "Waybill Label";
                    TORptWay: Report "TO Waybill Label";
                    PostRptWay: Report "Posted Inv Waybill Label";
                    THRec: Record "Transfer Header";
                    AORptWay: Report "Assembly Waybill";
                    AHRec: Record "Assembly Header";
                begin
                    if ALEisPosted(Rec."No.") then begin        //Print way bill from posted invoice details
                        ALERec.reset;
                        ALERec.SetRange("Picking Doc No.", Rec."No.");
                        if ALERec.FindFirst() then begin
                            SIHRec.reset;
                            SIHRec.SetRange("No.", ALERec."Invoice No.");
                            if SIHRec.FindFirst() then begin
                                Clear(RptWay);
                                PostRptWay.SetPLNo(Rec."No.");
                                PostRptWay.SetColdStatus(true);
                                PostRptWay.setDelZone(Rec."Shipping Bin");
                                if GotColdItem(Rec."No.") then
                                    PostRptWay.SetColdStatus(true)
                                else
                                    PostRptWay.SetColdStatus(false);
                                PostRptWay.SetTableView(SIHRec);
                                PostRptWay.Run();
                            end;
                        end;
                    end else begin
                        //DX        18 July 2021
                        ALERec.reset;
                        ALERec.SetLoadFields("Picking Doc No.", "Pick Type");
                        ALERec.SetRange("Picking Doc No.", Rec."No.");
                        if ALERec.FindFirst() then begin
                            if ALERec."Pick Type" = ALERec."Pick Type"::"Non-Cold" then
                                Error('Please print Non-Cold way bill for Non-Cold Room Items.');
                        end;
                        //DX        18 July 2021

                        WSRec.reset;
                        WSRec.SetRange("Whse. Activity No.", Rec."No.");
                        if WSRec.FindFirst() then begin
                            WSLine.reset;
                            WSLine.SetRange("No.", WSRec."No.");
                            if WSLine.FindFirst() then begin
                                if WSLine."Source Document" = WSLine."Source Document"::"Sales Order" then begin            // If source is a sales order
                                    SHRec.reset;
                                    SHRec.SetRange("No.", WSLine."Source No.");
                                    if SHRec.FindFirst() then begin
                                        Clear(RptWay);
                                        RptWay.SetPLNo(Rec."No.");
                                        RptWay.setDelZone(Rec."Shipping Bin");
                                        if GotColdItem(Rec."No.") then
                                            RptWay.SetColdStatus(true)
                                        else
                                            RptWay.SetColdStatus(false);
                                        RptWay.SetTableView(SHRec);
                                        RptWay.Run();
                                        //DX        25 July 2021
                                        if ALERec."Pick Type" = ALERec."Pick Type"::Combined then begin     //If pick type is combined, only update non cold end time.
                                            Rec."End Time" := CurrentDateTime;
                                            Rec.Modify(true);
                                        end;
                                    end
                                end else
                                    if (WSLine."Source Document" = WSLine."Source Document"::"Inbound Transfer") OR             // if source is a transfer order
                           (WSLine."Source Document" = WSLine."Source Document"::"Outbound Transfer") then begin
                                        THRec.reset;
                                        THRec.SetRange("No.", WSLine."Source No.");
                                        if THRec.FindFirst() then begin
                                            Clear(RptWay);
                                            TORptWay.SetPLNo(Rec."No.");
                                            TORptWay.setDelZone(Rec."Shipping Bin");
                                            if GotColdItem(Rec."No.") then
                                                RptWay.SetColdStatus(true)
                                            else
                                                RptWay.SetColdStatus(false);
                                            TORptWay.SetTableView(THRec);
                                            TORptWay.Run();
                                        end;
                                    end else
                                        if (WSLine."Source Document" = WSLine."Source Document"::"Assembly Consumption") OR
                                  (WSLine."Source Document" = WSLine."Source Document"::"Assembly Order") then begin
                                            AHRec.reset;
                                            AHRec.SetRange("No.", WSLine."Source No.");
                                            if AHRec.FindFirst() then begin
                                                Clear(RptWay);
                                                AORptWay.SetPLNo(Rec."No.");
                                                AORptWay.setDelZone(Rec."Shipping Bin");
                                                if GotColdItem(Rec."No.") then
                                                    AORptWay.SetColdStatus(true)
                                                else
                                                    AORptWay.SetColdStatus(false);
                                                AORptWay.SetTableView(AHRec);
                                                AORptWay.Run();
                                            end;
                                        end;
                            end;
                        end else begin
                            TBARec.reset;
                            TBARec.SetRange("Document No.", Rec."No.");
                            if TBARec.FindFirst() then begin
                                SIHRec.reset;
                                SIHRec.SetRange("No.", TBARec."Apply To Doc No.");
                                if SIHRec.FindFirst() then begin
                                    //DX        18 July 2021    Additional checkbox for cold / non cold room print out
                                    Clear(RptWay);
                                    PostRptWay.SetPLNo(Rec."No.");
                                    PostRptWay.setDelZone(SIHRec."Delivery Zone");
                                    if GotColdItem(SIHRec."Order No.") then
                                        PostRptWay.SetColdStatus(true)
                                    else
                                        PostRptWay.SetColdStatus(false);
                                    PostRptWay.SetTableView(SHRec);
                                    PostRptWay.Run();
                                    //report.Run(55012, true, false, SHRec);
                                    //DX        18 July 2021                                                                    

                                end;
                            end;

                        end;


                        Rec."2nd Checker ID" := UserId;
                        Rec.Modify(true);
                        ALERec."2nd Checker ID" := UserId;
                        ALERec.Modify(TRUE);

                    end;
                end;
            }
            action("Print Posted Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    SIHRec: Record "Sales Invoice Header";
                    ALERec: Record "Assignment Ledger Entry";
                begin
                    ALERec.reset;
                    ALERec.SetLoadFields("Invoice No.", "Checking Doc No.");
                    ALERec.SetRange("Checking Doc No.", Rec."No.");
                    if ALERec.FindFirst() then begin
                        SIHRec.reset;
                        SIHRec.SetRange("No.", ALERec."Invoice No.");
                        if SIHRec.FindFirst() then begin
                            report.Run(57001, true, false, SIHRec);
                        end;
                    end;

                end;
            }
            action("Print Delivery Order")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SetDOFlag;

                trigger OnAction()
                var
                    myInt: Integer;
                    SIHRec: Record "Sales Invoice Header";
                    ALERec: Record "Assignment Ledger Entry";
                    someReDO: Report 57001;
                begin
                    ALERec.reset;
                    ALERec.SetRange("Checking Doc No.", Rec."No.");
                    if ALERec.FindFirst() then begin
                        SIHRec.reset;
                        SIHRec.SetRange("No.", ALERec."Invoice No.");
                        if SIHRec.FindFirst() then begin
                            someReDO.SetDOCheckFlag(SetDOFlag);
                            someReDO.SetTableView(SIHRec);
                            someReDO.RunModal();
                        end;
                    end;

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetDOFlag := false;
    end;

    trigger OnAfterGetRecord()
    var
        SIHRec: Record "Sales Invoice Header";
        ALERec: Record "Assignment Ledger Entry";
        DOCust: Record Customer;
    begin
        ALERec.reset;
        ALERec.SetLoadFields("Checking Doc No.", "Invoice No.");
        ALERec.SetCurrentKey("Checking Doc No.");
        ALERec.SetRange("Checking Doc No.", Rec."No.");
        if ALERec.FindFirst() then begin
            SIHRec.reset;
            SIHRec.SetRange("No.", ALERec."Invoice No.");
            if SIHRec.FindFirst() then begin
                if DOCust.Get(SIHRec."Sell-to Customer No.") then begin
                    SetDOFlag := DOCust.I9G_DONeeded;
                end;
            end;
        end;
    end;

    local procedure ALEisPosted(DocNo: Code[20]): Boolean
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", DocNo);
        ALERec.SetFilter("Invoice No.", '<>%1', '');
        if NOT (ALERec.IsEmpty) then
            exit(true)
        else
            exit(false);
    end;

    local procedure GotColdItem(SHRec: Code[20]): Boolean;
    var
        myInt: Integer;
        ALERec: Record "Assignment Ledger Entry";
        CheckLine: Record "Checking Line";
        ItemRec: Record item;
    begin
        /*
        ALERec.reset;*
        ALERec.SetRange("Checking Doc No.", SHRec);
        if ALERec.FindFirst() then begin
            if (ALERec."Pick Type" = ALERec."Pick Type"::Cold) or (ALERec."Pick Type" = ALERec."Pick Type"::Combined) then
                exit(true)
            else
                exit(false);
        end else
            exit(False);
            */
        CheckLine.reset;
        CheckLine.SetRange("Doc No.", SHRec);
        if CheckLine.FindSet() then begin
            repeat
                if CheckLine."Item No." <> '' then begin
                    ItemRec.reset;
                    ItemRec.get(CheckLine."Item No.");
                    if ItemRec."Storage Condition" = ItemRec."Storage Condition"::Fridge then
                        exit(true);
                end;
            until CheckLine.next = 0;
            exit(false);
        end;
    end;

    var
        RPMPCU: Codeunit "WH-Checking";
        SetDOFlag: Boolean;
}