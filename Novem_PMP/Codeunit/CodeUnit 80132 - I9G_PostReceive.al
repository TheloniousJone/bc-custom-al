codeunit 80132 I9G_PostReceive
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        PurchPostCodeunit: Codeunit "Purch.-Post";
        xRecQtyToReceive: Decimal;
        xRecPurchasePrice: Decimal;
        ResetPurchaseHeaderRec: Record "Purchase Header";
    begin
        Clear(PurchPostCodeunit);
        PurchaseHeaderRec.Reset();
        if PurchaseHeaderRec.Get(Rec."Record ID to Process") then begin
            PurchaseLineRec.Reset();
            PurchaseLineRec.SetRange("Document Type", PurchaseHeaderRec."Document Type");
            PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
            if PurchaseLineRec.FindSet() then begin
                repeat
                    Clear(xRecQtyToReceive);
                    xRecQtyToReceive := PurchaseLineRec."Qty. to Receive";
                    Clear(xRecPurchasePrice);
                    xRecPurchasePrice := PurchaseLineRec."Purchase Price";
                    PurchaseLineRec.Validate("Order Qty");
                    PurchaseLineRec.Validate(Quantity);
                    PurchaseLineRec.Validate("Quantity (Base)");
                    PurchaseLineRec.Validate("Qty. to Receive", xRecQtyToReceive);
                    PurchaseLineRec.Validate("Purchase Price", xRecPurchasePrice);
                    PurchaseLineRec.Modify(false);
                until PurchaseLineRec.Next() = 0;
            end;
            ResetPurchaseHeaderRec.Reset();
            ResetPurchaseHeaderRec.SetRange("Document Type", PurchaseHeaderRec."Document Type");
            ResetPurchaseHeaderRec.SetRange("No.", PurchaseHeaderRec."No.");
            if ResetPurchaseHeaderRec.FindFirst() then begin
                PurchaseHeaderRec.Reset();
            end;
            ResetPurchaseHeaderRec.Receive := true;
            ResetPurchaseHeaderRec.Invoice := false;
            PurchPostCodeunit.Run(ResetPurchaseHeaderRec);
        end;
    end;
}