codeunit 80131 I9G_BatchCreatePO
{
    Permissions = tabledata "Purchase Line" = rimd, tabledata "Purchase Header" = rimd;
    trigger OnRun()
    var
        PurchaseHeaderRec: Record "Purchase Header";
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
    begin
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetRange("Document Type", PurchaseHeaderRec."Document Type"::Order);
        PurchaseHeaderRec.SetRange(I9G_NeedToCreatePO, true);
        PurchaseHeaderRec.SetRange(I9G_POCreated, false);
        if PurchaseHeaderRec.FindSet() then begin
            repeat
                I9G_ThirdPartyLogisticCodeUnit.CreatePurchaseDocument(PurchaseHeaderRec);
            until PurchaseHeaderRec.Next() = 0;
        end;
    end;
}