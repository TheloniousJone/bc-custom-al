pageextension 52100 ExtendPurchaseOrderList extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("P&osting")
        {
            group(Integration)
            {
                action("Export PO to DKSH Staging")
                {
                    ApplicationArea = all;
                    Caption = 'Export PO to DKSH Staging';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "DKSH Integrations";
                        DKSHSetupRec: Record "DKSH Integration Setup";
                        DKSHVendorCode: Text;
                    begin
                        if IntegrationCU.IsDKSHVendor(Rec."Buy-from Vendor No.") then begin
                            if Confirm('Send to Outgoing DKSH PO Staging Tables?', false) then begin
                                if DKSHSetupRec.Get() then
                                    DKSHVendorCode := DKSHSetupRec."BC Vendor Code";

                                CurrPage.SetSelectionFilter(POHeader);
                                POHeader.SetRange("Buy-from Vendor No.", DKSHVendorCode);
                                POHeader.SetRange(Status, POHeader.Status::Released);

                                if POHeader.Count <= 0 then
                                    Error('Nothing to generate');

                                if POHeader.FindSet() then
                                        repeat
                                            // Check Expiry Dates
                                            if IntegrationCU.HasItemExpiryDateBelowOneYear(POHeader."No.", false) then
                                                Message('There are items expiring in less than 1 year for PO - ' + POHeader."No.");

                                            // insert to staging    
                                            IntegrationCU.InsertOrUpdateOutgoingPOStagingRecords(POHeader."No.", false);

                                        // add wait state to generate unique file name based on timestamp
                                        // Sleep(1000); // not required if pushing to staging tables
                                        until POHeader.Next() = 0;
                            end;
                        end;
                    end;
                }

                action("Undo PO to DKSH Staging Export")
                {
                    ApplicationArea = all;
                    Caption = 'Undo PO to DKSH Staging Export';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "DKSH Integrations";
                        DKSHSetupRec: Record "DKSH Integration Setup";
                        DKSHVendorCode: Text;
                    begin
                        if IntegrationCU.IsDKSHVendor(Rec."Buy-from Vendor No.") then begin
                            if Confirm('Send Undo Request to Outgoing PO DKSH Staging Tables?', false) then begin
                                if DKSHSetupRec.Get() then
                                    DKSHVendorCode := DKSHSetupRec."BC Vendor Code";

                                CurrPage.SetSelectionFilter(POHeader);
                                POHeader.SetRange("Buy-from Vendor No.", DKSHVendorCode);
                                POHeader.SetRange(Status, POHeader.Status::Released);

                                if POHeader.Count <= 0 then
                                    Error('Nothing to generate');

                                if POHeader.FindSet() then
                                        repeat
                                            Clear(IntegrationCU);
                                            IntegrationCU.DeleteOutgoingPOStagingRecords(POHeader."No.", false);
                                        until POHeader.Next() = 0;
                            end;
                        end;
                    end;
                }

                /*
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
                */
            }

        }

        /*
        modify(Release)
        {
            trigger OnAfterAction()
            var
                IntegrationCU: Codeunit "DKSH Integrations";
                DKSHSetupRec: Record "DKSH Integration Setup";
                DKSHVendorCode: Text;
            begin
                if IntegrationCU.IsDKSHVendor(Rec."Buy-from Vendor No.") then begin
                    if Confirm('Send to Outgoing DKSH PO Staging Tables?', false) then begin
                        if DKSHSetupRec.Get() then
                            DKSHVendorCode := DKSHSetupRec."BC Vendor Code";

                        CurrPage.SetSelectionFilter(POHeader);
                        POHeader.SetRange("Buy-from Vendor No.", DKSHVendorCode);
                        POHeader.SetRange(Status, POHeader.Status::Released);

                        if POHeader.Count <= 0 then
                            Error('Nothing to generate');

                        if POHeader.FindSet() then
                            repeat
                                    // Check Expiry Dates
                                    if IntegrationCU.HasItemExpiryDateBelowOneYear(POHeader."No.", false) then
                                        Message('There are items expiring in less than 1 year for PO - ' + POHeader."No.");

                                // insert to staging    
                                IntegrationCU.InsertOrUpdateOutgoingPOStagingRecords(POHeader."No.", false);

                            // add wait state to generate unique file name based on timestamp
                            // Sleep(1000); // not required if pushing to staging tables
                            until POHeader.Next() = 0;
                    end;
                end;
            end;
        }
        */

    }

    var
        POHeader: Record "Purchase Header";

}