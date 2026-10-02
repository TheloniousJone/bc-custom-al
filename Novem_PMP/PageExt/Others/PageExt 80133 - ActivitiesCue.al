pageextension 80133 ActivitiesCue extends "O365 Activities"
{
    layout
    {
        addafter(Control54)
        {
            cuegroup(Interco)
            {
                Caption = 'Third Party Logistics';
                field(I9G_NoOfOpenWarehouseSO; Rec.I9G_NoOfOpenWarehouseSO)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of Open Warehouse SO field.';
                    DrillDownPageId = "Sales Order List";
                }
                field(I9G_NoOfOpenWarehousePO; Rec.I9G_NoOfOpenWarehousePO)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of Open Warehouse PO field.';
                    DrillDownPageId = "Purchase Order List";
                }
                field("No. Of Warehouse SO Sent"; Rec."No. Of Warehouse SO Sent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of Warehouse SO Sent field.';
                    DrillDownPageId = "Sales Order List";
                }
                field("No. Of Warehouse PO Sent"; Rec."No. Of Warehouse PO Sent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of Warehouse PO Sent field.';
                    DrillDownPageId = "Purchase Order List";
                }
            }
        }
    }
}