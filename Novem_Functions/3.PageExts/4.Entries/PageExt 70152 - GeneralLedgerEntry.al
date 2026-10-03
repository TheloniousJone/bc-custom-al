pageextension 70152 GeneralLedgerEntryPageExt extends "General Ledger Entries"
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
            action(PaymentVoucher)
            {
                Caption = 'Payment Voucher';
                Image = PostedPayment;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    GLEntryRec: Record "G/L Entry";
                    PaymentVoucherReport: Report I9G_PaymentVoucher;
                begin
                    GLEntryRec.Reset();
                    GLEntryRec.SetRange("Document No.", Rec."Document No.");
                    GLEntryRec.SetRange("Posting Date", Rec."Posting Date");
                    PaymentVoucherReport.SetTableView(GLEntryRec);
                    PaymentVoucherReport.Run();
                end;
            }
            action(IncomingPaymentListing)
            {
                Caption = 'Incoming Payment Listing';
                Image = Report;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    GLEntryRec: Record "G/L Entry";
                begin
                    Report.Run(70039, true, false, GLEntryRec);
                end;
            }
        }
        addafter(Dimensions)
        {
            action(ImportDimensions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Dimensions';
                Image = MapDimensions;
                ToolTip = 'Update dimension values for current records.';
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    I9G_ImportDimensionsCodeUnit: Codeunit I9G_ImportDimensionsGLE;
                begin
                    I9G_ImportDimensionsCodeUnit.ImportExcel();
                end;
            }
        }

        addafter(ReverseTransaction_Promoted)
        {
            actionref(PaymentVoucher_Promoted; PaymentVoucher) { }
            actionref(IncomingPaymentListing_Promoted; IncomingPaymentListing) { }
            actionref(ImportDimensions_Promoted; ImportDimensions) { }
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