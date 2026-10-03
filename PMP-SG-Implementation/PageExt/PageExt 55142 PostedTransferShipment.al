pageextension 55142 PostedTransferShipment extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Transfer-to Code")
        {
            field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
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
        }
    }
}