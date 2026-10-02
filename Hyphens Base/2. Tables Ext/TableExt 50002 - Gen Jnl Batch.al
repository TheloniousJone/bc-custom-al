tableextension 50002 GJBatch extends "Gen. Journal Batch"
{
    fields
    {
        // ...
    }

    trigger OnAfterInsert()
    begin
        "Copy to Posted Jnl. Lines" := true;
        Modify(false);
    end;
}