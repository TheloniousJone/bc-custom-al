pageextension 69009 SalesReturnOrderCard extends "Sales Return Order"
{

    actions
    {

        addbefore("Delete Warehouse Documents")
        {
            group(Versafleet)
            {
                action("Queue for Delivery Task")
                {
                    ApplicationArea = All;
                    Caption = 'Queue for Delivery Task';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SHRec: Record "Sales Header";
                        VersafleetCU: Codeunit "VersaFleet Integrations";
                    begin
                        if Confirm('Send Sales Return Order(s) to Staging Delivery Queue', false) then begin
                            CurrPage.SetSelectionFilter(SHRec);
                            VersafleetCU.InsertOrUpdateSalesReturnOrderToStagingInvoiceRecords(SHRec);
                        end;
                    end;
                }
            }
        }
    }
}