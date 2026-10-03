page 52000 "Dbs Incoming List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "DBS Incoming";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(msgID; Rec.msgID)
                {
                    ApplicationArea = all;
                    Caption = 'Message ID';
                }
                field(orgID; Rec.orgID)

                {
                    ApplicationArea = all;
                    Caption = 'Organisation ID';
                    ToolTip = 'DBS Organization ID';
                }
                field(timeStamp; Rec.DBS_timeStamp)
                {
                    ApplicationArea = all;
                    Caption = 'Time Stamp';
                    ToolTip = 'Date and time when incoming credit transaction is received.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = all;
                    Caption = 'Country';
                    ToolTip = 'DBS Country/Regionwhere the account is held';
                }

                field(txnType; Rec.txnType)
                {
                    ApplicationArea = all;
                    Caption = 'Transaction Type';
                }
                field("Customer Ref."; Rec."Customer Ref.")
                {
                    ApplicationArea = all;
                    Caption = 'Customer Reference';
                }
                field(txnRefID; Rec.txnRefID)
                {
                    ApplicationArea = all;
                    Caption = 'Transaction Ref. ID';
                    ToolTip = 'Unique Transaction Reference by the bank';
                }
                field(txnDate; Rec.txnDate)
                {
                    ApplicationArea = all;
                    Caption = 'Transaction Date';
                    ToolTip = 'Date when transaction is received';
                }
                field(valueDate; Rec.valueDate)
                {
                    ApplicationArea = all;
                    caption = 'Value Date';
                    ToolTip = 'Date when incoming credit transaction is received';
                }
                field("Recipient Name"; Rec."Recipient Name")
                {
                    ApplicationArea = all;
                    caption = 'Recipient Name';
                    ToolTip = 'Recipient Account Name';
                }
                field("Recipient Acct. No."; Rec."Recipient Acct. No.")
                {
                    ApplicationArea = all;
                    caption = 'Recipient Acct. No';
                }
                field(txnCcy; Rec.txnCcy)
                {
                    ApplicationArea = all;
                    caption = 'Transaction Currency';
                }
                field(txnAmt; Rec.txnAmt)
                {
                    ApplicationArea = all;
                    caption = 'Transaction Amount.';
                }
                field("Sender Name"; Rec."Sender Name")
                {
                    ApplicationArea = all;
                    caption = 'Sender Name.';
                    ToolTip = 'Name of sender party';
                }
                // YF 09 Dec 2021
                field("Sender Acct. No."; Rec."Sender Account No.")
                {
                    ApplicationArea = all;
                    caption = 'Sender Acct. No.';
                    ToolTip = 'Account number of sender';
                }
                /*
                field("Sender Acct. No."; Rec."Sender Acct. No.")
                {
                    ApplicationArea = all;
                    caption = 'Sender Acct. No.';
                    ToolTip = 'Account number of sender';
                }
                */
                // YF 09 Dec 2021
                field("Payment Details"; Rec."Payment Details")
                {
                    ApplicationArea = all;
                    Caption = 'Payment Details';
                }
                field("Additional Info."; Rec."Additional Info.")
                {
                    ApplicationArea = all;
                    Caption = 'Additional Info.';
                }
                field("Journals Created"; Rec."Journals Created")
                {
                    ApplicationArea = all;
                    Caption = 'Journals created.';
                    ToolTip = 'Journals have been created in BC';
                }

                // YF 19 Nov 2021 // Internal Status Fields
                field("Has Error"; Rec."Has Error")
                {
                    ApplicationArea = All;
                    Caption = 'Has Error';
                }

                field("Process Remark"; Rec."Process Remark")
                {
                    ApplicationArea = All;
                    Caption = 'Process Remark';
                }

                field("Entry Processed"; Rec."Entry Processed")
                {
                    ApplicationArea = All;
                    Caption = 'Entry Processed';
                }
                // YF 19 Nov 2021 // Internal Status Fields

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                // YF 19 Nov 2021 // Refactored
                action("Create Journal Lines")
                {
                    ApplicationArea = all;
                    Caption = 'Create Journal Lines';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Journal;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        StagingRec: Record "DBS Incoming";
                        IntegrationCU: Codeunit "DBS-Incoming Codeunit";
                    begin
                        CurrPage.SetSelectionFilter(StagingRec);

                        if StagingRec.FindSet() then
                            repeat
                                IntegrationCU.CreateCRJournal(StagingRec."Entry No.");
                            until StagingRec.Next() = 0;

                        Commit(); // YF 04 Apr 2022
                        CurrPage.Update(false);
                        Message('Run completed');
                    end;
                }

                action("Run Create Journal Job Queue")
                {
                    ApplicationArea = all;
                    Caption = ' Run Create Journal Job Queue';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Journal;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        StagingRec: Record "DBS Incoming";
                    begin
                        CurrPage.SetSelectionFilter(StagingRec);
                        Report.RunModal(52000, false, false, StagingRec);
                        Message('Run completed');
                    end;
                }
                // YF 19 Nov 2021 // Refactored

                action(ActionName) // to be retired by refactored version
                {
                    ApplicationArea = All;
                    Caption = 'Create Journal Record';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Task;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //CurrPage.SetSelectionFilter(Rec);
                        DBSCU.CreateCRJournal(Rec);
                        Message('Journal Created.');
                    end;
                }

            }

        }

    }

    var
        DBSCU: Codeunit 52000;
        DBSRec: Record "DBS Incoming";

}
