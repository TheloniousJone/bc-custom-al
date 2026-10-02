table 52101 "DKSH Staging Purch. Order Line"
{
    Caption = 'DKSH Staging Outgoing PO Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
            DataClassification = ToBeClassified;
        }

        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(20; "Sequence No."; Text[11])
        {
            Caption = 'Sequence No.';
        }

        field(25; "lineItem_number"; Integer)
        {
            Caption = 'Item Line Sequence Number';
        }
        field(30; "price_amount"; Decimal)
        {
            Caption = 'Item Price';
            DecimalPlaces = 0 : 2;
        }
        field(40; "price_currencyISOcode"; Text[3])
        {
            Caption = 'Currency Code for Item Price';
        }
        field(50; "netPrice_amount"; Decimal)
        {
            Caption = 'Item Net Price';
            DecimalPlaces = 0 : 2;
        }
        field(60; "netPrice_currencyISOcode"; Text[3])
        {
            Caption = 'NetPrice Currency ISO code';
        }
        field(70; "requestedQuantity"; Decimal)
        {
            Caption = 'Item Price Base Quantity';
            DecimalPlaces = 0 : 4;
        }
        field(80; "allowanceChargeType"; Text[16])
        {
            Caption = 'Type of Allowance Level';
        }
        field(90; "allowanceOrChargeType"; Text[9])
        {
            Caption = 'Allowance Or Charge?';
        }
        field(100; "settlementType"; Text[11])
        {
            Caption = 'Type of Allowance Settlement';
        }
        field(110; "monetary_amount"; Decimal)
        {
            Caption = 'Item Line Discount Amount';
            DecimalPlaces = 0 : 2;
        }
        field(120; "monetary_currencyISOcode"; Text[3])
        {
            Caption = 'Item Line Discount Amount Currency Code';
        }
        field(130; "monetary_percentage"; Decimal)
        {
            Caption = 'Item Line Discount Percentage';
            DecimalPlaces = 0 : 2;
        }
        field(140; "buyer_alternateItemId"; Text[50])
        {
            Caption = 'Item Barcode Identifier From Buyer';
        }
        field(150; "buyer_additionalItemId"; Text[50])
        {
            Caption = 'Item Standard Identifier From Buyer';
        }
        field(160; "buyer_additionalItemId_type"; Text[15])
        {
            Caption = 'Type Attribute of the Buyer Item Identifier';
        }
        field(170; "supplier_additionalItemId"; Text[50])
        {
            Caption = 'Item Standard Identifier From Seller';
        }
        field(180; "supplier_additionalItemId_type"; Text[18])
        {
            Caption = 'Type Attribute of the Seller Item Identifier';
        }
        field(190; "item_brandName"; Text[50])
        {
            Caption = 'Item Brand Name';
        }
        field(200; "item_desc_language"; Text[2])
        {
            Caption = 'Description Text Language';
        }
        field(210; "item_desc_text"; Text[150])
        {
            Caption = 'Item Description Text';
        }
        field(220; "item_packagingTypeCode"; Text[20])
        {
            Caption = 'Item Purchased Quantity Unit of Measure';
        }
        field(230; "item_quantityOfNextLevel"; Integer)
        {
            Caption = 'Packsize of Item Packaging';
        }
        field(240; "item_amount"; Decimal)
        {
            Caption = 'Item Net Amount';
            DecimalPlaces = 0 : 2;
        }
        field(250; "item_currencyISOcode"; Text[3])
        {
            Caption = 'Item Net Amount Currency Code';
        }
        field(260; "item_freeQuantity"; Decimal)
        {
            Caption = 'Free Quantity Purchased';
            DecimalPlaces = 0 : 4;
        }
        field(270; "ship_alternatePartyId"; Text[2])
        {
            Caption = 'ShiptoParty Alternate PartyID';
        }
        field(280; "ship_alternatePartyId_type"; Text[35])
        {
            Caption = 'Type Attritute of the Location Type';
        }
        field(290; "ship_additionalPartyId"; Text[30])
        {
            Caption = 'Deliver to Location Identifier';
        }
        field(300; "ship_additionalPartyId_type"; Text[35])
        {
            Caption = 'Type Attritute of the Location Identifier';
        }
        field(310; "ship_partyEndDateOriginal"; Date)
        {
            Caption = 'PO Line Delivery Period End Date Original';
        }
        field(320; "ship_partyEndDate"; Text[19])
        {
            Caption = 'PO Line Delivery Period End Date';
        }
        field(330; "ship_partyStartDateOriginal"; Date)
        {
            Caption = 'PO Line Delivery Period Start Date Original';
        }
        field(340; "ship_partyStartDate"; Text[19])
        {
            Caption = 'PO Line Delivery Period Start Date';
        }
        field(350; "ship_partyRole"; Text[7])
        {
            Caption = 'Role of PO Line Delivery';
        }
        field(360; "ship_city"; Text[35])
        {
            Caption = 'Delivery City';
        }
        field(370; "ship_countryISOCode"; Text[3])
        {
            Caption = 'Delivery Location Country Code';
        }
        field(380; "ship_languageOfTheParty"; Text[2])
        {
            Caption = 'Delivery Location Country Language Code';
        }
        field(390; "ship_name"; Text[100])
        {
            Caption = 'Delivery Location Name';
        }
        field(400; "ship_postalCode"; Text[15])
        {
            Caption = 'Delivery Location Postal Code';
        }
        field(410; "ship_state"; Text[80])
        {
            Caption = 'Delivery State';
        }
        field(420; "ship_streetAddressOne"; Text[100])
        {
            Caption = 'Delivery Location Address Line 1';
        }
        field(430; "ship_streetAddressTwo"; Text[100])
        {
            Caption = 'Delivery Location Address Line 2';
        }
        field(440; "ship_streetAddressThree"; Text[100])
        {
            Caption = 'Delivery Location Address Line 3';
        }
        field(450; "ship_streetAddressFour"; Text[100])
        {
            Caption = 'Delivery Location Address Line 4';
        }
        field(460; "ship_deliveryQuantity"; Decimal)
        {
            Caption = 'PO Line Deliver to Location Quantity Based On Item Price';
            DecimalPlaces = 0 : 4;
        }
        field(470; "ship_freeQuantity"; Decimal)
        {
            Caption = 'PO Line Deliver to Location Free Quantity';
            DecimalPlaces = 0 : 4;
        }

        /*
        field(480; "totalLineItem"; Integer)
        {
            Caption = 'Count of PO Lines';
        }
        field(490; "remarks"; Text[500])
        {
            Caption = 'Order Remarks';
        }
        */

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

        field(650; "Source PO Line No."; Integer)
        {
            Caption = 'Source PO Line No.';
        }

    }

    keys
    {
        key(PK; "Parent Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
