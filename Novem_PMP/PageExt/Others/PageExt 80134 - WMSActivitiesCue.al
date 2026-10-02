pageextension 80134 WMSActivitiesCue extends "WMS Ship & Receive Activities"
{
    layout
    {
        addafter("Inbound - Today")
        {
            cuegroup(Interco)
            {
                Caption = 'Third Party Logistics';
                field("No. Of Warehouse PO Received"; Rec."No. Of Warehouse PO Received")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase Order List";
                }
                field("No. Of Warehouse SO Received"; Rec."No. Of Warehouse SO Received")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Sales Order List";
                }
            }
        }
    }
}