report 50022 "HP Sales Credit Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Rpt 50022 HP Sales Credit Note.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            // DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.")
            //                     where("Document Type" = const("Credit Memo"), "Account Type" = const(Customer));
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.")
                                where("Document Type" = filter('Invoice|Credit Memo'), "Account Type" = const(Customer));
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            RequestFilterHeading = 'Credit Note';
            column(ReportCaption; ReportCaptionLbl)
            {
            }
            column(NumberCaption; NumberCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(YourRefCaption; YourRefCaptionLbl)
            {
            }
            column(OurRefCaption; OurRefCaptionLbl)
            {
            }
            column(PaymentCaption; PaymentCaptionLbl)
            {
            }
            column(TaxInvAccountCaption; TaxInvAccountCaptionLbl)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Header_CustName; rec_Customer.Name)
            {
            }
            column(Header_CustAddress; rec_Customer.Address)
            {
            }
            column(Header_CustAddress2; rec_Customer."Address 2")
            {
            }
            column(Header_CustCity; rec_Customer.City)
            {
            }
            column(Header_CustPostCode; rec_Customer."Post Code")
            {
            }
            column(Header_Number; "Document No.")
            {
            }
            column(Header_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Header_YourRef; "External Document No.")
            {
            }
            column(Header_OurRef; "Currency Code")
            {
            }
            column(Header_Payment; "Payment Terms Code")
            {
            }
            column(Header_TaxInvAcct; "Account No.")
            {
            }
            column(Lines_Description; Description)
            {
            }
            column(Lines_Amount; Amount)
            {
            }
            column(Sub_Total; Sub_Total)
            {
            }
            column(GST_Amount; GST_Amount)
            {
            }
            column(Grand_Total; Grand_Total)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(CompanyInfo_Address; CompanyInfo.Address) { }
            column(CompanyInfo_Address2; CompanyInfo."Address 2") { }
            column(CompanyInfo_Tel; CompanyInfo."Phone No.") { }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.") { }
            column(CompanyInfo_Website; CompanyInfo."Home Page") { }
            column(CompanyInfo_Email; CompanyInfo."E-Mail") { }
            column(CompanyInfo_GSTReg; CompanyInfo."VAT Registration No.") { }

            trigger OnAfterGetRecord()
            begin
                Clear(rec_Customer);

                if "Account No." <> '' then begin
                    rec_Customer.Reset();
                    rec_Customer.Get("Account No.");
                end;
                if "Gen. Journal Line"."Document Type" = "Gen. Journal Line"."Document Type"::"Credit Memo" then
                    Amount := -Amount;

                GetTotal("Gen. Journal Line");
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        rec_Customer: Record Customer;
        Grand_Total, GST_Amount, Sub_Total : Decimal;
        // ReportCaptionLbl: Label 'Credit Note';
        ReportCaptionLbl: Text[30];
        NumberCaptionLbl: Label 'Number';
        DateCaptionLbl: Label 'Date';
        PageNoCaptionLbl: Label 'Page No.';
        YourRefCaptionLbl: Label 'Your Ref';
        OurRefCaptionLbl: Label 'Currency';
        PaymentCaptionLbl: Label 'Payment';
        TaxInvAccountCaptionLbl: Label 'Tax Invoice Account';

    local procedure GetTotal(par_GJL: Record "Gen. Journal Line")
    var
        lcl_GenJourLine: Record "Gen. Journal Line";
    begin
        Clear(Sub_Total);
        Clear(GST_Amount);
        Clear(Grand_Total);
        Clear(ReportCaptionLbl);

        lcl_GenJourLine.Reset();
        lcl_GenJourLine.SetCurrentKey("Document Type", "Account Type", "Document No.");
        lcl_GenJourLine.SetRange("Document Type", par_GJL."Document Type");
        lcl_GenJourLine.SetRange("Account Type", par_GJL."Account Type");
        lcl_GenJourLine.SetRange("Document No.", par_GJL."Document No.");
        // YF 06 Jun 2022
        lcl_GenJourLine.SetRange("Journal Template Name", par_GJL."Journal Template Name");
        lcl_GenJourLine.SetRange("Journal Batch Name", par_GJL."Journal Batch Name");
        // YF 06 Jun 2002
        if lcl_GenJourLine.FindSet() then begin
            repeat
                Sub_Total += lcl_GenJourLine.Amount;
                GST_Amount += lcl_GenJourLine."VAT Amount";
            until lcl_GenJourLine.Next() = 0;
        end;

        Grand_Total := Sub_Total + GST_Amount;
        ReportCaptionLbl := 'Invoice';
        if lcl_GenJourLine."Document Type" = lcl_GenJourLine."Document Type"::"Credit Memo" then begin
            Sub_Total := -Sub_Total;
            GST_Amount := -GST_Amount;
            Grand_Total := -Grand_Total;
            ReportCaptionLbl := 'Credit Memo';

        end;
    end;
}