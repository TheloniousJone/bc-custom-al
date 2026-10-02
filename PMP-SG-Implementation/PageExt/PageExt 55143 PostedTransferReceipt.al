pageextension 55143 PostedTransferReceipt extends "Posted Transfer Receipt"
{
    layout
    {

        addafter("Shortcut Dimension 2 Code")
        {
            field("TO Created By"; Rec."TO Created By")
            {
                ApplicationArea = all;
            }
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}