codeunit 80135 I9G_UndoShipment
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        SalesShipmentLineRec: Record "Sales Shipment Line";
        CopySalesShipmentLineRec: Record "Sales Shipment Line";
        UndoSalesShipmentCodeunit: Codeunit "Undo Sales Shipment Line";
        I9G_BindSubscriptionCodeunit: Codeunit I9G_BindSubscription;
    begin
        Clear(UndoSalesShipmentCodeunit);
        SalesShipmentLineRec.Reset();
        if SalesShipmentLineRec.Get(Rec."Record ID to Process") then begin
            CopySalesShipmentLineRec.Reset();
            CopySalesShipmentLineRec.SetRange("Document No.", SalesShipmentLineRec."Document No.");
            CopySalesShipmentLineRec.SetRange("Line No.", SalesShipmentLineRec."Line No.");
            if CopySalesShipmentLineRec.FindFirst() then begin
                BindSubscription(I9G_BindSubscriptionCodeunit);
                UndoSalesShipmentCodeunit.Run(CopySalesShipmentLineRec);
                UnbindSubscription(I9G_BindSubscriptionCodeunit);
            end;
        end;
    end;
}