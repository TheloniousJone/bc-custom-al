codeunit 59002 POMEventCU
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::CustomEvents, 'OnBeforeCreateWarehouseShipmentFromSOtoWH', '', true, true)]
    local procedure OnBeforeCreateWarehouseShipmentFromSOtoWH(var SalesHeader: Record "Sales Header")
    var
        totalInvAmtDec: Decimal;
        SIhRec: Record "Sales Header";
    begin
        if SalesHeader."Amount Collected by POM" <> 0 then begin
            clear(TotalInvAmtDec);
            SIHRec.reset;
            SIHRec.SetRange("Document Type", SalesHeader."Document Type");
            SIHRec.SetRange("No.", SalesHeader."No.");
            if SIhRec.FindFirst() then begin
                SIHRec.CalcFields("Amount Including VAT");
                TotalInvAmtDec := SIHRec."Amount Including VAT";
                if TotalInvAmtDec > SalesHeader."Amount Collected by POM" then
                    Error('You are not allowed to release to warehouse if your invoice amount is more than the amount collected by POM.');
            end;


        end;
    end;



}
