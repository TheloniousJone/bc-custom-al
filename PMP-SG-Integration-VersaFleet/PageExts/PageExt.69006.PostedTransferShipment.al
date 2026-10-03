pageextension 69006 PostedTrShipment extends "Posted Transfer Shipment"
{
    layout
    {
        addlast(General)
        {
            field(I9G_DriverCode; Rec.I9G_DriverCode)
            {
                ApplicationArea = All;
            }
            field(I9G_DeliveryChargeCode; Rec.I9G_DeliveryChargeCode)
            {
                ApplicationArea = All;
            }
        }
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