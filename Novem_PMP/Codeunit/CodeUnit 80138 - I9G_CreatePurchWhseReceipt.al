codeunit 80138 I9G_CreatePurchWhseReceipt
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        I9G_BindSubscriptionCodeunit: Codeunit I9G_BindSubscription;
        ResetPurchaseHeaderRec: Record "Purchase Header";
    begin
        PurchaseHeaderRec.Reset();
        if PurchaseHeaderRec.Get(Rec."Record ID to Process") then begin
            PurchaseLineRec.Reset();
            PurchaseLineRec.SetRange("Document Type", PurchaseHeaderRec."Document Type");
            PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
            if PurchaseLineRec.FindSet() then begin
                repeat
                    PurchaseLineRec.Validate("Order Qty");
                    PurchaseLineRec.Validate("Purchase Price", 0);
                    PurchaseLineRec.Validate("Unit Cost", 0);
                    PurchaseLineRec.Validate("Direct Unit Cost", 0);
                    PurchaseLineRec.Modify();
                until PurchaseLineRec.Next() = 0;
            end;
            PurchaseHeaderRec.PerformManualRelease();
            ResetPurchaseHeaderRec.Reset();
            ResetPurchaseHeaderRec.SetRange("Document Type", PurchaseHeaderRec."Document Type");
            ResetPurchaseHeaderRec.SetRange("No.", PurchaseHeaderRec."No.");
            if ResetPurchaseHeaderRec.FindFirst() then begin
                PurchaseHeaderRec.Reset();
            end;
            /*
            BindSubscription(I9G_BindSubscriptionCodeunit);
            GetSourceDocInbound.CreateFromPurchOrder(ResetPurchaseHeaderRec);
            UnbindSubscription(I9G_BindSubscriptionCodeunit);
            */
            GetSourceDocInbound.CreateFromPurchOrderHideDialog(ResetPurchaseHeaderRec);
        end;
    end;
}