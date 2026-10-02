pageextension 55150 PostedReturnReceiptSubExt extends "Posted Return Receipt Subform"
{
    layout
    {
        addafter("Shipment Date")
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