pageextension 55156 RevaluationJournalExt extends "Revaluation Journal"
{
    layout
    {
        addlast(Control1)
        {

            field("I9G_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            }
        }

    }

}
