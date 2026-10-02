report 80130 "I9G_TaxInvoice3PL"
{
    DefaultRenderingLayout = "Tax Invoice - 3PL";
    Caption = 'Sales Tax Invoice';
    ApplicationArea = All;

    dataset
    {
        dataitem("SalesInvoiceHeader"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            dataitem(HeaderLoop; Integer)
            {
                column(CompanyLogo; CompanyInformationRec.Picture) { }
                column(CompanyQRCode; CompanyInformationRec.I9G_QRCode) { }
                column(CompanyName; CompanyInformationRec.Name) { }
                column(CompanyAddress; CompanyInformationRec.Address) { }
                column(CompanyAddress2; CompanyInformationRec."Address 2") { }
                column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
                column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
                column(CompanyEmail; CompanyInformationRec."E-Mail") { }
                column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
                column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
                column(CompanyPayNow; CompanyInformationRec.I9G_Paynow) { }
                column(CompanyBankAccountNo; CompanyInformationRec."Bank Account No.") { }
                column(CompanyBankName; CompanyInformationRec."Bank Name") { }
                column(CompanyBankCode; CompanyInformationRec.I9G_BankCode) { }
                column(CompanyBranchCode; CompanyInformationRec."Bank Branch No.") { }
                column(CompanySwiftCode; CompanyInformationRec."SWIFT Code") { }
                column(DocumentNo; TempSalesInvoiceHeaderRec."No.") { }
                column(LastShipmentNo; LastShipmentNo) { }
                column(DocumentDate; Format(TempSalesInvoiceHeaderRec."Document Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(SelltoCustomerNo; TempSalesInvoiceHeaderRec."Sell-to Customer No.") { }
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
                column(Purchaser; TempSalesInvoiceHeaderRec.I9G_Purchaser) { }
                column(DRIC; TempSalesInvoiceHeaderRec.I9G_DRIC) { }
                column(Remarks; TempSalesInvoiceHeaderRec.I9G_Remarks) { }
                column(PaymentTermsCode; TempSalesInvoiceHeaderRec."Payment Terms Code") { }
                column(ExternalDocNo; TempSalesInvoiceHeaderRec."External Document No.") { }
                column(Salesperson; SalesEmployeeName) { }
                column(Admin; TempSalesInvoiceHeaderRec.I9G_Admin) { }
                column(CaseNumber; TempSalesInvoiceHeaderRec.I9G_CaseNumber) { }
                column(ShipmentDate; Format(TempSalesInvoiceHeaderRec."Shipment Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(CurrencyCode; CurrencyCode) { }
                column(TotalAmount; TotalAmount) { }
                column(VATPercentageText; VATPercentageText) { }
                column(TotalVATAmount; TotalVATAmount) { }
                column(TotalAmountInclVAT; TotalAmountInclVAT) { }
                column(AmountInText; OutputString) { }
                column(ReportFooter; Footer) { }
                column(ShowTitleTaxWord; ShowTitleTaxWord) { }
                column(CaseDoctor; TempSalesInvoiceHeaderRec.I9G_CaseDoctor) { }
                column(DateUsed; Format(TempSalesInvoiceHeaderRec.I9G_DateUsed, 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(ConsignmentTaxInvoice; ConsignmentTaxInvoice) { }
                column(ShowSignatuure; ShowSignatuure) { }
                column(NoOfCopies; OutputNo) { }
                dataitem(LineLoop; Integer)
                {
                    column(SNNo; SNNo) { }
                    column(ItemType; TempSalesInvoiceLineRec.Type) { }
                    column(ItemCode; TempSalesInvoiceLineRec."No.") { }
                    column(ItemDescription; TempSalesInvoiceLineRec.Description) { }
                    column(ItemDescription2; Description2) { }
                    column(Quantity; TempSalesInvoiceLineRec.Quantity) { }
                    column(UOMCode; TempSalesInvoiceLineRec."Unit of Measure Code") { }
                    column(UnitPrice; TempSalesInvoiceLineRec."Unit Price") { }
                    column(LineDiscountAmount; DiscountedAmount) { }
                    column(LineAmount; TempSalesInvoiceLineRec."Line Amount") { }
                    column(HSARegistrationNo; HSARegistrationNo) { }
                    column(ProdClassificationCode; ProdClassificationCode) { }
                    column(Location_Code; TempSalesInvoiceLineRec."Location Code") { }
                    trigger OnPreDataItem()
                    begin
                        TempSalesInvoiceLineRec.Reset();
                        SetRange(Number, 1, TempSalesInvoiceLineRec.Count);
                        Clear(SNNo);
                        Clear(Chr);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        FromCompanyItemRec: Record Item;
                        FromCompanyItemLedgerEntryRec: Record "Item Ledger Entry";
                        TempSalesShipmentLineRec: Record "Sales Shipment Line" temporary;
                    begin
                        if Number = 1 then
                            TempSalesInvoiceLineRec.FindFirst()
                        else
                            TempSalesInvoiceLineRec.Next();

                        if TempSalesInvoiceLineRec.Type = TempSalesInvoiceLineRec.Type::Item then begin
                            if TempSalesInvoiceLineRec.Quantity = 0 then
                                CurrReport.Skip();
                            SNNo += 1;
                            Chr := 10;
                        end;
                        Clear(Description2);
                        RptGetSalesShptLines(TempSalesShipmentLineRec, TempSalesInvoiceLineRec);
                        if TempSalesShipmentLineRec.FindFirst() then begin
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
                        end else begin
                            FromCompanyItemLedgerEntryRec.Reset();
                            if FromCompanyItemLedgerEntryRec.ChangeCompany(FilterCompanyName) then begin
                                FromCompanyItemLedgerEntryRec.SetRange("Document Type", FromCompanyItemLedgerEntryRec."Document Type"::"Sales Invoice");
                                FromCompanyItemLedgerEntryRec.SetRange("Document No.", TempSalesInvoiceLineRec."Document No.");
                                FromCompanyItemLedgerEntryRec.SetRange("Document Line No.", TempSalesInvoiceLineRec."Line No.");
                                FromCompanyItemLedgerEntryRec.SetRange("Item No.", TempSalesInvoiceLineRec."No.");
                                if FromCompanyItemLedgerEntryRec.FindSet() then begin
                                    repeat
                                        if Description2 = '' then
                                            Description2 := 'BN : ' + FromCompanyItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(FromCompanyItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(FromCompanyItemLedgerEntryRec.Quantity))
                                        else
                                            Description2 += Chr + 'BN : ' + FromCompanyItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(FromCompanyItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(FromCompanyItemLedgerEntryRec.Quantity));
                                    until FromCompanyItemLedgerEntryRec.Next() = 0;
                                end;
                            end;
                        end;

                        FromCompanyItemRec.Reset();
                        if FromCompanyItemRec.ChangeCompany(FilterCompanyName) then begin
                            if FromCompanyItemRec.Get(TempSalesInvoiceLineRec."No.") then begin
                                HSARegistrationNo := FromCompanyItemRec.I9G_HSARegistrationNo;
                                ProdClassificationCode := FromCompanyItemRec.I9G_ProdClassificationCode;
                            end;
                        end;

                        If TempSalesInvoiceLineRec."Line Discount %" <> 0 then begin
                            DiscountedAmount := TempSalesInvoiceLineRec."Unit Price" - (TempSalesInvoiceLineRec."Unit Price" * (TempSalesInvoiceLineRec."Line Discount %" / 100));
                        end else begin
                            DiscountedAmount := 0;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        //TempSalesInvoiceLineRec.DeleteAll();
                    end;
                }
                trigger OnPreDataItem()
                begin
                    //DX        06 Oct 2025
                    //TempSalesInvoiceHeaderRec.Reset();
                    //SetRange(Number, 1, TempSalesInvoiceHeaderRec.Count);
                    //SetRange(Number, 1, NoOfCopies + TempSalesInvoiceHeaderRec.I9G_NovemCustNoOfCopies);
                    NoOfLoops := ABS(NoOfCopies) + NoOfLoops;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;

                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;

                trigger OnAfterGetRecord()
                begin
                    //    TempSalesInvoiceHeaderRec.FindFirst();

                    IF Number > 1 THEN BEGIN
                        OutputNo += 1;
                    END;
                    if Number = 1 then
                        TempSalesInvoiceHeaderRec.FindFirst()
                    else
                        TempSalesInvoiceHeaderRec.Next();
                end;

                trigger OnPostDataItem()
                begin
                    TempSalesInvoiceHeaderRec.DeleteAll();
                end;
            }
            trigger OnPreDataItem()
            var
            begin
                CompanyInformationRec.Reset();
                if CompanyInformationRec.ChangeCompany(FilterCompanyName) then begin
                    CompanyInformationRec.Get();
                    CompanyInformationRec.CalcFields(Picture, I9G_QRCode);
                end;

                SetFilter("No.", FilterInvoiceHeaderNo);
            end;

            trigger OnAfterGetRecord()
            var
                SalesInvoiceLineRec: Record "Sales Invoice Line";
                ShipToAddressRec: Record "Ship-to Address";
                DimensionValue: Record "Dimension Value";
                DimMgt: Codeunit DimensionManagement;
                NovemCU: Codeunit I9G_NovemEventSubscribers;
            begin
                ChangeCompanyRec(SalesInvoiceHeader);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Copies';
                    }
                    field(FilterCompanyName; FilterCompanyName)
                    {
                        Caption = 'Company Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(FilterInvoiceHeaderNo; FilterInvoiceHeaderNo)
                    {
                        Caption = 'Tax Invoice No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(ShowTitleTaxWord; ShowTitleTaxWord)
                    {
                        ApplicationArea = all;
                        Caption = 'Foreign Tax Invoice';
                    }
                    field(ConsignmentTaxInvoice; ConsignmentTaxInvoice)
                    {
                        ApplicationArea = All;
                        Caption = 'Consignment Tax Invoice';
                    }
                }
            }
        }
    }
    rendering
    {
        layout("Tax Invoice - 3PL")
        {
            Type = RDLC;
            LayoutFile = './ReportLayout/Rpt80130-TaxInvoice3PL.rdl';
        }
    }

    local procedure getLastShipmentNo(par_SalesInvoiceHeader: Record "Sales Invoice Header"): Code[20]
    var
        FromCompanyValueEntryRec: Record "Value Entry";
        FromCompanyItemLedgerEntryRec: Record "Item Ledger Entry";
        FromCompanySalesShipmentLineRec: Record "Sales Shipment Line";
    begin
        FromCompanyValueEntryRec.Reset();
        if FromCompanyValueEntryRec.ChangeCompany(FilterCompanyName) then begin
            FromCompanyValueEntryRec.SetCurrentKey("Document No.");
            FromCompanyValueEntryRec.SetRange("Document No.", par_SalesInvoiceHeader."No.");
            FromCompanyValueEntryRec.SetRange("Document Type", FromCompanyValueEntryRec."Document Type"::"Sales Invoice");
            if FromCompanyValueEntryRec.FindSet() then begin
                repeat
                    FromCompanyItemLedgerEntryRec.Reset();
                    if FromCompanyItemLedgerEntryRec.ChangeCompany(FilterCompanyName) then begin
                        FromCompanyItemLedgerEntryRec.Get(FromCompanyValueEntryRec."Item Ledger Entry No.");
                        if FromCompanyItemLedgerEntryRec."Document Type" = FromCompanyItemLedgerEntryRec."Document Type"::"Sales Shipment" then begin
                            FromCompanySalesShipmentLineRec.Reset();
                            if FromCompanySalesShipmentLineRec.ChangeCompany(FilterCompanyName) then begin
                                if FromCompanySalesShipmentLineRec.Get(FromCompanyItemLedgerEntryRec."Document No.", FromCompanyItemLedgerEntryRec."Document Line No.") then begin
                                    exit(FromCompanySalesShipmentLineRec."Document No.");
                                end;
                            end;
                        end;
                    end;
                until FromCompanyValueEntryRec.Next() = 0;
            end;
        end;

    end;

    var
        CompanyInformationRec: Record "Company Information";
        TempSalesInvoiceHeaderRec: Record "Sales Invoice Header" temporary;
        TempSalesInvoiceLineRec: Record "Sales Invoice Line" temporary;
        ReportConverter: Report I9G_ReportConverter;
        DiscountedAmount: decimal;
        FilterCompanyName: Text;
        FilterInvoiceHeaderNo: Text;
        ShowSignatuure: Boolean;
        ShipToTel: Text[30];
        ShipToFax: Text[30];
        ShipToEmail: Text[80];
        LastShipmentNo: Code[50];
        CurrencyCode: Code[10];
        VATPercentageText: Text[25];
        SNNo: Integer;
        Description2: Text;
        Footer: Text;
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i, x : integer;
        ShowTitleTaxWord: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        GLSetupShortcutDimCode: array[8] of Code[20];
        SalesEmployeeName: Text[50];
        HSARegistrationNo: Text[20];
        ProdClassificationCode: Code[25];
        ConsignmentTaxInvoice: Boolean;
        SellToAddr: array[6] of Text[250];
        ShipToAddr: array[7] of Text[250];
        Chr: Char;
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        OutputNo: Integer;

    procedure GetReportOptionAndFilter(par_FromCompanyName: Text[30]; par_SalesInvoiceHeaderNo: Text; par_NoOfCopies: Integer)
    var
    begin
        FilterCompanyName := par_FromCompanyName;
        FilterInvoiceHeaderNo := par_SalesInvoiceHeaderNo;
        NoOfCopies := par_NoOfCopies;
    end;

    procedure RptGetSalesShptLines(var TempSalesShipmentLine: Record "Sales Shipment Line" temporary; par_TempSalesInvLineRec: Record "Sales Invoice Line")
    var
        FromCompanySalesShipmentLineRec: Record "Sales Shipment Line";
        FromCompanyValueEntries: Record "Value Entry";
        FromCompanyItemLedgerEntries: Record "Item Ledger Entry";
    begin
        TempSalesShipmentLine.Reset();
        TempSalesShipmentLine.DeleteAll();

        FromCompanyValueEntries.Reset();
        if FromCompanyValueEntries.ChangeCompany(FilterCompanyName) then begin
            FromCompanyValueEntries.SetRange("Document No.", par_TempSalesInvLineRec."Document No.");
            FromCompanyValueEntries.SetRange("Document Type", Enum::"Item Ledger Document Type"::"Sales Invoice");
            FromCompanyValueEntries.SetRange("Document Line No.", par_TempSalesInvLineRec."Line No.");
            FromCompanyValueEntries.SetRange("Item Ledger Entry Type", Enum::"Item Ledger Document Type"::"Sales Shipment");
            if FromCompanyValueEntries.FindSet() then begin
                repeat
                    FromCompanyItemLedgerEntries.Reset();
                    FromCompanyItemLedgerEntries.ChangeCompany(FilterCompanyName);
                    FromCompanyItemLedgerEntries.SetRange("Entry No.", FromCompanyValueEntries."Item Ledger Entry No.");
                    FromCompanyItemLedgerEntries.SetRange("Entry Type", FromCompanyValueEntries."Item Ledger Entry Type");
                    if FromCompanyItemLedgerEntries.FindSet() then begin
                        repeat
                            FromCompanySalesShipmentLineRec.ChangeCompany(FilterCompanyName);
                            if FromCompanySalesShipmentLineRec.Get(FromCompanyItemLedgerEntries."Document No.", FromCompanyItemLedgerEntries."Document Line No.") then begin
                                TempSalesShipmentLine.Init();
                                TempSalesShipmentLine := FromCompanySalesShipmentLineRec;
                                if TempSalesShipmentLine.Insert() then;
                            end;
                        until FromCompanyItemLedgerEntries.Next() = 0;
                    end;
                until FromCompanyValueEntries.Next() = 0;
            end;
        end;
    end;

    procedure ChangeCompanyRec(par_SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    var
        FromCompanySalesInvoiceHeaderRec: Record "Sales Invoice Header";
        FromCompanySalesInvoiceLineRec: Record "Sales Invoice Line";
        FromCompanyShipToAddressRec: Record "Ship-to Address";
        FromCompanyDimensionValue: Record "Dimension Value";
        FromCompanyGeneralLedgerSetupRec: Record "General Ledger Setup";
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
        Clear(TotalAmount);
        Clear(TotalAmountInclVAT);
        Clear(TotalVATAmount);
        FromCompanySalesInvoiceHeaderRec.Reset();
        if FromCompanySalesInvoiceHeaderRec.ChangeCompany(FilterCompanyName) then begin
            FromCompanySalesInvoiceHeaderRec.SetRange(I9G_InvoiceNo, par_SalesInvoiceHeaderRec."No.");
            if FromCompanySalesInvoiceHeaderRec.FindFirst() then begin
                TempSalesInvoiceHeaderRec.Reset();
                TempSalesInvoiceHeaderRec.Init();
                FromCompanySalesInvoiceHeaderRec.CalcFields(Amount, "Amount Including VAT");
                TempSalesInvoiceHeaderRec.TransferFields(FromCompanySalesInvoiceHeaderRec);
                TempSalesInvoiceHeaderRec.Insert();


                TotalAmount := FromCompanySalesInvoiceHeaderRec.Amount;
                TotalAmountInclVAT := FromCompanySalesInvoiceHeaderRec."Amount Including VAT";
                TotalVATAmount := TotalAmountInclVAT - TotalAmount;

                Clear(Footer);
                FromCompanySalesReceivablesSetupRec.Reset();
                if FromCompanySalesReceivablesSetupRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesReceivablesSetupRec.Get();
                    Footer := FromCompanySalesReceivablesSetupRec.I9G_TaxInvoiceFooter;
                end;

                FromCompanyShipToAddressRec.Reset();
                if FromCompanyShipToAddressRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanyShipToAddressRec.SetRange("Customer No.", FromCompanySalesInvoiceHeaderRec."Sell-to Customer No.");
                    FromCompanyShipToAddressRec.SetRange(Code, FromCompanySalesInvoiceHeaderRec."Ship-to Code");
                    if FromCompanyShipToAddressRec.FindFirst() then begin
                        Clear(ShipToTel);
                        Clear(ShipToFax);
                        Clear(ShipToEmail);
                        ShipToTel := FromCompanyShipToAddressRec."Phone No.";
                        ShipToFax := FromCompanyShipToAddressRec."Fax No.";
                        ShipToEmail := FromCompanyShipToAddressRec."E-Mail";
                    end;
                end;

                Clear(CurrencyCode);
                if FromCompanySalesInvoiceHeaderRec."Currency Code" <> '' then begin
                    CurrencyCode := FromCompanySalesInvoiceHeaderRec."Currency Code";
                end else begin
                    FromCompanyGeneralLedgerSetupRec.Reset();
                    if FromCompanyGeneralLedgerSetupRec.ChangeCompany(FilterCompanyName) then begin
                        FromCompanyGeneralLedgerSetupRec.Get();
                        CurrencyCode := FromCompanyGeneralLedgerSetupRec."LCY Code";
                    end;
                end;

                Clear(LastShipmentNo);
                LastShipmentNo := getLastShipmentNo(FromCompanySalesInvoiceHeaderRec);

                Clear(VATPercentageText);
                FromCompanySalesInvoiceLineRec.Reset();
                if FromCompanySalesInvoiceLineRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesInvoiceLineRec.SetRange("Document No.", FromCompanySalesInvoiceHeaderRec."No.");
                    FromCompanySalesInvoiceLineRec.SetFilter("VAT %", '<>%1', 0);
                    if FromCompanySalesInvoiceLineRec.FindFirst() then begin
                        VATPercentageText := 'ADD ' + format(FromCompanySalesInvoiceLineRec."VAT %") + '% GST';
                    end else begin
                        VATPercentageText := 'ADD 0% GST';
                    end;
                end;

                Clear(NoText);
                Clear(InputString);
                Clear(OutputString);
                Clear(n);
                Clear(i);
                ReportConverter.InitTextVariable;
                ReportConverter.FormatNoText(NoText, Abs(FromCompanySalesInvoiceHeaderRec."Amount Including VAT"), CurrencyCode);
                InputString := NoText[1] + ' ' + NoText[2] + ' ONLY';
                n := STRLEN(InputString);
                FOR i := 1 TO n DO
                    IF (InputString[i] = ' ') AND (i < n) THEN BEGIN
                        IF NOT (InputString[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                            OutputString += FORMAT(InputString[i])
                    END ELSE
                        OutputString += FORMAT(InputString[i]);
                OutputString := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString, '<>', ' '));

                Clear(SalesEmployeeName);
                Clear(ShortcutDimCode);
                GetShortcutDimensions(FromCompanySalesInvoiceLineRec."Dimension Set ID", ShortcutDimCode, FilterCompanyName);
                if ShortcutDimCode[7] <> '' then begin
                    DimensionValueRec.Reset();
                    if DimensionValueRec.ChangeCompany(FilterCompanyName) then begin
                        if DimensionValueRec.Get(GLSetupShortcutDimCode[7], ShortcutDimCode[7]) then
                            SalesEmployeeName := ShortcutDimCode[7] + '/' + DimensionValueRec.Name
                        else
                            SalesEmployeeName := ShortcutDimCode[7];
                    end;
                end;

                NovemCU.FormatSelltoAddressNovem(SellToAddr, '', FromCompanySalesInvoiceHeaderRec."Sell-to Customer Name", FromCompanySalesInvoiceHeaderRec."Sell-to Customer Name 2", FromCompanySalesInvoiceHeaderRec."Bill-to Address", FromCompanySalesInvoiceHeaderRec."Bill-to Address 2", FromCompanySalesInvoiceHeaderRec.I9G_BillToAddress3);
                NovemCU.FormatShiptoAddressNovem(ShipToAddr, FromCompanySalesInvoiceHeaderRec."Sell-to Customer Name", FromCompanySalesInvoiceHeaderRec."Ship-to Name", FromCompanySalesInvoiceHeaderRec."Ship-to Name 2", FromCompanySalesInvoiceHeaderRec."Ship-to Address", FromCompanySalesInvoiceHeaderRec."Ship-to Address 2", FromCompanySalesInvoiceHeaderRec.I9G_ShipToAddress3, ShipToTel);

                FromCompanySalesInvoiceLineRec.Reset();
                if FromCompanySalesInvoiceLineRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesInvoiceLineRec.SetRange("Document No.", FromCompanySalesInvoiceHeaderRec."No.");
                    if FromCompanySalesInvoiceLineRec.FindSet() then begin
                        repeat
                            TempSalesInvoiceLineRec.Reset();
                            TempSalesInvoiceLineRec.Init();
                            TempSalesInvoiceLineRec.TransferFields(FromCompanySalesInvoiceLineRec);
                            TempSalesInvoiceLineRec.Insert();
                        until FromCompanySalesInvoiceLineRec.Next() = 0;
                    end;
                end;
            end else begin
                Error('The tax invoice does not exists in partner company [%1]', FilterCompanyName);
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