pageextension 56210 SalesInvoiceList extends "Sales Invoice List"
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
