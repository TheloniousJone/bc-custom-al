codeunit 80137 I9G_PostCreditMm
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesPostCodeunit: Codeunit "Sales-Post";
        xRecQtyToInvoice: Decimal;
    begin
        Clear(SalesPostCodeunit);
        SalesHeaderRec.Reset();
        if SalesHeaderRec.Get(Rec."Record ID to Process") then begin
            SalesPostCodeunit.Run(SalesHeaderRec);
        end;
    end;
}