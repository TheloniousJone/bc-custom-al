xmlport 52153 "Citibank Local Payment Exd"
{
    Caption = 'Citibank Local Payment Exd';
    Direction = Export;
    Format = VariableText;
    TextEncoding = WINDOWS;
    FieldSeparator = '@';
    FieldDelimiter = '<None>';
    TableSeparator = '<None>';
    RecordSeparator = '<LF>';
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(GenJnlLine; "Gen. Journal Line")
            {
                RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Account Type";

                textelement(ProductCode) // Field 1 - Product Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        ProductCode := 'PLG';
                        ProductCode := SanitizeData(ProductCode, 1, true);
                    end;
                }

                textelement(DebitAcctCountryCode) // Field 2 - Debit Account Country Code - Fixed to SG
                {
                    trigger OnBeforePassVariable()
                    begin
                        DebitAcctCountryCode := 'SG';
                        DebitAcctCountryCode := SanitizeData(DebitAcctCountryCode, 2, true);
                    end;
                }

                textelement(DebitAcctNumber) // Field 3 - Debit Account Number
                {
                    trigger OnBeforePassVariable()
                    begin
                        DebitAcctNumber := SanitizeData(DebitAcctNumber, 3, true);
                    end;
                }

                textelement(PaymentCurrency) // Field 4 - Payment Currency
                {
                    trigger OnBeforePassVariable()
                    begin
                        if GenJnlLine."Currency Code" = '' then
                            PaymentCurrency := GLSetup."LCY Code"
                        else
                            PaymentCurrency := GenJnlLine."Currency Code";

                        PaymentCurrency := SanitizeData(PaymentCurrency, 4, true);
                    end;
                }

                textelement(PaymentAmount) // Field 5 - Payment Amount
                {
                    trigger OnBeforePassVariable()
                    begin
                        PaymentAmount := SanitizeData(PaymentAmount, 5, true);
                    end;
                }

                textelement(BranchCode) // Field 6 - Branch Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        BranchCode := SanitizeData(BranchCode, 6, true);
                    end;
                }

                textelement(ValueDate) // Field 7 - Value Date (Posting Date)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ValueDate := Format(GenJnlLine."Posting Date", 0, '<Year4><Month,2><Day,2>');
                        ValueDate := SanitizeData(ValueDate, 7, true);
                    end;
                }

                textelement(TransactRefNumber) // Field 8 - Transaction Reference Number
                {
                    trigger OnBeforePassVariable()
                    begin
                        TransactRefNumber := SanitizeData(TransactRefNumber, 8, true);
                    end;
                }

                textelement(PreFormatGroupCode) // Field 9 - Pre-format Group Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        PreFormatGroupCode := SanitizeData(PreFormatGroupCode, 9, true);
                    end;
                }

                textelement(PreFormatCode) // Field 10 - Pre-format Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        PreFormatCode := SanitizeData(PreFormatCode, 10, true);
                    end;
                }

                textelement(ConfidentialIndicator) // Field 11 - Confidential Indicator
                {
                    trigger OnBeforePassVariable()
                    begin
                        ConfidentialIndicator := SanitizeData(ConfidentialIndicator, 11, true);
                    end;
                }

                textelement(OrderingPartyType) // Field 12 - Ordering Party Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyType := SanitizeData(OrderingPartyType, 12, true);
                    end;
                }

                textelement(OrderingPartyID) // Field 13 - Ordering Party ID
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyID := SanitizeData(OrderingPartyID, 13, true);
                    end;
                }

                textelement(OrderingPartyName) // Field 14 - Ordering Party Name i.e. Company Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyName := CompanyInfo.Name;
                        OrderingPartyName := SanitizeData(OrderingPartyName, 14, true);
                    end;
                }

                textelement(OrderingPartyAddress1) // Field 15 - Ordering Party Address 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyAddress1 := SanitizeData(OrderingPartyAddress1, 15, true);
                    end;
                }

                textelement(OrderingPartyAddress2) // Field 16 - Ordering Party Address 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyAddress2 := SanitizeData(OrderingPartyAddress2, 16, true);
                    end;
                }

                textelement(OrderingPartyAddress3) // Field 17 - Ordering Party Address 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyAddress3 := SanitizeData(OrderingPartyAddress3, 17, true);
                    end;
                }

                textelement(OrderingPartyRoutingMethod) // Field 18 - Ordering Party Routing Method
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyRoutingMethod := SanitizeData(OrderingPartyRoutingMethod, 18, true);
                    end;
                }

                textelement(OrderingPartyRoutingCode) // Field 19 - Ordering Party Routing Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderingPartyRoutingCode := SanitizeData(OrderingPartyRoutingCode, 19, true);
                    end;
                }

                textelement(BeneficiaryName) // Field 20 - Beneficiary Name - Vendor Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneficiaryName := SanitizeData(BeneficiaryName, 20, true);
                    end;
                }

                textelement(BeneAddress1) // Field 21 - Beneficiary Address 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneAddress1 := SanitizeData(BeneAddress1, 21, true);
                    end;
                }

                textelement(BeneAddress2) // Field 22 - Beneficiary Address 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneAddress2 := SanitizeData(BeneAddress2, 22, true);
                    end;
                }

                textelement(BeneAddress3) // Field 23 - Beneficiary Address 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneAddress3 := SanitizeData(BeneAddress3, 23, true);
                    end;
                }

                textelement(BeneAcctType) // Field 24 - Beneficiary Account or Other ID Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneAcctType := SanitizeData(BeneAcctType, 24, true);
                    end;
                }

                textelement(BeneAcctNo) // Field 25 - Beneficiary Account Number
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneAcctType := SanitizeData(BeneAcctType, 25, true);
                    end;
                }

                textelement(BeneReference) // Field 26 - Beneficiary Reference
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneReference := SanitizeData(BeneReference, 26, true);
                    end;
                }

                textelement(BeneBankName) // Field 27 - Beneficiary Bank Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankName := SanitizeData(BeneBankName, 27, true);
                    end;
                }

                textelement(BeneBankAddress1) // Field 28 - Beneficiary Bank Address 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankAddress1 := SanitizeData(BeneBankAddress1, 28, true);
                    end;
                }

                textelement(BeneBankAddress2) // Field 29 - Beneficiary Bank Address 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankAddress2 := SanitizeData(BeneBankAddress2, 29, true);
                    end;
                }

                textelement(BeneBankAddress3) // Field 30 - Beneficiary Bank Address 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankAddress3 := SanitizeData(BeneBankAddress3, 30, true);
                    end;
                }

                textelement(BeneBankRoutingMethod) // Field 31 - Beneficiary Bank Routing Method
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankRoutingMethod := 'IS';
                        BeneBankRoutingMethod := SanitizeData(BeneBankRoutingMethod, 31, true);
                    end;
                }

                textelement(BeneBankRoutingCode) // Field 32 - Beneficiary Bank Routing Code // SWIFT code
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankRoutingCode := SanitizeData(BeneBankRoutingCode, 32, true);
                    end;
                }

                textelement(BeneBankAccountType) // Field 33 - Beneficiary Bank Account or Other ID Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankAccountType := SanitizeData(BeneBankAccountType, 33, true);
                    end;
                }

                textelement(BeneBankAccount) // Field 34 - Beneficiary Bank Account
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankAccount := SanitizeData(BeneBankAccount, 34, true);
                    end;
                }

                textelement(BeneBankAdviceType) // Field 35 - Beneficiary Bank Advice Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneBankAdviceType := SanitizeData(BeneBankAdviceType, 35, true);
                    end;
                }

                textelement(PaymentDetailsLine1) // Field 36 - Payment Details, Line 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        PaymentDetailsLine1 := SanitizeData(PaymentDetailsLine1, 36, true);
                    end;
                }

                textelement(PaymentDetailsLine2) // Field 37 - Payment Details, Line 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        PaymentDetailsLine2 := SanitizeData(PaymentDetailsLine2, 37, true);
                    end;
                }

                textelement(PaymentDetailsLine3) // Field 38 - Payment Details, Line 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        PaymentDetailsLine3 := SanitizeData(PaymentDetailsLine3, 38, true);
                    end;
                }

                textelement(PaymentDetailsLine4) // Field 39 - Payment Details, Line 4
                {
                    trigger OnBeforePassVariable()
                    begin
                        PaymentDetailsLine4 := SanitizeData(PaymentDetailsLine4, 39, true);
                    end;
                }

                textelement(BeneIsABank) // Field 40 - Beneficiary Is (A Bank)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneIsABank := SanitizeData(BeneIsABank, 40, true);
                    end;
                }

                textelement(B2BInfoLine1) // Field 41 - Bank to Bank Information, Line 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        B2BInfoLine1 := SanitizeData(B2BInfoLine1, 41, true);
                    end;
                }

                textelement(B2BInfoLine2) // Field 42 - Bank to Bank Information, Line 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        B2BInfoLine2 := SanitizeData(B2BInfoLine2, 42, true);
                    end;
                }

                textelement(B2BInfoLine3) // Field 43 - Bank to Bank Information, Line 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        B2BInfoLine3 := SanitizeData(B2BInfoLine3, 43, true);
                    end;
                }

                textelement(B2BInfoLine4) // Field 44 - Bank to Bank Information, Line 4
                {
                    trigger OnBeforePassVariable()
                    begin
                        B2BInfoLine4 := SanitizeData(B2BInfoLine4, 44, true);
                    end;
                }

                textelement(B2BInfoLine5) // Field 45 - Bank to Bank Information, Line 5
                {
                    trigger OnBeforePassVariable()
                    begin
                        B2BInfoLine5 := SanitizeData(B2BInfoLine5, 45, true);
                    end;
                }

                textelement(B2BInfoLine6) // Field 46 - Bank to Bank Information, Line 6
                {
                    trigger OnBeforePassVariable()
                    begin
                        B2BInfoLine6 := SanitizeData(B2BInfoLine6, 46, true);
                    end;
                }

                textelement(IntermBankRoutingMethod) // Field 47 - Intermediary Bank Routing Method
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankRoutingMethod := SanitizeData(IntermBankRoutingMethod, 47, true);
                    end;
                }

                textelement(IntermBankRoutingCode) // Field 48 - Intermediary Bank Routing Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankRoutingCode := SanitizeData(IntermBankRoutingCode, 48, true);
                    end;
                }

                textelement(IntermBankName) // Field 49 - Intermediary Bank Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankName := SanitizeData(IntermBankName, 49, true);
                    end;
                }

                textelement(IntermBankAddress1) // Field 50 - Intermediary Bank Address 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankAddress1 := SanitizeData(IntermBankAddress1, 50, true);
                    end;
                }

                textelement(IntermBankAddress2) // Field 51 - Intermediary Bank Address 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankAddress2 := SanitizeData(IntermBankAddress2, 51, true);
                    end;
                }

                textelement(IntermBankAddress3) // Field 52 - Intermediary Bank Address 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankAddress3 := SanitizeData(IntermBankAddress3, 52, true);
                    end;
                }

                textelement(IntermBankCountryCode) // Field 53 - Intermediary Bank Country Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankCountryCode := SanitizeData(IntermBankCountryCode, 53, true);
                    end;
                }

                textelement(IntermBankCountryName) // Field 54 - Intermediary Bank Country Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntermBankCountryName := SanitizeData(IntermBankCountryName, 54, true);
                    end;
                }

                textelement(FXContract) // Field 55 - FX Contract
                {
                    trigger OnBeforePassVariable()
                    begin
                        FXContract := SanitizeData(FXContract, 55, true);
                    end;
                }

                textelement(ExchangeRate) // Field 56 - Exchange Rate
                {
                    trigger OnBeforePassVariable()
                    begin
                        ExchangeRate := SanitizeData(ExchangeRate, 56, true);
                    end;
                }

                textelement(IntraCompanyIndicator) // Field 57 - IntraCompanyIndicator
                {
                    trigger OnBeforePassVariable()
                    begin
                        IntraCompanyIndicator := SanitizeData(IntraCompanyIndicator, 57, true);
                    end;
                }

                textelement(ChargesIndicator) // Field 58 - Charges Indicator
                {
                    trigger OnBeforePassVariable()
                    begin
                        ChargesIndicator := SanitizeData(ChargesIndicator, 58, true);
                    end;
                }

                textelement(ChargesAccount) // Field 59 - Charges Account
                {
                    trigger OnBeforePassVariable()
                    begin
                        ChargesAccount := SanitizeData(ChargesAccount, 59, true);
                    end;
                }

                textelement(PriorityFlag) // Field 60 - Priority Flag
                {
                    trigger OnBeforePassVariable()
                    begin
                        PriorityFlag := SanitizeData(PriorityFlag, 60, true);
                    end;
                }

                textelement(PreAdviceFlag) // Field 61 - Pre-Advice Flag
                {
                    trigger OnBeforePassVariable()
                    begin
                        PreAdviceFlag := SanitizeData(PreAdviceFlag, 61, true);
                    end;
                }

                textelement(NumOfCreditParties) // Field 62 - Number of Credit Parties
                {
                    trigger OnBeforePassVariable()
                    begin
                        NumOfCreditParties := SanitizeData(NumOfCreditParties, 62, true);
                    end;
                }

                textelement(EntryDescr) // Field 63 - Entry Description
                {
                    trigger OnBeforePassVariable()
                    begin
                        EntryDescr := SanitizeData(EntryDescr, 63, true);
                    end;
                }

                textelement(SecondIntermBankAcctType) // Field 64 - Second Intermediary Bank Account or Other ID Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankAcctType := SanitizeData(SecondIntermBankAcctType, 64, true);
                    end;
                }

                textelement(SecondIntermBankAcctID) // Field 65 - Second Intermediary Bank Accout or Other ID
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankAcctID := SanitizeData(SecondIntermBankAcctID, 65, true);
                    end;
                }

                textelement(SecondIntermBankAdviceType) // Field 66 - Second Intermediary Bank Advice Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankAdviceType := SanitizeData(SecondIntermBankAdviceType, 66, true);
                    end;
                }

                textelement(SecondIntermBankName) // Field 67 - Second Intermediary Bank Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankName := SanitizeData(SecondIntermBankName, 67, true);
                    end;
                }

                textelement(SecondIntermBankAddress1) // Field 68 - second Intermediary Bank Address 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankAddress1 := SanitizeData(SecondIntermBankAddress1, 68, true);
                    end;
                }

                textelement(SecondIntermBankAddress2) // Field 69 - second Intermediary Bank Address 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankAddress2 := SanitizeData(SecondIntermBankAddress2, 69, true);
                    end;
                }

                textelement(SecondIntermBankAddress3) // Field 70 - second Intermediary Bank Address 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        SecondIntermBankAddress3 := SanitizeData(SecondIntermBankAddress3, 70, true);
                    end;
                }

                textelement(AdviceToName) // Field 71 - Advice to Name // Vendor Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        AdviceToName := SanitizeData(AdviceToName, 71, true);
                    end;
                }

                textelement(INTText) // Field 72 - Advice Media/Bene Advice Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        INTText := 'INT';
                        INTText := SanitizeData(INTText, 72, true);
                    end;
                }

                textelement(FaxNumber) // Field 73 - Fax Number
                {
                    trigger OnBeforePassVariable()
                    begin
                        FaxNumber := SanitizeData(FaxNumber, 73, true);
                    end;
                }

                textelement(AltFaxNumber) // Field 74 - Alternate Fax Number
                {
                    trigger OnBeforePassVariable()
                    begin
                        AltFaxNumber := SanitizeData(AltFaxNumber, 74, true);
                    end;
                }

                textelement(ContactPhoneNum) // Field 75 - Contact Phone Number
                {
                    trigger OnBeforePassVariable()
                    begin
                        ContactPhoneNum := SanitizeData(ContactPhoneNum, 75, true);
                    end;
                }

                /*
                textelement(FinanceText)
                {
                    trigger OnBeforePassVariable()
                    begin
                        FinanceText := 'Finance@';
                    end;
                }
                */

                textelement(VendBankAccEmail) // Field 76 + 77 // Email Account and Domain Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        VendBankAccEmail := SanitizeData(VendBankAccEmail, 76, true);
                    end;
                }

                textelement(PaymentType) // Field 78 - Payment Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        PaymentType := SanitizeData(PaymentType, 78, true);
                    end;
                }

                textelement(TransactType) // Field 79 - Trasaction Type
                {
                    trigger OnBeforePassVariable()
                    begin
                        TransactType := SanitizeData(TransactType, 79, true);
                    end;
                }

                textelement(MailToName) // Field 80 - Mail To Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToName := SanitizeData(MailToName, 80, true);
                    end;
                }

                textelement(MailToAddress1) // Field 81 
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToAddress1 := SanitizeData(MailToAddress1, 81, true);
                    end;
                }

                textelement(MailToAddress2) // Field 82 - Mail To Address 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToAddress2 := SanitizeData(MailToAddress2, 82, true);
                    end;
                }

                textelement(MailToAddress3) // Field 83 - Mail To Address 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToAddress3 := SanitizeData(MailToAddress3, 83, true);
                    end;
                }

                textelement(MailToAddress4) // Field 84 - Mail To Address 4
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToAddress4 := SanitizeData(MailToAddress4, 84, true);
                    end;
                }

                textelement(MailToCountryCode) // Field 85 - Mail To Country Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToCountryCode := SanitizeData(MailToCountryCode, 85, true);
                    end;
                }

                textelement(MailToCountryName) // Field 86 - Mail To Country Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        MailToCountryName := SanitizeData(MailToCountryName, 86, true);
                    end;
                }

                textelement(BeneCountryCode) // Field 87 - Beneficiary Country Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneCountryCode := SanitizeData(BeneCountryCode, 87, true);
                    end;
                }

                textelement(BeneCountryName) // Field 88 - Beneficiary Country Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        BeneCountryName := SanitizeData(BeneCountryName, 88, true);
                    end;
                }

                textelement(ClearingCountryCode) // Field 89 - Clearing Country Code
                {
                    trigger OnBeforePassVariable()
                    begin
                        ClearingCountryCode := SanitizeData(ClearingCountryCode, 89, true);
                    end;
                }

                textelement(ClearingCountryName) // Field 90 - Clearing Country Name
                {
                    trigger OnBeforePassVariable()
                    begin
                        ClearingCountryName := SanitizeData(ClearingCountryName, 90, true);
                    end;
                }

                textelement(DeliveryMethod) // Field 91 - Delivery Method
                {
                    trigger OnBeforePassVariable()
                    begin
                        DeliveryMethod := SanitizeData(DeliveryMethod, 91, true);
                    end;
                }

                textelement(PayableAtLocation) // Field 92 - Payable At Location
                {
                    trigger OnBeforePassVariable()
                    begin
                        PayableAtLocation := SanitizeData(PayableAtLocation, 92, true);
                    end;
                }

                textelement(PDCDiscounting) // Field 93 - PDC Discounting
                {
                    trigger OnBeforePassVariable()
                    begin
                        PDCDiscounting := SanitizeData(PDCDiscounting, 93, true);
                    end;
                }

                textelement(CustomField1) // Field 94 - Custom field 1
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField1 := SanitizeData(CustomField1, 94, true);
                    end;
                }

                textelement(CustomField2) // Field 95 - Custom field 2
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField2 := SanitizeData(CustomField2, 95, true);
                    end;
                }

                textelement(CustomField3) // Field 96 - Custom field 3
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField3 := SanitizeData(CustomField3, 96, true);
                    end;
                }

                textelement(CustomField4) // Field 97 - Custom field 4
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField4 := SanitizeData(CustomField4, 97, true);
                    end;
                }

                textelement(CustomField5) // Field 98 - Custom field 5
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField5 := SanitizeData(CustomField5, 98, true);
                    end;
                }

                textelement(CustomField6) // Field 99 - Custom field 6
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField6 := SanitizeData(CustomField6, 99, true);
                    end;
                }

                textelement(CustomField7) // Field 100 - Custom field 7
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField7 := SanitizeData(CustomField7, 100, true);
                    end;
                }

                textelement(CustomField8) // Field 101 - Custom field 8
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField8 := SanitizeData(CustomField8, 101, true);
                    end;
                }

                textelement(CustomField9) // Field 102 - Custom field 9
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField9 := SanitizeData(CustomField9, 102, true);
                    end;
                }

                textelement(CustomField10) // Field 103 - Custom field 10
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField10 := SanitizeData(CustomField10, 103, true);
                    end;
                }

                textelement(CustomField11) // Field 104 - Custom field 11
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField11 := SanitizeData(CustomField11, 104, true);
                    end;
                }

                textelement(CustomField12) // Field 105 - Custom field 12
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField12 := SanitizeData(CustomField12, 105, true);
                    end;
                }

                textelement(CustomField13) // Field 106 - Custom field 13
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField13 := SanitizeData(CustomField13, 106, true);
                    end;
                }

                textelement(CustomField14) // Field 107 - Custom field 14
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField14 := SanitizeData(CustomField14, 107, true);
                    end;
                }

                textelement(CustomField15) // Field 108 - Custom field 15
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField15 := SanitizeData(CustomField15, 108, true);
                    end;
                }

                textelement(CustomField16) // Field 109 - Custom field 16
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField16 := SanitizeData(CustomField16, 109, true);
                    end;
                }

                textelement(CustomField17) // Field 110 - Custom field 17
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField17 := SanitizeData(CustomField17, 110, true);
                    end;
                }

                textelement(CustomField18) // Field 111 - Custom field 18
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField18 := SanitizeData(CustomField18, 111, true);
                    end;
                }

                textelement(CustomField19) // Field 112 - Custom field 19
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomField19 := SanitizeData(CustomField19, 112, true);
                    end;
                }

                textelement(SubsidiaryIdentifier) // Field 113 - Subsidiary Identifier
                {
                    trigger OnBeforePassVariable()
                    begin
                        SubsidiaryIdentifier := SanitizeData(SubsidiaryIdentifier, 113, true);
                    end;
                }

                tableelement(VendLedgerEntry; "Vendor Ledger Entry")
                {
                    LinkTable = GenJnlLine;
                    SourceTableView = sorting("Vendor No.");

                    textelement(InvText) // Field 901 - Invoice detail line - Product Code
                    {
                        trigger OnBeforePassVariable()
                        begin
                            i += 1;

                            if i = 1 then begin
                                Ch10 := 10;
                                InvText := Format(Ch10) + 'INV';
                            end else
                                InvText := 'INV';

                            /*
                            if i = 1 then begin
                                Ch10 := 10;
                                InvText := Format(Ch10) + 'INV@Invoice ';
                            end else
                                InvText := 'INV@Invoice ';
                            */

                            InvText := SanitizeData(InvText, 901, true);
                        end;
                    }

                    textelement(AppliedInvNo) // Field 902 - Invoice detail line - Invoice Data
                    {
                        trigger OnBeforePassVariable()
                        begin
                            if VendLedgerEntry."External Document No." <> '' then begin
                                AppliedInvNo := 'Invoice ' + VendLedgerEntry."External Document No.";
                            end else
                                AppliedInvNo := 'Invoice ' + VendLedgerEntry."Document No.";

                            if (AppliedInvNo = '') Or (AppliedInvNo = 'Invoice ') then
                                CurrXMLport.Skip();

                            AppliedInvNo := SanitizeData(AppliedInvNo, 902, true);
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
    var
        result: Boolean; // YF 24 Aug 2022
        textList: List of [Text];  // YF 24 Aug 2022
        citibankCU: Codeunit CitibankCU;  // YF 24 Aug 2022
        listElementText: Text;  // YF 24 Aug 2022
    begin
        InitInfo();

        if (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::"Bank Account") and (TempGenJnlLine."Bal. Account No." <> '') then begin
            TempGenJnlLine.Testfield(Amount);

            BankAcc.Get(TempGenJnlLine."Bal. Account No.");
            // DebitAcctNumber := BankAcc."Bank Account No.";
            DebitAcctNumber := BankAcc."Citibank Export Account No.";
            PaymentAmount := Format(TempGenJnlLine.Amount);
        end;

        PaymentAmount := Format(TempGenJnlLine.Amount);
        PaymentAmount := DelChr(PaymentAmount, '=', ',');

        // YF 24 Aug 2022
        Clear(citibankCU);
        Clear(textList);
        if citibankCU.SplitTextBySize(TempGenJnlLine.Description, textList, 35) then begin
            if textList.Get(1, listElementText) then
                PaymentDetailsLine1 := listElementText;

            if textList.Get(2, listElementText) then
                PaymentDetailsLine2 := listElementText;

            if textList.Get(3, listElementText) then
                PaymentDetailsLine3 := listElementText;

            if textList.Get(4, listElementText) then
                PaymentDetailsLine4 := listElementText;
        end;
        // YF 24 Aug 2022

        case TempGenJnlLine."Account Type" of
            TempGenJnlLine."Account Type"::Vendor:
                begin
                    if Vendor.Get(TempGenJnlLine."Account No.") then begin
                        Vendor.Testfield(Name);
                        Vendor.Testfield("Preferred Bank Account Code");
                        BeneficiaryName := CopyStr(Vendor.Name, 1, 20);
                        AdviceToName := CopyStr(Vendor.Name, 1, 35);

                        if VendorBankAcc.Get(Vendor."No.", Vendor."Preferred Bank Account Code") then begin
                            VendorBankAcc.TestField("Bank Account No.");
                            VendorBankAcc.TestField(Name);
                            VendorBankAcc.TestField("SWIFT Code");
                            VendorBankAcc.TestField("E-Mail");

                            BeneAcctNo := VendorBankAcc."Bank Account No.";
                            VendBankAccEmail := VendorBankAcc."E-Mail";
                            BeneBankRoutingCode := VendorBankAcc."SWIFT Code";

                            // To be shifted to sanitize
                            If StrLen(VendBankAccEmail) = 0 then
                                VendBankAccEmail := '@';
                        end;
                    end;
                end;
        end;
    end;

    procedure InitInfo()
    begin
        PaymentAmount := '';
        DebitAcctNumber := '';
        BeneficiaryName := '';
        AdviceToName := '';
        BeneAcctNo := '';
        VendBankAccEmail := '';
        BeneBankRoutingCode := '';

        // YF 24 Aug 2022
        PaymentDetailsLine1 := '';
        PaymentDetailsLine2 := '';
        PaymentDetailsLine3 := '';
        PaymentDetailsLine4 := '';
        // YF 24 Aug 2022
    end;

    local procedure SanitizeData(TextInput: Text; FieldNo: Integer; ShowErrMsg: Boolean): Text
    var
        TextOutput: Text;
        EvalDecimal: Decimal;
    begin

        case FieldNo of
            1:
                begin
                    // Product Code
                    if ShowErrMsg then begin
                        if not (TextInput in ['PLC', 'PLG', 'PLP', 'OCT', 'OPL']) then
                            Error('Product Code not valid');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 3);
                    exit(TextOutput);
                end;
            2:
                begin
                    // Debit Account Country Code
                    if ShowErrMsg then begin
                        if (StrLen(TextInput) > 2) Or (TextInput = '') then
                            Error('ISO Country Code cannot be more than 2 characters or empty');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 2);
                    exit(TextOutput);
                end;
            3:
                begin
                    // Debit Account Number
                    if ShowErrMsg then begin
                        if (StrLen(TextInput) > 35) Or (TextInput = '') then
                            Error('Debit Account Number cannot be more than 35 characters or empty');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            4:
                begin
                    // Payment Currency
                    if ShowErrMsg then begin
                        if (StrLen(TextInput) > 3) Or (TextInput = '') then
                            Error('Payment Currency cannot be more than 3 characers or empty');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 3);
                    exit(TextOutput);
                end;
            5:
                begin
                    // Payment Amount
                    if ShowErrMsg then begin
                        if (StrLen(TextInput) > 21) Or (TextInput = '') then
                            Error('Payment Amount cannot be empty or more than 21 numeric value');

                        if Evaluate(EvalDecimal, TextInput) then begin
                            if EvalDecimal <= 0 then
                                Error('Payment Amount less or equal to zero');
                        end
                        else
                            Error('Invalid Payment Amount numeric value');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 21);
                    exit(TextOutput);
                end;
            6:
                begin
                    // Branch Code
                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 3 then
                            Error('Branch code cannot be more than 3 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 3);
                    exit(TextOutput);
                end;
            7:
                begin
                    // Value Date
                    if ShowErrMsg then begin
                        if (StrLen(TextInput) <> 8) And (TextInput <> '') then
                            Error('Value Date has to be 8 characters in YYYYMMDD format');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 8);
                    exit(TextOutput);
                end;
            8:
                begin
                    // Transaction Reference Number
                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 15 then
                            Error('Transaction Reference Number cannot be more than 15 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 15);
                    exit(TextOutput);
                end;
            9:
                begin
                    // Pre-format Group Code
                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 16 then
                            Error('Pre-format Group Code cannot be more than 16 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 16);
                    exit(TextOutput);
                end;
            10:
                begin
                    // Pre-format Code
                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 35 then
                            Error('Pre-format Code cannot be more than 35 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            11:
                begin
                    // Confidential Indicator
                    if ShowErrMsg then begin
                        if (TextInput <> 'C') And (TextInput <> ' ') And (TextInput <> '') then
                            Error('Confidential Indicator valid values either C or Blank or not specificed');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 1);
                    exit(TextOutput);
                end;
            12:
                begin
                    // Ordering Party ID/Advice Type
                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 6); // Max 6 characters
                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            13:
                begin
                    // Ordering Party ID
                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 34); // Max 34 characters
                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            14:
                begin
                    // Ordering Party Name
                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 35 then
                            Error('Ordering Party Name cannot be more than 35 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            15 .. 19:
                begin
                    // 15. Ordering Party Address 1 - Max Length 35X
                    // 16. Ordering Party Address 2 - Max Length 35X
                    // 17. Ordering Party Address 3 - Max Length 35X
                    // 18. Ordering Party Routing Method - Max Length 35X
                    // 19. Ordering Party Routing Code - Max Length 11X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            20:
                begin
                    // Beneficiary Name
                    if ProductCode in ['PLC'] then begin
                        if ShowErrMsg then begin
                            if (StrLen(TextInput) > 70) Or (TextInput = '') then
                                Error('Beneficiary Name cannot be more than 70 characters or empty');
                        end;

                        if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 70); // Giro 20 chars, Fast 35 chars, Othrs 70 chars
                    end;

                    if ProductCode in ['PLG', 'PLP'] then begin
                        if ShowErrMsg then begin
                            if StrLen(TextInput) > 20 then
                                Error('Beneficiary Name cannot be more than 20 characters');
                        end;

                        if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 20); // Giro 20 chars, Fast 35 chars
                    end;

                    if ProductCode in ['OCT', 'OPL'] then begin
                        if ShowErrMsg then begin
                            if StrLen(TextInput) > 35 then
                                Error('Beneficiary Name cannot be more than 35 characters');
                        end;

                        if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35); // Giro 20 chars, Fast 35 chars
                    end;

                    exit(TextOutput);
                end;
            21 .. 24:
                begin
                    // 21. Beneficiary Address 1 - Max Length 35X
                    // 22. Beneficiary Address 2 - Max Length 35X
                    // 23. Beneficiary Address 3 - Max Length 35X
                    // 24. Beneficiary Account or Other ID Type - Max Length 6X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            25:
                begin
                    // Beneficiary Account Number or Other ID

                    if ProductCode in ['PLC'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 34 then
                            Error('Beneficiary Account Number or Other ID cannot be more than 34 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 34);
                    exit(TextOutput);
                end;
            26 .. 31:
                begin
                    // 26. Beneficiary Reference - Max Length 35X
                    // 27. Beneficiary Bank Name - Max Length 35X
                    // 28. Beneficiary Bank Address 1 - Max Length 35X
                    // 29. Beneficiary Bank Address 2 - Max Length 35X
                    // 30. Beneficiary Bank Address 3 - Max Length 35X
                    // 31. Beneficiary Bank Routing Method - Max Length 35X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            32:
                begin
                    // Beneficiary Bank Routing Code

                    if ProductCode in ['PLC'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 11 then
                            Error('Beneficiary Bank Routing Code cannot be more than 11 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 11);
                    exit(TextOutput);
                end;
            33 .. 35:
                begin
                    // 33. Beneficiary Bank Account or Other ID Type - Max Length 6X
                    // 34. Beneficiary Bank Account - Max Length 34X
                    // 35. Beneficiary Bank Advice Type - Max Length 10X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            36:
                begin
                    // Payment Details Line 1

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 35 then
                            Error('Payment Details Line 1 cannot be more than 35 characters');
                    end;

                    if ProductCode in ['PLG', 'PLP'] then begin
                        if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 12); // For PLG/PLP, only first 12 characters are sent to clearing house
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            37 .. 39:
                begin
                    // 37. Payment Details Line 2
                    // 38. Payment Details Line 3
                    // 39. Payment Details Line 4

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 35 then
                            Error('Payment Details Line cannot be more than 35 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            40 .. 70:
                begin
                    // 40. Beneficiary Is [A Bank] - Max Length 10X
                    // 41. Bank to Bank Information Line 1 - Max Length 35X
                    // 42. Bank to Bank Information Line 2 - Max Length 35X
                    // 43. Bank to Bank Information Line 3 - Max Length 35X
                    // 44. Bank to Bank Information Line 4 - Max Length 35X
                    // 45. Bank to Bank Information Line 5 - Max Length 35X
                    // 46. Bank to Bank Information Line 6 - Max Length 35X
                    // 47. Intermediary Bank Routing Method - Max Length 35X
                    // 48. Intermediary Bank Routing Code - Max Length 11X
                    // 49. Intermediary Bank Name - Max Length 35X
                    // 50. Intermediary Bank Address 1 - Max Length 35X
                    // 51. Intermediary Bank Address 2 - Max Length 35X
                    // 52. Intermediary Bank Address 3 - Max Length 35X
                    // 53. Intermediary Bank Country Code - Max Length 2X
                    // 54. Intermediary Bank Country Name - Max Length 35X
                    // 55. FX Contract - Max Length 20X
                    // 56. Exchange Rate - Max Length 20X
                    // 57. Intra-company [Indicator] - Max Length 1X
                    // 58. Charges Indicator - Max Length 3X
                    // 59. Charges Account - Max Length 34X
                    // 60. Priority Flag - Max Length 1X
                    // 61. Pre-Advice Flag - Max Length 1X
                    // 62. Number of Credit Parties - Max Length 35X
                    // 63. Entry Description - Max Length 10X
                    // 64. Second Intermediary Bank Account or Other ID Type - Max Length 6X
                    // 65. Second Intermediary Bank Account or Other ID - Max Length 64X
                    // 66. Second Intermediary Bank Advice Type - Max Length 10X
                    // 67. Second Intermediary Bank Name - Max Length 35X
                    // 68. Second Intermediary Bank Address 1 - Max Length 35X
                    // 69. Second Intermediary Bank Address 2 - Max Length 35X
                    // 70. Second Intermediary Bank Address 3 - Max Length 35X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            71:
                begin
                    // Advice To Name
                    if ProductCode in ['PLC', 'PLG', 'PLP'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ProductCode in ['OCT', 'OPL'] then begin
                        if ShowErrMsg then begin
                            if StrLen(TextInput) > 35 then
                                Error('Advice To Name cannot be more than 35 characters');
                        end;
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            72:
                begin
                    // Advice Media/Bene Advice Type
                    if ProductCode in ['PLC', 'PLG', 'PLP'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ProductCode in ['OCT', 'OPL'] then begin
                        if ShowErrMsg then begin
                            if StrLen(TextInput) > 10 then
                                Error('Advice To Name cannot be more than 10 characters');
                        end;
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 10);
                    exit(TextOutput);
                end;
            73:
                begin
                    // Fax Number
                    if ProductCode in ['PLP', 'OCT', 'OPL'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ProductCode in ['PLC', 'PLG'] then begin
                        if ShowErrMsg then begin
                            if StrLen(TextInput) > 15 then
                                Error('Fax Number cannot be more than 15 characters');
                        end;
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 15);
                    exit(TextOutput);
                end;
            74 .. 75:
                begin
                    // 74. Alternate Fax Number - Max Length 15X
                    // 75. Contact Phone Number - Max Length 35X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            76 .. 77:
                begin
                    // 76. Internet Address Account Name
                    // 77. Internet Address Domain Name
                    if ProductCode in ['PLP'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 50 then
                            Error('Internet Address Email cannot be more than 50 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 50);
                    exit(TextOutput);
                end;
            78:
                begin
                    // Payment Type - Max Length 4X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            79:
                begin
                    // Transaction Type
                    if ProductCode in ['PLC'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 4 then
                            Error('Transaction Type cannot be more than 4 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 4);
                    exit(TextOutput);
                end;
            80 .. 84:
                begin
                    // 80. Mail To Name
                    // 81. Mail To Address 1
                    // 82. Mail To Address 2
                    // 83. Mail To Address 3
                    // 84. Mail To Address 4

                    if ProductCode in ['OCT', 'OPL'] then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 35 then
                            Error('Mail To Name/Address Lines cannot be more than 35 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 35);
                    exit(TextOutput);
                end;
            85 .. 90:
                begin
                    // 85. Mail To Country Code - Max Length 2X
                    // 86. Mail To Country Name - Max Length 35X
                    // 87. Beneficiary Country Code - Max Length 2X
                    // 88. Beneficiary Country Name - Max Length 35X
                    // 89. Clearing Country Code - Max Length 2X
                    // 90. Clearing Country Name - Max Length 35X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            91:
                begin
                    // Delivery Method
                    if ProductCode in ['PLC'] then begin
                        if ShowErrMsg then begin
                            if StrLen(TextInput) > 5 then
                                Error('Delivery Method cannot be more than 4 characters');

                            if not (TextInput in ['MAIL', 'RET', 'C/OR', 'C/R']) then
                                Error('Delivery Method not valid');
                        end;

                        if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 5);
                        exit(TextOutput);
                    end;

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            92 .. 93:
                begin
                    // 92. Payable at Location - Max Length 9X
                    // 93. PDC Discounting - Max Length 10X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            94:
                begin
                    // Custom Field 1

                    if not (ProductCode in ['OCT', 'OPL']) then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if (StrLen(TextInput) > 70) Or (TextInput = '') then
                            Error('Custom field 1 cannot be more than 70 characters or empty');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 70);
                    exit(TextOutput);
                end;
            95:
                begin
                    // Custom Field 2

                    if not (ProductCode in ['OCT', 'OPL']) then begin
                        TextOutput := ''; // Not required
                        exit(TextOutput);
                    end;

                    if ShowErrMsg then begin
                        if (StrLen(TextInput) > 70) then
                            Error('Custom field 2 cannot be more than 70 characters or empty');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 70);
                    exit(TextOutput);
                end;
            96 .. 112:
                begin
                    // Custom field 3-19 - Max Length 70X

                    TextOutput := ''; // Not required
                    exit(TextOutput);
                end;
            113:
                begin
                    // Subsidiary Identifier

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 5 then
                            Error('Subsidiary Identifier cannot be more than 5 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 5);
                    exit(TextOutput);
                end;
            901:
                begin
                    // Invoice details line - Product Code
                    // Disabled 
                    /*
                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 3 then
                            Error('Invoice Detail Line Product Code cannot be more than 3 characters');

                        if (TextInput <> '') And (TextInput <> 'INV') then
                            Error('Invoice Detail Line Product Code must be INV');
                    end;

                    if StrLen(TextOutput) > 0 then TextOutput := CopyStr(TextInput, 1, 3);
                    */
                    exit(TextInput);
                end;
            902:
                begin
                    // Invoice details line - Invoice Data

                    if ShowErrMsg then begin
                        if StrLen(TextInput) > 75 then
                            Error('Invoice Detail Line Product Code cannot be more than 3 characters');
                    end;

                    if StrLen(TextInput) > 0 then TextOutput := CopyStr(TextInput, 1, 75);
                    exit(TextOutput);
                end;
            else begin
                // Invalid field no.
            end;
        end;

        exit(TextInput);
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