codeunit 70000 "I9G_NovemEventSubscribers"
{
    Permissions = tabledata "Company Information" = rimd, tabledata "Sales Header" = rimd;
    /*General Functions --- Start*/
    procedure GetCompanyCheck(): Boolean
    var
        CompanyInformationRec: Record "Company Information";
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;

    procedure GetSelectionFilter(var TempRecRef: RecordRef; SelectionFieldID: Integer): Text
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
    begin
        if TempRecRef.IsTemporary then begin
            RecRef := TempRecRef.Duplicate();
            RecRef.Reset();
        end else
            RecRef.Open(TempRecRef.Number, false, TempRecRef.CurrentCompany);

        TempRecRef.Ascending(true);
        if TempRecRef.FindSet() then begin
            repeat
                RecRef.SetPosition(TempRecRef.GetPosition());
                RecRef.Find();
                FieldRef := RecRef.Field(SelectionFieldID);
                if SelectionFilter <> '' then begin
                    SelectionFilter := SelectionFilter + '|' + Format(FieldRef.Value);
                end else begin
                    SelectionFilter := Format(FieldRef.Value);
                end;
            until TempRecRef.Next() = 0;
        end;
        exit(SelectionFilter);
    end;

    procedure I9G_TerminationDateStatusCheck()
    var
        SalesHeaderRec: Record "Sales Header";
        NullDate: Date;
    begin
        if GetCompanyCheck() = true then begin
            Clear(NullDate);
            SalesHeaderRec.Reset();
            SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::"Blanket Order");
            SalesHeaderRec.SetFilter(I9G_TerminationDate, '<>%1', SalesHeaderRec.I9G_TerminationDate::Closed);
            SalesHeaderRec.SetFilter(I9G_EndDate, '<%1|%2', WorkDate(), NullDate);
            if SalesHeaderRec.FindSet() then begin
                repeat
                    SalesHeaderRec.Validate(I9G_TerminationDate, SalesHeaderRec.I9G_TerminationDate::Closed);
                    SalesHeaderRec.Modify(false);
                until SalesHeaderRec.Next() = 0;
            end;
        end;
    end;

    procedure I9G_CustomerLicenseStatusCheck()
    var
        ShipToAddressRec: Record "Ship-to Address";
        SalesReceivableSetupRec: Record "Sales & Receivables Setup";
        NullDate: Date;
    begin
        if GetCompanyCheck() = true then begin
            SalesReceivableSetupRec.Get();
            SalesReceivableSetupRec.TestField(I9G_CustomerLicenseExpiration);
            ShipToAddressRec.Reset();
            if ShipToAddressRec.FindSet() then begin
                repeat
                    if ShipToAddressRec.I9G_LicenseEndDate <> 0D then begin
                        if ShipToAddressRec.I9G_LicenseEndDate < WorkDate() then begin
                            ShipToAddressRec.Validate(I9G_LicenseStatus, I9G_LicenseStatus::Expired);
                        end else begin
                            if (ShipToAddressRec.I9G_LicenseEndDate - WorkDate() > SalesReceivableSetupRec.I9G_CustomerLicenseExpiration) then begin
                                ShipToAddressRec.Validate(I9G_LicenseStatus, I9G_LicenseStatus::New);
                            end else begin
                                ShipToAddressRec.Validate(I9G_LicenseStatus, I9G_LicenseStatus::Soon);
                            end;
                        end;
                    end else begin
                        ShipToAddressRec.Validate(I9G_LicenseStatus, I9G_LicenseStatus::New);
                    end;
                    ShipToAddressRec.Modify();
                until ShipToAddressRec.Next = 0;
            end;
        end;
    end;
    /*General Functions --- End*/

    /*Ledger Entry Modules --- Start*/
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnAfterCopyCustLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Cust. Ledger Entry_OnAfterCopyCustLedgerEntryFromGenJnlLine"(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        if GetCompanyCheck() = true then begin
            CustLedgerEntry.I9G_Remarks := GenJournalLine.I9G_Remarks;
            CustLedgerEntry.I9G_ChequeDetails := GenJournalLine.I9G_ChequeDetails;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GetCompanyCheck() = true then begin
            GLEntry.I9G_Remarks := GenJournalLine.I9G_Remarks;
            GLEntry.I9G_ChequeDetails := GenJournalLine.I9G_ChequeDetails;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Vendor Ledger Entry_OnAfterCopyVendLedgerEntryFromGenJnlLine"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        if GetCompanyCheck() = true then begin
            VendorLedgerEntry.I9G_Remarks := GenJournalLine.I9G_Remarks;
            VendorLedgerEntry.I9G_ChequeDetails := GenJournalLine.I9G_ChequeDetails;
        end;
    end;
    /*Ledger Entry Modules --- End*/

    /*Report Substitute --- Start*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, OnAfterSubstituteReport, '', false, false)]
    local procedure OnAfterSubstituteReport(ReportId: Integer; RunMode: Option; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer);
    var
    begin
        if GetCompanyCheck() = true then begin
            if ReportId = Report::"Aged Accounts Payable" then
                NewReportId := Report::I9G_AgedAccountsPayable;
            if ReportId = Report::"Aged Accounts Receivable" then
                NewReportId := Report::I9G_AgedAccountsReceivable;
        end;
    end;
    /*Report Substitute --- End*/

    /*Purchase Module --- Start*/
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnInitOutstandingOnBeforeInitOutstandingAmount, '', false, false)]
    local procedure "PurchaseLineOnInitOutstandingOnBeforeInitOutstandingAmount"(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line")
    var
        PurchaseLineRec: Record "Purchase Line";
        PurchaseHeaderRec: Record "Purchase Header";
    begin
        if GetCompanyCheck() = true then begin
            PurchaseLine.I9G_CompletelyReceived := PurchaseLine."Completely Received";
            if PurchaseLine.I9G_CompletelyReceived = false then begin
                PurchaseHeaderRec.Reset();
                PurchaseHeaderRec.SetRange("Document Type", PurchaseLine."Document Type");
                PurchaseHeaderRec.SetRange("No.", PurchaseLine."Document No.");
                if PurchaseHeaderRec.FindFirst() then begin
                    PurchaseHeaderRec.I9G_CompletelyReceived := false;
                    PurchaseHeaderRec.Modify();
                end;
            end else begin
                PurchaseHeaderRec.Reset();
                PurchaseHeaderRec.SetRange("Document Type", PurchaseLine."Document Type");
                PurchaseHeaderRec.SetRange("No.", PurchaseLine."Document No.");
                if PurchaseHeaderRec.FindFirst() then begin
                    PurchaseLineRec.Reset();
                    PurchaseLineRec.SetRange("Document Type", PurchaseLine."Document Type");
                    PurchaseLineRec.SetRange("Document No.", PurchaseLine."Document No.");
                    PurchaseLineRec.SetRange(I9G_CompletelyReceived, false);
                    PurchaseLineRec.SetFilter("Line No.", '<>%1', PurchaseLine."Line No.");
                    if PurchaseLineRec.FindFirst() then begin
                        PurchaseHeaderRec.I9G_CompletelyReceived := false;
                        PurchaseHeaderRec.Modify();
                    end else begin
                        PurchaseHeaderRec.I9G_CompletelyReceived := true;
                        PurchaseHeaderRec.Modify();
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterInitOutstandingQty, '', false, false)]
    local procedure "PurchaseLineOnAfterInitOutstandingQty"(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line")
    var
    begin
        if GetCompanyCheck() = true then begin
            PurchaseLine.I9G_CompletelyReceived := (PurchaseLine.Quantity <> 0) and (PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced" = 0);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopyPurchDocOnBeforeCopyPurchDocInvLine, '', false, false)]
    local procedure "CopyDocumentMgtOnCopyPurchDocOnBeforeCopyPurchDocInvLine"(var FromPurchInvHeader: Record "Purch. Inv. Header"; var ToPurchaseHeader: Record "Purchase Header")
    var
    begin
        if GetCompanyCheck() = true then begin
            ToPurchaseHeader.I9G_ReferenceInvoiceNo := FromPurchInvHeader."No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterUpdateVendLedgEntry, '', false, false)]
    local procedure "Copy Document Mgt._OnAfterUpdateVendLedgEntry"(var PurchaseHeader: Record "Purchase Header"; FromDocumentNo: Code[20])
    var
    begin
        if GetCompanyCheck() = true then begin
            PurchaseHeader.I9G_ReferenceInvoiceNo := FromDocumentNo;
            PurchaseHeader.Modify();
        end;
    end;
    /*Purchase Module --- End*/

    /*Sales Module --- Start*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", OnAfterRun, '', false, false)]
    local procedure "Blanket Sales Order to Order_OnAfterRun"(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        SalesLineRec: Record "Sales Line";
    begin
        if GetCompanyCheck() = true then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Blanket Order" then begin
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", SalesHeader."Document Type");
                SalesLineRec.SetRange("Document No.", SalesHeader."No.");
                SalesLineRec.SetFilter("Qty To Deliver", '<>%1', 0);
                if SalesLineRec.FindSet() then begin
                    repeat
                        SalesLineRec.Validate("Qty To Deliver", 0);
                        SalesLineRec.Modify(false);
                    until SalesLineRec.Next() = 0;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", OnAfterRun, '', false, false)]
    local procedure "BlanketSalesOrderToOrderOnAfterRun"(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
    begin
        if GetCompanyCheck() = true then begin
            SalesOrderHeader.I9G_BlanketSalesOrder := true;
            SalesOrderHeader.I9G_BlanketSalesOrderNo := SalesHeader."No.";
            SalesOrderHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterUpdateBlanketOrderLine, '', false, false)]
    local procedure "Sales-Post_OnAfterUpdateBlanketOrderLine"(var BlanketOrderSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; Ship: Boolean; Receive: Boolean; Invoice: Boolean)
    var
    begin
        if GetCompanyCheck() = true then begin
            BlanketOrderSalesLine.Validate(I9G_OpenQuantity, BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced");
            BlanketOrderSalesLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInitOutstanding, '', false, false)]
    local procedure "SalesLineOnAfterInitOutstanding"(var SalesLine: Record "Sales Line")
    var
    begin
        if GetCompanyCheck() = true then begin
            SalesLine.Validate(I9G_OpenQuantity, SalesLine.Quantity - SalesLine."Quantity Invoiced");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopySalesDocOnBeforeCopySalesDocInvLine, '', false, false)]
    local procedure "CopyDocumentMgtOnCopySalesDocOnBeforeCopySalesDocInvLine"(var FromSalesInvoiceHeader: Record "Sales Invoice Header"; var ToSalesHeader: Record "Sales Header")
    var
    begin
        if GetCompanyCheck() = true then begin
            ToSalesHeader.I9G_ReferenceInvoiceNo := FromSalesInvoiceHeader."No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterUpdateCustLedgerEntry, '', false, false)]
    local procedure "Copy Document Mgt._OnAfterUpdateCustLedgerEntry"(var ToSalesHeader: Record "Sales Header"; FromDocType: Enum "Gen. Journal Document Type"; FromDocNo: Code[20]; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
    begin
        if GetCompanyCheck() = true then begin
            ToSalesHeader.I9G_ReferenceInvoiceNo := FromDocNo;
            ToSalesHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeOnRun, '', false, false)]
    local procedure "Sales-Post (Yes/No)_OnBeforeOnRun"(var SalesHeader: Record "Sales Header")
    var
    begin
        if GetCompanyCheck() = true then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                if (SalesHeader.I9G_SignedOrder = false) and (SalesHeader.I9G_DeliveryOrder = false) then begin
                    Error('Please indicate posting for Signed Order or Delivery order.');
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopyShiptoCodeFromInvToCrMemo, '', false, false)]
    local procedure "Copy Document Mgt._OnAfterCopyShiptoCodeFromInvToCrMemo"(var ToSalesHeader: Record "Sales Header"; FromSalesInvHeader: Record "Sales Invoice Header"; FromDocType: Enum "Sales Document Type From")
    begin
        if GetCompanyCheck() = true then begin
            if ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::"Credit Memo" then begin
                ToSalesHeader."I9G_Name (CN)" := FromSalesInvHeader."Ship-to Name";
                ToSalesHeader."I9G_Ship-to Name 2 (CN)" := FromSalesInvHeader."Ship-to Name 2";
                ToSalesHeader."I9G_Address (CN)" := FromSalesInvHeader."Ship-to Address";
                ToSalesHeader."I9G_Address 2 (CN)" := FromSalesInvHeader."Ship-to Address 2";
                ToSalesHeader."I9G_Address 3 (CN)" := FromSalesInvHeader.I9G_ShipToAddress3;
                ToSalesHeader."I9G_District Code (CN)" := FromSalesInvHeader.I9G_ShipToDistrictCode;
                ToSalesHeader."I9G_City (CN)" := FromSalesInvHeader."Ship-to City";
                ToSalesHeader."I9G_Postcode (CN)" := FromSalesInvHeader."Ship-to Post Code";

                ToSalesHeader.I9G_ShipToAddress3 := '';
                ToSalesHeader.I9G_ShipToDistrictCode := '';
                ToSalesHeader.Modify();
            end;
        end;
    end;
    /*Sales Module --- End*/

    /*Transfer Module --- Start*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnBeforeInsertTransShptHeader, '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header")
    var
    begin
        if GetCompanyCheck() = true then begin
            TransShptHeader.I9G_Admin := TransHeader.I9G_Admin;
            TransShptHeader.I9G_Consignment := TransHeader.I9G_Consignment;
            TransShptHeader.I9G_CustomerNo := TransHeader.I9G_CustomerNo;
            TransShptHeader.I9G_CustomerName := TransHeader.I9G_CustomerName;
            TransShptHeader.I9G_CustomerName2 := TransHeader.I9G_CustomerName2;
            TransShptHeader.I9G_CustomerAddress := TransHeader.I9G_CustomerAddress;
            TransShptHeader.I9G_CustomerAddress2 := TransHeader.I9G_CustomerAddress2;
            TransShptHeader.I9G_CustomerAddress3 := TransHeader.I9G_CustomerAddress3;
            TransShptHeader.I9G_ShiptoCode := TransHeader.I9G_ShiptoCode;
            TransShptHeader.I9G_Remarks := TransHeader.I9G_Remarks;
            TransShptHeader.I9G_CaseNumber := TransHeader.I9G_CaseNumber;
            TransShptHeader.I9G_CaseDR := TransHeader.I9G_CaseDR;
            TransShptHeader.I9G_DateUsed := TransHeader.I9G_DateUsed;
            TransShptHeader."I9G_Deliverydate" := TransHeader."I9G_DeliveryDate";
            TransShptHeader.I9G_InternalRemarks := TransHeader.I9G_InternalRemarks;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforeTransRcptHeaderInsert, '', false, false)]
    local procedure "TransferOrderPostReceiptOnBeforeTransRcptHeaderInsert"(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    var
    begin
        if GetCompanyCheck() = true then begin
            TransferReceiptHeader.I9G_Admin := TransferHeader.I9G_Admin;
            TransferReceiptHeader.I9G_Consignment := TransferHeader.I9G_Consignment;
            TransferReceiptHeader.I9G_CustomerNo := TransferHeader.I9G_CustomerNo;
            TransferReceiptHeader.I9G_CustomerName := TransferHeader.I9G_CustomerName;
            TransferReceiptHeader.I9G_CustomerName2 := TransferHeader.I9G_CustomerName2;
            TransferReceiptHeader.I9G_CustomerAddress := TransferHeader.I9G_CustomerAddress;
            TransferReceiptHeader.I9G_CustomerAddress2 := TransferHeader.I9G_CustomerAddress2;
            TransferReceiptHeader.I9G_CustomerAddress3 := TransferHeader.I9G_CustomerAddress3;
            TransferReceiptHeader.I9G_ShiptoCode := TransferHeader.I9G_ShiptoCode;
            TransferReceiptHeader.I9G_Remarks := TransferHeader.I9G_Remarks;
            TransferReceiptHeader.I9G_CaseNumber := TransferHeader.I9G_CaseNumber;
            TransferReceiptHeader.I9G_CaseDR := TransferHeader.I9G_CaseDR;
            TransferReceiptHeader.I9G_DateUsed := TransferHeader.I9G_DateUsed;
            TransferReceiptHeader."I9G_Deliverydate" := TransferHeader."I9G_DeliveryDate";
            TransferReceiptHeader.I9G_InternalRemarks := TransferHeader.I9G_InternalRemarks;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", OnInsertDirectTransHeaderOnBeforeDirectTransHeaderInsert, '', false, false)]
    local procedure "OnInsertDirectTransHeaderOnBeforeDirectTransHeaderInsert"(var DirectTransHeader: Record "Direct Trans. Header"; TransferHeader: Record "Transfer Header");
    var
    begin
        if GetCompanyCheck() = true then begin
            DirectTransHeader.I9G_Admin := TransferHeader.I9G_Admin;
            DirectTransHeader.I9G_Consignment := TransferHeader.I9G_Consignment;
            DirectTransHeader.I9G_CustomerNo := TransferHeader.I9G_CustomerNo;
            DirectTransHeader.I9G_CustomerName := TransferHeader.I9G_CustomerName;
            DirectTransHeader.I9G_CustomerName2 := TransferHeader.I9G_CustomerName2;
            DirectTransHeader.I9G_CustomerAddress := TransferHeader.I9G_CustomerAddress;
            DirectTransHeader.I9G_CustomerAddress2 := TransferHeader.I9G_CustomerAddress2;
            DirectTransHeader.I9G_CustomerAddress3 := TransferHeader.I9G_CustomerAddress3;
            DirectTransHeader.I9G_ShiptoCode := TransferHeader.I9G_ShiptoCode;
            DirectTransHeader.I9G_Remarks := TransferHeader.I9G_Remarks;
            DirectTransHeader.I9G_CaseNumber := TransferHeader.I9G_CaseNumber;
            DirectTransHeader.I9G_CaseDR := TransferHeader.I9G_CaseDR;
            DirectTransHeader.I9G_DateUsed := TransferHeader.I9G_DateUsed;
            DirectTransHeader."I9G_Deliverydate" := TransferHeader."I9G_DeliveryDate";
            DirectTransHeader.I9G_InternalRemarks := TransferHeader.I9G_InternalRemarks;
            DirectTransHeader."No." := TransferHeader."No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", OnAfterInsertDirectTransLine, '', false, false)]
    local procedure "TransferOrder-Post Transfer_OnAfterInsertDirectTransLine"(var DirectTransLine: Record "Direct Trans. Line"; DirectTransHeader: Record "Direct Trans. Header"; TransLine: Record "Transfer Line")
    var
        ReservEnt: Record "Reservation Entry";
    begin
        ReservEnt.Reset();
        ReservEnt.SetFilter("Source Type", '%1', 5741);
        ReservEnt.SetFilter("Source Subtype", '%1', 1);
        ReservEnt.SetRange("Source ID", DirectTransLine."Document No.");
        ReservEnt.SetRange("Source Ref. No.", DirectTransLine."Line No.");
        if ReservEnt.FindFirst() then begin
            ReservEnt.PostedTO := true;
            ReservEnt.Modify();
        end;
    end;
    /*Transfer Module --- End*/

    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterOnInsert, '', false, false)]
    local procedure Customer_OnAfterOnInsert(var Customer: Record Customer; xCustomer: Record Customer)
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        if GetCompanyCheck() = true then begin
            Customer.Validate("Gen. Bus. Posting Group", 'LOCAL');
            Customer.Validate("VAT Bus. Posting Group", 'LOCAL');
            Customer.Validate("Customer Posting Group", 'TRADE EXTERNAL');
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Ship-to Address", OnAfterOnNewRecord, '', false, false)]
    local procedure ShipToAddress_OnAfterOnNewRecord(var Customer: Record Customer; var ShipToAddress: Record "Ship-to Address")
    begin
        if GetCompanyCheck() = true then begin
            ShipToAddress.Validate(I9G_Address3, Customer.I9G_Adddress3);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeValidateShipToCode, '', false, false)]
    local procedure OnBeforeValidateShipToCode(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Cust: Record Customer; ShipToAddr: Record "Ship-to Address"; var IsHandled: Boolean)
    begin
        if GetCompanyCheck() = true then begin
            if ShipToAddr.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then begin
                if ShipToAddr.I9G_LicenseStatus = ShipToAddr.I9G_LicenseStatus::Expired then begin
                    Error('The license status must not be expired.');
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmSalesPost, '', false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    var
        SalesLine: Record "Sales Line";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if GetCompanyCheck() = true then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetFilter(Quantity, '<>%1', 0);
            SalesLine.SetFilter("Selling Price", '%1', 0);
            if SalesLine.FindFirst() then begin
                if not ConfirmManagement.GetResponseOrDefault(StrSubstNo('Item No. %1 has 0 selling price, do you want to proceed with posting?', SalesLine."No."), true) then begin
                    IsHandled := true;
                    exit;
                end;
            end;

            DefaultOption := 1;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeConfirmPost, '', false, false)]
    local procedure OnBeforeConfirmPurchasePost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if GetCompanyCheck() = true then begin
            DefaultOption := 1;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnSetBillToCustomerAddressFieldsFromCustomerOnAfterAssignBillToCustomerAddress, '', false, false)]
    procedure OnSetBillToCustomerAddressFieldsFromCustomerOnAfterAssignBillToCustomerAddress(var SalesHeader: Record "Sales Header"; Customer: Record Customer)
    begin
        if GetCompanyCheck() = true then begin
            SalesHeader.I9G_BillToAddress3 := Customer.I9G_Adddress3;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterCopySellToAddressToBillToAddress, '', false, false)]
    local procedure OnAfterCopySellToAddressToBillToAddress(var SalesHeader: Record "Sales Header")
    begin
        if GetCompanyCheck() = true then begin
            SalesHeader.I9G_BillToAddress3 := SalesHeader.I9G_SellToAddress3;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", OnPostOnBeforePostedAssemblyHeaderInsert, '', false, false)]
    local procedure OnPostOnBeforePostedAssemblyHeaderInsert(AssemblyHeader: Record "Assembly Header"; var PostedAssemblyHeader: Record "Posted Assembly Header")
    begin
        if GetCompanyCheck() = true then begin
            PostedAssemblyHeader."No." := AssemblyHeader."No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeBlanketOrderSalesLineModify, '', false, false)]
    local procedure OnBeforeBlanketOrderSalesLineModify(var BlanketOrderSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line")
    begin
        if GetCompanyCheck() = true then begin
            BlanketOrderSalesLine.Validate("Qty To Deliver", BlanketOrderSalesLine."Order Qty" - BlanketOrderSalesLine."Quantity Shipped");
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnAfterOnValidateItemNoAssignByEntryType, '', false, false)]
    // local procedure OnAfterOnValidateItemNoAssignByEntryType(var ItemJournalLine: Record "Item Journal Line"; var Item: Record Item)
    // begin
    //     if GetCompanyCheck() = true then begin
    //         ItemJournalLine.Validate("Location Code", Item.I9G_ItemLocationCode);
    //     end;
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnAfterCopyItemJnlLineFromSalesHeader, '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        if GetCompanyCheck() = true then begin
            ItemJnlLine.I9G_CaseNumber := SalesHeader.I9G_CaseNumber;
            ItemJnlLine.I9G_ShipToDistrictCode := SalesHeader.I9G_ShipToDistrictCode;
            ItemJnlLine.I9G_ShipToPostCode := SalesHeader."Ship-to Post Code";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertItemLedgEntry, '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
    begin
        if GetCompanyCheck() = true then begin
            ItemLedgerEntry.I9G_CaseNumber := ItemJournalLine.I9G_CaseNumber;
            ItemLedgerEntry.I9G_CaseDR := ItemJournalLine.I9G_CaseDR;
            ItemLedgerEntry.I9G_ShipToDistrictCode := ItemJournalLine.I9G_ShipToDistrictCode;
            ItemLedgerEntry.I9G_ShipToPostCode := ItemJournalLine.I9G_ShipToPostCode;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnAfterCreateItemJnlLine, '', false, false)]
    local procedure OnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        if GetCompanyCheck() = true then begin
            ItemJournalLine.I9G_CaseNumber := TransferShipmentHeader.I9G_CaseNumber;
            ItemJournalLine.I9G_CaseDR := TransferShipmentHeader.I9G_CaseDR;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforePostItemJournalLine, '', false, false)]
    local procedure OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header")
    begin
        if GetCompanyCheck() = true then begin
            ItemJournalLine.I9G_CaseNumber := TransferReceiptHeader.I9G_CaseNumber;
            ItemJournalLine.I9G_CaseDR := TransferReceiptHeader.I9G_CaseDR;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", OnOnRunOnBeforeTestFieldNo, '', false, false)]
    local procedure OnOnRunOnBeforeTestFieldNo(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        if GetCompanyCheck() = true then begin
            SalesInvoiceHeader.I9G_Remarks := SalesInvoiceHeaderRec.I9G_Remarks;
            SalesInvoiceHeader.I9G_InternalRemarks := SalesInvoiceHeaderRec.I9G_InternalRemarks;
            SalesInvoiceHeader.I9G_DRIC := SalesInvoiceHeaderRec.I9G_DRIC;
            SalesInvoiceHeader.I9G_CaseNumber := SalesInvoiceHeaderRec.I9G_CaseNumber;
            SalesInvoiceHeader."Shipment Date" := SalesInvoiceHeaderRec."Shipment Date";
            SalesInvoiceHeader.I9G_DateUsed := SalesInvoiceHeaderRec.I9G_DateUsed;
            SalesInvoiceHeader.I9G_CaseDoctor := SalesInvoiceHeaderRec.I9G_CaseDoctor;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", OnAfterRecordChanged, '', false, false)]
    local procedure PostedSalesInvUpdate_OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        if IsChanged = false then begin
            if GetCompanyCheck() = true then begin
                IsChanged := (SalesInvoiceHeader.I9G_Remarks <> xSalesInvoiceHeader.I9G_Remarks) or
                    (SalesInvoiceHeader.I9G_InternalRemarks <> xSalesInvoiceHeader.I9G_InternalRemarks) or
                    (SalesInvoiceHeader.I9G_DRIC <> xSalesInvoiceHeader.I9G_DRIC) or
                    (SalesInvoiceHeader.I9G_CaseNumber <> xSalesInvoiceHeader.I9G_CaseNumber) or
                    (SalesInvoiceHeader."Shipment Date" <> xSalesInvoiceHeader."Shipment Date") or
                    (SalesInvoiceHeader.I9G_DateUsed <> xSalesInvoiceHeader.I9G_DateUsed) or
                    (SalesInvoiceHeader.I9G_CaseDoctor <> xSalesInvoiceHeader.I9G_CaseDoctor);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", OnBeforePurchInvHeaderModify, '', false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    begin
        if GetCompanyCheck() = true then begin
            PurchInvHeader.I9G_Remarks := PurchInvHeaderRec.I9G_Remarks;
            PurchInvHeader.I9G_InternalRemarks := PurchInvHeaderRec.I9G_InternalRemarks;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", OnAfterRecordChanged, '', false, false)]
    local procedure PostedPurchInvoiceUpdate_OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
        if IsChanged = false then begin
            if GetCompanyCheck() = true then begin
                IsChanged := (PurchInvHeader.I9G_Remarks <> xPurchInvHeaderGlobal.I9G_Remarks) or
                    (PurchInvHeader.I9G_InternalRemarks <> xPurchInvHeaderGlobal.I9G_InternalRemarks);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnAfterPrepareInvoicePostingBuffer, '', false, false)]
    local procedure SalesPostInvoice_OnAfterPrepareInvoicePostingBuffer(var SalesLine: Record "Sales Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        if GetCompanyCheck() = true then begin
            InvoicePostingBuffer.I9G_GSTBaseAmount := SalesLine.I9G_GSTBaseAmount;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", OnAfterPrepareInvoicePostingBuffer, '', false, false)]
    local procedure PurchPostInvoice_OnAfterPrepareInvoicePostingBuffer(var PurchaseLine: Record "Purchase Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        if GetCompanyCheck() = true then begin
            InvoicePostingBuffer.I9G_GSTBaseAmount := PurchaseLine.I9G_GSTBaseAmount;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", OnAfterCopyToGenJnlLine, '', false, false)]
    local procedure InvoicePostingBuffer_OnAfterCopyToGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer");
    begin
        if GetCompanyCheck() = true then begin
            GenJnlLine.I9G_GSTBaseAmount := InvoicePostingBuffer.I9G_GSTBaseAmount;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeInsertVATEntry, '', false, false)]
    local procedure OnBeforeInsertVATEntry(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line"; var NextVATEntryNo: Integer; var TempGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link" temporary; var TempGLEntryBuf: Record "G/L Entry" temporary; GLRegister: Record "G/L Register")
    begin
        if GetCompanyCheck() = true then begin
            if VATEntry.Amount < 0 then
                VATEntry.I9G_GSTBaseAmount := GenJournalLine.I9G_GSTBaseAmount * -1
            else
                VATEntry.I9G_GSTBaseAmount := GenJournalLine.I9G_GSTBaseAmount;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnCopySalesDocOnAfterCopySalesDocLines, '', false, false)]
    local procedure OnCopySalesDocOnAfterCopySalesDocLines(FromDocType: Option; FromDocNo: Code[20]; FromDocOccurrenceNo: Integer; FromDocVersionNo: Integer; FromSalesHeader: Record "Sales Header"; IncludeHeader: Boolean; var ToSalesHeader: Record "Sales Header"; var HideDialog: Boolean)
    begin
        if GetCompanyCheck() = true then begin
            ToSalesHeader.I9G_ShipToAddress3 := FromSalesHeader.I9G_ShipToAddress3;
            ToSalesHeader.I9G_ShipToDistrictCode := FromSalesHeader.I9G_ShipToDistrictCode;
            ToSalesHeader.I9G_DRIC := FromSalesHeader.I9G_DRIC;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Pstd. Sales Cr. Memo - Update", OnAfterRecordChanged, '', false, false)]
    local procedure "Pstd. Sales Cr. Memo - Update_OnAfterRecordChanged"(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; xSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsChanged: Boolean)
    begin
        if IsChanged = false then begin
            if GetCompanyCheck() = true then begin
                IsChanged := (SalesCrMemoHeader.I9G_ShipToAddress3 <> xSalesCrMemoHeader.I9G_ShipToAddress3) or
                    (SalesCrMemoHeader.I9G_ShipToDistrictCode <> xSalesCrMemoHeader.I9G_ShipToDistrictCode) or
                    (SalesCrMemoHeader."External Document No." <> xSalesCrMemoHeader."External Document No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Credit Memo Hdr. - Edit", OnBeforeSalesCrMemoHeaderModify, '', false, false)]
    local procedure "Sales Credit Memo Hdr. - Edit_OnBeforeSalesCrMemoHeaderModify"(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        if GetCompanyCheck() = true then begin
            SalesCrMemoHeader.I9G_ShipToAddress3 := FromSalesCrMemoHeader.I9G_ShipToAddress3;
            SalesCrMemoHeader.I9G_ShipToDistrictCode := FromSalesCrMemoHeader.I9G_ShipToDistrictCode;
            SalesCrMemoHeader."External Document No." := FromSalesCrMemoHeader."External Document No.";
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Shipment - Update", OnAfterRecordChanged, '', false, false)]
    local procedure "Posted Sales Shipment - Update_OnAfterRecordChanged"(var SalesShipmentHeader: Record "Sales Shipment Header"; xSalesShipmentHeader: Record "Sales Shipment Header"; var IsChanged: Boolean)
    begin
        if IsChanged = false then begin
            if GetCompanyCheck() = true then begin
                IsChanged := (SalesShipmentHeader.I9G_CaseDoctor <> xSalesShipmentHeader.I9G_CaseDoctor) or
                    (SalesShipmentHeader.I9G_DRIC <> xSalesShipmentHeader.I9G_DRIC) or
                    (SalesShipmentHeader.I9G_CaseNumber <> xSalesShipmentHeader.I9G_CaseNumber) or
                    (SalesShipmentHeader.I9G_Remarks <> xSalesShipmentHeader.I9G_Remarks) or
                    (SalesShipmentHeader.I9G_ReferenceInvoiceNo <> xSalesShipmentHeader.I9G_ReferenceInvoiceNo) or
                    (SalesShipmentHeader.I9G_InternalRemarks <> xSalesShipmentHeader.I9G_InternalRemarks) or
                    (SalesShipmentHeader."Shipment Date" <> xSalesShipmentHeader."Shipment Date") or
                    (SalesShipmentHeader.I9G_DateUsed <> xSalesShipmentHeader.I9G_DateUsed) or
                    (SalesShipmentHeader."External Document No." <> xSalesShipmentHeader."External Document No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", OnBeforeSalesShptHeaderModify, '', false, false)]
    local procedure "Shipment Header - Edit_OnBeforeSalesShptHeaderModify"(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
        if GetCompanyCheck() = true then begin
            SalesShptHeader.I9G_CaseDoctor := FromSalesShptHeader.I9G_CaseDoctor;
            SalesShptHeader.I9G_DRIC := FromSalesShptHeader.I9G_DRIC;
            SalesShptHeader.I9G_CaseNumber := FromSalesShptHeader.I9G_CaseNumber;
            SalesShptHeader.I9G_Remarks := FromSalesShptHeader.I9G_Remarks;
            SalesShptHeader.I9G_ReferenceInvoiceNo := FromSalesShptHeader.I9G_ReferenceInvoiceNo;
            SalesShptHeader.I9G_InternalRemarks := FromSalesShptHeader.I9G_InternalRemarks;
            SalesShptHeader."Shipment Date" := FromSalesShptHeader."Shipment Date";
            SalesShptHeader.I9G_DateUsed := FromSalesShptHeader.I9G_DateUsed;
            SalesShptHeader."External Document No." := FromSalesShptHeader."External Document No.";
        end;
    end;

    procedure FormatSelltoAddressNovem(var AddrArray: array[6] of Text[250]; CustName: Text[100]; Name: Text[100]; Name2: Text[100]; Address: Text[100]; Address2: Text[100]; Address3: Text[250])
    var
        LineNo: Integer;
    begin
        Clear(AddrArray);
        LineNo := 1;

        if CustName <> '' then begin
            AddrArray[LineNo] := CustName;
            LineNo := LineNo + 1;
        end;

        if Name <> '' then begin
            AddrArray[LineNo] := Name;
            LineNo := LineNo + 1;
        end;

        if Name2 <> '' then begin
            AddrArray[LineNo] := Name2;
            LineNo := LineNo + 1;
        end;

        if Address <> '' then begin
            AddrArray[LineNo] := Address;
            LineNo := LineNo + 1;
        end;

        if Address2 <> '' then begin
            AddrArray[LineNo] := Address2;
            LineNo := LineNo + 1;
        end;

        if Address3 <> '' then begin
            AddrArray[LineNo] := Address3;
            LineNo := LineNo + 1;
        end;
    end;

    procedure FormatShiptoAddressNovem(var AddrArray: array[7] of Text[250]; CustName: Text[100]; Name: Text[100]; Name2: Text[100]; Address: Text[100]; Address2: Text[100]; Address3: Text[250]; Tel: Text[100])
    var
        LineNo: Integer;
    begin
        Clear(AddrArray);
        LineNo := 1;

        if CustName <> '' then begin
            AddrArray[LineNo] := CustName;
            LineNo := LineNo + 1;
        end;

        if Name <> '' then begin
            AddrArray[LineNo] := Name;
            LineNo := LineNo + 1;
        end;

        if Name2 <> '' then begin
            AddrArray[LineNo] := Name2;
            LineNo := LineNo + 1;
        end;

        if Address <> '' then begin
            AddrArray[LineNo] := Address;
            LineNo := LineNo + 1;
        end;

        if Address2 <> '' then begin
            AddrArray[LineNo] := Address2;
            LineNo := LineNo + 1;
        end;

        if Address3 <> '' then begin
            AddrArray[LineNo] := Address3;
            LineNo := LineNo + 1;
        end;

        if Tel <> '' then begin
            AddrArray[LineNo] := 'Tel : ' + Tel;
            LineNo := LineNo + 1;
        end;
    end;
}