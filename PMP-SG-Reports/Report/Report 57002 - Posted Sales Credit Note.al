report 57002 "Posted Sales Credit Note"
{

    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57002 - Posted Sales Credit Note.rdl';
    CaptionML = ENU = 'Posted Sales Credit Memo',
                ENA = 'Posted Sales Credit Memo';
    EnableHyperlinks = true;
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;
    // WordMergeDataItem = Header;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";
            RequestFilterHeadingML = ENU = 'Posted Sales Credit Note',
                                     ENA = 'Posted Sales Credit Note';
            column(No_SalesInvHeader; "No.")
            {
            }
            column(VATPercentCaption; VATPercentCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(VATAmountCaption; VATAmountCaptionLbl)
            {
            }
            column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
            {
            }
            column(VATIdentifierCaption; VATIdentifierCaptionLbl)
            {
            }
            column(InvDiscBaseAmountCaption; InvDiscBaseAmountCaptionLbl)
            {
            }
            column(LineAmountCaption; LineAmountCaptionLbl)
            {
            }
            column(InvoiceDiscountAmountCaption; InvoiceDiscountAmountCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
            {
            }
            column(WebCaption; WebCaptionLbl)
            { }
            column(EmailCaption; EmailCaptionLbl)
            { }
            column(TelCaption; TelCaptionLbl)
            { }
            column(FaxCaption; FaxCaptionLbl)
            { }
            column(GSTRegNoCaption; GSTRegNoCaptionLbl)
            { }
            column(CoRegNoCaption; CoRegNoCaptionLbl)
            { }
            column(BillToCaption; BillToCaptionLbl)
            { }
            column(DeliveryToCaption; DeliveryToCaptionLbl)
            { }
            column(AttnCaption; AttnCaptionLbl)
            { }
            column(TaxInvoiceNoCaption; TaxInvoiceNoCaptionLbl)
            { }
            column(DateCaption; DateCaptionLbl)
            { }
            column(YourPONoCaption; YourPONoCaptionLbl)
            { }
            column(SalesmanCaption; SalesmanCaptionLbl)
            { }
            column(TermsCaption; TermsCaptionLbl)
            { }
            column(DriverAreaCaption; DriverAreaCaptionLbl)
            { }
            column(PageCaption; PageCaptionLbl)
            { }
            //LK281123
            column(Your_Reference; "Your Reference")
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            //LK281123
            //KM20210226 - Start
            column(CompCurrCode; GLSetup."LCY Code") { }
            //KM20210226 - End
            dataitem(CopyLoop; 2000000026)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; 2000000026)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    // column(CompInfoPicture2; CompanyInfo."Picture 2")
                    // {
                    // }
                    column(DocCaptionCopyText; STRSUBSTNO(DocumentCaption, CopyText))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo_FaxNo; CompanyInfo."Fax No.")
                    { }
                    column(CompanyInfo_CoRegNo; CompanyInfo."Registration No.")
                    { }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(ShipMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(CompInfoVATRegsNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader; "Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(SalesInvHdr_SellToCustNo; "Sales Cr.Memo Header"."Sell-to Customer No.")
                    { }
                    column(PostingDt_SalesInvHeader; FORMAT("Sales Cr.Memo Header"."Posting Date", 0, 1))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegsNo_SalesInvHeader; "Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvHeader; FORMAT("Sales Cr.Memo Header"."Due Date", 0, 4))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(SalesInvHeaderNo1; "Sales Cr.Memo Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(SalesInvHeaderYourReference; "Sales Cr.Memo Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(OrderNo_SalesInvHdr; "Sales Cr.Memo Header"."Return Order No.")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompAddr6; CompanyAddr[6])
                    {
                    }
                    column(DocumentDate04_SalesInvHeader; FORMAT("Sales Cr.Memo Header"."Document Date", 0, 4))
                    {
                    }
                    column(PricesIncludVAT_SalesInvHdr; "Sales Cr.Memo Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo; FORMAT("Sales Cr.Memo Header"."Prices Including VAT"))
                    {
                    }
                    // column(PageCaption; PageCaptionCap)
                    // {
                    // }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccountNoCaption; BankAccountNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                    }
                    column(ABNCaption; ABNCaptionLbl)
                    {
                    }
                    column(DivisionPartNoCaption; DivisionPartNoCaptionLbl)
                    {
                    }
                    column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl)
                    {
                    }
                    column(ShipmentMethodDescriptionCaption; ShipmentMethodDescriptionCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(EmailIdCaption; EmailIdCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesInvHeaderCaption; "Sales Cr.Memo Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricesIncludVAT_SalesInvHdrCaption; "Sales Cr.Memo Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(PONum; "Sales Cr.Memo Header"."External Document No.")
                    {
                    }
                    column(CustNo; CustRec."No.")
                    {
                    }
                    // column(ShippingAgentCode; "Sales Cr.Memo Header"."Shipping Agent Code")
                    // {
                    // }
                    column(ShippingAgentCode; ShippingAgentDesc)
                    {
                    }
                    column(UserID; "Sales Cr.Memo Header"."User ID")
                    {
                    }
                    column(UENNo; CompanyInfo."Registration No.")
                    {
                    }
                    column(ShipToAddr11; ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr22; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr33; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr44; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr55; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr66; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr77; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr88; ShipToAddr[8])
                    {
                    }
                    column(Phone2; CompanyInfo."Phone No. 2")
                    {
                    }
                    column(CompanyFax; CompanyInfo."Fax No.")
                    {
                    }
                    column(ShipToPhoneNo; ShipToPhoneNo)
                    {
                    }
                    column(ShipToFaxNo; ShipToFaxNo)
                    { }
                    column(CustPriceGrp; CustRec."Customer Price Group")
                    {
                    }
                    column(SellToContactPhoneNum; SellToContactPhone)
                    {
                    }
                    // column(OverallComments; "Sales Cr.Memo Header"."Overall Comment")
                    // {
                    // }
                    column(ShortcutDim1; "Sales Cr.Memo Header"."Shortcut Dimension 1 Code")
                    {
                    }
                    column(ContactName; "Sales Cr.Memo Header"."Sell-to Contact")
                    {
                    }
                    column(ContactName2; "Sales Cr.Memo Header"."Ship-to Contact")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(SwiftCode; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(AccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    // column(DeliveryDate; "Sales Cr.Memo Header"."Delivery Date")
                    // {
                    // }
                    // column(AccountName; CompanyInfo."Account Name")
                    // {
                    // }
                    // column(TermDetails1; TermsRec."Terms Details 1")
                    // {
                    // }
                    // column(TermDetails2; TermsRec."Terms Details 2")
                    // {
                    // }
                    // column(TermDetails3; TermsRec."Terms Details 3")
                    // {
                    // }
                    // column(TermDetails4; TermsRec."Terms Details 4")
                    // {
                    // }
                    // column(TermDetails5; TermsRec."Terms Details 5")
                    // {
                    // }
                    // column(TermDetails6; TermsRec."Terms Details 6")
                    // {
                    // }
                    // column(TermDetails7; TermsRec."Terms Details 7")
                    // {
                    // }
                    // column(TermDetails8; TermsRec."Terms Details 8")
                    // {
                    // }
                    // column(TermDetails9; TermsRec."Terms Details 9")
                    // {
                    // }
                    // column(TermDetails10; TermsRec."Terms Details 10")
                    // {
                    // }
                    // column(TermDetails11; TermsRec."Terms Details 11")
                    // {
                    // }
                    // column(TermDetails12; TermsRec."Terms Details 12")
                    // {
                    // }
                    column(CurrCode; CurrCode)
                    {
                    }
                    column(BillToAddress1; "Sales Cr.Memo Header"."Bill-to Address")
                    {
                    }
                    Column(BillToAddress2; "Sales Cr.Memo Header"."Bill-to Address 2")
                    {
                    }
                    Column(SellToAddress1; "Sales Cr.Memo Header"."Sell-to Address")
                    {
                    }
                    Column(SellToAddress2; "Sales Cr.Memo Header"."Sell-to Address 2")
                    {
                    }
                    Column(BillToName2; "Sales Cr.Memo Header"."Bill-to Name")
                    {
                    }
                    Column(SellToName2; "Sales Cr.Memo Header"."Sell-to Customer Name")
                    {
                    }
                    column(DiscAmt; DiscAmt * -1)
                    {
                    }
                    column(DiscPercent; DiscPercent + '%')
                    {
                    }
                    column(Subtotal; Subtotal)
                    {
                    }
                    column(GSTAmt; GSTAmt)
                    {
                    }
                    column(TotalInclGST; TotalInclGST)
                    {
                    }
                    column(CreationUser; '"Sales Cr.Memo Header"."Creation User"')
                    {
                    }
                    column(AmountInWords; NoText[1] + NoText[2])
                    {
                    }
                    column(SalesLine_VAT; GSTValue)
                    {
                    }
                    column(Details1; '"Sales Cr.Memo Header"."Details 1"')
                    {
                    }
                    column(SellToContactFaxNum; SellToContactFax)
                    {
                    }
                    Column(BillToAddress3; BillToAddr3Text)
                    {
                    }
                    Column(BillToAddress4; '"Sales Cr.Memo Header"."Sell To Address 4"')
                    {
                    }
                    Column(SellToAddress3; SellToAddr3Text)
                    {
                    }
                    Column(SellToAddress4; '"Sales Cr.Memo Header"."Ship to Address 4"')
                    {
                    }
                    column(HideDiscount; HideDiscount)
                    {
                    }
                    //DX        21 Aug 2021
                    column(BarcodeText; BarcodeText)
                    {

                    }
                    column(BarcodeOrder; BarcodeOrder)
                    {

                    }
                    column(CustInstr; "Sales Cr.Memo Header"."Customer Instructions")
                    {

                    }
                    column(PlacedBy; "Sales Cr.Memo Header"."SO Placed By")
                    {

                    }
                    column(TakenBy; "Sales Cr.Memo Header"."SO Placed By")
                    {

                    }

                    dataitem(DimensionLoop1; 2000000026)
                    {
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number1_IntergerLine; DimensionLoop1.Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(LineAmt_SalesInvLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            // AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine; Description)
                        {
                        }
                        column(Desc_2SalesInvLine; "Sales Cr.Memo Line"."Description 2")
                        {
                        }
                        column(No_SalesInvLine; "No.")
                        {
                        }
                        column(No_SalesInvLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(Qty_SalesInvLine; Quantity)
                        {
                        }
                        column(UnitMeasure_SalesInvLine; "Unit of Measure Code")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            // AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesInvLine; "Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesInvLine; "VAT Identifier")
                        {
                        }
                        column(PostedShipDt_SalesInvLine; FORMAT(PostedShipmentDate))
                        {
                        }
                        column(SalesLineType_SalesInvLine; FORMAT(Type))
                        {
                        }
                        column(InvDiscountAmt_SalesInvLine; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            //AutoFormatType = 1;
                        }
                        column(TotalSubTotal_SalesInvLine; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            //AutoFormatType = 1;
                        }
                        column(TotalInvDiscountAmt_SalesInvLine; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            //AutoFormatType = 1;
                        }
                        column(TotalText_SalesInvLine; TotalText)
                        {
                        }
                        column(Amount__SalesInvLine; Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            //AutoFormatType = 1;
                        }
                        column(TotalAmount__SalesInvLine; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            //AutoFormatType = 1;
                        }
                        column(AmtIncludVATAmt; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            // AutoFormatType = 1;
                        }
                        column(AmtIncludVAT_SalesInvLine; "Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            //AutoFormatType = 1;
                        }
                        // column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        // {
                        // }
                        column(VATAmtLineVATAmtText; VATAmountText)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            // AutoFormatType = 1;
                        }
                        column(TotalAmtVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            // AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Cr.Memo Header"."VAT Base Discount %")
                        {
                            //  AutoFormatType = 1;
                        }
                        column(TotalPaymentDisOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            // AutoFormatType = 1;
                        }
                        column(SalesInvHeaderCurrFactor; "Sales Cr.Memo Header"."Currency Factor")
                        {
                        }
                        column(TotalExclVATTextLCY; TotalExclVATTextLCY)
                        {
                        }
                        column(TotalInclVATTextLCY; TotalInclVATTextLCY)
                        {
                        }
                        column(AmtIncLCYAmtLCY; AmountIncLCY - AmountLCY)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            //  AutoFormatType = 1;
                        }
                        column(AmtIncLCY; AmountIncLCY)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            //  AutoFormatType = 1;
                        }
                        column(AmtLCY; AmountLCY)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            // AutoFormatType = 1;
                        }
                        column(CurrLCY; CurrencyLCY)
                        {
                        }
                        column(CurrCode_SalesInvHeader; "Sales Cr.Memo Header"."Currency Code")
                        {
                        }
                        column(AmtLangB1AmtLangB2; AmountLangB[1] + ' ' + AmountLangB[2])
                        {
                            // AutoFormatType = 1;
                        }
                        column(AmtLangA1AmtLangA2; AmountLangA[1] + ' ' + AmountLangA[2])
                        {
                            AutoFormatType = 1;
                        }
                        column(AmtInWords; AmountInWords)
                        {
                        }
                        column(SalesInvLineLineNo; "Line No.")
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountPercentCaption; DiscountPercentCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption; PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PaymentDiscountonVATCaption; PaymentDiscountonVATCaptionLbl)
                        {
                        }
                        column(ExchangeRateCaption; ExchangeRateCaptionLbl)
                        {
                        }
                        column(Desc_SalesInvLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(Qty_SalesInvLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(UnitMeasure_SalesInvLineCaption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesInvLineCaption; FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(IsLineWithTotals; LineNoWithTotal = "Line No.")
                        {
                        }
                        column(SerialNoText; SerialNoText)
                        {
                        }
                        // column(ItemModel; ItemRec.Model)
                        // {
                        // }
                        //KM20210215 - Start
                        column(ExpirationDate; ExpirationDate) { }
                        column(Batch; Batch) { }
                        //KM20210215 - End
                        //DX        15 Jun 2021 : Additional fields
                        column(OrderQty; "Sales Cr.Memo Line"."Order Qty")
                        {

                        }
                        column(Selling_Price; "Sales Cr.Memo Line"."Selling Price")
                        {

                        }
                        column(FOC_Qty; "Sales Cr.Memo Line"."FOC Qty")
                        {

                        }
                        column(ILEQty; ILEQty)
                        {

                        }

                        column(LineRemark; LineRemark)
                        { }
                        //DX        15 Jun 2021 : Additional fields
                        dataitem("Sales Shipment Buffer"; 2000000026)
                        {
                            DataItemTableView = SORTING(Number);
                            column(SalesShipBufferPostingDt; FORMAT(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShipBufferQty; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShipmentCaption; ShipmentCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN
                                    SalesShipmentBuffer.FIND('-')
                                ELSE
                                    SalesShipmentBuffer.NEXT;

                                IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."No." <> '') THEN BEGIN
                                    CLEAR(ItemRec);
                                    ItemRec.GET(SalesLine."No.");
                                end;
                            end;

                            trigger OnPreDataItem();
                            begin
                                SalesShipmentBuffer.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                                SalesShipmentBuffer.SETRANGE("Line No.", "Sales Cr.Memo Line"."Line No.");

                                SETRANGE(Number, 1, SalesShipmentBuffer.COUNT);
                            end;
                        }
                        dataitem(DimensionLoop2; 2000000026)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimTextCtrl82; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem();
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Cr.Memo Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; 2000000026)
                        {
                            column(PostedAsmMeasureCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                //DecimalPlaces = 0:5;
                            }
                            column(PostedAsmLineQty; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(PostedAsmLineVarCode; BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {
                                //DecimalPlaces = 0:5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(PostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord();
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                ELSE
                                    TempPostedAsmLine.NEXT;

                                IF ItemTranslation.GET(TempPostedAsmLine."No.",
                                     TempPostedAsmLine."Variant Code",
                                     "Sales Cr.Memo Header"."Language Code")
                                THEN
                                    TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem();
                            begin
                                CLEAR(TempPostedAsmLine);
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK;
                                CollectAsmInformation;
                                CLEAR(TempPostedAsmLine);
                                SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            PostedShipmentDate := 0D;
                            IF Quantity <> 0 THEN
                                PostedShipmentDate := FindPostedShipmentDate;

                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            VATAmountLine.INIT;
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."VAT Amount" := "Amount Including VAT" - Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            IF "Allow Invoice Disc." THEN
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                            //RptConverter.FormatNoText(NoText, TotalAmountInclVAT, '');

                            IF ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) AND ("Sales Cr.Memo Line"."No." <> '') THEN BEGIN
                                CLEAR(ItemRec);
                                ItemRec.GET("Sales Cr.Memo Line"."No.");
                            end;

                            //wx dtd 180418
                            IF "Sales Cr.Memo Line".Type.AsInteger() > 0 THEN BEGIN
                                SerialNo += 1;
                                SerialNoText := FORMAT(SerialNo);

                            END ELSE BEGIN
                                SerialNoText := '';

                            END;

                            //KM20210215 - Start
                            if TempILE.IsTemporary then begin
                                TempILE.Reset();
                                TempILE.DeleteAll();
                            end;
                            Clear(Batch);
                            Clear(ExpirationDate);
                            Clear(ILEQty);
                            ItemTrackDocMngt.RetrieveEntriesFromPostedInvoice(TempILE, "Sales Cr.Memo Line".RowID1());
                            if TempILE.FindSet() then begin
                                repeat
                                    //Batch := TempILE."Lot No." + ';';
                                    //ExpirationDate := format(TempILE."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>') + ';';

                                    Batch += TempILE."Lot No." + ';';
                                    ExpirationDate += format(TempILE."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>') + ';';
                                    //DX        21 Aug 2021
                                    ILEQty += FORMAT(TempILE.Quantity, 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>') + ';';
                                    ExprDateVal := TempILE."Expiration Date";
                                    if ExprDateVal <> 0D Then
                                        if (ExprDateVal - Today) < 365 then      //DX        21 Aug 2021 : :Less than 1 year to add to remark
                                            LineRemark := 'Short Expiration' + ';'; // YF 02 Nov 2021 // Bug Fix
                                                                                    // LineRemark += 'Short Expiration' + ';'; // YF 02 Nov 2021 // Bug Fix

                                //DX        21 Aug 2021
                                until TempILE.Next() = 0;
                            end;
                            //KM20210215 - End
                        end;

                        trigger OnPreDataItem();
                        begin
                            VATAmountLine.DELETEALL;
                            SalesShipmentBuffer.RESET;
                            SalesShipmentBuffer.DELETEALL;
                            FirstValueEntryNo := 0;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            LineNoWithTotal := "Line No.";
                            SETRANGE("Line No.", 0, "Line No.");
                            //CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; 2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATBase_VATAmtLine; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmt_VATAmtLine; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmt_VATAmtLine; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDiscBaseAmt_VATAmtLine; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDiscAmt_VATAmtLine; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VatCounterLCY; 2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALSpecLCYHdr; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATCtrl164_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIndCtrl_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Sales Cr.Memo Header"."Currency Code" = '')
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            //CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", 1);
                            if "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount" <> 0 then
                                CalculatedExchRate := ROUND(1 / "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := STRSUBSTNO(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(PaymentReportingArgument; "Payment Reporting Argument")
                    {
                        DataItemTableView = SORTING(Key);
                        UseTemporary = true;
                        column(PaymentServiceLogo; Logo)
                        {
                        }
                        column(PaymentServiceURLText; "URL Caption")
                        {
                        }
                        column(PaymentServiceURL; GetTargetURL)
                        {
                        }

                        trigger OnPreDataItem();
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            // PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument, "Sales Cr.Memo Header");
                            // IF ISEMPTY THEN
                            CurrReport.BREAK;
                        end;
                    }
                    dataitem(Total; 2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; 2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(SelltoCustomerNo_SalesInvHeader; "Sales Cr.Memo Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        {
                        }
                        column(SelltoCustomerNo_SalesInvHeaderCaption; "Sales Cr.Memo Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(LineFee; 2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            ORDER(Ascending)
                                            WHERE(Number = FILTER(1 ..));
                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF NOT DisplayAdditionalFeeNote THEN
                                CurrReport.BREAK;

                            IF Number = 1 THEN BEGIN
                                IF NOT TempLineFeeNoteOnReportHist.FINDSET THEN
                                    CurrReport.BREAK
                            END ELSE
                                IF TempLineFeeNoteOnReportHist.NEXT = 0 THEN
                                    CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    END;
                    //CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                end;

                trigger OnPostDataItem();
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        // CODEUNIT.RUN(CODEUNIT::"Sales Inv.-Printed", "Sales Cr.Memo Header");
                        Codeunit.Run(Codeunit::"Sales Cr. Memo-Printed", "Sales Cr.Memo Header");
                end;

                trigger OnPreDataItem();
                begin
                    // NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;  //RL  24 Oct 2021
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                StringConvMgmtCU: Codeunit StringConversionManagement; // YF 08 Feb 2022
                SingleQuoteChar: Char; // YF 08 Feb 2022
                PMPReportCU: Codeunit "PMP-ReportCU"; // YF 23 Aug 2022
                SalesCrMemoHdrRecRef: RecordRef; // YF 23 Aug 2022
                GSTPercent: Decimal; // YF 23 Aug 2022
            begin

                // calculated total
                Subtotal := 0;
                DiscAmt := 0;
                GSTAmt := 0;
                TotalInclGST := 0;

                SalesLineRecNew.RESET;
                SalesLineRecNew.SETRANGE("Document No.", "Sales Cr.Memo Header"."No.");
                IF SalesLineRecNew.FINDSET() THEN
                    REPEAT
                        Subtotal += SalesLineRecNew.Amount + SalesLineRecNew."Line Discount Amount";

                        DiscAmt += SalesLineRecNew."Line Discount Amount";
                        GSTAmt += SalesLineRecNew."Amount Including VAT" - SalesLineRecNew.Amount;
                        TotalInclGST += SalesLineRecNew."Amount Including VAT";

                        // if SalesLineRecNew.type <> SalesLineRecNew.Type::" " then begin

                        //     GstPerc := format(SalesLineRecNew."VAT %");

                        //     // Message(GstPerc);
                        // end;

                        if (SalesLineRecNew.Type <> SalesLineRecNew.Type::" ") AND (GSTValue <> '') then begin
                            GSTValue := format(SalesLineRecNew."VAT %");
                        end;

                    UNTIL SalesLineRecNew.NEXT = 0;

                CalcFields("Invoice Discount Amount");
                DiscAmt += "Invoice Discount Amount";
                Subtotal += "Invoice Discount Amount";
                //GSTValue := format(SalesLineRecNew."VAT %");

                // YF 23 Aug 2022
                GSTPercent := 0;
                Clear(PMPReportCU);
                Clear(SalesCrMemoHdrRecRef);
                SalesCrMemoHdrRecRef.GetTable("Sales Cr.Memo Header");
                GSTPercent := PMPReportCU.GetVATPercentFromDocument(SalesCrMemoHdrRecRef);
                if GSTPercent = 0 then
                    GSTValue := ''
                else
                    GSTValue := ' ' + Format(GSTPercent) + '%';
                // YF 23 Aug 2022

                RptConverter.FormatNoText(NoText, TotalInclGST, '');

                IF Subtotal <> 0 THEN
                    DiscPercent := FORMAT((DiscAmt / Subtotal) * 100, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>')
                ELSE
                    DiscPercent := FORMAT(0);

                FormatAddressFields("Sales Cr.Memo Header");
                FormatDocumentFields("Sales Cr.Memo Header");

                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                CALCFIELDS(Amount);
                CALCFIELDS("Amount Including VAT");

                AmountLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      WORKDATE, "Currency Code", Amount, "Currency Factor"));
                AmountIncLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      WORKDATE, "Currency Code", "Amount Including VAT", "Currency Factor"));
                RptConverter.InitTextVariable;
                RptConverter.FormatNoText(AmountLangA, "Amount Including VAT", "Currency Code");
                IF ShowTHFormatting THEN BEGIN
                    RptConverter.InitTextVariableTH;
                    RptConverter.FormatNoTextTH(AmountLangB, "Amount Including VAT", "Sales Cr.Memo Header"."Currency Code");
                END ELSE BEGIN
                    AmountLangB[1] := '';
                    AmountLangB[2] := '';
                END;

                GetLineFeeNoteOnReportHist("No.");

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    END;

                CLEAR(ShipToRec);

                IF "Sales Cr.Memo Header"."Ship-to Code" = '' THEN BEGIN

                    ShipToPhoneNo := '';
                    ShipToFaxNo := '';

                END ELSE BEGIN

                    ShipToRec.GET("Sales Cr.Memo Header"."Sell-to Customer No.", "Sales Cr.Memo Header"."Ship-to Code");
                    ShipToPhoneNo := ShipToRec."Phone No.";
                    ShipToFaxNo := ShipToRec."Fax No.";
                END;

                //wx dtd 180418 add a serial number
                SerialNo := 0;

                ShippingAgentRec.Reset();

                if "Sales Cr.Memo Header"."Shipping Agent Code" <> '' then begin
                    ShippingAgentRec.Get("Sales Cr.Memo Header"."Shipping Agent Code");
                    ShippingAgentDesc := ShippingAgentRec.Name;
                end;

                IF "Sales Cr.Memo Header"."Currency Code" = '' THEN BEGIN
                    CurrCode := GLSetup."LCY Code"
                END
                ELSE BEGIN
                    CurrRec.RESET;
                    CurrRec.SETRANGE(Code, "Sales Cr.Memo Header"."Currency Code");
                    IF CurrRec.FINDFIRST THEN
                        //DX        03 Feb 2022
                        CurrCode := CurrRec.Code;
                    //CurrCode := CurrRec.Symbol;
                    //DX        03 Feb 2022
                END;

                //wx 180418 get customer no
                IF "Sales Cr.Memo Header"."Sell-to Customer No." <> '' THEN BEGIN
                    CustRec.GET("Sales Cr.Memo Header"."Sell-to Customer No.");
                    SellToContactPhone := CustRec."Phone No.";
                    SellToContactFax := CustRec."Fax No.";
                END;

                CLEAR(ShipToRec);

                IF "Sales Cr.Memo Header"."Ship-to Code" = '' THEN BEGIN

                    ShipToContactPhone := '';

                END ELSE BEGIN

                    ShipToRec.GET("Sales Cr.Memo Header"."Sell-to Customer No.", "Sales Cr.Memo Header"."Ship-to Code");
                    ShipToContactPhone := ShipToRec."Phone No.";
                END;

                // if "Sales Cr.Memo Header".Terms <> '' then begin

                //     TermsRec.get("Sales Cr.Memo Header".Terms);
                // end;
                //DX        21 Aug 2021
                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/                
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                if "No." <> '' then begin
                    barcodeString := "No.";
                    BarcodeFontProvider.ValidateInput(barcodeString, BarcodeSymbology);
                    BarcodeText := BarcodeFontProvider.EncodeFont(barcodeString, BarcodeSymbology);
                end;

                if ("External Document No." <> '') and ("External Document No." <> '.') and ("External Document No." <> '-') then begin

                    // YF 08 Feb 2022
                    Clear(StringConvMgmtCU);

                    barcodeString := StringConvMgmtCU.RemoveNonAlphaNumericCharacters("External Document No.");

                    SingleQuoteChar := 39;
                    barcodeString := delchr(barcodeString, '=', Format(SingleQuoteChar));
                    barcodeString := delchr(barcodeString, '=', '''');

                    // barcodeString := delchr("External Document No.", '=', '''');
                    // YF 08 Feb 2022

                    BarcodeFontProvider.ValidateInput(barcodeString, BarcodeSymbology);
                    BarcodeOrder := BarcodeFontProvider.EncodeFont(barcodeString, BarcodeSymbology);
                end;

                //DX        01 Jun 2021 : https://demiliani.com/2021/04/06/dynamics-365-business-central-native-support-for-barcodes/
                //DX        21 aug 2021             
            end;

            trigger OnPreDataItem()
            begin
                if FromEmail = true then begin
                    Reset();
                    SetRange("No.", Gbl_SCNH."No.");
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
                group(Options)
                {
                    CaptionML = ENU = 'Options',
                                ENA = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'No. of Copies',
                                    ENA = 'No. of Copies';
                        ToolTipML = ENU = 'Specifies how many copies of the document to print.',
                                    ENA = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show Internal Information',
                                    ENA = 'Show Internal Information';
                        ToolTipML = ENU = 'Specifies if the document shows internal information.',
                                    ENA = 'Specifies if the document shows internal information.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Log Interaction',
                                    ENA = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTipML = ENU = 'Specifies that interactions with the contact are logged.',
                                    ENA = 'Specifies that interactions with the contact are logged.';
                    }
                    field(ShowTotalInWords; AmountInWords)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show Total In Words',
                                    ENA = 'Show Total In Words';
                    }
                    field(ShowLCYForFCY; CurrencyLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show LCY for FCY',
                                    ENA = 'Show LCY for FCY';
                    }
                    field(ShowTHAmountInWords; ShowTHFormatting)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show TH Amount In Words',
                                    ENA = 'Show TH Amount In Words';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show Assembly Components',
                                    ENA = 'Show Assembly Components';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show Additional Fee Note',
                                    ENA = 'Show Additional Fee Note';
                        ToolTipML = ENU = 'Specifies that any notes about additional fees are included on the document.',
                                    ENA = 'Specifies that any notes about additional fees are included on the document.';
                    }
                    field(HideDiscount; HideDiscount)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Hide / Show Discount (%)',
                                    ENA = 'Hide / Show Discount (%)';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            LogInteractionEnable := TRUE;
            FromEmail := false;
        end;

        trigger OnOpenPage();
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
        SalesSetup.GET;
        CompanyInfo.GET;
        // CompanyInfo.VerifyAndSetPaymentInfo;
        //FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
        CompanyInfo.CALCFIELDS(Picture);
        // CompanyInfo.CALCFIELDS("Picture 2");
    end;

    trigger OnPreReport();
    begin
        // IF NOT CurrReport.USEREQUESTPAGE THEN
        //     InitLogInteraction;
    end;

    var
        Text004: TextConst Comment = '%1 = Document No.', ENU = 'Sales - Credit Note %1', ENA = 'Sales - Credit Note %1';
        PageCaptionCap: TextConst ENU = 'Page %1 of %2', ENA = 'Page %1 of %2';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        Cust: Record customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        LanguageCU: Codeunit Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: TextConst ENU = 'GST Amount Specification in ', ENA = 'GST Amount Specification in ';
        Text008: TextConst ENU = 'Local Currency', ENA = 'Local Currency';
        VALExchRate: Text[50];
        Text009: TextConst ENU = 'Exchange rate: %1/%2', ENA = 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: TextConst ENU = 'Sales - Prepayment Invoice %1', ENA = 'Sales - Prepayment Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        TotalInclVATTextLCY: Text[50];
        TotalExclVATTextLCY: Text[50];
        AmountLCY: Decimal;
        AmountIncLCY: Decimal;
        CurrencyLCY: Boolean;
        AmountInWords: Boolean;
        AmountLangA: array[2] of Text[80];
        AmountLangB: array[2] of Text[80];
        SalesLine: Record "Sales Line";
        ShowTHFormatting: Boolean;
        // [InDataSet] // YF 06 Aug 2024
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        VATPercentCaptionLbl: TextConst ENU = 'GST %', ENA = 'GST %';
        VATBaseCaptionLbl: TextConst ENU = 'GST Base', ENA = 'GST Base';
        VATAmountCaptionLbl: TextConst ENU = 'GST Amount', ENA = 'GST Amount';
        VATAmountSpecificationCaptionLbl: TextConst ENU = 'GST Amount Specification', ENA = 'GST Amount Specification';
        VATIdentifierCaptionLbl: TextConst ENU = 'GST Identifier', ENA = 'GST Identifier';
        InvDiscBaseAmountCaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ENA = 'Invoice Discount Base Amount';
        LineAmountCaptionLbl: TextConst ENU = 'Line Amount', ENA = 'Line Amount';
        InvoiceDiscountAmountCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ENA = 'Invoice Discount Amount';
        TotalCaptionLbl: TextConst ENU = 'Total', ENA = 'Total';
        DocumentDateCaptionLbl: TextConst ENU = 'Document Date', ENA = 'Document Date';
        PhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ENA = 'Phone No.';
        VATRegNoCaptionLbl: TextConst ENU = 'GST Registration No.', ENA = 'Exemption Certificate No.';
        GiroNoCaptionLbl: TextConst ENU = 'Giro No.', ENA = 'Giro No.';
        BankNameCaptionLbl: TextConst ENU = 'Bank', ENA = 'Bank';
        BankAccountNoCaptionLbl: TextConst ENU = 'Account No.', ENA = 'Account No.';
        DueDateCaptionLbl: TextConst ENU = 'Due Date', ENA = 'Due Date';
        InvoiceNoCaptionLbl: TextConst ENU = 'Invoice No.', ENA = 'Invoice No.';
        PostingDateCaptionLbl: TextConst ENU = 'Posting Date', ENA = 'Posting Date';
        ABNCaptionLbl: TextConst ENU = 'ABN', ENA = 'ABN';
        DivisionPartNoCaptionLbl: TextConst ENU = 'Division Part No.', ENA = 'Division Part No.';
        PaymentTermsDescriptionCaptionLbl: TextConst ENU = 'Payment Terms', ENA = 'Payment Terms';
        ShipmentMethodDescriptionCaptionLbl: TextConst ENU = 'Shipment Method', ENA = 'Shipment Method';
        HomePageCaptionLbl: TextConst ENU = 'Home Page', ENA = 'Home Page';
        EmailIdCaptionLbl: TextConst ENU = 'E-Mail', ENA = 'E-Mail';
        HeaderDimensionsCaptionLbl: TextConst ENU = 'Header Dimensions', ENA = 'Header Dimensions';
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ENA = 'Unit Price';
        DiscountPercentCaptionLbl: TextConst ENU = 'Discount%', ENA = 'Discount%';
        AmountCaptionLbl: TextConst ENU = 'Amount', ENA = 'Amount';
        PostedShipmentDateCaptionLbl: TextConst ENU = 'Posted Shipment Date', ENA = 'Posted Shipment Date';
        InvDiscountAmountCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ENA = 'Invoice Discount Amount';
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ENA = 'Subtotal';
        PaymentDiscountonVATCaptionLbl: TextConst ENU = 'Payment Discount on GST', ENA = 'Payment Discount on GST';
        ExchangeRateCaptionLbl: TextConst ENU = 'Exchange Rate', ENA = 'Exchange Rate';
        ShipmentCaptionLbl: TextConst ENU = 'Shipment', ENA = 'Shipment';
        LineDimensionsCaptionLbl: TextConst ENU = 'Line Dimensions', ENA = 'Line Dimensions';
        ShiptoAddressCaptionLbl: TextConst ENU = 'Ship-to Address', ENA = 'Ship-to Address';
        DisplayAdditionalFeeNote: Boolean;
        LineNoWithTotal: Integer;
        CustRec: Record Customer;
        SerialNoText: Text[50];
        SerialNo: Integer;
        ShipToPhoneNo: Text[50];
        ShipToFaxNo: Text[50];
        ShipToRec: Record "Ship-to Address";
        ItemRec: Record Item;
        ContactRec: record Contact;
        SellToContactPhone: Text[50];
        SellToContactFax: Text[50];
        ShipToContactPhone: Text[50];
        RptConverter: Report "Report Converter";
        NoText: array[2] of Text[250];
        // SLCU: Codeunit SLCU;
        TotalTxt: TextConst ENU = 'Total %1';
        TotalInclVATTxt: TextConst ENU = 'Total %1 Incl. GST';
        TotalExclVATTxt: TextConst ENU = 'Total %1 Excl. GST';
        Text000: TextConst ENU = '%1% GST';
        Text001: TextConst ENU = 'GST Amount';
        VATAmountLineRec: record "VAT Amount Line";
        //TermsRec: record Terms;
        CurrCode: Text[5];
        CurrRec: Record Currency;
        SalesLineRecNew: Record "Sales Cr.Memo Line";
        DiscAmt: Decimal;
        SubTotal: Decimal;
        GstAmt: Decimal;
        TotalInclGST: Decimal;
        DiscPercent: Text;
        WebCaptionLbl: Label 'Web';
        EmailCaptionLbl: Label 'Email';
        TelCaptionLbl: Label 'Tel';
        FaxCaptionLbl: Label 'Fax';
        GSTRegNoCaptionLbl: Label 'GST Reg. No.';
        CoRegNoCaptionLbl: Label 'Co. Reg. No.';
        BillToCaptionLbl: Label 'Bill To';
        DeliveryToCaptionLbl: Label 'Delivery To';
        AttnCaptionLbl: Label 'Attn';
        TaxInvoiceNoCaptionLbl: Label 'Tax Invoice No.';
        DateCaptionLbl: Label 'Date';
        YourPONoCaptionLbl: Label 'Your PO No.';
        SalesmanCaptionLbl: Label 'Sales Rep :';
        TermsCaptionLbl: Label 'Terms';
        DriverAreaCaptionLbl: Label 'Driver/Area';
        PageCaptionLbl: Label 'Page';
        GSTValue: text[50];
        ShippingAgentRec: Record "Shipping Agent";
        ShippingAgentDesc: text[50];
        HideDiscount: boolean;
        ItemTrackDocMngt: Codeunit "Item Tracking Doc. Management";//KM20210215
        TempILE: Record "Item Ledger Entry" temporary;//KM20210215
        Batch: Text;// List of [Text];
        ExpirationDate: Text;//List of [Text];
        BarcodeSymbology: Enum "Barcode Symbology";//DX     21 Aug 2021
        BarcodeFontProvider: Interface "Barcode Font Provider";
        barcodeString: text;
        BarcodeText: Text;
        BarcodeOrder: Text;
        //DX        14 Sept 2021
        ExprDateVal: date;
        LineRemark: Text[500]; // YF 02 Nov 2021 // Bug Fix
        ILEQty: Text;
        //DX        14 Sept 2021

        //RL        24 Oct 2021
        SellToAddr3Text: Text[150];
        BillToAddr3Text: Text[150];
        //DX        04 Feb 2022        
        //RL        24 Oct 2021
        FromEmail: Boolean;
        Gbl_SCNH: Record "Sales Cr.Memo Header";

    procedure InitLogInteraction();
    begin
        // LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    local procedure FindPostedShipmentDate(): Date;
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        // NextEntryNo := 1;
        // IF "Sales Cr.Memo Line"."Shipment No." <> '' THEN
        //     IF SalesShipmentHeader.GET("Sales Cr.Memo Line"."Shipment No.") THEN
        //         EXIT(SalesShipmentHeader."Posting Date");

        // IF "Sales Cr.Memo Header"."Order No." = '' THEN
        //     EXIT("Sales Cr.Memo Header"."Posting Date");

        // CASE "Sales Cr.Memo Line".Type OF
        //     "Sales Cr.Memo Line".Type::Item:
        //         GenerateBufferFromValueEntry("Sales Cr.Memo Line");
        //     "Sales Cr.Memo Line".Type::"G/L Account", "Sales Cr.Memo Line".Type::Resource,
        //   "Sales Cr.Memo Line".Type::"Charge (Item)", "Sales Cr.Memo Line".Type::"Fixed Asset":
        //         GenerateBufferFromShipment("Sales Cr.Memo Line");
        //     "Sales Cr.Memo Line".Type::" ":
        //         EXIT(0D);
        // END;

        // SalesShipmentBuffer.RESET;
        // SalesShipmentBuffer.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        // SalesShipmentBuffer.SETRANGE("Line No.", "Sales Cr.Memo Line"."Line No.");
        // IF SalesShipmentBuffer.FIND('-') THEN BEGIN
        //     SalesShipmentBuffer2 := SalesShipmentBuffer;
        //     IF SalesShipmentBuffer.NEXT = 0 THEN BEGIN
        //         SalesShipmentBuffer.GET(
        //           SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
        //         SalesShipmentBuffer.DELETE;
        //         EXIT(SalesShipmentBuffer2."Posting Date");
        //     END;
        //     SalesShipmentBuffer.CALCSUMS(Quantity);
        //     IF SalesShipmentBuffer.Quantity <> "Sales Cr.Memo Line".Quantity THEN BEGIN
        //         SalesShipmentBuffer.DELETEALL;
        //         EXIT("Sales Cr.Memo Header"."Posting Date");
        //     END;
        // END ELSE
        EXIT("Sales Cr.Memo Header"."Posting Date");
    end;

    local procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Cr.Memo Line");
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SETRANGE("Posting Date", "Sales Cr.Memo Header"."Posting Date");
        ValueEntry.SETRANGE("Item Charge No.", '');
        ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
        IF ValueEntry.FIND('-') THEN
            REPEAT
                IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                    IF SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 THEN
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    ELSE
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                END;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            UNTIL (ValueEntry.NEXT = 0) OR (TotalQuantity = 0);
    end;

    local procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Cr.Memo Line");
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        SalesInvoiceLine2: Record "Sales Cr.Memo Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SETCURRENTKEY("Return Order No.");
        SalesInvoiceHeader.SETFILTER("No.", '..%1', "Sales Cr.Memo Header"."No.");
        SalesInvoiceHeader.SETRANGE("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        IF SalesInvoiceHeader.FIND('-') THEN
            REPEAT
                SalesInvoiceLine2.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SETRANGE(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SETRANGE("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SETRANGE("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                IF SalesInvoiceLine2.FIND('-') THEN
                    REPEAT
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    UNTIL SalesInvoiceLine2.NEXT = 0;
            UNTIL SalesInvoiceHeader.NEXT = 0;

        SalesShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        SalesShipmentLine.SETRANGE("Order No.", "Sales Cr.Memo Header"."Return Order No.");
        SalesShipmentLine.SETRANGE("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SETRANGE(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SETRANGE("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SETRANGE("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SETFILTER(Quantity, '<>%1', 0);

        IF SalesShipmentLine.FIND('-') THEN
            REPEAT
                // IF "Sales Cr.Memo Header"."Get Shipment Used" THEN
                //     CorrectShipment(SalesShipmentLine);
                IF ABS(SalesShipmentLine.Quantity) <= ABS(TotalQuantity - SalesInvoiceLine.Quantity) THEN
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                ELSE BEGIN
                    IF ABS(SalesShipmentLine.Quantity) > ABS(TotalQuantity) THEN
                        SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    IF SalesShipmentHeader.GET(SalesShipmentLine."Document No.") THEN
                        AddBufferEntry(
                          SalesInvoiceLine,
                          Quantity,
                          SalesShipmentHeader."Posting Date");
                END;
            UNTIL (SalesShipmentLine.NEXT = 0) OR (TotalQuantity = 0);
    end;

    local procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line");
    var
        SalesInvoiceLine: Record "Sales Cr.Memo Line";
    begin
        // SalesInvoiceLine.SETCURRENTKEY("Shipment No.", "Shipment Line No.");
        // SalesInvoiceLine.SETRANGE("Shipment No.", SalesShipmentLine."Document No.");
        // SalesInvoiceLine.SETRANGE("Shipment Line No.", SalesShipmentLine."Line No.");
        // IF SalesInvoiceLine.FIND('-') THEN
        //     REPEAT
        //         SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
        //     UNTIL SalesInvoiceLine.NEXT = 0;
    end;

    local procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Cr.Memo Line"; QtyOnShipment: Decimal; PostingDate: Date);
    begin
        SalesShipmentBuffer.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SETRANGE("Posting Date", PostingDate);
        IF SalesShipmentBuffer.FIND('-') THEN BEGIN
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.MODIFY;
            EXIT;
        END;

        // WITH SalesShipmentBuffer DO BEGIN
        //     "Document No." := SalesInvoiceLine."Document No.";
        //     "Line No." := SalesInvoiceLine."Line No.";
        //     "Entry No." := NextEntryNo;
        //     Type := SalesInvoiceLine.Type;
        //     "No." := SalesInvoiceLine."No.";
        //     Quantity := QtyOnShipment;
        //     "Posting Date" := PostingDate;
        //     INSERT;
        //     NextEntryNo := NextEntryNo + 1
        // END;

        SalesShipmentBuffer."Document No." := SalesInvoiceLine."Document No.";
        SalesShipmentBuffer."Line No." := SalesInvoiceLine."Line No.";
        SalesShipmentBuffer."Entry No." := NextEntryNo;
        SalesShipmentBuffer.Type := SalesInvoiceLine.Type;
        SalesShipmentBuffer."No." := SalesInvoiceLine."No.";
        SalesShipmentBuffer.Quantity := QtyOnShipment;
        SalesShipmentBuffer."Posting Date" := PostingDate;
        SalesShipmentBuffer.INSERT;
        NextEntryNo := NextEntryNo + 1

    end;

    local procedure DocumentCaption(): Text[250];
    begin
        // IF "Sales Cr.Memo Header"."Prepayment Invoice" THEN
        //     EXIT(Text010);
        EXIT(Text004);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewAmountInWords: Boolean; NewCurrencyLCY: Boolean; NewShowTHFormatting: Boolean; NewDisplayAsmInfo: Boolean; NewDisplayAdditionalFeeNote: Boolean);
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        AmountInWords := NewAmountInWords;
        CurrencyLCY := NewCurrencyLCY;
        ShowTHFormatting := NewShowTHFormatting;
        DisplayAssemblyInformation := NewDisplayAsmInfo;
        DisplayAdditionalFeeNote := NewDisplayAdditionalFeeNote;
    end;

    local procedure FormatDocumentFields(SalesInvoiceHeader: Record "Sales Cr.Memo Header");
    begin
        // WITH SalesInvoiceHeader DO BEGIN
        //     //FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        //     SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        //     FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
        //     FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
        //     FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");

        //     OrderNoText := FormatDocument.SetText("Order No." <> '', FIELDCAPTION("Order No."));
        //     ReferenceText := FormatDocument.SetText("Your Reference" <> '', FIELDCAPTION("Your Reference"));
        //     VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FIELDCAPTION("VAT Registration No."));
        // END;

        //FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        SetTotalLabels(SalesInvoiceHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson, SalesInvoiceHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesInvoiceHeader."Payment Terms Code", SalesInvoiceHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesInvoiceHeader."Shipment Method Code", SalesInvoiceHeader."Language Code");

        OrderNoText := FormatDocument.SetText(SalesInvoiceHeader."Return Order No." <> '', SalesInvoiceHeader.FIELDCAPTION("Return Order No."));
        ReferenceText := FormatDocument.SetText(SalesInvoiceHeader."Your Reference" <> '', SalesInvoiceHeader.FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText(SalesInvoiceHeader."VAT Registration No." <> '', SalesInvoiceHeader.FIELDCAPTION("VAT Registration No."));

    end;

    local procedure FormatAddressFields(SalesInvoiceHeader: Record "Sales Cr.Memo Header");
    var
        CountryRec: Record "Country/Region";
    begin
        FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesCrMemoSellTo(CustAddr, SalesInvoiceHeader);
        ShowShippingAddr := FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, SalesInvoiceHeader);

        BillToAddr3Text := '';
        if SalesInvoiceHeader."Bill-to City" <> '' then
            BillToAddr3Text := SalesInvoiceHeader."Bill-to City" + ' ';
        if SalesInvoiceHeader."Bill-to Country/Region Code" = '' then
            BillToAddr3Text := BillToAddr3Text + 'SINGAPORE '
        else begin
            if CountryRec.Get(SalesInvoiceHeader."Bill-to Country/Region Code") then
                BillToAddr3Text := BillToAddr3Text + UpperCase(CountryRec.Name) + ' ';
        end;
        BillToAddr3Text := BillToAddr3Text + SalesInvoiceHeader."Bill-to Post Code";

        SellToAddr3Text := '';
        if SalesInvoiceHeader."Sell-to City" <> '' then
            SellToAddr3Text := SalesInvoiceHeader."Sell-to City" + ' ';
        if SalesInvoiceHeader."Sell-to Country/Region Code" = '' then
            SellToAddr3Text := SellToAddr3Text + 'SINGAPORE '
        else begin
            if CountryRec.Get(SalesInvoiceHeader."Sell-to Country/Region Code") then
                SellToAddr3Text := SellToAddr3Text + UpperCase(CountryRec.Name) + ' ';
        end;
        SellToAddr3Text := SellToAddr3Text + SalesInvoiceHeader."Sell-to Post Code";
    end;

    local procedure CollectAsmInformation();
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DELETEALL;
        IF "Sales Cr.Memo Line".Type <> "Sales Cr.Memo Line".Type::Item THEN
            EXIT;
        // WITH ValueEntry DO BEGIN
        //     SETCURRENTKEY("Document No.");
        //     SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        //     SETRANGE("Document Type", "Document Type"::"Sales Invoice");
        //     SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
        //     SETRANGE(Adjustment, FALSE);
        //     IF NOT FINDSET THEN
        //         EXIT;
        // END;

        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
        ValueEntry.SETRANGE(Adjustment, FALSE);
        IF NOT ValueEntry.FINDSET THEN
            EXIT;

        REPEAT
            IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
                IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        IF PostedAsmLine.FINDSET THEN
                            REPEAT
                                TreatAsmLineBuffer(PostedAsmLine);
                            UNTIL PostedAsmLine.NEXT = 0;
                    END;
                END;
        UNTIL ValueEntry.NEXT = 0;
    end;

    local procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line");
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        IF TempPostedAsmLine.FINDFIRST THEN BEGIN
            //TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Quantity += PostedAsmLine."Quantity per";
            TempPostedAsmLine.MODIFY;
        END ELSE BEGIN
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        END;
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[10];
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10];
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20]);
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DELETEALL;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeaderNo);
        IF NOT CustLedgerEntry.FINDFIRST THEN
            EXIT;

        IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN
            EXIT;

        LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SETRANGE("Language Code", Customer."Language Code");
        IF LineFeeNoteOnReportHist.FINDSET THEN BEGIN
            REPEAT
                TempLineFeeNoteOnReportHist.INIT;
                TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.INSERT;
            UNTIL LineFeeNoteOnReportHist.NEXT = 0;
        END ELSE BEGIN
            //LineFeeNoteOnReportHist.SETRANGE("Language Code", Language.GetUserLanguage);
            LineFeeNoteOnReportHist.SETRANGE("Language Code", LanguageCU.GetUserLanguageCode());
            IF LineFeeNoteOnReportHist.FINDSET THEN
                REPEAT
                    TempLineFeeNoteOnReportHist.INIT;
                    TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.INSERT;
                UNTIL LineFeeNoteOnReportHist.NEXT = 0;
        END;
    end;

    Procedure SetTotalLabels(CurrencyCode: Code[10]; VAR TotalText: Text[50]; VAR TotalInclVATText: Text[50]; VAR TotalExclVATText: Text[50])
    begin

        IF CurrencyCode = '' THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD("LCY Code");
            TotalText := STRSUBSTNO(TotalTxt, GLSetup."LCY Code");
            TotalInclVATText := STRSUBSTNO(TotalInclVATTxt, GLSetup."LCY Code");
            TotalExclVATText := STRSUBSTNO(TotalExclVATTxt, GLSetup."LCY Code");
        END ELSE BEGIN
            TotalText := STRSUBSTNO(TotalTxt, CurrencyCode);
            TotalInclVATText := STRSUBSTNO(TotalInclVATTxt, CurrencyCode);
            TotalExclVATText := STRSUBSTNO(TotalExclVATTxt, CurrencyCode);
        END;

    end;

    Procedure VATAmountText(): Text[30]
    var
        FullCount: Integer;
        TempVATAmountLine: record "VAT Amount Line";
    begin

        FullCount := TempVATAmountLine.COUNT;
        IF FullCount = 1 THEN BEGIN
            TempVATAmountLine.FINDFIRST;
            IF TempVATAmountLine."VAT %" <> 0 THEN
                EXIT(STRSUBSTNO(Text000, TempVATAmountLine."VAT %"));
        END;
        IF FullCount > 1 THEN BEGIN
            TempVATAmountLine.COPY(VATAmountLineRec, TRUE);
            TempVATAmountLine.FINDFIRST;
            IF TempVATAmountLine."VAT %" <> 0 THEN BEGIN
                TempVATAmountLine.SETRANGE("VAT %", TempVATAmountLine."VAT %");
                IF TempVATAmountLine.COUNT = FullCount THEN
                    EXIT(STRSUBSTNO(Text000, TempVATAmountLine."VAT %"));
            END;
        END;
        EXIT(Text001);

    end;

    procedure SetParamSendEmail(var Param_SCNH: Record "Sales Cr.Memo Header")
    var

    begin
        Gbl_SCNH.reset;
        Gbl_SCNH.Copy(Param_SCNH);
        FromEmail := true;
    end;
}


