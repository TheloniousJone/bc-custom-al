pageextension 56101 PurchaseOrderCard extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(Release)
        {
            trigger OnAfterAction()
            var
                IntegrationCU: Codeunit "Zuellig Integrations";
                ZPVendorCode: Text;
                ZPSetupRec: Record "Zuellig Integration Setup";
            begin
                if IntegrationCU.IsZuelligVendor(Rec."Buy-from Vendor No.") then begin
                    if Confirm('Send to Outgoing PO EDI Staging Tables?', false) then begin
                        CurrPage.SETSELECTIONFILTER(POHeader);

                        // Basic Error Checking
                        if POHeader.Count <= 0 then
                            Error('Nothing to generate');

                        // 1 PO 1 File Implementation for ZP
                        if ZPSetupRec.Get() then
                            ZPVendorCode := ZPSetupRec."BC Vendor Code";

                        POHeader.SetRange("Buy-from Vendor No.", ZPVendorCode);
                        POHeader.SetRange(Status, POHeader.Status::Released);
                        if POHeader.FindSet() then
                            repeat
                                Clear(IntegrationCU);

                                // Check Expiry Dates
                                if IntegrationCU.HasItemExpiryDateBelowOneYear(POHeader."No.", false) then
                                    Message('There are items expiring in less than 1 year for PO - ' + POHeader."No.");

                                // insert to staging    
                                IntegrationCU.InsertOrUpdateOutgoingPOEDIRecords(POHeader."No.", false);
                            until POHeader.Next() = 0;
                    end;
                end;
            end;
        }

        addafter("P&osting")
        {
            group(Integration)
            {
                action("Export PO EDI")
                {
                    ApplicationArea = all;
                    Caption = 'Export PO EDI';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                        ZPVendorCode: Text;
                        ZPSetupRec: Record "Zuellig Integration Setup";
                    begin
                        if IntegrationCU.IsZuelligVendor(Rec."Buy-from Vendor No.") then begin
                            if Confirm('Send to Outgoing PO EDI Staging Tables?', false) then begin
                                CurrPage.SETSELECTIONFILTER(POHeader);

                                // Basic Error Checking
                                if POHeader.Count <= 0 then
                                    Error('Nothing to generate');

                                // 1 PO 1 File Implementation for ZP
                                if ZPSetupRec.Get() then
                                    ZPVendorCode := ZPSetupRec."BC Vendor Code";

                                POHeader.SetRange("Buy-from Vendor No.", ZPVendorCode);
                                POHeader.SetRange(Status, POHeader.Status::Released);
                                if POHeader.FindSet() then
                                    repeat
                                        Clear(IntegrationCU);

                                        // Check Expiry Dates
                                        if IntegrationCU.HasItemExpiryDateBelowOneYear(POHeader."No.", false) then
                                            Message('There are items expiring in less than 1 year for PO - ' + POHeader."No.");

                                        // insert to staging    
                                        IntegrationCU.InsertOrUpdateOutgoingPOEDIRecords(POHeader."No.", false);
                                    until POHeader.Next() = 0;
                            end;
                        end;
                    end;
                }

                action("Undo PO EDI Export")
                {
                    ApplicationArea = all;
                    Caption = 'Undo PO EDI Export';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                        ZPVendorCode: Text;
                        ZPSetupRec: Record "Zuellig Integration Setup";
                    begin
                        if IntegrationCU.IsZuelligVendor(Rec."Buy-from Vendor No.") then begin
                            if Confirm('Send Undo Request to Outgoing PO EDI Staging Tables?', false) then begin
                                CurrPage.SETSELECTIONFILTER(POHeader);

                                // Basic Error Checking
                                if POHeader.Count <= 0 then
                                    Error('Nothing to generate');

                                // 1 PO 1 File Implementation for ZP
                                if ZPSetupRec.Get() then
                                    ZPVendorCode := ZPSetupRec."BC Vendor Code";

                                POHeader.SetRange("Buy-from Vendor No.", ZPVendorCode);
                                if POHeader.FindSet() then
                                    repeat
                                        Clear(IntegrationCU);
                                        IntegrationCU.DeleteOutgoingPOEDIRecords(POHeader."No.", false);
                                    until POHeader.Next() = 0;
                            end;
                        end;
                    end;
                }

                action("Manual Export PO EDI")
                {
                    ApplicationArea = all;
                    Caption = 'Manual Export PO EDI';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "Zuellig Integrations";
                        ZPVendorCode: Text;
                        ZPSetupRec: Record "Zuellig Integration Setup";
                    begin

                        if Confirm('Manual Generate PO EDI?', false) then begin
                            CurrPage.SETSELECTIONFILTER(POHeader);

                            // Basic Error Checking
                            if POHeader.Count <= 0 then
                                Error('Nothing to generate');

                            // 1 PO 1 File Implementation for ZP
                            if ZPSetupRec.Get() then
                                ZPVendorCode := ZPSetupRec."BC Vendor Code";

                            POHeader.SetRange("Buy-from Vendor No.", ZPVendorCode);
                            POHeader.SetRange(Status, POHeader.Status::Released);
                            if POHeader.FindSet() then
                                repeat
                                    Clear(IntegrationCU);

                                    // Check Expiry Dates
                                    if IntegrationCU.HasItemExpiryDateBelowOneYear(POHeader."No.", false) then
                                        Message('There are items expiring in less than 1 year for PO - ' + POHeader."No.");

                                    // genreate CSV   
                                    IntegrationCU.GeneratePOEDI_PONum_API(POHeader."No.", false);
                                until POHeader.Next() = 0;
                        end;
                    end;
                }

            }
        }
    }

    var
        POHeader: Record "Purchase Header";
}