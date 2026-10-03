pageextension 69005 PostedTrShipments extends "Posted Transfer Shipments"
{
    layout
    {

    }

    actions
    {
        addafter("&Shipment")
        {
            group("Versafleet")
            {
                action("Queue for Delivery Task")
                {
                    ApplicationArea = all;
                    Caption = 'Queue for Delivery Task';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        TransferShipmentHeader: Record "Transfer Shipment Header";
                        VersafleetCU: Codeunit "VersaFleet Integrations";
                    begin
                        if Confirm('Send Transfer Shipment(s) to Staging Delivery Queue', false) then begin
                            CurrPage.SetSelectionFilter(TransferShipmentHeader);
                            VersafleetCU.InsertOrUpdateStagingTransferRecords(TransferShipmentHeader);
                        end;
                    end;
                }
            }
        }
    }
}