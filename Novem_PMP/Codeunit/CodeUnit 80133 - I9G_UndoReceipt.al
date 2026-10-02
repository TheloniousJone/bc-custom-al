codeunit 80133 I9G_UndoReceipt
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        PurchRcptLineRec: Record "Purch. Rcpt. Line";
        CopyPurchRcptLineRec: Record "Purch. Rcpt. Line";
        UndoPurchaseReceiptLineCodeunit: Codeunit "Undo Purchase Receipt Line";
        I9G_BindSubscriptionCodeunit: Codeunit I9G_BindSubscription;
    begin
        Clear(UndoPurchaseReceiptLineCodeunit);
        PurchRcptLineRec.Reset();
        if PurchRcptLineRec.Get(Rec."Record ID to Process") then begin
            CopyPurchRcptLineRec.Reset();
            CopyPurchRcptLineRec.SetRange("Document No.", PurchRcptLineRec."Document No.");
            CopyPurchRcptLineRec.SetRange("Line No.", PurchRcptLineRec."Line No.");
            if CopyPurchRcptLineRec.FindFirst() then begin
                BindSubscription(I9G_BindSubscriptionCodeunit);
                UndoPurchaseReceiptLineCodeunit.Run(CopyPurchRcptLineRec);
                UnbindSubscription(I9G_BindSubscriptionCodeunit);
            end;
        end;
    end;
}