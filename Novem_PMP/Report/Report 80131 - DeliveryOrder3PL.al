report 80131 "I9G_DeliveryOrder3PL"
{
    DefaultRenderingLayout = "Delivery Order - 3PL";
    Caption = 'Delivery Order';
    ApplicationArea = All;

    dataset
    {
        dataitem("SalesShipmentHeader"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            dataitem(HeaderLoop; Integer)
            {
                column(CompanyLogo; CompanyInformationRec.Picture) { }
                column(CompanyName; CompanyInformationRec.Name) { }
                column(CompanyAddress; CompanyInformationRec.Address) { }
                column(CompanyAddress2; CompanyInformationRec."Address 2") { }
                column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
                column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
                column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
                column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
                column(DocumentNo; TempSalesShipmentHeaderRec."No.") { }
                column(DocumentDate; Format(TempSalesShipmentHeaderRec."Document Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(SelltoCustomerNo; TempSalesShipmentHeaderRec."Sell-to Customer No.") { }
                column(SelltoCustomerName; SellToAddr[1]) { }
                column(SelltoCustomerName2; SellToAddr[2]) { }
                column(SelltoAddress; SellToAddr[3]) { }
                column(SelltoAddress2; SellToAddr[4]) { }
                column(SelltoAddress3; SellToAddr[5]) { }
                column(CustName; ShipToAddr[1]) { }
                column(ShiptoName; ShipToAddr[2]) { }
                column(ShiptoName2; ShipToAddr[3]) { }
                column(ShiptoAddress; ShipToAddr[4]) { }
                column(ShiptoAddress2; ShipToAddr[5]) { }
                column(ShiptoAddress3; ShipToAddr[6]) { }
                column(ShipToTel; ShipToAddr[7]) { }
                column(ShipToFax; ShipToFax) { }
                column(ShipToEmail; ShipToEmail) { }
                column(Purchaser; TempSalesShipmentHeaderRec.I9G_Purchaser) { }
                column(DRIC; TempSalesShipmentHeaderRec.I9G_DRIC) { }
                column(Remarks; TempSalesShipmentHeaderRec.I9G_Remarks) { }
                column(PaymentTermsCode; TempSalesShipmentHeaderRec."Payment Terms Code") { }
                column(ExternalDocNo; TempSalesShipmentHeaderRec."External Document No.") { }
                column(Salesperson; SalesEmployeeName) { }
                column(Admin; TempSalesShipmentHeaderRec.I9G_Admin) { }
                column(CaseNumber; TempSalesShipmentHeaderRec.I9G_CaseNumber) { }
                column(ShipmentDate; Format(TempSalesShipmentHeaderRec."Shipment Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(SignedOrder; TempSalesShipmentHeaderRec.I9G_SignedOrder) { }
                column(DeliveryOrder; TempSalesShipmentHeaderRec.I9G_DeliveryOrder) { }
                column(ReportHeader; ReportHeader) { }
                column(ReportHeader2; ReportHeader2) { }
                column(ReportHeader3; ReportHeader3) { }
                column(ReportFooter; ReportFooter) { }
                column(ReportFooter2; ReportFooter2) { }
                column(ReportFooter3; ReportFooter3) { }
                column(ReportFooter4; ReportFooter4) { }
                column(ReportFooter5; ReportFooter5) { }
                column(ShowSignatuure; ShowSignatuure) { }
                dataitem(LineLoop; Integer)
                {
                    column(SNNo; SNNo) { }
                    column(ItemType; TempSalesShipmentLineRec.Type) { }
                    column(ItemCode; TempSalesShipmentLineRec."No.") { }
                    column(ItemDescription; TempSalesShipmentLineRec.Description) { }
                    column(ItemDescription2; Description2) { }
                    column(Quantity; TempSalesShipmentLineRec.Quantity) { }
                    column(UOMCode; TempSalesShipmentLineRec."Unit of Measure Code") { }
                    column(HSARegistrationNo; HSARegistrationNo) { }
                    column(ProdClassificationCode; ProdClassificationCode) { }

                    trigger OnPreDataItem()
                    begin
                        TempSalesShipmentLineRec.Reset();
                        SetRange(Number, 1, TempSalesShipmentLineRec.Count);
                        Clear(SNNo);
                        Clear(Chr);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        FromCompanyItemRec: Record Item;
                        FromCompanyItemLedgerEntryRec: Record "Item Ledger Entry";
                    begin
                        if Number = 1 then
                            TempSalesShipmentLineRec.FindFirst()
                        else
                            TempSalesShipmentLineRec.Next();

                        if TempSalesShipmentLineRec.Type = TempSalesShipmentLineRec.Type::Item then begin
                            SNNo += 1;
                            Chr := 10;
                        end;

                        Clear(Description2);
                        FromCompanyItemLedgerEntryRec.Reset();
                        if FromCompanyItemLedgerEntryRec.ChangeCompany(FilterCompanyName) then begin
                            FromCompanyItemLedgerEntryRec.SetRange("Document Type", FromCompanyItemLedgerEntryRec."Document Type"::"Sales Shipment");
                            FromCompanyItemLedgerEntryRec.SetRange("Document No.", TempSalesShipmentLineRec."Document No.");
                            FromCompanyItemLedgerEntryRec.SetRange("Document Line No.", TempSalesShipmentLineRec."Line No.");
                            FromCompanyItemLedgerEntryRec.SetRange("Item No.", TempSalesShipmentLineRec."No.");
                            if FromCompanyItemLedgerEntryRec.FindSet() then begin
                                repeat
                                    if Description2 = '' then
                                        Description2 := 'BN : ' + FromCompanyItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(FromCompanyItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(FromCompanyItemLedgerEntryRec.Quantity))
                                    else
                                        Description2 += Chr + 'BN : ' + FromCompanyItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(FromCompanyItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(FromCompanyItemLedgerEntryRec.Quantity));
                                until FromCompanyItemLedgerEntryRec.Next() = 0;
                            end;
                        end;
                        FromCompanyItemRec.Reset();
                        if FromCompanyItemRec.ChangeCompany(FilterCompanyName) then begin
                            if FromCompanyItemRec.Get(TempSalesShipmentLineRec."No.") then begin
                                HSARegistrationNo := FromCompanyItemRec.I9G_HSARegistrationNo;
                                ProdClassificationCode := FromCompanyItemRec.I9G_ProdClassificationCode;
                            end;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        TempSalesShipmentLineRec.DeleteAll();
                    end;
                }
                trigger OnPreDataItem()
                begin
                    TempSalesShipmentHeaderRec.Reset();
                    SetRange(Number, 1, TempSalesShipmentHeaderRec.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempSalesShipmentHeaderRec.FindFirst()
                    else
                        TempSalesShipmentHeaderRec.Next();
                end;

                trigger OnPostDataItem()
                begin
                    TempSalesShipmentHeaderRec.DeleteAll();
                end;
            }
            trigger OnPreDataItem()
            var
            begin
                CompanyInformationRec.Reset();
                if CompanyInformationRec.ChangeCompany(FilterCompanyName) then begin
                    CompanyInformationRec.Get();
                    CompanyInformationRec.CalcFields(Picture);
                end;
                SetFilter("No.", FilterShipmentHeaderNo);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                ChangeCompanyRec(SalesShipmentHeader);
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
                group(Options)
                {
                    field(FilterCompanyName; FilterCompanyName)
                    {
                        Caption = 'Company Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(FilterShipmentHeaderNo; FilterShipmentHeaderNo)
                    {
                        Caption = 'Delivery Order No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    rendering
    {
        layout("Delivery Order - 3PL")
        {
            Type = RDLC;
            LayoutFile = './ReportLayout/Rpt80131-DeliveryOrder3PL.rdl';
        }
    }

    var
        CompanyInformationRec: Record "Company Information";
        TempSalesShipmentHeaderRec: Record "Sales Shipment Header" temporary;
        TempSalesShipmentLineRec: Record "Sales Shipment Line" temporary;
        FilterCompanyName: Text;
        FilterShipmentHeaderNo: Text;
        ShowSignatuure: Boolean;
        SNNo: Integer;
        ShipToTel: Text[30];
        ShipToFax: Text[30];
        ShipToEmail: Text[80];
        Description2: Text;
        ReportHeader: Text[50];
        ReportHeader2: Text[50];
        ReportHeader3: Text[50];
        ReportFooter: Text[2048];
        ReportFooter2: Text[200];
        ReportFooter3: Text[200];
        ReportFooter4: Text[200];
        ReportFooter5: Text[200];
        ShortcutDimCode: array[8] of Code[20];
        GLSetupShortcutDimCode: array[8] of Code[20];
        SalesEmployeeName: Text[50];
        HSARegistrationNo: Text[20];
        ProdClassificationCode: Code[25];
        SellToAddr: array[6] of Text[250];
        ShipToAddr: array[7] of Text[250];
        Chr: Char;
        n, i, x : integer;

    procedure GetReportOptionAndFilter(par_FromCompanyName: Text[30]; par_SalesShipmentHeaderNo: Text)
    var
    begin
        FilterCompanyName := par_FromCompanyName;
        FilterShipmentHeaderNo := par_SalesShipmentHeaderNo;
    end;

    procedure ChangeCompanyRec(par_SalesShipmentHeaderRec: Record "Sales Shipment Header")
    var
        FromCompanySalesShipmentHeaderRec: Record "Sales Shipment Header";
        FromCompanySalesShipmentLineRec: Record "Sales Shipment Line";
        FromCompanyShipToAddressRec: Record "Ship-to Address";
        FromCompanyDimensionValue: Record "Dimension Value";
        FromCompanySalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        DimMgt: Codeunit DimensionManagement;
        NovemCU: Codeunit I9G_NovemEventSubscribers;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        DimensionValueRec: Record "Dimension Value";
    begin
        I9G_ThirdPartyLogisticSetupRec.Reset();
        I9G_ThirdPartyLogisticSetupRec.Get();
        if I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany = '' then begin
            ShowSignatuure := false;
        end;
        FromCompanySalesShipmentHeaderRec.Reset();
        if FromCompanySalesShipmentHeaderRec.ChangeCompany(FilterCompanyName) then begin
            FromCompanySalesShipmentHeaderRec.SetRange(I9G_ShipmentNo, par_SalesShipmentHeaderRec."No.");
            if FromCompanySalesShipmentHeaderRec.FindFirst() then begin
                TempSalesShipmentHeaderRec.Reset();
                TempSalesShipmentHeaderRec.Init();
                TempSalesShipmentHeaderRec.TransferFields(FromCompanySalesShipmentHeaderRec);
                TempSalesShipmentHeaderRec.Insert();

                Clear(ReportHeader);
                Clear(ReportHeader2);
                Clear(ReportHeader3);
                Clear(ReportFooter);
                Clear(ReportFooter2);
                Clear(ReportFooter3);
                Clear(ReportFooter4);
                Clear(ReportFooter5);
                if FromCompanySalesReceivablesSetupRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesReceivablesSetupRec.Get();
                    if SalesShipmentHeader.I9G_SignedOrder = true then begin
                        ReportHeader := 'SIGNED ORDER';
                        ReportHeader2 := 'SIGNED ORDER / PICK LIST NO. :';
                        ReportHeader3 := 'ORDERED BY :';
                        ReportFooter := FromCompanySalesReceivablesSetupRec.I9G_SignedOrderFooter;
                        ReportFooter2 := 'GOODS PACKED BY / CHECKED BY :';
                        ReportFooter3 := 'STORE SIGNATURE / AUTHORISED SIGNATURE';
                        ReportFooter4 := 'GOODS ORDERED BY :';
                        ReportFooter5 := 'AUTHORISED SIGNATURE';
                    end else begin
                        ReportHeader := 'DELIVERY ORDER';
                        ReportHeader2 := 'DELIVERY ORDER NO. :';
                        ReportHeader3 := 'BILL TO :';
                        ReportFooter := FromCompanySalesReceivablesSetupRec.I9G_DeliveryOrderFooter;
                        ReportFooter2 := 'FOR ' + UpperCase(CompanyInformationRec.Name);
                        ReportFooter3 := 'AUTHORISED SIGNATURE';
                        ReportFooter4 := 'RECEIVED IN GOOD CONDITION';
                        ReportFooter5 := 'CUSTOMER SIGNATURE AND DATE';
                    end;
                    FromCompanyShipToAddressRec.Reset();
                    if FromCompanyShipToAddressRec.ChangeCompany(FilterCompanyName) then begin
                        FromCompanyShipToAddressRec.SetRange("Customer No.", FromCompanySalesShipmentHeaderRec."Sell-to Customer No.");
                        FromCompanyShipToAddressRec.SetRange(Code, FromCompanySalesShipmentHeaderRec."Ship-to Code");
                        if FromCompanyShipToAddressRec.FindFirst() then begin
                            Clear(ShipToTel);
                            Clear(ShipToFax);
                            Clear(ShipToEmail);
                            ShipToTel := FromCompanyShipToAddressRec."Phone No.";
                            ShipToFax := FromCompanyShipToAddressRec."Fax No.";
                            ShipToEmail := FromCompanyShipToAddressRec."E-Mail";
                        end;
                    end;
                end;

                NovemCU.FormatSelltoAddressNovem(SellToAddr, '', FromCompanySalesShipmentHeaderRec."Sell-to Customer Name", FromCompanySalesShipmentHeaderRec."Sell-to Customer Name 2", FromCompanySalesShipmentHeaderRec."Bill-to Address", FromCompanySalesShipmentHeaderRec."Bill-to Address 2", FromCompanySalesShipmentHeaderRec.I9G_BillToAddress3);
                NovemCU.FormatShiptoAddressNovem(ShipToAddr, FromCompanySalesShipmentHeaderRec."Sell-to Customer Name", FromCompanySalesShipmentHeaderRec."Ship-to Name", FromCompanySalesShipmentHeaderRec."Ship-to Name 2", FromCompanySalesShipmentHeaderRec."Ship-to Address", FromCompanySalesShipmentHeaderRec."Ship-to Address 2", FromCompanySalesShipmentHeaderRec.I9G_ShipToAddress3, ShipToTel);

                FromCompanySalesShipmentLineRec.Reset();
                if FromCompanySalesShipmentLineRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesShipmentLineRec.SetRange("Document No.", FromCompanySalesShipmentHeaderRec."No.");
                    if FromCompanySalesShipmentLineRec.FindSet() then begin
                        Clear(SalesEmployeeName);
                        Clear(ShortcutDimCode);
                        GetShortcutDimensions(FromCompanySalesShipmentLineRec."Dimension Set ID", ShortcutDimCode, FilterCompanyName);
                        if ShortcutDimCode[7] <> '' then begin
                            DimensionValueRec.Reset();
                            if DimensionValueRec.ChangeCompany(FilterCompanyName) then begin
                                if DimensionValueRec.Get(GLSetupShortcutDimCode[7], ShortcutDimCode[7]) then
                                    SalesEmployeeName := ShortcutDimCode[7] + '/' + DimensionValueRec.Name
                                else
                                    SalesEmployeeName := ShortcutDimCode[7];
                            end;
                        end;
                        repeat
                            TempSalesShipmentLineRec.Reset();
                            TempSalesShipmentLineRec.Init();
                            TempSalesShipmentLineRec.TransferFields(FromCompanySalesShipmentLineRec);
                            TempSalesShipmentLineRec.Insert();
                        until FromCompanySalesShipmentLineRec.Next() = 0;
                    end;
                end;
            end else begin
                Error('The delivery order does not exists in partner company [%1]', FilterCompanyName);
            end;
        end;
    end;

    procedure GetShortcutDimensions(DimSetID: Integer; var ShortcutDimCode: array[8] of Code[20]; par_FromCompanyName: Text)
    var
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
    begin
        Clear(ShortcutDimCode);
        if DimSetID = 0 then
            exit;
        GeneralLedgerSetupRec.Reset();
        if GeneralLedgerSetupRec.ChangeCompany(par_FromCompanyName) then begin
            GeneralLedgerSetupRec.Get();
            GLSetupShortcutDimCode[1] := GeneralLedgerSetupRec."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GeneralLedgerSetupRec."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GeneralLedgerSetupRec."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GeneralLedgerSetupRec."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GeneralLedgerSetupRec."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GeneralLedgerSetupRec."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GeneralLedgerSetupRec."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GeneralLedgerSetupRec."Shortcut Dimension 8 Code";
            for x := 1 to 8 do
                if GLSetupShortcutDimCode[x] <> '' then
                    ShortcutDimCode[x] := GetDimSetEntry(DimSetID, GLSetupShortcutDimCode[x], par_FromCompanyName);
        end;
    end;


    local procedure GetDimSetEntry(DimSetID: Integer; DimCode: Code[20]; par_FromCompanyName: Text): Code[20]
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if TempDimSetEntry.Get(DimSetID, DimCode) then
            exit(TempDimSetEntry."Dimension Value Code");

        TempDimSetEntry.Init();
        if DimensionSetEntry.ChangeCompany(par_FromCompanyName) then begin
            if DimensionSetEntry.Get(DimSetID, DimCode) then
                TempDimSetEntry := DimensionSetEntry
            else begin
                TempDimSetEntry."Dimension Set ID" := DimSetID;
                TempDimSetEntry."Dimension Code" := DimCode;
            end;
        end;
        TempDimSetEntry.Insert();
        exit(TempDimSetEntry."Dimension Value Code");
    end;
}