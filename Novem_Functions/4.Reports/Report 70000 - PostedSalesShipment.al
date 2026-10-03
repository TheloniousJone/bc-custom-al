report 70000 "I9G_PostedSalesShipment"
{
    DefaultRenderingLayout = "Novem - Signed Order / Delivery Order";
    Caption = 'Signed Order / Delivery Order';
    ApplicationArea = All;

    dataset
    {
        dataitem("SalesShipmentHeader"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(CompanyAddress; CompanyInformationRec.Address) { }
            column(CompanyAddress2; CompanyInformationRec."Address 2") { }
            column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
            column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
            column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
            column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
            column(DocumentNo; "No.") { }
            column(DocumentDate; Format("Document Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(SelltoCustomerNo; "Sell-to Customer No.") { }
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
            column(Purchaser; I9G_Purchaser) { }
            column(DRIC; I9G_DRIC) { }
            column(Remarks; I9G_Remarks) { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(ExternalDocNo; "External Document No.") { }
            column(Salesperson; SalesEmployeeName) { }
            column(Admin; I9G_Admin) { }
            column(CaseNumber; I9G_CaseNumber) { }
            column(ShipmentDate; Format("Shipment Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(SignedOrder; I9G_SignedOrder) { }
            column(DeliveryOrder; I9G_DeliveryOrder) { }
            column(ReportHeader; ReportHeader) { }
            column(ReportHeader2; ReportHeader2) { }
            column(ReportHeader3; ReportHeader3) { }
            column(ReportFooter; ReportFooter) { }
            column(ReportFooter2; ReportFooter2) { }
            column(ReportFooter3; ReportFooter3) { }
            column(ReportFooter4; ReportFooter4) { }
            column(ReportFooter5; ReportFooter5) { }
            dataitem("SalesShipmentLine"; "Sales Shipment Line")
            {
                DataItemLinkReference = SalesShipmentHeader;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                column(SNNo; SNNo) { }
                column(ItemType; Type) { }
                column(ItemCode; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; Description2) { }
                column(Quantity; Quantity) { }
                column(UOMCode; "Unit of Measure Code") { }
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

                    if SalesShipmentLine.Type = SalesShipmentLine.Type::Item then begin
                        SNNo += 1;
                        Chr := 10;

                        ItemLedgerEntryRec.Reset();
                        ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Sales Shipment");
                        ItemLedgerEntryRec.SetRange("Document No.", SalesShipmentLine."Document No.");
                        ItemLedgerEntryRec.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                        ItemLedgerEntryRec.SetRange("Item No.", SalesShipmentLine."No.");
                        if ItemLedgerEntryRec.FindSet() then begin
                            repeat
                                if Description2 = '' then
                                    Description2 := 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity))
                                else
                                    Description2 += Chr + 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity));
                            until ItemLedgerEntryRec.Next() = 0;
                        end;

                        Item.Reset();
                        if Item.Get(SalesShipmentLine."No.") then begin
                            HSARegistrationNo := Item.I9G_HSARegistrationNo;
                            ProdClassificationCode := Item.I9G_ProdClassificationCode;
                        end;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                ShipToAddressRec: Record "Ship-to Address";
                DimensionValue: Record "Dimension Value";
                DimMgt: Codeunit DimensionManagement;
                NovemCU: Codeunit I9G_NovemEventSubscribers;
            begin
                Clear(ReportHeader);
                Clear(ReportHeader2);
                Clear(ReportHeader3);
                Clear(ReportFooter);
                Clear(ReportFooter2);
                Clear(ReportFooter3);
                Clear(ReportFooter4);
                Clear(ReportFooter5);
                SalesReceivablesSetupRec.Get();
                if SalesShipmentHeader.I9G_SignedOrder = true then begin
                    ReportHeader := 'SIGNED ORDER';
                    ReportHeader2 := 'SIGNED ORDER / PICK LIST NO. :';
                    ReportHeader3 := 'ORDERED BY :';
                    ReportFooter := SalesReceivablesSetupRec.I9G_SignedOrderFooter;
                    ReportFooter2 := 'GOODS PACKED BY / CHECKED BY :';
                    ReportFooter3 := 'STORE SIGNATURE / AUTHORISED SIGNATURE';
                    ReportFooter4 := 'GOODS ORDERED BY :';
                    ReportFooter5 := 'AUTHORISED SIGNATURE';
                end else begin
                    ReportHeader := 'DELIVERY ORDER';
                    ReportHeader2 := 'DELIVERY ORDER NO. :';
                    ReportHeader3 := 'BILL TO :';
                    ReportFooter := SalesReceivablesSetupRec.I9G_DeliveryOrderFooter;
                    ReportFooter2 := 'FOR ' + UpperCase(CompanyInformationRec.Name);
                    ReportFooter3 := 'AUTHORISED SIGNATURE';
                    ReportFooter4 := 'RECEIVED IN GOOD CONDITION';
                    ReportFooter5 := 'CUSTOMER SIGNATURE AND DATE';
                end;
                ShipToAddressRec.Reset();
                ShipToAddressRec.SetRange("Customer No.", SalesShipmentHeader."Sell-to Customer No.");
                ShipToAddressRec.SetRange(Code, SalesShipmentHeader."Ship-to Code");
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
                NovemCU.FormatShiptoAddressNovem(ShipToAddr, "Sell-to Customer Name", "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", I9G_ShipToAddress3, ShipToTel);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
    }
    rendering
    {
        layout("Novem - Signed Order / Delivery Order")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70000-SignedOrderDeliveryOrder.rdl';
        }
    }
    trigger OnInitReport()
    var
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
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
}