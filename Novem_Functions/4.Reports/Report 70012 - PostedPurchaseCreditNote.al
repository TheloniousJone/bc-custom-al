report 70012 "I9G_PostedPurchaseCreditNote"
{
    DefaultRenderingLayout = "Novem - Purchase Credit Note";
    Caption = 'Purchase Credit Note';
    ApplicationArea = All;

    dataset
    {
        dataitem("PurchCrMemoHeader"; "Purch. Cr. Memo Hdr.")
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
            column(SelltoCustomerNo; "Buy-from Vendor No.") { }
            column(SelltoCustomerName; "Buy-from Vendor Name") { }
            column(SelltoCustomerName2; "Buy-from Vendor Name 2") { }
            column(SelltoAddress; "Buy-from Address") { }
            column(SelltoAddress2; "Buy-from Address 2") { }
            column(SelltoAddress3; "Buy-from City" + ' ' + "Buy-from County" + ' ' + "Buy-from Country/Region Code" + ' ' + "Buy-from Post Code") { }
            column(ShiptoName; "Ship-to Name") { }
            column(ShiptoName2; "Ship-to Name 2") { }
            column(ShiptoAddress; "Ship-to Address") { }
            column(ShiptoAddress2; "Ship-to Address 2") { }
            column(ShiptoAddress3; "Ship-to City" + ' ' + "Ship-to County" + ' ' + "Ship-to Country/Region Code" + ' ' + "Ship-to Post Code") { }
            column(Purchaser; '') { }
            column(DRIC; '') { }
            column(Remarks; I9G_Remarks) { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(ExternalDocNo; "Vendor Cr. Memo No.") { }
            column(Salesperson; "Shortcut Dimension 1 Code") { }
            column(Admin; I9G_Admin) { }
            column(CaseNumber; I9G_ReferenceInvoiceNo) { }
            column(ShipmentDate; Format(I9G_ShipmentDate, 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(ShipVia; I9G_ShipVia) { }
            column(DeliverTo; CompanyInformationRec.Address + ', ' + CompanyInformationRec."Address 2") { }
            column(DocumentsRequired; CompanyInformationRec.I9G_DocumentRequired) { }
            column(SpecialInstructions; I9G_SpecialInstructions) { }
            column(ShippingConfig; I9G_ShippingConfig) { }
            column(CurrencyCode; CurrencyCode) { }
            column(TotalAmount; Amount) { }
            column(VATPercentageText; VATPercentageText) { }
            column(TotalVATAmount; "Amount Including VAT" - Amount) { }
            column(TotalAmountInclVAT; "Amount Including VAT") { }
            column(AmountInText; OutputString) { }
            column(ReportFooter; PurchasesPayablesSetupRec.I9G_CreditNoteFooter) { }
            dataitem("PurchCrMemoLine"; "Purch. Cr. Memo Line")
            {
                DataItemLinkReference = PurchCrMemoHeader;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                column(SNNo; SNNo) { }
                column(ItemType; Type) { }
                column(ItemCode; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; Description2) { }
                column(Quantity; Quantity) { }
                column(UOMCode; "Unit of Measure Code") { }
                column(UnitPrice; "Unit Cost") { }
                column(LineDiscountAmount; DiscountedAmount) { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
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

                    if PurchCrMemoLine.Type = PurchCrMemoLine.Type::Item then begin
                        SNNo += 1;
                        Chr := 10;

                        ItemLedgerEntryRec.Reset();
                        ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Purchase Credit Memo");
                        ItemLedgerEntryRec.SetRange("Document No.", PurchCrMemoLine."Document No.");
                        ItemLedgerEntryRec.SetRange("Document Line No.", PurchCrMemoLine."Line No.");
                        ItemLedgerEntryRec.SetRange("Item No.", PurchCrMemoLine."No.");
                        if ItemLedgerEntryRec.FindSet() then begin
                            repeat
                                if Description2 = '' then
                                    Description2 := 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity))
                                else
                                    Description2 += Chr + 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity));
                            until ItemLedgerEntryRec.Next() = 0;
                        end;

                        Item.Reset();
                        if Item.Get("PurchCrMemoLine"."No.") then begin
                            HSARegistrationNo := Item.I9G_HSARegistrationNo;
                            ProdClassificationCode := Item.I9G_ProdClassificationCode;
                        end;
                    end;
                    If "Line Discount %" <> 0 then begin
                        DiscountedAmount := "Direct Unit Cost" - ("Direct Unit Cost" * ("Line Discount %" / 100));
                    end else begin
                        DiscountedAmount := 0;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                PurchCrMemoLineRec: Record "Purch. Cr. Memo Line";
            begin
                PurchCrMemoLineRec.Reset();
                Clear(VATPercentageText);
                PurchCrMemoLineRec.SetRange("Document No.", PurchCrMemoHeader."No.");
                PurchCrMemoLineRec.SetFilter("VAT %", '<>%1', 0);
                if PurchCrMemoLineRec.FindFirst() then begin
                    VATPercentageText := 'ADD ' + format(PurchCrMemoLineRec."VAT %") + '% GST';
                end else begin
                    VATPercentageText := 'ADD 0% GST';
                end;
                Clear(CurrencyCode);
                if PurchCrMemoHeader."Currency Code" <> '' then begin
                    CurrencyCode := PurchCrMemoHeader."Currency Code"
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
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
    }
    rendering
    {
        layout("Novem - Purchase Credit Note")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70012-PostedPurchaseCreditNote.rdl';
        }
    }
    trigger OnPreReport()
    var
    begin
        CompanyInformationRec.Get();
        GeneralLedgerSetupRec.Get();
        PurchasesPayablesSetupRec.Get();
        CompanyInformationRec.CalcFields(Picture);
        CompanyInformationRec.CalcFields(I9G_QRCode);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        PurchasesPayablesSetupRec: Record "Purchases & Payables Setup";
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
        Chr: Char;
}