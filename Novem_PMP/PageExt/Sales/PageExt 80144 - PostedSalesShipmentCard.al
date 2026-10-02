pageextension 80144 PostedSalesShipmentCardExt3PL extends "Posted Sales Shipment"
{
    actions
    {
        addlast(processing)
        {
            action("DeliveryOrder3PL")
            {
                Caption = 'Delivery Order (3PL)';
                ApplicationArea = All;
                Image = SalesInvoice;
                ToolTip = 'Print Delivery Order (3PL).';
                trigger OnAction()
                var
                    DeliverOrderReport: Report I9G_DeliveryOrder3PL;
                    SalesShipmentHeaderRec: Record "Sales Shipment Header";
                    I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
                    RecRef: RecordRef;
                begin
                    SalesShipmentHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(SalesShipmentHeaderRec);
                    RecRef.GetTable(SalesShipmentHeaderRec);
                    DeliverOrderReport.GetReportOptionAndFilter(Rec.I9G_FromCompanyName, I9G_ThirdPartyLogisticCodeUnit.GetSelectionFilter(RecRef, SalesShipmentHeaderRec.FieldNo("No.")));
                    DeliverOrderReport.RunModal();
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(DeliveryOrder3PL_Promoted; DeliveryOrder3PL) { }
        }
    }
    trigger OnOpenPage()
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
    begin
        ReportVisible := false;
        if (I9G_ThirdPartyLogisticSetupRec.Get()) then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (I9G_ThirdPartyLogisticCodeUnit.CheckCompanyName = false) then begin
                ReportVisible := true;
            end;
        end;
    end;

    var
        ReportVisible: Boolean;
}