pageextension 55149 TransferReceiptExt extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addafter("Shipping Time")
        {
            //LK231123
            field("I9G QC/QA Comments"; Rec."I9G QC/QA Comments")
            {
                ApplicationArea = All;

            }
            //LK231123
        }
    }
}
