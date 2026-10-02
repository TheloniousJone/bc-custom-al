pageextension 60101 WellawaySSSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Additional)
        {
            group(Wellaway)
            {
                field("Def. Patient No. Series"; Rec."Def. Patient No. Series")
                {
                    ApplicationArea = all;
                }
                field("Def Item. Journal Batch"; Rec."Def Item. Journal Batch")
                {
                    ApplicationArea = all;
                    ToolTip = 'Default Wellaway Item Journal Batch';
                }
                field("Def. Wellaway Inv. No. Series"; Rec."Def. Wellaway Inv. No. Series")
                {
                    ApplicationArea = all;
                    Caption = 'Default Wellaway Sales Invoice No. Series';
                    ToolTip = 'Select the no. series to generate sales invoices for Wellaway.';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}