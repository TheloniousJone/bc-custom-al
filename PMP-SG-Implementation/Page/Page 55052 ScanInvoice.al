page 55052 ScanInvoice
{
    //DX        09 July 2021
    Caption = 'Scan Invoice for completion';
    PageType = Card;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            group(General)
            {

                field(InvNo; InvNo)
                {
                    Caption = 'Scan invoice no. to update completed.';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if InvNo <> '' then begin
                            EnhanceCU.ScanInvoice(InvNo);
                            InvNo := '';
                        end;
                    end;

                }
            }
        }
    }

    var
        InvNo: Code[20];
        EnhanceCU: Codeunit "PMP-Enhancements";

}
