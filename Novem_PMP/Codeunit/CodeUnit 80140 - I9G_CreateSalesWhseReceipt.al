codeunit 80140 I9G_CreateSalesWhseReceipt
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        I9G_BindSubscriptionCodeunit: Codeunit I9G_BindSubscription;
    begin
        SalesHeaderRec.Reset();
        if SalesHeaderRec.Get(Rec."Record ID to Process") then begin
            SalesHeaderRec.PerformManualRelease();
            /*
            BindSubscription(I9G_BindSubscriptionCodeunit);
            GetSourceDocInbound.CreateFromSalesReturnOrder(SalesHeaderRec);
            UnbindSubscription(I9G_BindSubscriptionCodeunit);
            */
            GetSourceDocInbound.CreateFromSalesReturnOrderHideDialog(SalesHeaderRec);
        end;
    end;
}