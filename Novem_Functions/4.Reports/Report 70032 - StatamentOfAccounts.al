report 70032 I9G_StatementofAccount
{
    DefaultRenderingLayout = "Novem - Statement of Account";
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Statement of Account';

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            DataItemTableView = sorting("No.") order(ascending);
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(CompanyAddress; CompanyInformationRec.Address) { }
            column(CompanyAddress2; CompanyInformationRec."Address 2") { }
            column(CompanyTelePhone; CompanyInformationRec."Phone No.") { }
            column(CompanyFaxNo; CompanyInformationRec."Fax No.") { }
            column(CompanyRegNo; CompanyInformationRec."Registration No.") { }
            column(CompanyGSTRegNo; CompanyInformationRec."VAT Registration No.") { }
            column(CustomerNo; "No.") { }
            column(CustomerName; CustomerName) { }
            column(CustomerAddress; CustomerAddress1) { }
            column(CustomerAddress2; CustomerAddress2) { }
            column(CustomerAddress3; CustomerAddress3) { }
            column(CustomerAddress4; CustomerAddress4) { }
            column(CustomerInfo1; CustomerInfo[1]) { }
            column(CustomerInfo2; CustomerInfo[2]) { }
            column(CustomerInfo3; CustomerInfo[3]) { }
            column(CustomerInfo4; CustomerInfo[4]) { }
            column(CustomerInfo5; CustomerInfo[5]) { }
            column(CustomerInfo6; CustomerInfo[6]) { }
            column(CustomerInfo7; CustomerInfo[7]) { }
            column(AttenTo; Contact) { }
            column(PaymentTerms; "Payment Terms Code") { }
            column(CurrencyCode; CurrencyCode) { }
            column(AgingDate; Format(FilterAgingAsOfDate, 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
            column(HeaderText1; HeaderText[1]) { }
            column(HeaderText2; HeaderText[2]) { }
            column(HeaderText3; HeaderText[3]) { }
            column(HeaderText4; HeaderText[4]) { }
            column(HeaderText5; HeaderText[5]) { }
            column(HeaderText6; HeaderText[6]) { }
            column(StatementFooter; SalesReceivablesSetupRec.I9G_StatementFooter) { }
            column(Skip0Amt; Skip0Amt) { }
            column(Hide0Amt; Hide0Amt) { }
            dataitem(CustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Posting Date", Open) order(ascending);
                column(DueDate; Format(CustLedgerEntry."Due Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
                column(PostingDate; Format(CustLedgerEntry."Posting Date", 0, '<Closing><Day,2>/<Month,2>/<Year>')) { }
                column(DocumentType; CustLedgerEntry."Document Type") { }
                column(DocumentNo; CustLedgerEntry."Document No.") { }
                column(DocumentRefNo; DocumentRefNo) { }
                column(DebitAmount; Debit) { }
                column(CreditAmount; Credit) { }
                column(OriginalAmount; CustLedgerEntry."Original Amount") { }
                column(RemainingAmount; RemainingAmount) { }
                column(AgingAmount1; AgingAmount[1]) { }
                column(AgingAmount2; AgingAmount[2]) { }
                column(AgingAmount3; AgingAmount[3]) { }
                column(AgingAmount4; AgingAmount[4]) { }
                column(AgingAmount5; AgingAmount[5]) { }
                column(AgingAmount6; AgingAmount[6]) { }
                column(OutputString; OutputString) { }
                column(AmountLCY; CustLedgerEntry."Amount (LCY)") { }
                column(RemainingAmtLCY; CustLedgerEntry."Remaining Amt. (LCY)") { }
                column(CustLedgEnt_CustomerNo; "Customer No.") { }
                column(Remarks; I9G_Remarks) { }
                column(Balance; Balance) { }

                trigger OnPreDataItem()
                begin
                    SetFilter(CustLedgerEntry."Posting Date", '..%1', FilterAgingAsOfDate);
                    Clear(NoofDays);
                    Clear(AgingAmount);
                    Clear(Balance);
                end;

                trigger OnAfterGetRecord()
                var
                    MonthInteger: Integer;
                begin
                    CalcFields("Original Amount", "Original Amt. (LCY)", Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)");

                    Clear(Debit);
                    Clear(Credit);
                    Clear(RemainingAmount);

                    if (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Payment) or
                        (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice) then begin
                        if (CustLedgerEntry."Remaining Amount" < CustLedgerEntry."Amount (LCY)") and ("Remaining Amt. (LCY)" > 0) then begin
                            if CustLedgerEntry."Amount (LCY)" < 0 then begin
                                Debit := 0;
                                Credit := Abs("Amount (LCY)");
                            end;

                            if CustLedgerEntry."Amount (LCY)" > 0 then begin
                                Debit := "Amount (LCY)";
                                Credit := 0;
                            end;

                            Balance += "Amount (LCY)";
                        end
                        else begin
                            if CustLedgerEntry."Remaining Amount" < 0 then begin
                                Debit := 0;
                                Credit := Abs("Remaining Amount");
                            end;

                            if CustLedgerEntry."Remaining Amount" > 0 then begin
                                Debit := "Remaining Amount";
                                Credit := 0;
                            end;

                            Balance += "Remaining Amount";
                        end;
                    end
                    else begin
                        if CustLedgerEntry."Remaining Amount" < 0 then begin
                            Debit := 0;
                            Credit := Abs("Remaining Amount");
                        end;

                        if CustLedgerEntry."Remaining Amount" > 0 then begin
                            Debit := "Remaining Amount";
                            Credit := 0;
                        end;

                        Balance += "Remaining Amount";
                    end;

                    CheckDetailedCustLedgEnt(CustLedgerEntry);

                    Clear(DocumentRefNo);
                    if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
                        SIHdr.Reset();
                        SIHdr.SetRange("No.", CustLedgerEntry."Document No.");
                        if SIHdr.FindFirst() then begin
                            DocumentRefNo := SIHdr."External Document No.";
                        end;
                    end;

                    if Balance <> 0 then begin
                        Hide0Amt := false;
                    end
                    else begin
                        if Skip0Amt = true then
                            Hide0Amt := true
                        else
                            Hide0Amt := false
                    end;

                    Clear(MonthInteger);
                    MonthInteger := Date2DMY(CustLedgerEntry."Posting Date", 2);
                    AgingAmount[1] += RemainingAmount;
                    if MonthInteger = MonthRange[2] then begin
                        AgingAmount[2] += RemainingAmount;
                    end else if MonthInteger = MonthRange[3] then begin
                        AgingAmount[3] += RemainingAmount;
                    end else if MonthInteger = MonthRange[4] then begin
                        AgingAmount[4] += RemainingAmount;
                    end else if MonthInteger = MonthRange[5] then begin
                        AgingAmount[5] += RemainingAmount;
                    end else
                        AgingAmount[6] += RemainingAmount;
                    Clear(NoText);
                    Clear(InputString);
                    Clear(OutputString);
                    Clear(n);
                    Clear(i);
                    ReportConverter.InitTextVariable;
                    ReportConverter.FormatNoText(NoText, Abs(AgingAmount[1]), CurrencyCode);
                    InputString := NoText[1] + ' ' + NoText[2] + ' ONLY';
                    n := STRLEN(InputString);
                    FOR i := 1 TO n DO
                        IF (InputString[i] = ' ') AND (i < n) THEN BEGIN
                            IF NOT (InputString[i + 1] IN [32 .. 47, 58 .. 63]) THEN
                                OutputString += FORMAT(InputString[i])
                        END ELSE
                            OutputString += FORMAT(InputString[i]);
                    OutputString := 'DOLLARS (' + CurrencyCode + ')' + ' : ' + UpperCase(DELCHR(OutputString, '<>', ' '));

                end;
            }
            trigger OnPreDataItem()
            var
            begin
                if FilterCustomerNo <> '' then
                    SetFilter("No.", FilterCustomerNo);
            end;

            trigger OnAfterGetRecord()
            var
                GeneralLedgerSetupRec: Record "General Ledger Setup";
                i: Integer;
            begin
                Clear(CurrencyCode);
                if Customer."Currency Code" = '' then begin
                    GeneralLedgerSetupRec.Get();
                    CurrencyCode := GeneralLedgerSetupRec."LCY Code";
                end else begin
                    CurrencyCode := Customer."Currency Code";
                end;

                Clear(CustomerInfo);

                CustomerInfo[1] := "No.";
                CustomerInfo[2] := Name;

                if I9G_UseForSOA = true then begin
                    CustomerInfo[3] := I9G_MailingClinicName;
                    CustomerInfo[4] := I9G_MailingAddress;
                    CustomerInfo[5] := I9G_MailingAddress2;
                    CustomerInfo[6] := I9G_MailingAddress3;
                    CustomerInfo[7] := I9G_MailingAttnTo;

                    // CustomerName := I9G_MailingClinicName;
                    // CustomerAddress1 := I9G_MailingAddress;
                    // CustomerAddress2 := I9G_MailingAddress2;
                    // CustomerAddress3 := I9G_MailingAddress3;
                    // CustomerAddress4 := I9G_MailingAttnTo;
                end else begin
                    // CustomerName := Customer.Name;
                    // CustomerAddress1 := Address;
                    // CustomerAddress2 := "Address 2";
                    // CustomerAddress3 := I9G_Adddress3;
                    // CustomerAddress4 := "Country/Region Code" + ' ' + "Post Code";                               

                    i := 3;

                    if "Name 2" <> '' then begin
                        CustomerInfo[i] := "Name 2";
                        i := i + 1;
                    end;

                    if Address <> '' then begin
                        CustomerInfo[i] := Address;
                        i := i + 1;
                    end;

                    if "Address 2" <> '' then begin
                        CustomerInfo[i] := "Address 2";
                        i := i + 1;
                    end;

                    if I9G_Adddress3 <> '' then begin
                        CustomerInfo[i] := I9G_Adddress3;
                        i := i + 1;
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
            area(Content)
            {
                group("Options")
                {
                    field(FilterAgingAsOfDate; FilterAgingAsOfDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging As Of Date';
                        ShowMandatory = true;
                        NotBlank = true;
                    }
                    field(FilterCustomerNo; FilterCustomerNo)
                    {
                        Caption = 'Customer Code';
                        Lookup = true;
                        DrillDown = true;
                        LookupPageId = "Customer Lookup";
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            CustomerRec: Record Customer;
                            CustomerLookupPage: Page "Customer Lookup";
                            I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
                            RecRef: RecordRef;
                        begin
                            clear(FilterCustomerNo);
                            CustomerLookupPage.SetTableView(CustomerRec);
                            CustomerLookupPage.LookupMode(true);
                            if CustomerLookupPage.RunModal() = Action::LookupOK then begin
                                CustomerLookupPage.SetSelectionFilter(CustomerRec);
                                RecRef.GetTable(CustomerRec);
                                FilterCustomerNo := I9G_NovemEventSubscribersCodeUnit.GetSelectionFilter(RecRef, CustomerRec.FieldNo("No."));
                            end;
                        end;
                    }
                    field(Skip0Amt; Skip0Amt)
                    {
                        ApplicationArea = All;
                        Caption = 'Skip 0 Amount';
                    }
                }
            }
        }
    }
    rendering
    {
        layout("Novem - Statement of Account")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70032-StatementofAccount.rdl';
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
        SalesReceivablesSetupRec.Get();
        CreateHeadings();
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
        DateRec: Record Date;
    begin
        HeaderText[1] := 'Balance Due';
        MonthRange[1] := 0;
        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
        DateRec.SetRange("Period No.", Date2DMY(FilterAgingAsOfDate, 2));
        if DateRec.FindFirst() then begin
            HeaderText[2] := DateRec."Period Name";
            MonthRange[2] := DateRec."Period No.";
        end;
        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
        DateRec.SetRange("Period No.", Date2DMY(CalcDate('-1M', FilterAgingAsOfDate), 2));
        if DateRec.FindFirst() then begin
            HeaderText[3] := DateRec."Period Name";
            MonthRange[3] := DateRec."Period No.";
        end;
        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
        DateRec.SetRange("Period No.", Date2DMY(CalcDate('-2M', FilterAgingAsOfDate), 2));
        if DateRec.FindFirst() then begin
            HeaderText[4] := DateRec."Period Name";
            MonthRange[4] := DateRec."Period No.";
        end;
        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
        DateRec.SetRange("Period No.", Date2DMY(CalcDate('-3M', FilterAgingAsOfDate), 2));
        if DateRec.FindFirst() then begin
            HeaderText[5] := DateRec."Period Name";
            MonthRange[5] := DateRec."Period No.";
        end;
        HeaderText[6] := StrSubstNo('Before %1', HeaderText[5]);
        MonthRange[6] := 0;
    end;

    procedure GetReportFilterText(par_FilterCustomerNo: Text)
    var
    begin
        FilterCustomerNo := par_FilterCustomerNo;
    end;

    procedure CheckDetailedCustLedgEnt(var CustLedgEnt: Record "Cust. Ledger Entry")
    var
        DetailedCustLedgEnt: Record "Detailed Cust. Ledg. Entry";
        total: Decimal;
        getPrev: Boolean;
    begin
        getPrev := false;
        case CustLedgerEntry."Document Type" of
            CustLedgerEntry."Document Type"::" ",
            CustLedgerEntry."Document Type"::Invoice,
            CustLedgerEntry."Document Type"::Payment:
                begin
                    if (CustLedgerEntry.Reversed = false) then begin
                        DetailedCustLedgEnt.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                        DetailedCustLedgEnt.SetAscending("Entry Type", true);
                        DetailedCustLedgEnt.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        DetailedCustLedgEnt.SetRange("Entry Type", DetailedCustLedgEnt."Entry Type"::Application);
                        DetailedCustLedgEnt.SetRange(Unapplied, false);
                        DetailedCustLedgEnt.SetFilter("Posting Date", '>%1', FilterAgingAsOfDate);
                        if DetailedCustLedgEnt.FindSet() then begin
                            repeat
                                if CustLedgerEntry."Amount (LCY)" = abs(DetailedCustLedgEnt."Amount (LCY)") then begin
                                    total := abs(DetailedCustLedgEnt."Amount (LCY)")
                                end
                                else begin
                                    total += Abs(DetailedCustLedgEnt."Amount (LCY)");
                                end;
                            until DetailedCustLedgEnt.Next() = 0;

                            getPrev := true;
                            RemainingAmount := total + CustLedgerEntry."Remaining Amount";
                        end
                        else begin
                            RemainingAmount := CustLedgerEntry."Remaining Amount";
                        end;
                    end
                    else begin
                        CurrReport.Skip();
                    end;
                end;
            CustLedgerEntry."Document Type"::"Credit Memo",
            CustLedgerEntry."Document Type"::Refund:
                begin
                    if (CustLedgerEntry.Reversed = false) then begin
                        DetailedCustLedgEnt.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                        DetailedCustLedgEnt.SetAscending("Entry Type", true);
                        DetailedCustLedgEnt.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        DetailedCustLedgEnt.SetRange("Entry Type", DetailedCustLedgEnt."Entry Type"::Application);
                        DetailedCustLedgEnt.SetRange(Unapplied, false);
                        DetailedCustLedgEnt.SetFilter("Posting Date", '>%1', FilterAgingAsOfDate);
                        if DetailedCustLedgEnt.FindSet() then begin
                            repeat
                                if CustLedgerEntry."Amount (LCY)" = abs(DetailedCustLedgEnt."Amount (LCY)") then begin
                                    total := 0
                                end
                                else begin
                                    total += DetailedCustLedgEnt."Amount (LCY)";
                                end;
                            until DetailedCustLedgEnt.Next() = 0;

                            getPrev := true;
                            RemainingAmount := -total + CustLedgerEntry."Remaining Amount";
                        end
                        else begin
                            RemainingAmount := CustLedgerEntry."Remaining Amount";
                        end;
                    end
                    else begin
                        CurrReport.Skip();
                    end;
                end;
        end;

        if (Debit = 0) and (Credit = 0) and (getPrev) then begin
            if CustLedgerEntry."Amount (LCY)" < 0 then begin
                Debit := 0;
                Credit := Abs(CustLedgerEntry."Amount (LCY)");
            end;

            if CustLedgerEntry."Amount (LCY)" > 0 then begin
                Debit := CustLedgerEntry."Amount (LCY)";
                Credit := 0;
            end;

            Balance += CustLedgerEntry."Amount (LCY)";
        end;
    end;

    var
        CompanyInformationRec: Record "Company Information";
        SalesReceivablesSetupRec:
                Record "Sales & Receivables Setup";
        ReportConverter:
                Report I9G_ReportConverter;
        FilterAgingAsOfDate:
                Date;
        FilterCustomerNo:
                Text[2048];
        CurrencyCode:
                Code[20];
        NoofDays:
                Integer;
        AgingAmount:
                array[6] of Decimal;
        HeaderText:
                array[6] of Text;
        MonthRange:
                array[6] of Integer;
        NoText:
                array[2] of Text[250];
        InputString, OutputString :
                Text[2400];
        n, i :
                integer;
        CustomerAddress1:
                Text[100];
        CustomerAddress2:
                Text[100];
        CustomerAddress3:
                Text[100];
        CustomerAddress4:
                Text[100];
        CustomerName:
                Text[200];
        CustomerInfo:
                array[7] of Text[100];
        Debit:
                Decimal;
        Credit:
                Decimal;
        Balance:
                Decimal;
        RemainingAmount:
                Decimal;
        Skip0Amt:
                Boolean;
        Hide0Amt:
                Boolean;
        SIHdr:
                Record "Sales Invoice Header";
        DocumentRefNo:
                Code[35];
}
