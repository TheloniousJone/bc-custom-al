table 52100 "DKSH Staging Purch. Order Hdr."
{
    Caption = 'DKSH Staging Outgoing PO Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(20; "documentStatus"; Text[10])
        {
            Caption = 'Document Status';
        }
        field(30; "creationDateOriginal"; Date)
        {
            Caption = 'PO Date Original';
        }
        field(40; "creationDate"; Text[19])
        {
            Caption = 'PO Date';
        }
        field(50; "TypeOfOrder"; Text[20])
        {
            Caption = 'Type Of Order';
        }
        field(60; "version"; Text[5])
        {
            Caption = 'Specification Identifier of PO Xml Doc';
        }
        field(70; "voidDateOriginal"; Date)
        {
            Caption = 'PO Expiry Date Original';
        }
        field(80; "voidDate"; Text[10])
        {
            Caption = 'PO Expiry Date';
        }
        field(90; "movementDateOriginal"; Date)
        {
            Caption = 'Delivery Date From Original';
        }
        field(100; "movementDate"; Text[19])
        {
            Caption = 'Delivery Date From';
        }
        field(110; "movementDateType"; Text[20])
        {
            Caption = 'Type of Movement Date';
        }
        field(120; "entityType"; Text[5])
        {
            Caption = 'Type of Entity Identification';
        }
        field(130; "uniqueCreatorIdentification"; Text[30])
        {
            Caption = 'PO Number';
        }
        field(140; "owner_gln"; Text[20])
        {
            Caption = 'PO Owner VAT Identifier';
        }
        field(150; "buyer_gln"; Text[20])
        {
            Caption = 'Buyer VAT Identifier';
        }

        field(154; "buyer_alternatePartyId"; Text[20])
        {
            Caption = 'Code of Buyer';
        }
        field(157; "buyer_alternatePartyId_type"; Text[35])
        {
            Caption = 'Type Attritute of the Buyer Identifier';
        }

        field(160; "buyer_partyRole"; Text[5])
        {
            Caption = 'Role of Buyer';
        }
        field(170; "buyer_city"; Text[35])
        {
            Caption = 'Buyer City';
        }
        field(180; "buyer_countryISOCode"; Text[3])
        {
            Caption = 'Buyer Country Code';
        }

        field(190; "buyer_languageOfTheParty"; Text[2])
        {
            Caption = 'Buyer Country Language Code';
        }
        field(200; "buyer_name"; Text[100])
        {
            Caption = 'Buyer Name';
        }
        field(210; "buyer_postalCode"; Text[15])
        {
            Caption = 'Buyer Postal Code';
        }
        field(220; "buyer_state"; Text[80])
        {
            Caption = 'Buyer State';
        }
        field(230; "buyer_streetAddressOne"; Text[100])
        {
            Caption = 'Buyer Address Line 1';
        }
        field(240; "buyer_streetAddressTwo"; Text[100])
        {
            Caption = 'Buyer Address Line 2';
        }
        field(250; "buyer_streetAddressThree"; Text[100])
        {
            Caption = 'Buyer Address Line 3';
        }
        field(260; "buyer_streetAddressFour"; Text[100])
        {
            Caption = 'Buyer Address Line 4';
        }
        field(270; "seller_alternatePartyId"; Text[20])
        {
            Caption = 'Code of Seller Given By Buyer';
        }
        field(280; "seller_alternatePartyId_type"; Text[35])
        {
            Caption = 'Type Attritute of the Seller Identifier';
        }
        field(290; "seller_partyRole"; Text[8])
        {
            Caption = 'Role of Seller';
        }
        field(300; "seller_commChannelCode"; Text[10])
        {
            Caption = 'Seller Contact Communication Channel Code';
        }
        field(310; "seller_commNumber"; Text[50])
        {
            Caption = 'Seller Contact Communication Channel Number';
        }
        field(320; "seller_lanuage"; Text[2])
        {
            Caption = 'Seller Contact Country Language Code';
        }
        field(330; "seller_text"; Text[50])
        {
            Caption = 'Seller Contact (Department) Name';
        }
        field(340; "seller_city"; Text[35])
        {
            Caption = 'Seller City';
        }
        field(350; "seller_countryISOCode"; Text[3])
        {
            Caption = 'Seller Country Code';
        }
        field(360; "seller_languageOfTheParty"; Text[2])
        {
            Caption = 'Seller Country Language Code ';
        }
        field(370; "seller_name"; Text[100])
        {
            Caption = 'Seller Name';
        }
        field(380; "seller_postalCode"; Text[15])
        {
            Caption = 'Seller Postal Code';
        }
        field(390; "seller_state"; Text[80])
        {
            Caption = 'Seller State';
        }
        field(400; "seller_streetAddressOne"; Text[100])
        {
            Caption = 'Seller Address Line 1';
        }
        field(410; "seller_streetAddressTwo"; Text[100])
        {
            Caption = 'Seller Address Line 2';
        }
        field(420; "seller_streetAddressThree"; Text[100])
        {
            Caption = 'Seller Address Line 3';
        }
        field(430; "seller_streetAddressFour"; Text[100])
        {
            Caption = 'Seller Address Line 4';
        }
        field(440; "ship_identificationType"; Text[7])
        {
            Caption = 'Delivery Party Identification Type';
        }
        field(450; "ship_alternatePartyId"; Text[20])
        {
            Caption = 'Deliver to Location Identifier';
        }
        field(460; "ship_alternatePartyId_type"; Text[35])
        {
            Caption = 'Type Attribute of the Location Identifier';
        }
        field(470; "ship_partyRole"; Text[20])
        {
            Caption = 'Role of Delivery';
        }
        field(480; "ship_city"; Text[35])
        {
            Caption = 'Delivery City';
        }
        field(490; "ship_countryISOCode"; Text[3])
        {
            Caption = 'Delivery Location Country Code';
        }
        field(500; "ship_languageOfTheParty"; Text[2])
        {
            Caption = 'Delivery Location Country Language Code';
        }
        field(510; "ship_name"; Text[100])
        {
            Caption = 'Delivery Location Name';
        }
        field(520; "ship_postalCode"; Text[15])
        {
            Caption = 'Delivery Location Postal Code';
        }
        field(530; "ship_state"; Text[80])
        {
            Caption = 'Delivery State';
        }
        field(540; "ship_streetAddressOne"; Text[100])
        {
            Caption = 'Delivery Location Address Line 1';
        }
        field(550; "ship_streetAddressTwo"; Text[100])
        {
            Caption = 'Delivery Location Address Line 2';
        }
        field(560; "ship_streetAddressThree"; Text[100])
        {
            Caption = 'Delivery Location Address Line 3';
        }
        field(570; "ship_streetAddressFour"; Text[100])
        {
            Caption = 'Delivery Location Address Line 4';
        }

        field(580; "Date Created"; DateTime)
        {
            Caption = 'Date Created';
        }

        field(590; "Date Modified"; DateTime)
        {
            Caption = 'Date Modified';
        }

        field(600; "Is Rejected"; Boolean)
        {
            Caption = 'Is Rejected';
        }

        field(610; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
        }

        field(620; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }

        field(630; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
        }

        field(640; "Source PO No."; Code[20])
        {
            Caption = 'Source PO No.';
        }

        field(650; "Total Line Item Count"; Integer)
        {
            Caption = 'Count of PO Lines';
        }

        field(660; "Remarks"; Text[500])
        {
            Caption = 'Remarks';
        }

        // YF 17 Nov 2022
        field(670; "PO Emailed"; Boolean)
        {
            Caption = 'PO Emailed';
        }
        // YF 17 Nov 2022
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        /*
        key(UniqueKey; "Source PO No.")
        {
            Unique = true;
        }
        */
    }
}
