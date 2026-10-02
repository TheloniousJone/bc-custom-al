tableextension 50003 CompanyInfoExt extends "Company Information"
{
    fields
    {
        field(50000; "Enable Peg Rate Module"; Boolean)
        {
            Caption = 'Enable Peg Rate Module';
        }

        field(50001; "Enable Purch. Req. Template"; Boolean)
        {
            Caption = 'Enable Purchase Requirement Template';
        }

        field(50002; "Exch. Var. Settlement Account"; Code[20])
        {
            Caption = 'Exchange Variable Settlement Account';
            TableRelation = "G/L Account"."No.";
            // Default G/L Account = 22500
        }

        // YF 07 Dec 2021
        field(50003; "Trade Sales Adjustment Account"; Code[20])
        {
            Caption = 'Trade Sales Adjustment Account';
            TableRelation = "G/L Account"."No.";
        }

        field(50004; "Exch. Adj. Gen. Jnl Batch"; Code[10])
        {
            Caption = 'Exch. Adj. General Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = const('GENERAL'));
        }
        // YF 07 Dec 2021

        // YF 08 Dec 2021
        field(50005; "Payment Bank 1"; Code[20])
        {
            Caption = 'Payment Bank 1';
            TableRelation = "Bank Account"."No.";
        }

        field(50006; "Payment Bank 2"; Code[20])
        {
            Caption = 'Payment Bank 2';
            TableRelation = "Bank Account"."No.";
        }

        field(50007; "Payment Bank 3"; Code[20])
        {
            Caption = 'Payment Bank 3';
            TableRelation = "Bank Account"."No.";
        }
        // YF 08 Dec 2021
    }
}