pageextension 69000 PostedSalesInvoiceListExt extends "Posted Sales Invoices"
{
    layout
    {
        // add fields
    }

    actions
    {
        // add actions
        addafter("&Invoice")
        {
            group("Versafleet")
            {
                action("Queue for Delivery Task")
                {
                    ApplicationArea = all;
                    Caption = 'Queue for Delivery Task';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SIHRec: Record "Sales Invoice Header";
                        VersafleetCU: Codeunit "VersaFleet Integrations";
                    begin
                        if Confirm('Send Posted Sales Invoice(s) to Staging Delivery Queue', false) then begin
                            CurrPage.SetSelectionFilter(SIHRec);
                            VersafleetCU.InsertOrUpdateStagingInvoiceRecords(SIHRec);
                        end;
                    end;
                }
            }
        }
    }
}
