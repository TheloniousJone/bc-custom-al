report 70052 "I9G_UnpostedSalesTaxInvoice"
{
    DefaultRenderingLayout = "Novem - Unposted Sales Tax Invoice";
    Caption = 'Unposted Sales Tax Invoice';
    ApplicationArea = All;

    dataset
    {
        dataitem("SalesHeader"; "Sales Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
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
            column(DocumentNo; "No.") { }
            column(LastShipmentNo; LastShipmentNo) { }
            column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(SelltoCustomerNo; "Sell-to Customer No.") { }
            column(SelltoCustomerName; SellToAddr[1]) { }
            column(SelltoCustomerName2; SellToAddr[2]) { }
            column(SelltoAddress; SellToAddr[3]) { }
            column(SelltoAddress2; SellToAddr[4]) { }
            column(SelltoAddress3; SellToAddr[5]) { }
            column(ShiptoName; ShipToAddr[1]) { }
            column(ShiptoName2; ShipToAddr[2]) { }
            column(ShiptoAddress; ShipToAddr[3]) { }
            column(ShiptoAddress2; ShipToAddr[4]) { }
            column(ShiptoAddress3; ShipToAddr[5]) { }
            column(ShipToTel; ShipToAddr[6]) { }
            column(ShipToFax; ShipToFax) { }
            column(ShipToEmail; ShipToEmail) { }
            column(Purchaser; I9G_Purchaser) { }
            column(DRIC; I9G_DRIC) { }
            column(Remarks; I9G_Remarks) { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(ExternalDocNo; "External Document No.") { }
            column(Salesperson; SalesEmployeeName) { }
            column(Admin; I9G_Admin) { }
            column(CaseNumber; I9G_CaseNumber) { }
            column(ShipmentDate; Format("Shipment Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(CurrencyCode; CurrencyCode) { }
            column(TotalAmount; Amount) { }
            column(VATPercentageText; VATPercentageText) { }
            column(TotalVATAmount; "Amount Including VAT" - Amount) { }
            column(TotalAmountInclVAT; "Amount Including VAT") { }
            column(AmountInText; OutputString) { }
            column(ReportFooter; SalesReceivablesSetupRec.I9G_TaxInvoiceFooter) { }
            column(ShowTitleTaxWord; ShowTitleTaxWord) { }
            column(CaseDoctor; I9G_CaseDoctor) { }
            column(DateUsed; Format(I9G_DateUsed, 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(ConsignmentTaxInvoice; ConsignmentTaxInvoice) { }
            dataitem("SalesLine"; "Sales Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
                column(SNNo; SNNo) { }
                column(ItemType; Type) { }
                column(ItemCode; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; Description2) { }
                column(Quantity; Quantity) { }
                column(UOMCode; "Unit of Measure Code") { }
                column(UnitPrice; "Unit Price") { }
                column(LineDiscountAmount; DiscountedAmount) { }
                column(LineAmount; "Line Amount") { }
                column(HSARegistrationNo; HSARegistrationNo) { }
                column(ProdClassificationCode; ProdClassificationCode) { }
                column(Location_Code; "Location Code") { }
                trigger OnPreDataItem()
                var
                begin
                    Clear(SNNo);
                    Clear(HSARegistrationNo);
                    Clear(ProdClassificationCode);
                    SNNo := 0;
                    Chr := 0;
                end;

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    ReservationEntry: Record "Reservation Entry";
                begin
                    if SalesLine.Type = SalesLine.Type::Item then begin
                        SNNo += 1;
                        // if TempSalesShipmentLineRec.IsTemporary then
                        //     TempSalesShipmentLineRec.DeleteAll();
                        // TempSalesShipmentLineRec.Reset();
                        // SalesLine.GetSalesShptLines(TempSalesShipmentLineRec);
                        // if TempSalesShipmentLineRec.FindFirst() then begin
                        //     ItemLedgerEntryRec.Reset();
                        //     ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Sales Shipment");
                        //     ItemLedgerEntryRec.SetRange("Document No.", TempSalesShipmentLineRec."Document No.");
                        //     ItemLedgerEntryRec.SetRange("Document Line No.", TempSalesShipmentLineRec."Line No.");
                        //     ItemLedgerEntryRec.SetRange("Item No.", TempSalesShipmentLineRec."No.");
                        //     if ItemLedgerEntryRec.FindFirst() then begin
                        //         Clear(Description2);
                        //         Description2 := 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Quantity);
                        //     end;
                        // end;

                        Clear(Description2);
                        ReservationEntry.Reset();
                        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
                        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
                        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
                        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                        if ReservationEntry.FindSet() then begin
                            repeat
                                Chr := 10;

                                ItemLedgerEntryRec.Reset();
                                ItemLedgerEntryRec.SetRange("Item No.", SalesLine."No.");
                                ItemLedgerEntryRec.SetRange("Variant Code", SalesLine."Variant Code");
                                ItemLedgerEntryRec.SetRange("Location Code", SalesLine."Location Code");
                                ItemLedgerEntryRec.SetRange("Lot No.", ReservationEntry."Lot No.");
                                ItemLedgerEntryRec.SetFilter("Remaining Quantity", '>0');
                                if ItemLedgerEntryRec.FindFirst() then;

                                if Description2 = '' then
                                    Description2 := 'BN : ' + ReservationEntry."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ReservationEntry.Quantity))
                                else
                                    Description2 += Chr + 'BN : ' + ReservationEntry."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ReservationEntry.Quantity));
                            until ReservationEntry.Next() = 0;
                        end;

                        Item.Reset();
                        if Item.Get(SalesLine."No.") then begin
                            HSARegistrationNo := Item.I9G_HSARegistrationNo;
                            ProdClassificationCode := Item.I9G_ProdClassificationCode;
                        end;
                    end;
                    If "Line Discount %" <> 0 then begin
                        DiscountedAmount := "Unit Price" - ("Unit Price" * ("Line Discount %" / 100));
                    end else begin
                        DiscountedAmount := 0;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                SalesLineRec: Record "Sales Line";
                ShipToAddressRec: Record "Ship-to Address";
                DimensionValue: Record "Dimension Value";
                DimMgt: Codeunit DimensionManagement;
                NovemCU: Codeunit I9G_NovemEventSubscribers;
            begin
                SalesLineRec.Reset();
                Clear(VATPercentageText);
                SalesLineRec.SetRange("Document Type", SalesHeader."Document Type");
                SalesLineRec.SetRange("Document No.", SalesHeader."No.");
                SalesLineRec.SetFilter("VAT %", '<>%1', 0);
                if SalesLineRec.FindFirst() then begin
                    VATPercentageText := 'ADD ' + format(SalesLineRec."VAT %") + '% GST';
                end else begin
                    VATPercentageText := 'ADD 0% GST';
                end;
                Clear(CurrencyCode);
                if SalesHeader."Currency Code" <> '' then begin
                    CurrencyCode := SalesHeader."Currency Code"
                end else begin
                    CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                end;
                Clear(LastShipmentNo);
                LastShipmentNo := getLastShipmentNo(SalesHeader);
                Clear(NoText);
                Clear(InputString);
                Clear(OutputString);
                Clear(n);
                Clear(i);
                ReportConverter.InitTextVariable;
                ReportConverter.FormatNoText(NoText, Abs("Amount Including VAT"), CurrencyCode);
                InputString := NoText[1] + ' ' + NoText[2] + ' ONLY';
                n := STRLEN(InputString);
                FOR i := 1 TO n DO
                    IF (InputString[i] = ' ') AND (i < n) THEN BEGIN
                        IF NOT (InputString[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                            OutputString += FORMAT(InputString[i])
                    END ELSE
                        OutputString += FORMAT(InputString[i]);
                OutputString := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString, '<>', ' '));
                ShipToAddressRec.Reset();
                ShipToAddressRec.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                ShipToAddressRec.SetRange(Code, SalesHeader."Ship-to Code");
                if ShipToAddressRec.FindFirst() then begin
                    Clear(ShipToTel);
                    Clear(ShipToFax);
                    Clear(ShipToEmail);
                    ShipToTel := ShipToAddressRec."Phone No.";
                    ShipToFax := ShipToAddressRec."Fax No.";
                    ShipToEmail := ShipToAddressRec."E-Mail";
                end;

                Clear(SalesEmployeeName);
                Clear(ShortcutDimCode);
                DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);

                if ShortcutDimCode[7] <> '' then begin
                    DimMgt.GetGLSetup(GLSetupShortcutDimCode);

                    DimensionValue.Reset();
                    if DimensionValue.Get(GLSetupShortcutDimCode[7], ShortcutDimCode[7]) then begin
                        SalesEmployeeName := ShortcutDimCode[7] + '/' + DimensionValue.Name
                    end else begin
                        SalesEmployeeName := ShortcutDimCode[7];
                    end;
                end;

                NovemCU.FormatSelltoAddressNovem(SellToAddr, '', "Sell-to Customer Name", "Sell-to Customer Name 2", "Bill-to Address", "Bill-to Address 2", I9G_BillToAddress3);
                NovemCU.FormatShiptoAddressNovem(ShipToAddr, '', "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", I9G_ShipToAddress3, ShipToTel);
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
    rendering
    {
        layout("Novem - Unposted Sales Tax Invoice")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70052-UnpostedSalesTaxInvoice.rdl';
        }
        layout("Novem - Unposted Sales Tax Invoice (No PayNow)")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70059-UnpostedSalesTaxInvoice(NoPayNow).rdl';
        }
    }
    trigger OnPreReport()
    var
    begin
        CompanyInformationRec.Get();
        GeneralLedgerSetupRec.Get();
        SalesReceivablesSetupRec.Get();
        CompanyInformationRec.CalcFields(Picture);
        CompanyInformationRec.CalcFields(I9G_QRCode);
    end;

    local procedure getLastShipmentNo(par_SalesHeader: Record "Sales Header"): Code[20]
    var
        ValueEntryRec: Record "Value Entry";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        SalesShipmentLineRec: Record "Sales Shipment Line";
    begin
        ValueEntryRec.Reset();
        ValueEntryRec.SetCurrentKey("Document No.");
        ValueEntryRec.SetRange("Document No.", par_SalesHeader."No.");
        ValueEntryRec.SetRange("Document Type", ValueEntryRec."Document Type"::"Sales Invoice");
        if ValueEntryRec.FindSet() then begin
            repeat
                ItemLedgerEntryRec.Reset();
                ItemLedgerEntryRec.Get(ValueEntryRec."Item Ledger Entry No.");
                if ItemLedgerEntryRec."Document Type" = ItemLedgerEntryRec."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLineRec.Reset();
                    if SalesShipmentLineRec.Get(ItemLedgerEntryRec."Document No.", ItemLedgerEntryRec."Document Line No.") then begin
                        exit(SalesShipmentLineRec."Document No.");
                    end;
                end;
            until ValueEntryRec.Next() = 0;
        end;
    end;

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        ReportConverter: Report I9G_ReportConverter;
        TempSalesShipmentLineRec: Record "Sales Shipment Line" temporary;
        DiscountedAmount: decimal;
        ShipToTel: Text[30];
        ShipToFax: Text[30];
        ShipToEmail: Text[80];
        LastShipmentNo: Code[50];
        CurrencyCode: Code[10];
        VATPercentageText: Text[25];
        SNNo: Integer;
        Description2: Text;
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i : integer;
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
}