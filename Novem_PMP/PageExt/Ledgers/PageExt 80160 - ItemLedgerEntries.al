pageextension 80160 ItemLedgerEntriesPageExt3PL extends "Item Ledger Entries"
{
    layout
    {
        addafter(SourceNo)
        {
            field(I9G3PL_SourceName; I9G_SourceName)
            {
                Caption = 'Source Name';
                ApplicationArea = All;
                Editable = false;
                Visible = true;
            }
        }
    }
    var
        I9G_SourceName: Text[100];

    trigger OnAfterGetRecord()
    var
        CustomerRec: Record Customer;
        VendorRec: Record Vendor;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        PurchaRcptHeaderRec: Record "Purch. Rcpt. Header";
        SalesShipmentHeaderRec: Record "Sales Shipment Header";
        ReturnReceiptHeaderRec: Record "Return Receipt Header";
    begin
        I9G_SourceName := '';
        if Rec."Source Type" = Rec."Source Type"::Customer then begin
            CustomerRec.Reset();
            CustomerRec.SetLoadFields("No.", Name);
            CustomerRec.SetRange("No.", Rec."Source No.");
            if CustomerRec.FindFirst() then begin
                I9G_SourceName := CustomerRec.Name;
            end;

            if Rec."Document Type" = Rec."Document Type"::"Sales Shipment" then begin
                SalesShipmentHeaderRec.Reset();
                SalesShipmentHeaderRec.SetLoadFields("No.", I9G_CustVendName, I9G_SONo);
                SalesShipmentHeaderRec.SetRange("No.", Rec."Document No.");
                if SalesShipmentHeaderRec.FindFirst() then begin
                    if SalesShipmentHeaderRec.I9G_SONo <> '' then begin
                        I9G_SourceName := SalesShipmentHeaderRec.I9G_CustVendName;
                    end else begin
                        CustomerRec.Reset();
                        CustomerRec.SetLoadFields("No.", Name);
                        CustomerRec.SetRange("No.", Rec."Source No.");
                        if CustomerRec.FindFirst() then begin
                            I9G_SourceName := CustomerRec.Name;
                        end;
                    end;
                end;
            end;

            if Rec."Document Type" = Rec."Document Type"::"Sales Return Receipt" then begin
                ReturnReceiptHeaderRec.Reset();
                ReturnReceiptHeaderRec.SetLoadFields("No.", I9G_CustVendName, I9G_SONo);
                ReturnReceiptHeaderRec.SetRange("No.", Rec."Document No.");
                if ReturnReceiptHeaderRec.FindFirst() then begin
                    if ReturnReceiptHeaderRec.I9G_SONo <> '' then begin
                        I9G_SourceName := ReturnReceiptHeaderRec.I9G_CustVendName;
                    end else begin
                        CustomerRec.Reset();
                        CustomerRec.SetLoadFields("No.", Name);
                        CustomerRec.SetRange("No.", Rec."Source No.");
                        if CustomerRec.FindFirst() then begin
                            I9G_SourceName := CustomerRec.Name;
                        end;
                    end;
                end;
            end;
        end;
        if Rec."Source Type" = Rec."Source Type"::Vendor then begin
            VendorRec.Reset();
            VendorRec.SetLoadFields("No.", Name);
            VendorRec.SetRange("No.", Rec."Source No.");
            if VendorRec.FindFirst() then begin
                I9G_SourceName := VendorRec.Name;
            end;

            if Rec."Document Type" = Rec."Document Type"::"Purchase Receipt" then begin
                PurchaRcptHeaderRec.Reset();
                PurchaRcptHeaderRec.SetLoadFields("No.", I9G_CustVendName, I9G_PONo);
                PurchaRcptHeaderRec.SetRange("No.", Rec."Document No.");
                if PurchaRcptHeaderRec.FindFirst() then begin
                    if PurchaRcptHeaderRec.I9G_PONo <> '' then begin
                        I9G_SourceName := PurchaRcptHeaderRec.I9G_CustVendName;
                    end else begin
                        VendorRec.Reset();
                        VendorRec.SetLoadFields("No.", Name);
                        VendorRec.SetRange("No.", Rec."Source No.");
                        if VendorRec.FindFirst() then begin
                            I9G_SourceName := VendorRec.Name;
                        end;
                    end;
                end;
            end;
        end;
    end;
}