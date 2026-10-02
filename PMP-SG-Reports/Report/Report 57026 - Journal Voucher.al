report 57026 "Journal Voucher"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57026 - Journal Voucher.rdl';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                                ;//WHERE("Journal Template Name" = CONST('GENERAL'));
            column(GenAccountType; "Gen. Journal Line"."Account Type")
            {
            }
            column(GenAccountNo; "Gen. Journal Line"."Account No.")
            {
            }
            column(GenPostingDate; FORMAT("Gen. Journal Line"."Posting Date"))
            {
            }
            column(GenAmount; FORMAT("Gen. Journal Line".Amount))
            {
                //DecimalPlaces = 2:2;
            }
            column(GenAmountLCY; "Gen. Journal Line"."Amount (LCY)")
            {
                DecimalPlaces = 2 : 2;
            }
            column(GenDocNo; "Gen. Journal Line"."Document No.")
            {
            }
            column(GenDescription; "Gen. Journal Line".Description)
            {
            }
            column(GenBalAcctNo; "Gen. Journal Line"."Bal. Account No.")
            {
            }
            column(GenCurrCode; "Gen. Journal Line"."Currency Code")
            {
            }
            column(GenPayMethod; "Gen. Journal Line"."Payment Method Code")
            {
            }
            column(GenExtDocNo; "Gen. Journal Line"."External Document No.")
            {
            }
            column(GenGSTAmt; "Gen. Journal Line"."VAT Amount")
            {
            }
            column(VendorName; VendName)
            {
            }
            column(VendorAdd; VendRec.Address + ' ' + VendRec."Address 2")
            {
            }
            column(VendCount; VendRec."Country/Region Code" + VendRec."Post Code")
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5] + ' ' + CompanyAddr[6])
            {
            }
            column(CompanyAddr6; CompanyAddr[7] + ' ' + CompanyAddr[8])
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoPic; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(PaymentAmt; PaymentAmt)
            {
            }
            column(PayTo; "Gen. Journal Line".Comment)
            {
            }
            column(CheckText; CheckText[1] + ' ' + CheckText[2])
            {
            }
            column(AccName; AccName)
            {

            }
            column(Addr1; Addr1)
            {

            }
            column(Addr2; Addr2)
            {

            }
            column(City; City)
            {

            }
            column(PostCode; PostCode)
            {

            }
            column(Country; Country)
            {

            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {

            }
            column(Debit_Amount; Debit_Amount) // I9YY 25052021 - Changed to var
            {

            }
            column(Credit_Amount; Credit_Amount) // I9YY 25052021 - Changed to var
            {

            }
            column(GST_Amount; "VAT Amount") // I9YY 25052021
            {

            }
            column(Currency_Code; "Currency Code")
            { }

            //KM20200727 - Start
            trigger OnPreDataItem()
            begin
                SetRange("Journal Template Name", Template);
                SetRange("Journal Batch Name", Batch);
                SetRange("Document No.", Doc);
            end;
            //KM20200727 - End


            trigger OnAfterGetRecord();
            begin
                VendRec.RESET;
                IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor THEN BEGIN
                    VendRec.GET("Gen. Journal Line"."Account No.");
                    VendName := VendRec.Name;
                END;
                Sno := 0;

                // Converter.FormatNoText(CheckText, "Gen. Journal Line".Amount, '');

                /*
                PaymentAmt :=0;
                //Get Bank Amount totals
                GLRec.RESET;
                GLRec.SETFILTER(GLRec."Document No.","Gen. Journal Line"."Document No.");
                GLRec.SETRANGE("Document Type","Gen. Journal Line"."Document Type"::Payment);
                GLRec.SETFILTER(Amount, '<%1',0);
                IF GLRec.FINDFIRST THEN
                    PaymentAmt := GLRec.Amount*-1;
                
                */
                //Clear(AccName);
                Clear(BalAccName);
                Clear(Addr1);
                Clear(Addr2);
                Clear(City);
                Clear(PostCode);
                Clear(Country);
                GenJnlManagement.GetAccounts("Gen. Journal Line", AccName, BalAccName);

                if "Gen. Journal Line"."Account Type" = "Account Type"::Vendor then begin
                    Vendor.Reset();
                    Vendor.Get("Gen. Journal Line"."Account No.");
                    Addr1 := Vendor.Address;
                    Addr2 := Vendor."Address 2";
                    City := Vendor.City;
                    PostCode := Vendor."Post Code";
                    Country := Vendor."Country/Region Code";
                end;

                // I9YY 25052021 - Start
                Clear(Debit_Amount);
                Clear(Credit_Amount);
                if "Debit Amount" <> 0 then begin
                    Debit_Amount := "Debit Amount" - "VAT Amount";
                end else begin
                    Debit_Amount := 0;
                end;

                if "Credit Amount" <> 0 then begin
                    Credit_Amount := "Credit Amount" + "VAT Amount";
                end else begin
                    Credit_Amount := 0;
                end;
                // I9YY 25052021 - End

                if "Currency Code" = '' then begin
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := "Currency Code";
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyInfo.CALCFIELDS(Picture);
        GLSetup.reset;
        GLSetup.get;
    end;

    var
        VendName: Text[100];
        VendRec: Record Vendor;
        Sno: Integer;
        AbsVendLCY: Decimal;
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        GLRec: Record "Gen. Journal Line";
        CheckText: array[2] of Text[80];
        // Converter: Report "Report Converter";
        PaymentAmt: Decimal;
        VLERec: Record "Vendor Ledger Entry";
        GenJnlManagement: Codeunit 230;
        AccName: Text[100];
        BalAccName: Text[100];
        Addr1: Text[100];
        Addr2: Text[100];
        PostCode: Code[20];
        Country: Code[50];
        City: Code[20];
        Vendor: Record Vendor;
        Template: Code[20];
        Batch: Code[20];
        Doc: Code[20];
        Debit_Amount: Decimal; // I9YY 25052021
        Credit_Amount: Decimal; // I9YY 25052021
        CurrCode: Code[20];
        GLSetup: Record "General Ledger Setup";

    //KM20200727 - Start
    procedure Getbatch(T: Code[20]; B: Code[20]; D: Code[20])
    begin
        Clear(Template);
        Clear(Batch);
        Clear(Doc);

        Template := T;
        Batch := B;
        Doc := D;
    end;
    //KM20200727 - End
}