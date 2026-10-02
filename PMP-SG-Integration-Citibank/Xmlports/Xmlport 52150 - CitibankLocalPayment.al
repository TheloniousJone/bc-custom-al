xmlport 52150 "Citibank Local Payment"
{
    Caption = 'Citibank Local Payment';
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
                        TextPLG := 'PLG@';
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
                        CompanyInfoName := CompanyInfo.Name + '@@@@@@';
                    end;
                }
                textelement(VendName20)
                {
                }
                textelement(VendBankAccNo)
                {
                }
                textelement(VendBankAccName)
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
                textelement(VendName35)
                {
                }
                textelement(INTText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        INTText := 'INT@@@';
                    end;
                }
                textelement(FinanceText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        FinanceText := 'Finance@';
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
                                        TempGenJnlLine.Amount := -GenJnlLine1.Amount;
                                        TempGenJnlLine."Amount (LCY)" := -GenJnlLine1."Amount (LCY)";
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
        Amt := DelChr(Amt, '=', ',');
        case TempGenJnlLine."Account Type" of
            TempGenJnlLine."Account Type"::Vendor:
                begin
                    if Vendor.Get(TempGenJnlLine."Account No.") then begin
                        Vendor.Testfield(Name);
                        Vendor.Testfield("Preferred Bank Account Code");
                        VendName20 := CopyStr(Vendor.Name, 1, 20) + '@@@@@';
                        VendName35 := CopyStr(Vendor.Name, 1, 35) + '@';

                        if VendorBankAcc.Get(Vendor."No.", Vendor."Preferred Bank Account Code") then begin
                            VendorBankAcc.TestField("Bank Account No.");
                            VendorBankAcc.TestField(Name);
                            VendorBankAcc.TestField("SWIFT Code");
                            VendorBankAcc.TestField("E-Mail");

                            VendBankAccNo := VendorBankAcc."Bank Account No." + '@@';
                            VendBankAccName := '@@@@';
                            VendBankAccEmail := VendorBankAcc."E-Mail" + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
                            VendBankAccSwiftCode := VendorBankAcc."SWIFT Code" + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
                        end;
                    end;
                end;
        end;
    end;

    procedure InitInfo()
    begin
        Amt := '';
        BalBankAccNo := '';
        VendName20 := '';
        VendName35 := '';
        VendBankAccNo := '';
        VendBankAccName := '';
        VendBankAccEmail := '';
        VendBankAccSwiftCode := '';
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