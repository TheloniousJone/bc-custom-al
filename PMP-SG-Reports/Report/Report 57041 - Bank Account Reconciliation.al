report 57041 "Bank Account Reconciliation"
{
    // version NAVAPAC13.00

    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57041 - Bank Account Reconciliation.rdl';
    Caption = 'Reconciliation';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            CalcFields = "Balance at Date";
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", "Bank Acc. Posting Group", "Date Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PAGENO)
            // {
            // }
            column(USERID; USERID)
            {
            }
            column(Bank_Account__TABLENAME__________BankAccFilter; "Bank Account".TABLENAME + ': ' + BankAccFilter)
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DISPLAYNAME)
            {
            }
            column(Bank_Account__No__; "No.")
            {
            }
            column(Bank_Account__Balance_at_Date_; "Balance at Date")
            {
            }
            column(Bank_Account_Name; Name)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(Bank_Account_Date_Filter; "Date Filter")
            {
            }
            column(Bank_ReconciliationCaption; Bank_ReconciliationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bank_Account__Balance_at_Date_Caption; Bank_Account__Balance_at_Date_CaptionLbl)
            {
            }
            dataitem("Bank Account Ledger Entry1"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Bank Account No.", "Document No.", "Posting Date", Open)
                                    WHERE(Open = CONST(true),
                                          Amount = FILTER(< 0),
                                          Reversed = CONST(false));
                column(V1_Amount; -1 * Amount)
                {
                }
                column(Bank_Account_Ledger_Entry1__Document_No__; "Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry1__Posting_Date_; FORMAT("Posting Date"))
                {
                }
                column(Bank_Account_Ledger_Entry1_Description; Description)
                {
                }
                column(V1_Amount_Control1500017; -1 * Amount)
                {
                }
                column(V1_Amount_Control1500019; -1 * Amount)
                {
                }
                column(Total1; Total1)
                {
                }
                column(Bank_Account_Ledger_Entry1_Entry_No_; "Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry1_Bank_Account_No_; "Bank Account No.")
                {
                }
                column(Bank_Account_Ledger_Entry1_Posting_Date; "Posting Date")
                {
                }
                column(Plus_unpresented_cheques_Caption; Plus_unpresented_cheques_CaptionLbl)
                {
                }
                column(ContinuedCaption; ContinuedCaptionLbl)
                {
                }
                column(ContinuedCaption_Control1500018; ContinuedCaption_Control1500018Lbl)
                {
                }
                column(Total1Caption; Total1CaptionLbl)
                {
                }
                column(ExtDocNoBank1; "External Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Total1 := -1 * Amount + Total1;
                end;

                trigger OnPreDataItem()
                begin
                    CLEAR(Total1);
                end;
            }
            dataitem("Bank Account Ledger Entry2"; 271)
            {
                DataItemLink = "Bank Account No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Bank Account No.", "Document No.", "Posting Date", Open)
                                    WHERE(Open = CONST(true),
                                          Amount = FILTER(> 0),
                                          Reversed = CONST(false));
                column(Bank_Account_Ledger_Entry2_Amount; Amount)
                {
                }
                column(Bank_Account_Ledger_Entry2_Description; Description)
                {
                }
                column(Bank_Account_Ledger_Entry2__Posting_Date_; FORMAT("Posting Date"))
                {
                }
                column(Bank_Account_Ledger_Entry2__Document_No__; "Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry2_Amount_Control1500028; Amount)
                {
                }
                column(Bank_Account_Ledger_Entry2_Amount_Control1500030; Amount)
                {
                }
                column(Total2; Total2)
                {
                }
                column(Bank_Account_Ledger_Entry2_Entry_No_; "Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry2_Bank_Account_No_; "Bank Account No.")
                {
                }
                column(Bank_Account_Ledger_Entry2_Posting_Date; "Posting Date")
                {
                }
                column(Less_outstanding_deposits_Caption; Less_outstanding_deposits_CaptionLbl)
                {
                }
                column(ContinuedCaption_Control1500023; ContinuedCaption_Control1500023Lbl)
                {
                }
                column(ContinuedCaption_Control1500029; ContinuedCaption_Control1500029Lbl)
                {
                }
                column(Total2Caption; Total2CaptionLbl)
                {
                }
                column(ExtDocNoBank2; "External Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Total2 := Amount + Total2;
                end;

                trigger OnPreDataItem()
                begin
                    CLEAR(Total2);
                end;
            }
            dataitem(FooterLoop; 2000000026)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1));
                MaxIteration = 1;
                column(Bank_Account___Balance_at_Date____Total1___Total2; "Bank Account"."Balance at Date" + Total1 - Total2)
                {
                }
                column(FooterLoop_Number; Number)
                {
                }
                column(Bank_Account___Balance_at_Date____Total1___Total2Caption; Bank_Account___Balance_at_Date____Total1___Total2CaptionLbl)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                //// CurrReport.PRINTONLYIFDETAIL := TRUE;

                // Add PageGroupNo.Begin,COMMENTS
                IF PrintOnlyOnePerPage THEN
                    PageGroupNo := PageGroupNo + 1;
                // Add PageGroupNo.End
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPagePerBankAccount; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Bank Account';
                        ToolTip = 'Specifies if information about each bank account is printed on a new page.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        BankAccFilter := "Bank Account".GETFILTERS;
    end;

    var
        PrintOnlyOnePerPage: Boolean;
        BankAccFilter: Text[250];
        Total1: Decimal;
        Total2: Decimal;
        PageGroupNo: Integer;
        Bank_ReconciliationCaptionLbl: Label 'Bank Reconciliation';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Bank_Account__Balance_at_Date_CaptionLbl: Label 'Balance As Per General Ledger';
        Plus_unpresented_cheques_CaptionLbl: Label 'Plus unpresented cheques:';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption_Control1500018Lbl: Label 'Continued';
        Total1CaptionLbl: Label 'Total';
        Less_outstanding_deposits_CaptionLbl: Label 'Less outstanding deposits:';
        ContinuedCaption_Control1500023Lbl: Label 'Continued';
        ContinuedCaption_Control1500029Lbl: Label 'Continued';
        Total2CaptionLbl: Label 'Total';
        Bank_Account___Balance_at_Date____Total1___Total2CaptionLbl: Label 'Balance As Per Bank Statement';
}

