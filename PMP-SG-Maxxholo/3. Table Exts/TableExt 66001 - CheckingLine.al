tableextension 66001 CheckingLineMaxxholo extends "Checking Line"
{
    fields
    {

    }

    var
        gcdu_MaxxholoIntegration: Codeunit "Maxxholo Integration";

    trigger OnDelete()
    var
        lrec_MaxxholoHeader: Record MaxxholoHeader;
    begin
        Clear(gcdu_MaxxholoIntegration);
        if gcdu_MaxxholoIntegration.IsItemMaxxholo("Item No.") then begin
            lrec_MaxxholoHeader.Reset();
            lrec_MaxxholoHeader.SetRange(I9G_SourceDocNo, "Doc No.");
            lrec_MaxxholoHeader.SetRange(I9G_SourceDocLineNo, "Line No.");
            lrec_MaxxholoHeader.SetRange(I9G_ProductCode, "Item No.");
            if lrec_MaxxholoHeader.FindFirst() then begin
                lrec_MaxxholoHeader.Delete(true);
            end;
        end;
    end;
}