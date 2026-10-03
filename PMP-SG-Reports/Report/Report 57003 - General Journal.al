report 57003 "General Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57003 - General Journal.rdl';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
            column(GenAccountType; "Gen. Journal Line"."Account Type")
            {
            }
            column(GenAccountNo; "Gen. Journal Line"."Account No.")
            {
            }
            column(GenPostingDate; FORMAT("Gen. Journal Line"."Posting Date"))
            {
            }
            column(GenAmount; "Gen. Journal Line".Amount)//KM20210219 - Remove ABS
            {
                DecimalPlaces = 2 : 2;
            }
            column(GenAmountLCY; ABS("Gen. Journal Line"."Amount (LCY)"))
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

            //KM20210406 - Start
            column(Bal__Account_Type; "Bal. Account Type") { }
            column(VAT_Amount; "VAT Amount") { }
            column(Bal__VAT_Amount; "Bal. VAT Amount") { }
            column(AccName; AccName) { }
            column(BalAccName; BalAccName) { }
            column(BalAmount; BalAmount) { }

            // dataitem(Integer; Integer)
            // {
            //     DataItemTableView = sorting(Number) where(Number = const(1));
            //     DataItemLinkReference = "Gen. Journal Line";
            column(gdec_Total; gdec_Total) { }
            // }
            //KM20210406 - End


            trigger OnPreDataItem()
            begin
                GLSetup.Get();
                Clear(gcd_DocNo);
            end;

            trigger OnAfterGetRecord()
            begin
                // CustRec.RESET;
                // CustRec.GET("Gen. Journal Line"."Account No.");
                // CustName := CustRec.Name;
                Sno := 0;

                if gtxt_BatchDesc = '' then begin
                    grec_Batches.Reset();
                    grec_Batches.SetRange("Journal Template Name", "Journal Template Name");
                    grec_Batches.SetRange(Name, "Journal Batch Name");
                    if grec_Batches.FindFirst() then begin
                        gtxt_BatchDesc := grec_Batches.Description;
                    end;
                end;

                //KM20210218 - Start
                Clear(Dimension3);
                grec_DimSetEntry.Reset();
                grec_DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                grec_DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if grec_DimSetEntry.FindFirst() then begin
                    Dimension3 := grec_DimSetEntry."Dimension Value Code";
                end;
                //KM20210218 - End

                //KM20210406 - Start 

                // if gcd_DocNo = '' then begin
                //     Clear(gdec_Total);
                //     gcd_DocNo := "Gen. Journal Line"."Document No.";
                // end;

                // if "Gen. Journal Line"."Document No." <> gcd_DocNo then begin
                //     Clear(gdec_Total);
                // end;

                //Get Account Name and Bal Acc Name >>
                Clear(AccName);
                Clear(BalAccName);
                Clear(BalAmount);

                //GL Acc >>
                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::"G/L Account" then begin
                    grec_GLAcc.Reset();
                    grec_GLAcc.SetLoadFields("No.", Name);
                    grec_GLAcc.SetRange("No.", "Gen. Journal Line"."Account No.");
                    if grec_GLAcc.FindFirst() then begin
                        AccName := grec_GLAcc.Name;
                    end;
                end;

                if "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"G/L Account" then begin
                    grec_GLAcc.Reset();
                    grec_GLAcc.SetLoadFields("No.", Name);
                    grec_GLAcc.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if grec_GLAcc.FindFirst() then begin
                        BalAccName := grec_GLAcc.Name;
                    end;
                end;
                //GL Acc <<

                //Cust >>
                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Customer then begin
                    grec_Cust.Reset();
                    grec_Cust.SetRange("No.", "Gen. Journal Line"."Account No.");
                    if grec_Cust.FindFirst() then begin
                        AccName := grec_Cust.Name;
                    end;
                end;

                if "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::Customer then begin
                    grec_Cust.Reset();
                    grec_Cust.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if grec_Cust.FindFirst() then begin
                        BalAccName := grec_Cust.Name;
                    end;
                end;
                //Cust <<

                //Vend >>
                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor then begin
                    grec_Vend.Reset();
                    grec_Vend.SetRange("No.", "Gen. Journal Line"."Account No.");
                    if grec_Vend.FindFirst() then begin
                        AccName := grec_Vend.Name;
                    end;
                end;

                if "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::Vendor then begin
                    grec_Vend.Reset();
                    grec_Vend.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if grec_Vend.FindFirst() then begin
                        BalAccName := grec_Vend.Name;
                    end;
                end;
                //Vend <<

                //FA >>
                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::"Fixed Asset" then begin
                    grec_FA.Reset();
                    grec_FA.SetRange("No.", "Gen. Journal Line"."Account No.");
                    if grec_FA.FindFirst() then begin
                        AccName := grec_FA.Description;
                    end;
                end;

                if "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"Fixed Asset" then begin
                    grec_FA.Reset();
                    grec_FA.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if grec_FA.FindFirst() then begin
                        BalAccName := grec_FA.Description;
                    end;
                end;
                //FA <<

                //Employee >>
                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Employee then begin
                    grec_Employee.Reset();
                    grec_Employee.SetRange("No.", "Gen. Journal Line"."Account No.");
                    if grec_Employee.FindFirst() then begin
                        AccName := grec_Employee.FullName();
                    end;
                end;

                if "Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::Employee then begin
                    grec_Employee.Reset();
                    grec_Employee.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                    if grec_Employee.FindFirst() then begin
                        BalAccName := grec_Employee.FullName();
                    end;
                end;
                //Employee <<

                //Get Account Name and Bal Acc Name <<

                // if "Bal. Account No." <> '' then
                //     BalAmount += (-1 * "Gen. Journal Line".Amount)
                // else
                //     BalAmount := 0;

                BalAmount += (-1 * "Gen. Journal Line".Amount);
                // gdec_Total := gdec_Total + "Gen. Journal Line".Amount + BalAmount;
                // gcd_DocNo := "Gen. Journal Line"."Document No.";
                //KM20210406 - End 

                //KM20210407 - Start
                Clear(gdec_Total);
                grec_GJL.Reset();
                grec_GJL.SetRange("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                grec_GJL.SetRange("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                grec_GJL.SetRange("Document No.", "Gen. Journal Line"."Document No.");
                if grec_GJL.FindSet() then begin
                    repeat
                        if grec_GJL."Account No." <> '' then begin
                            gdec_Total += grec_GJL.Amount;
                        end;
                        if grec_GJL."Bal. Account No." <> '' then begin
                            gdec_Total += (-1 * (grec_GJL.Amount));
                        end;
                    until grec_GJL.Next() = 0;
                end;
                // gcd_DocNo := "Gen. Journal Line"."Document No.";
                //KM20210407 - End

                // Remember to get Approval Details >>
                // Clear(gcd_Approver);
                // Clear(gcd_Reject);

                // grec_Approval.Reset();
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

        //KM20210406 - Start
        AccName: Text; //KM20210406
        BalAccName: Text;  //KM20210406
        grec_GLAcc: Record "G/L Account"; //KM20210406
        BalAmount: Decimal; //KM20210406
        grec_Cust: Record Customer;
        grec_Vend: Record Vendor;
        grec_Bank: Record "Bank Account";
        grec_FA: Record "Fixed Asset";
        grec_Employee: Record Employee;
        gcd_DocNo: Text;
        gdec_Total: Decimal;
        grec_GJL: Record "Gen. Journal Line";
    //KM20210406 - End
}

