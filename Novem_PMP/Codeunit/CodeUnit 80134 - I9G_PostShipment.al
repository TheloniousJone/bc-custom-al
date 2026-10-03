codeunit 80134 I9G_PostShipment
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
            SalesLineRec.Reset();
            SalesLineRec.SetRange("Document Type", SalesHeaderRec."Document Type");
            SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
            if SalesLineRec.FindSet() then begin
                repeat
                    Clear(xRecQtyToShip);
                    xRecQtyToShip := SalesLineRec."Qty. to Ship";
                    SalesLineRec.Validate(Quantity);
                    SalesLineRec.Validate("Quantity (Base)");
                    SalesLineRec.Validate("Qty. to Ship", xRecQtyToShip);
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