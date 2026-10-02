report 50023 "HP Posted Credit Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/Rpt 50023 HP Posted Credit Note.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Exchange Variable Settlement';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where("Document Type" = const("Credit Memo"));
            RequestFilterFields = "Document No.";
            RequestFilterHeading = 'Posted Credit Note';
            CalcFields = Amount;
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
            column(Header_Payment; '')
            {
            }
            column(Header_TaxInvAcct; "Customer No.")
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

            trigger OnAfterGetRecord()
            begin
                Clear(rec_Customer);

                if "Customer No." <> '' then begin
                    rec_Customer.Reset();
                    rec_Customer.Get("Customer No.");
                end;

                GetTotal("Cust. Ledger Entry");
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
        ReportCaptionLbl: Label 'Credit Note';
        NumberCaptionLbl: Label 'Number';
        DateCaptionLbl: Label 'Date';
        PageNoCaptionLbl: Label 'Page No.';
        YourRefCaptionLbl: Label 'Your Ref';
        OurRefCaptionLbl: Label 'Our Ref';
        PaymentCaptionLbl: Label 'Payment';
        TaxInvAccountCaptionLbl: Label 'Tax Invoice Account';

    local procedure GetTotal(par_CLE: Record "Cust. Ledger Entry")
    var
        lcl_CustLedEntry: Record "Cust. Ledger Entry";
    begin
        Clear(Sub_Total);
        Clear(GST_Amount);
        Clear(Grand_Total);

        lcl_CustLedEntry.Reset();
        lcl_CustLedEntry.SetCurrentKey("Document Type", "Document No.");
        lcl_CustLedEntry.SetRange("Document Type", par_CLE."Document Type");
        lcl_CustLedEntry.SetRange("Document No.", par_CLE."Document No.");
        if lcl_CustLedEntry.FindSet() then begin
            repeat
                lcl_CustLedEntry.CalcFields(Amount);
                Sub_Total += lcl_CustLedEntry.Amount;
            until lcl_CustLedEntry.Next() = 0;
        end;

        Grand_Total := Sub_Total + GST_Amount;
    end;
}