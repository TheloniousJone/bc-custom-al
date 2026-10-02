report 70020 "I9G_PostedDirectTransfer"
{
    DefaultRenderingLayout = "Novem - Transfer Order";
    Caption = 'Transfer Order';
    ApplicationArea = All;

    dataset
    {
        dataitem(DirectTransHeader; "Direct Trans. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
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
            column(DocumentDate; Format("Posting Date", 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(Remarks; I9G_Remarks) { }
            column(DateUsed; Format(I9G_DateUsed, 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(TransferFromCode; "Transfer-from Code") { }
            column(TransferToCode; "Transfer-to Code") { }
            column(Salesperson; "Shortcut Dimension 1 Code") { }
            column(Admin; I9G_Admin) { }
            column(CaseDR; I9G_CaseDR) { }
            column(CaseNumber; I9G_CaseNumber) { }
            column(CustomerNo; I9G_CustomerNo) { }
            column(CustName; SellToAddr[1]) { }
            column(CustomerName; SellToAddr[2]) { }
            column(CustomerName2; SellToAddr[3]) { }
            column(CustomerAddress; SellToAddr[4]) { }
            column(CustomerAddress2; SellToAddr[5]) { }
            column(CustomerAddress3; SellToAddr[6]) { }
            column(DeliveryDate; Format(I9G_DeliveryDate, 0, '<Closing><Day,2>.<Month,2>.<Year>')) { }
            column(Consignment; I9G_Consignment) { }
            column(CurrencyCode; GeneralLedgerSetupRec."LCY Code") { }
            column(ReportHeader; ReportHeader) { }
            column(ReportHeader2; ReportHeader2) { }
            column(ReportFooter; ReportFooter) { }
            column(TotalAmount; TotalAmount) { }
            column(ShortcutDim7Code; ShortcutDimCode[7]) { }
            dataitem("DirectTransLine"; "Direct Trans. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(SNNo; SNNo) { }
                column(ItemCode; "Item No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; Description2) { }
                column(Quantity; Quantity) { }
                column(UOMCode; "Unit of Measure Code") { }
                column(UnitCost; GetItemRec."Unit Cost") { }
                column(LineAmount; Quantity * GetItemRec."Unit Cost") { }
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

                trigger OnAfterGetRecord();
                var
                    Item: Record Item;
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                begin
                    SNNo += 1;
                    Chr := 10;
                    GetItemRec.Reset();
                    GetItemRec := getItemRecord("Item No.");
                    Clear(Description2);
                    ItemLedgerEntryRec.Reset();
                    ItemLedgerEntryRec.SetRange("Document Type", ItemLedgerEntryRec."Document Type"::"Direct Transfer");
                    ItemLedgerEntryRec.SetRange("Document No.", DirectTransLine."Document No.");
                    ItemLedgerEntryRec.SetRange("Document Line No.", DirectTransLine."Line No.");
                    ItemLedgerEntryRec.SetRange("Item No.", DirectTransLine."Item No.");
                    ItemLedgerEntryRec.SetRange("Location Code", DirectTransLine."Transfer-from Code");
                    if ItemLedgerEntryRec.FindSet() then begin
                        repeat
                            if Description2 = '' then
                                Description2 := 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity))
                            else
                                Description2 += Chr + 'BN : ' + ItemLedgerEntryRec."Lot No." + '(EXP : ' + Format(ItemLedgerEntryRec."Expiration Date", 0, '<Closing><Day,2>-<Month,2>-<Year,2>') + '), QTY : ' + Format(Abs(ItemLedgerEntryRec.Quantity));
                        until ItemLedgerEntryRec.Next() = 0;
                    end;

                    HSARegistrationNo := GetItemRec.I9G_HSARegistrationNo;
                    ProdClassificationCode := GetItemRec.I9G_ProdClassificationCode;
                end;
            }
            trigger OnAfterGetRecord()
            var
                DirectTransLineRec: Record "Direct Trans. Line";
                DimMgt: Codeunit DimensionManagement;
                NovemCU: Codeunit I9G_NovemEventSubscribers;
                CustRec: Record Customer;
            begin
                Clear(ReportHeader);
                Clear(ReportHeader2);
                Clear(ReportFooter);
                if I9G_Consignment = true then begin
                    ReportHeader := 'CONSIGNMENT NOTE';
                    ReportHeader2 := 'CONSIGNMENT NOTE NO.';
                    ReportFooter := SalesReceivablesSetupRec.I9G_TransferOrderFooter;
                end else begin
                    ReportHeader := 'INVENTORY TRANSFER';
                    ReportHeader2 := 'TRANSFER REF. NO.';
                    ReportFooter := 'FOR INTERNAL INVENTORY TRANSFERS ONLY';
                end;
                Clear(TotalAmount);
                DirectTransLineRec.Reset();
                DirectTransLineRec.SetRange("Document No.", DirectTransHeader."No.");
                if DirectTransLineRec.FindSet() then begin
                    repeat
                        GetItemRec.Reset();
                        GetItemRec := getItemRecord(DirectTransLineRec."Item No.");
                        TotalAmount += DirectTransLineRec.Quantity * GetItemRec."Unit Cost";
                    until DirectTransLineRec.Next() = 0;
                end;

                Clear(ShortcutDimCode);
                DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);

                Clear(CustName);
                CustRec.Reset();
                if CustRec.Get(I9G_CustomerNo) then begin
                    CustName := CustRec.Name;
                end;
                NovemCU.FormatSelltoAddressNovem(SellToAddr, CustName, I9G_CustomerName, I9G_CustomerName2, I9G_CustomerAddress, I9G_CustomerAddress2, I9G_CustomerAddress3);
            end;
        }
    }
    rendering
    {
        layout("Novem - Transfer Order")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70020-TransferOrder.rdl';
        }
    }
    trigger OnPreReport();
    begin
        CompanyInformationRec.Get();
        GeneralLedgerSetupRec.Get();
        CompanyInformationRec.CalcFields(Picture);
        SalesReceivablesSetupRec.Get();
    end;

    local procedure getItemRecord(par_ItemNo: Code[20]): Record "Item"
    var
        ItemRec: Record Item;
    begin
        ItemRec.Reset();
        ItemRec.SetRange("No.", par_ItemNo);
        if ItemRec.FindFirst() then
            exit(ItemRec);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
        GetItemRec: Record Item;
        SNNo: Integer;
        TotalAmount: Decimal;
        Description2: Text;
        ReportHeader: Text[100];
        ReportHeader2: Text[100];
        ReportFooter: Text[2048];
        ShortcutDimCode: array[8] of Code[20];
        HSARegistrationNo: Text[20];
        ProdClassificationCode: Code[25];
        SellToAddr: array[6] of Text[250];
        Chr: Char;
        CustName: Text[100];
}