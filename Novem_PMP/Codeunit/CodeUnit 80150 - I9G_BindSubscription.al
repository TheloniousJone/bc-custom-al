codeunit 80150 I9G_BindSubscription
{
    EventSubscriberInstance = Manual;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Purchase Receipt Line", OnBeforeOnRun, '', false, false)]
    local procedure "UndoPurchaseReceiptLineOnBeforeOnRun"(var PurchRcptLine: Record "Purch. Rcpt. Line"; var IsHandled: Boolean; var SkipTypeCheck: Boolean; var HideDialog: Boolean)
    var
    begin
        HideDialog := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Sales Shipment Line", OnBeforeOnRun, '', false, false)]
    local procedure "UndoSalesShipmentLineOnBeforeOnRun"(var SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean; var SkipTypeCheck: Boolean; var HideDialog: Boolean)
    var
    begin
        HideDialog := true;
    end;

    /* 01/08/2026 - YT - Suppress Warehouse Receipt/Shipment Page when running in non-GUI mode -- Begin */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnOpenWarehouseReceiptPage', '', false, false)]
    local procedure SuppressWarehouseReceiptPage(WarehouseReceiptHeader: Record "Warehouse Receipt Header"; ServVendDocNo: Code[20]; var IsHandled: Boolean; var GetSourceDocuments: Report "Get Source Documents")
    var
    begin
        if not GuiAllowed then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", OnBeforeOpenWarehouseShipmentPage, '', false, false)]
    local procedure SuppressWarehouseShipmentPage(var GetSourceDocuments: Report "Get Source Documents"; var IsHandled: Boolean)
    var
    begin
        if not GuiAllowed then
            IsHandled := true;
    end;
    /* 01/08/2026 - YT - Suppress Warehouse Receipt/Shipment Page when running in non-GUI mode -- End */
}