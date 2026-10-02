report 70011 "I9G_PostedPurchaseReceipt"
{
    DefaultRenderingLayout = "Novem - Purchase Goods Receipt";
    Caption = 'Purchase Goods Receipt';
    ApplicationArea = All;

    dataset
    {
        dataitem("PurchRcptHeader"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(CompanyAddress; CompanyInformationRec.Address) { }
            column(CompanyAddress2; CompanyInformationRec."Address 2") { }
            column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
            column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
            column(CompanyEmail; CompanyInformationRec."E-Mail") { }
            column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
            column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
            column(DocumentNo; "No.") { }
            column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(PayToVendorNo; "Pay-to Vendor No.") { }
            column(PayToName; "Pay-to Name") { }
            column(PayToName2; "Pay-to Name") { }
            column(PayToAddress; "Pay-to Address") { }
            column(PayToAddress2; "Pay-to Address 2") { }
            column(PayToCity; "Pay-to City") { }
            column(PayToCountryRegionCode; "Pay-to Country/Region Code") { }
            column(PayToCountry; "Pay-to County") { }
            column(PayToPostCode; "Pay-to Post Code") { }
            column(PayToContactName; "Pay-to Contact") { }
            column(PayToContactNo; "Pay-to Contact No.") { }
            column(PayToEmail; GetVendorRec."E-Mail") { }
            column(PayToTel; GetVendorRec."Phone No.") { }
            column(PayToFax; GetVendorRec."Fax No.") { }
            column(Remarks; I9G_Remarks) { }
            column(PaymentTerms; "Payment Terms Code") { }
            column(PONo; "Order No.") { }
            column(SupplierInvNo; VendorInvoiceNo) { }
            column(VATPercentageText; VATPercentageText) { }
            column(CurrencyCode; CurrencyCode) { }
            column(CurrencyFactor; CurrencyFactor) { }
            dataitem("PurchRcptLine"; "Purch. Rcpt. Line")
            {
                DataItemLinkReference = PurchRcptHeader;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                column(SNNo; SNNo) { }
                column(ItemType; Type) { }
                column(ItemCode; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; Description2) { }
                column(Quantity; Quantity) { }
                column(UOMCode; "Unit of Measure Code") { }
                column(PurchasePrice; "Purchase Price") { }
                column(DirectUnitCost; DirectUnitCost) { }
                column(LineAmount; LineAmount) { }
                column(UnitCost; "Unit Cost") { }
                column(DiscountAmount; DiscountedAmount) { }
                // column(LineAmountExclVAT; "Unit Cost" * Quantity) { }
                column(LineAmountExclVAT; LineAmountExclVAT) { }
                column(LineAmountInclVAT; LineAmountInclVAT)
                {
                    DecimalPlaces = 0 : 2;
                }
                // column(GSTAmount; LineAmountInclVAT - ("Unit Cost" * Quantity)) { }
                column(GSTAmount; LineAmountInclVAT - LineAmountExclVAT) { }
                column(AmountInText; OutputString) { }
                column(HSARegistrationNo; HSARegistrationNo) { }
                column(ProdClassificationCode; ProdClassificationCode) { }
                trigger OnPreDataItem()
                var
                begin
                    Clear(SNNo);
                    Clear(HSARegistrationNo);
                    Clear(ProdClassificationCode);
                    Clear(TotalBeforeVAT);
                    Clear(GrandTotal);
                    Clear(CountLines);
                    SNNo := 0;
                    Chr := 0;
                    CountLines := PurchRcptLine.Count();
                end;

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    PurchaseLineRec: Record "Purchase Line";
                    PurchaseInvLineRec: Record "Purch. Inv. Line";
                    Currency: Record Currency;
                begin
                    Clear(Description2);

                    if (PurchRcptLine.Type in [PurchRcptLine.Type::Item, PurchRcptLine.Type::"Charge (Item)", PurchRcptLine.Type::Resource]) and (PurchRcptLine.Quantity <> 0) then begin
                        SNNo += 1;

                        Chr := 10;
                        ItemLedgerEntryRec.Reset();
                        ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Purchase Receipt");
                        ItemLedgerEntryRec.SetRange("Document No.", PurchRcptLine."Document No.");
                        ItemLedgerEntryRec.SetRange("Document Line No.", PurchRcptLine."Line No.");
                        ItemLedgerEntryRec.SetRange("Item No.", PurchRcptLine."No.");
                        if ItemLedgerEntryRec.FindSet() then begin
                            repeat
                                if Description2 = '' then
                                    Description2 := 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity))
                                else
                                    Description2 += Chr + 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity));
                            until ItemLedgerEntryRec.Next() = 0;
                        end;

                        if TempPurchaseInvLineRec.IsTemporary then
                            TempPurchaseInvLineRec.DeleteAll();
                        Clear(LineAmountExclVAT);
                        Clear(DiscountAmount);
                        Clear(LineAmountInclVAT);
                        TempPurchaseInvLineRec.Reset();
                        PurchRcptLine.GetPurchInvLines(TempPurchaseInvLineRec);
                        if TempPurchaseInvLineRec.FindFirst() then begin
                            // if "Line Discount %" <> 0 then
                            //     UnitPrice := "Unit Cost" / (1 - ("Line Discount %" / 100))
                            // else
                            //     UnitPrice := "Unit Cost";
                            // DiscountAmount := (Quantity * UnitPrice) * ("Line Discount %" / 100);
                            // LineAmountExclVAT := ("UnitPrice" * Quantity) - DiscountAmount;
                            // LineAmountInclVAT := LineAmountExclVAT * ((100 + "VAT %") / 100);
                            DiscountAmount := (TempPurchaseInvLineRec."Line Discount Amount");
                            LineAmountExclVAT := TempPurchaseInvLineRec."Line Amount";
                            DirectUnitCost := TempPurchaseInvLineRec."Direct Unit Cost";
                            LineAmount := TempPurchaseInvLineRec."Amount";
                            // LineAmountInclVAT := "Unit Cost" * Quantity * (1 + (TempPurchaseInvLineRec."VAT %" / 100));
                            LineAmountInclVAT := (TempPurchaseInvLineRec."Amount Including VAT" / TempPurchaseInvLineRec.Quantity) * Quantity;


                            If TempPurchaseInvLineRec."Line Discount %" <> 0 then begin
                                DiscountedAmount := TempPurchaseInvLineRec."Direct Unit Cost" - (TempPurchaseInvLineRec."Direct Unit Cost" * (TempPurchaseInvLineRec."Line Discount %" / 100));
                            end else begin
                                DiscountedAmount := 0;
                            end;
                        end else begin
                            PurchaseInvLineRec.Reset();
                            PurchaseInvLineRec.SetRange("Order No.", PurchRcptLine."Order No.");
                            PurchaseInvLineRec.SetRange("Line No.", PurchRcptLine."Line No.");
                            if PurchaseInvLineRec.FindFirst() then begin
                                // if "Line Discount %" <> 0 then
                                //     UnitPrice := "Unit Cost" / (1 - ("Line Discount %" / 100))
                                // else
                                //     UnitPrice := "Unit Cost";
                                // DiscountAmount := (Quantity * UnitPrice) * ("Line Discount %" / 100);
                                // LineAmountExclVAT := ("UnitPrice" * Quantity) - DiscountAmount;
                                // LineAmountInclVAT := LineAmountExclVAT * (100 + "VAT %") / 100;
                                LineAmountExclVAT := (PurchaseInvLineRec."Line Amount" / PurchaseInvLineRec.Quantity) * Quantity;
                                DirectUnitCost := PurchaseInvLineRec."Direct Unit Cost";
                                LineAmountInclVAT := (PurchaseInvLineRec."Amount Including VAT" / PurchaseInvLineRec.Quantity) * Quantity;

                                LineAmount := PurchaseInvLineRec."Amount";

                                If PurchaseInvLineRec."Line Discount %" <> 0 then begin
                                    DiscountedAmount := PurchaseInvLineRec."Direct Unit Cost" - (PurchaseInvLineRec."Direct Unit Cost" * (PurchaseInvLineRec."Line Discount %" / 100));
                                end else begin
                                    DiscountedAmount := 0;
                                end;
                            end
                            else begin
                                PurchaseLineRec.Reset();
                                PurchaseLineRec.SetRange("Document Type", PurchaseLineRec."Document Type"::Order);
                                PurchaseLineRec.SetRange("Document No.", PurchRcptLine."Order No.");
                                PurchaseLineRec.SetRange("Line No.", PurchRcptLine."Order Line No.");
                                if PurchaseLineRec.FindFirst() then begin

                                    // Original Commented Codes
                                    /*
                                    // if "Line Discount %" <> 0 then
                                    //     UnitPrice := "Unit Cost" / (1 - ("Line Discount %" / 100))
                                    // else
                                    //     UnitPrice := "Unit Cost";
                                    // DiscountAmount := (Quantity * UnitPrice) * ("Line Discount %" / 100);
                                    // LineAmountExclVAT := ("UnitPrice" * Quantity) - DiscountAmount;
                                    // LineAmountInclVAT := LineAmountExclVAT * (100 + "VAT %") / 100;
                                    */

                                    // Previous Codes
                                    /*
                                    LineAmountExclVAT := PurchaseLineRec.Amount;
                                    DiscountAmount := (PurchaseLineRec."Line Discount Amount");
                                    LineAmountInclVAT := (PurchaseLineRec."Amount Including VAT");
                                    DirectUnitCost := PurchaseLineRec."Direct Unit Cost";
                                    LineAmount := PurchaseLineRec."Amount";
                                    */

                                    // Workaround
                                    DirectUnitCost := PurchaseLineRec."Direct Unit Cost";
                                    DiscountAmount := (Quantity * DirectUnitCost) * ("Line Discount %" / 100);
                                    LineAmountExclVAT := (DirectUnitCost * Quantity)/* - DiscountAmount*/;
                                    LineAmountInclVAT := LineAmountExclVAT * (100 + "VAT %") / 100;
                                    LineAmount := DirectUnitCost * Quantity;

                                    If PurchaseLineRec."Line Discount %" <> 0 then begin
                                        DiscountedAmount := PurchaseLineRec."Direct Unit Cost" - (PurchaseLineRec."Direct Unit Cost" * (PurchaseLineRec."Line Discount %" / 100));
                                    end else begin
                                        DiscountedAmount := 0;
                                    end;
                                end;
                            end;
                        end;

                        if PurchRcptHeader."Currency Code" = '' then
                            Currency.InitRoundingPrecision()
                        else
                            Currency.Get(PurchRcptHeader."Currency Code");

                        DiscountAmount := Round(DiscountAmount, Currency."Amount Rounding Precision");
                        LineAmountExclVAT := Round(LineAmountExclVAT, Currency."Amount Rounding Precision");
                        LineAmountInclVAT := Round(LineAmountInclVAT, Currency."Amount Rounding Precision");
                        DiscountedAmount := Round(DiscountedAmount, Currency."Amount Rounding Precision");
                        LineAmount := Round(LineAmount, Currency."Amount Rounding Precision");

                        GrandTotal += LineAmountInclVAT;
                        if SNNo = CountLines then begin
                            Clear(NoText);
                            Clear(InputString);
                            Clear(OutputString);
                            Clear(n);
                            Clear(i);
                            ReportConverter.InitTextVariable;
                            ReportConverter.FormatNoText(NoText, Abs(Round(GrandTotal, 0.01, '=')), CurrencyCode);
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

                        Item.Reset();
                        if Item.Get("PurchRcptLine"."No.") then begin
                            HSARegistrationNo := Item.I9G_HSARegistrationNo;
                            ProdClassificationCode := Item.I9G_ProdClassificationCode;
                        end;
                    end else begin
                        CurrReport.Skip();
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                PurchRcptLineRec: Record "Purch. Rcpt. Line";
                PurchaseHeaderRec: Record "Purchase Header";
                PurchInvHeaderRec: Record "Purch. Inv. Header";
            begin
                PurchRcptLineRec.Reset();
                Clear(VATPercentageText);
                PurchRcptLineRec.SetRange("Document No.", PurchRcptHeader."No.");
                PurchRcptLineRec.SetFilter("VAT %", '<>%1', 0);
                if PurchRcptLineRec.FindFirst() then begin
                    VATPercentageText := 'ADD ' + format(PurchRcptLineRec."VAT %") + '% GST';
                end else begin
                    VATPercentageText := 'ADD 0% GST';
                end;
                Clear(CurrencyCode);
                if PurchRcptHeader."Currency Code" <> '' then begin
                    CurrencyCode := PurchRcptHeader."Currency Code"
                end else begin
                    CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                end;
                GetVendorRec.Reset();
                if GetVendorRec.Get("Pay-to Vendor No.") then;
                Clear(CurrencyFactor);
                if PurchRcptHeader."Currency Factor" = 0 then begin
                    CurrencyFactor := CurrencyCode;
                end else begin
                    CurrencyFactor := CurrencyCode + ' / ' + Format(Round(1 / PurchRcptHeader."Currency Factor", 0.00001, '='));
                end;
                Clear(VendorInvoiceNo);
                PurchaseHeaderRec.Reset();
                PurchaseHeaderRec.SetRange("Document Type", PurchaseHeaderRec."Document Type"::Order);
                PurchaseHeaderRec.SetRange("No.", PurchRcptHeader."Order No.");
                if PurchaseHeaderRec.FindFirst() then begin
                    VendorInvoiceNo := PurchaseHeaderRec."Vendor Invoice No.";
                end else begin
                    PurchInvHeaderRec.Reset();
                    PurchInvHeaderRec.SetRange("Order No.", PurchRcptHeader."Order No.");
                    if PurchInvHeaderRec.FindFirst() then begin
                        VendorInvoiceNo := PurchaseHeaderRec."Vendor Invoice No.";
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
    }
    rendering
    {
        layout("Novem - Purchase Goods Receipt")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70011-PostedPurchaseReceipt.rdl';
        }
    }
    trigger OnPreReport()
    var
    begin
        CompanyInformationRec.Get();
        GeneralLedgerSetupRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        TempPurchaseInvLineRec: Record "Purch. Inv. Line" temporary;
        GetVendorRec: Record Vendor;
        ReportConverter: Report I9G_ReportConverter;
        DiscountAmount, LineAmountExclVAT, LineAmountInclVAT, TotalBeforeVAT, VATAmount, GrandTotal : Decimal;
        CurrencyCode: Code[10];
        DiscountedAmount: decimal;
        CurrencyFactor, VendorInvoiceNo : Code[50];
        VATPercentageText: Text[25];
        SNNo: Integer;
        Description2: Text;
        PayToEmail: Text[500];
        NoText: array[2] of Text[250];
        InputString, OutputString : Text[2400];
        n, i : integer;
        HSARegistrationNo: Text[20];
        ProdClassificationCode: Code[25];
        Chr: Char;
        CountLines: Integer;
        DirectUnitCost: Decimal;
        LineAmount: Decimal;
        UnitPrice: Decimal;
}