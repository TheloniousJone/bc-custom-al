codeunit 70001 I9G_DirectTransferHeaderEdit
{
    Permissions = TableData "Direct Trans. Header" = rm;
    TableNo = "Direct Trans. Header";

    trigger OnRun()
    var
        DirecTransHeader: Record "Direct Trans. Header";
    begin
        DirecTransHeader.Copy(Rec);
        DirecTransHeader.ReadIsolation(IsolationLevel::UpdLock);
        DirecTransHeader.Find();
        DirecTransHeader.I9G_Remarks := Rec.I9G_Remarks;
        DirecTransHeader.I9G_InternalRemarks := Rec.I9G_InternalRemarks;
        DirecTransHeader.I9G_CaseNumber := Rec.I9G_CaseNumber;
        DirecTransHeader.I9G_DateUsed := Rec.I9G_DateUsed;
        DirecTransHeader.I9G_DeliveryDate := Rec.I9G_DeliveryDate;
        DirecTransHeader.I9G_CaseDR := Rec.I9G_CaseDR;
        DirecTransHeader.TestField("No.", Rec."No.");
        DirecTransHeader.Modify();
        Rec.Copy(DirecTransHeader);
    end;
}

