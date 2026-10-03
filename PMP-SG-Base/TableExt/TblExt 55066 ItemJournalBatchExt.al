tableextension 55066 ItemJournalBatchExt extends "Item Journal Batch"
{
    fields
    {
        field(55000; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
    }

}
