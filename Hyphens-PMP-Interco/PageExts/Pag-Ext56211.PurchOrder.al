pageextension 56211 PurchOrder extends "Purchase Order"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Interco Order No"; Rec."Interco Order No")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(CopyDocument)
        {
            action("Retrieve Transfers from OH")
            {
                ApplicationArea = all;
                Caption = 'Generate PO in PMP';
                Promoted = true;
                PromotedCategory = Process;
                Image = TransferOrder;
                Visible = IsPMP;
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
