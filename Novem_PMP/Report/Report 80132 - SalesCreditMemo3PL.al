report 80132 "I9G_PostedSalesCreditNote3PL"
{
    DefaultRenderingLayout = "Sales Credit Note - 3PL";
    Caption = 'Sales Credit Note';
    ApplicationArea = All;

    dataset
    {
        dataitem("SalesCrMemoHeader"; "Sales Cr.Memo Header")
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
                column(DocumentNo; TempSalesCrMemoHeaderRec."No.") { }
                column(LastShipmentNo; LastShipmentNo) { }
                column(DocumentDate; Format(TempSalesCrMemoHeaderRec."Document Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(SelltoCustomerNo; TempSalesCrMemoHeaderRec."Sell-to Customer No.") { }
                column(SelltoCustomerName; SellToAddr[1]) { }
                column(SelltoCustomerName2; SellToAddr[2]) { }
                column(SelltoAddress; SellToAddr[3]) { }
                column(SelltoAddress2; SellToAddr[4]) { }
                column(SelltoAddress3; SellToAddr[5]) { }
                column(ShiptoName; TempSalesCrMemoHeaderRec."Ship-to Name") { }
                column(ShiptoName2; TempSalesCrMemoHeaderRec."Ship-to Name 2") { }
                column(ShiptoAddress; TempSalesCrMemoHeaderRec."Ship-to Address") { }
                column(ShiptoAddress2; TempSalesCrMemoHeaderRec."Ship-to Address 2") { }
                column(ShiptoAddress3; TempSalesCrMemoHeaderRec.I9G_ShipToAddress3) { }
                column(Purchaser; TempSalesCrMemoHeaderRec.I9G_Purchaser) { }
                column(DRIC; TempSalesCrMemoHeaderRec.I9G_DRIC) { }
                column(Remarks; TempSalesCrMemoHeaderRec.I9G_Remarks) { }
                column(PaymentTermsCode; TempSalesCrMemoHeaderRec."Payment Terms Code") { }
                column(ExternalDocNo; TempSalesCrMemoHeaderRec."External Document No.") { }
                column(Salesperson; TempSalesCrMemoHeaderRec."Shortcut Dimension 1 Code") { }
                column(Admin; TempSalesCrMemoHeaderRec.I9G_Admin) { }
                column(CaseNumber; TempSalesCrMemoHeaderRec.I9G_ReferenceInvoiceNo) { }
                column(ShipmentDate; Format(TempSalesCrMemoHeaderRec."Shipment Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
                column(CurrencyCode; CurrencyCode) { }
                column(TotalAmount; TotalAmount) { }
                column(VATPercentageText; VATPercentageText) { }
                column(TotalVATAmount; TotalVATAmount) { }
                column(TotalAmountInclVAT; TotalAmountInclVAT) { }
                column(AmountInText; OutputString) { }
                column(ReportFooter; Footer) { }
                column(ShowSignatuure; ShowSignatuure) { }
                dataitem(LineLoop; Integer)
                {
                    column(SNNo; SNNo) { }
                    column(ItemType; TempSalesCrMemoLineRec.Type) { }
                    column(ItemCode; TempSalesCrMemoLineRec."No.") { }
                    column(ItemDescription; TempSalesCrMemoLineRec.Description) { }
                    column(ItemDescription2; Description2) { }
                    column(Quantity; TempSalesCrMemoLineRec.Quantity) { }
                    column(UOMCode; TempSalesCrMemoLineRec."Unit of Measure Code") { }
                    column(UnitPrice; TempSalesCrMemoLineRec."Unit Price") { }
                    column(LineDiscountAmount; DiscountedAmount) { }
                    column(LineAmount; TempSalesCrMemoLineRec."Line Amount") { }
                    column(HSARegistrationNo; HSARegistrationNo) { }
                    column(ProdClassificationCode; ProdClassificationCode) { }
                    trigger OnPreDataItem()
                    begin
                        TempSalesCrMemoLineRec.Reset();
                        SetRange(Number, 1, TempSalesCrMemoLineRec.Count);
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
                            TempSalesCrMemoLineRec.FindFirst()
                        else
                            TempSalesCrMemoLineRec.Next();

                        if TempSalesCrMemoLineRec.Type = TempSalesCrMemoLineRec.Type::Item then begin
                            SNNo += 1;
                            Chr := 10;
                        end;

                        Clear(Description2);
                        Clear(Description2);
                        FromCompanyItemLedgerEntryRec.Reset();
                        if FromCompanyItemLedgerEntryRec.ChangeCompany(FilterCompanyName) then begin
                            FromCompanyItemLedgerEntryRec.SetRange("Document Type", FromCompanyItemLedgerEntryRec."Document Type"::"Sales Credit Memo");
                            FromCompanyItemLedgerEntryRec.SetRange("Document No.", TempSalesCrMemoLineRec."Document No.");
                            FromCompanyItemLedgerEntryRec.SetRange("Document Line No.", TempSalesCrMemoLineRec."Line No.");
                            FromCompanyItemLedgerEntryRec.SetRange("Item No.", TempSalesCrMemoLineRec."No.");
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
                            if FromCompanyItemRec.Get(TempSalesCrMemoLineRec."No.") then begin
                                HSARegistrationNo := FromCompanyItemRec.I9G_HSARegistrationNo;
                                ProdClassificationCode := FromCompanyItemRec.I9G_ProdClassificationCode;
                            end;
                        end;

                        If TempSalesCrMemoLineRec."Line Discount %" <> 0 then begin
                            DiscountedAmount := TempSalesCrMemoLineRec."Unit Price" - (TempSalesCrMemoLineRec."Unit Price" * (TempSalesCrMemoLineRec."Line Discount %" / 100));
                        end else begin
                            DiscountedAmount := 0;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        TempSalesCrMemoLineRec.DeleteAll();
                    end;
                }
                trigger OnPreDataItem()
                begin
                    TempSalesCrMemoHeaderRec.Reset();
                    SetRange(Number, 1, TempSalesCrMemoHeaderRec.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempSalesCrMemoHeaderRec.FindFirst()
                    else
                        TempSalesCrMemoHeaderRec.Next();
                end;

                trigger OnPostDataItem()
                begin
                    TempSalesCrMemoHeaderRec.DeleteAll();
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

                SetFilter("No.", FilterCreditMemoHeaderNo);
            end;

            trigger OnAfterGetRecord()
            var
                SalesCrMemoLineRec: Record "Sales Cr.Memo Line";
                NovemCU: Codeunit I9G_NovemEventSubscribers;
            begin
                ChangeCompanyRec(SalesCrMemoHeader);
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
                    field(FilterCreditMemoHeaderNo; FilterCreditMemoHeaderNo)
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
        layout("Sales Credit Note - 3PL")
        {
            Type = RDLC;
            LayoutFile = './ReportLayout/Rpt80132-PostedSalesCreditNote3PL.rdl';
        }
    }

    var
        CompanyInformationRec: Record "Company Information";
        TempSalesCrMemoHeaderRec: Record "Sales Cr.Memo Header" temporary;
        TempSalesCrMemoLineRec: Record "Sales Cr.Memo Line" temporary;
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        ReportConverter: Report I9G_ReportConverter;
        FilterCompanyName: Text;
        FilterCreditMemoHeaderNo: Text;
        ShowSignatuure: Boolean;
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
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        Footer: Text;

    procedure GetReportOptionAndFilter(par_FromCompanyName: Text[30]; par_SalesShipmentHeaderNo: Text)
    var
    begin
        FilterCompanyName := par_FromCompanyName;
        FilterCreditMemoHeaderNo := par_SalesShipmentHeaderNo;
    end;

    procedure ChangeCompanyRec(par_SalesCrMemoHeaderRec: Record "Sales Cr.Memo Header")
    var
        FromCompanySalesCrMemoHeaderRec: Record "Sales Cr.Memo Header";
        FromCompanySalesCrMemoLineRec: Record "Sales Cr.Memo Line";
        FromCompanyShipToAddressRec: Record "Ship-to Address";
        FromCompanyDimensionValue: Record "Dimension Value";
        FromCompanyGeneralLedgerSetupRec: Record "General Ledger Setup";
        FromCompanySalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        DimMgt: Codeunit DimensionManagement;
        NovemCU: Codeunit I9G_NovemEventSubscribers;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
    begin
        I9G_ThirdPartyLogisticSetupRec.Reset();
        I9G_ThirdPartyLogisticSetupRec.Get();
        if I9G_ThirdPartyLogisticSetupRec.I9G_WarehouseCompany = '' then begin
            ShowSignatuure := false;
        end;
        Clear(TotalAmount);
        Clear(TotalAmountInclVAT);
        Clear(TotalVATAmount);
        FromCompanySalesCrMemoHeaderRec.Reset();
        if FromCompanySalesCrMemoHeaderRec.ChangeCompany(FilterCompanyName) then begin
            FromCompanySalesCrMemoHeaderRec.SetRange(I9G_CreditMemoNo, par_SalesCrMemoHeaderRec."No.");
            if FromCompanySalesCrMemoHeaderRec.FindFirst() then begin
                TempSalesCrMemoHeaderRec.Reset();
                TempSalesCrMemoHeaderRec.Init();
                FromCompanySalesCrMemoHeaderRec.CalcFields(Amount, "Amount Including VAT");
                TempSalesCrMemoHeaderRec.TransferFields(FromCompanySalesCrMemoHeaderRec);
                TempSalesCrMemoHeaderRec.Insert();
                TotalAmount := FromCompanySalesCrMemoHeaderRec.Amount;
                TotalAmountInclVAT := FromCompanySalesCrMemoHeaderRec."Amount Including VAT";
                TotalVATAmount := TotalAmountInclVAT - TotalAmount;

                Clear(Footer);
                FromCompanySalesReceivablesSetupRec.Reset();
                if FromCompanySalesReceivablesSetupRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanySalesReceivablesSetupRec.Get();
                    Footer := FromCompanySalesReceivablesSetupRec.I9G_CreditNoteFooter;
                end;

            end;

            Clear(CurrencyCode);
            if FromCompanySalesCrMemoHeaderRec."Currency Code" <> '' then begin
                CurrencyCode := FromCompanySalesCrMemoHeaderRec."Currency Code";
            end else begin
                FromCompanyGeneralLedgerSetupRec.Reset();
                if FromCompanyGeneralLedgerSetupRec.ChangeCompany(FilterCompanyName) then begin
                    FromCompanyGeneralLedgerSetupRec.Get();
                    CurrencyCode := FromCompanyGeneralLedgerSetupRec."LCY Code";
                end;
            end;

            Clear(VATPercentageText);
            FromCompanySalesCrMemoLineRec.Reset();
            if FromCompanySalesCrMemoLineRec.ChangeCompany(FilterCompanyName) then begin
                FromCompanySalesCrMemoLineRec.SetRange("Document No.", FromCompanySalesCrMemoHeaderRec."No.");
                FromCompanySalesCrMemoLineRec.SetFilter("VAT %", '<>%1', 0);
                if FromCompanySalesCrMemoLineRec.FindFirst() then begin
                    VATPercentageText := 'ADD ' + format(FromCompanySalesCrMemoLineRec."VAT %") + '% GST';
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
            ReportConverter.FormatNoText(NoText, Abs(FromCompanySalesCrMemoHeaderRec."Amount Including VAT"), CurrencyCode);
            InputString := NoText[1] + ' ' + NoText[2] + ' ONLY';
            n := STRLEN(InputString);
            FOR i := 1 TO n DO
                IF (InputString[i] = ' ') AND (i < n) THEN BEGIN
                    IF NOT (InputString[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                        OutputString += FORMAT(InputString[i])
                END ELSE
                    OutputString += FORMAT(InputString[i]);
            OutputString := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString, '<>', ' '));


            NovemCU.FormatSelltoAddressNovem(SellToAddr, '', FromCompanySalesCrMemoHeaderRec."Sell-to Customer Name", FromCompanySalesCrMemoHeaderRec."Sell-to Customer Name 2", FromCompanySalesCrMemoHeaderRec."Bill-to Address", FromCompanySalesCrMemoHeaderRec."Bill-to Address 2", FromCompanySalesCrMemoHeaderRec.I9G_BillToAddress3);

            FromCompanySalesCrMemoLineRec.Reset();
            if FromCompanySalesCrMemoLineRec.ChangeCompany(FilterCompanyName) then begin
                FromCompanySalesCrMemoLineRec.SetRange("Document No.", FromCompanySalesCrMemoHeaderRec."No.");
                if FromCompanySalesCrMemoLineRec.FindSet() then begin
                    repeat
                        TempSalesCrMemoLineRec.Reset();
                        TempSalesCrMemoLineRec.Init();
                        TempSalesCrMemoLineRec.TransferFields(FromCompanySalesCrMemoLineRec);
                        TempSalesCrMemoLineRec.Insert();
                    until FromCompanySalesCrMemoLineRec.Next() = 0;
                end;
            end;
        end else begin
            Error('The sales credit note does not exists in partner company [%1]', FilterCompanyName);
        end;
    end;
}