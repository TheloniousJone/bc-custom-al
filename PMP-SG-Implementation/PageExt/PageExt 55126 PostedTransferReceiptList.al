pageextension 55126 PostedTransferReceiptList extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = all;
            }
        }
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
            // field("No. of Carton"; Rec."No. of Carton")
            // {
            //     ApplicationArea = All;
            // }
        }
    }
}
