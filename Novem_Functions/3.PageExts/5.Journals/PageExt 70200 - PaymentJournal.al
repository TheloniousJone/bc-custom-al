pageextension 70200 PaymentJournalWorksheetExt extends "Payment Journal"
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
            action(OutgoingPaymentVoucher)
            {
                Caption = 'Outgoing Payment Voucher';
                Image = PaymentJournal;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    GenJournalLineRec: Record "Gen. Journal Line";
                    OutgoingPaymentVoucherReport: Report I9G_OutgoingPaymentVoucher;
                begin
                    GenJournalLineRec.Reset();
                    GenJournalLineRec.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLineRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLineRec.SetRange("Posting Date", Rec."Posting Date");
                    GenJournalLineRec.SetRange("Document No.", Rec."Document No.");
                    GenJournalLineRec.SetRange("Account Type", Rec."Account Type");
                    GenJournalLineRec.SetRange("Account No.", Rec."Account No.");
                    if Rec."Applies-to ID" <> '' then begin
                        OutgoingPaymentVoucherReport.GetReportFilter(true);
                    end else begin
                        OutgoingPaymentVoucherReport.GetReportFilter(false);
                    end;
                    OutgoingPaymentVoucherReport.SetTableView(GenJournalLineRec);
                    OutgoingPaymentVoucherReport.Run();
                end;
            }
        }
        addafter(Reconcile_Promoted)
        {
            actionref(OutgoingPaymentVoucher_Promoted; OutgoingPaymentVoucher) { }
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