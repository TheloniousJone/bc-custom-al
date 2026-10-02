pageextension 56217 ReturnShipment extends "Posted Return Shipment"
{
    layout
    {
        addlast(General)
        {
            field("Interco Order No."; Rec."Interco Order No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }

    }
    actions
    {
        addafter("&Navigate")
        {
            action("Reset Transfer to OH")
            {
                ApplicationArea = all;
                Caption = 'Reset Transfer to OH';
                Promoted = true;
                PromotedCategory = Process;
                Image = TransferOrder;
                Visible = true;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    if CompanyName <> 'PMP' then begin
                        Error('Please execute this process in Pan Malayan Pharmaceuticals Company only.');
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
                        if Confirm('Are you sure you wish to reset the interco order no. for this Purchase Return Order?') then begin
                            intercoCU.ResetOHTransfer(Rec);
                        end;
                    end;
                end;
            }
        }

    }
    var
        IsPMP: Boolean;
        intercoCU: Codeunit "Hyphens PMP Interco CU";
        PostedTransferShipmentsList: Page "Posted Transfer Shipments";
        PostedTransRec: Record "Transfer Shipment Header";
}
