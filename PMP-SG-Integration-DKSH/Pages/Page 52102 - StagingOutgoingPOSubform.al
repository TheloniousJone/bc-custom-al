page 52102 "DKSH Stag. Outgoing PO Subform"
{
    AutoSplitKey = true;
    Caption = 'DKSH Staging Outgoing PO Details';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "DKSH Staging Purch. Order Line";

    layout
    {
        area(content)
        {
            repeater(Details)
            {
                field("Parent Entry No."; Rec."Parent Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }

                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }

                field(lineItem_number; Rec.lineItem_number)
                {
                    ApplicationArea = All;
                }

                field(price_amount; Rec.price_amount)
                {
                    ApplicationArea = All;
                }

                field(price_currencyISOcode; Rec.price_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(netPrice_amount; Rec.netPrice_amount)
                {
                    ApplicationArea = All;
                }

                field(netPrice_currencyISOcode; Rec.netPrice_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(requestedQuantity; Rec.requestedQuantity)
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

                field(monetary_percentage; Rec.monetary_percentage)
                {
                    ApplicationArea = All;
                }

                field(buyer_alternateItemId; Rec.buyer_alternateItemId)
                {
                    ApplicationArea = All;
                }

                field(buyer_additionalItemId; Rec.buyer_additionalItemId)
                {
                    ApplicationArea = All;
                }

                field(buyer_additionalItemId_type; Rec.buyer_additionalItemId_type)
                {
                    ApplicationArea = All;
                }

                field(supplier_additionalItemId; Rec.supplier_additionalItemId)
                {
                    ApplicationArea = All;
                }

                field(supplier_additionalItemId_type; Rec.supplier_additionalItemId_type)
                {
                    ApplicationArea = All;
                }

                field(item_brandName; Rec.item_brandName)
                {
                    ApplicationArea = All;
                }

                field(item_desc_language; Rec.item_desc_language)
                {
                    ApplicationArea = All;
                }

                field(item_desc_text; Rec.item_desc_text)
                {
                    ApplicationArea = All;
                }

                field(item_packagingTypeCode; Rec.item_packagingTypeCode)
                {
                    ApplicationArea = All;
                }

                field(item_quantityOfNextLevel; Rec.item_quantityOfNextLevel)
                {
                    ApplicationArea = All;
                }

                field(item_amount; Rec.item_amount)
                {
                    ApplicationArea = All;
                }

                field(item_currencyISOcode; Rec.item_currencyISOcode)
                {
                    ApplicationArea = All;
                }

                field(item_freeQuantity; Rec.item_freeQuantity)
                {
                    ApplicationArea = All;
                }

                field(ship_alternatePartyId; Rec.ship_alternatePartyId)
                {
                    ApplicationArea = All;
                }

                field(ship_alternatePartyId_type; Rec.ship_alternatePartyId_type)
                {
                    ApplicationArea = All;
                }

                field(ship_additionalPartyId; Rec.ship_additionalPartyId)
                {
                    ApplicationArea = All;
                }

                field(ship_additionalPartyId_type; Rec.ship_additionalPartyId_type)
                {
                    ApplicationArea = All;
                }

                field(ship_partyStartDateOriginal; Rec.ship_partyStartDateOriginal)
                {
                    ApplicationArea = All;
                }

                field(ship_partyStartDate; Rec.ship_partyStartDate)
                {
                    ApplicationArea = All;
                }

                field(ship_partyEndDateOriginal; Rec.ship_partyEndDateOriginal)
                {
                    ApplicationArea = All;
                }

                field(ship_partyEndDate; Rec.ship_partyEndDate)
                {
                    ApplicationArea = All;
                }

                field(ship_partyRole; Rec.ship_partyRole)
                {
                    ApplicationArea = All;
                }

                field(ship_city; Rec.ship_city)
                {
                    ApplicationArea = All;
                }

                field(ship_countryISOCode; Rec.ship_countryISOCode)
                {
                    ApplicationArea = All;
                }

                field(ship_languageOfTheParty; Rec.ship_languageOfTheParty)
                {
                    ApplicationArea = All;
                }

                field(ship_name; Rec.ship_name)
                {
                    ApplicationArea = All;
                }

                field(ship_postalCode; Rec.ship_postalCode)
                {
                    ApplicationArea = All;
                }

                field(ship_state; Rec.ship_state)
                {
                    ApplicationArea = All;
                }

                field(ship_streetAddressOne; Rec.ship_streetAddressOne)
                {
                    ApplicationArea = All;
                }

                field(ship_streetAddressTwo; Rec.ship_streetAddressTwo)
                {
                    ApplicationArea = All;
                }

                field(ship_streetAddressThree; Rec.ship_streetAddressThree)
                {
                    ApplicationArea = All;
                }

                field(ship_streetAddressFour; Rec.ship_streetAddressFour)
                {
                    ApplicationArea = All;
                }

                field(ship_deliveryQuantity; Rec.ship_deliveryQuantity)
                {
                    ApplicationArea = All;
                }

                field(ship_freeQuantity; Rec.ship_freeQuantity)
                {
                    ApplicationArea = All;
                }

                /*
                field(totalLineItem; Rec.totalLineItem)
                {
                    ApplicationArea = All;
                }

                field(remarks; Rec.remarks)
                {
                    ApplicationArea = All;
                }
                */

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

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }

                field("Source PO No."; Rec."Source PO No.")
                {
                    ApplicationArea = All;
                }

                field("Source PO Line No."; Rec."Source PO Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
