pageextension 70071 PostedSalesShipmentListExt extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field(I9G_SignedOrder; Rec.I9G_SignedOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Signed Order field.';
            }
            field(I9G_DeliveryOrder; Rec.I9G_DeliveryOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Delivery Order field.';
            }
        }
    }
    actions
    {
        addafter(PrintCertificateofSupply)
        {
            action(PostedSalesShipment)
            {
                Caption = 'Signed Order/Delivery Order';
                Image = Order;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    SalesShipmentHeaderRec: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(SalesShipmentHeaderRec);
                    Report.RunModal(70000, true, false, SalesShipmentHeaderRec);
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(PostedSalesShipment_Promoted; PostedSalesShipment) { }
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