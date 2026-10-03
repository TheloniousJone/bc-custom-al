table 55036 "Pharma Purchase Price"
{
    Caption = 'Pharma Purchase Price';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Item No." <> xRec."Item No." then begin
                    "Unit of Measure Code" := '';
                    "Variant Code" := '';
                end;
            end;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get("Vendor No.") then
                    "Currency Code" := Vend."Currency Code";
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
        }

        field(6; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(7; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(8; "Line Discount %"; Integer)
        {
            Caption = 'Line Discount %';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
            MinValue = 0;
            MaxValue = 100;
        }

        field(9; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc';
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if "Ending Date" = 0D then
                    "Ending Date" := DMY2Date(31, 12, 2100);
                Validate("Starting Date");
            end;
        }

        field(30; Status; Enum "Price Status")
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }

        field(55000; "FOC Qty"; Decimal)
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
            Caption = 'FOC Qty';
        }
        field(55001; "RecRefID"; Code[50])
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(31; "New Cost Price"; Decimal)
        {
            // temp for page dialog
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(32; Remarks; Text[100])
        {
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        field(33; "Margin Percent"; Decimal)
        {
            // temp for page dialog
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }
        field(34; "New FOC Qty"; Decimal)
        {
            // temp for page dialog
            // DataClassification = ToBeClassified; // YF 23 Dec 2021
        }

        // YF 23 Dec 2021 // Fields for Reflect Price Changes
        field(35; "New Min Order Qty"; Decimal)
        {
            Caption = 'New Minimum Order Quantity';
        }

        field(36; "Average Cost"; Decimal)
        {
            Caption = 'Average Cost';
        }

        field(37; "New Average Cost"; Decimal)
        {
            Caption = 'New Average Cost';
        }

        field(38; "Margin Increase"; Decimal)
        {
            Caption = 'Margin Increase';
        }
        // YF 23 Dec 2021 // Fields for Reflect Price Changes

        // YF 02 Mar 2022
        field(39; "Country of Purchase Code"; Code[10])
        {
            Caption = 'Country of Purchase Code';
            TableRelation = "Country/Region".Code;
        }
        // YF 02 Mar 2022

    }

    keys
    {
        /*
        key(Key1; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
            Clustered = true;
        }
        */

        // YF 02 Mar 2022
        key(Key1; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Country of Purchase Code")
        {
            Clustered = true;
        }
        // YF 02 Mar 2022

        key(Key2; "Vendor No.", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
        // YF 29 Jul 2021
        /*
        key(Key3; "Vendor No.", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Direct Unit Cost")
        {
        }
        */
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
    }

    trigger OnInsert()
    begin
        TestField("Vendor No.");
        TestField("Item No.");

        // Set Starting Date defaults
        if "Starting Date" = 0D then
            "Starting Date" := WorkDate();

        // Set Ending Date defaults
        if "Ending Date" = 0D then
            "Ending Date" := DMY2Date(31, 12, 2100);
    end;

    trigger OnRename()
    begin
        TestField("Vendor No.");
        TestField("Item No.");
    end;

    var
        Vend: Record Vendor;
        Text000: Label '%1 cannot be after %2';

    /*
    procedure CopyPurchPriceToVendorsPurchPrice(var PurchPrice: Record "Purchase Price"; VendNo: Code[20])
    var
        NewPurchasePrice: Record "Purchase Price";
    begin
        if PurchPrice.FindSet then
            repeat
                NewPurchasePrice := PurchPrice;
                NewPurchasePrice."Vendor No." := VendNo;
                OnBeforeNewPurchasePriceInsert(NewPurchasePrice, PurchPrice);
                if NewPurchasePrice.Insert() then;
            until PurchPrice.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNewPurchasePriceInsert(var NewPurchasePrice: Record "Purchase Price"; PurchasePrice: Record "Purchase Price")
    begin
    end;
    */
}
