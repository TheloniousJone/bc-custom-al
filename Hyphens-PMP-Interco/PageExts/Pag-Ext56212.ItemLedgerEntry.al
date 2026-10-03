pageextension 56212 ItemLedgerEntry extends "Item Ledger Entries"
{
    layout
    {
        addafter("Location Code")
        {
            field("Transferred to OH"; Rec."Transferred to OH")
            {
                ApplicationArea = all;
            }
            field("Invoiced to OH"; Rec."Invoiced to OH")
            {
                ApplicationArea = all;
            }


        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action("Reset Transfer To OH")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Action;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    myInt: Integer;
                    OHCU: Codeunit "Hyphens PMP Interco CU";
                    ILERec: Record "Item Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(ILERec);
                    if ILERec.FindSet() then
                        repeat
                            OHCU.ResetTransferStatus(ILERec);
                        until ILERec.next = 0;
                    if ILERec.Count > 0 then
                        Message('Transfer Entries have been reset, please reinvoice again.');
                end;
            }
            action("Reset Invoice To OH")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Action;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    myInt: Integer;
                    OHCU: Codeunit "Hyphens PMP Interco CU";
                    ILERec: Record "Item Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(ILERec);
                    if ILERec.FindSet() then
                        repeat
                            OHCU.ResetInvoiceStatus(ILERec);
                        until ILERec.next = 0;
                    if ILERec.Count > 0 then
                        Message('Invoice Entries have been reset, please reinvoice again.');
                end;
            }
        }
    }
}
