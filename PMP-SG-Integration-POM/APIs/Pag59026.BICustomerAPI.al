page 59026 BICustomerAPI
{
    APIGroup = 'pom_integration';
    APIPublisher = 'illum9';
    APIVersion = 'v2.0';
    Editable = false;
    EntityName = 'BOcustomerAPI';
    EntitySetName = 'BIcustomers';
    PageType = API;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(acctInformation; Rec."Acct Information")
                {
                    Caption = 'Acct Information';
                }
                field(activateCommercial; Rec."Activate Commercial")
                {
                    Caption = 'Activate Commercial';
                }
                field(activateForensic; Rec."Activate Forensic")
                {
                    Caption = 'Activate Forensic';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(allowLineDisc; Rec."Allow Line Disc.")
                {
                    Caption = 'Allow Line Disc.';
                }
                field(allowMultiplePostingGroups; Rec."Allow Multiple Posting Groups")
                {
                    Caption = 'Allow Multiple Posting Groups';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(applicationMethod; Rec."Application Method")
                {
                    Caption = 'Application Method';
                }
                field(balance; Rec.Balance)
                {
                    Caption = 'Balance';
                }
                field(balanceLCY; Rec."Balance (LCY)")
                {
                    Caption = 'Balance (LCY)';
                }
                field(balanceDue; Rec."Balance Due")
                {
                    Caption = 'Balance Due';
                }
                field(balanceDueLCY; Rec."Balance Due (LCY)")
                {
                    Caption = 'Balance Due (LCY)';
                }
                field(baseCalendarCode; Rec."Base Calendar Code")
                {
                    Caption = 'Base Calendar Code';
                }
                field(billAddress; Rec."Bill Address")
                {
                    Caption = 'Bill Address';
                }
                field(billAddress2; Rec."Bill Address 2")
                {
                    Caption = 'Bill Address 2';
                }
                field(billCity; Rec."Bill City")
                {
                    Caption = 'Bill City';
                }
                field(billContact; Rec."Bill Contact")
                {
                    Caption = 'Bill Contact';
                }
                field(billCountryCode; Rec."Bill Country Code")
                {
                    Caption = 'Bill Country Code';
                }
                field(billCounty; Rec."Bill County")
                {
                    Caption = 'Bill County';
                }
                field(billName; Rec."Bill Name")
                {
                    Caption = 'Bill Name';
                }
                field(billName2; Rec."Bill Name 2")
                {
                    Caption = 'Bill Name 2';
                }
                field(billPostCode; Rec."Bill Post Code")
                {
                    Caption = 'Bill Post Code';
                }
                field(billToNoOfBlanketOrders; Rec."Bill-To No. of Blanket Orders")
                {
                    Caption = 'Bill-To No. of Blanket Orders';
                }
                field(billToNoOfCreditMemos; Rec."Bill-To No. of Credit Memos")
                {
                    Caption = 'Bill-To No. of Credit Memos';
                }
                field(billToNoOfInvoices; Rec."Bill-To No. of Invoices")
                {
                    Caption = 'Bill-To No. of Invoices';
                }
                field(billToNoOfOrders; Rec."Bill-To No. of Orders")
                {
                    Caption = 'Bill-To No. of Orders';
                }
                field(billToNoOfPstdCrMemos; Rec."Bill-To No. of Pstd. Cr. Memos")
                {
                    Caption = 'Bill-To No. of Pstd. Cr. Memos';
                }
                field(billToNoOfPstdInvoices; Rec."Bill-To No. of Pstd. Invoices")
                {
                    Caption = 'Bill-To No. of Pstd. Invoices';
                }
                field(billToNoOfPstdReturnR; Rec."Bill-To No. of Pstd. Return R.")
                {
                    Caption = 'Bill-To No. of Pstd. Return R.';
                }
                field(billToNoOfPstdShipments; Rec."Bill-To No. of Pstd. Shipments")
                {
                    Caption = 'Bill-To No. of Pstd. Shipments';
                }
                field(billToNoOfQuotes; Rec."Bill-To No. of Quotes")
                {
                    Caption = 'Bill-To No. of Quotes';
                }
                field(billToNoOfReturnOrders; Rec."Bill-To No. of Return Orders")
                {
                    Caption = 'Bill-To No. of Return Orders';
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(billToNoOfArchivedDoc; Rec."Bill-to No. Of Archived Doc.")
                {
                    Caption = 'Bill-to No. Of Sales Archived Doc.';
                }
                field(bizRegistrationType; Rec."Biz Registration Type")
                {
                    Caption = 'Biz Registration Type';
                }
                field(blockPaymentTolerance; Rec."Block Payment Tolerance")
                {
                    Caption = 'Block Payment Tolerance';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(branchSubsidiary; Rec."Branch/Subsidiary")
                {
                    Caption = 'Branch/Subsidiary';
                }


                field(chainName; Rec."Chain Name")
                {
                    Caption = 'Chain Name';
                }
                field(chainPharmacy; Rec."Chain Pharmacy")
                {
                    Caption = 'Chain Pharmacy';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }

                field(combineServiceShipments; Rec."Combine Service Shipments")
                {
                    Caption = 'Combine Service Shipments';
                }
                field(combineShipments; Rec."Combine Shipments")
                {
                    Caption = 'Combine Sales Shipments';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(commercialPermissionGroup; Rec."Commercial Permission Group")
                {
                    Caption = 'Commercial Permission Group';
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(contactGraphId; Rec."Contact Graph Id")
                {
                    Caption = 'Contact Graph Id';
                }
                field(contactID; Rec."Contact ID")
                {
                    Caption = 'Contact ID';
                }
                field(contactType; Rec."Contact Type")
                {
                    Caption = 'Contact Type';
                }
                field(contractGainLossAmount; Rec."Contract Gain/Loss Amount")
                {
                    Caption = 'Contract Gain/Loss Amount';
                }
                field(copySellToAddrToQteFrom; Rec."Copy Sell-to Addr. to Qte From")
                {
                    Caption = 'Copy Sell-to Addr. to Qte From';
                }
                field(corporateSalesRep4; Rec."Corporate  Sales Rep (4)")
                {
                    Caption = 'Corporate  Sales Rep (4)';
                }
                field(corporateSalesRep5; Rec."Corporate  Sales Rep (5)")
                {
                    Caption = 'Corporate  Sales Rep (5)';
                }

                field(corporateSalesRepHB; Rec."Corporate  Sales Rep (HB)")
                {
                    Caption = 'Corporate  Sales Rep (HB)';
                }
                field(corporateSalesRepHYP; Rec."Corporate  Sales Rep (HYP)")
                {
                    Caption = 'Corporate  Sales Rep (HYP)';
                }
                field(corporateSalesRepWS; Rec."Corporate  Sales Rep (WS)")
                {
                    Caption = 'Corporate  Sales Rep (WS)';
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(county; Rec.County)
                {
                    Caption = 'County';
                }

                field(coverageDate; Rec."Coverage Date")
                {
                    Caption = 'Coverage Date';
                }
                field(crMemoAmounts; Rec."Cr. Memo Amounts")
                {
                    Caption = 'Cr. Memo Amounts';
                }
                field(crMemoAmountsLCY; Rec."Cr. Memo Amounts (LCY)")
                {
                    Caption = 'Cr. Memo Amounts (LCY)';
                }
                field(creditAmount; Rec."Credit Amount")
                {
                    Caption = 'Credit Amount';
                }
                field(creditAmountLCY; Rec."Credit Amount (LCY)")
                {
                    Caption = 'Credit Amount (LCY)';
                }
                field(creditInsurance; Rec."Credit Insurance")
                {
                    Caption = 'Credit Insurance';
                }
                field(creditLimitLCY; Rec."Credit Limit (LCY)")
                {
                    Caption = 'Credit Limit (LCY)';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(currencyId; Rec."Currency Id")
                {
                    Caption = 'Currency Id';
                }
                field(customerCommissionGroup; Rec."Customer Commission Group")
                {
                    Caption = 'Customer Commission Group';
                }
                field(customerDiscGroup; Rec."Customer Disc. Group")
                {
                    Caption = 'Customer Disc. Group';
                }
                field(customerGroup; Rec."Customer Group")
                {
                    Caption = 'Customer Group';
                }
                field(customerInstructions; Rec."Customer Instructions")
                {
                    Caption = 'Customer Instructions';
                }
                field(customerPostingGroup; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                }
                field(customerPriceGroup; Rec."Customer Price Group")
                {
                    Caption = 'Customer Price Group';
                }
                field(customerSalesClassification; Rec."Customer Sales Classification")
                {
                    Caption = 'Customer Sales Classification';
                }
                field(customerStatus; Rec."Customer Status")
                {
                    Caption = 'Customer Status';
                }
                field(debitAmount; Rec."Debit Amount")
                {
                    Caption = 'Debit Amount';
                }
                field(debitAmountLCY; Rec."Debit Amount (LCY)")
                {
                    Caption = 'Debit Amount (LCY)';
                }

                field(deliveryCharge; Rec."Delivery Charge")
                {
                    Caption = 'Delivery Charge';
                }
                field(deliveryInstructions; Rec."Delivery Instructions")
                {
                    Caption = 'Delivery Instructions';
                }
                field(deliveryZone; Rec."Delivery Zone")
                {
                    Caption = 'Delivery Zone';
                }
                field(disableSearchByName; Rec."Disable Search by Name")
                {
                    Caption = 'Disable Search by Name';
                }
                field(eInvoicing; Rec."E-Invoicing")
                {
                    Caption = 'E-Invoicing';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }



                field(forensicPermmissionGroup; Rec."Forensic Permmission Group")
                {
                    Caption = 'Forensic Permmission Group';
                }


                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                }
                field(homePage; Rec."Home Page")
                {
                    Caption = 'Home Page';
                }
                field(i9GAutoEmailInvEmailAddress; Rec.I9G_AutoEmailInvEmailAddress)
                {
                    Caption = 'Auto Email Inv. Email Address';
                }
                field(i9GAutoEmailInvoice; Rec.I9G_AutoEmailInvoice)
                {
                    Caption = 'Auto Email Invoice';
                }

                field(i9GDONeeded; Rec.I9G_DONeeded)
                {
                    Caption = 'DO Needed';
                }
                field(i9GEmailonPriceChg; Rec.I9G_EmailonPriceChg)
                {
                    Caption = 'Email on Price Change';
                }
                field(i9GPriceExtLeadTime; Rec.I9G_PriceExtLeadTime)
                {
                    Caption = 'Price Extension Lead Time';
                }
                field(i9GRequirementApproval; Rec.I9G_RequirementApproval)
                {
                    Caption = 'Requirement Approval';
                }
                field(i9GSector; Rec.I9G_Sector)
                {
                    Caption = 'Sector';
                }
                field(i9GShowRefNo; Rec.I9G_ShowRefNo)
                {
                    Caption = 'Trigger Ref. Code';
                }


                field(insuranceCoverage; Rec."Insurance Coverage")
                {
                    Caption = 'Insurance Coverage';
                }

                field(invAmountsLCY; Rec."Inv. Amounts (LCY)")
                {
                    Caption = 'Inv. Amounts (LCY)';
                }
                field(invDiscountsLCY; Rec."Inv. Discounts (LCY)")
                {
                    Caption = 'Inv. Discounts (LCY)';
                }
                field(invoiceAmounts; Rec."Invoice Amounts")
                {
                    Caption = 'Invoice Amounts';
                }
                //TN        21 Sept 2026
                //Removed: Customer."Invoice Copies" is ObsoleteState = Pending (tag 27.0), AL0432
                // field(invoiceCopies; Rec."Invoice Copies")
                // {
                //     Caption = 'Invoice Copies';
                // }
                //TN        21 Sept 2026
                field(invoiceDiscCode; Rec."Invoice Disc. Code")
                {
                    Caption = 'Invoice Disc. Code';
                }
                field(lsPercentage; Rec."LS Percentage")
                {
                    Caption = 'Logistics Service % calculation.';
                }

                field(lastDateModified; Rec."Last Date Modified")
                {
                    Caption = 'Last Date Modified';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                }
                field(lastStatementNo; Rec."Last Statement No.")
                {
                    Caption = 'Last Statement No.';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(logisticsService; Rec."Logistics Service")
                {
                    Caption = 'Logistics Service';
                }
                field(mohLicenseNo; Rec."MOH License No.")
                {
                    Caption = 'MOH License No.';
                }
                field(mandatoryExtDocNo; Rec."Mandatory Ext Doc. No.")
                {
                    Caption = 'Mandatory Ext Doc. No.';
                }
                field(mobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }

                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                }
                field(netChange; Rec."Net Change")
                {
                    Caption = 'Net Change';
                }
                field(netChangeLCY; Rec."Net Change (LCY)")
                {
                    Caption = 'Net Change (LCY)';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                // field(noOfTBADOs; Rec."No. Of TBA DOs")
                // {
                //     Caption = 'No. Of TBA DOs';
                // }
                // field(noOfTBAInvoices; Rec."No. Of TBA Invoices")
                // {
                //     Caption = 'No. Of TBA Invoices';
                // }

                // field(noOfInvoices; Rec."No. of Invoices")
                // {
                //     Caption = 'No. of Invoices';
                // }
                // field(noOfOrders; Rec."No. of Orders")
                // {
                //     Caption = 'No. of Orders';
                // }
                // field(noOfPstdCreditMemos; Rec."No. of Pstd. Credit Memos")
                // {
                //     Caption = 'No. of Pstd. Credit Memos';
                // }
                // field(noOfPstdInvoices; Rec."No. of Pstd. Invoices")
                // {
                //     Caption = 'No. of Pstd. Invoices';
                // }
                // field(noOfPstdReturnReceipts; Rec."No. of Pstd. Return Receipts")
                // {
                //     Caption = 'No. of Pstd. Return Receipts';
                // }
                // field(noOfPstdShipments; Rec."No. of Pstd. Shipments")
                // {
                //     Caption = 'No. of Pstd. Shipments';
                // }
                // field(noOfQuotes; Rec."No. of Quotes")
                // {
                //     Caption = 'No. of Quotes';
                // }
                // field(noOfReturnOrders; Rec."No. of Return Orders")
                // {
                //     Caption = 'No. of Return Orders';
                // }
                // field(noOfShipToAddresses; Rec."No. of Ship-to Addresses")
                // {
                //     Caption = 'No. of Ship-to Addresses';
                // }
                field(oneTimeCustomer; Rec."One-time Customer")
                {
                    Caption = 'One-time Customer';
                }
                field(otherAmounts; Rec."Other Amounts")
                {
                    Caption = 'Other Amounts';
                }
                field(otherAmountsLCY; Rec."Other Amounts (LCY)")
                {
                    Caption = 'Other Amounts (LCY)';
                }
                field(ourAccountNo; Rec."Our Account No.")
                {
                    Caption = 'Our Account No.';
                }
                // field(outstandingInvoices; Rec."Outstanding Invoices")
                // {
                //     Caption = 'Outstanding Invoices';
                // }
                // field(outstandingInvoicesLCY; Rec."Outstanding Invoices (LCY)")
                // {
                //     Caption = 'Outstanding Invoices (LCY)';
                // }
                // field(outstandingOrders; Rec."Outstanding Orders")
                // {
                //     Caption = 'Outstanding Orders';
                // }
                // field(outstandingOrdersLCY; Rec."Outstanding Orders (LCY)")
                // {
                //     Caption = 'Outstanding Orders (LCY)';
                // }
                // field(outstandingServOrdersLCY; Rec."Outstanding Serv. Orders (LCY)")
                // {
                //     Caption = 'Outstanding Serv. Orders (LCY)';
                // }
                // field(outstandingServInvoicesLCY; Rec."Outstanding Serv.Invoices(LCY)")
                // {
                //     Caption = 'Outstanding Serv.Invoices(LCY)';
                // }
                field(pomCustomer; Rec."POM Customer")
                {
                    Caption = 'POM Customer';
                }
                field(pomNo; Rec."POM No.")
                {
                    Caption = 'POM No.';
                }

                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }

                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }

                field(payments; Rec.Payments)
                {
                    Caption = 'Payments';
                }
                field(paymentsLCY; Rec."Payments (LCY)")
                {
                    Caption = 'Payments (LCY)';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(pickingInstructions; Rec."Picking Instructions")
                {
                    Caption = 'Picking Instructions';
                }


                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(preferredBankAccountCode; Rec."Preferred Bank Account Code")
                {
                    Caption = 'Preferred Bank Account Code';
                }


                field(pricesIncludingVAT; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Including VAT';
                }
                field(primaryContactNo; Rec."Primary Contact No.")
                {
                    Caption = 'Primary Contact No.';
                }

                field(priority; Rec.Priority)
                {
                    Caption = 'Priority';
                }
                field(priorityPicking; Rec."Priority Picking")
                {
                    Caption = 'Priority Picking';
                }

                field(refunds; Rec.Refunds)
                {
                    Caption = 'Refunds';
                }



                field(responsibilityCenter; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                }
                field(salesLCY; Rec."Sales (LCY)")
                {
                    Caption = 'Sales (LCY)';
                }
                field(salesArea; Rec."Sales Area")
                {
                    Caption = 'Sales Area';
                }



                field(shipToCode; Rec."Ship-to Code")
                {
                    Caption = 'Ship-to Code';
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code';
                }
                field(shipmentMethodId; Rec."Shipment Method Id")
                {
                    Caption = 'Shipment Method Id';
                }
                field(shippedNotInvoiced; Rec."Shipped Not Invoiced")
                {
                    Caption = 'Shipped Not Invoiced';
                }
                field(shippedNotInvoicedLCY; Rec."Shipped Not Invoiced (LCY)")
                {
                    Caption = 'Shipped Not Invoiced (LCY)';
                }
                field(shippingAdvice; Rec."Shipping Advice")
                {
                    Caption = 'Shipping Advice';
                }


                field(shortcutDim3Code; Rec.ShortcutDim3Code)
                {
                    Caption = 'Shortcut Dimension 3 Code';
                }

                field(shortcutDim5Code; Rec.ShortcutDim5Code)
                {
                    Caption = 'Shortcut Dimension 5 Code';
                }
                field(shortcutDim6Code; Rec.ShortcutDim6Code)
                {
                    Caption = 'Shortcut Dimension 6 Code';
                }

                field(singlePO; Rec."Single PO")
                {
                    Caption = 'Single PO';
                }

                field(statusDate; Rec."Status Date")
                {
                    Caption = 'Status Date';
                }
                field(statusRemarks; Rec."Status Remarks")
                {
                    Caption = 'Status Remarks';
                }
                field(storeInformation; Rec."Store Information")
                {
                    Caption = 'Store Information';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }


                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                }

                field(wsMembership; Rec."WS Membership")
                {
                    Caption = 'WS Membership';
                }
                field(webUserEmail; Rec."Web User Email")
                {
                    Caption = 'Web User Email';
                }
                field(webUserID; Rec."Web User ID")
                {
                    Caption = 'Web User ID';
                }
                field(webUserName; Rec."Web User Name")
                {
                    Caption = 'Web User Name';
                }
                field(wellawayCustomer; Rec."Wellaway Customer")
                {
                    Caption = 'Wellaway Customer';
                }
                field(wellawayWebUserEmail; Rec."Wellaway Web User Email")
                {
                    Caption = 'Wellaway Web User Email';
                }
                field(wellawayWebUserID; Rec."Wellaway Web User ID")
                {
                    Caption = 'Wellaway Web User ID';
                }
                field(wellawayWebUserName; Rec."Wellaway Web User Name")
                {
                    Caption = 'Wellaway Web User Name';
                }
                field(workingHours; Rec."Working Hours")
                {
                    Caption = 'Working Hours';
                }
            }
        }
    }
}
