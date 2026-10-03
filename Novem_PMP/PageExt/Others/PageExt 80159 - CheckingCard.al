pageextension 80159 CheckCardExt3PL extends "Checking Card"
{
    layout
    {
        modify(ScanBasket)
        {
            trigger OnAfterValidate()
            var
            begin
                /*Get Novem Customer Details from PMP Sales Order or Posted Sales Invoice*/
                ShowNovemCustomerDetails();
            end;
        }
        addlast(General)
        {
            group("3PL Customer Information")
            {
                Visible = GroupVisibile;
                field(I9G_NovemCustomerName; Rec.I9G_NovemCustomerName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Customer Name field.';
                }
                field(I9G_NovemShipToCustomerName; Rec.I9G_NovemShipToCustomerName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Customer Name field.';
                }
                field(I9G_NovemShipToCustomerName2; Rec.I9G_NovemShipToCustomerName2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Novem Ship-to Customer Name 2 field.';
                }
                field(I9G_NovemCustomerAddress; Rec.I9G_NovemCustomerAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Customer Address field.';
                }
                field(I9G_NovemCustomerAddress2; Rec.I9G_NovemCustomerAddress2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Customer Address 2 field.';
                }
                field(I9G_NovemCustomerOpsHr; Rec.I9G_NovemCustomerOpsHr)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Working Hours field.';
                    MultiLine = true;
                }
                field(I9G_NovemCustomerDelInstr; Rec.I9G_NovemCustomerDelInstr)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Instruction field.';
                    MultiLine = true;
                }
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("TaxInvoice3PL")
            {
                Caption = 'Tax Invoice (3PL)';
                ApplicationArea = All;
                Image = SalesInvoice;
                ToolTip = 'Print Tax Invoice (3PL).';
                trigger OnAction()
                var
                    TaxInvoiceReport: Report I9G_TaxInvoice3PL;
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                    I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
                    RecRef: RecordRef;
                    AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
                begin
                    AssignmentLedgerEntryRec.Reset();
                    AssignmentLedgerEntryRec.SetRange("Picking Doc No.", Rec."No.");
                    AssignmentLedgerEntryRec.SetFilter("Invoice No.", '<>%1', '');
                    if AssignmentLedgerEntryRec.FindFirst() then begin
                        SalesInvoiceHeaderRec.Reset();
                        SalesInvoiceHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
                        if SalesInvoiceHeaderRec.FindFirst() then begin
                            //DX        21 July 2026
                            I9G_ThirdPartyLogisticCodeUnit.CheckPMPInvLineAnd3PLInvLine(salesinvoiceheaderrec."No.", salesinvoiceheaderrec.I9G_FromCompanyName);
                            //DX        21 July 2026                            
                            RecRef.GetTable(SalesInvoiceHeaderRec);
                            TaxInvoiceReport.GetReportOptionAndFilter(SalesInvoiceHeaderRec.I9G_FromCompanyName, I9G_ThirdPartyLogisticCodeUnit.GetSelectionFilter(RecRef, SalesInvoiceHeaderRec.FieldNo("No.")), SalesInvoiceHeaderRec.I9G_NovemCustNoOfCopies);
                            TaxInvoiceReport.RunModal();
                        end else begin
                            Error('Please use the Delivery Order (3PL).');
                        end;
                    end else begin
                        Error('The Invoice No. cannot be found.');
                    end;
                end;
            }
            action("DeliveryOrder3PL")
            {
                Caption = 'Delivery Order (3PL)';
                ApplicationArea = All;
                Image = SalesInvoice;
                ToolTip = 'Print Delivery Order (3PL).';
                trigger OnAction()
                var
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                    SalesShipmentHeaderRec: Record "Sales Shipment Header";
                    AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
                    NovemSalesHeaderRec: Record "Sales Header";
                    NovemSalesLineRec: Record "Sales Line";
                    NovemSalesInvoiceHeaderRec: Record "Sales Invoice Header";
                    NovemSalesShipmentHeaderRec: Record "Sales Shipment Header";
                    I9G_ThirdPartyLogisticCU: Codeunit I9G_ThirdPartyLogisticCU;
                    SalesReceivableSetupRec: Record "Sales & Receivables Setup";
                    DeliverOrderReport: Report I9G_DeliveryOrder3PL;
                    I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
                    RecRef: RecordRef;
                    SILRec: Record "Sales Invoice Line";
                    VLERec: Record "Value Entry";
                    ILErec: Record "Item Ledger Entry";
                begin
                    AssignmentLedgerEntryRec.Reset();
                    AssignmentLedgerEntryRec.SetCurrentKey("Picking Doc No.", "Invoice No.");
                    AssignmentLedgerEntryRec.SetLoadFields("Picking Doc No.", "Invoice No.");
                    AssignmentLedgerEntryRec.SetRange("Picking Doc No.", Rec."No.");
                    AssignmentLedgerEntryRec.SetFilter("Invoice No.", '<>%1', '');
                    if AssignmentLedgerEntryRec.FindFirst() then begin
                        SalesShipmentHeaderRec.Reset();
                        SalesShipmentHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
                        SalesShipmentHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
                        SalesShipmentHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
                        if SalesShipmentHeaderRec.FindFirst() then begin
                            RecRef.GetTable(SalesShipmentHeaderRec);
                            DeliverOrderReport.GetReportOptionAndFilter(SalesShipmentHeaderRec.I9G_FromCompanyName, I9G_ThirdPartyLogisticCodeUnit.GetSelectionFilter(RecRef, SalesShipmentHeaderRec.FieldNo("No.")));
                            DeliverOrderReport.RunModal();
                        end else begin
                            SILRec.reset;
                            SILRec.SetCurrentKey(Type, "No.", "Document No.");
                            SILRec.SetLoadFields(Type, "No.", "Document No.");
                            SILRec.SetRange(Type, SILRec.Type::Item);
                            SILRec.SetFilter("No.", '<>%1', '');
                            SILRec.SetRange("Document No.", AssignmentLedgerEntryRec."Invoice No.");
                            if SILRec.FindFirst() then begin
                                VLERec.reset;
                                VLERec.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                                VLERec.SetLoadFields("Document Type", "Document No.", "Document Line No.");
                                VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
                                VLERec.SetRange("Document No.", SILRec."Document No.");
                                VLERec.SetRange("Document Line No.", SILRec."Line No.");
                                if VLERec.FindFirst then begin
                                    ILErec.reset;
                                    ILErec.SetCurrentKey("Document Type", "Entry No.");
                                    ILErec.SetRange("Document Type", ILErec."Document Type"::"Sales Shipment");
                                    ILErec.SetRange("Entry No.", VLERec."Item Ledger Entry No.");
                                    if ILErec.FindFirst() then begin
                                        SalesShipmentHeaderRec.Reset();
                                        SalesShipmentHeaderRec.SetCurrentKey("No.");
                                        SalesShipmentHeaderRec.SetRange("No.", ILErec."Document No.");
                                        if SalesShipmentHeaderRec.FindFirst() then begin
                                            RecRef.GetTable(SalesShipmentHeaderRec);
                                            DeliverOrderReport.GetReportOptionAndFilter(SalesShipmentHeaderRec.I9G_FromCompanyName, I9G_ThirdPartyLogisticCodeUnit.GetSelectionFilter(RecRef, SalesShipmentHeaderRec.FieldNo("No.")));
                                            DeliverOrderReport.RunModal();
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end else begin
                        Error('The Invoice No. cannot be found.');
                    end;
                end;
            }
            action("NonColdWaybill3PL")
            {
                Caption = 'Non-Cold Waybill (3PL)';
                ApplicationArea = All;
                Image = Delivery;
                ToolTip = 'Print Non-Cold Waybill (3PL).';
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
                    RptWay: Report I9G_WaybillLabel3PL;
                    PostRptWay: Report I9G_PostedInvWaybillLabel3PL;
                    TORptWay: Report I9G_TOWaybillLabel3PL;
                    AORptWay: Report I9G_AssemblyWaybill3PL;
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
            action("ColdWaybill3PL")
            {
                Caption = 'Cold Waybill (3PL)';
                ApplicationArea = All;
                Image = Delivery;
                ToolTip = 'Print Cold Waybill (3PL).';
                trigger OnAction()
                var
                    WSLine: Record "Registered Whse. Activity Line";
                    WSRec: Record "Registered Whse. Activity Hdr.";
                    SHRec: Record "Sales Header";
                    TBARec: Record "TBA Ledger Entry";
                    SIHRec: Record "Sales Invoice Header";
                    ALERec: Record "Assignment Ledger Entry";
                    RptWay: Report I9G_WaybillLabel3PL;
                    TORptWay: Report I9G_TOWaybillLabel3PL;
                    PostRptWay: Report I9G_PostedInvWaybillLabel3PL;
                    THRec: Record "Transfer Header";
                    AORptWay: Report I9G_AssemblyWaybill3PL;
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
            action("Update3PLInvoiceAndDO")
            {
                Caption = 'Update 3PL Inv/DO';
                ApplicationArea = All;
                Image = SalesInvoice;
                ToolTip = 'Update 3PL Inv/DO';

                trigger OnAction()
                var
                    DeliverOrderReport: Report I9G_DeliveryOrder3PL;
                    SalesShipmentHeaderRec: Record "Sales Shipment Header";
                    I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
                    RecRef: RecordRef;
                    AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
                    SILRec: Record "Sales Invoice Line";
                    VLERec: Record "Value Entry";
                    ILErec: Record "Item Ledger Entry";
                    thirdCU: Codeunit I9G_ThirdPartyLogisticCU;
                    PMPInvoiceNo: code[20];
                    NovemInvNo: code[20];
                    NovemSHipNo: code[20];
                    PmpShipNo: code[20];
                    NovSIHRec: Record "Sales Invoice Header";
                    NovSSHRec: Record "Sales Shipment Header";
                    OrderNo: code[20];
                begin
                    if Confirm('Are you sure you wish to automatically patch this order in Novem?') then begin
                        clear(PMPInvoiceNo);
                        clear(PmpShipNo);
                        clear(NovemInvNo);
                        clear(NovemSHipNo);
                        clear(OrderNo);
                        AssignmentLedgerEntryRec.Reset();
                        AssignmentLedgerEntryRec.SetCurrentKey("Picking Doc No.", "Invoice No.");
                        AssignmentLedgerEntryRec.SetLoadFields("Picking Doc No.", "Invoice No.");
                        AssignmentLedgerEntryRec.SetRange("Picking Doc No.", Rec."No.");
                        AssignmentLedgerEntryRec.SetFilter("Invoice No.", '<>%1', '');
                        if AssignmentLedgerEntryRec.FindFirst() then begin
                            PMPInvoiceNo := AssignmentLedgerEntryRec."Invoice No.";
                            SILRec.reset;
                            SILRec.SetCurrentKey(Type, "No.", "Document No.");
                            SILRec.SetLoadFields(Type, "No.", "Document No.");
                            SILRec.SetRange(Type, SILRec.Type::Item);
                            SILRec.SetFilter("No.", '<>%1', '');
                            SILRec.SetRange("Document No.", AssignmentLedgerEntryRec."Invoice No.");
                            if SILRec.FindFirst() then begin
                                OrderNo := SILRec."Order No.";
                                VLERec.reset;
                                VLERec.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                                VLERec.SetLoadFields("Document Type", "Document No.", "Document Line No.");
                                VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
                                VLERec.SetRange("Document No.", SILRec."Document No.");
                                VLERec.SetRange("Document Line No.", SILRec."Line No.");
                                if VLERec.FindFirst then begin
                                    ILErec.reset;
                                    ILErec.SetCurrentKey("Document Type", "Entry No.");
                                    ILErec.SetLoadFields("Document Type", "Entry No.", "Document No.");
                                    ILErec.SetRange("Document Type", ILErec."Document Type"::"Sales Shipment");
                                    ILErec.SetRange("Entry No.", VLERec."Item Ledger Entry No.");
                                    if ILErec.FindFirst() then begin
                                        PmpShipNo := ILErec."Document No.";
                                    end;
                                end;
                            end;
                            //start of novem entity patching.
                            NovSIHRec.reset;
                            NovSIHRec.ChangeCompany('NOVEM-NHC');
                            NovSIHRec.SetRange("Order No.", OrderNo);
                            if NovSIHRec.FindFirst() then begin
                                thirdCU.UpdateInvNoAtNovem(NovemInvNo, PMPInvoiceNo);
                                VLERec.reset;
                                VLERec.ChangeCompany('NOVEM-NHC');
                                VLERec.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                                VLERec.SetLoadFields("Document Type", "Document No.", "Document Line No.");
                                VLERec.SetRange("Document Type", VLERec."Document Type"::"Sales Invoice");
                                VLERec.SetRange("Document No.", NovSIHRec."No.");
                                if VLERec.FindFirst then begin
                                    ILErec.reset;
                                    ILErec.ChangeCompany('NOVEM-NHC');
                                    ILErec.SetLoadFields("Document Type", "Entry No.", "Document No.");
                                    ILErec.SetCurrentKey("Document Type", "Entry No.");
                                    ILErec.SetRange("Document Type", ILErec."Document Type"::"Sales Shipment");
                                    ILErec.SetRange("Entry No.", VLERec."Item Ledger Entry No.");
                                    if ILErec.FindFirst() then begin
                                        NovemSHipNo := ILErec."Document No.";
                                    end;
                                end;
                                NovSSHRec.reset;
                                NovSSHRec.SetRange("No.", NovemSHipNo);
                                if NovSSHRec.FindFirst() then begin
                                    thirdCU.UpdateShipNoAtNovem(NovemSHipNo, PmpShipNo);
                                end;
                                Message(StrSubstNo('Patched %1 to %2, %3 to %4', NovemInvNo, PMPInvoiceNo, NovemSHipNo, PmpShipNo));
                            end else begin
                                Error('Not able to find posted Novem Invoice, please check.');
                            end;
                        end;
                    end;
                end;
            }
            action(PostDocument3PL)
            {
                Caption = 'Post Document (3PL)';
                ApplicationArea = All;
                Image = PostDocument;
                ToolTip = 'Post Document (3PL).';
                trigger OnAction()
                var
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                    SalesShipmentHeaderRec: Record "Sales Shipment Header";
                    AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
                    NovemSalesHeaderRec: Record "Sales Header";
                    NovemSalesLineRec: Record "Sales Line";
                    I9G_ThirdPartyLogisticCU: Codeunit I9G_ThirdPartyLogisticCU;
                    SalesReceivableSetupRec: Record "Sales & Receivables Setup";
                begin
                    AssignmentLedgerEntryRec.Reset();
                    AssignmentLedgerEntryRec.SetCurrentKey("Picking Doc No.", "Invoice No.");
                    AssignmentLedgerEntryRec.SetLoadFields("Picking Doc No.", "Invoice No.");
                    AssignmentLedgerEntryRec.SetRange("Picking Doc No.", Rec."No.");
                    AssignmentLedgerEntryRec.SetFilter("Invoice No.", '<>%1', '');
                    if AssignmentLedgerEntryRec.FindFirst() then begin
                        SalesReceivableSetupRec.Get();
                        if (SalesReceivableSetupRec."Posted Invoice Nos." <> '') and (SalesReceivableSetupRec."Posted Shipment Nos." <> '') then begin
                            if IsNoSeriesForSalesInvoice(SalesReceivableSetupRec."Posted Invoice Nos.", AssignmentLedgerEntryRec."Invoice No.") = true then begin
                                SalesInvoiceHeaderRec.Reset();
                                SalesInvoiceHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
                                SalesInvoiceHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
                                SalesInvoiceHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
                                if SalesInvoiceHeaderRec.FindFirst() then begin
                                    NovemSalesHeaderRec.Reset();
                                    if NovemSalesHeaderRec.ChangeCompany(SalesInvoiceHeaderRec.I9G_FromCompanyName) then begin
                                        NovemSalesHeaderRec.SetRange("Document Type", NovemSalesHeaderRec."Document Type"::Order);
                                        NovemSalesHeaderRec.SetRange("No.", SalesInvoiceHeaderRec.I9G_SONo);
                                        if NovemSalesHeaderRec.FindFirst() then begin
                                            if NovemSalesHeaderRec.Status <> NovemSalesHeaderRec.Status::Open then begin
                                                NovemSalesHeaderRec.Status := NovemSalesHeaderRec.Status::Open;
                                                NovemSalesHeaderRec.Invoice := true;
                                                NovemSalesHeaderRec.Modify(true);
                                                Commit();
                                            end;
                                            NovemSalesLineRec.Reset();
                                            if NovemSalesLineRec.ChangeCompany(SalesInvoiceHeaderRec.I9G_FromCompanyName) then begin
                                                NovemSalesLineRec.SetRange("Document Type", NovemSalesHeaderRec."Document Type");
                                                NovemSalesLineRec.SetRange("Document No.", NovemSalesHeaderRec."No.");
                                                if NovemSalesLineRec.FindSet() then begin
                                                    repeat
                                                        NovemSalesLineRec.Validate("Qty. to Invoice", (NovemSalesLineRec."Quantity" - NovemSalesLineRec."Quantity Invoiced"));
                                                        NovemSalesLineRec.Modify();
                                                    until NovemSalesLineRec.Next() = 0;
                                                end;
                                            end;
                                            I9G_ThirdPartyLogisticCU.CreateJobQueueToPostSalesDocument(SalesInvoiceHeaderRec.I9G_FromCompanyName, NovemSalesHeaderRec.RecordId);
                                            Message('Posting the partner company sales invoice document.');
                                        end else begin
                                            Error('The Sales Order document is not found in the partner company.');
                                        end;
                                    end;
                                end;
                            end else begin
                                SalesShipmentHeaderRec.Reset();
                                SalesShipmentHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
                                SalesShipmentHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
                                SalesShipmentHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
                                if SalesShipmentHeaderRec.FindFirst() then begin
                                    NovemSalesHeaderRec.Reset();
                                    if NovemSalesHeaderRec.ChangeCompany(SalesShipmentHeaderRec.I9G_FromCompanyName) then begin
                                        NovemSalesHeaderRec.SetRange("Document Type", NovemSalesHeaderRec."Document Type"::Order);
                                        NovemSalesHeaderRec.SetRange("No.", SalesShipmentHeaderRec.I9G_SONo);
                                        if NovemSalesHeaderRec.FindFirst() then begin
                                            if NovemSalesHeaderRec.Status <> NovemSalesHeaderRec.Status::Open then begin
                                                NovemSalesHeaderRec.Status := NovemSalesHeaderRec.Status::Open;
                                                NovemSalesHeaderRec.Ship := true;
                                                NovemSalesHeaderRec.Modify(true);
                                                Commit();
                                            end;
                                            NovemSalesLineRec.Reset();
                                            if NovemSalesLineRec.ChangeCompany(SalesShipmentHeaderRec.I9G_FromCompanyName) then begin
                                                NovemSalesLineRec.SetRange("Document Type", NovemSalesHeaderRec."Document Type");
                                                NovemSalesLineRec.SetRange("Document No.", NovemSalesHeaderRec."No.");
                                                if NovemSalesLineRec.FindSet() then begin
                                                    repeat
                                                        NovemSalesLineRec.Validate("Qty. to Ship", (NovemSalesLineRec.Quantity - NovemSalesLineRec."Quantity Shipped"));
                                                        NovemSalesLineRec.Modify();
                                                    until NovemSalesLineRec.Next() = 0;
                                                end;
                                            end;
                                            I9G_ThirdPartyLogisticCU.CreateJobQueueToPostSalesDocument(SalesShipmentHeaderRec.I9G_FromCompanyName, NovemSalesHeaderRec.RecordId);
                                            Message('Posting the partner company sales shipment document.');
                                        end else begin
                                            Error('The Sales Order document is not found in the partner company.');
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end else begin
                        Error('The Invoice No. cannot be found.');
                    end;
                end;
            }
            action(ShowNovemCustomerDetails)
            {
                Caption = 'Show Novem Customer Details (3PL)';
                ApplicationArea = All;
                Image = PostDocument;
                ToolTip = 'Show Novem Customer Details (3PL).';
                trigger OnAction()
                var
                begin
                    /*Get Novem Customer Details from PMP Sales Order or Posted Sales Invoice*/
                    //ShowNovemCustomerDetails();
                    /*Get Novem Customer Details from Novem Ship-to details*/
                    I9G_ThirdPartyLogisticCU.ShowNovemCustomerDetailsFromShipTo(Rec);
                end;
            }
            action(Update3PLDocumentNo)
            {
                Caption = 'Update Posted Inv/Ship No.(3PL)';
                ApplicationArea = All;
                Image = PostDocument;
                ToolTip = 'Update Posted Document No. (3PL).';
                Visible = GroupVisibile;
                trigger OnAction()
                var
                    AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                    SalesShipmentHeaderRec: Record "Sales Shipment Header";
                    SalesInvoiceLineRec: Record "Sales Invoice Line";
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    ValueEntryRec: Record "Value Entry";
                    SalesReceivableSetupRec: Record "Sales & Receivables Setup";
                    I9G_ThirdPartyLogisticCU: Codeunit I9G_ThirdPartyLogisticCU;
                    SONO, InvoiceNo, ShipmentNo : Code[20];
                    FromCompanyName: Text;
                begin
                    Clear(SONO);
                    Clear(InvoiceNo);
                    Clear(ShipmentNo);
                    Clear(FromCompanyName);
                    AssignmentLedgerEntryRec.Reset();
                    AssignmentLedgerEntryRec.SetCurrentKey("Picking Doc No.", "Invoice No.", "Document No.");
                    AssignmentLedgerEntryRec.SetLoadFields("Picking Doc No.", "Invoice No.", "Document No.");
                    AssignmentLedgerEntryRec.SetRange("Picking Doc No.", Rec."No.");
                    AssignmentLedgerEntryRec.SetFilter("Invoice No.", '<>%1', '');
                    if AssignmentLedgerEntryRec.FindFirst() then begin
                        SalesReceivableSetupRec.Get();
                        if (SalesReceivableSetupRec."Posted Invoice Nos." <> '') and (SalesReceivableSetupRec."Posted Shipment Nos." <> '') then begin
                            if IsNoSeriesForSalesInvoice(SalesReceivableSetupRec."Posted Invoice Nos.", AssignmentLedgerEntryRec."Invoice No.") = true then begin
                                SalesInvoiceHeaderRec.Reset();
                                SalesInvoiceHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
                                if SalesInvoiceHeaderRec.FindFirst() then begin
                                    SalesInvoiceLineRec.Reset();
                                    SalesInvoiceLineRec.SetCurrentKey(Type, "No.", "Document No.", Quantity);
                                    SalesInvoiceLineRec.SetLoadFields(Type, "No.", "Document No.", Quantity);
                                    SalesInvoiceLineRec.SetRange("Document No.", SalesInvoiceHeaderRec."No.");
                                    SalesInvoiceLineRec.SetRange(Type, SalesInvoiceLineRec.Type::Item);
                                    SalesInvoiceLineRec.SetFilter("No.", '<>%1', '');
                                    SalesInvoiceLineRec.SetFilter(Quantity, '<>%1', 0);
                                    if SalesInvoiceLineRec.FindFirst() then begin
                                        ValueEntryRec.Reset();
                                        ValueEntryRec.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                                        ValueEntryRec.SetLoadFields("Document Type", "Document No.", "Document Line No.");
                                        ValueEntryRec.SetRange("Document Type", ValueEntryRec."Document Type"::"Sales Invoice");
                                        ValueEntryRec.SetRange("Document No.", SalesInvoiceLineRec."Document No.");
                                        ValueEntryRec.SetRange("Document Line No.", SalesInvoiceLineRec."Line No.");
                                        if ValueEntryRec.FindFirst then begin
                                            ItemLedgerEntryRec.Reset();
                                            ItemLedgerEntryRec.SetCurrentKey("Document Type", "Entry No.", "Document No.");
                                            ItemLedgerEntryRec.SetLoadFields("Document Type", "Entry No.", "Document No.");
                                            ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Sales Shipment");
                                            ItemLedgerEntryRec.SetRange("Entry No.", ValueEntryRec."Item Ledger Entry No.");
                                            if ItemLedgerEntryRec.FindFirst() then begin
                                                SONO := SalesInvoiceHeaderRec.I9G_SONo;
                                                InvoiceNo := SalesInvoiceHeaderRec."No.";
                                                ShipmentNo := ItemLedgerEntryRec."Document No.";
                                                FromCompanyName := SalesInvoiceHeaderRec.I9G_FromCompanyName;
                                                I9G_ThirdPartyLogisticCU.UpdateSalesInvoice(SONO, InvoiceNo, ShipmentNo, FromCompanyName);
                                                I9G_ThirdPartyLogisticCU.UpdateSalesShipment(SONO, InvoiceNo, ShipmentNo, FromCompanyName);
                                                Message('Invoice No. and Shipment No. updated in the partner company [%1]', FromCompanyName);
                                            end
                                        end;
                                    end;
                                end;
                            end else begin
                                SalesShipmentHeaderRec.Reset();
                                SalesShipmentHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
                                if SalesShipmentHeaderRec.FindFirst() then begin
                                    I9G_ThirdPartyLogisticCU.UpdateSalesShipment(SalesShipmentHeaderRec.I9G_SONo, '', SalesShipmentHeaderRec."No.", SalesShipmentHeaderRec.I9G_FromCompanyName);
                                    Message('Shipment No. updated in the partner company [%1]', SalesShipmentHeaderRec.I9G_FromCompanyName);
                                end;
                            end;
                        end;
                    end;
                end;
            }
        }
        addlast(Promoted)
        {
            group(Reports3PL)
            {
                Caption = 'Reports (3PL)';
                actionref(TaxInvoice3PL_Promoted; TaxInvoice3PL) { }
                actionref(DeliveryOrder3PL_Promoted; DeliveryOrder3PL) { }
                actionref(NonColdWaybill3PL_Promoted; NonColdWaybill3PL) { }
                actionref(ColdWaybill3PL_Promoted; ColdWaybill3PL) { }
            }
            group(Functions3PL)
            {
                Caption = 'Functions (3PL)';
                actionref(Update3PLDocumentNo_Promoted; Update3PLDocumentNo) { }
                actionref(PostDocument3PL_Promoted; PostDocument3PL) { }
                actionref(ShowNovemCustomerDetails_Promoted; ShowNovemCustomerDetails) { }
            }
        }
    }
    trigger OnOpenPage()
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
    begin
        ReportVisible := false;
        if (I9G_ThirdPartyLogisticSetupRec.Get()) then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (I9G_ThirdPartyLogisticCodeUnit.CheckCompanyName = false) then begin
                ReportVisible := true;
            end;
        end;
        GroupVisibile := GroupVisibility;
    end;

    trigger OnAfterGetRecord()
    var
    begin
        GroupVisibile := GroupVisibility;
    end;

    var
        ReportVisible: Boolean;
        GroupVisibile: Boolean;
        I9G_ThirdPartyLogisticCU: Codeunit I9G_ThirdPartyLogisticCU;

    local procedure GroupVisibility(): Boolean
    var
    begin
        if Rec."Customer Name" = 'NOVEM HEALTHCARE PTE LTD' then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;

    local procedure ALEisPosted(DocNo: Code[20]): Boolean
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", DocNo);
        ALERec.SetFilter("Invoice No.", '<>%1', '');
        if ALERec.FindFirst() then
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

    local procedure IsNoSeriesForSalesInvoice(SeriesCode: Code[20]; DocumentNo: Code[20]): Boolean
    var
        NoSeriesLineRec: Record "No. Series Line";
    begin
        NoSeriesLineRec.Reset();
        NoSeriesLineRec.SetRange("Series Code", SeriesCode);
        if NoSeriesLineRec.FindFirst() then begin
            repeat
                if (DocumentNo >= NoSeriesLineRec."Starting No.") then begin
                    exit(true);
                end;
            until NoSeriesLineRec.Next() = 0;
        end;
        exit(false);
    end;

    local procedure ShowNovemCustomerDetails()
    var
        SalesInvoiceHeaderRec: Record "Sales Invoice Header";
        AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
        SalesHeaderRec: Record "Sales Header";
    begin
        /*Get Novem Customer Details from PMP Sales Order or Posted Sales Invoice*/
        Rec.I9G_NovemCustomerName := '';
        Rec.I9G_NovemShipToCustomerName := '';
        Rec.I9G_NovemShipToCustomerName2 := '';
        Rec.I9G_NovemCustomerAddress := '';
        Rec.I9G_NovemCustomerAddress2 := '';
        Rec.I9G_NovemCustomerAddress3 := '';
        Rec.I9G_NovemCustomerOpsHr := '';
        Rec.I9G_NovemCustomerDelInstr := '';
        AssignmentLedgerEntryRec.Reset();
        AssignmentLedgerEntryRec.SetCurrentKey("Picking Doc No.", "Invoice No.", "Document No.");
        AssignmentLedgerEntryRec.SetLoadFields("Picking Doc No.", "Invoice No.", "Document No.");
        AssignmentLedgerEntryRec.SetRange("Picking Doc No.", Rec."No.");
        if AssignmentLedgerEntryRec.FindFirst() then begin
            SalesInvoiceHeaderRec.Reset();
            SalesInvoiceHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Invoice No.");
            SalesInvoiceHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
            SalesInvoiceHeaderRec.SetFilter(I9G_CustVendName, '<>%1', '');
            SalesInvoiceHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
            if SalesInvoiceHeaderRec.FindFirst() then begin
                Rec.I9G_NovemCustomerName := SalesInvoiceHeaderRec.I9G_CustVendName;
                Rec.I9G_NovemShipToCustomerName := SalesInvoiceHeaderRec.I9G_NovemShipToCustomerName;
                Rec.I9G_NovemShipToCustomerName2 := SalesInvoiceHeaderRec.I9G_NovemShipToCustomerName2;
                Rec.I9G_NovemCustomerAddress := SalesInvoiceHeaderRec.I9G_NovemShipToAddress;
                Rec.I9G_NovemCustomerAddress2 := SalesInvoiceHeaderRec.I9G_NovemShipToAddress2;
                Rec.I9G_NovemCustomerOpsHr := SalesInvoiceHeaderRec.I9G_NovemShipToAddress3;
                Rec.I9G_NovemCustomerDelInstr := SalesInvoiceHeaderRec."Delivery Instructions";
            end else begin
                SalesHeaderRec.Reset();
                SalesHeaderRec.SetRange("No.", AssignmentLedgerEntryRec."Document No.");
                SalesHeaderRec.SetFilter(I9G_FromCompanyName, '<>%1', '');
                SalesHeaderRec.SetFilter(I9G_CustVendName, '<>%1', '');
                SalesHeaderRec.SetFilter(I9G_SONo, '<>%1', '');
                if SalesHeaderRec.FindFirst() then begin
                    Rec.I9G_NovemCustomerName := SalesHeaderRec.I9G_CustVendName;
                    Rec.I9G_NovemShipToCustomerName := SalesHeaderRec.I9G_NovemShipToCustomerName;
                    Rec.I9G_NovemShipToCustomerName2 := SalesHeaderRec.I9G_NovemShipToCustomerName2;
                    Rec.I9G_NovemCustomerAddress := SalesHeaderRec.I9G_NovemShipToAddress;
                    Rec.I9G_NovemCustomerAddress2 := SalesHeaderRec.I9G_NovemShipToAddress2;
                    Rec.I9G_NovemCustomerOpsHr := SalesHeaderRec.I9G_NovemShipToAddress3;
                    Rec.I9G_NovemCustomerDelInstr := SalesHeaderRec."Delivery Instructions";
                end;
            end;
            Rec.Modify();
        end;
    end;

}