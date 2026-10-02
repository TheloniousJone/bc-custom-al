pageextension 50049 PostedSalesCrMemoUpdate extends "Pstd. Sales Cr. Memo - Update"
{
    layout
    {
        addlast("Cr. Memo Details")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}