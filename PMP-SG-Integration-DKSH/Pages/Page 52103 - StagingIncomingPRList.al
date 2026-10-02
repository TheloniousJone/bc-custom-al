page 52103 "DKSH Staging Incoming PR List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'DKSH Staging Incoming PR List';
    CardPageID = "DKSH Staging Incoming PR Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    SourceTable = "DKSH Staging Purch. Rcpt. Hdr.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field(documentStatus; Rec.documentStatus)
                {
                    ApplicationArea = All;
                }

                field(creationDateOriginal; Rec.creationDateOriginal)
                {
                    ApplicationArea = All;
                }

                field(creationDate; Rec.creationDate)
                {
                    ApplicationArea = All;
                }

                field("version"; Rec."version")
                {
                    ApplicationArea = All;
                }

                field(invoiceType; Rec.invoiceType)
                {
                    ApplicationArea = All;
                }

                field(uniqueCreatorIdentification; Rec.uniqueCreatorIdentification)
                {
                    ApplicationArea = All;
                }

                field(owner_alternatePartyId; Rec.owner_alternatePartyId)
                {
                    ApplicationArea = All;
                }

                field(owner_alternatePartyId_type; Rec.owner_alternatePartyId_type)
                {
                    ApplicationArea = All;
                }

                field(buyer_alternatePartyId; Rec.buyer_alternatePartyId)
                {
                    ApplicationArea = All;
                }

                field(buyer_alternatePartyId_type; Rec.buyer_alternatePartyId_type)
                {
                    ApplicationArea = All;
                }

                field(buyer_partyRole; Rec.buyer_partyRole)
                {
                    ApplicationArea = All;
                }

                field(buyer_city; Rec.buyer_city)
                {
                    ApplicationArea = All;
                }

                field(buyer_countryISOCode; Rec.buyer_countryISOCode)
                {
                    ApplicationArea = All;
                }

                field(buyer_languageOfTheParty; Rec.buyer_languageOfTheParty)
                {
                    ApplicationArea = All;
                }

                field(buyer_name; Rec.buyer_name)
                {
                    ApplicationArea = All;
                }

                field(buyer_postalCode; Rec.buyer_postalCode)
                {
                    ApplicationArea = All;
                }

                field(buyer_state; Rec.buyer_state)
                {
                    ApplicationArea = All;
                }

                field(buyer_streetAddressOne; Rec.buyer_streetAddressOne)
                {
                    ApplicationArea = All;
                }

                field(buyer_streetAddressTwo; Rec.buyer_streetAddressTwo)
                {
                    ApplicationArea = All;
                }

                field(buyer_streetAddressThree; Rec.buyer_streetAddressThree)
                {
                    ApplicationArea = All;
                }

                field(buyer_streetAddressFour; Rec.buyer_streetAddressFour)
                {
                    ApplicationArea = All;
                }

                field(seller_alternatePartyId; Rec.seller_alternatePartyId)
                {
                    ApplicationArea = All;
                }

                field(seller_alternatePartyId_type; Rec.seller_alternatePartyId_type)
                {
                    ApplicationArea = All;
                }

                field(seller_amount; Rec.seller_amount)
                {
                    ApplicationArea = All;
                }

                field(seller_currencyISOcode; Rec.seller_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(seller_taxPercent; Rec.seller_taxPercent)
                {
                    ApplicationArea = All;
                }

                field(seller_taxRegistrationNumber; Rec.seller_taxRegistrationNumber)
                {
                    ApplicationArea = All;
                }

                field(seller_typeOfTaxRegistration; Rec.seller_typeOfTaxRegistration)
                {
                    ApplicationArea = All;
                }

                field(seller_partyRole; Rec.seller_partyRole)
                {
                    ApplicationArea = All;
                }

                field(seller_city; Rec.seller_city)
                {
                    ApplicationArea = All;
                }

                field(seller_countryISOCode; Rec.seller_countryISOCode)
                {
                    ApplicationArea = All;
                }

                field(seller_languageOfTheParty; Rec.seller_languageOfTheParty)
                {
                    ApplicationArea = All;
                }

                field(seller_name; Rec.seller_name)
                {
                    ApplicationArea = All;
                }

                field(seller_postalCode; Rec.seller_postalCode)
                {
                    ApplicationArea = All;
                }

                field(seller_state; Rec.seller_state)
                {
                    ApplicationArea = All;
                }

                field(seller_streetAddressOne; Rec.seller_streetAddressOne)
                {
                    ApplicationArea = All;
                }

                field(seller_streetAddressTwo; Rec.seller_streetAddressTwo)
                {
                    ApplicationArea = All;
                }

                field(seller_streetAddressThree; Rec.seller_streetAddressThree)
                {
                    ApplicationArea = All;
                }

                field(seller_streetAddressFour; Rec.seller_streetAddressFour)
                {
                    ApplicationArea = All;
                }

                field(allowanceChargeType; Rec.allowanceChargeType)
                {
                    ApplicationArea = All;
                }

                field(allowanceOrChargeType; Rec.allowanceOrChargeType)
                {
                    ApplicationArea = All;
                }

                field(settlementType; Rec.settlementType)
                {
                    ApplicationArea = All;
                }

                field(monetary_amount; Rec.monetary_amount)
                {
                    ApplicationArea = All;
                }

                field(monetary_currencyISOcode; Rec.monetary_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(or_referenceDateOnlyOriginal; Rec.or_referenceDateOnlyOriginal)
                {
                    ApplicationArea = All;
                }

                field(or_referenceDateOnly; Rec.or_referenceDateOnly)
                {
                    ApplicationArea = All;
                }

                field(or_referenceIdentification; Rec.or_referenceIdentification)
                {
                    ApplicationArea = All;
                }

                field(dn_referenceDateOnlyOriginal; Rec.dn_referenceDateOnlyOriginal)
                {
                    ApplicationArea = All;
                }

                field(dn_referenceDateOnly; Rec.dn_referenceDateOnly)
                {
                    ApplicationArea = All;
                }

                field(dn_referenceIdentification; Rec.dn_referenceIdentification)
                {
                    ApplicationArea = All;
                }

                field(total_net_amount; Rec.total_net_amount)
                {
                    ApplicationArea = All;
                }

                field(total_net_currencyISOcode; Rec.total_net_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(total_ttl_amount; Rec.total_ttl_amount)
                {
                    ApplicationArea = All;
                }

                field(total_ttl_currencyISOcode; Rec.total_ttl_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(remarks; Rec.remarks)
                {
                    ApplicationArea = All;
                }

                field(ext_store; Rec.ext_store)
                {
                    ApplicationArea = All;
                }

                field(ext_store_code; Rec.ext_store_code)
                {
                    ApplicationArea = All;
                }

                field(ext_creditTerms; Rec.ext_creditTerms)
                {
                    ApplicationArea = All;
                }

                field(ext_creditTerms_code; Rec.ext_creditTerms_code)
                {
                    ApplicationArea = All;
                }

                field(ext_footer_line; Rec.ext_footer_line)
                {
                    ApplicationArea = All;
                }

                field(ext_footer_line_number; Rec.ext_footer_line_number)
                {
                    ApplicationArea = All;
                }

                field(ext_bizRegNo; Rec.ext_bizRegNo)
                {
                    ApplicationArea = All;
                }

                field(ext_discp_amount; Rec.ext_discp_amount)
                {
                    ApplicationArea = All;
                }

                field(ext_discp_currencyISOcode; Rec.ext_discp_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(store_address1; Rec.store_address1)
                {
                    ApplicationArea = All;
                }

                field(store_address2; Rec.store_address2)
                {
                    ApplicationArea = All;
                }

                field(store_address3; Rec.store_address3)
                {
                    ApplicationArea = All;
                }

                field(store_address4; Rec.store_address4)
                {
                    ApplicationArea = All;
                }

                field(store_city; Rec.store_city)
                {
                    ApplicationArea = All;
                }

                field(store_state; Rec.store_state)
                {
                    ApplicationArea = All;
                }

                field(store_ctryCode; Rec.store_ctryCode)
                {
                    ApplicationArea = All;
                }

                field(store_postalCode; Rec.store_postalCode)
                {
                    ApplicationArea = All;
                }

                field(cust_amount; Rec.cust_amount)
                {
                    ApplicationArea = All;
                }

                field(cust_currencyISOcode; Rec.cust_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                }

                field("Date Modified"; Rec."Date Modified")
                {
                    ApplicationArea = All;
                }

                field("Is Rejected"; Rec."Is Rejected")
                {
                    ApplicationArea = All;
                }

                field("Has Error"; Rec."Has Error")
                {
                    ApplicationArea = All;
                }

                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }

                field("PO No. Updated"; Rec."PO No. Updated")
                {
                    ApplicationArea = All;
                }

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // actions here
        area(Processing)
        {
            group(Process)
            {
                action("Update PO Lines from DKSH Invoices")
                {
                    ApplicationArea = all;
                    Caption = 'Update PO Lines from DKSH Invoices';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Delivery;
                    PromotedCategory = Process;
                    // RunObject = report 69000;

                    trigger OnAction()
                    var
                        StagingRec: Record "DKSH Staging Purch. Rcpt. Hdr.";
                        SyncReport: Report "Update DKSH PO Lines Job Queue";
                    begin
                        CurrPage.SetSelectionFilter(StagingRec);
                        SyncReport.SetTableView(StagingRec);
                        SyncReport.Run();
                        CurrPage.Update(false);
                        Message('Run completed');
                    end;
                }

            }

        }
    }

}
