report 70038 "I9G_TaxReport"
{
    DefaultRenderingLayout = "Novem - Item Tax Report";
    ApplicationArea = All;
    Caption = 'Item Tax Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Header; "VAT Product Posting Group")
        {
            DataItemTableView = sorting(Code) order(Ascending);
            RequestFilterFields = "Code";
            column(CompanyLogo; CompanyInformationRec.Picture) { }
            column(CompanyName; CompanyInformationRec.Name) { }
            column(PeriodFrom; PeriodFrom) { }
            column(PeriodTo; PeriodTo) { }
            column(ReportTitle; RptTitle) { }
            column(DateFilter; DateFilter) { }
            column(TaxCodeFilter; TaxCodeFilter) { }
            column(CodeCaption; CodeCaption) { }
            column(NameCaption; NameCaption) { }
            column(GrandVATBaseAmount; GrandVATBaseAmount) { }
            column(GrandVATAmount; GrandVATAmount) { }
            column(GrandVATTotalAmount; GrandVATTotalAmount) { }
            column(HeaderCode; Code) { }
            dataitem(Loop; Integer)
            {
                column(LinePartyCode; PartyCode) { }
                column(LinePartyName; PartyName) { }
                column(LinePostingDate; PostingDate) { }
                column(LineDocNo; DocNo) { }
                column(LineDocType; DocType) { }
                column(LineVATCode; VATCode) { }
                column(LineVATRate; VATRate) { }
                column(LineTotalAmount; TotalAmount) { }
                column(LineVATBaseAmount; VATBaseAmount) { }
                column(LineVATAmount; VATAmount) { }
                column(LineVATRegNo; VATRegNo) { }
                column(LineGroupPeriod; GroupPeriod) { }

                trigger OnAfterGetRecord()
                begin
                    if ReportBreak then begin
                        CurrReport.Break();
                    end else begin
                        PartyCode := VATEntry."Bill-to/Pay-to No.";
                        DocNo := VATEntry."Document No.";

                        if (VATEntry."Source Code" = 'CASHRECJNL') or (VATEntry."Source Code" = 'PAYMENTJNL') then begin
                            PostGenJlnLn.Reset();
                            PostGenJlnLn.SetRange("Document No.", VATEntry."Document No.");
                            PostGenJlnLn.SetRange("VAT Base Amount (LCY)", VATEntry.Base);
                            if PostGenJlnLn.FindFirst() then begin
                                PartyName := PostGenJlnLn.I9G_AccountDetails;
                            end;
                        end
                        else begin
                            if VATEntry.Type = VATEntry.Type::Sale then begin
                                case VATEntry."Document Type" of
                                    VATEntry."Document Type"::"Credit Memo":
                                        begin
                                            if SalesCrHeader.GET(DocNo) then
                                                PartyName := SalesCrHeader."Bill-to Name";
                                        end;
                                    VATEntry."Document Type"::Invoice:
                                        begin
                                            if SalesInvHeader.GET(DocNo) then
                                                PartyName := SalesInvHeader."Bill-to Name";
                                        end;
                                    else
                                        if Cust.GET(PartyCode) then begin
                                            PartyName := Cust.Name;
                                        end;
                                end;
                            end else begin
                                case VATEntry."Document Type" of
                                    VATEntry."Document Type"::"Credit Memo":
                                        begin
                                            if PurcCrHeader.GET(DocNo) then
                                                PartyName := PurcCrHeader."Pay-to Name";
                                        end;
                                    VATEntry."Document Type"::Invoice:
                                        begin
                                            if PurcInvHeader.GET(DocNo) then
                                                PartyName := PurcInvHeader."Pay-to Name";
                                        end;
                                    else
                                        if Vend.GET(PartyCode) then begin
                                            PartyName := Vend.Name;
                                        end;
                                end;
                            end;
                        end;
                        PostingDate := VATEntry."Posting Date";
                        DocType := GetDocType(VATEntry.Type, VATEntry."Document Type");
                        VATCode := Header.Code;
                        if VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group") then
                            VATRate := VATPostingSetup."VAT %"
                        else
                            VATRate := 0;

                        if VATEntry.Type = VATEntry.Type::Sale then
                            MultiplyValue := -1
                        else
                            MultiplyValue := 1;



                        if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Full VAT" then begin
                            TotalAmount := VATEntry.Amount * MultiplyValue;
                            VATBaseAmount := VATEntry.I9G_GSTBaseAmount * MultiplyValue;
                        end else begin
                            TotalAmount := (VATEntry.Base + VATEntry.Amount) * MultiplyValue;
                            VATBaseAmount := VATEntry.Base * MultiplyValue;
                        end;

                        VATAmount := VATEntry.Amount * MultiplyValue;
                        VATRegNo := VATEntry."VAT Registration No.";
                        GroupPeriod := FORMAT(VATEntry."Posting Date", 0, '<Year4>-<Month,2>');

                        VATAmountLine.Reset();
                        VATAmountLine.SetRange("VAT Identifier", VATCode);
                        VATAmountLine.SetRange("VAT Calculation Type", VATEntry."VAT Calculation Type");
                        if VATAmountLine.FindFirst() then begin
                            VATAmountLine."VAT Base" := VATAmountLine."VAT Base" + VATBaseAmount;
                            VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" + TotalAmount;
                            VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" + VATAmount;
                            VATAmountLine.Modify();
                        end else begin
                            VATAmountLine.INIT;
                            VATAmountLine."VAT Identifier" := VATCode;
                            VATAmountLine."VAT Calculation Type" := VATEntry."VAT Calculation Type";
                            VATAmountLine."VAT %" := VATRate;
                            VATAmountLine."VAT Base" := VATBaseAmount;
                            VATAmountLine."Amount Including VAT" := TotalAmount;
                            VATAmountLine."VAT Amount" := VATAmount;
                            VATAmountLine.Insert();
                        end;
                    end;
                    if VATEntry.NEXT = 0 then
                        ReportBreak := TRUE;
                end;

                trigger OnPreDataItem()
                begin
                    RecordCount := 0;
                    ReportBreak := FALSE;
                end;
            }
            dataitem(VATCounter; Integer)
            {
                column(VATAmtNumber; Number) { }
                column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                {
                    AutoFormatType = 1;
                }
                column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                {
                    AutoFormatType = 1;
                }
                column(VATAmtLineAmountIncludeVAT; VATAmountLine."Amount Including VAT")
                {
                    AutoFormatType = 1;
                }
                column(VATAmtLineVATRate; VATAmountLine."VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATAmtLineVATCode; VATAmountLine."VAT Identifier") { }

                trigger OnAfterGetRecord()
                begin
                    VATAmountLine.GetLine(Number);
                    if Number = 1 then
                        VATAmountLine.FINDSET
                    else
                        VATAmountLine.NEXT;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, VATAmountLine.COUNT);
                    CurrReport.CREATETOTALS(VATAmountLine."Amount Including VAT", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                VATEntry.RESET;
                VATEntry.SETFILTER("Posting Date", '%1..%2', PeriodFrom, PeriodTo);
                VATEntry.SETFILTER(Type, '%1', TypeSelection);
                VATEntry.SETFILTER("VAT Prod. Posting Group", Header.Code);
                DateFilter := VATEntry.GETFILTER("Posting Date");
                if VATEntry.FIND('-') then
                    RecordCount := VATEntry.COUNT
                else
                    CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            var
            begin
                clear(PartyCode);
                Clear(PartyName);
                if PeriodFrom = 0D then
                    PeriodFrom := CALCDATE('<-CY>', TODAY);
                if PeriodTo = 0D then
                    PeriodTo := TODAY;
                if TypeFilter = TypeFilter::Sale then begin
                    TypeSelection := VATEntry.Type::Sale.AsInteger();
                    RptTitle := Text001;
                    CodeCaption := Text003;
                    NameCaption := Text004;
                    MultiplyValue := -1
                end
                else begin
                    TypeSelection := VATEntry.Type::Purchase.AsInteger();
                    RptTitle := Text002;
                    CodeCaption := Text005;
                    NameCaption := Text006;
                    MultiplyValue := 1
                end;
                VATEntry.RESET;
                VATEntry.SETFILTER("Posting Date", '%1..%2', PeriodFrom, PeriodTo);
                VATEntry.SETFILTER(Type, '%1', TypeSelection);
                VATEntry.SETFILTER("VAT Prod. Posting Group", '<>%1', '');
                TaxCodeFilter := Header.GETFILTER(Code);
                if TaxCodeFilter = '' then
                    TaxCodeFilter := 'All Codes'
                else
                    VATEntry.SETFILTER("VAT Prod. Posting Group", TaxCodeFilter);
                DateFilter := VATEntry.GETFILTER("Posting Date");

                VATEntry.SetFilter("VAT Calculation Type", '<> %1', VATEntry."VAT Calculation Type"::"Full VAT");
                VATEntry.CALCSUMS(VATEntry.Amount, VATEntry.Base);
                GrandVATBaseAmount := VATEntry.Base * MultiplyValue;
                GrandVATAmount := VATEntry.Amount * MultiplyValue;
                GrandVATTotalAmount := GrandVATBaseAmount + GrandVATAmount;

                VATEntry.SetFilter("VAT Calculation Type", '%1', VATEntry."VAT Calculation Type"::"Full VAT");
                VATEntry.CALCSUMS(VATEntry.Amount, VATEntry.I9G_GSTBaseAmount);
                GrandVATBaseAmount := GrandVATBaseAmount + (VATEntry.I9G_GSTBaseAmount * MultiplyValue);
                GrandVATAmount := GrandVATAmount + (VATEntry.Amount * MultiplyValue);
                GrandVATTotalAmount := GrandVATTotalAmount + (VATEntry.Amount * MultiplyValue);

                VATEntry.SetRange("VAT Calculation Type");
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
                field(PeriodFrom; PeriodFrom)
                {
                    ApplicationArea = all;
                    Caption = 'Period From';
                }
                field(PeriodTo; PeriodTo)
                {
                    ApplicationArea = all;
                    Caption = 'Period To';
                }
                field(TypeFilter; TypeFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Document Type';
                }
            }
        }
    }

    rendering
    {
        layout("Novem - Item Tax Report")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70038-TaxReport.rdl';
        }
    }

    trigger OnPreReport()
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
    end;

    var
        CompanyInformationRec: Record "Company Information";
        Cust: Record Customer;
        Vend: Record Vendor;
        InvHeader: Record "Sales Invoice Header";
        VATEntry: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        PurcInvHeader: Record "Purch. Inv. Header";
        PurcCrHeader: Record "Purch. Cr. Memo Hdr.";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrHeader: Record "Sales Cr.Memo Header";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PostGenJlnLn: Record "Posted Gen. Journal Line";
        DateFilter: Text;
        TaxCodeFilter: Text;
        CompName: Text[50];
        CompAddr1: Text[50];
        CompAddr2: Text[50];
        CompRegNo: Text[20];
        CompVATNo: Text[20];
        CompCity: Text[50];
        CompPostCode: Text[50];
        CompCounty: Text[30];
        PartyCode: Text[20];
        PartyName: Text[100];
        PostingDate: Date;
        DocNo: Text[50];
        DocType: Text[10];
        VATCode: Text[10];
        VATRate: Decimal;
        TotalAmount: Decimal;
        VATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATRegNo: Text[30];
        PeriodFrom: Date;
        PeriodTo: Date;
        Text001: Label 'Sales Item Tax Tracking';
        Text002: Label 'Purchase Item Tax Tracking';
        RptTitle: Text[100];
        RecordCount: Integer;
        ReportBreak: Boolean;
        MultiplyValue: Integer;
        GroupPeriod: Text[7];
        AccPeriod: Record "Accounting Period";
        TypeFilter: Option Sale,Purchase;
        TypeSelection: Integer;
        Text003: Label 'Customer No.';
        Text004: Label 'Customer Name';
        Text005: Label 'Vendor No.';
        Text006: Label 'Vendor Name';
        CodeCaption: Text[20];
        NameCaption: Text[20];
        GrandVATBaseAmount: Decimal;
        GrandVATAmount: Decimal;
        GrandVATTotalAmount: Decimal;
        SumVATCode: Text[10];
        SumTotalAmount: Decimal;
        SumVATBaseAmount: Decimal;
        SumVATAmount: Decimal;

    procedure GetDocType(EntryType: Enum "General Posting Type"; EntryDocType: Enum "Gen. Journal Document Type") RetDocType: Text[30]
    begin
        if (EntryType = VATEntry.Type::Sale) AND (EntryDocType = VATEntry."Document Type"::Invoice) then
            RetDocType := 'AR-IN';
        if (EntryType = VATEntry.Type::Sale) AND (EntryDocType = VATEntry."Document Type"::"Credit Memo") then
            RetDocType := 'AR-CR';
        if (EntryType = VATEntry.Type::Purchase) AND (EntryDocType = VATEntry."Document Type"::Invoice) then
            RetDocType := 'AP-IN';
        if (EntryType = VATEntry.Type::Purchase) AND (EntryDocType = VATEntry."Document Type"::"Credit Memo") then
            RetDocType := 'AP-CR';
    end;
}
