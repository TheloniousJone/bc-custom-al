codeunit 80136 I9G_PostInvoice
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesPostCodeunit: Codeunit "Sales-Post";
        ResetSalesHeaderRec: Record "Sales Header";
        xRecQtyToInvoice: Decimal;
    begin
        Clear(SalesPostCodeunit);
        SalesHeaderRec.Reset();
        if SalesHeaderRec.Get(Rec."Record ID to Process") then begin
            SalesLineRec.Reset();
            SalesLineRec.SetRange("Document Type", SalesHeaderRec."Document Type");
            SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
            if SalesLineRec.FindSet() then begin
                repeat
                    Clear(xRecQtyToInvoice);
                    xRecQtyToInvoice := SalesLineRec."Qty. to Invoice";
                    SalesLineRec.Validate(Quantity);
                    SalesLineRec.Validate("Quantity (Base)");
                    SalesLineRec.Validate("Qty. to Invoice", xRecQtyToInvoice);
                    SalesLineRec.Modify(false);
                until SalesLineRec.Next() = 0;
            end;
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