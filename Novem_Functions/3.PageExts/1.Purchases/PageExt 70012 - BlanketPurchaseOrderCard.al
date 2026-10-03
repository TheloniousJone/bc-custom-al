pageextension 70012 BlanketPurchaseOrderCardExt extends "Blanket Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field(I9G_SpecialInstructions; Rec.I9G_SpecialInstructions)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                MultiLine = true;
                ToolTip = 'Specifies the value of the Special Instruction field.';
            }
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                MultiLine = true;
                ToolTip = 'Specifies the value of the Remarks field.';
            }
            field(I9G_InternalRemarks; Rec.I9G_InternalRemarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                MultiLine = true;
                ToolTip = 'Specifies the value of the Internal Remarks field.';
            }
            field(I9G_ReferenceInvoiceNo; Rec.I9G_ReferenceInvoiceNo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Ref. Invoice No. field.';
            }
            field(I9G_ShipmentDate; Rec.I9G_ShipmentDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Shipment Date field.';
            }
            field(I9G_ShipVia; Rec.I9G_ShipVia)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Ship Via field.';
            }
            field(I9G_Admin; Rec.I9G_Admin)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Admin field.';
            }
            field(I9G_CompletelyReceived; Rec.I9G_CompletelyReceived)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Completely Received field.';
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}