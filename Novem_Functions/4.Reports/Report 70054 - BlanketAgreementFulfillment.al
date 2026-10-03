report 70054 "BlanketAgreementFulfillment"
{
    DefaultRenderingLayout = "Blanket Agreement Fulfillment";
    Caption = 'Blanket Agreement Fulfillment';
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const("Blanket Order"));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Blanket Sales Order';
            column(No; "No.")
            {
            }
            column(SNNO; SNNO)
            {
            }
            column(ShowNotes; ShowNotes)
            {
            }
            column(I9G_GPOR_ContactNo; "I9G_GPOR/ContactNo")
            {
            }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(No1_SalesHeader; "Sales Header"."No.")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(CurrencyCode; CurrencyCode)
                    {
                    }

                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        column(No_SalesHeader; "Sales Header"."No.")
                        {
                        }
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(SelltoCustName_SalesHeader; "Sales Header"."Sell-to Customer Name")
                        {
                        }

                        column(StartDate_SalesHeader; Format("Sales Header".I9G_StartDate, 0, '<Day,2>.<Month,2>.<Year>'))
                        {
                        }
                        column(EndDate_SalesHeader; Format("Sales Header".I9G_EndDate, 0, '<Day,2>.<Month,2>.<Year>'))
                        {
                        }
                        column(TerminationDate_SalesHeader; "Sales Header".I9G_TerminationDate)
                        {
                        }
                        column(Admin_SalesHeader; "Sales Header".I9G_Admin)
                        {
                        }
                        column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(FulfilledStatus_SalesHeader; "Sales Header".I9G_FulfilledStatus)
                        {
                        }
                        column(RowStatus_SalesHeader; "Sales Header".I9G_RowStatus)
                        {
                        }
                        column(LineNo_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(DocumentNo_SalesLine; "Sales Line"."Document No.")
                        {
                        }
                        column(No_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Description_SalesLine; "Sales Line".Description)
                        {
                        }
                        column(UOMCode_SalesLine; "Sales Line"."Unit of Measure Code")
                        {
                        }
                        column(QtyInvoiced_SalesLine; "Sales Line"."Qty. Invoiced (Base)")
                        {
                        }
                        column(OpenQty_SalesLine; "Sales Line".I9G_OpenQuantity)
                        {
                        }
                        column(SellingPrice_SalesLine; "Sales Line"."Selling Price")
                        {
                            DecimalPlaces = 0 : 4;
                        }
                        column(OrderQty_SalesLine; "Sales Line"."Order Qty")
                        {
                        }
                        column(CumulativeAmt_SalesLine; "Sales Line"."Qty. Invoiced (Base)" * "Sales Line"."Selling Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(OpenAmt_SalesLine; "Sales Line".I9G_OpenQuantity * "Sales Line"."Selling Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            SNNO += 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            "Sales Header".I9G_Notes.CreateInStream(NotesDescriptionInstream);
                            NotesDescriptionInstream.ReadText(ShowNotes);
                        end;

                    }

                }

                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(TempSalesLine);
                    Clear(SalesPost);
                    TempSalesLine.DeleteAll();
                    TempVATAmountLine.DeleteAll();
                    SalesPost.GetSalesLines("Sales Header", TempSalesLine, 0);
                    TempSalesLine.CalcVATAmountLines(0, "Sales Header", TempSalesLine, TempVATAmountLine);
                    TempSalesLine.UpdateVATOnLines(0, "Sales Header", TempSalesLine, TempVATAmountLine);
                    VATAmount := TempVATAmountLine.GetTotalVATAmount();
                    VATBaseAmount := TempVATAmountLine.GetTotalVATBase();
                    VATDiscountAmount :=
                      TempVATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT();

                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode() then
                        CODEUNIT.Run(CODEUNIT::"Sales-Printed", "Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);

                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault("Language Code");
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault("Format Region");
                FormatAddr.SetLanguageCode("Language Code");

                FormatAddressFields("Sales Header");
                FormatDocumentFields("Sales Header");
                CalcFields(I9G_Notes);
                if SellToContact.Get("Sell-to Contact No.") then;
                if BillToContact.Get("Bill-to Contact No.") then;

                if not CompanyBankAccount.Get("Sales Header"."Company Bank Account Code") then
                    CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if not IsReportInPreviewMode() then
                    if ArchiveDocument then
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                Clear(CurrencyCode);
                if "Sales Header"."Currency Code" <> '' then begin
                    CurrencyCode := "Sales Header"."Currency Code"
                end else begin
                    CurrencyCode := GLSetup."LCY Code";
                end;
            end;
        }
    }

    rendering
    {
        layout("Blanket Agreement Fulfillment")
        {
            Type = RDLC;
            LayoutFile = './6.ReportLayouts/Rpt70054-BlanketAgreementFulfillment.rdl';
        }
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        SalesSetup.Get();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);

        SNNO := 0;
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if "Sales Header".FindSet() then
                repeat
                    "Sales Header".CalcFields("No. of Archived Versions");
                    if "Sales Header"."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          2, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence",
                          "Sales Header"."No. of Archived Versions", Database::Contact, "Sales Header"."Bill-to Contact No.",
                          "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description",
                          "Sales Header"."Opportunity No.")
                    else
                        SegManagement.LogDocument(
                          2, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence",
                          "Sales Header"."No. of Archived Versions", Database::Customer, "Sales Header"."Bill-to Customer No.",
                          "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description",
                          "Sales Header"."Opportunity No.");

                until "Sales Header".Next() = 0;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyBankAccount: Record "Bank Account";
        TempSalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        LanguageMgt: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        VATNoText: Text[80];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        SalesLineTypeInt: Integer;
        OutputNo: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        ArchiveDocument: Boolean;
        LogInteractionEnable: Boolean;
        SNNO: Integer;
        CurrencyCode: Code[10];
        SalesHeader: Record "Sales Header";
        NotesDescriptionInstream: InStream;
        ShowNotes: Text[100];

    protected var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[50];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        ShowShippingAddr: Boolean;
        TotalAmountInclVAT: Decimal;
        TotalSalesLineAmount: Decimal;
        TotalSalesInvDiscAmount: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields(var SalesHeader: Record "Sales Header")
    begin
        FormatAddr.GetCompanyAddr(SalesHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesHeaderBillTo(CustAddr, SalesHeader);
        ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesHeader);
    end;

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        FormatDocument.SetTotalLabels(SalesHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson, SalesHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesHeader."Payment Terms Code", SalesHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");

        ReferenceText := FormatDocument.SetText(SalesHeader."Your Reference" <> '', SalesHeader.FieldCaption("Your Reference"));
        VATNoText := FormatDocument.SetText(SalesHeader."VAT Registration No." <> '', SalesHeader.FieldCaption("VAT Registration No."));
    end;
}
