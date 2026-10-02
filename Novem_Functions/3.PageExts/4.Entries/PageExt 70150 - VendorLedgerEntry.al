pageextension 70150 VendorLedgerEntryPageExt extends "Vendor Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = false;
                ToolTip = 'Specifies the value of the Remarks field.';
            }
            field(I9G_ChequeDetails; Rec.I9G_ChequeDetails)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = false;
                ToolTip = 'Specifies the value of the Cheque Details field.';
            }
        }
    }
    actions
    {
        addafter(ReverseTransaction)
        {
            action(VendorOutgoingPaymentVoucher)
            {
                Caption = 'Outgoing Payment Voucher';
                Image = PaymentJournal;
                ApplicationArea = All;
                Enabled = Rec."Document Type" = Rec."Document Type"::Payment;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    VendorLedgerEntryRec: Record "Vendor Ledger Entry";
                    VendorOutgoingPaymentVoucherReport: Report I9G_VendorPaymentVoucher;
                begin
                    VendorLedgerEntryRec.Reset();
                    VendorLedgerEntryRec.SetRange("Vendor No.", Rec."Vendor No.");
                    VendorLedgerEntryRec.SetRange("Document No.", Rec."Document No.");
                    VendorLedgerEntryRec.SetRange("Posting Date", Rec."Posting Date");
                    VendorOutgoingPaymentVoucherReport.SetTableView(VendorLedgerEntryRec);
                    VendorOutgoingPaymentVoucherReport.Run();
                end;
            }
        }
        addafter(ReverseTransaction_Promoted)
        {
            actionref(VendorOutgoingPaymentVoucher_Promoted; VendorOutgoingPaymentVoucher) { }
        }
    }
    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}