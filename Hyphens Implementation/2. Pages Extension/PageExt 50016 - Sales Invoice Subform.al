pageextension 50016 HyphensSaleInvoiceSubformExt extends "Sales Invoice Subform"
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