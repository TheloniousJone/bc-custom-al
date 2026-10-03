
xmlport 52152 "Citibank Payroll"
{
    Caption = 'Citibank Payroll';
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
                RequestFilterFields = "Journal Template Name", "Journal Batch Name";
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
                textelement(EmployeeName20)
                {
                }
                textelement(EmployeeBankAccountNo)
                {
                }
                textelement(EmployeeBankBranchNo)
                {
                }
                textelement(ISText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ISText := 'IS@';
                    end;
                }
                textelement(EmployeeSwiftCode)
                {
                }
                textelement(EmployeeName35)
                {
                }
                textelement(INTText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        INTText := 'INT@@@';
                    end;
                }
                textelement(EmployeePrivateEmail)
                {
                }
                tableelement(EmployeeLedgerEntry; "Employee Ledger Entry")
                {
                    LinkFields = "Document No." = field("Document No.");
                    LinkTable = GenJnlLine;
                    SourceTableView = SORTING("Employee No.");

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
                            AppliedInvNo := EmployeeLedgerEntry."Document No.";
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee then
                            EmployeeLedgerEntry.SetRange("Employee No.", GenJnlLine."Account No.")
                        else begin
                            if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account" then begin
                                if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Employee then
                                    EmployeeLedgerEntry.SetRange("Employee No.", GenJnlLine."Bal. Account No.");
                            end else
                                EmployeeLedgerEntry.SetRange("Employee No.", GenJnlLine."Account No."); //Let it no data
                        end;

                        if GenJnlLine."Applies-to ID" <> '' then begin
                            EmployeeLedgerEntry.SetCurrentKey("Employee No.", "Applies-to ID");
                            EmployeeLedgerEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                        end;
                        if GenJnlLine."Applies-to Doc. No." <> '' then
                            EmployeeLedgerEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                    end;

                    trigger OnAfterGetRecord()
                    begin
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
                        GenJnlLine."Account Type"::Employee:
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
                                if (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Employee) then begin
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
            TempGenJnlLine."Account Type"::Employee:
                begin
                    if Employee.Get(TempGenJnlLine."Account No.") then begin
                        Employee.TestField("First Name");
                        Employee.TestField("Bank Account No.");
                        Employee.TestField("Bank Branch No.");
                        Employee.TestField("SWIFT Code");
                        Employee.TestField("E-Mail");

                        EmployeeName20 := CopyStr(Employee."First Name", 1, 20) + '@@@@@';
                        EmployeeName35 := CopyStr(Employee."First Name", 1, 35) + '@';
                        EmployeeBankAccountNo := Employee."Bank Account No." + '@@';
                        EmployeeBankBranchNo := '@@@@';
                        EmployeeSwiftCode := Employee."SWIFT Code" + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
                        EmployeePrivateEmail := Employee."E-Mail" + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
                    end;
                end;
        end;
    end;

    procedure InitInfo()
    begin
        Amt := '';
        BalBankAccNo := '';
        EmployeeName20 := '';
        EmployeeName35 := '';
        EmployeeBankAccountNo := '';
        EmployeeBankBranchNo := '';
        EmployeeSwiftCode := '';
        EmployeePrivateEmail := '';
    end;

    var
        CompanyInfo: Record "Company Information";
        BankAcc: Record "Bank Account";
        Employee: Record Employee;
        GLSetup: Record "General Ledger Setup";
        GenJnlLine1: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        Ch10: Char;
        i: Integer;
}