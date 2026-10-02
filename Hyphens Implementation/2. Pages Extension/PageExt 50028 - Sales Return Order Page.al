pageextension 50028 HyphensSalesRetOrderPageExt extends "Sales Return Order"
{
    layout
    {
        addafter(I9G_Reason_Text)
        {
            field(I9_ContractDate; Rec.I9_ContractDate)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

            field(I9_ContractNo; Rec.I9_ContractNo)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

            field(I9_ContractAmount; Rec.I9_ContractAmount)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
        addlast(General)
        {
            group("Peg Data")
            {
                Visible = ShowPegFeature;

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
            }

        }
    }

    // YF 14 Apr 2022
    actions
    {
        modify(GetPostedDocumentLinesToReverse)
        {
            ApplicationArea = All;

            trigger OnAfterAction()
            begin
                if ShowPegFeature then
                    UpdateHeaderPegRateInfo();
            end;
        }
    }
    // YF 14 Apr 2022

    trigger OnOpenPage()
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;
        ShowPegFeature := CompanyInfoRec."Enable Peg Rate Module";
    end;

    // YF 14 Apr 2022
    local procedure UpdateHeaderPegRateInfo()
    var
        SLRec: Record "Sales Line";
        CurrXchgnRateRec: Record "Currency Exchange Rate";
        CompanyInfoRec: Record "Company Information";
    begin

        CompanyInfoRec.Get;
        if Not CompanyInfoRec."Enable Peg Rate Module" then
            exit;

        // Peg Rate = Find First from Sales Line
        SLRec.Reset;
        SLRec.SetRange("Document Type", Rec."Document Type");
        SLRec.SetRange("Document No.", Rec."No.");
        SLRec.SetRange(Type, SLRec.Type::Item);
        SLRec.SetFilter("Peg Rate", '<>%1', 0);
        if SLRec.FindFirst() then begin
            Rec."Peg Rate" := SLRec."Peg Rate";
            Rec.CalcFields(Amount);
            Rec."VND Amount" := Rec.Amount * Rec."Peg Rate";

            // VND-LCY Rate = Take from Currency Table, filter by order date
            CurrXchgnRateRec.Reset;
            CurrXchgnRateRec.SetRange("Currency Code", 'VND');
            CurrXchgnRateRec.SetFilter("Starting Date", '<=%1', Rec."Posting Date"); // or order date? TBC
            CurrXchgnRateRec.SetCurrentKey("Starting Date");
            CurrXchgnRateRec.SetAscending("Starting Date", false);
            if CurrXchgnRateRec.FindFirst() then
                if CurrXchgnRateRec."Relational Exch. Rate Amount" <> 0 then
                    Rec."VND-LCY Rate" := (CurrXchgnRateRec."Exchange Rate Amount" / CurrXchgnRateRec."Relational Exch. Rate Amount");

            // Peg SGD Amount
            if Rec."VND-LCY Rate" <> 0 then
                Rec."Peg SGD Amount" := Rec."VND Amount" / Rec."VND-LCY Rate";

            // FCY-LCY Rate = 1 / SHRec.Currency Factor
            if Rec."Currency Factor" <> 0 then
                Rec."FCY-LCY Rate" := 1 / Rec."Currency Factor"
            else
                Rec."FCY-LCY Rate" := 1;

            if Rec."Currency Factor" <> 0 then
                Rec."LCY Amount" := Rec.Amount / Rec."Currency Factor"
            else
                Rec."LCY Amount" := Rec.Amount;

            // Adjustment
            Rec.Adjustment := Rec."Peg SGD Amount" - Rec."LCY Amount";

        end
        else begin
            Rec."Peg Rate" := 0;
            Rec."VND Amount" := 0;
            Rec."VND-LCY Rate" := 0;
            Rec."Peg SGD Amount" := 0;
            Rec."FCY-LCY Rate" := 0;
            Rec."LCY Amount" := 0;
            Rec.Adjustment := 0;
        end;

        // Update Header Record
        Rec.Modify(false);

    end;
    // YF 14 Apr 2022

    var
        ShowPegFeature: Boolean;

}