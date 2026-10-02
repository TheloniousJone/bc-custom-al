codeunit 80142 I9G_CreateTransWhseShipAndPick
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        TransferHeaderRec: Record "Transfer Header";
        TransferLineRec: Record "Transfer Line";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        I9G_BindSubscriptionCodeunit: Codeunit I9G_BindSubscription;
    begin
        TransferHeaderRec.Reset();
        if TransferHeaderRec.Get(Rec."Record ID to Process") then begin
            PerformManualRelease(TransferHeaderRec);
            /*
            BindSubscription(I9G_BindSubscriptionCodeunit);
            GetSourceDocOutbound.CreateFromOutbndTransferOrder(TransferHeaderRec);
            UnbindSubscription(I9G_BindSubscriptionCodeunit);
            */
            GetSourceDocOutbound.CreateFromOutbndTransferOrderHideDialog(TransferHeaderRec);
            PickCreate(TransferHeaderRec);
        end;
    end;

    procedure PickCreate(par_TransferHeaderRec: Record "Transfer Header")
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        TransferLineRec: Record "Transfer Line";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
    begin
        WhseShptLine.Reset();
        WhseShptLine.SetRange("Source Type", TransferLineRec.RecordId.TableNo);
        WhseShptLine.SetRange("Source No.", par_TransferHeaderRec."No.");
        if WhseShptLine.FindSet() then begin
            WhseShptHeader.Get(WhseShptLine."No.");
            if WhseShptHeader.Status = WhseShptHeader.Status::Open then
                ReleaseWhseShipment.Release(WhseShptHeader);
            repeat
                WhseShptLine.CreatePickDoc(WhseShptLine, WhseShptHeader)
            until WhseShptLine.Next() = 0;
        end;
    end;

    procedure PerformManualRelease(par_TransferHeaderRec: Record "Transfer Header")
    var
        ReleaseTransferDoc: Codeunit "Release Transfer Document";
        IsHandled: Boolean;
    begin
        if par_TransferHeaderRec.Status <> par_TransferHeaderRec.Status::Released then begin
            ReleaseTransferDoc.Release(par_TransferHeaderRec);
            Commit();
        end;
    end;
}