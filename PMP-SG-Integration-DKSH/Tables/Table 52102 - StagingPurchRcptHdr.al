table 52102 "DKSH Staging Purch. Rcpt. Hdr."
{
    Caption = 'DKSH Staging Incoming Purch Rcpt Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(20; "documentStatus"; Text[4])
        {
            Caption = 'Document Status';
        }
        field(30; "creationDateOriginal"; Date)
        {
            Caption = 'Invoice Date Original';
        }
        field(40; "creationDate"; Text[19])
        {
            Caption = 'Invoice Date';
        }
        field(50; "version"; Text[5])
        {
            Caption = 'Specification Identifier of PO Xml Doc';
        }
        field(60; "invoiceType"; Text[3])
        {
            Caption = 'Invoice Type Code';
        }
        field(70; "uniqueCreatorIdentification"; Text[30])
        {
            Caption = 'Invoice Number';
        }
        field(80; "owner_alternatePartyId"; Text[20])
        {
            Caption = 'Code of Seller Defined By Seller';
        }
        field(90; "owner_alternatePartyId_type"; Text[38])
        {
            Caption = 'Type Attritute of the Seller Identifier';
        }
        field(100; "buyer_alternatePartyId"; Text[20])
        {
            Caption = 'Code of Buyer Given By Seller';
        }
        field(110; "buyer_alternatePartyId_type"; Text[38])
        {
            Caption = 'Type Attritute of the Seller Identifier';
        }
        field(120; "buyer_partyRole"; Text[5])
        {
            Caption = 'Role of Buyer';
        }
        field(130; "buyer_city"; Text[35])
        {
            Caption = 'Buyer City';
        }
        field(140; "buyer_countryISOCode"; Text[3])
        {
            Caption = 'Buyer Country Code';
        }
        field(150; "buyer_languageOfTheParty"; Text[2])
        {
            Caption = 'Buyer Country Language Code';
        }
        field(160; "buyer_name"; Text[100])
        {
            Caption = 'Buyer Name';
        }
        field(170; "buyer_postalCode"; Text[15])
        {
            Caption = 'Buyer Postal Code';
        }
        field(180; "buyer_state"; Text[50])
        {
            Caption = 'Buyer State';
        }
        field(190; "buyer_streetAddressOne"; Text[100])
        {
            Caption = 'Buyer Address Line 1';
        }
        field(200; "buyer_streetAddressTwo"; Text[100])
        {
            Caption = 'Buyer Address Line 2';
        }
        field(210; "buyer_streetAddressThree"; Text[100])
        {
            Caption = 'Buyer Address Line 3';
        }
        field(220; "buyer_streetAddressFour"; Text[100])
        {
            Caption = 'Buyer Address Line 4';
        }
        field(230; "seller_alternatePartyId"; Text[20])
        {
            Caption = 'Code of Seller Given By Buyer';
        }
        field(240; "seller_alternatePartyId_type"; Text[40])
        {
            Caption = 'Type Attritute of the Seller Identifier';
        }
        field(250; "seller_amount"; Decimal)
        {
            Caption = 'Invoice Total Vat Amount';
            DecimalPlaces = 0 : 2;
        }
        field(260; "seller_currencyISOcode"; Text[3])
        {
            Caption = 'Amount Currency Code';
        }
        field(270; "seller_taxPercent"; Decimal)
        {
            Caption = 'Tax Rate';
            DecimalPlaces = 0 : 2;
        }
        field(280; "seller_taxRegistrationNumber"; Text[20])
        {
            Caption = 'Seller Tax Registration identifier';
        }
        field(290; "seller_typeOfTaxRegistration"; Text[3])
        {
            Caption = 'Seller Tax Type';
        }
        field(300; "seller_partyRole"; Text[6])
        {
            Caption = 'Role of Seller';
        }
        field(310; "seller_city"; Text[50])
        {
            Caption = 'Seller City';
        }
        field(320; "seller_countryISOCode"; Text[3])
        {
            Caption = 'Seller Country Code';
        }
        field(330; "seller_languageOfTheParty"; Text[2])
        {
            Caption = 'Seller Country Language Code ';
        }
        field(340; "seller_name"; Text[100])
        {
            Caption = 'Seller Name';
        }
        field(350; "seller_postalCode"; Text[100])
        {
            Caption = 'Seller Postal Code';
        }
        field(360; "seller_state"; Text[50])
        {
            Caption = 'Seller State';
        }
        field(370; "seller_streetAddressOne"; Text[100])
        {
            Caption = 'Seller Address Line 1';
        }
        field(380; "seller_streetAddressTwo"; Text[100])
        {
            Caption = 'Seller Address Line 2';
        }
        field(390; "seller_streetAddressThree"; Text[100])
        {
            Caption = 'Seller Address Line 3';
        }
        field(400; "seller_streetAddressFour"; Text[100])
        {
            Caption = 'Seller Address Line 4';
        }

        field(440; "allowanceChargeType"; Text[16])
        {
            Caption = 'Type of Allowance Level';
        }
        field(450; "allowanceOrChargeType"; Text[9])
        {
            Caption = 'Allowance Or Charge?';
        }
        field(460; "settlementType"; Text[11])
        {
            Caption = 'Type of Allowance Settlement';
        }
        field(470; "monetary_amount"; Decimal)
        {
            Caption = 'Invoice Additional Discount Amount';
            DecimalPlaces = 0 : 2;
        }
        field(480; "monetary_currencyISOcode"; Text[3])
        {
            Caption = 'Invoice Additional Discount Amount Currency Code';
        }

        field(490; "or_referenceDateOnlyOriginal"; Date)
        {
            Caption = 'PO Date Original';
        }
        field(500; "or_referenceDateOnly"; Text[10])
        {
            Caption = 'PO Date';
        }
        field(510; "or_referenceIdentification"; Text[30])
        {
            Caption = 'PO Number';
        }
        field(520; "dn_referenceDateOnlyOriginal"; Date)
        {
            Caption = 'DO Date Original';
        }
        field(530; "dn_referenceDateOnly"; Text[10])
        {
            Caption = 'DO Date';
        }
        field(540; "dn_referenceIdentification"; Text[30])
        {
            Caption = 'DO Number';
        }
        field(550; "total_net_amount"; Decimal)
        {
            Caption = 'Invoice Total Amount Without Tax';
            DecimalPlaces = 0 : 2;
        }
        field(560; "total_net_currencyISOcode"; Text[3])
        {
            Caption = 'Invoice Total Amount Without Tax Currency Code';
        }
        field(570; "total_ttl_amount"; Decimal)
        {
            Caption = 'Invoice Total Amount With Tax';
            DecimalPlaces = 0 : 2;
        }
        field(580; "total_ttl_currencyISOcode"; Text[3])
        {
            Caption = 'Invoice Total Amount With Tax Currency Code';
        }
        field(590; "remarks"; Text[500])
        {
            Caption = 'Remarks';
        }
        field(600; "ext_store"; Text[100])
        {
            Caption = 'Invoice Delivery To Location Name';
        }
        field(610; "ext_store_code"; Text[20])
        {
            Caption = 'Invoice Delivery To Location Identifier';
        }
        field(620; "ext_creditTerms"; Text[100])
        {
            Caption = 'Payment Terms';
        }
        field(630; "ext_creditTerms_code"; Text[20])
        {
            Caption = 'Payment Terms Code';
        }
        field(640; "ext_footer_line"; Text[100])
        {
            Caption = 'Payment Terms Details Line';
        }
        field(650; "ext_footer_line_number"; Integer)
        {
            Caption = 'Payment Terms Details Line';
        }
        field(660; "ext_bizRegNo"; Text[100])
        {
            Caption = 'Seller Identifier';
        }
        field(670; "ext_discp_amount"; Decimal)
        {
            Caption = 'Invoiced Addtional Discount Percent';
            DecimalPlaces = 0 : 2;
        }
        field(680; "ext_discp_currencyISOcode"; Text[3])
        {
            Caption = 'Invoiced Addtional Discount Percent Amount Currency Code';
        }
        field(690; "store_address1"; Text[100])
        {
            Caption = 'Invoice Deliver to Location Address 1';
        }
        field(700; "store_address2"; Text[100])
        {
            Caption = 'Invoice Deliver to Location Address 2';
        }
        field(710; "store_address3"; Text[100])
        {
            Caption = 'Invoice Deliver to Location Address 3';
        }
        field(720; "store_address4"; Text[100])
        {
            Caption = 'Invoice Deliver to Location Address 4';
        }
        field(730; "store_city"; Text[50])
        {
            Caption = 'City of Invoice Deliver to Location';
        }
        field(740; "store_state"; Text[50])
        {
            Caption = 'State of Invoice Deliver to Location';
        }
        field(750; "store_ctryCode"; Text[3])
        {
            Caption = 'Deliver to Location Country Code';
        }
        field(760; "store_postalCode"; Text[15])
        {
            Caption = 'Deliver to Location Postal Code';
        }
        field(770; "cust_amount"; Decimal)
        {
            Caption = 'Customer Account to Tax';
            DecimalPlaces = 0 : 2;
        }
        field(780; "cust_currencyISOcode"; Text[3])
        {
            Caption = 'Customer Account to Tax Amount Currency Code';
        }

        field(800; "Date Created"; DateTime)
        {
            Caption = 'Date Created';
        }

        field(810; "Date Modified"; DateTime)
        {
            Caption = 'Date Modified';
        }

        field(820; "Is Rejected"; Boolean)
        {
            Caption = 'Is Rejected';
        }

        field(830; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
        }

        field(840; "Closed"; Boolean)
        {
            Caption = 'PO Updated';
        }

        field(850; "PO No. Updated"; Code[20])
        {
            Caption = 'PO No. Updated';
        }

        field(860; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

    }
}
