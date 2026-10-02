tableextension 50005 HyphensSalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; "Peg Rate"; Decimal)
        {
            Caption = 'Peg Rate';
            DataClassification = ToBeClassified;
        }

        field(50001; "VND Amount"; Decimal)
        {
            Caption = 'VND Amount';
            DataClassification = ToBeClassified;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                CalculateVNDPegRateAmount();
            end;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                CalculateVNDPegRateAmount();
            end;
        }

        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CalculateVNDPegRateAmount();
            end;
        }

        modify("Currency Code")
        {
            trigger OnAfterValidate()
            begin
                CalculateVNDPegRateAmount();
            end;
        }

    }

    trigger OnAfterInsert()
    begin
        CalculateVNDPegRateAmount();
        Rec.Modify(false);
        UpdateHeaderPegRateInfo();
    end;

    trigger OnAfterModify()
    begin
        Rec.Modify(false);
        UpdateHeaderPegRateInfo();
    end;

    trigger OnAfterDelete()
    begin
        UpdateHeaderPegRateInfo();
    end;

    local procedure CalculateVNDPegRateAmount()
    var
        PegRateRec: Record "Peg Rate";
        SpecifcPegRateExist: Boolean;
        ItemRec: Record Item;
        CompanyInfoRec: Record "Company Information";
        SHRec: Record "Sales Header";
        SHRecPostingDate: Date;
    begin
        CompanyInfoRec.Get;
        if Not CompanyInfoRec."Enable Peg Rate Module" then
            exit;

        Rec."Peg Rate" := 0;
        Rec."VND Amount" := 0;
        SpecifcPegRateExist := false;

        SHRec.Reset;
        SHRec.SetRange("Document Type", Rec."Document Type");
        SHRec.SetRange("No.", Rec."Document No.");
        if SHRec.FindFirst() then
            SHRecPostingDate := SHRec."Posting Date";

        if Rec.Type = Rec.Type::Item then begin
            PegRateRec.Reset;
            PegRateRec.SetRange("Customer No.", Rec."Sell-to Customer No.");
            // PegRateRec.SetRange(Currency, 'VND');
            PegRateRec.SetRange(Currency, Rec."Currency Code");
            PegRateRec.SetRange("Item Type", PegRateRec."Item Type"::Specific);
            PegRateRec.SetRange("Item Code", Rec."No.");
            PegRateRec.SetFilter("Start Date", '<=%1', SHRecPostingDate);
            PegRateRec.SetFilter("End Date", '>=%1', SHRecPostingDate);
            if PegRateRec.FindFirst() then begin
                Rec."Peg Rate" := PegRateRec."Peg Rate";
                Rec."VND Amount" := Rec."Unit Price" * PegRateRec."Peg Rate";
                SpecifcPegRateExist := true;
            end;

            if Not SpecifcPegRateExist then begin
                if ItemRec.Get(Rec."No.") then begin
                    PegRateRec.Reset;
                    PegRateRec.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    // PegRateRec.SetRange(Currency, 'VND');
                    PegRateRec.SetRange(Currency, Rec."Currency Code");
                    PegRateRec.SetRange("Item Type", PegRateRec."Item Type"::Group);
                    PegRateRec.SetRange("Item Code", ItemRec."Hyphens Item Group");
                    PegRateRec.SetFilter("Start Date", '<=%1', SHRecPostingDate);
                    PegRateRec.SetFilter("End Date", '>=%1', SHRecPostingDate);
                    if PegRateRec.FindFirst() then begin
                        Rec."Peg Rate" := PegRateRec."Peg Rate";
                        Rec."VND Amount" := Rec."Unit Price" * PegRateRec."Peg Rate";
                        SpecifcPegRateExist := true;
                    end;
                end;
            end;

            /*
            if Rec.Modify(false) then
                UpdateHeaderPegRateInfo();
            */
        end;

    end;

    local procedure UpdateHeaderPegRateInfo()
    var
        SHRec: Record "Sales Header";
        SLRec: Record "Sales Line";
        CurrXchgnRateRec: Record "Currency Exchange Rate";
        CompanyInfoRec: Record "Company Information"; // YF 06 Dec 2021
    begin
        // YF 06 Dec 2021
        CompanyInfoRec.Get;
        if Not CompanyInfoRec."Enable Peg Rate Module" then
            exit;
        // YF 06 Dec 2021

        SHRec.Reset;
        SHRec.SetRange("Document Type", Rec."Document Type");
        SHRec.SetRange("No.", Rec."Document No.");
        if SHRec.FindFirst() then begin

            // Peg Rate = Find First from Sales Line
            SLRec.Reset;
            SLRec.SetRange("Document Type", Rec."Document Type");
            SLRec.SetRange("Document No.", Rec."Document No.");
            SLRec.SetRange(Type, SLRec.Type::Item);
            SLRec.SetFilter("Peg Rate", '<>%1', 0); //RL 13 Jan 2022 - find first line with peg rate
            if SLRec.FindFirst() then begin
                SHRec."Peg Rate" := SLRec."Peg Rate";
                // VND Amount = SH.Amount * Peg Rate
                SHRec.CalcFields(Amount);
                SHRec."VND Amount" := SHRec.Amount * SHRec."Peg Rate";

                // VND-LCY Rate = Take from Currency Table, filter by order date
                CurrXchgnRateRec.Reset;
                CurrXchgnRateRec.SetRange("Currency Code", 'VND');
                CurrXchgnRateRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date"); // or order date? TBC
                CurrXchgnRateRec.SetCurrentKey("Starting Date");
                CurrXchgnRateRec.SetAscending("Starting Date", false);
                if CurrXchgnRateRec.FindFirst() then
                    if CurrXchgnRateRec."Relational Exch. Rate Amount" <> 0 then // YF 06 Dec 2021
                        SHRec."VND-LCY Rate" := (CurrXchgnRateRec."Exchange Rate Amount" / CurrXchgnRateRec."Relational Exch. Rate Amount");
                // SHRec."VND-LCY Rate" := CurrXchgnRateRec."Relational Exch. Rate Amount";

                // Peg SGD Amount
                // SHRec."Peg SGD Amount" := SHRec.Amount * SHRec."VND-LCY Rate"; // YF 01 Dec 2021
                if SHRec."VND-LCY Rate" <> 0 then // YF 06 Dec 2021
                    SHRec."Peg SGD Amount" := SHRec."VND Amount" / SHRec."VND-LCY Rate"; // YF 01 Dec 2021

                // FCY-LCY Rate = 1 / SHRec.Currency Factor
                if SHRec."Currency Factor" <> 0 then
                    SHRec."FCY-LCY Rate" := 1 / SHRec."Currency Factor"
                else
                    SHRec."FCY-LCY Rate" := 1; //RL 14 Feb 2022
                // LCY Amount = Amount / SHRec.Currency Factor
                if SHRec."Currency Factor" <> 0 then
                    SHRec."LCY Amount" := SHRec.Amount / SHRec."Currency Factor"
                else
                    SHRec."LCY Amount" := Rec.Amount; //RL 14 Feb 2022
                // Adjustment
                SHRec.Adjustment := SHRec."Peg SGD Amount" - SHRec."LCY Amount";
            end
            else begin
                SHRec."Peg Rate" := 0;
                SHRec."VND Amount" := 0;
                SHRec."VND-LCY Rate" := 0;
                SHRec."Peg SGD Amount" := 0;
                SHRec."FCY-LCY Rate" := 0;
                SHRec."LCY Amount" := 0;
                SHRec.Adjustment := 0;
            end;

            // Update Header Record
            SHRec.Modify(false);
        end;
    end;
}
