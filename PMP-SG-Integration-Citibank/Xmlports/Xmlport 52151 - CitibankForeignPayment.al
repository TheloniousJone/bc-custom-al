xmlport 52151 "Citibank Foreign Payment"
{
    Caption = 'Citibank Foreign Payment';
    Direction = Export;
    Format = VariableText;
    TextEncoding = WINDOWS;
    FieldSeparator = '<None>';
    FieldDelimiter = '<None>';
    TableSeparator = '<None>';
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(GenJnlLine; "Gen. Journal Line")
            {
                RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Account Type";
                textelement(TextPLG)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TextPLG := 'EFT@';
                    end;
                }
                textelement(TextSG)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TextSG := 'SG@';
                    end;
                }
                textelement(BalBankAccNo)
                {
                }
                textelement(CurrencyCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if GenJnlLine."Currency Code" = '' then
                            CurrencyCode := GLSetup."LCY Code" + '@'
                        else
                            CurrencyCode := GenJnlLine."Currency Code" + '@';
                    end;
                }
                textelement(Amt)
                {
                }
                textelement(PostingDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PostingDate := Format(GenJnlLine."Posting Date", 0, '<Year4><Month,2><Day,2>') + '@@@@@@@';
                    end;
                }
                textelement(CompanyInfoName)
                {
                    trigger OnBeforePassVariable()

                    begin
                        CompanyInfoName := CompanyInfo.Name + '@';
                    end;
                }
                textelement(CompanyInfoAddr1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyInfoAddr1 := CompanyInfo.Address + '@';
                    end;
                }
                textelement(CompanyInfoAddr2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyInfoAddr2 := CompanyInfo."Address 2" + '@';
                    end;
                }
                textelement(CompanyInfoCityPostCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyInfoCityPostCode := CompanyInfo.City + ' ' + Format(CompanyInfo."Post Code") + '@@@';
                    end;
                }
                textelement(VendName35a)
                {
                }
                textelement(VendAddr1)
                {
                }
                textelement(VendCityPostCode)
                {
                }
                textelement(VendPhoneNo)
                {
                }
                textelement(VendBankAccNo)
                {
                }
                textelement(VendBankAccName)
                {
                }
                textelement(VendBankAddr1)
                {
                }
                textelement(VendBankAddr2)
                {
                }
                textelement(ISText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ISText := 'IS@';
                    end;
                }
                textelement(VendBankAccSwiftCode)
                {
                }
                textelement(VendBankClearingStandard)
                {
                }
                textelement(VendBankCleaingCode)
                {
                }
                textelement(VendBankPhoneNo)
                {
                }
                textelement(VendBankContact)
                {
                }
                textelement(VendBankBranchNo)
                {
                }
                textelement(VendBankTransitNo)
                {
                }
                textelement(SHRText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SHRText := 'SHR@@@@@@@@@@@@@';
                    end;
                }
                textelement(VendName35)
                {
                }
                textelement(INTText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        INTText := 'INT@@@@';
                    end;
                }
                textelement(VendBankAccEmail)
                {
                }
                tableelement(VendLedgerEntry; "Vendor Ledger Entry")
                {
                    LinkTable = GenJnlLine;
                    SourceTableView = sorting("Vendor No.");

                    textelement(InvText)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            i += 1;

                            if i = 1 then begin
                                Ch10 := 10;
                                InvText := Format(Ch10) + 'INV@Invoice ';
                            end else
                                InvText := 'INV@Invoice ';
                        end;
                    }
                    textelement(AppliedInvNo)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if VendLedgerEntry."External Document No." <> '' then begin
                                AppliedInvNo := VendLedgerEntry."External Document No.";
                            end else
                                AppliedInvNo := VendLedgerEntry."Document No.";

                            if AppliedInvNo = '' then
                                CurrXMLport.Skip();
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then
                            VendLedgerEntry.SetRange("Vendor No.", GenJnlLine."Account No.")
                        else begin
                            if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account" then begin
                                if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then
                                    VendLedgerEntry.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
                            end else
                                VendLedgerEntry.SetRange("Vendor No.", GenJnlLine."Account No."); //Let it no data
                        end;

                        if GenJnlLine."Applies-to ID" <> '' then begin
                            VendLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendLedgerEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                        end;
                        if GenJnlLine."Applies-to Doc. No." <> '' then
                            VendLedgerEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if (GenJnlLine."Applies-to ID" = '') and (GenJnlLine."Applies-to Doc. No." = '') then
                            CurrXMLport.Skip();
                    end;
                }

                trigger OnPreXMLItem()
                begin
                end;

                trigger OnAfterGetRecord()
                begin
                    TempGenJnlLine.DeleteAll();
                    i := 0;

                    case GenJnlLine."Account Type" of
                        GenJnlLine."Account Type"::Vendor:
                            begin
                                if GenJnlLine."Bal. Account No." <> '' then begin
                                    TempGenJnlLine := GenJnlLine;
                                    TempGenJnlLine.Insert();

                                    InsertInfoToFile(TempGenJnlLine);
                                end else begin
                                    GenJnlLine1.SetCurrentKey("Document No.");
                                    GenJnlLine1.SetRange("Document No.", GenJnlLine."Document No.");
                                    GenJnlLine1.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                                    GenJnlLine1.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                                    GenJnlLine1.SetRange("Account Type", GenJnlLine."Account Type"::"Bank Account");
                                    if GenJnlLine1.FindFirst() then begin
                                        TempGenJnlLine := GenJnlLine;
                                        TempGenJnlLine."Account Type" := TempGenJnlLine."Account Type"::"Bank Account";
                                        TempGenJnlLine."Bal. Account No." := GenJnlLine1."Account No.";
                                        TempGenJnlLine."Currency Code" := GenJnlLine1."Currency Code";
                                        TempGenJnlLine.Validate(Amount, -GenJnlLine1.Amount);
                                        TempGenJnlLine.Insert();

                                        InsertInfoToFile(TempGenJnlLine);
                                    end else
                                        Error('Please apply balance account for bank!');
                                end;
                            end;
                        GenJnlLine."Account Type"::"Bank Account":
                            begin
                                if (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) then begin
                                    GenJnlLine.Testfield("Bal. Account No.");
                                    TempGenJnlLine := GenJnlLine;
                                    TempGenJnlLine."Account Type" := GenJnlLine."Bal. Account Type";
                                    TempGenJnlLine."Account No." := GenJnlLine."Bal. Account No.";
                                    TempGenJnlLine."Bal. Account Type" := GenJnlLine."Account Type";
                                    TempGenJnlLine."Bal. Account No." := GenJnlLine."Account No.";
                                    TempGenJnlLine.Amount := -GenJnlLine.Amount;
                                    TempGenJnlLine."Amount (LCY)" := -GenJnlLine."Amount (LCY)";
                                    TempGenJnlLine.Insert();

                                    InsertInfoToFile(TempGenJnlLine);
                                end;
                            end;
                    end;

                    if not TempGenJnlLine.FindSet() then
                        CurrXMLport.Skip();
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        CompanyInfo.Get();
        GLSetup.Get();
    end;

    procedure InsertInfoToFile(var TempGenJnlLine: Record "Gen. Journal Line" temporary)
    begin
        InitInfo();

        if (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::"Bank Account") and (TempGenJnlLine."Bal. Account No." <> '') then begin
            TempGenJnlLine.Testfield(Amount);

            BankAcc.Get(TempGenJnlLine."Bal. Account No.");
            BalBankAccNo := BankAcc."Bank Account No." + '@';
            Amt := Format(TempGenJnlLine.Amount) + '@@';
            BalBankAccNo := BankAcc."Bank Account No." + '@';
        end;

        Amt := Format(TempGenJnlLine.Amount) + '@@';
        Amt := DelChr(Amt, '=', ',');//to remove ',' from amount 

        case TempGenJnlLine."Account Type" of
            TempGenJnlLine."Account Type"::Vendor:
                begin
                    if Vendor.Get(TempGenJnlLine."Account No.") then begin
                        Vendor.TestField(Name);
                        Vendor.TestField(Address);
                        Vendor.TestField("Phone No.");

                        VendName35 := CopyStr(Vendor.Name, 1, 35) + '@';
                        VendName35a := CopyStr(Vendor.Name, 1, 35) + '@';
                        VendAddr1 := '@';
                        VendCityPostCode := '@';
                        VendPhoneNo := '@@';

                        if VendorBankAcc.Get(Vendor."No.", Vendor."Preferred Bank Account Code") then begin
                            VendorBankAcc.TestField("SWIFT Code");
                            VendorBankAcc.TestField("E-Mail");
                            VendorBankAcc.TestField(Address);
                            VendorBankAcc.TestField("Address 2");
                            VendorBankAcc.TestField("Bank Clearing Standard");
                            VendorBankAcc.TestField("Bank Clearing Code");
                            VendorBankAcc.TestField("Transit No.");

                            VendBankAccNo := VendorBankAcc."Bank Account No." + '@@';
                            VendBankAccName := '@';
                            VendBankAddr1 := '@';
                            VendBankAddr2 := '@@';
                            VendBankAccSwiftCode := VendorBankAcc."SWIFT Code" + '@@@@@@@@@@@@@@@';
                            VendBankClearingStandard := VendorBankAcc."Bank Clearing Standard" + '@';
                            VendBankCleaingCode := VendorBankAcc."Bank Clearing Code" + '@';
                            VendBankPhoneNo := VendorBankAcc."Phone No." + '@';
                            VendBankContact := VendorBankAcc.Contact + '@';
                            VendBankBranchNo := VendorBankAcc."Bank Branch No." + '@';
                            VendBankTransitNo := VendorBankAcc."Transit No." + '@@@@@@';
                            VendBankAccEmail := VendorBankAcc."E-Mail" + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
                        end;
                    end;
                end;
        end;
    end;

    procedure InitInfo()
    begin
        Amt := '';
        BalBankAccNo := '';
        VendName35 := '';
        VendName35a := '';
        VendAddr1 := '';
        VendCityPostCode := '';
        VendPhoneNo := '';
        VendBankAccNo := '';
        VendBankAccName := '';
        VendBankAddr1 := '';
        VendBankAddr2 := '';
        VendBankAccSwiftCode := '';
        VendBankClearingStandard := '';
        VendBankCleaingCode := '';
        VendBankPhoneNo := '';
        VendBankContact := '';
        VendBankBranchNo := '';
        VendBankTransitNo := '';
        VendBankAccEmail := '';
    end;

    var
        CompanyInfo: Record "Company Information";
        BankAcc: Record "Bank Account";
        GLSetup: Record "General Ledger Setup";
        GenJnlLine1: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        Vendor: Record Vendor;
        VendorBankAcc: Record "Vendor Bank Account";
        Ch10: Char;
        i: Integer;
}