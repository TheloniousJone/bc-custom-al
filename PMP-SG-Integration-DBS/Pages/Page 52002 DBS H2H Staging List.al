page 52002 "DBS H2H Staging List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "DBS Host2Host Staging";
    Caption = 'DBS Host to Host Staging List';
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

                // Header
                field("Header Record Type"; Rec."Header Record Type")
                {
                    ApplicationArea = All;
                }

                field("Header File Creation Date"; Rec."Header File Creation Date")
                {
                    ApplicationArea = All;
                }

                field("Header Org ID"; Rec."Header Org ID")
                {
                    ApplicationArea = All;
                }

                field("Header Sender Name"; Rec."Header Sender Name")
                {
                    ApplicationArea = All;
                }
                // Header

                // Detail
                field("Detail Record Type"; Rec."Detail Record Type")
                {
                    ApplicationArea = All;
                }

                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }

                field("Orig. Account No."; Rec."Orig. Account No.")
                {
                    ApplicationArea = All;
                }

                field("Orig. Account Currency"; Rec."Orig. Account Currency")
                {
                    ApplicationArea = All;
                }

                field("Cust. Batch Reference"; Rec."Cust. Batch Reference")
                {
                    ApplicationArea = All;
                }

                field("Payment Currency"; Rec."Payment Currency")
                {
                    ApplicationArea = All;
                }

                field("Base Batch ID"; Rec."Base Batch ID")
                {
                    ApplicationArea = All;
                }

                field("Batch ID"; Rec."Batch ID")
                {
                    ApplicationArea = All;
                }

                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                }

                field("Bank Charges"; Rec."Bank Charges")
                {
                    ApplicationArea = All;
                }

                field("Debit Acct for Bank Charges"; Rec."Debit Acct for Bank Charges")
                {
                    ApplicationArea = All;
                }

                field("Receiving Party Name"; Rec."Receiving Party Name")
                {
                    ApplicationArea = All;
                }

                field("Payable To"; Rec."Payable To")
                {
                    ApplicationArea = All;
                }

                field("Recv Party Address 1"; Rec."Recv Party Address 1")
                {
                    ApplicationArea = All;
                }

                field("Recv Party Address 2"; Rec."Recv Party Address 2")
                {
                    ApplicationArea = All;
                }

                field("Recv Party Address 3"; Rec."Recv Party Address 3")
                {
                    ApplicationArea = All;
                }

                field("Recv Acct No. IBAN"; Rec."Recv Acct No. IBAN")
                {
                    ApplicationArea = All;
                }

                field("Country Specific"; Rec."Country Specific")
                {
                    ApplicationArea = All;
                }

                field("Receiving Bank Code"; Rec."Receiving Bank Code")
                {
                    ApplicationArea = All;
                }

                field("Receiving Branch Code"; Rec."Receiving Branch Code")
                {
                    ApplicationArea = All;
                }

                field("Clearing Code"; Rec."Clearing Code")
                {
                    ApplicationArea = All;
                }

                field("Bene Bank SWIFT BIC"; Rec."Bene Bank SWIFT BIC")
                {
                    ApplicationArea = All;
                }

                field("Bene Bank Name"; Rec."Bene Bank Name")
                {
                    ApplicationArea = All;
                }

                field("Bene Bank Address"; Rec."Bene Bank Address")
                {
                    ApplicationArea = All;
                }

                field("Bene Bank Country"; Rec."Bene Bank Country")
                {
                    ApplicationArea = All;
                }

                field("Routing Code"; Rec."Routing Code")
                {
                    ApplicationArea = All;
                }

                field("Intermed. Bank SWIFT BIC"; Rec."Intermed. Bank SWIFT BIC")
                {
                    ApplicationArea = All;
                }

                field("Amount Currency"; Rec."Amount Currency")
                {
                    ApplicationArea = All;
                }

                field("Amount Value"; Rec."Amount Value")
                {
                    ApplicationArea = All;
                }

                field("Amount Text"; Rec."Amount Text")
                {
                    ApplicationArea = All;
                }

                field("FX Contract Reference 1"; Rec."FX Contract Reference 1")
                {
                    ApplicationArea = All;
                }

                field("Amount to Use for FX 1"; Rec."Amount to Use for FX 1")
                {
                    ApplicationArea = All;
                }

                field("Amt to Use for FX 1 Text"; Rec."Amt to Use for FX 1 Text")
                {
                    ApplicationArea = All;
                }

                field("FX Contract Reference 2"; Rec."FX Contract Reference 2")
                {
                    ApplicationArea = All;
                }

                field("Amount to Use for FX 2"; Rec."Amount to Use for FX 2")
                {
                    ApplicationArea = All;
                }

                field("Amt to Use for FX 2 Text"; Rec."Amt to Use for FX 2 Text")
                {
                    ApplicationArea = All;
                }

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }

                field("Payer Bene Particulars"; Rec."Payer Bene Particulars")
                {
                    ApplicationArea = All;
                }

                field(DDA; Rec.DDA)
                {
                    ApplicationArea = All;
                }

                field("Payment Details"; Rec."Payment Details")
                {
                    ApplicationArea = All;
                }

                field("Instruction to Order Bank"; Rec."Instruction to Order Bank")
                {
                    ApplicationArea = All;
                }

                field("Bene Resident Status"; Rec."Bene Resident Status")
                {
                    ApplicationArea = All;
                }

                field("Beneficiary Category"; Rec."Beneficiary Category")
                {
                    ApplicationArea = All;
                }

                field("Transaction Relationship"; Rec."Transaction Relationship")
                {
                    ApplicationArea = All;
                }

                field("Payee Role"; Rec."Payee Role")
                {
                    ApplicationArea = All;
                }

                field("Remitter Identity"; Rec."Remitter Identity")
                {
                    ApplicationArea = All;
                }

                field("Purpose of Payment"; Rec."Purpose of Payment")
                {
                    ApplicationArea = All;
                }

                field("Supplementary Info"; Rec."Supplementary Info")
                {
                    ApplicationArea = All;
                }

                field("Delivery Mode"; Rec."Delivery Mode")
                {
                    ApplicationArea = All;
                }

                field("Print or Pickup Location"; Rec."Print or Pickup Location")
                {
                    ApplicationArea = All;
                }

                field("Payable Location"; Rec."Payable Location")
                {
                    ApplicationArea = All;
                }

                field("Mail to Party Name"; Rec."Mail to Party Name")
                {
                    ApplicationArea = All;
                }

                field("Mail to Party Address 1"; Rec."Mail to Party Address 1")
                {
                    ApplicationArea = All;
                }

                field("Mail to Party Address 2"; Rec."Mail to Party Address 2")
                {
                    ApplicationArea = All;
                }

                field("Mail to Party Address 3"; Rec."Mail to Party Address 3")
                {
                    ApplicationArea = All;
                }

                field("Reserved Field"; Rec."Reserved Field")
                {
                    ApplicationArea = All;
                }

                field("Mail to Party Postal Code"; Rec."Mail to Party Postal Code")
                {
                    ApplicationArea = All;
                }

                field("Email 1"; Rec."Email 1")
                {
                    ApplicationArea = All;
                }

                field("Email 2"; Rec."Email 2")
                {
                    ApplicationArea = All;
                }

                field("Email 3"; Rec."Email 3")
                {
                    ApplicationArea = All;
                }

                field("Email 4"; Rec."Email 4")
                {
                    ApplicationArea = All;
                }

                field("Email 5"; Rec."Email 5")
                {
                    ApplicationArea = All;
                }

                field("Phone Number 1"; Rec."Phone Number 1")
                {
                    ApplicationArea = All;
                }

                field("Phone Number 2"; Rec."Phone Number 2")
                {
                    ApplicationArea = All;
                }

                field("Phone Number 3"; Rec."Phone Number 3")
                {
                    ApplicationArea = All;
                }

                field("Phone Number 4"; Rec."Phone Number 4")
                {
                    ApplicationArea = All;
                }

                field("Phone Number 5"; Rec."Phone Number 5")
                {
                    ApplicationArea = All;
                }

                field("Invoice Details"; Rec."Invoice Details")
                {
                    ApplicationArea = All;
                }

                field("Client Reference 1"; Rec."Client Reference 1")
                {
                    ApplicationArea = All;
                }

                field("Client Reference 2"; Rec."Client Reference 2")
                {
                    ApplicationArea = All;
                }

                field("Client Reference 3"; Rec."Client Reference 3")
                {
                    ApplicationArea = All;
                }

                field("Client Reference 4"; Rec."Client Reference 4")
                {
                    ApplicationArea = All;
                }
                // Detail

                // Trailer
                field("Trailer Record Type"; Rec."Trailer Record Type")
                {
                    ApplicationArea = All;
                }

                field("Total No. of Transactions"; Rec."Total No. of Transactions")
                {
                    ApplicationArea = All;
                }

                field("Total Transaction Amount"; Rec."Total Transaction Amount")
                {
                    ApplicationArea = All;
                }

                field("Total Transaction Amount Text"; Rec."Total Transaction Amount Text")
                {
                    ApplicationArea = All;
                }
                // Trailer

                // System Administration
                field(Validated; Rec.Validated)
                {
                    ApplicationArea = All;
                }

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }

                field("Date Created Timestamp"; Rec."Date Created Timestamp")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Exported; Rec.Exported)
                {
                    ApplicationArea = All;
                }
                // System Administration

                // Source Journal Tracking
                field("Src Jnl Template Name"; Rec."Src Jnl Template Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Src Jnl Batch Name"; Rec."Src Jnl Batch Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Src Jnl Line No."; Rec."Src Jnl Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // Source Journal Tracking

            }
        }

    }

    // Generate CSV Files
    // Select Unique Originating Account, Payment Currency, Batch ID, Value Date from Dialog to generate CSV File
    // Provide basic options for now due to resource contraints
    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Create Export File")
                {
                    ApplicationArea = all;
                    Caption = 'Create Export File';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Export;
                    PromotedCategory = Process;
                    ToolTip = 'Create Export file based on filters from current selected record';
                    Visible = false; // YF 07 Jan 2022 Disabled for now - Incomplete

                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "DBS Host to Host Codeunit";
                    begin
                        Clear(IntegrationCU);
                        IntegrationCU.GenerateExportFileBasic(Rec);
                        CurrPage.Update(false);
                    end;
                }

                // YF 15 Mar 2022
                action("Archive Staging Records Job Queue")
                {
                    ApplicationArea = all;
                    Caption = 'Archive Staging Records Job Queue';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Archive;
                    PromotedCategory = Process;
                    // RunObject = report 69000;

                    trigger OnAction()
                    var
                        StagingRec: Record "DBS Host2Host Staging";
                        SyncReport: Report "DBS Archive H2H Staging";
                    begin
                        CurrPage.SetSelectionFilter(StagingRec);
                        SyncReport.SetTableView(StagingRec);
                        SyncReport.Run();
                        CurrPage.Update(false);
                        Message('Run completed');
                    end;
                }
                // YF 15 Mar 2022            

            }

        }

    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Entry No.");
        Rec.Ascending(false);
        if Rec.FindFirst() then begin end;
    end;


}
