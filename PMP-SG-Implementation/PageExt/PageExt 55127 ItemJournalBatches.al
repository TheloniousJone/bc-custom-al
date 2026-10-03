pageextension 55127 ItemJournalBatchesExt extends "Item Journal Batches"
{
    layout
    {
        addafter("Posting No. Series")
        {
            field("I9 Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    ItemJnlLines: Record "Item Journal Line";
                begin
                    // do not allow change if existing item journal lines exists
                    if Rec."Gen. Prod. Posting Group" <> '' then begin
                        ItemJnlLines.Reset;
                        ItemJnlLines.SetRange("Journal Batch Name", Rec.Name);
                        ItemJnlLines.SetRange("Journal Template Name", 'ITEM');
                        ItemJnlLines.SetFilter("Item No.", '<>%1', '');
                        if ItemJnlLines.Count > 0 then
                            Error('Existing Item Journal Lines present. Cannot edit');
                    end;
                end;
            }
        }
    }
}
