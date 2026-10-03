report 70039 "I9G_IncomingPaymentListing"
{
    DefaultRenderingLayout = "Novem - Incoming Payment Listing";
    ApplicationArea = All;
    Caption = 'Incoming Payment Listing';

    dataset
    {
        dataitem("GLEntry"; "G/L Entry")
        {
            DataItemTableView = sorting("Document No.", "Posting Date") where("Document Type" = const(Payment), "Source Type" = filter(Customer | "Bank Account"), "Bal. Account Type" = filter("Bank Account"), Amount = filter(> 0));
            RequestFilterFields = "Document No.";
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(DocumentNo; "Document No.") { }
            column(PostingDate; Format("Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(AccountType; "Source Type") { }
            column(AccountCode; "Source No.") { }
            column(AccountName; AccountName) { }
            column(ChequeDetails; I9G_ChequeDetails) { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(Amount; Abs(Amount)) { }
            column(SNNo; SNNo) { }
            column(TotalAmount; TotalAmount) { }
            trigger OnPreDataItem()
            var
            begin
                SetFilter("Posting Date", FilterDate);
                Clear(SNNo);
                Clear(TotalAmount);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                SNNo += 1;
                TotalAmount += GLEntry.Amount;
                Clear(AccountName);
                if GLEntry."Source Type" = GLEntry."Source Type"::Customer then begin
                    CustomerRec.Reset();
                    if CustomerRec.Get(GLEntry."Source No.") then begin
                        AccountName := CustomerRec.Name;
                    end;
                end else if GLEntry."Source Type" = GLEntry."Source Type"::"Bank Account" then begin
                    BankAccountRec.Reset();
                    BankAccountRec.SetRange("No.", GLEntry."Source No.");
                    if BankAccountRec.FindFirst() then begin
                        AccountName := BankAccountRec.Name;
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(FilterDate; FilterDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date Range Filter';
                        ToolTip = 'Specifies the value of the Date Range filter field.';
                        ShowMandatory = true;
                        NotBlank = true;
                        trigger OnValidate()
                        var
                            FilterTokensCodeUnit: Codeunit "Filter Tokens";
                        begin
                            FilterTokensCodeUnit.MakeDateFilter(FilterDate);
                        end;
                    }
                }
            }
        }
    }
    rendering
    {
        layout("Novem - Incoming Payment Listing")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70039-IncomingPaymentListing.rdl';
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        FilterDate: Text;
        CustomerRec: Record Customer;
        BankAccountRec: Record "Bank Account";
        AccountName: Text[250];
        SNNo: Integer;
        TotalAmount: Decimal;
}