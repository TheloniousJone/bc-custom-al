pageextension 70201 CashReceiptJournalWorksheetExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter(Description)
        {
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Remarks field.';
            }
            field(I9G_ChequeDetails; Rec.I9G_ChequeDetails)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Cheque Details field.';
            }
            field(I9G_AccountDetails; Rec.I9G_AccountDetails)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }
    actions
    {
        addafter(Reconcile)
        {
            action(IncomingPaymentVoucher)
            {
                Caption = 'Incoming Payment Voucher';
                Image = CashReceiptJournal;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    GenJournalLineRec: Record "Gen. Journal Line";
                    IncomingaymentVoucherReport: Report I9G_IncomingPaymentVoucher;
                begin
                    GenJournalLineRec.Reset();
                    GenJournalLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLineRec.SetRange("Posting Date", Rec."Posting Date");
                    GenJournalLineRec.SetRange("Document No.", Rec."Document No.");
                    GenJournalLineRec.SetRange("Account Type", Rec."Account Type");
                    GenJournalLineRec.SetRange("Account No.", Rec."Account No.");
                    if Rec."Applies-to ID" <> '' then begin
                        IncomingaymentVoucherReport.GetReportFilter(true);
                    end else begin
                        IncomingaymentVoucherReport.GetReportFilter(false);
                    end;
                    IncomingaymentVoucherReport.SetTableView(GenJournalLineRec);
                    IncomingaymentVoucherReport.Run();
                end;
            }
        }
        addafter(Reconcile_Promoted)
        {
            actionref(IncomingPaymentVoucher_Promoted; IncomingPaymentVoucher) { }
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