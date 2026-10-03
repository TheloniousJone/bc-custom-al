pageextension 55146 ApplyCustEntry extends "Apply Customer Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action("Import Payments")
            {
                ApplicationArea = All;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IntegrationCU.ImportChainPaymentsCLE();
                end;
            }
        }
    }

    var
        myInt: Integer;
        IntegrationCU: Codeunit "PMP Integrations";
}