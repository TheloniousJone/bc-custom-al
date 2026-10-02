pageextension 56214 PurchInvList extends "Purchase Invoices"
{
    actions
    {
        addfirst(processing)
        {
            action("Generate Interco")
            {
                ApplicationArea = all;
                Caption = 'Generate Interco Doc.';
                Promoted = true;
                PromotedCategory = Process;
                Image = Create;
                trigger OnAction()
                var
                    myInt: Integer;
                    IntercoRep: Report IntercoInvoiceGen;
                begin
                    IntercoRep.Run();

                end;
            }
        }
    }
}
