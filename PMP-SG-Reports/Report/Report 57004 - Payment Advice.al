report 57004 "Payment Advice"
{
    // version I9

    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57004 - Payment Advice.rdl';
    CaptionML = ENU = 'Payment Advice',
                ENA = 'Payment Advice';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                                WHERE("Journal Template Name" = CONST('PAYMENT'));

            column(Journal_Batch_Name; "Gen. Journal Line"."Journal Batch Name")
            {
            }
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
            column(GenBalAcctType; "Gen. Journal Line"."Bal. Account Type")
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
            column(CompanyInfoRegNo; CompanyInfo."Registration No.")
            {
            }
            column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(PaymentAmt; PaymentAmt)
            {
            }
            // column(PayTo; "Gen. Journal Line".Comment)
            // {
            // }
            column(PayTo; VendName)
            {
            }
            column(CheckText; CheckText[1] + ' ' + CheckText[2])
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("Account No."),
                               "Applies-to ID" = FIELD("Document No.");
                column(VendNo; "Vendor Ledger Entry"."Vendor No.")
                {
                }
                column(VendAmtToApply; "Vendor Ledger Entry"."Amount to Apply")
                {
                }
                column(VendDocNo; "Vendor Ledger Entry"."Document No.")
                {
                }
                column(VendAmtLCY; "Vendor Ledger Entry"."Amount (LCY)")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(VendRemAmt; "Vendor Ledger Entry"."Remaining Amount")
                {
                }
                column(VendAmt; "Vendor Ledger Entry".Amount)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(VendInvNo; "Vendor Ledger Entry"."External Document No.")
                {
                }
                column(VendCurrCode; "Vendor Ledger Entry"."Currency Code")
                {
                }
                column(VendPostingDate; FORMAT("Vendor Ledger Entry"."Posting Date"))
                {
                }
                column(Sno; Sno)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Sno += 1;
                    AbsVendLCY := ABS("Vendor Ledger Entry"."Amount (LCY)");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                VendRec.RESET;
                IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor THEN BEGIN
                    VendRec.GET("Gen. Journal Line"."Account No.");
                    VendName := VendRec.Name;
                END;
                Sno := 0;

                Converter.InitTextVariable();
                Converter.FormatNoText(CheckText, "Gen. Journal Line".Amount, '');

                IF "Gen. Journal Line"."Currency Code" = '' THEN BEGIN
                    CurrCode := GLSetup."Local Currency Symbol"
                END
                ELSE BEGIN
                    CurrRec.RESET;
                    CurrRec.SETRANGE(Code, "Gen. Journal Line"."Currency Code");
                    IF CurrRec.FINDFIRST THEN
                        CurrCode := CurrRec.Symbol;
                END;


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
        GLSetup.GET;
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        VendName: Text[50];
        VendRec: Record Vendor;
        Sno: Integer;
        AbsVendLCY: Decimal;
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        GLRec: Record "Gen. Journal Line";
        CheckText: array[2] of Text[80];
        Converter: Report "Report Converter";
        PaymentAmt: Decimal;
        VLERec: Record "Vendor Ledger Entry";
        CurrCode: Text[5];
        CurrRec: Record Currency;
        GLSetup: Record "General Ledger Setup";
}

