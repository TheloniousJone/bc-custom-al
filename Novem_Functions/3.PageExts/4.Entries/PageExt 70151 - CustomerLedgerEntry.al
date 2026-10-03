pageextension 70151 CustomerLedgerEntryPageExt extends "Customer Ledger Entries"
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
            action(CustomerOutgoingPaymentVoucher)
            {
                Caption = 'Outgoing Payment Voucher';
                Image = PaymentJournal;
                ApplicationArea = All;
                Enabled = Rec."Document Type" = Rec."Document Type"::Payment;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    CustLedgerEntryRec: Record "Cust. Ledger Entry";
                    CustomerOutgoingPaymentVoucherReport: Report I9G_CustomerPaymentVoucher;
                begin
                    CustLedgerEntryRec.Reset();
                    CustLedgerEntryRec.SetRange("Customer No.", Rec."Customer No.");
                    CustLedgerEntryRec.SetRange("Document No.", Rec."Document No.");
                    CustLedgerEntryRec.SetRange("Posting Date", Rec."Posting Date");
                    CustomerOutgoingPaymentVoucherReport.SetTableView(CustLedgerEntryRec);
                    CustomerOutgoingPaymentVoucherReport.Run();
                end;
            }
        }
        addafter(ReverseTransaction_Promoted)
        {
            actionref(CustomerOutgoingPaymentVoucher_Promoted; CustomerOutgoingPaymentVoucher) { }
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