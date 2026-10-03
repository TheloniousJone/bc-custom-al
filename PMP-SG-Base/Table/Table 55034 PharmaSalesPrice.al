table 55034 "Pharma Sales Price"
{
    Caption = 'Pharma Sales Price';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Item No." <> xRec."Item No." then begin
                    Item.Get("Item No.");
                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                    "Variant Code" := '';
                end;

                /*
                IF "Sales Type" = "Sales Type"::"Customer Price Group" THEN
                    IF CustPriceGr.GET("Sales Code") AND
                        (CustPriceGr."Allow Invoice Disc." = "Allow Invoice Disc.")
                    THEN
                        EXIT;
                */

                UpdateValuesFromItem;
            end;
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group" ELSE
            IF ("Sales Type" = CONST(Customer)) Customer ELSE
            IF ("Sales Type" = CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                IF "Sales Code" <> '' THEN
                    CASE "Sales Type" OF
                        "Sales Type"::"All Customers":
                            ERROR(Text001, FIELDCAPTION("Sales Code"));
                        "Sales Type"::"Customer Price Group":
                            BEGIN
                                CustPriceGr.GET("Sales Code");
                                "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                            END;
                        "Sales Type"::Customer:
                            BEGIN
                                Cust.GET("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                                "Allow Line Disc." := Cust."Allow Line Disc.";
                            END;
                        "Sales Type"::Campaign:
                            BEGIN
                                Campaign.GET("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            END;
                    END;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                    ERROR(Text000, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));

                IF CurrFieldNo = 0 THEN
                    EXIT;

                IF "Starting Date" <> 0D THEN
                    IF "Sales Type" = "Sales Type"::Campaign THEN
                        ERROR(Text002, "Sales Type");
            end;
        }
        field(5; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(6; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
            DataClassification = ToBeClassified;
        }
        field(7; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc';
            DataClassification = ToBeClassified;
        }
        field(8; "Line Discount %"; Integer)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
        }
        field(9; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionMembers = "Customer","Customer Price Group","All Customers","Campaign";
            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN BEGIN
                    VALIDATE("Sales Code", '');
                    UpdateValuesFromItem;
                END;
            end;
        }
        field(10; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DataClassification = ToBeClassified;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF CurrFieldNo = 0 THEN
                    EXIT;

                VALIDATE("Starting Date");

                IF "Ending Date" <> 0D THEN
                    IF "Sales Type" = "Sales Type"::Campaign THEN
                        ERROR(Text002, "Sales Type");

            end;
        }

        field(12; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(13; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            DataClassification = ToBeClassified;
        }
        field(14; "Allow Line Disc."; Boolean)
        {
            DataClassification = ToBeClassified;
            // InitValue = true;
        }
        field(15; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(16; "FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'FOC Qty';
        }
        field(17; Status; Enum "Price Status")
        {
            DataClassification = ToBeClassified;
        }
        field(55001; "RecRefID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(18; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        // YF 18 Mar 2022
        field(60; "TA Type"; Option)
        {
            Caption = 'TA Type';
            OptionMembers = "All","Wellaway","POM";
            InitValue = "All";
        }

        field(70; "Find Next"; Boolean)
        {
            Caption = 'Find Next';
            InitValue = true;
        }
        // YF 18 Mar 2022

    }
    keys
    {
        key(PK; "Item No.", "Sales Type", "Sales Code", "Currency Code", "Starting Date", "Minimum Quantity", "Unit Of Measure Code")
        {
            Clustered = true;
        }
        //DX    08 Jun 2023
        key(key2; "Sales Type", "Sales Code")
        {

        }
        //DX    08 Jun 2023
    }

    local procedure UpdateValuesFromItem()
    begin
        IF Item.GET("Item No.") THEN BEGIN
            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
            IF "Sales Type" = "Sales Type"::"All Customers" THEN BEGIN
                "Price Includes VAT" := Item."Price Includes VAT";
                "VAT Bus. Posting Gr. (Price)" := Item."VAT Bus. Posting Gr. (Price)";
            END;
        END;
    end;

    trigger OnInsert()
    begin
        IF "Sales Type" = "Sales Type"::"All Customers" THEN
            "Sales Code" := ''
        ELSE
            TESTFIELD("Sales Code");
        TESTFIELD("Item No.");
    end;

    trigger OnRename()
    begin
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
            TESTFIELD("Sales Code");
        TESTFIELD("Item No.");
    end;

    procedure CopySalesPriceToCustomersSalesPrice(var SalesPrice: Record "Pharma Sales Price"; CustNo: Code[20])
    var
        NewSalesPrice: Record "Pharma Sales Price";
    begin
        if SalesPrice.FindSet then
            repeat
                NewSalesPrice := SalesPrice;
                NewSalesPrice."Sales Type" := NewSalesPrice."Sales Type"::Customer;
                NewSalesPrice."Sales Code" := CustNo;
                if NewSalesPrice.Insert() then;
            until SalesPrice.Next() = 0;
    end;

    var
        Item: Record item;
        Campaign: Record Campaign;
        CustPriceGr: Record "Customer Price Group";
        Cust: record Customer;

        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        Text002: Label 'If Sales Type = %1, then you can only change Starting Date and Ending Date from the Campaign Card.';

}
