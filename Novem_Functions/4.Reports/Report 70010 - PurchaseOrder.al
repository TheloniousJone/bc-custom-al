report 70010 "I9G_PurchaseOrder"
{
    DefaultRenderingLayout = "Novem - Purchase Orders";
    Caption = 'Purchase Order';
    ApplicationArea = All;

    dataset
    {
        dataitem("PurchaseHeader"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.") where("Document Type" = const(Order));
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
            column(PayToContactNo; GetContactRec."Phone No.") { }
            column(PayToEmail; GetVendorRec."E-Mail") { }
            column(PayToTel; GetVendorRec."Phone No.") { }
            column(PayToFax; GetVendorRec."Fax No.") { }
            column(Remarks; I9G_Remarks) { }
            column(PaymentTerms; "Payment Terms Code") { }
            column(VendorInvoiceNo; "Vendor Invoice No.") { }
            column(ShipmentDate; Format(I9G_ShipmentDate, 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(ShipVia; I9G_ShipVia) { }
            column(DeliverTo; CompanyInformationRec.Address + ', ' + CompanyInformationRec."Address 2") { }
            column(DocumentsRequired; CompanyInformationRec.I9G_DocumentRequired) { }
            column(SpecialInstructions; I9G_SpecialInstructions) { }
            column(ShippingConfig; I9G_ShippingConfig) { }
            column(TotalAmount; Amount) { }
            column(VATPercentageText; VATPercentageText) { }
            column(TotalVATAmount; "Amount Including VAT" - Amount) { }
            column(TotalAmountInclVAT; "Amount Including VAT") { }
            column(CurrencyCode; CurrencyCode) { }
            column(CurrencyFactor; CurrencyFactor) { }
            dataitem("PurchaseLine"; "Purchase Line")
            {
                DataItemLinkReference = PurchaseHeader;
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
                column(SNNo; SNNo) { }
                column(ItemType; Type) { }
                column(ItemCode; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; Description2) { }
                column(Quantity; Quantity) { }
                column(UOMCode; "Unit of Measure Code") { }
                column(PurchasePrice; "Purchase Price") { }
                column(UnitCost; "Unit Cost") { }
                column(LineDiscountAmount; "Line Discount Amount") { }
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
                end;

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    if PurchaseLine.Type = PurchaseLine.Type::Item then begin
                        SNNo += 1;

                        Item.Reset();
                        if Item.Get("PurchaseLine"."No.") then begin
                            HSARegistrationNo := Item.I9G_HSARegistrationNo;
                            ProdClassificationCode := Item.I9G_ProdClassificationCode;
                        end;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                PurchaseLineRec: Record "Purchase Line";
                VendorRec: Record Vendor;
            begin
                GetContactRec.Reset();
                if GetContactRec.Get(PurchaseHeader."Pay-to Contact No.") then;
                PurchaseLineRec.Reset();
                Clear(VATPercentageText);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLineRec.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLineRec.SetFilter("VAT %", '<>%1', 0);
                if PurchaseLineRec.FindFirst() then begin
                    VATPercentageText := 'ADD ' + format(PurchaseLineRec."VAT %") + '% GST';
                end else begin
                    VATPercentageText := 'ADD 0% GST';
                end;
                Clear(CurrencyCode);
                if PurchaseHeader."Currency Code" <> '' then begin
                    CurrencyCode := PurchaseHeader."Currency Code"
                end else begin
                    CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                end;
                GetVendorRec.Reset();
                GetVendorRec := getPayToVendorRecord(PurchaseHeader."Pay-to Vendor No.");
                Clear(CurrencyFactor);
                if PurchaseHeader."Currency Factor" = 0 then begin
                    CurrencyFactor := CurrencyCode;
                end else begin
                    CurrencyFactor := CurrencyCode + ' / ' + Format(Round(1 / PurchaseHeader."Currency Factor", 0.00001, '='));
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
        layout("Novem - Purchase Orders")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70010-PurchaseOrder.rdl';
        }
    }
    trigger OnPreReport()
    var
    begin
        CompanyInformationRec.Get();
        GeneralLedgerSetupRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    local procedure getPayToVendorRecord(par_PayToVendorNo: Code[20]): Record "Vendor"
    var
        VendorRec: Record Vendor;
    begin
        VendorRec.Reset();
        VendorRec.SetRange("No.", par_PayToVendorNo);
        if VendorRec.FindFirst() then
            exit(VendorRec);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        GetVendorRec: Record Vendor;
        GetContactRec: Record Contact;
        CurrencyCode: Code[10];
        CurrencyFactor: Code[50];
        VATPercentageText: Text[25];
        SNNo: Integer;
        Description2: Text[300];
        PayToEmail: Text[500];
        HSARegistrationNo: Text[20];
        ProdClassificationCode: Code[25];
}