report 57024 "Statement of Account"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57024 - Statement of Account.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            //PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            //RequestFilterFields = "No.", "Currency Filter", "SOA Applicable", "Statement Group";
            column(No_Cust; "No.")
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(CoRegNoCaption; CoRegNoCaptionLbl)
            {
            }
            column(GSTRegNoCaption; GSTRegNoCaptionLbl)
            {
            }
            column(TelCaption; TelCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
            {
            }
            column(WebsiteCaption; WebsiteCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(StatementDateCaption; StatementDateCaptionLbl)
            {
            }
            column(AccountNumberCaption; AccountNumberCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(CurrencyCaption; CurrencyCaptionLbl)
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                //PrintOnlyIfDetail = true;
                column(CompanyInfo1Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyInfo3Picture; CompanyInfo3.Picture)
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo_CompanyInfo; CompanyInfo."Giro No.")
                {
                }
                column(BankName_CompanyInfo; CompanyInfo."Bank Name")
                {
                }
                column(BankAccNo_CompanyInfo; CompanyInfo."Bank Account No.")
                {
                }
                column(No1_Cust; Customer."No.")
                {
                }
                column(TodayFormatted; FORMAT(TODAY))
                {
                }
                column(StartDate; FORMAT(StartDate))
                {
                }
                column(EndDate; FORMAT(EndDate, 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(LastStatmntNo_Cust; FORMAT(Customer."Last Statement No."))
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyAddr7; CompanyAddr[7])
                {
                }
                column(CompanyAddr8; CompanyAddr[8])
                {
                }
                column(StatementCaption; StatementCaptionLbl)
                {
                }
                column(PhoneNo_CompanyInfoCaption; PhoneNo_CompanyInfoCaptionLbl)
                {
                }
                column(VATRegNo_CompanyInfoCaption; VATRegNo_CompanyInfoCaptionLbl)
                {
                }
                column(GiroNo_CompanyInfoCaption; GiroNo_CompanyInfoCaptionLbl)
                {
                }
                column(BankName_CompanyInfoCaption; BankName_CompanyInfoCaptionLbl)
                {
                }
                column(BankAccNo_CompanyInfoCaption; BankAccNo_CompanyInfoCaptionLbl)
                {
                }
                column(No1_CustCaption; No1_CustCaptionLbl)
                {
                }
                column(StartDateCaption; StartDateCaptionLbl)
                {
                }
                column(EndDateCaption; EndDateCaptionLbl)
                {
                }
                column(LastStatmntNo_CustCaption; LastStatmntNo_CustCaptionLbl)
                {
                }
                column(PostDate_DtldCustLedgEntriesCaption; PostDate_DtldCustLedgEntriesCaptionLbl)
                {
                }
                column(DocNo_DtldCustLedgEntriesCaption; DtldCustLedgEntries.FIELDCAPTION("Document No."))
                {
                }
                column(Desc_CustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION(Description))
                {
                }
                column(DueDate_CustLedgEntry2Caption; DueDate_CustLedgEntry2CaptionLbl)
                {
                }
                column(RemainAmtCustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION("Remaining Amount"))
                {
                }
                column(CustBalanceCaption; CustBalanceCaptionLbl)
                {
                }
                column(OriginalAmt_CustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION("Original Amount"))
                {
                }
                column(CompanyInfoHomepageCaption; CompanyInfoHomepageCaptionLbl)
                {
                }
                column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
                {
                }
                column(DocDateCaption; DocDateCaptionLbl)
                {
                }
                column(Total_Caption2; Total_CaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyInfo_Name; CompanyInfo.Name)
                {
                }
                column(CompanyInfo_Name2; CompanyInfo."Name 2")
                {
                }
                column(CompanyInfo_Address; CompanyInfo.Address)
                {
                }
                column(CompanyInfo_City; CompanyInfo.City)
                {
                }
                column(CompanyInfo_PostCode; CompanyInfo."Post Code")
                {
                }
                column(CompanyInfo_Country; CompanyInfo."Country/Region Code")
                {
                }
                column(CompanyInfo_CoRegNo; CompanyInfo."Registration No.")
                {
                }
                column(CompanyInfo_GSTRegNo; CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfo_FaxNo; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfo_Website; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfo_Email; CompanyInfo."E-Mail")
                {
                }
                column(Customer_Currency; CurrencyCode)
                {
                }
                column(Customer_Name; AddrArray[1])
                {
                }
                column(Customer_Address; AddrArray[2])
                {
                }
                column(Customer_Address2; AddrArray[3])
                {
                }
                //wx dtd 240520
                column(Customer_Address3; addrArray[4])
                {
                }
                column(Customer_Address4; '')
                {
                }

                column(PaymentTerm; Customer."Payment Terms Code")
                { }

                //wx dtd 240520
                //wx dtd 250520
                column(FwdAmt; FwdAmt)
                {
                    // AutoFormatType = 1;
                    // AutoFormatExpression = '$<precision, 2:2><standard format, 0>';
                    DecimalPlaces = 2;
                    AutoFormatType = 3;
                }
                //wx dtd 250520
                column(Customer_City; Customer.City)
                {
                }
                column(Customer_PostCode; Customer."Post Code")
                {
                }
                column(Customer_Country; Customer."Country/Region Code")
                {
                }
                column(AgingDateNew; AgingDateNew)
                {
                }
                column(Over150Days; Over150Days) //HHS 9-Jun-2021
                {
                }
                dataitem(CurrencyLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = FILTER(1 ..));
                    //PrintOnlyIfDetail = true;
                    dataitem(CustLedgEntryHdr; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(Currency2Code_CustLedgEntryHdr; STRSUBSTNO(Text001, CurrencyCode3))
                        {
                        }
                        column(StartBalance; StartBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCode3; CurrencyCode3)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdr; CustBalance)
                        {
                        }
                        column(PrintLine; PrintLine)
                        {
                        }
                        column(DtldCustLedgEntryType; FORMAT(DtldCustLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        column(IsNewCustCurrencyGroup; IsNewCustCurrencyGroup)
                        {
                        }
                        dataitem(DtldCustLedgEntries; "Detailed Cust. Ledg. Entry")
                        {
                            DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code");
                            column(PostDate_DtldCustLedgEntries; FORMAT("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                            {
                            }
                            column(DocNo_DtldCustLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDate_DtldCustLedgEntries; FORMAT(DueDate, 0, '<Day,2>/<Month,2>/<Year4>'))
                            {
                            }
                            column(CurrCode_DtldCustLedgEntries; "Currency Code")
                            {
                            }
                            //wx dtd 25 May 2020
                            column(Debit_Amount; "Debit Amount")
                            {
                            }
                            column(Credit_Amount; "Credit Amount")
                            {
                            }
                            //wx dtd 25 May 2020
                            column(Amt_DtldCustLedgEntries; Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(RemainAmt_DtldCustLedgEntries; RemainingAmount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(CustBalance; CustBalance)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Currency2Code; Currency2.Code)
                            {
                            }
                            column(DtldCustLedgEntries_DocType; "Document Type")
                            {
                            }
                            //DX        07 Oct 2021
                            column(ExtDocNo; ExtDocNo)
                            {

                            }
                            //DX        07 Oct 2021

                            trigger OnAfterGetRecord()
                            var
                                CustLedgerEntry: Record "Cust. Ledger Entry";
                            begin
                                IF SkipReversedUnapplied(DtldCustLedgEntries) OR (Amount = 0) THEN
                                    CurrReport.SKIP;
                                RemainingAmount := 0;
                                PrintLine := TRUE;
                                CASE "Entry Type" OF
                                    "Entry Type"::"Initial Entry":
                                        BEGIN
                                            CustLedgerEntry.GET("Cust. Ledger Entry No.");
                                            Description := CustLedgerEntry.Description;
                                            DueDate := CustLedgerEntry."Due Date";
                                            CustLedgerEntry.SETRANGE("Date Filter", 0D, EndDate);
                                            CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                            RemainingAmount := CustLedgerEntry."Remaining Amount";
                                        END;
                                    "Entry Type"::Application:
                                        BEGIN
                                            DtldCustLedgEntries2.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type");
                                            DtldCustLedgEntries2.SETRANGE("Customer No.", "Customer No.");
                                            DtldCustLedgEntries2.SETRANGE("Posting Date", "Posting Date");
                                            DtldCustLedgEntries2.SETRANGE("Entry Type", "Entry Type"::Application);
                                            DtldCustLedgEntries2.SETRANGE("Transaction No.", "Transaction No.");
                                            DtldCustLedgEntries2.SETFILTER("Currency Code", '<>%1', "Currency Code");
                                            IF NOT DtldCustLedgEntries2.ISEMPTY THEN BEGIN
                                                Description := Text005;
                                                DueDate := 0D;
                                            END ELSE
                                                PrintLine := FALSE;
                                        END;
                                    "Entry Type"::"Payment Discount",
                                    "Entry Type"::"Payment Discount (VAT Excl.)",
                                    "Entry Type"::"Payment Discount (VAT Adjustment)",
                                    "Entry Type"::"Payment Discount Tolerance",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                        BEGIN
                                            Description := Text006;
                                            DueDate := 0D;
                                        END;
                                    "Entry Type"::"Payment Tolerance",
                                    "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                        BEGIN
                                            Description := Text014;
                                            DueDate := 0D;
                                        END;
                                    "Entry Type"::"Appln. Rounding",
                                    "Entry Type"::"Correction of Remaining Amount":
                                        BEGIN
                                            Description := Text007;
                                            DueDate := 0D;
                                        END;
                                END;

                                IF PrintLine THEN BEGIN
                                    CustBalance := CustBalance + Amount;
                                    IsNewCustCurrencyGroup := IsFirstPrintLine;
                                    IsFirstPrintLine := FALSE;
                                    ClearCompanyPicture;
                                END;

                                //DX        07 Oct 2021
                                ExtDocNo := CustLedgerEntry."External Document No.";
                                //DX        07 Oct 2021

                            end;

                            trigger OnPreDataItem()
                            begin
                                SETRANGE("Customer No.", Customer."No.");
                                SETRANGE("Posting Date", StartDate, EndDate);
                                SETRANGE("Currency Code", Currency2.Code);

                                IF Currency2.Code = '' THEN BEGIN
                                    GLSetup.TESTFIELD("LCY Code");
                                    CurrencyCode3 := GLSetup."LCY Code"
                                END ELSE
                                    CurrencyCode3 := Currency2.Code;

                                IsFirstPrintLine := TRUE;
                            end;
                        }
                    }
                    dataitem(CustLedgEntryFooter; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(CurrencyCode3_CustLedgEntryFooter; CurrencyCode3)
                        {
                        }
                        column(Total_Caption; Total_CaptionLbl)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdrFooter; CustBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(EntriesExistsl_CustLedgEntryFooterCaption; EntriesExists)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ClearCompanyPicture;
                        end;
                    }
                    dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No." = FIELD("No.");
                        DataItemLinkReference = Customer;
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date");
                        column(OverDueEntries; STRSUBSTNO(Text002, Currency2.Code))
                        {
                        }
                        column(RemainAmt_CustLedgEntry2; "Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PostDate_CustLedgEntry2; FORMAT("Posting Date"))
                        {
                        }
                        column(DocNo_CustLedgEntry2; "Document No.")
                        {
                        }
                        column(Desc_CustLedgEntry2; Description)
                        {
                        }
                        column(DueDate_CustLedgEntry2; FORMAT("Due Date"))
                        {
                        }
                        column(OriginalAmt_CustLedgEntry2; "Original Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                        }
                        column(CurrCode_CustLedgEntry2; "Currency Code")
                        {
                        }
                        column(PrintEntriesDue; PrintEntriesDue)
                        {
                        }
                        column(Currency2Code_CustLedgEntry2; Currency2.Code)
                        {
                        }
                        column(CurrencyCode3_CustLedgEntry2; CurrencyCode3)
                        {
                        }
                        column(CustNo_CustLedgEntry2; "Customer No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            CustLedgEntry: Record "Cust. Ledger Entry";
                        begin
                            IF IncludeAgingBand THEN BEGIN
                                IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
                                    CurrReport.SKIP;
                                IF DateChoice = DateChoice::"Due Date" THEN
                                    IF "Due Date" >= EndDate THEN
                                        CurrReport.SKIP;
                            END;
                            CustLedgEntry := CustLedgEntry2;
                            CustLedgEntry.SETRANGE("Date Filter", 0D, EndDate);
                            CustLedgEntry.CALCFIELDS("Remaining Amount");
                            "Remaining Amount" := CustLedgEntry."Remaining Amount";
                            IF CustLedgEntry."Remaining Amount" = 0 THEN
                                CurrReport.SKIP;

                            IF IncludeAgingBand AND ("Posting Date" <= EndDate) THEN
                                UpdateBuffer(Currency2.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            IF "Due Date" >= EndDate THEN
                                CurrReport.SKIP;

                            ClearCompanyPicture;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT IncludeAgingBand THEN
                                SETRANGE("Due Date", 0D, EndDate - 1);
                            SETRANGE("Currency Code", Currency2.Code);
                            IF (NOT PrintEntriesDue) AND (NOT IncludeAgingBand) THEN
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        IF Number = 1 THEN
                            Currency2.FINDFIRST;

                        REPEAT
                            IF NOT IsFirstLoop THEN
                                IsFirstLoop := TRUE
                            ELSE
                                IF Currency2.NEXT = 0 THEN
                                    CurrReport.BREAK;
                            CustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                            CustLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
                            CustLedgerEntry.SETRANGE("Currency Code", Currency2.Code);
                            EntriesExists := NOT CustLedgerEntry.ISEMPTY;
                        UNTIL EntriesExists;
                        Cust2 := Customer;
                        Cust2.SETRANGE("Date Filter", 0D, StartDate - 1);
                        Cust2.SETRANGE("Currency Filter", Currency2.Code);
                        Cust2.CALCFIELDS("Net Change");
                        StartBalance := Cust2."Net Change";
                        CustBalance := Cust2."Net Change";
                    end;

                    trigger OnPreDataItem()
                    begin
                        Customer.COPYFILTER("Currency Filter", Currency2.Code);
                    end;
                }
                dataitem(AgingBandLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = FILTER(1 ..));
                    column(AgingDate1; FORMAT(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2; FORMAT(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; FORMAT(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3; FORMAT(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; FORMAT(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4; FORMAT(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; STRSUBSTNO(Text011, AgingBandEndingDate, PeriodLength, SELECTSTR(DateChoice + 1, Text013)))
                    {
                    }
                    column(AgingDate41; FORMAT(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; FORMAT(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt; AgingBandBuf."Column 1 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt; AgingBandBuf."Column 2 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt; AgingBandBuf."Column 3 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt; AgingBandBuf."Column 4 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt; AgingBandBuf."Column 5 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                    {
                    }
                    column(beforeCaption; beforeCaptionLbl)
                    {
                    }
                    column(DaysPeriodEnd; Format(DaysPeriodEnd))
                    {
                    }
                    // column(DaysPeriodStart; Format(DaysPeriodStart + 1))
                    // {
                    // }
                    column(DaysPeriodStart; Format(DaysPeriodStart)) //HHS 25-Jun-2021
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN BEGIN
                            ClearCompanyPicture;
                            IF NOT AgingBandBuf.FIND('-') THEN
                                CurrReport.BREAK;
                        END ELSE
                            IF AgingBandBuf.NEXT = 0 THEN
                                CurrReport.BREAK;
                        AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                        IF AgingBandCurrencyCode = '' THEN
                            AgingBandCurrencyCode := GLSetup."LCY Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT IncludeAgingBand THEN
                            CurrReport.BREAK;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                AgingBandBuf.DELETEALL;
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                PrintLine := FALSE;
                Cust2 := Customer;
                COPYFILTER("Currency Filter", Currency2.Code);
                IF PrintAllHavingBal THEN BEGIN
                    IF Currency2.FIND('-') THEN
                        REPEAT
                            Cust2.SETRANGE("Date Filter", 0D, EndDate);
                            Cust2.SETRANGE("Currency Filter", Currency2.Code);
                            Cust2.CALCFIELDS("Net Change");
                            PrintLine := Cust2."Net Change" <> 0;
                        UNTIL (Currency2.NEXT = 0) OR PrintLine;
                END;
                IF (NOT PrintLine) AND PrintAllHavingEntry THEN BEGIN
                    CustLedgerEntry.SETRANGE("Customer No.", "No.");
                    CustLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
                    COPYFILTER("Currency Filter", CustLedgerEntry."Currency Code");
                    PrintLine := NOT CustLedgerEntry.ISEMPTY;
                END;
                IF NOT PrintLine THEN
                    CurrReport.SKIP;

                FormatAddr.Customer(CustAddr, Customer);
                //CurrReport.PAGENO := 1;

                IF NOT IsReportInPreviewMode THEN BEGIN
                    LOCKTABLE;
                    FIND;
                    "Last Statement No." := "Last Statement No." + 1;
                    MODIFY;
                    COMMIT;
                END ELSE
                    "Last Statement No." := "Last Statement No." + 1;

                IsFirstLoop := FALSE;

                Clear(CurrencyCode);
                Clear(AgingDateNew);
                Clear(Over150Days); //HHS 9-Jun-2021

                if "Currency Code" = '' then begin
                    GLSetup.Get();
                    GLSetup.TestField("LCY Code");
                    CurrencyCode := GLSetup."LCY Code";
                end else begin
                    CurrencyCode := "Currency Code";
                end;

                //KM20210813 - Commented - Start
                // CustLedgerEntryRec.Reset();
                // CustLedgerEntryRec.SetRange("Customer No.", "No.");

                // if DateChoice = DateChoice::"Due Date" then
                //     CustLedgerEntryRec.SetFilter("Due Date", '%1..%2', DaysPeriodStart, DaysPeriodEnd)
                // else
                //     CustLedgerEntryRec.SetFilter("Posting Date", '%1..%2', DaysPeriodStart, DaysPeriodEnd);
                // if CustLedgerEntryRec.FindSet() then begin
                //     repeat
                //         CustLedgerEntryRec.CalcFields("Remaining Amount");
                //         AgingDateNew += CustLedgerEntryRec."Remaining Amount";
                //     until CustLedgerEntryRec.Next() = 0;
                // end;

                // //HHS 9-Jun-2021 Start
                // CustLedgerEntryRec.Reset();
                // CustLedgerEntryRec.SetRange("Customer No.", "No.");

                // if DateChoice = DateChoice::"Due Date" then
                //     CustLedgerEntryRec.SetFilter("Due Date", '<=%1', DaysPeriodStart)
                // else
                //     CustLedgerEntryRec.SetFilter("Posting Date", '<=%1', DaysPeriodStart);
                // if CustLedgerEntryRec.FindSet() then begin
                //     repeat
                //         CustLedgerEntryRec.CalcFields("Remaining Amount");
                //         Over150Days += CustLedgerEntryRec."Remaining Amount";
                //     until CustLedgerEntryRec.Next() = 0;
                // end;
                // //HHS 9-Jun-2021 End
                //KM20210813 - Commented - End

                //wx dtd 25 May 2020
                FwdAmt := CalcFwdAmt(Customer);
                //wx dtd 25 May 2020
                //DX        11 Oct 2021
                AddrArray[1] := Customer.Name;
                AddrArray[2] := Customer.Address;
                AddrArray[3] := Customer."Address 2";
                if Customer.City = '' then
                    AddrArray[4] := 'SINGAPORE ' + customer."Post Code"
                else
                    AddrArray[4] := Customer.City + ' ' + customer."Post Code";

                if Customer."Bill Name" <> '' then
                    AddrArray[1] := Customer."Bill Name";
                if Customer."Bill Address" <> '' then // YF 08 Sep 2023 // remove trailing spaces
                    AddrArray[2] := Customer."Bill Address"; // YF 08 Sep 2023 // remove trailing spaces
                if Customer."Bill Address 2" <> '' then
                    AddrArray[3] := Customer."Bill Address 2";
                if Customer."Bill Post Code" <> '' then begin
                    if Customer."Bill City" = '' then
                        AddrArray[4] := 'SINGAPORE ' + customer."Bill Post Code"
                    else
                        AddrArray[4] := Customer."Bill City" + ' ' + customer."Bill Post Code"
                end;




                //AddrArray[5] := Customer."Post Code"
                //DX        11 Oct 2021
            end;

            trigger OnPreDataItem()
            begin
                VerifyDates;
                AgingBandEndingDate := EndDate;
                CalcAgingBandDates;

                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                CompanyInfo.CalcFields(Picture);

                Currency2.Code := '';
                Currency2.INSERT;
                COPYFILTER("Currency Filter", Currency.Code);
                IF Currency.FIND('-') THEN
                    REPEAT
                        Currency2 := Currency;
                        Currency2.INSERT;
                    UNTIL Currency.NEXT = 0;
            end;
        }
    }

    requestpage
    {
        //SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Specifies if you want overdue entries to be shown separately for each currency.';
                    }
                    group(Include)
                    {
                        Caption = 'Include';
                        field(IncludeAllCustomerswithLE; PrintAllHavingEntry)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Customers with Ledger Entries';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have ledger entries at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                IF NOT PrintAllHavingEntry THEN
                                    PrintAllHavingBal := TRUE;
                            end;
                        }
                        field(IncludeAllCustomerswithBalance; PrintAllHavingBal)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Customers with a Balance';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have a balance at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                IF NOT PrintAllHavingBal THEN
                                    PrintAllHavingEntry := TRUE;
                            end;
                        }
                        field(IncludeReversedEntries; PrintReversedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Reversed Entries';
                            ToolTip = 'Specifies if you want to include reversed entries in the report.';
                        }
                        field(IncludeUnappliedEntries; PrintUnappliedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Unapplied Entries';
                            ToolTip = 'Specifies if you want to include unapplied entries in the report.';
                        }
                    }
                    group("Aging Band")
                    {
                        Caption = 'Aging Band';
                        field(IncludeAgingBand; IncludeAgingBand)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Aging Band';
                            ToolTip = 'Specifies if you want an aging band to be included in the document. If you place a check mark here, you must also fill in the Aging Band Period Length and Aging Band by fields.';
                        }
                        field(AgingBandPeriodLengt; PeriodLength)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band Period Length';
                            ToolTip = 'Specifies the length of each of the four periods in the aging band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.';
                        }
                        field(AgingBandby; DateChoice)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band by';
                            OptionCaption = 'Due Date,Posting Date';
                            ToolTip = 'Specifies if the aging band will be calculated from the due date or from the posting date.';
                        }
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                }
                group("Output Options")
                {
                    Caption = 'Output Options';
                    field(ReportOutput; SupportedOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Output';
                        OptionCaption = 'Print,Preview,PDF,Email,Excel,XML';
                        ToolTip = 'Specifies the output of the scheduled report, such as PDF or Word.';

                        trigger OnValidate()
                        var
                            CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                        begin
                            ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);

                            CASE SupportedOutputMethod OF
                                SupportedOutputMethod::Print:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
                                SupportedOutputMethod::Preview:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
                                SupportedOutputMethod::PDF:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
                                SupportedOutputMethod::Email:
                                    ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
                                SupportedOutputMethod::Excel:
                                    ChosenOutputMethod := CustomLayoutReporting.GetExcelOption;
                                SupportedOutputMethod::XML:
                                    ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
                            END;
                        end;
                    }
                    field(ChosenOutput; ChosenOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Chosen Output';
                        ToolTip = 'Specifies how to output the report, such as Print or Excel.';
                        Visible = false;
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses; PrintRemaining)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Print remaining statements';
                            ToolTip = 'Specifies if you want to print remaining statements.';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitRequestPageDataInternal;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
        END;

        LogInteractionEnable := TRUE;

        //wx dtd 25 May 2020
        StartDate := CALCDATE('CM-6M+1D', today);
        EndDate := CalcDate('CM');
        IncludeAgingBand := true;
        //wx dtd 25 May 2020

        DateChoice := DateChoice::"Posting Date"; //HHS 2-Jun-2021
    end;

    trigger OnPostReport()
    begin
        IF LogInteraction AND NOT IsReportInPreviewMode THEN
            IF Customer.FINDSET THEN
                REPEAT
                    SegManagement.LogDocument(
                      7, FORMAT(Customer."Last Statement No."), 0, 0, DATABASE::Customer, Customer."No.", Customer."Salesperson Code", '',
                      Text003 + FORMAT(Customer."Last Statement No."), '');
                UNTIL Customer.NEXT = 0;
    end;

    trigger OnPreReport()
    begin
        InitRequestPageDataInternal;
    end;

    //wx dtd 25 May 2020
    procedure CalcFwdAmt(CustRec: Record Customer) Fwd: Decimal
    var
        CalcTotalAmt: Decimal;
        CustLedgRec: record "Cust. Ledger Entry";
        DCustLedgRec: record "Detailed Cust. Ledg. Entry";
        InitEntryDate: Date;
        IsSameMonthBool: Boolean;

    begin
        CalcTotalAmt := 0;
        //FwdDateEndFilter := CALCDATE('<CM>',CALCDATE('<-CM-1D>',TODAY));
        FwdDateEndFilter := CALCDATE('<-CM-1D>', StartDate);
        CustLedgRec.RESET;
        CustLedgRec.SETFILTER("Posting Date", '..%1', FwdDateEndFilter);
        CustLedgRec.SETRANGE("Customer No.", CustRec."No.");
        //CustLedgRec.SETFILTER("Document Type",'<>%1',CustLedgRec."Document Type"::Payment);
        IF CustLedgRec.FINDSET THEN
            REPEAT
                CustLedgRec.CALCFIELDS(Amount, "Remaining Amount");
                IF CustLedgRec."Remaining Amount" <> CustLedgRec.Amount THEN BEGIN
                    CalcTotalAmt += CustLedgRec.Amount;
                END ELSE BEGIN
                    DCustLedgRec.RESET;
                    DCustLedgRec.SETRANGE("Cust. Ledger Entry No.", CustLedgRec."Entry No.");
                    DCustLedgRec.SETFILTER("Posting Date", '..%1', FwdDateEndFilter);
                    IF DCustLedgRec.FINDSET THEN
                        REPEAT
                            CalcTotalAmt += DCustLedgRec.Amount;
                        UNTIL DCustLedgRec.NEXT = 0;
                END;
            UNTIL CustLedgRec.NEXT = 0;
        EXIT(CalcTotalAmt);
    end;
    //wx dtd 25 May 2020

    var
        Text001: Label 'Entries %1';
        Text002: Label 'Overdue Entries %1';
        Text003: Label 'Statement ';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Cust2: Record Customer;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        DtldCustLedgEntries2: Record "Detailed Cust. Ledg. Entry";
        AgingBandBuf: Record "Aging Band Buffer" temporary;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        DueDate: Date;
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        Description: Text[100];
        StartBalance: Decimal;
        CustBalance: Decimal;
        RemainingAmount: Decimal;
        CurrencyCode3: Code[10];
        Text005: Label 'Multicurrency Application';
        Text006: Label 'Payment Discount';
        Text007: Label 'Rounding';
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array[5] of Date;
        Text008: Label 'You must specify the Aging Band Period Length.';
        AgingBandEndingDate: Date;
        Text010: Label 'You must specify Aging Band Ending Date.';
        Text011: Label 'Aged Summary by %1 (%2 by %3)';
        IncludeAgingBand: Boolean;
        Text012: Label 'Period Length is out of range.';
        AgingBandCurrencyCode: Code[20];
        Text013: Label 'Due Date,Posting Date';
        Text014: Label 'Application Writeoffs';
        // [InDataSet] // YF 06 Aug 2024
        LogInteractionEnable: Boolean;
        Text036: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        StatementCaptionLbl: Label 'Statement';
        PhoneNo_CompanyInfoCaptionLbl: Label 'Phone No.';
        VATRegNo_CompanyInfoCaptionLbl: Label 'VAT Registration No.';
        GiroNo_CompanyInfoCaptionLbl: Label 'Giro No.';
        BankName_CompanyInfoCaptionLbl: Label 'Bank';
        BankAccNo_CompanyInfoCaptionLbl: Label 'Account No.';
        No1_CustCaptionLbl: Label 'Customer No.';
        StartDateCaptionLbl: Label 'Starting Date';
        EndDateCaptionLbl: Label 'Ending Date';
        LastStatmntNo_CustCaptionLbl: Label 'Statement No.';
        PostDate_DtldCustLedgEntriesCaptionLbl: Label 'Posting Date';
        DueDate_CustLedgEntry2CaptionLbl: Label 'Due Date';
        CustBalanceCaptionLbl: Label 'Balance';
        beforeCaptionLbl: Label '..before';
        isInitialized: Boolean;
        CompanyInfoHomepageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'Email';
        DocDateCaptionLbl: Label 'Document Date';
        Total_CaptionLbl: Label 'Total';
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        IsFirstLoop: Boolean;
        CurrReportPageNoCaptionLbl: Label 'Page';
        IsFirstPrintLine: Boolean;
        IsNewCustCurrencyGroup: Boolean;
        SupportedOutputMethod: Option Print,Preview,PDF,Email,Excel,XML;
        ChosenOutputMethod: Integer;
        PrintRemaining: Boolean;
        // [InDataSet] // YF 06 Aug 2024
        ShowPrintRemaining: Boolean;
        FirstCustomerPrinted: Boolean;
        DocumentCaptionLbl: Label 'Statement';
        CoRegNoCaptionLbl: Label 'Co. Reg. No.';
        GSTRegNoCaptionLbl: Label 'GST Reg. No.';
        TelCaptionLbl: Label 'Tel';
        FaxCaptionLbl: Label 'Fax';
        WebsiteCaptionLbl: Label 'Website';
        EmailCaptionLbl: Label 'Email';
        StatementDateCaptionLbl: Label 'Statement Date';
        AccountNumberCaptionLbl: Label 'Account Number';
        PageCaptionLbl: Label 'Page';
        CurrencyCaptionLbl: Label 'Currency';
        CurrencyCode: Code[10];
        DaysPeriodStart: Date;
        DaysPeriodEnd: Date;
        AgingDateNew: Decimal;
        CustLedgerEntryRec: Record "Cust. Ledger Entry";
        //wx dtd 25 May 2020
        FwdDateEndFilter: Date;
        FwdAmt: Decimal;
        //wx dtd 25 May 2020
        Over150Days: Decimal; //HHS 9-Jun-2021
        ExtDocNo: Code[50];

        AddrArray: array[5] of Text[100];



    local procedure GetDate(PostingDate: Date; DueDate: Date): Date
    begin
        IF DateChoice = DateChoice::"Posting Date" THEN
            EXIT(PostingDate);

        EXIT(DueDate);
    end;

    local procedure CalcAgingBandDates()
    begin
        IF NOT IncludeAgingBand THEN
            EXIT;
        IF AgingBandEndingDate = 0D THEN
            ERROR(Text010);
        IF FORMAT(PeriodLength) = '' THEN
            ERROR(Text008);
        EVALUATE(PeriodLength2, STRSUBSTNO(Text036, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CALCDATE(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CALCDATE(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CALCDATE(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CALCDATE(PeriodLength2, AgingDate[2]);
        DaysPeriodEnd := AgingDate[1];
        // DaysPeriodStart := CalcDate(PeriodLength2, DaysPeriodEnd);
        DaysPeriodStart := CalcDate(PeriodLength2, DaysPeriodEnd) + 1; //HHS 25-Jun-2021
        IF AgingDate[2] <= AgingDate[1] THEN
            ERROR(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal)
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code" := CurrencyCode;
        IF NOT AgingBandBuf.FIND THEN
            AgingBandBuf.INSERT;
        I := 1;
        GoOn := TRUE;
        WHILE (I <= 5) AND GoOn DO BEGIN
            IF Date <= AgingDate[I] THEN
                //IF Date <= DaysPeriodStart THEN
                IF I = 1 THEN BEGIN
                    AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 2 THEN BEGIN
                    AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 3 THEN BEGIN
                    AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 4 THEN BEGIN
                    AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 5 THEN BEGIN
                    AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
                    GoOn := FALSE;
                END;
            I := I + 1;
        END;
        AgingBandBuf.MODIFY;

        //KM20210813 - Start
        if (Date >= DaysPeriodStart) and (Date <= DaysPeriodEnd) then begin
            AgingDateNew += Amount;
        end;

        if (Date < DaysPeriodStart) then begin
            Over150Days += Amount;
        end;
        //KM20210813 - End
    end;

    [Scope('Cloud')]
    procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record "Detailed Cust. Ledg. Entry"): Boolean
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        IF PrintReversedEntries AND PrintUnappliedEntries THEN
            EXIT(FALSE);
        IF NOT PrintUnappliedEntries THEN
            IF DtldCustLedgEntries.Unapplied THEN
                EXIT(TRUE);
        IF NOT PrintReversedEntries THEN BEGIN
            CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.");
            IF CustLedgEntry.Reversed THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    [Scope('Cloud')]
    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean; NewStartDate: Date; NewEndDate: Date)
    begin
        InitRequestPageDataInternal;

        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        IncludeAgingBand := NewIncludeAgingBand;
        EVALUATE(PeriodLength, NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteraction := NewLogInteraction;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    end;

    [Scope('Cloud')]
    procedure InitRequestPageDataInternal()
    begin
        IF isInitialized THEN
            EXIT;

        isInitialized := TRUE;

        IF (NOT PrintAllHavingEntry) AND (NOT PrintAllHavingBal) THEN
            PrintAllHavingBal := TRUE;

        // YF 06 Aug 2024 // BC Upgrade Patch  
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Stmnt.") <> '';
        // LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
        // YF 06 Aug 2024 // BC Upgrade Patch

        LogInteractionEnable := LogInteraction;

        IF FORMAT(PeriodLength) = '' THEN
            EVALUATE(PeriodLength, '<1M+CM>');

        ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);
    end;

    local procedure VerifyDates()
    begin
        IF StartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF EndDate = 0D THEN
            ERROR(BlankEndDateErr);
        IF StartDate > EndDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;

    local procedure ClearCompanyPicture()
    begin
        IF FirstCustomerPrinted THEN BEGIN
            CLEAR(CompanyInfo.Picture);
            CLEAR(CompanyInfo1.Picture);
            CLEAR(CompanyInfo2.Picture);
            CLEAR(CompanyInfo3.Picture);
        END;
        FirstCustomerPrinted := TRUE;
    end;
}