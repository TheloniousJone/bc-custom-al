codeunit 57000 "PMP-ReportCU"
{

    [EventSubscriber(ObjectType::Report, Report::"Whse. Calculate Inventory", 'OnAfterWhseJnlLineInsert', '', false, false)]
    local procedure OnBeforeWhseJnlLineInsert(var WarehouseJournalLine: Record "Warehouse Journal Line"; var NextLineNo: Integer; var BinContent: Record "Bin Content");
    var

    begin
        // WarehouseJournalLine."Qty. (Phys. Inventory)" := 0;
        WarehouseJournalLine.Validate("Qty. (Phys. Inventory)", 0);
        WarehouseJournalLine.Modify();
    end;

    // YF 23 Aug 2022
    /*  
        =====================================
        Usage Example
        =====================================
        Clear(TestRecRef);
        SalesHdrRec.Reset;
        if SalesHdrRec.FindFirst() then begin
            TestRecRef.GetTable(SalesHdrRec);
            Message(Format(CUTest.GetVATPercentFromDocument(TestRecRef)));
        end;
        Clear(TestRecRef);
        TestRecRef.Close();
    */
    procedure GetVATPercentFromDocument(var SourceRecRef: RecordRef) VATPercent: Decimal;
    var
        RetVATPercent: Decimal;
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ServiceLine: Record "Service Line";
        ServiceInvLine: Record "Service Invoice Line";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
    begin
        // Message(Format(SourceRecRef.RecordId));
        case SourceRecRef.Number of
            81:
                begin
                    // Gen. Journal Line // "Journal Template Name", "Journal Batch Name", "Line No."
                    /*
                    Message(Format(SourceRecRef.Field(1))); // Journal Template Name
                    Message(Format(SourceRecRef.Field(2))); // Line No
                    Message(Format(SourceRecRef.Field(51))); // Journal Batch Name
                    Message(Format(SourceRecRef.Field(10))); // VAT %
                    */
                    RetVATPercent := SourceRecRef.Field(10).Value;
                end;
            38:
                begin
                    // Purchase Header // Document Type, No.
                    PurchLine.Reset;
                    PurchLine.SetLoadFields("Document Type", "Document No.", "VAT %", "Line Amount");
                    PurchLine.SetRange("Document Type", SourceRecRef.Field(1).Value);
                    PurchLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    PurchLine.SetFilter("VAT %", '<>%1', 0);
                    PurchLine.SetFilter("Line Amount", '<>%1', 0);
                    if PurchLine.FindFirst() then begin
                        RetVATPercent := PurchLine."VAT %";
                    end;
                end;
            36:
                begin
                    // Sales Header / /Document Type, No.
                    SalesLine.Reset;
                    SalesLine.SetLoadFields("Document Type", "Document No.", "VAT %", "Line Amount");
                    SalesLine.SetRange("Document Type", SourceRecRef.Field(1).Value);
                    SalesLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    SalesLine.SetFilter("VAT %", '<>%1', 0);
                    SalesLine.SetFilter("Line Amount", '<>%1', 0);
                    if SalesLine.FindFirst() then begin
                        RetVATPercent := SalesLine."VAT %";
                    end;
                end;
            122:
                begin
                    // Posted Purchase Invoice Header
                    PurchInvLine.Reset;
                    PurchInvLine.SetLoadFields("Document No.", "VAT %", "Line Amount");
                    PurchInvLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    PurchInvLine.SetFilter("VAT %", '<>%1', 0);
                    PurchInvLine.SetFilter("Line Amount", '<>%1', 0);
                    if PurchInvLine.FindFirst() then begin
                        RetVATPercent := PurchInvLine."VAT %";
                    end;
                end;
            124:
                begin
                    // Posted Purchase Credit Memo Header
                    PurchCrMemoLine.Reset;
                    PurchCrMemoLine.SetLoadFields("Document No.", "VAT %", "Line Amount");
                    PurchCrMemoLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    PurchCrMemoLine.SetFilter("VAT %", '<>%1', 0);
                    PurchCrMemoLine.SetFilter("Line Amount", '<>%1', 0);
                    if PurchCrMemoLine.FindFirst() then begin
                        RetVATPercent := PurchCrMemoLine."VAT %";
                    end;
                end;
            112:
                begin
                    // Posted Sales Invoice Header
                    SalesInvLine.Reset;
                    SalesInvLine.SetLoadFields("Document No.", "VAT %", "Line Amount");
                    SalesInvLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    SalesInvLine.SetFilter("VAT %", '<>%1', 0);
                    SalesInvLine.SetFilter("Line Amount", '<>%1', 0);
                    if SalesInvLine.FindFirst() then begin
                        RetVATPercent := SalesInvLine."VAT %";
                    end;
                end;
            114:
                begin
                    // Posted Sales Credit Memo Header
                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetLoadFields("Document No.", "VAT %", "Line Amount");
                    SalesCrMemoLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    SalesCrMemoLine.SetFilter("VAT %", '<>%1', 0);
                    SalesCrMemoLine.SetFilter("Line Amount", '<>%1', 0);
                    if SalesCrMemoLine.FindFirst() then begin
                        RetVATPercent := SalesCrMemoLine."VAT %";
                    end;
                end;
            5900:
                begin
                    // Service Header
                    ServiceLine.Reset;
                    ServiceLine.SetLoadFields("Document No.", "VAT %", "Line Amount");
                    ServiceLine.SetRange("Document Type", SourceRecRef.Field(1).Value);
                    ServiceLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    ServiceLine.SetFilter("VAT %", '<>%1', 0);
                    ServiceLine.SetFilter("Line Amount", '<>%1', 0);
                    if ServiceLine.FindFirst() then begin
                        RetVATPercent := ServiceLine."VAT %";
                    end;
                end;
            5992:
                begin
                    // Posted Service Invoice Header
                    ServiceInvLine.Reset;
                    ServiceInvLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    ServiceInvLine.SetFilter("VAT %", '<>%1', 0);
                    ServiceInvLine.SetFilter("Line Amount", '<>%1', 0);
                    if ServiceInvLine.FindFirst() then begin
                        RetVATPercent := ServiceInvLine."VAT %";
                    end;
                end;
            5994:
                begin
                    // Posted Service Credit Memo Header
                    ServiceCrMemoLine.Reset;
                    ServiceCrMemoLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    ServiceCrMemoLine.SetFilter("VAT %", '<>%1', 0);
                    ServiceCrMemoLine.SetFilter("Line Amount", '<>%1', 0);
                    if ServiceCrMemoLine.FindFirst() then begin
                        RetVATPercent := ServiceCrMemoLine."VAT %";
                    end;
                end;
            else
                RetVATPercent := 0;
        end;

        VATPercent := RetVATPercent;
    end;
    // YF 23 Aug 2022

    // KP 25 Feb 2025 - Auto Invoice Email
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        LocCode: Record Location;
    begin
        if SalesInvHdrNo <> '' then begin
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetLoadFields("No.", "Location Code", "Bill-to Customer No.");
            SalesInvoiceHeader.SetRange("No.", SalesInvHdrNo);
            if SalesInvoiceHeader.FindFirst() then begin
                LocCode.reset;
                LocCode.SetLoadFields(Code, "Require Shipment", "Require Pick");
                LocCode.SetRange(Code, SalesInvoiceHeader."Location Code");
                if LocCode.FindFirst() then begin
                    if (LocCode."Require Shipment" = true) and (LocCode."Require Pick" = true) then begin
                        Customer.Reset();
                        if Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then begin
                            // Check if Auto Email Invoice is true and if Email Address is provided
                            if Customer.I9G_AutoEmailInvoice = true then begin
                                if Customer.I9G_AutoEmailInvEmailAddress <> '' then begin
                                    // Call the email sending procedure
                                    SendPostedSalesInvoiceEmail(SalesInvoiceHeader, Customer.I9G_AutoEmailInvEmailAddress);
                                end;
                            end;
                        end;
                    end;
                end;

            end;
        end;
    end;

    //KP 25 Feb 2025 - Auto Invoice Email
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterSalesPost', '', false, false)]
    // local procedure OnAfterSalesPost(SalesHeader: Record "Sales Header"; Invoice: Boolean; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    // var
    //     Customer: Record Customer;
    //     SalesInvoiceHeader: Record "Sales Invoice Header";
    // begin
    //     //if Invoice = true then begin
    //     SalesInvoiceHeader.Reset();
    //     SalesInvoiceHeader.SetCurrentKey("Order No.");
    //     SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
    //     if SalesInvoiceHeader.FindLast() then begin
    //         Customer.Reset();
    //         Customer.SetLoadFields(I9G_AutoEmailInvoice, I9G_AutoEmailInvEmailAddress);
    //         if Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then begin
    //             // Check if Auto Email Invoice is true and if Email Address is provided
    //             if Customer.I9G_AutoEmailInvoice = true then begin
    //                 if Customer.I9G_AutoEmailInvEmailAddress <> '' then begin
    //                     // Call the email sending procedure
    //                     SendPostedSalesInvoiceEmail(SalesInvoiceHeader, Customer.I9G_AutoEmailInvEmailAddress);
    //                 end;
    //             end;
    //         end;
    //     end;
    //end;
    // if SalesInvHdrNo <> '' then begin
    //     SalesInvoiceHeader.Reset();
    //     SalesInvoiceHeader.SetRange("No.", SalesInvHdrNo);
    //     if SalesInvoiceHeader.FindFirst() then begin
    //         Customer.Reset();
    //         if Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then begin
    //             // Check if Auto Email Invoice is true and if Email Address is provided
    //             if Customer.I9G_AutoEmailInvoice = true then begin
    //                 if Customer.I9G_AutoEmailInvEmailAddress <> '' then begin
    //                     // Call the email sending procedure
    //                     SendPostedSalesInvoiceEmail(SalesInvoiceHeader, Customer.I9G_AutoEmailInvEmailAddress);
    //                 end;
    //             end;
    //         end;
    //     end;
    // end;
    // end;

    local procedure SendPostedSalesInvoiceEmail(var SalesInvoiceHeader: Record "Sales Invoice Header"; EmailAddress: Text[1000])
    var
        OStream: OutStream;
        IStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        CnvB64: Codeunit "Base64 Convert";
        EmailMsg: Codeunit "Email Message";
        Email: Codeunit Email;
        RecRef: RecordRef;
        TxtB64: Text;
        EmailSubject: Text;
        EmailBody: Text;
        EmailAddressList: List of [Text];
        SalesSetup: Record "Sales & Receivables Setup";
        ReportSelection: Record "Report Selections";
        CompanyInfo: Record "Company Information";
    begin
        ReportSelection.Reset();
        ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Invoice");
        if ReportSelection.FindFirst() then begin
            TempBlob.CreateOutStream(OStream);

            if EmailAddress = '' then
                exit;

            EmailAddressList := EmailAddress.Split(';');

            RecRef.GetTable(SalesInvoiceHeader);

            if Report.SaveAs(ReportSelection."Report ID", '', ReportFormat::Pdf, OStream, RecRef) then begin
                TempBlob.CreateInStream(IStream);
                TxtB64 := CnvB64.ToBase64(IStream, true);

                if (TxtB64 <> '') then begin
                    CompanyInfo.reset;
                    CompanyInfo.SetLoadFields(Name);
                    CompanyInfo.get;
                    EmailSubject := UpperCase(CompanyInfo.Name) + ' - Sales Invoice - ' + SalesInvoiceHeader."No.";


                    SalesSetup.Get();
                    EmailBody := SalesSetup.I9G_AutoEmailInvBody;
                    EmailBody := EmailBody.Replace('//', '<br />');

                    EmailMsg.Create(EmailAddress, EmailSubject, EmailBody, true);
                    EmailMsg.AddAttachment('Posted Sales Invoice - ' + SalesInvoiceHeader."No." + '.pdf', 'application/pdf', TxtB64);
                    Email.Send(EmailMsg);
                end;
            end;
        end;
    end;
    //KP 25 Feb 2025 - Auto Invoice Email

}
