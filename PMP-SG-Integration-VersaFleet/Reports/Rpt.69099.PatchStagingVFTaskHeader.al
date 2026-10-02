report 69099 "Patch Staging VF Task Header"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Staging VF Task Header"; "Staging VF Task Header")
        {
            RequestFilterFields = "Sales Invoice No.", "Posting Date";
            trigger OnPreDataItem()
            begin
                SetFilter("Sales Invoice No.", '<> %1', '');
                SetRange("Customer No.", '');
            end;

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                EntryNo: Integer;
                SalesInvoiceHeader: Record "Sales Invoice Header";
                DeliveryMiscCharges: Record "Delivery Misc Charges";
                TBALedgerEntry: Record "TBA Ledger Entry";
                TBALedgerEntryArchive: Record "TBA Ledger Entry Archive";
                SalesHeader: Record "Sales Header";
                ReturnReceiptHeader: Record "Return Receipt Header";
            begin
                if "Source Document Type" = "Source Document Type"::"Posted Sales Invoice" then begin
                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetRange("No.", "Sales Invoice No.");
                    if SalesInvoiceHeader.FindFirst() then begin
                        "Customer Group" := SalesInvoiceHeader."Customer Group";
                        "Customer No." := SalesInvoiceHeader."Sell-to Customer No.";
                        Modify();
                    end;
                end else if "Source Document Type" = "Source Document Type"::"Misc. Delivery Charge" then begin
                    Evaluate(EntryNo, Copystr("Sales Invoice No.", 9));

                    DeliveryMiscCharges.Reset();
                    DeliveryMiscCharges.SetRange("Entry No.", EntryNo);
                    if DeliveryMiscCharges.FindFirst() then begin
                        Customer.Reset();
                        if Customer.Get(DeliveryMiscCharges."Customer No.") then begin
                            "Customer Group" := Customer."Customer Group";
                            "Customer No." := Customer."No.";
                            Modify();
                        end;
                    end;
                end else if "Source Document Type" = "Source Document Type"::"TBA Ledger" then begin
                    TBALedgerEntry.Reset();
                    TBALedgerEntry.SetRange("Document No.", "Sales Invoice No.");
                    if TBALedgerEntry.FindFirst() then begin
                        Customer.Reset();
                        if Customer.Get(TBALedgerEntry."Customer No.") then begin
                            "Customer Group" := Customer."Customer Group";
                            "Customer No." := Customer."No.";
                            Modify();
                        end;
                    end else begin
                        TBALedgerEntryArchive.Reset();
                        TBALedgerEntryArchive.SetRange("Document No.", "Sales Invoice No.");
                        if TBALedgerEntryArchive.FindFirst() then begin
                            Customer.Reset();
                            if Customer.Get(TBALedgerEntryArchive."Customer No.") then begin
                                "Customer Group" := Customer."Customer Group";
                                "Customer No." := Customer."No.";
                                Modify();
                            end;
                        end;
                    end;
                end else if "Source Document Type" = "Source Document Type"::"Sales Return Order" then begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Return Order");
                    SalesHeader.SetRange("No.", "Sales Invoice No.");
                    if SalesHeader.FindFirst() then begin
                        "Customer Group" := SalesHeader."Customer Group";
                        "Customer No." := SalesHeader."Sell-to Customer No.";
                        Modify();
                    end else begin
                        ReturnReceiptHeader.Reset();
                        ReturnReceiptHeader.SetRange("Return Order No.", "Sales Invoice No.");
                        if ReturnReceiptHeader.FindFirst() then begin
                            "Customer Group" := ReturnReceiptHeader."Customer Group";
                            "Customer No." := ReturnReceiptHeader."Sell-to Customer No.";
                            Modify();
                        end;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Patch Completed.');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
            }
        }
    }
}