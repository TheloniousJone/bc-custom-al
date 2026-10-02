pageextension 55027 "Cust Sell-To Factbox PageExt" extends "Sales Hist. Sell-to FactBox"
{
    layout
    {


        addafter(Control23)
        {
            cuegroup(Sales)
            {
                Caption = 'TBA Information';
                field("No. Of TBA DOs"; Rec."No. Of TBA DOs")
                {
                    ApplicationArea = all;
                    // DrillDownPageId = "Posted Sales Invoices";
                    DrillDownPageId = "TBA Ledger Entry";
                }
                field("No. Of TBA Invoices"; Rec."No. Of TBA Invoices")
                {
                    ApplicationArea = all;
                    // DrillDownPageId = "TBA Ledger Entry";
                    DrillDownPageId = "Posted Sales Invoices";
                }
            }

        }
        addafter("No. of Pstd. Credit Memos")
        {

            field("TBA DOs"; Rec."No. Of TBA DOs")
            {
                ApplicationArea = all;
                DrillDownPageId = "Posted Sales Invoices";
            }
            field("TBA Invoices"; Rec."No. Of TBA Invoices")
            {
                ApplicationArea = all;
                DrillDownPageId = "TBA Ledger Entry";
            }


        }
    }
}