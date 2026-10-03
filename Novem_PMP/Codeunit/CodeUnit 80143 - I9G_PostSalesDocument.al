codeunit 80143 I9G_PostSalesDocument
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesPostCodeunit: Codeunit "Sales-Post";
        xRecQtyToShip: Decimal;
        ResetSalesHeaderRec: Record "Sales Header";
    begin
        Clear(SalesPostCodeunit);
        SalesHeaderRec.Reset();
        if SalesHeaderRec.Get(Rec."Record ID to Process") then begin
            ResetSalesHeaderRec.Reset();
            ResetSalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type");
            ResetSalesHeaderRec.SetRange("No.", SalesHeaderRec."No.");
            if ResetSalesHeaderRec.FindFirst() then begin
                SalesHeaderRec.Reset();
            end;
            SalesPostCodeunit.Run(ResetSalesHeaderRec);
        end;
    end;
}