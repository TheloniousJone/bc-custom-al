pageextension 70202 PostedGenJournal extends "Posted General Journal"
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
        addafter(Approvals)
        {
            action(IncomingPaymentVoucher)
            {
                Caption = 'Incoming Payment Voucher';
                Image = CashReceiptJournal;
                ApplicationArea = All;
                PromotedCategory = Report;
                Promoted = true;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    GenJournalLineRec: Record "Posted Gen. Journal Line";
                    IncomingPaymentVoucherReport: Report I9G_CustPaymentVoucherPostedGJ;
                begin
                    GenJournalLineRec.Reset();
                    GenJournalLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLineRec.SetRange("Posting Date", Rec."Posting Date");
                    GenJournalLineRec.SetRange("Document No.", Rec."Document No.");
                    GenJournalLineRec.SetRange("Account Type", Rec."Account Type");
                    GenJournalLineRec.SetRange("Account No.", Rec."Account No.");
                    GenJournalLineRec.SetRange("Line No.", Rec."Line No.");
                    if Rec."Applies-to ID" <> '' then begin
                        IncomingPaymentVoucherReport.GetReportFilter(true);
                    end else begin
                        IncomingPaymentVoucherReport.GetReportFilter(false);
                    end;
                    IncomingPaymentVoucherReport.SetTableView(GenJournalLineRec);
                    IncomingPaymentVoucherReport.Run();
                end;
            }
            action(OutcomingPaymentVoucher)
            {
                Caption = 'Out Payment Voucher';
                Image = CashReceiptJournal;
                ApplicationArea = All;
                PromotedCategory = Report;
                Promoted = true;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    GenJournalLineRec: Record "Posted Gen. Journal Line";
                    IncomingaymentVoucherReport: Report I9G_VendPaymentVoucherPostedGJ;
                begin
                    GenJournalLineRec.Reset();
                    GenJournalLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLineRec.SetRange("Posting Date", Rec."Posting Date");
                    GenJournalLineRec.SetRange("Document No.", Rec."Document No.");
                    GenJournalLineRec.SetRange("Account Type", Rec."Account Type");
                    GenJournalLineRec.SetRange("Account No.", Rec."Account No.");
                    GenJournalLineRec.SetRange("Line No.", Rec."Line No.");
                    if Rec."Applies-to ID" <> '' then begin
                        IncomingaymentVoucherReport.GetReportFilter(true);
                    end else begin
                        IncomingaymentVoucherReport.GetReportFilter(false);
                    end;
                    IncomingaymentVoucherReport.SetTableView(GenJournalLineRec);
                    IncomingaymentVoucherReport.Run();
                end;
            }
            action(PaymentVoucher)
            {
                Caption = 'Payment Voucher';
                Image = PostedPayment;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                PromotedCategory = Report;
                Promoted = true;
                trigger OnAction()
                var
                    GLEntryRec: Record "Posted Gen. Journal Line";
                    PaymentVoucherReport: Report I9G_PaymentVoucherPostedGJ;
                begin
                    GLEntryRec.Reset();
                    GLEntryRec.SetRange("Document No.", Rec."Document No.");
                    GLEntryRec.SetRange("Posting Date", Rec."Posting Date");
                    PaymentVoucherReport.SetTableView(GLEntryRec);
                    PaymentVoucherReport.Run();
                end;
            }
            action(Print)
            {
                Caption = 'Print...';
                Image = Print;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                PromotedCategory = Report;
                Promoted = true;

                trigger OnAction()
                var
                    lrec_PGJL: Record "Posted Gen. Journal Line";
                begin
                    lrec_PGJL.Reset();
                    lrec_PGJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                    lrec_PGJL.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    lrec_PGJL.SetRange("Document No.", Rec."Document No.");
                    if lrec_PGJL.FindSet() then begin
                        Report.RunModal(70062, true, false, lrec_PGJL);
                    end;
                end;
            }

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