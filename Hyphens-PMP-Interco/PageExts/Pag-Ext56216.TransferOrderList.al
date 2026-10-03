pageextension 56216 TransferOrderList extends "Transfer Orders"
{
    actions
    {
        addafter("F&unctions")
        {
            action("Retrieve Returns from PMP")
            {
                ApplicationArea = all;
                Caption = 'Generate TO in OH';
                Promoted = true;
                PromotedCategory = Process;
                Image = TransferOrder;
                Visible = IsOHPL;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    if CompanyName <> 'OHPL' then begin
                        Error('Please execute this process in Ocean Health Pte Ltd only.');
                    end else begin
                        /*
                        clear(PostedTransferShipmentsList);
                        PostedTransRec.reset;
                        PostedTransRec.ChangeCompany('OHPL');
                        PostedTransRec.SetRange("Transfer-to Code", 'W3');
                        PostedTransRec.SetFilter("Interco Order No", '<>%1', '');
                        PostedTransferShipmentsList.SetTableView(PostedTransRec);
                        if page.RunModal()
*/
                        page.Run(56201);
                    end;
                end;
            }
        }

    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if CompanyName = 'OHPL' then
            IsOHPL := true
        else
            IsOHPL := false;
    end;

    var

        IsOHPL: Boolean;
        intercoCU: Codeunit "Hyphens PMP Interco CU";
        PostedTransferShipmentsList: Page "Posted Transfer Shipments";
        PostedTransRec: Record "Transfer Shipment Header";
}
