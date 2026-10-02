pageextension 50003 CompanyInfoExt extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter(Picture)
        {
            group("Hyphens Setup")
            {
                field("Enable Peg Rate Module"; Rec."Enable Peg Rate Module")
                {
                    ApplicationArea = All;
                }

                field("Enable Purch. Req. Template"; Rec."Enable Purch. Req. Template")
                {
                    ApplicationArea = All;
                }

                field("Exch. Var. Settlement Account"; Rec."Exch. Var. Settlement Account")
                {
                    ApplicationArea = All;
                }

                // YF 07 Dec 2021
                field("Trade Sales Adjustment Account"; Rec."Trade Sales Adjustment Account")
                {
                    ApplicationArea = All;
                }

                field("Exch. Adj. Gen. Jnl Batch"; Rec."Exch. Adj. Gen. Jnl Batch")
                {
                    ApplicationArea = All;
                }
                // YF 07 Dec 2021

                // YF 08 Dec 2021
                field("Payment Bank 1"; Rec."Payment Bank 1")
                {
                    ApplicationArea = All;
                }

                field("Payment Bank 2"; Rec."Payment Bank 2")
                {
                    ApplicationArea = All;
                }

                field("Payment Bank 3"; Rec."Payment Bank 3")
                {
                    ApplicationArea = All;
                }
                // YF 08 Dec 2021
            }
        }
    }
}