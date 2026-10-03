pageextension 50004 HyphensSaleOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Peg Rate"; Rec."Peg Rate")
            {
                ApplicationArea = All;
                Visible = ShowPegFeature;
                Editable = false;
            }

            field("VND Amount"; Rec."VND Amount")
            {
                ApplicationArea = All;
                Visible = ShowPegFeature;
                Editable = false;
            }

        }
        addafter(ShortcutDimCode8)
        {
            field("Special Order Purchase No."; Rec."Special Order Purchase No.")
            {
                ApplicationArea = All;
            }
            field("Special Order Purch. Line No."; Rec."Special Order Purch. Line No.")
            {
                ApplicationArea = All;
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