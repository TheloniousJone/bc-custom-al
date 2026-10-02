pageextension 69002 TBALedgerEntListExt extends "TBA Ledger Entry"
{
    layout
    {
        // add fields
    }

    actions
    {
        // add actions
        addafter("Insert New TBA From Sales Invoice")
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
                    TBARec: Record "TBA Ledger Entry";
                    VersafleetCU: Codeunit "VersaFleet Integrations";
                begin
                    if Confirm('Send TBA Ledger(s) to Staging Versafleet Delivery Queue', false) then begin

                        CurrPage.SetSelectionFilter(TBARec);
                        TBARec.SetRange("Entry Type", TBARec."Entry Type"::Delivery); // Limit to only delivery entries
                        VersafleetCU.InsertOrUpdateStagingInvoiceRecords(TBARec);
                    end;
                end;
            }
        }
    }
}
