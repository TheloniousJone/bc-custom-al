report 70062 "Posted General Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './6.ReportLayouts/Rpt70062-PostedGeneralJournal.rdl';

    dataset
    {
        dataitem("Posted Gen. Journal Line"; "Posted Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
            column(GenAccountType; "Posted Gen. Journal Line"."Account Type")
            {
            }
            column(GenAccountNo; "Posted Gen. Journal Line"."Account No.")
            {
            }
            column(GenPostingDate; FORMAT("Posted Gen. Journal Line"."Posting Date"))
            {
            }
            column(GenAmt_Debit; GenAmt_Debit)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GenAmt_Credit; GenAmt_Credit)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GenAmountLCY; ABS("Posted Gen. Journal Line"."Amount (LCY)"))
            {
                DecimalPlaces = 2 : 2;
            }
            column(GenDocNo; "Posted Gen. Journal Line"."Document No.")
            {
            }
            column(GenDescription; "Posted Gen. Journal Line".Description)
            {
            }
            column(GenBalAcctNo; "Posted Gen. Journal Line"."Bal. Account No.")
            {
            }
            column(GenCurrCode; "Posted Gen. Journal Line"."Currency Code")
            {
            }
            column(GenPayMethod; "Posted Gen. Journal Line"."Payment Method Code")
            {
            }
            column(GenExtDocNo; "Posted Gen. Journal Line"."External Document No.")
            {
            }
            column(CustName; CustName)
            {
            }
            column(CustAdd; CustRec.Address + ' ' + CustRec."Address 2")
            {
            }
            column(CustCountry; CustRec."Country/Region Code" + ',' + CustRec."Post Code")
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
            column(Journal_Template_Name; "Journal Template Name") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(gtxt_BatchDesc; gtxt_BatchDesc) { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
            column(Dimension3; Dimension3) { }
            column(Bal__Account_Type; "Bal. Account Type") { }
            column(VAT_Amount; "VAT Amount") { }
            column(Bal__VAT_Amount; "Bal. VAT Amount") { }
            column(AccName; AccName) { }
            column(BalAccName; BalAccName) { }
            column(BalAmt_Debit; BalAmt_Debit) { }
            column(BalAmt_Credit; BalAmt_Credit) { }
            column(gdec_Total_Debit; gdec_Total_Debit) { }
            column(gdec_Total_Credit; gdec_Total_Credit) { }
            column(Payment_Reference; "Payment Reference") { }

            trigger OnPreDataItem()
            begin
                GLSetup.Get();
                Clear(gcd_DocNo);
            end;

            trigger OnAfterGetRecord()
            begin
                Sno := 0;

                if gtxt_BatchDesc = '' then begin
                    grec_Batches.Reset();
                    grec_Batches.SetRange("Journal Template Name", "Journal Template Name");
                    grec_Batches.SetRange(Name, "Journal Batch Name");
                    if grec_Batches.FindFirst() then begin
                        gtxt_BatchDesc := grec_Batches.Description;
                    end;
                end;

                Clear(Dimension3);
                grec_DimSetEntry.Reset();
                grec_DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                grec_DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if grec_DimSetEntry.FindFirst() then begin
                    Dimension3 := grec_DimSetEntry."Dimension Value Code";
                end;

                //Get Account Name and Bal Acc Name >>
                Clear(AccName);
                Clear(BalAccName);
                Clear(BalAmt_Debit);
                Clear(BalAmt_Credit);
                Clear(GenAmt_Debit);
                Clear(GenAmt_Credit);

                //GL Acc >>
                if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::"G/L Account" then begin
                    grec_GLAcc.Reset();
                    grec_GLAcc.SetRange("No.", "Posted Gen. Journal Line"."Account No.");
                    if grec_GLAcc.FindFirst() then begin
                        AccName := grec_GLAcc.Name;
                    end;
                end;

                if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::"G/L Account" then begin
                    grec_GLAcc.Reset();
                    grec_GLAcc.SetRange("No.", "Posted Gen. Journal Line"."Bal. Account No.");
                    if grec_GLAcc.FindFirst() then begin
                        BalAccName := grec_GLAcc.Name;
                    end;
                end;

                if "Posted Gen. Journal Line".Amount < 0 then
                    GenAmt_Credit += "Posted Gen. Journal Line".Amount;

                if "Posted Gen. Journal Line".Amount > 0 then
                    GenAmt_Debit += "Posted Gen. Journal Line".Amount;
                //GL Acc <<

                //Cust >>
                if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::Customer then begin
                    grec_Cust.Reset();
                    grec_Cust.SetRange("No.", "Posted Gen. Journal Line"."Account No.");
                    if grec_Cust.FindFirst() then begin
                        AccName := grec_Cust.Name;
                    end;
                end;

                if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::Customer then begin
                    grec_Cust.Reset();
                    grec_Cust.SetRange("No.", "Posted Gen. Journal Line"."Bal. Account No.");
                    if grec_Cust.FindFirst() then begin
                        BalAccName := grec_Cust.Name;
                    end;
                end;
                //Cust <<

                //Vend >>
                if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::Vendor then begin
                    grec_Vend.Reset();
                    grec_Vend.SetRange("No.", "Posted Gen. Journal Line"."Account No.");
                    if grec_Vend.FindFirst() then begin
                        AccName := grec_Vend.Name;
                    end;
                end;

                if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::Vendor then begin
                    grec_Vend.Reset();
                    grec_Vend.SetRange("No.", "Posted Gen. Journal Line"."Bal. Account No.");
                    if grec_Vend.FindFirst() then begin
                        BalAccName := grec_Vend.Name;
                    end;
                end;
                //Vend <<

                //FA >>
                if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::"Fixed Asset" then begin
                    grec_FA.Reset();
                    grec_FA.SetRange("No.", "Posted Gen. Journal Line"."Account No.");
                    if grec_FA.FindFirst() then begin
                        AccName := grec_FA.Description;
                    end;
                end;

                if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::"Fixed Asset" then begin
                    grec_FA.Reset();
                    grec_FA.SetRange("No.", "Posted Gen. Journal Line"."Bal. Account No.");
                    if grec_FA.FindFirst() then begin
                        BalAccName := grec_FA.Description;
                    end;
                end;
                //FA <<

                //Employee >>
                if "Posted Gen. Journal Line"."Account Type" = "Posted Gen. Journal Line"."Account Type"::Employee then begin
                    grec_Employee.Reset();
                    grec_Employee.SetRange("No.", "Posted Gen. Journal Line"."Account No.");
                    if grec_Employee.FindFirst() then begin
                        AccName := grec_Employee.FullName();
                    end;
                end;

                if "Posted Gen. Journal Line"."Bal. Account Type" = "Posted Gen. Journal Line"."Bal. Account Type"::Employee then begin
                    grec_Employee.Reset();
                    grec_Employee.SetRange("No.", "Posted Gen. Journal Line"."Bal. Account No.");
                    if grec_Employee.FindFirst() then begin
                        BalAccName := grec_Employee.FullName();
                    end;
                end;
                //Employee <<

                //Get Account Name and Bal Acc Name <<

                if (-1 * "Posted Gen. Journal Line".Amount) < 0 then
                    BalAmt_Credit += (-1 * "Posted Gen. Journal Line".Amount);

                if (-1 * "Posted Gen. Journal Line".Amount) > 0 then
                    BalAmt_Debit += (-1 * "Posted Gen. Journal Line".Amount);

                Clear(gdec_Total_Debit);
                Clear(gdec_Total_Credit);
                grec_PGJL.Reset();
                grec_PGJL.SetRange("Journal Template Name", "Posted Gen. Journal Line"."Journal Template Name");
                grec_PGJL.SetRange("Journal Batch Name", "Posted Gen. Journal Line"."Journal Batch Name");
                grec_PGJL.SetRange("Document No.", "Posted Gen. Journal Line"."Document No.");
                if grec_PGJL.FindSet() then begin
                    repeat
                        if grec_PGJL."Account No." <> '' then begin
                            if grec_PGJL.Amount < 0 then
                                gdec_Total_Credit += grec_PGJL.Amount;
                            if grec_PGJL.Amount > 0 then
                                gdec_Total_Debit += grec_PGJL.Amount;
                        end;
                        if grec_PGJL."Bal. Account No." <> '' then begin
                            if (-1 * (grec_PGJL.Amount)) < 0 then
                                gdec_Total_Credit += (-1 * (grec_PGJL.Amount));
                            if (-1 * (grec_PGJL.Amount)) > 0 then
                                gdec_Total_Debit += (-1 * (grec_PGJL.Amount));
                        end;
                    until grec_PGJL.Next() = 0;
                end;

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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        FormatAddr.Company(CompanyAddr, CompanyInfo);
    end;

    var
        CustName: Text[50];
        CustRec: Record 18;
        Sno: Integer;
        AbsVendLCY: Decimal;
        CompanyInfo: Record 79;
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit 365;
        gtxt_BatchDesc: Text;
        grec_Batches: Record "Gen. Journal Batch";
        grec_Approval: Record "Approval Entry";
        gcd_Approver: Text;
        gcd_Reject: Text;
        grec_DimSetEntry: Record "Dimension Set Entry";
        Dimension3: Code[20];
        GLSetup: Record "General Ledger Setup";


        AccName: Text;
        BalAccName: Text;
        grec_GLAcc: Record "G/L Account";
        BalAmt_Debit: Decimal;
        BalAmt_Credit: Decimal;
        GenAmt_Debit: Decimal;
        GenAmt_Credit: Decimal;
        grec_Cust: Record Customer;
        grec_Vend: Record Vendor;
        grec_Bank: Record "Bank Account";
        grec_FA: Record "Fixed Asset";
        grec_Employee: Record Employee;
        gcd_DocNo: Text;
        gdec_Total_Debit: Decimal;
        gdec_Total_Credit: Decimal;
        grec_PGJL: Record "Posted Gen. Journal Line";
}