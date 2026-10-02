page 52101 "DKSH Staging Outgoing PO Card"
{
    Caption = 'DKSH Staging Outgoing PO Card';
    PageType = Document;
    SourceTable = "DKSH Staging Purch. Order Hdr.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Source PO No."; Rec."Source PO No.")
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

                field(TypeOfOrder; Rec.TypeOfOrder)
                {
                    ApplicationArea = All;
                }

                field("version"; Rec."version")
                {
                    ApplicationArea = All;
                }

                field(voidDateOriginal; Rec.voidDateOriginal)
                {
                    ApplicationArea = All;
                }

                field(voidDate; Rec.voidDate)
                {
                    ApplicationArea = All;
                }

                field(movementDateOriginal; Rec.movementDateOriginal)
                {
                    ApplicationArea = All;
                }

                field(movementDate; Rec.movementDate)
                {
                    ApplicationArea = All;
                }

                field(movementDateType; Rec.movementDateType)
                {
                    ApplicationArea = All;
                }

                field(entityType; Rec.entityType)
                {
                    ApplicationArea = All;
                }

                field(uniqueCreatorIdentification; Rec.uniqueCreatorIdentification)
                {
                    ApplicationArea = All;
                }

                field(owner_gln; Rec.owner_gln)
                {
                    ApplicationArea = All;
                }

                field(buyer_gln; Rec.buyer_gln)
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

                field(seller_partyRole; Rec.seller_partyRole)
                {
                    ApplicationArea = All;
                }

                field(seller_commChannelCode; Rec.seller_commChannelCode)
                {
                    ApplicationArea = All;
                }

                field(seller_commNumber; Rec.seller_commNumber)
                {
                    ApplicationArea = All;
                }

                field(seller_lanuage; Rec.seller_lanuage)
                {
                    ApplicationArea = All;
                }

                field(seller_text; Rec.seller_text)
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

                field(ship_identificationType; Rec.ship_identificationType)
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

                field("Total Line Item Count"; Rec."Total Line Item Count")
                {
                    ApplicationArea = All;
                }

                field(Remarks; Rec.Remarks)
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

                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                }

                // YF 17 Nov 2022
                field("PO Emailed"; Rec."PO Emailed")
                {
                    ApplicationArea = All;
                }
                // YF 17 Nov 2022
            }

            part(StagingLines; "DKSH Stag. Outgoing PO Subform")
            {
                ApplicationArea = All;
                Caption = 'Staging Lines';
                SubPageLink = "Parent Entry No." = FIELD("Entry No.");
                UpdatePropagation = Both;
            }
        }
    }

}
