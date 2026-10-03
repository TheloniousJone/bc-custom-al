page 55078 "New Purchase Price Dialog"
{
    PageType = StandardDialog;
    CaptionML = ENU = 'Reflect Purchase Price Change Dialog',
              ENA = 'Reflect Purchase Price Change Dialog';

    SourceTable = "Pharma Purchase Price";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'Reflect Purchase Price Change Dialog',
                          ENA = 'Reflect Purchase Price Change Dialog';
                ShowCaption = true;

                field(VendorCode; VendorCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Vendor No.';
                }

                field(VendorName; VendorName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Vendor Name';
                }

                field(ItemCode; ItemCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Item No.';
                }

                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Item Description';
                }

                field(CurrencyCode; CurrencyCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Currency';
                }

                field(VariantCode; VariantCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Variant Code';
                }

                field(UOMCode; UOMCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'UOM';
                }

                field(NewPurchasePrice; NewPurchasePrice)
                {
                    CaptionML = ENU = 'New Purchase Price',
                            ENA = 'New Purchase Price';
                    Description = 'New Purchase Price';
                    ApplicationArea = All;
                    Visible = false;
                }

                // YF 29 Dec 2021
                field(NewStartDate; NewStartDate)
                {
                    Caption = 'New Purchase Start Date';
                    ApplicationArea = All;
                    Visible = true;
                }
                // YF 29 Dec 2021
                //DX        31 Jan 2025
                field(NewSalesStartDate; NewSalesStartDate)
                {
                    ApplicationArea = all;
                    Caption = 'New Sales Start Date';
                    Visible = true;
                }
                //DX        31 Jan 2025

            }

            repeater("Purchase Price Lines")
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Cost Price';
                }

                // YF 23 Dec 2021
                field("Average Cost"; Rec."Average Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    BlankZero = true;
                    Visible = true; // YF 23 Dec 2021 
                }
                // YF 23 Dec 2021

                field("New Cost Price"; Rec."New Cost Price")
                {
                    ApplicationArea = All;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        if Rec."New Cost Price" = 0 then
                            Rec."Margin Percent" := 0
                        else
                            Rec."Margin Percent" := ((Rec."New Cost Price" - Rec."Direct Unit Cost") / Rec."Direct Unit Cost") * 100; // Percentage Increase = [ (Final Value - Starting Value) / |Starting Value| ] × 100

                        CalculateAverageCost(Rec); // YF 23 Dec 2021
                    end;
                }

                // YF 23 Dec 2021
                field("New Min Order Qty"; Rec."New Min Order Qty")
                {
                    ApplicationArea = All;
                    Visible = true; // YF 23 Dec 2021 

                    trigger OnValidate()
                    begin
                        CalculateAverageCost(Rec); // YF 23 Dec 2021
                    end;
                }

                field("New FOC Qty"; Rec."New FOC Qty")
                {
                    ApplicationArea = All;
                    Visible = true; // YF 23 Dec 2021 

                    trigger OnValidate()
                    begin
                        CalculateAverageCost(Rec); // YF 23 Dec 2021
                    end;
                }

                field("New Average Cost"; Rec."New Average Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    BlankZero = true;
                    Visible = true; // YF 23 Dec 2021 
                }

                field("Margin Increase"; Rec."Margin Increase")
                {
                    ApplicationArea = All;
                    Editable = false;
                    BlankZero = true;
                    Visible = true; // YF 23 Dec 2021 
                }
                // YF 23 Dec 2021

                field("Margin Percent"; Rec."Margin Percent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    BlankZero = true;
                    Visible = false; // YF 23 Dec 2021 
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    var
        NewPurchasePrice: Decimal;
        PharmaPurchasePrices: Record "Pharma Purchase Price";
        VendorCode: Code[20];
        ItemCode: Code[20];
        CurrencyCode: Code[20];
        VariantCode: Code[20];
        UOMCode: Code[20];
        ItemDesc: Text[100];
        VendorName: Text[100];
        NewStartDate: Date; // YF 29 Dec 2021
        NewSalesStartDate: Date; //DX       31 Jan 2025


    trigger OnOpenPage()
    begin

        PharmaPurchasePrices.Reset;
        PharmaPurchasePrices.SetRange(Status, PharmaPurchasePrices.Status::Active);
        PharmaPurchasePrices.SetRange("Vendor No.", VendorCode);
        PharmaPurchasePrices.SetRange("Item No.", ItemCode);
        PharmaPurchasePrices.SetRange("Currency Code", CurrencyCode);
        PharmaPurchasePrices.SetRange("Variant Code", VariantCode);
        PharmaPurchasePrices.SetRange("Unit of Measure Code", UOMCode);
        //PharmaPurchasePrices.SetFilter("Starting Date", '<=%1', WorkDate());
        //PharmaPurchasePrices.SetFilter("Ending Date", '>=%1', WorkDate());

        if PharmaPurchasePrices.FindSet() then
            repeat
                Rec.Init();
                Rec.TransferFields(PharmaPurchasePrices, true);

                // YF 23 Dec 2021 // Load extra defaults
                Rec."New Cost Price" := PharmaPurchasePrices."Direct Unit Cost";
                Rec."New Min Order Qty" := PharmaPurchasePrices."Minimum Quantity";
                Rec."New FOC Qty" := PharmaPurchasePrices."FOC Qty";
                CalculateAverageCost(Rec);
                // YF 23 Dec 2021 // Load extra defaults

                Rec.Insert();
            until PharmaPurchasePrices.Next() = 0;
    end;

    trigger OnAfterGetCurrRecord()
    var
        VendorRec: Record Vendor;
        ItemRec: Record Item;
    begin
        // Get Vendor Name
        VendorName := '';
        if VendorRec.Get(VendorCode) then
            VendorName := VendorRec.Name;

        // Get Item Descr
        ItemDesc := '';
        if ItemRec.Get(ItemCode) then
            ItemDesc := ItemRec.Description;
    end;

    trigger OnAfterGetRecord()
    var
        VendorRec: Record Vendor;
        ItemRec: Record Item;
    begin
        // Get Vendor Name
        VendorName := '';
        if VendorRec.Get(VendorCode) then
            VendorName := VendorRec.Name;

        // Get Item Descr
        ItemDesc := '';
        if ItemRec.Get(ItemCode) then
            ItemDesc := ItemRec.Description;
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        // Previous Version 
        ItemRec: Record Item;

        HighestMarkupPercent: Decimal;
        HighestMinQty: Decimal;
        HighestNewCostPrice: Decimal;
        HighestOriCostPrice: Decimal;

        LowestMarkupPercent: Decimal;
        LowestMinQty: Decimal;
        LowestNewCostPrice: Decimal;
        LowestOriCostPrice: Decimal;

        TradeAgreementCU: Codeunit "Trade Agreement CU";

        PurchTradeAgtRec: Record "Pharma Purchase Price";
        PurchTradeAgtArchive: Record "Pharma Purchase Price Archives";
        // Previous Version 

        // Revised Version
        HighestMarginIncrease: Decimal;
        HighestNewMinQty: Decimal;
        NewPurchTreadeAgtRec: Record "Pharma Purchase Price";
    // Revised Version

    begin

        // YF 03 Jan 2022
        if CloseAction = CloseAction::OK then begin

            // YF 29 Dec 2021
            if NewStartDate = 0D then begin
                Message('New Start Date not entered');
                exit(false);
            end;
            // YF 29 Dec 2021
            //DX        31 Jan 2025
            if NewSalesStartDate = 0D Then begin
                Error('Please enter New Sales Starting Date');
            end;
            //DX        31 Jan 2025
            // Loop thru the current temporary records to find highest MOQ margin change
            if Rec.FindSet() then
                repeat

                    // validate all new unit cost price entered
                    if Rec."New Cost Price" = 0 then begin
                        Message('New Cost Price for all lines not entered');
                        exit(false);
                    end
                    else begin
                        // recalculate missing margin percent if detected
                        Rec."Margin Percent" := ((Rec."New Cost Price" - Rec."Direct Unit Cost") / Rec."Direct Unit Cost") * 100; // Percentage Increase = [ (Final Value - Starting Value) / |Starting Value| ] × 100
                        CalculateAverageCost(Rec);

                        // Tier Comparison and Identification
                        if HighestMarginIncrease = 0 then begin
                            HighestMinQty := Rec."Minimum Quantity";
                            HighestMarkupPercent := Rec."Margin Percent";
                            HighestNewCostPrice := Rec."New Cost Price";
                            HighestOriCostPrice := Rec."Direct Unit Cost";
                            HighestMarginIncrease := Rec."Margin Increase";
                            HighestNewMinQty := Rec."New Min Order Qty";
                        end
                        else begin

                            if Rec."New Min Order Qty" > HighestNewMinQty then begin
                                HighestMinQty := Rec."Minimum Quantity";
                                HighestMarkupPercent := Rec."Margin Percent";
                                HighestNewCostPrice := Rec."New Cost Price";
                                HighestOriCostPrice := Rec."Direct Unit Cost";
                                HighestMarginIncrease := Rec."Margin Increase";
                                HighestNewMinQty := Rec."New Min Order Qty";
                            end;
                        end;
                    end;
                until Rec.Next() = 0;

            // Processing Loop to generate new Purchase Price entries
            // YF 29 Dec 2021
            if Rec.FindSet() then
                repeat
                    // Disable existing price record
                    PurchTradeAgtRec.Reset();
                    PurchTradeAgtRec.SetRange("Vendor No.", Rec."Vendor No.");
                    PurchTradeAgtRec.SetRange("Item No.", Rec."Item No.");
                    PurchTradeAgtRec.SetRange("Starting Date", Rec."Starting Date");
                    PurchTradeAgtRec.SetRange("Currency Code", Rec."Currency Code");
                    PurchTradeAgtRec.SetRange("Variant Code", Rec."Variant Code");
                    PurchTradeAgtRec.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                    PurchTradeAgtRec.SetRange("Minimum Quantity", Rec."Minimum Quantity");
                    if PurchTradeAgtRec.FindFirst() then begin
                        PurchTradeAgtRec."Ending Date" := NewStartDate - 1;
                        //PurchTradeAgtRec.Status := PurchTradeAgtRec.Status::active; //change to active
                        if Today > NewStartDate then
                            PurchTradeAgtRec.Status := PurchTradeAgtRec.Status::Inactive; //change to inactive
                        PurchTradeAgtRec.Modify();
                    end;

                    // Insert new price record
                    NewPurchTreadeAgtRec.Init;
                    NewPurchTreadeAgtRec."Item No." := Rec."Item No.";
                    NewPurchTreadeAgtRec."Vendor No." := Rec."Vendor No.";
                    NewPurchTreadeAgtRec."Currency Code" := Rec."Currency Code";
                    NewPurchTreadeAgtRec."Starting Date" := NewStartDate;
                    NewPurchTreadeAgtRec."Direct Unit Cost" := Rec."New Cost Price";
                    NewPurchTreadeAgtRec."Price Includes VAT" := Rec."Price Includes VAT";
                    NewPurchTreadeAgtRec."Allow Invoice Disc." := Rec."Allow Invoice Disc.";
                    NewPurchTreadeAgtRec."Line Discount %" := Rec."Line Discount %";
                    NewPurchTreadeAgtRec."Allow Line Disc." := Rec."Allow Line Disc.";
                    NewPurchTreadeAgtRec."Minimum Quantity" := Rec."New Min Order Qty";
                    //RL   06 Jan 2022 - to replace new end date with old end date
                    //NewPurchTreadeAgtRec."Ending Date" := Rec."Ending Date";
                    NewPurchTreadeAgtRec.Validate("Ending Date", DMY2Date(31, 12, 2100));
                    //RL   06 Jan 2022  
                    NewPurchTreadeAgtRec.Status := Rec.Status;
                    NewPurchTreadeAgtRec."Unit of Measure Code" := Rec."Unit of Measure Code";
                    NewPurchTreadeAgtRec."Variant Code" := Rec."Variant Code";
                    NewPurchTreadeAgtRec."FOC Qty" := Rec."New FOC Qty";
                    NewPurchTreadeAgtRec.RecRefID := Rec.RecRefID;
                    NewPurchTreadeAgtRec.Remarks := Rec.Remarks;
                    NewPurchTreadeAgtRec."Average Cost" := Rec."Average Cost";
                    IF NewPurchTreadeAgtRec.Insert(true) then begin

                    end;

                until Rec.Next() = 0;
            // YF 29 Dec 2021

            // Generate Sales Price Staging Entries based on highest MQC
            if ItemRec.Get(ItemCode) then begin
                Clear(TradeAgreementCU);
                // YF 12 Jan 2022
                //TradeAgreementCU.HandlePriceChangeV3(ItemCode, CurrencyCode, VariantCode, UOMCode, HighestOriCostPrice, HighestNewCostPrice, HighestMarginIncrease, NewStartDate);
                // YF 12 Jan 2022
                //DX        31 Jan 2025
                HighestMarkupPercent := (HighestMarkupPercent / 100) + 1;
                //TradeAgreementCU.HandlePriceChangeV3(ItemCode, CurrencyCode, VariantCode, UOMCode, HighestOriCostPrice, HighestNewCostPrice, HighestMarginIncrease, NewSalesStartDate);
                TradeAgreementCU.HandlePriceChangeV3(ItemCode, CurrencyCode, VariantCode, UOMCode, HighestOriCostPrice, HighestNewCostPrice, HighestMarkupPercent, NewSalesStartDate);
                //DX        31 Jan 2025
            end;

        end;
        // YF 03 Jan 2022

        if CloseAction = CloseAction::Cancel then
            exit(true);

        exit(true);
    end;

    procedure SetVendorNo(VendorCodeParameter: Code[20])
    begin
        VendorCode := VendorCodeParameter;
    end;

    procedure SetItemNo(ItemCodeParameter: Code[20])
    begin
        ItemCode := ItemCodeParameter;
    end;

    procedure SetCurrencyCode(CurrencyCodeParameter: Code[20])
    begin
        CurrencyCode := CurrencyCodeParameter;
    end;

    procedure SetVariantCode(VariantCodeParameter: Code[20])
    begin
        VariantCode := VariantCodeParameter;
    end;

    procedure SetUOMCode(UOMCodeParameter: Code[20])
    begin
        UOMCode := UOMCodeParameter;
    end;

    procedure GetNewPurchasePrice(): Decimal;
    begin
        exit(NewPurchasePrice);
    end;

    // YF 23 Dec 2021
    local procedure CalculateAverageCost(var PriceRec: Record "Pharma Purchase Price")
    begin
        if PriceRec."FOC Qty" <> 0 then //Change from direct cost to FOC
            // PriceRec."Average Cost" := (PriceRec."Minimum Quantity" + PriceRec."FOC Qty") / PriceRec."Direct Unit Cost"
            PriceRec."Average Cost" := (PriceRec."Direct Unit Cost" * PriceRec."Minimum Quantity") / (PriceRec."Minimum Quantity" + PriceRec."FOC Qty")
        else
            PriceRec."Average Cost" := PriceRec."Direct Unit Cost";

        if PriceRec."New FOC Qty" <> 0 then //Change from new cost to new FOC
            // PriceRec."New Average Cost" := (PriceRec."New Min Order Qty" + PriceRec."New FOC Qty") / PriceRec."New Cost Price"
            PriceRec."New Average Cost" := (PriceRec."New Cost Price" * PriceRec."New Min Order Qty") / (PriceRec."New Min Order Qty" + PriceRec."New FOC Qty")
        else
            PriceRec."New Average Cost" := PriceRec."New Cost Price";  //change from 0 to new cost price

        // Calculate Margin Increase
        if PriceRec."Average Cost" <> 0 then
            PriceRec."Margin Increase" := ROUND(1 + ((PriceRec."New Average Cost" - PriceRec."Average Cost") / PriceRec."Average Cost"), 0.01, '>') //RL  06 Jan 2022 - round up margin
        else
            PriceRec."Margin Increase" := 0;
        // Calculate Margin Increase
    end;
    // YF 23 Dec 2021
}