table 52103 "DKSH Staging Purch. Rcpt. Line"
{
    Caption = 'DKSH Staging Incoming Purch Rcpt Line';
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
        field(30; "buyer_alternateItemId_type"; Text[14])
        {
            Caption = 'Type Attritute of the Buyer Item Identifier';
        }
        field(40; "buyer_alternateItemId_value"; Text[50])
        {
            Caption = 'Item Standard Identifier From Buyer';
        }
        field(50; "buyer_additionalItemId_type"; Text[14])
        {
            Caption = 'Type Attritute of Item Barcode Identifier';
        }
        field(60; "buyer_additionalItemId_value"; Text[50])
        {
            Caption = 'Item Barcode Identifier From Buyer';
        }
        field(70; "seller_additionalItemId_type"; Text[17])
        {
            Caption = 'Type Attritute of Item Identifier From Seller';
        }
        field(80; "seller_additionalItemId_value"; Text[50])
        {
            Caption = 'Item Standard Identifier From Buyer';
        }
        field(90; "item_brandName"; Text[50])
        {
            Caption = 'Item Brand Name';
        }
        field(100; "item_modelNo"; Text[50])
        {
            Caption = 'Item Model Number';
        }
        field(110; "item_desc_language"; Text[2])
        {
            Caption = 'Description Text Language';
        }
        field(120; "item_desc_text"; Text[100])
        {
            Caption = 'Item Description Text';
        }
        field(130; "item_colorCodeListAgency"; Text[10])
        {
            Caption = 'Agency of Colour Code List';
        }
        field(140; "item_colorCodeValue"; Text[20])
        {
            Caption = 'Item Colour Code';
        }
        field(150; "color_desc_language"; Text[2])
        {
            Caption = 'Colour Description Text Language';
        }
        field(160; "color_desc_text"; Text[50])
        {
            Caption = 'Item Colour Description';
        }
        field(170; "item_quantityOfNextLevel"; Decimal)
        {
            Caption = 'Packsize of Item Packaging';
        }
        field(180; "item_sizeCodeListAgency"; Text[10])
        {
            Caption = 'Agency of Size Code List';
        }
        field(190; "item_sizeCodeValue"; Text[20])
        {
            Caption = 'Item Size Code';
        }
        field(200; "size_desc_language"; Text[2])
        {
            Caption = 'Size Description Text Language';
        }
        field(210; "size_desc_text"; Text[50])
        {
            Caption = 'Item Size Description';
        }
        field(220; "item_invoicedQuantity"; Decimal)
        {
            Caption = 'Item Invoiced Quantity';
            DecimalPlaces = 0 : 4;
        }
        field(230; "item_unitp_amount"; Decimal)
        {
            Caption = 'Item Gross Price';
            DecimalPlaces = 0 : 2;
        }
        field(240; "item_unitp_currencyISOcode"; Text[3])
        {
            Caption = 'Item Gross Price Amount Currency Code';
        }
        field(250; "item_netp_amount"; Decimal)
        {
            Caption = 'Item Net Price';
            DecimalPlaces = 0 : 2;
        }
        field(260; "item_netp_currencyISOcode"; Text[3])
        {
            Caption = 'Item Net Price Amount Currency Code';
        }
        field(270; "item_ttl_amount"; Decimal)
        {
            Caption = 'Invoice line Gross Amount';
            DecimalPlaces = 0 : 2;
        }
        field(280; "item_ttl_currencyISOcode"; Text[3])
        {
            Caption = 'Invoice line Gross Amount Currency Code';
        }
        field(290; "item_uom"; Text[20])
        {
            Caption = 'Invoiced Item Quantity Unit of Measure';
        }
        field(300; "item_baseUnit"; Text[1])
        {
            Caption = 'Invoiced Item Packaging Type';
        }
        field(310; "item_focQuantity"; Decimal)
        {
            Caption = 'Item Free Quantity';
            DecimalPlaces = 0 : 4;
        }
        field(320; "item_focbaseUnit"; Text[1])
        {
            Caption = 'Invoiced Free Item Packaging Type';
        }
        field(330; "item_focUom"; Text[20])
        {
            Caption = 'Invoiced Free Item Quantity Unit of Measure';
        }
        field(340; "item_disca_amount"; Decimal)
        {
            Caption = 'Invoiced Item Discount Amount';
            DecimalPlaces = 0 : 2;
        }
        field(350; "item_disca_currencyISOcode"; Text[3])
        {
            Caption = 'Invoiced Item Discount Amount Currency Code';
        }
        field(360; "item_discp_amount"; Decimal)
        {
            Caption = 'Invoiced Item Discount Percent';
        }
        field(370; "item_discp_currencyISOcode"; Text[3])
        {
            Caption = 'Invoiced Item Discount Percent Amount Currency Code';
        }
        field(380; "item_neta_amount"; Decimal)
        {
            Caption = 'Invoice Line Net Amount';
            DecimalPlaces = 0 : 2;
        }
        field(390; "item_neta_currencyISOcode"; Text[3])
        {
            Caption = 'Invoice Line Net Amount Currency Code';
        }
        field(400; "item_itemRemarks"; Text[31])
        {
            Caption = 'Item Remarks';
        }
        field(410; "item_batchNumber"; Text[12])
        {
            Caption = 'Item Batch Number';
        }
        field(420; "item_expiry_referenceDateOnly"; Text[10])
        {
            Caption = 'Item Expiry Date';
        }
        field(430; "item_manu_referenceDateOnly"; Text[10])
        {
            Caption = 'Item Manufacturing Date';
        }

        field(790; "Date Created"; DateTime)
        {
            Caption = 'Date Created';
        }

        field(800; "Date Modified"; DateTime)
        {
            Caption = 'Date Modified';
        }

        field(810; "Is Rejected"; Boolean)
        {
            Caption = 'Is Rejected';
        }

        field(820; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
        }

        field(830; "Closed"; Boolean)
        {
            Caption = 'PO Updated';
        }

        field(840; "PO No. Updated"; Code[20])
        {
            Caption = 'PO No. Updated';
        }

        field(850; "PO Line No. Updated"; Integer)
        {
            Caption = 'PO Line No. Updated';
        }

        field(860; "Process Remarks"; Text[250])
        {
            Caption = 'Process Remarks';
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
