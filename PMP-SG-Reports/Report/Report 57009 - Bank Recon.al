report 57009 "Bank Account Recon Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57009 - Bank Recon.rdl';
    Caption = 'Bank Account Statement';

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            DataItemTableView = SORTING("Bank Account No.", "Statement No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Bank Account No.", "Statement No.";
            column(ComanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(BankAccStmtTableCaptFltr; TableCaption + ': ' + BankAccStmtFilter)
            {
            }
            column(BankAccStmtFilter; BankAccStmtFilter)
            {
            }
            column(StmtNo_BankAccStmt; "Statement No.")
            {
                IncludeCaption = true;
            }
            column(Amt_BankAccStmtLineStmt; '"Bank Account Statement Line"."Statement Amount"')
            {
            }
            column(AppliedAmt_BankAccStmtLine; '"Bank Account Statement Line"."Applied Amount"')
            {
            }
            column(BankAccNo_BankAccStmt; "Bank Account No.")
            {
            }
            column(BankAccStmtCapt; BankAccStmtCaptLbl)
            {
            }
            column(CurrReportPAGENOCapt; CurrReportPAGENOCaptLbl)
            {
            }
            column(BnkAccStmtLinTrstnDteCapt; BnkAccStmtLinTrstnDteCaptLbl)
            {
            }
            column(BnkAcStmtLinValDteCapt; BnkAcStmtLinValDteCaptLbl)
            {
            }
            column(Statement_Date; "Statement Date") { }
            column(Statement_No_; "Statement No.") { }
            column(BankName; BankName) { }
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                DataItemTableView = SORTING("Bank Account No.", "Statement No.", "Statement Line No.");
                column(TrnsctnDte_BnkAcStmtLin; Format("Transaction Date"))
                {
                }
                // column(Type_BankAccStmtLine; Type)
                // {
                //     IncludeCaption = true;
                // }
                column(LineDocNo_BankAccStmt; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(AppliedEntr_BankAccStmtLine; "Applied Entries")
                {
                    IncludeCaption = true;
                }
                column(Amt1_BankAccStmtLineStmt; "Statement Amount")
                {
                    IncludeCaption = true;
                }
                column(AppliedAmt1_BankAccStmtLine; "Applied Amount")
                {
                    IncludeCaption = true;
                }
                column(Desc_BankAccStmtLine; Description)
                {
                    IncludeCaption = true;
                }
                column(ValueDate_BankAccStmtLine; Format("Value Date"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(BankName);
                grec_Bank.Reset();
                grec_Bank.SetRange("No.", "Bank Account No.");
                if grec_Bank.FindFirst() then begin
                    BankName := grec_Bank.Name;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        TotalCaption = 'Total';
    }

    trigger OnPreReport()
    begin
        // BankAccStmtFilter := "Bank Account Statement".GetFilters;
        BankAccStmtFilter := "Bank Acc. Reconciliation".GetFilters;
    end;

    var
        BankAccStmtFilter: Text;
        BankAccStmtCaptLbl: Label 'Bank Account Statement';
        CurrReportPAGENOCaptLbl: Label 'Page';
        BnkAccStmtLinTrstnDteCaptLbl: Label 'Transaction Date';
        BnkAcStmtLinValDteCaptLbl: Label 'Value Date';
        grec_Bank: Record "Bank Account";
        BankName: Text;
}

