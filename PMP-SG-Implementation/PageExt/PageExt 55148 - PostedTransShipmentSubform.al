pageextension 55148 TransferShipmentExt extends "Posted Transfer Shpt. Subform"
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
