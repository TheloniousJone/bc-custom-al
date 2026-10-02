pageextension 50013 HyphensCustLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Peg Rate"; Rec."Peg Rate")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("VND Amount"; Rec."VND Amount")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("VND-LCY Rate"; Rec."VND-LCY Rate")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("Peg SGD Amount"; Rec."Peg SGD Amount")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("FCY-LCY Rate"; Rec."FCY-LCY Rate")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("LCY Amount"; Rec."LCY Amount")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field(Adjustment; Rec.Adjustment)
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            // YF 09 Dec 2021
            field("VND Paid Rate"; Rec."VND Paid Rate")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }

            field("Paid VND"; Rec."Paid VND")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = ShowPegFeature;
            }
            // YF 09 Dec 2021
        }
    }

    actions
    {
        addafter("Apply Entries")
        {
            action("CLE Peg List")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CLERec: Record "Cust. Ledger Entry";
                begin
                    // CurrPage.SetSelectionFilter(CLERec);
                    // report.Run(211, true, true, CLERec);
                    Report.Run(50014);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;
        ShowPegFeature := CompanyInfoRec."Enable Peg Rate Module";
    end;

    var
        ShowPegFeature: Boolean;
}
