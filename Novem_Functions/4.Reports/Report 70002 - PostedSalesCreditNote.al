report 70002 "I9G_PostedSalesCreditNote"
{
    DefaultRenderingLayout = "Novem - Sales Credit Note";
    Caption = 'Sales Credit Note';
    ApplicationArea = All;

    dataset
    {
        dataitem("SalesCrMemoHeader"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
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
            column(ShiptoName; "Ship-to Name") { }
            column(ShiptoName2; "Ship-to Name 2") { }
            column(ShiptoAddress; "Ship-to Address") { }
            column(ShiptoAddress2; "Ship-to Address 2") { }
            column(ShiptoAddress3; I9G_ShipToAddress3) { }
            column(Purchaser; I9G_Purchaser) { }
            column(DRIC; I9G_DRIC) { }
            column(Remarks; I9G_Remarks) { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(ExternalDocNo; "External Document No.") { }
            column(Salesperson; "Shortcut Dimension 1 Code") { }
            column(Admin; I9G_Admin) { }
            column(CaseNumber; I9G_ReferenceInvoiceNo) { }
            column(ShipmentDate; Format("Shipment Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(CurrencyCode; CurrencyCode) { }
            column(TotalAmount; Amount) { }
            column(VATPercentageText; VATPercentageText) { }
            column(TotalVATAmount; "Amount Including VAT" - Amount) { }
            column(TotalAmountInclVAT; "Amount Including VAT") { }
            column(AmountInText; OutputString) { }
            column(ReportFooter; SalesReceivablesSetupRec.I9G_CreditNoteFooter) { }
            dataitem("SalesCrMemoLine"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = SalesCrMemoHeader;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
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
                begin
                    Clear(Description2);

                    if SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item then begin
                        SNNo += 1;
                        Chr := 10;

                        ItemLedgerEntryRec.Reset();
                        ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Sales Credit Memo");
                        ItemLedgerEntryRec.SetRange("Document No.", SalesCrMemoLine."Document No.");
                        ItemLedgerEntryRec.SetRange("Document Line No.", SalesCrMemoLine."Line No.");
                        ItemLedgerEntryRec.SetRange("Item No.", SalesCrMemoLine."No.");
                        if ItemLedgerEntryRec.FindSet() then begin
                            repeat
                                if Description2 = '' then
                                    Description2 := 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity))
                                else
                                    Description2 += Chr + 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity));
                            until ItemLedgerEntryRec.Next() = 0;
                        end;

                        Item.Reset();
                        if Item.Get("SalesCrMemoLine"."No.") then begin
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
                SalesCrMemoLineRec: Record "Sales Cr.Memo Line";
                NovemCU: Codeunit I9G_NovemEventSubscribers;
            begin
                SalesCrMemoLineRec.Reset();
                Clear(VATPercentageText);
                SalesCrMemoLineRec.SetRange("Document No.", SalesCrMemoHeader."No.");
                SalesCrMemoLineRec.SetFilter("VAT %", '<>%1', 0);
                if SalesCrMemoLineRec.FindFirst() then begin
                    VATPercentageText := 'ADD ' + format(SalesCrMemoLineRec."VAT %") + '% GST';
                end else begin
                    VATPercentageText := 'ADD 0% GST';
                end;
                Clear(CurrencyCode);
                if SalesCrMemoHeader."Currency Code" <> '' then begin
                    CurrencyCode := SalesCrMemoHeader."Currency Code"
                end else begin
                    CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                end;
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

                NovemCU.FormatSelltoAddressNovem(SellToAddr, '', "Sell-to Customer Name", "Sell-to Customer Name 2", "Bill-to Address", "Bill-to Address 2", I9G_BillToAddress3);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
    }
    rendering
    {
        layout("Novem - Sales Credit Note")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70002-PostedSalesCreditNote.rdl';
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

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        ReportConverter: Report I9G_ReportConverter;
        DiscountedAmount: decimal;
        LastShipmentNo: Code[50];
        CurrencyCode: Code[10];
        VATPercentageText: Text[25];
        SNNo: Integer;
        Description2: Text;
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i : integer;
        HSARegistrationNo: Text[20];
        ProdClassificationCode: Code[25];
        SellToAddr: array[6] of Text[250];
        Chr: Char;
}