codeunit 80141 I9G_BatchCreateSO
{
    Permissions = tabledata "Sales Line" = rimd, tabledata "Sales Header" = rimd;
    trigger OnRun()
    var
        SalesHeaderRec: Record "Sales Header";
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
        SalesHeaderRec.SetRange(I9G_NeedToCreateSO, true);
        SalesHeaderRec.SetRange(I9G_SOCreated, false);
        if SalesHeaderRec.FindSet() then begin
            repeat
                I9G_ThirdPartyLogisticCodeUnit.CreateSalesDocument(SalesHeaderRec);
            until SalesHeaderRec.Next() = 0;
        end;
    end;
}