codeunit 55012 CustomEvents
{


    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateWarehouseShipmentFromSOtoWH(var SalesHeader: Record "Sales Header")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, OnAfterValidateShortcutDimValues, '', true, true)]
    local procedure OnAfterValidateShortcutDimValues(FieldNumber: Integer; var DimSetID: Integer; var ShortcutDimCode: Code[20])
    begin
        // if UserId = 'DIXONSAMUEL' then begin
        //     Message('field number %1 , Dim Set Id %2, shortcutdimcode %3', FieldNumber, DimSetID, ShortcutDimCode);
        // end;
    end;



}
