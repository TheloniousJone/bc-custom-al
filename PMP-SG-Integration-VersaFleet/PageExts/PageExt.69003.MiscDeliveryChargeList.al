pageextension 69003 MiscDelChargeListExt extends "Delivery Misc Charges List"
{
    layout
    {
        // add fields
    }

    actions
    {
        // add actions
        addlast(Processing)
        {
            action("Queue for Versafleet Delivery Task")
            {
                ApplicationArea = all;
                Caption = 'Queue for Versafleet Delivery Task';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Export;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DMCRec: Record "Delivery Misc Charges";
                    VersafleetCU: Codeunit "VersaFleet Integrations";
                begin
                    if Confirm('Send Misc Delivery Charge(s) to Staging Versafleet Delivery Queue', false) then begin

                        CurrPage.SetSelectionFilter(DMCRec);
                        DMCRec.SetFilter("Customer No.", '<>%1', ''); // Limit to only those with customer no.
                        VersafleetCU.InsertOrUpdateStagingInvoiceRecords(DMCRec);
                    end;
                end;
            }
        }
    }
}
