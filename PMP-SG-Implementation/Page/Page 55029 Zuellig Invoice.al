page 55029 "Zuellig Invoices"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Zuellig Invoices";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Invoice Created"; Rec."Invoice Created")
                {
                    ApplicationArea = All;

                }
                field("BC Doc No."; Rec."BC Invoice No.")
                {
                    ApplicationArea = all;
                    Caption = 'BC Document No.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = All;
                }
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                }
                field("Recorded Date"; Rec."Recorded Date")
                {
                    ApplicationArea = All;
                }
                field("New Customer No."; Rec."New Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Type 2"; Rec."Type 2")
                {
                    ApplicationArea = All;
                }
                field("New Item No."; Rec."New Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;

                }
                field("Trans Qty"; Rec."Trans Qty")
                {
                    ApplicationArea = All;

                }
                field("Selling Price"; Rec."Selling Price")
                {
                    ApplicationArea = All;

                }
                field("Trans Value"; Rec."Trans Value")
                {
                    ApplicationArea = All;

                }
                field(SP; Rec.SP)
                {
                    ApplicationArea = All;

                }
                field(Detailman; Rec.Detailman)
                {
                    ApplicationArea = All;

                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;

                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;

                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = All;

                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;

                }
                field("Lot Expiry Date"; Rec."Lot Expiry Date")
                {
                    ApplicationArea = All;

                }
                field("Reason For Return"; Rec."Reason For Return")
                {
                    ApplicationArea = All;

                }
                field("Business Division 4"; Rec."Business Division 4")
                {
                    ApplicationArea = All;

                }
                field("Business Division 5"; Rec."Business Division 5")
                {
                    ApplicationArea = All;

                }
                field(Distributor; Rec.Distributor)
                {
                    ApplicationArea = All;

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import")
            {
                ApplicationArea = All;
                Caption = 'Import';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TestDatabase;
                InFooterBar = true;
                trigger OnAction()
                var
                    PMPCU: Codeunit "PMP Integrations";
                begin
                    PMPCU.ImportZLInvoices();
                    // if UploadIntoStream('Please choose your excel file', '', '', Filename, Ins) then begin
                end;
            }

            /*
            // YF 25 Oct 2021 // Shift to ZP Extension
            action("Create")
            {
                ApplicationArea = All;
                Caption = 'Create Documents';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocuments;
                InFooterBar = true;
                trigger OnAction()
                var
                    PMPCU: Codeunit "PMP Integrations";
                begin
                    if Confirm('Are you sure you wish to create documents from Zuelig Invoices?') then begin
                        Message('%1 Transactions created', PMPCU.CreateDocuments());
                    end;
                    // if UploadIntoStream('Please choose your excel file', '', '', Filename, Ins) then begin
                end;
            }
            // YF 25 Oct 2021 // Shift to ZP Extension
            */
        }
    }
}