pageextension 52000 SSDBSSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Exact Cost Reversing Mandatory")
        {
            field("Def. DBS CRJ Journal Batch"; Rec."Def. DBS CRJ Journal Batch")
            {
                ApplicationArea = all;
                ToolTip = 'Default CRJ Batch for DBS Incoming Receipts';
            }
            field("Def. DBS Incoming Bank"; Rec."Def. DBS Incoming Bank")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}