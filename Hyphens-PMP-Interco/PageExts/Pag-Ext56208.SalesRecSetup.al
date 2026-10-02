pageextension 56208 "Sales&RecSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Def. ZP Invoice Loc. Code")
        {
            field("Def. OH Item Gen Prod"; Rec."Def. OH Item Gen Prod")
            {
                ApplicationArea = all;
                ToolTip = 'Select for the default filtering of OH items in PMP';
            }
            field("Default PMP Customer Code"; Rec."Default PMP Customer Code")
            {
                ApplicationArea = all;
                TableRelation = Customer."No.";
                Caption = 'Default PMP Customer code';
            }
            field("Default OH Vendor Code"; Rec."Default OH Vendor Code")
            {
                ApplicationArea = all;
                TableRelation = Vendor."No.";
            }
            field("Def PMP WH Location"; Rec."Def PMP WH Location")
            {
                ApplicationArea = all;
                TableRelation = Location.Code;
            }
            field("Def PMP Clearing Account"; Rec."Def PMP Clearing Account")
            {
                ApplicationArea = all;
                TableRelation = "G/L Account"."No.";
            }
        }
    }

}
