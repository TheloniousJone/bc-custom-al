codeunit 55005 "Trade Agreement CU"
{

    procedure UpdatePLLine(var PLRec: Record "Purchase Line")
    var
        OrgLineAmt: Decimal;
        InclFocUnitPrice: Decimal;
    begin
        OrgLineAmt := PLRec."Purchase Price" * PLRec."Order Qty";
        InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty" + PLRec."FOC Qty");
        PLRec.Validate(Quantity, PLRec."Order Qty" + PLRec."FOC Qty");
        PLRec.Validate("FOC Qty", PLRec."FOC Qty");
        PLRec.Validate("Purchase Price", PLRec."Purchase Price");
        PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
        PLRec.Modify(TRUE);
    end;


    procedure UpdateSLLine(Var SLRec: Record "Sales Line")
    var
        InclFOCUnitPrice: Decimal;
        OrgLineAmt: Decimal;
    begin
        OrgLineAmt := SLRec."Selling Price" * SLRec."Order Qty";
        InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty" + SLRec."FOC Qty");
        SLRec.Validate("Unit Price", InclFOCUnitPrice);
        SLRec.Validate(Quantity, SLRec."Order Qty" + SLRec."FOC Qty");
        //DX        28 July 2021
        SLRec.Validate("FOC (Qty) To Deliver", SLRec."FOC Qty" - SLRec."FOC Qty Delivered");
        //DX        28 July 2021
        SLRec.Modify(TRUE);
    end;

    procedure UpdatePLLineFOCQtyAndAmt(var PLRec: Record "Purchase Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Price List Line";
    begin
        GetPriceTierForPurchaseAgreement(PLRec, PriceListLineRec);
        //FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity") * PriceListLineRec."FOC Qty";        //If order 100 pcs, 100 /2 * 15 to get extra sets of FOC        
        AgreementQty := PriceListLineRec."Minimum Quantity";
        if PriceListLineRec."Minimum Quantity" <> 0 then
            FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
        FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15        
        if FOCQty <> 0 then begin
            OrgLineAmt := PLRec."Purchase Price" * PLRec."Order Qty";
            InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty" + FOCQty);
            PLRec.Validate(Quantity, PLRec."Order Qty" + FOCQty);
            PLRec.Validate("FOC Qty", FOCQty);
            PLRec.Validate("Purchase Price", PriceListLineRec."Direct Unit Cost");
            PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
            PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");      //DX        27 Jun 2021 : Add line discount
            PLRec.Modify(TRUE);
        end else begin          //If no FOC available
            PLRec.Validate(Quantity, PLRec."Order Qty");
            PLRec.Validate("FOC Qty", 0);
            PLRec.Validate("Purchase Price", 0);
            PLRec.Validate("Direct Unit Cost", 0);

            PLRec.Modify(TRUE);
        end;
    end;

    procedure UpdateSLLineFromFOCQty(var SLRec: Record "Sales Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Price List Line";
    begin
        FOCQty := SLRec."FOC Qty";
        if FOCQty <> 0 then begin
            OrgLineAmt := SLRec."Selling Price" * SLRec."Order Qty";
            InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty" + FOCQty);
            SLRec.Validate(Quantity, SLRec."Order Qty" + FOCQty);
            SLRec.Validate("Unit Price", InclFOCUnitPrice);
            //DX        28 July 2021
            SLRec.Validate(SLRec."FOC (Qty) To Deliver", SLRec."FOC Qty" - SLRec."FOC Qty Delivered");
            SLRec.Validate(SLRec."Qty To Deliver", SLRec."Order Qty" - SLRec."Qty Delivered");
            //DX        28 July 2021
            SLRec.Modify(TRUE);
        end else begin
            OrgLineAmt := SLRec."Selling Price" * SLRec."Order Qty";
            InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty");
            SLRec.Validate(Quantity, SLRec."Order Qty");
            SLRec.Validate("Unit Price", InclFOCUnitPrice);
            //DX        28 July 2021
            SLRec.Validate(SLRec."FOC (Qty) To Deliver", SLRec."FOC Qty" - SLRec."FOC Qty Delivered");
            SLRec.Validate(SLRec."Qty To Deliver", SLRec."Order Qty" - SLRec."Qty Delivered");
            //DX        28 July 2021
            SLRec.Modify(TRUE);
        end;
    end;

    procedure UpdateSLLineSellPrice(var SLRec: Record "Sales Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Price List Line";
    begin
        FOCQty := SLRec."FOC Qty";

        OrgLineAmt := SLRec."Selling Price" * SLRec."Order Qty";
        InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty" + FOCQty);
        SLRec.Validate("Unit Price", InclFOCUnitPrice);
        SLRec.Modify(TRUE);
    end;

    procedure UpdatePLLineFromFOCQty(var PLRec: Record "Purchase Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Price List Line";
    begin
        FOCQty := PLRec."FOC Qty";
        if FOCQty <> 0 then begin
            OrgLineAmt := PLRec."Purchase Price" * PLRec."Order Qty";
            InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty" + FOCQty);
            PLRec.Validate(Quantity, PLRec."Order Qty" + FOCQty);
            PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
            PLRec.Modify(TRUE);
        end else begin
            OrgLineAmt := PLRec."Purchase Price" * PLRec."Order Qty";
            InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty");
            PLRec.Validate(Quantity, PLRec."Order Qty");
            PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
            PLRec.Modify(TRUE);
        end;
    end;

    procedure UpdatePLLineSellPrice(var PLRec: Record "Purchase Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Price List Line";
    begin
        FOCQty := PLRec."FOC Qty";
        OrgLineAmt := PLRec."Purchase Price" * PLRec."Order Qty";
        InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty" + FOCQty);
        PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
        PLRec.Modify(TRUE);
    end;

    procedure IsPromoPrice(var SLRec: Record "Sales Line") IsPromo: Boolean;
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Price List Line";
    begin
        //GetPriceTierForSalesAgreement(SLRec, PriceListLineRec);
        //if PriceListLineRec."Minimum Quantity" <> 0 then
        //    FOCQty := PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15                
        if SLRec."FOC Qty" <> 0 then begin
            exit(TRUE)
        end else
            exit(FALSE);
    end;


    procedure IsValidPurchaseAgreement(PLRec: Record "Purchase Line") IsValid: Boolean
    var
        myInt: Integer;
        PriceListRec: Record "Price List Line";
        PharmaPriceList: Record "Pharma Purchase Price";
    begin
        //180521        DX      Check if there is a valid purchase agreement first.
        //DX        16 Aug 2021         Amend to new purchase price table        
        PharmaPriceList.reset;
        PharmaPriceList.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
        PharmaPriceList.SetRange(Status, PriceListRec.Status::Active);
        //PharmaPriceList.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
        PharmaPriceList.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        //PharmaPriceList.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
        PharmaPriceList.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        PharmaPriceList.SetRange("Item No.", PLRec."No.");
        if PharmaPriceList.FindFirst() then
            IsValid := true
        else
            IsValid := false;
    end;


    procedure IsValidSalesAgreement(SLRec: Record "Sales Line") IsValid: Boolean
    var
        PriceListRec: Record "Price List Line";
        SHRec: Record "Sales Header";
        PharmaSalesPrice: Record "Pharma Sales Price";
    begin
        //180521        DX      Check if there is a valid purchase agreement first.
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin
            //DX        16 Aug 2021     Change to new price table
            PharmaSalesPrice.reset;
            PharmaSalesPrice.SetRange("Sales Type", PharmaSalesPrice."Sales Type"::Customer);
            PharmaSalesPrice.SetRange("Sales Code", SLRec."Sell-to Customer No.");
            PharmaSalesPrice.SetRange(Status, PriceListRec.Status::Active);
            PharmaSalesPrice.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PharmaSalesPrice.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PharmaSalesPrice.SetRange("Item No.", SLRec."No.");
            PharmaSalesPrice.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            if PharmaSalesPrice.FindFirst() then
                IsValid := true
            else
                IsValid := false;
            //DX        16 Aug 2021     Change to new price table
        end;
    end;

    local procedure PLQtyIsLowerThanTradeAgreement(PLRec: Record "Purchase Line") IsTrue: Boolean
    var
        lPriceListRec: Record "Price List Line";
    begin
        lPriceListRec.reset;
        lPriceListRec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
        lPriceListRec.SetRange("Source Type", lPriceListRec."Source Type"::Vendor);
        lPriceListRec.SetRange("Source No.", PLRec."Buy-from Vendor No.");
        lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
        //lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
        lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        //lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
        lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++


        lPriceListRec.SetRange("Asset Type", lPriceListRec."Asset Type"::Item);
        lPriceListRec.SetRange("Asset No.", PLRec."No.");
        lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
        if lPriceListRec.FindFirst() then begin
            if PLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                exit(true)
            else
                exit(false);
        end;
    end;

    //180521        DX      PMP creates trade agreements based on tiers.
    procedure GetPriceTierForPurchaseAgreement(PLRec: Record "Purchase Line"; var PriceListRec: Record "Price List Line")
    var
        myInt: Integer;
    begin
        //Different scenarios to consider
        //eg. buy 10 FOC 1, 25 FOC 5, 50 FOC 15
        if NOT (PLQtyIsLowerThanTradeAgreement(PLRec)) then begin
            PriceListRec.reset;
            PriceListRec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            PriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
            PriceListRec.SetRange("Source Type", PriceListRec."Source Type"::Vendor);
            PriceListRec.SetRange("Source No.", PLRec."Buy-from Vendor No.");
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            //PriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
            //PriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
            PriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));
            PriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));
            PriceListRec.SetRange("Asset Type", PriceListRec."Asset Type"::Item);
            PriceListRec.SetRange("Asset No.", PLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
            PriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
            if PriceListRec.FindFirst() then begin      //If can find any tier that is below the total quantity of PL line, then return the relveant tier closest tier.
            end else begin
                PriceListRec.reset;
                PriceListRec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                PriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                PriceListRec.SetRange("Source Type", PriceListRec."Source Type"::Vendor);
                PriceListRec.SetRange("Source No.", PLRec."Buy-from Vendor No.");
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                // PriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                // PriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                PriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                PriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                PriceListRec.SetRange("Asset Type", PriceListRec."Asset Type"::Item);
                PriceListRec.SetRange("Asset No.", PLRec."No.");                //Min qty : 50 pcs , PL line 100 Pcs
                PriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                if PriceListRec.FindFirst() then begin      //Just return the highest min qty tier if cannot find any tier below.
                end;
            end;
        end;
    end;

    local procedure SLQtyIsLowerThanTradeAgreement(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
        lPriceListrec: Record "Price List Line";
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin
            lPriceListrec.reset;
            lPriceListrec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListrec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
            lPriceListrec.SetRange("Source Type", lPriceListrec."Source Type"::Customer);
            lPriceListrec.SetRange("Source No.", SLRec."Sell-to Customer No.");
            lPriceListrec.SetRange(Status, lPriceListrec.Status::Active);
            lPriceListrec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            lPriceListrec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            lPriceListrec.SetRange("Asset Type", lPriceListrec."Asset Type"::Item);
            lPriceListrec.SetRange("Asset No.", SLRec."No.");
            lPriceListrec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            if lPriceListrec.FindFirst() then begin
                if SLRec."Order Qty" < lPriceListrec."Minimum Quantity" then begin
                    exit(true);
                end else begin
                    exit(false);
                end;

            end;
        end;

    end;

    //180521        DX      PMP creates trade agreements based on tiers.


    //DX        17 Jun 2021 : Additional calculation for rolling 12 month average and compare to item card before trigger approval.
    //Item total sales / 12 > Item Card Max qty
    procedure RequireMaxQtyApproval(var SLRec: Record "Sales Line")
    var
        TotalSales: Decimal;
        ILERec: Record "Item Ledger Entry";
        ItemRec: Record item;
        SHRec: Record "Sales Header";
        CustException: Record "Customer Exception Orders";
        ErrorMessage: Label 'Max qty approval required';
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin end;
        if (SLRec.Type = SLRec.Type::Item) and
        (SLRec."No." <> '') and
        (SLRec.Quantity <> 0) then begin        //Filter the last 12 months of total item sales first for the line
            ItemRec.reset;
            ItemRec.get(SLRec."No.");
            if itemRec."Max Mthly Order Qty" <> 0 then begin
                //DX        07 Sept 2021
                //if (current month item ledger + salesline order qty)>monthly avg, then flag maxqtyApproval                
                ILERec.reset;
                ILERec.SetRange("Item No.", SLRec."No.");
                ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
                ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
                ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                ILERec.SetFilter("Posting Date", '%1..%2', CalcDate('-1M', Today), Today);
                ILERec.CalcSums(Quantity);
                TotalSales := abs(ILERec.Quantity);
                TotalSales := TotalSales + SLRec."Quantity (Base)";

                if TotalSales > ItemRec."Max Mthly Order Qty" then begin
                    SLRec."Max Qty Approval" := true;
                    SLRec.Modify(TRUE);
                    SHRec."Max Qty Item App. Required" := true;
                    SHRec.Modify(TRUE);
                end;
                //DX        07 Sept 2021

                //Start of 2nd approval requirement.    if (total sales/12)> monthly avg,then flag maxqtyApproval
                ILERec.reset;
                ILERec.SetRange("Item No.", SLRec."No.");
                ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
                ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
                ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                ILERec.SetFilter("Posting Date", '%1..%2', CalcDate('-1Y', Today), Today);
                ILERec.CalcSums(Quantity);
                TotalSales := abs(ILERec.Quantity);

                if TotalSales <> 0 then begin
                    if TotalSales / 12 > ItemRec."Max Mthly Order Qty" then begin       //If average last 12 month sales is above the max item limit
                        CustException.reset;
                        CustException.SetRange("Cust No.", SLRec."Sell-to Customer No.");
                        CustException.SetRange("Item No.", SLRec."No.");
                        if CustException.FindFirst() then begin
                            if TotalSales / 12 > CustException.Quantity then begin      //if total purchase exceeds customer exceptions, then trigger approval
                                SLRec."Max Qty Approval" := true;
                                SLRec.Modify(TRUE);
                                SHRec.reset;
                                SHRec.SetRange("Document Type", SLRec."Document Type");
                                SHRec.SetRange("No.", SLRec."Document No.");
                                if SHRec.FindFirst() then begin
                                    SHRec."Max Qty Item App. Required" := true;
                                    SHRec.Modify(TRUE);
                                    Message(ErrorMessage);
                                end;

                            end;
                        end else begin                  //if don;t have exception, straight away trigger for approval
                            SLRec."Max Qty Approval" := true;
                            SLRec.Modify(TRUE);
                            SHRec.reset;
                            SHRec.SetRange("Document Type", SLRec."Document Type");
                            SHRec.SetRange("No.", SLRec."Document No.");
                            if SHRec.FindFirst() then begin
                                SHRec."Max Qty Item App. Required" := true;
                                SHRec.Modify(TRUE);
                                Message(ErrorMessage);
                            end;
                        end;
                        ILERec.reset;
                        ILERec.SetRange("Item No.", SLRec."No.");
                        ILERec.SetRange("Source Type", ILERec."Source Type"::Customer);
                        ILERec.SetRange("Source No.", SLRec."Sell-to Customer No.");
                        ILERec.SetRange("Entry Type", ILERec."Entry Type"::Sale);
                        ILERec.SetFilter("Posting Date", '%1..%2', CalcDate('-1Y', Today), Today);
                        ILERec.CalcSums(Quantity);
                        TotalSales := ILERec.Quantity;
                        if TotalSales <> 0 then begin
                            if TotalSales / 12 > ItemRec."Max Mthly Order Qty" then begin       //If average last 12 month sales is above the max item limit
                                CustException.reset;
                                CustException.SetRange("Cust No.", SLRec."Sell-to Customer No.");
                                CustException.SetRange("Item No.", SLRec."No.");
                                if CustException.FindFirst() then begin
                                    if TotalSales / 12 > CustException.Quantity then begin      //if total purchase exceeds customer exceptions, then trigger approval
                                        SLRec."Max Qty Approval" := true;
                                        SLRec.Modify(TRUE);
                                        SHRec."Max Qty Item App. Required" := true;
                                        SHRec.Modify(TRUE);
                                        Message(ErrorMessage);
                                    end;
                                end else begin                  //if don;t have exception, straight away trigger for approval
                                    SLRec."Max Qty Approval" := true;
                                    SLRec.Modify(TRUE);
                                    SHRec."Max Qty Item App. Required" := true;
                                    SHRec.Modify(TRUE);
                                    Message(ErrorMessage);
                                end;
                            end;
                        end;
                    end;
                end else begin
                    //DX        28 Aug 2021
                    //If never have sales before, just take from item card 
                    if SLRec."Order Qty" > ItemRec."Max Mthly Order Qty" then begin
                        SLRec."Max Qty Approval" := true;
                        SLRec.Modify(TRUE);
                        SHRec."Max Qty Item App. Required" := true;
                        SHRec.Modify(TRUE);
                        Message(ErrorMessage);
                    end;
                end;
            end;
        end;
    end;
    //DX        17 Jun 2021 : Additional calculation for rolling 12 month average and compare to item card before trigger approval.


    // YF  23 July 2021
    procedure GetPriceTierForPurchaseAgreement(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal; var PriceListRec: Record "Price List Line")
    begin
        //Different scenarios to consider
        //eg. buy 10 FOC 1, 25 FOC 5, 50 FOC 15
        if NOT (PLQtyIsLowerThanTradeAgreement(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty)) then begin
            PriceListRec.reset;
            PriceListRec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            PriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
            PriceListRec.SetRange("Source Type", PriceListRec."Source Type"::Vendor);
            PriceListRec.SetRange("Source No.", VendorNo);
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
            PriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
            PriceListRec.SetRange("Asset Type", PriceListRec."Asset Type"::Item);
            PriceListRec.SetRange("Asset No.", AssetNo);
            PriceListRec.SetRange("Unit of Measure Code", AssetUOM);
            PriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs
            if PriceListRec.FindFirst() then begin      //If can find any tier that is below the total quantity of PL line, then return the relveant tier closest tier.
            end else begin
                PriceListRec.reset;
                PriceListRec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                PriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                PriceListRec.SetRange("Source Type", PriceListRec."Source Type"::Vendor);
                PriceListRec.SetRange("Source No.", VendorNo);
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                PriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                PriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                PriceListRec.SetRange("Asset Type", PriceListRec."Asset Type"::Item);
                PriceListRec.SetRange("Asset No.", AssetNo);                //Min qty : 50 pcs , PL line 100 Pcs
                PriceListRec.SetRange("Unit of Measure Code", AssetUOM);
                if PriceListRec.FindFirst() then begin      //Just return the highest min qty tier if cannot find any tier below.
                end;
            end;
        end;
    end;

    local procedure PLQtyIsLowerThanTradeAgreement(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal) IsTrue: Boolean
    var
        lPriceListRec: Record "Price List Line";
    begin
        lPriceListRec.reset;
        lPriceListRec.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
        lPriceListRec.SetRange("Source Type", lPriceListRec."Source Type"::Vendor);
        lPriceListRec.SetRange("Source No.", VendorNo);
        lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
        lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
        lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
        lPriceListRec.SetRange("Asset Type", lPriceListRec."Asset Type"::Item);
        lPriceListRec.SetRange("Asset No.", AssetNo);
        lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
        if lPriceListRec.FindFirst() then begin
            if AssetOrderQty < lPriceListRec."Minimum Quantity" then
                exit(true)
            else
                exit(false);
        end;
    end;
    // YF  23 July 2021


    // YF  28 July 2021 // For Custom PMP Purchase Price List
    procedure IsValidPurchaseAgreement_PMPCustomized(PLRec: Record "Purchase Line") IsValid: Boolean
    var
        PriceListRec: Record "Pharma Purchase Price";
    begin
        //180521        DX      Check if there is a valid purchase agreement first.
        PriceListRec.Reset;
        PriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
        PriceListRec.SetRange(Status, PriceListRec.Status::Active);
        // PriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
        // PriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
        PriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        PriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        PriceListRec.SetRange("Item No.", PLRec."No.");
        if PriceListRec.FindFirst() then
            IsValid := true
        else
            IsValid := false;
    end;

    procedure UpdatePLLineFOCQtyAndAmt_PMPCustomized(var PLRec: Record "Purchase Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Pharma Purchase Price";
        ItemRec: Record Item;
        AMQ6: Decimal;
        PMPEnhacnce: Codeunit "PMP-Enhancements";

    begin
        GetPriceTierForPurchaseAgreement_PMPCustomized(PLRec, PriceListLineRec);

        if PriceListLineRec.IsEmpty then begin
            // use price from item card - last direct unit cost
            if ItemRec.Get(PLRec."No.") then begin
                PLRec.Validate(Quantity, PLRec."Order Qty");
                PLRec.Validate("FOC Qty", 0);
                PLRec.Validate("Purchase Price", ItemRec."Last Direct Cost");
                PLRec.Validate("Direct Unit Cost", ItemRec."Last Direct Cost");
                // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end
        else begin
            //FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity") * PriceListLineRec."FOC Qty";        //If order 100 pcs, 100 /2 * 15 to get extra sets of FOC        
            AgreementQty := PriceListLineRec."Minimum Quantity";
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15    

            if FOCQty <> 0 then begin
                //DX        27 Aug 2021     Bug fixes
                //OrgLineAmt := PLRec."Purchase Price" * PLRec."Order Qty";
                OrgLineAmt := PriceListLineRec."Direct Unit Cost" * PLRec."Order Qty";
                //DX        27 Aug 2021 
                InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty" + FOCQty);
                PLRec.Validate(Quantity, PLRec."Order Qty" + FOCQty);
                PLRec.Validate("FOC Qty", FOCQty);
                PLRec.Validate("Purchase Price", PriceListLineRec."Direct Unit Cost");
                PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
                PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");      //DX        27 Jun 2021 : Add line discount
            end else begin          //If no FOC available
                PLRec.Validate(Quantity, PLRec."Order Qty");
                PLRec.Validate("FOC Qty", 0);
                PLRec.Validate("Purchase Price", PriceListLineRec."Direct Unit Cost");
                PLRec.Validate("Direct Unit Cost", PriceListLineRec."Direct Unit Cost");
                PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end;

        PLRec.Modify(TRUE);
    end;

    procedure GetPriceTierForPurchaseAgreement_PMPCustomized(PLRec: Record "Purchase Line"; var PriceListRec: Record "Pharma Purchase Price")
    var
        lPriceListRec: Record "Pharma Purchase Price";
        lLowestPrice: Decimal;
    begin
        //Different scenarios to consider
        //eg. buy 10 FOC 1, 25 FOC 5, 50 FOC 15
        if NOT (PLQtyIsLowerThanTradeAgreement_PMPCustomized(PLRec)) then begin
            lPriceListRec.reset;
            lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

            lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
            lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
            //lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
            //lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
            lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
            lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
            lPriceListRec.SetRange("Item No.", PLRec."No.");
            lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

            // find lowest price from this returned dataset cos getrangemin can't work here
            if lPriceListRec.FindSet() then
                repeat
                    if lLowestPrice = 0 then
                        lLowestPrice := lPriceListRec."Direct Unit Cost"
                    else begin
                        if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                            lLowestPrice := lPriceListRec."Direct Unit Cost";
                    end;
                until lPriceListRec.Next() = 0
            else
                lLowestPrice := 0;

            // Message(Format(lLowestPrice)); // debug statement

            //If can find any tier that is below the total quantity of PL line, then return the relveant tier closest tier.
            if lLowestPrice <> 0 then begin
                //DX        29 Aug 2021     Removed current key starting date
                lPriceListRec.reset;
                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetRange("Item No.", PLRec."No.");
                lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                //DX        29 Aug 2021     Additional filters to get the correct list.

                lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);

                if lPriceListRec.Find('-') then
                    PriceListRec := lPriceListRec;
            end
            else begin
                lPriceListRec.reset;
                //lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                //lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Direct Unit Cost");
                lPriceListRec.SetAscending("Minimum Quantity", false);       //Loop from highest minmum quantity first 
                lPriceListRec.SetAscending("Direct Unit Cost", true);       //Loop from lowest direct unit cost next 

                lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetRange("Item No.", PLRec."No.");                //Min qty : 50 pcs , PL line 100 Pcs
                lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                //DX        29 Aug 2021
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                //DX        29 Aug 2021
                // find lowest price from this returned dataset cos getrangemin can't work here
                if lPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lPriceListRec."Direct Unit Cost"
                        else begin
                            if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                                lLowestPrice := lPriceListRec."Direct Unit Cost";
                        end;
                    until lPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX        29 Aug 2021
                    lPriceListRec.reset;
                    lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                    lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                    lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
                    lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                    // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                    // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                    lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                    lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                    lPriceListRec.SetRange("Item No.", PLRec."No.");
                    lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                    lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                 //DX        29 Aug 2021     Additional filters to get the correct list.
                    lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);

                    if lPriceListRec.Find('-') then begin
                        PriceListRec := lPriceListRec;
                    end;
                end;
            end;
        end;

    end;

    local procedure PLQtyIsLowerThanTradeAgreement_PMPCustomized(PLRec: Record "Purchase Line") IsTrue: Boolean
    var
        lPriceListRec: Record "Pharma Purchase Price";
    begin
        lPriceListRec.reset;
        lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first 

        lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
        lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
        // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
        // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
        lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        lPriceListRec.SetRange("Item No.", PLRec."No.");
        lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
        //DX    28 Aug 2021
        lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
        //DX    28 Aug 2021
        if lPriceListRec.FindFirst() then begin
            if PLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                exit(true)
            else
                exit(false);
        end;
    end;

    procedure GetPriceTierForPurchaseAgreement_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal; var PriceListRec: Record "Pharma Purchase Price")
    var
        lPriceListRec: Record "Pharma Purchase Price";
        lLowestPrice: Decimal;
    begin
        //Different scenarios to consider
        //eg. buy 10 FOC 1, 25 FOC 5, 50 FOC 15
        if NOT (PLQtyIsLowerThanTradeAgreement_PMPCustomized(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty)) then begin
            lPriceListRec.reset;
            lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

            lPriceListRec.SetRange("Vendor No.", VendorNo);
            lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
            lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
            lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
            lPriceListRec.SetRange("Item No.", AssetNo);
            lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs

            // find lowest price from this returned dataset cos getrangemin can't work here
            if lPriceListRec.FindSet() then
                repeat
                    if lLowestPrice = 0 then
                        lLowestPrice := lPriceListRec."Direct Unit Cost"
                    else begin
                        if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                            lLowestPrice := lPriceListRec."Direct Unit Cost";
                    end;
                until lPriceListRec.Next() = 0
            else
                lLowestPrice := 0;

            // Message(Format(lLowestPrice)); // debug statement

            //If can find any tier that is below the total quantity of PL line, then return the relveant tier closest tier.
            if lLowestPrice <> 0 then begin

                //DX        29 Aug 2021     Removed current key starting date
                lPriceListRec.reset;
                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange("Vendor No.", VendorNo);
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                lPriceListRec.SetRange("Item No.", AssetNo);
                lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                         //DX        29 Aug 2021     Additional filters to get the correc

                lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);
                //DX        29 Aug 2021     Additional filters to get the correct list.

                lPriceListRec.Find('-');
            end
            else begin
                lPriceListRec.reset;
                //lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                //lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Direct Unit Cost");
                lPriceListRec.SetAscending("Minimum Quantity", false);       //Loop from highest minmum quantity first 
                lPriceListRec.SetAscending("Direct Unit Cost", true);       //Loop from lowest direct unit cost next 

                lPriceListRec.SetRange("Vendor No.", VendorNo);
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                lPriceListRec.SetRange("Item No.", AssetNo);                //Min qty : 50 pcs , PL line 100 Pcs
                lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lPriceListRec."Direct Unit Cost"
                        else begin
                            if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                                lLowestPrice := lPriceListRec."Direct Unit Cost";
                        end;
                    until lPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX        29 Aug 2021     Removed current key starting date
                    lPriceListRec.reset;
                    lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                    lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                    lPriceListRec.SetRange("Vendor No.", VendorNo);
                    lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                    lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                    lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                    lPriceListRec.SetRange("Item No.", AssetNo);
                    lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
                    lPriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                             //DX        29 Aug 2021     Additional filters to get the correc
                    lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);

                    lPriceListRec.Find('-');
                end;
            end;

            // Assign and return found price list
            PriceListRec := lPriceListRec;
        end;

    end;

    local procedure PLQtyIsLowerThanTradeAgreement_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal) IsTrue: Boolean
    var
        lPriceListRec: Record "Pharma Purchase Price";
    begin
        lPriceListRec.reset;
        lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first 

        lPriceListRec.SetRange("Vendor No.", VendorNo);
        lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
        lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
        lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
        lPriceListRec.SetRange("Item No.", AssetNo);
        lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
        if lPriceListRec.FindFirst() then begin
            if AssetOrderQty < lPriceListRec."Minimum Quantity" then
                exit(true)
            else
                exit(false);
        end;
    end;
    // YF  28 July 2021 // For Custom PMP Purchase Price List

    // YF  03 August 2021 // For Custom PMP Sales Price List

    procedure IsValidSalesAgreement_PMPCustomized(SLRec: Record "Sales Line"): Boolean
    var
        PriceListRec: Record "Pharma Sales Price";
        SHRec: Record "Sales Header";
        CustRec: Record Customer;
        CustNo: Code[20]; // YF 23 Aug 2021 // Logic Change Request by Richmond
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check all customers and campaign
            PriceListRec.Reset();
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Sales Type", '%1|%2', PriceListRec."Sales Type"::"All Customers", PriceListRec."Sales Type"::Campaign);
            PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PriceListRec.SetRange("Item No.", SLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
            PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 18 Mar 2022
            if PriceListRec.FindFirst() then
                exit(true);

            // Check customer specific
            PriceListRec.Reset();
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::Customer);

            // YF 23 Aug 2021 // Logic Change Request by Richmond
            // PriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            if SHRec."Bill-to Customer No." <> '' then
                PriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.")
            else
                PriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            // YF 23 Aug 2021 // Logic Change Request by Richmond

            PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PriceListRec.SetRange("Item No.", SLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
            PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 18 Mar 2022
            if PriceListRec.FindFirst() then
                exit(true);

            // Check customer group
            // YF 23 Aug 2021 // Logic Change Request by Richmond
            if SHRec."Bill-to Customer No." <> '' then
                CustNo := SHRec."Bill-to Customer No."
            else
                CustNo := SHRec."Sell-to Customer No.";
            // YF 23 Aug 2021 // Logic Change Request by Richmond
            if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                PriceListRec.Reset();
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::"Customer Price Group");
                PriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                PriceListRec.SetRange("Item No.", SLRec."No.");
                PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 18 Mar 2022
                if PriceListRec.FindFirst() then
                    exit(true);
            end;
        end;

        exit(false);

    end;

    procedure UpdateSLLineFOCQtyAndAmt_PMPCustomized(var SLRec: Record "Sales Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Pharma Sales Price";
        ItemRec: Record Item;
    begin
        Clear(PriceListLineRec);
        GetPriceTierForSalesAgreement_PMPCustomized(SLRec, PriceListLineRec);

        if PriceListLineRec.IsEmpty then begin
            // use price from item card - last direct unit cost
            if ItemRec.Get(SLRec."No.") then begin
                SLRec.Validate(Quantity, SLRec."Order Qty");
                SLRec.Validate("FOC Qty", 0);
                SLRec.Validate("Selling Price", ItemRec."Unit Price");
                SLRec.Validate("Unit Price", ItemRec."Unit Price");
                // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end
        else begin
            //FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity") * PriceListLineRec."FOC Qty";        //If order 100 pcs, 100 /2 * 15 to get extra sets of FOC        
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (SLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15        
            AgreementQty := PriceListLineRec."Minimum Quantity";
            if FOCQty <> 0 then begin
                OrgLineAmt := PriceListLineRec."Unit Price" * SLRec."Order Qty";
                InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty" + FOCQty);
                SLRec.Validate(Quantity, SLRec."Order Qty" + FOCQty);
                SLRec.Validate("FOC Qty", FOCQty);
                SLRec.Validate("Selling Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Unit Price", InclFOCUnitPrice);
                SLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");      //DX        27 Jun 2021 : Add line discount
                                                                                            //DX        28 July 2021
                SLRec.Validate("Qty To Deliver", SLRec."Order Qty" - SLRec."Qty Delivered");
                SLRec.validate("FOC (Qty) To Deliver", SLRec."FOC Qty" - SLRec."FOC Qty Delivered");
                //DX        28 July 2021
                SLRec.Modify(TRUE);
            end else begin
                SLRec.Validate(Quantity, SLRec."Order Qty");
                SLRec.Validate("FOC Qty", 0);
                SLRec.Validate("Selling Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Unit Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                SLRec.Modify(TRUE);
            end;
        end;
    end;


    local procedure GetPriceTierForSalesAgreement_PMPCustomized(SLRec: Record "Sales Line"; var PriceListRec: Record "Pharma Sales Price")
    var
        SHRec: Record "Sales Header";
        lAllPriceListRec: Record "Pharma Sales Price";
        lCustPriceListRec: Record "Pharma Sales Price";
        lGrpPriceListRec: Record "Pharma Sales Price";
        lRetPriceListRec: Record "Pharma Sales Price";
        lLowestPrice: Decimal;    // price list identifier
        CustRec: Record Customer;
        lBoolCheckClosestTier: Boolean;
        CustNo: Code[20]; // YF 23 Aug 2021 // Logic Change Request by Richmond
    begin
        lBoolCheckClosestTier := true;

        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin     //Use Sales header because sales line posting date have no value

            // Customers and Campaign
            if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                lLowestPrice := 0;
                lAllPriceListRec.Reset();
                lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                lAllPriceListRec.SetAscending("Unit Price", true);

                lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lAllPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lAllPriceListRec."Unit Price"
                        else begin
                            if lLowestPrice > lAllPriceListRec."Unit Price" then
                                lLowestPrice := lAllPriceListRec."Unit Price";
                        end;
                    until lAllPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX     29 Aug 2021        Added all the criteria + price just to be exact.
                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lAllPriceListRec.SetAscending("Unit Price", true);
                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    //DX     29 Aug 2021
                    // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                    if lAllPriceListRec.FindFirst() then begin
                        lRetPriceListRec := lAllPriceListRec;
                        lBoolCheckClosestTier := false;
                    end;
                end;
            end;

            // Customer
            if NOT (SLQtyIsLowerThanTradeAgreement_Customer(SLRec)) then begin
                lLowestPrice := 0;
                lCustPriceListRec.Reset();
                lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                lCustPriceListRec.SetAscending("Unit Price", true);
                lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);

                // YF 23 Aug 2021 // Logic Change Request by Richmond
                // lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                if SHRec."Bill-to Customer No." <> '' then
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.")
                else
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                // YF 23 Aug 2021 // Logic Change Request by Richmond

                lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lCustPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lCustPriceListRec."Unit Price"
                        else begin
                            if lLowestPrice > lCustPriceListRec."Unit Price" then
                                lLowestPrice := lCustPriceListRec."Unit Price";
                        end;
                    until lCustPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX        30 Aug 2021     added all the criteria to be sure again.
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);

                    // YF 23 Aug 2021 // Logic Change Request by Richmond
                    // lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    if SHRec."Bill-to Customer No." <> '' then
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.")
                    else
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    // YF 23 Aug 2021 // Logic Change Request by Richmond

                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    //DX        30 Aug 2021     added all the criteria to be sure again.
                    // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                    if lCustPriceListRec.FindFirst() then begin
                        if lBoolCheckClosestTier then begin
                            lRetPriceListRec := lCustPriceListRec;
                            lBoolCheckClosestTier := false;
                        end
                        else begin
                            if lRetPriceListRec."Unit Price" > lCustPriceListRec."Unit Price" then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;
                            end;
                        end;

                    end;

                end;
            end;

            // Group
            if NOT (SLQtyIsLowerThanTradeAgreement_Group(SLRec)) then begin
                lLowestPrice := 0;

                // YF 23 Aug 2021 // Logic Change Request by Richmond
                if SHRec."Bill-to Customer No." <> '' then
                    CustNo := SHRec."Bill-to Customer No."
                else
                    CustNo := SHRec."Sell-to Customer No.";
                // YF 23 Aug 2021 // Logic Change Request by Richmond

                if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                    lGrpPriceListRec.Reset();
                    lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lGrpPriceListRec.SetAscending("Unit Price", true);
                    lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                    lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                    //DX        04 Oct 2021
                    if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                        lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                    else
                        lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    //DX        04 Oct 2021
                    //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                    lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lGrpPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lGrpPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lGrpPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                    lLowestPrice := lGrpPriceListRec."Unit Price";
                            end;
                        until lGrpPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        //DX     30 Aug 201
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                        //DX        04 Oct 2021
                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021
                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        //DX        30 Aug 201
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        if lGrpPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lGrpPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin
                                if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;

                        end;

                    end;
                end;
            end;

            // if after all the checks still no record, repeat and check next closest tier
            if lBoolCheckClosestTier then begin

                // Customers and Campaign - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                    lLowestPrice := 0;
                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lAllPriceListRec.SetAscending("Unit Price", true);

                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lAllPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lAllPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lAllPriceListRec."Unit Price" then
                                    lLowestPrice := lAllPriceListRec."Unit Price";
                            end;
                        until lAllPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        //DX        30 Aug 201
                        lAllPriceListRec.Reset();
                        lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lAllPriceListRec.SetAscending("Unit Price", true);

                        lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                        lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                        lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                        lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        //DX        30 Aug 201
                        lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                        if lAllPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lAllPriceListRec;
                            lBoolCheckClosestTier := false;
                        end;
                    end;
                end;

                // Customer - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_Customer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);

                    // YF 23 Aug 2021 // Logic Change Request by Richmond
                    // lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    if SHRec."Bill-to Customer No." <> '' then
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.")
                    else
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    // YF 23 Aug 2021 // Logic Change Request by Richmond	

                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lCustPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lCustPriceListRec."Unit Price" then
                                    lLowestPrice := lCustPriceListRec."Unit Price";
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        if SHRec."Bill-to Customer No." <> '' then
                            lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.")
                        else
                            lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                        if lCustPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin
                                if lRetPriceListRec."Unit Price" > lCustPriceListRec."Unit Price" then begin
                                    lRetPriceListRec := lCustPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;
                        end;

                    end;
                end;

                // Group - Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_Group(SLRec)) then begin
                    lLowestPrice := 0;

                    // YF 23 Aug 2021 // Logic Change Request by Richmond
                    if SHRec."Bill-to Customer No." <> '' then
                        CustNo := SHRec."Bill-to Customer No."
                    else
                        CustNo := SHRec."Sell-to Customer No.";
                    // YF 23 Aug 2021 // Logic Change Request by Richmond

                    if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                        //DX        04 Oct 2021
                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021
                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lGrpPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                        lLowestPrice := lGrpPriceListRec."Unit Price";
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin
                            //DX        30 Aug 2021
                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                            // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                            //DX        04 Oct 2021
                            if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            //DX        04 Oct 2021
                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            //DX        30 Aug 2021

                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                            if lGrpPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;
                            end;

                        end;
                    end;
                end;
            end;

        end;

        PriceListRec := lRetPriceListRec; // Assign and return found price list

    end;

    local procedure SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec: Record "Sales Line"): Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check all customers and campaign
            lPriceListRec.Reset();
            lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
            lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
            lPriceListRec.SetFilter("Sales Type", '%1|%2', lPriceListRec."Sales Type"::"All Customers", lPriceListRec."Sales Type"::Campaign);
            lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            lPriceListRec.SetRange("Item No.", SLRec."No.");
            lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            //DX        28 Aug 2021
            //DX    28 Aug 2021
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                         //DX    28 Aug 2021
                                                                                         //DX        28 Aug 2021
                                                                                         // lPriceListRec.SetRange("Variant Code", SLRec."Variant Code");

            lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 18 Mar 2022

            if lPriceListRec.FindFirst() then begin
                if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                    exit(true)
                else
                    exit(false);
            end;

        end;

        exit(true);

    end;

    local procedure SLQtyIsLowerThanTradeAgreement_Customer(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer specific
            lPriceListRec.Reset();
            lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
            lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
            lPriceListRec.SetFilter("Sales Type", '%1', lPriceListRec."Sales Type"::Customer);

            // YF 23 Aug 2021 // Logic Change Request by Richmond
            // lPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            if SHRec."Bill-to Customer No." <> '' then
                lPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.")
            else
                lPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            // YF 23 Aug 2021 // Logic Change Request by Richmond	

            lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            lPriceListRec.SetRange("Item No.", SLRec."No.");
            lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            //DX        28 Aug 2021
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
            //DX        28 Aug 2021
            // lPriceListRec.SetRange("Variant Code", SLRec."Variant Code");

            lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 18 Mar 2022

            if lPriceListRec.FindFirst() then begin
                if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                    exit(true)
                else
                    exit(false);
            end;

        end;

        exit(true);

    end;

    local procedure SLQtyIsLowerThanTradeAgreement_Group(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
        CustRec: Record Customer;
        CustNo: Code[20]; // YF 23 Aug 2021 // Logic Change Request by Richmond
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer group

            // YF 23 Aug 2021 // Logic Change Request by Richmond
            if SHRec."Bill-to Customer No." <> '' then
                CustNo := SHRec."Bill-to Customer No."
            else
                CustNo := SHRec."Sell-to Customer No.";
            // YF 23 Aug 2021 // Logic Change Request by Richmond

            if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                lPriceListRec.Reset();
                lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
                lPriceListRec.SetFilter("Sales Type", '%1', lPriceListRec."Sales Type"::"Customer Price Group");
                lPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lPriceListRec.SetRange("Item No.", SLRec."No.");
                lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                //DX        28 Aug 2021
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                             //DX        28 Aug 2021
                                                                                             // lPriceListRec.SetRange("Variant Code", SLRec."Variant Code");

                lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 18 Mar 2022

                if lPriceListRec.FindFirst() then begin
                    if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                        exit(true)
                    else
                        exit(false);
                end;
            end;

        end;

        exit(true);

    end;


    // YF  03 August 2021 // For Custom PMP Sales Price List

    procedure IsWarehouseReq(LocCode: Code[20]): Boolean
    var
        LocRec: Record Location;
    begin
        LocRec.reset;
        LocRec.SetRange(Code, LocCode);
        if LocRec.FindFirst() then begin
            if locrec."Require Put-away" = true then
                exit(true)
            else
                exit(false);
        end;

    end;


    // YF 12 Jan 2022
    procedure HandlePriceChangeV3(ItemCode: Code[20]; CurrencyCode: Code[20]; VariantCode: Code[20]; UOMCode: Code[20]; OriginalCostPrice: Decimal; NewPurchasePrice: Decimal; NewMarkupPercent: Decimal; NewStartDate: Date): Boolean
    var
        SalesPriceListRec: Record "Pharma Sales Price";
        SalesPriceChangeStage: Record "Sales Price Change Staging";
        RecordsAdded: Boolean;
        CustRec: Record customer; //DX     31 Jan 2025
        Dateform: text[20];
    begin
        RecordsAdded := false;

        // find affected sales prices
        SalesPriceListRec.Reset;
        SalesPriceListRec.SetRange("Item No.", ItemCode);
        SalesPriceListRec.SetRange("Currency Code", CurrencyCode);
        SalesPriceListRec.SetRange("Unit Of Measure Code", UOMCode);
        SalesPriceListRec.SetRange("Variant Code", VariantCode);
        SalesPriceListRec.SetFilter("Starting Date", '<=%1', WorkDate());
        SalesPriceListRec.SetFilter("Ending Date", '>=%1', WorkDate());
        SalesPriceListRec.SetFilter("TA Type", '%1|%2', SalesPriceListRec."TA Type"::All, SalesPriceListRec."TA Type"::Wellaway); // YF 18 Mar 2022
        //DX        02 June 2025
        SalesPriceListRec.SetRange(Status, SalesPriceListRec.Status::Active);
        //DX        02 June 2025
        if SalesPriceListRec.FindSet() then
            repeat
                if SalesPriceListRec."Sales Type" = SalesPriceListRec."Sales Type"::Customer then begin
                    CustRec.reset;
                    CustRec.SetLoadFields("No.", I9G_PriceExtLeadTime, "Customer Status");
                    CustRec.SetRange("No.", SalesPriceListRec."Sales Code");
                    if CustRec.FindFirst() then begin   //DX        31 Jan 2025     Only modify customer price lists who are active status
                        if CustRec."Customer Status" = CustRec."Customer Status"::Active then begin
                            // duplicate sales price record to staging
                            SalesPriceChangeStage.Reset;
                            SalesPriceChangeStage.Init();
                            SalesPriceChangeStage."Entry No." := 0;
                            SalesPriceChangeStage."Item No." := SalesPriceListRec."Item No.";
                            SalesPriceChangeStage."Sales Type" := SalesPriceListRec."Sales Type";
                            SalesPriceChangeStage."Sales Code" := SalesPriceListRec."Sales Code";
                            SalesPriceChangeStage."Currency Code" := SalesPriceListRec."Currency Code";
                            SalesPriceChangeStage."Starting Date" := SalesPriceListRec."Starting Date";
                            SalesPriceChangeStage."Minimum Quantity" := SalesPriceListRec."Minimum Quantity";
                            SalesPriceChangeStage."Unit Of Measure Code" := SalesPriceListRec."Unit Of Measure Code";
                            SalesPriceChangeStage."Variant Code" := SalesPriceListRec."Variant Code";
                            SalesPriceChangeStage."FOC Qty" := SalesPriceListRec."FOC Qty";
                            SalesPriceChangeStage."Ending Date" := SalesPriceListRec."Ending Date";
                            SalesPriceChangeStage."Original Cost Price" := OriginalCostPrice;
                            SalesPriceChangeStage."New Cost Price" := NewPurchasePrice;
                            SalesPriceChangeStage."Markup Percent" := NewMarkupPercent;
                            SalesPriceChangeStage."Original Selling Price" := SalesPriceListRec."Unit Price";
                            // SalesPriceChangeStage."Suggested Selling Price" := ((SalesPriceListRec."Unit Price" * SalesPriceListRec."Minimum Quantity") / (SalesPriceListRec."Minimum Quantity" + SalesPriceListRec."FOC Qty")) * ((SalesPriceChangeStage."Markup Percent" + 100) / 100); // YF 20 Nov 2021
                            // SalesPriceChangeStage."Suggested Selling Price" := ((SalesPriceListRec."Unit Price") * ((SalesPriceChangeStage."Markup Percent" + 100) / 100)); // YF 29 Nov 2021
                            SalesPriceChangeStage."Suggested Selling Price" := Round(SalesPriceListRec."Unit Price" * NewMarkupPercent, 0.1, '>'); //RL   06 Jan 2022 to round up selling price
                            SalesPriceChangeStage.Status := SalesPriceChangeStage.Status::Pending;
                            SalesPriceChangeStage."Entry Timestamp" := CurrentDateTime;

                            /* Store and compute date logic
                                Existing Price aka Existing Sales Line = Original Start Date + 1 Day | Date of Price Increase + 14 Days
                                New Price aka New Sales Line = Original Start Date | Original End Date
                                Use existing fields
                                    1. Revised Start End for Existing Price
                                    2. New Start End for New Price 
                            */

                            //SalesPriceChangeStage."Revised Price Start Date" := CalcDate('<1D>', SalesPriceChangeStage."Starting Date");
                            //SalesPriceChangeStage."Revised Price End Date" := CalcDate('<14D>', SalesPriceChangeStage."Starting Date");

                            //DX        31 Jan 2025
                            if SalesPriceListRec."Sales Type" = SalesPriceListRec."Sales Type"::Customer then begin
                                CustRec.reset;
                                //CustRec.SetLoad
                                CustRec.SetLoadFields("No.", I9G_PriceExtLeadTime);
                                CustRec.SetRange("No.", SalesPriceListRec."Sales Code");
                                if CustRec.FindFirst() then begin
                                    clear(Dateform);
                                    Dateform := StrSubstNo('<%1>', CustRec.I9G_PriceExtLeadTime);
                                    //SalesPriceChangeStage."Revised Price Start Date" := CalcDate('<1D>', SalesPriceChangeStage."Starting Date");
                                    //SalesPriceChangeStage."Revised Price End Date" := CalcDate(Dateform, NewStartDate);
                                    if format(CustRec.I9G_PriceExtLeadTime) <> '' then begin
                                        SalesPriceChangeStage."Revised Price Start Date" := CalcDate(Dateform, NewStartDate);
                                        SalesPriceChangeStage."Revised Price End Date" := 21001231D;
                                        SalesPriceChangeStage."New Price Start Date" := CalcDate(Dateform, NewStartDate);
                                        SalesPriceChangeStage."New Price End Date" := 21001231D;
                                    end else begin
                                        SalesPriceChangeStage."Revised Price Start Date" := NewStartDate;
                                        SalesPriceChangeStage."Revised Price End Date" := 21001231D;
                                        SalesPriceChangeStage."New Price Start Date" := NewStartDate;
                                        SalesPriceChangeStage."New Price End Date" := 21001231D;
                                    end;

                                end;
                            end else begin
                                //DX        31 Jan 2025
                                SalesPriceChangeStage."Revised Price Start Date" := NewStartDate;
                                SalesPriceChangeStage."Revised Price End Date" := 21001231D;
                                SalesPriceChangeStage."New Price Start Date" := NewStartDate;
                                SalesPriceChangeStage."New Price End Date" := 21001231D;
                            end;


                            SalesPriceChangeStage."Requested By" := UserId; // 07 Mar 2022
                            SalesPriceChangeStage."TA Type" := SalesPriceListRec."TA Type"; // YF 18 Mar 2022
                            SalesPriceChangeStage."Find Next" := SalesPriceListRec."Find Next"; // YF 18 Mar 2022
                            SalesPriceChangeStage.Insert(true);

                            RecordsAdded := true;
                        end;

                    end;
                end else begin      //DX        31 Jan 2025      If not customer sales type, then revert to origial code
                                    // duplicate sales price record to staging
                    SalesPriceChangeStage.Reset;
                    SalesPriceChangeStage.Init();
                    SalesPriceChangeStage."Entry No." := 0;
                    SalesPriceChangeStage."Item No." := SalesPriceListRec."Item No.";
                    SalesPriceChangeStage."Sales Type" := SalesPriceListRec."Sales Type";
                    SalesPriceChangeStage."Sales Code" := SalesPriceListRec."Sales Code";
                    SalesPriceChangeStage."Currency Code" := SalesPriceListRec."Currency Code";
                    SalesPriceChangeStage."Starting Date" := SalesPriceListRec."Starting Date";
                    SalesPriceChangeStage."Minimum Quantity" := SalesPriceListRec."Minimum Quantity";
                    SalesPriceChangeStage."Unit Of Measure Code" := SalesPriceListRec."Unit Of Measure Code";
                    SalesPriceChangeStage."Variant Code" := SalesPriceListRec."Variant Code";
                    SalesPriceChangeStage."FOC Qty" := SalesPriceListRec."FOC Qty";
                    SalesPriceChangeStage."Ending Date" := SalesPriceListRec."Ending Date";
                    SalesPriceChangeStage."Original Cost Price" := OriginalCostPrice;
                    SalesPriceChangeStage."New Cost Price" := NewPurchasePrice;
                    SalesPriceChangeStage."Markup Percent" := NewMarkupPercent;
                    SalesPriceChangeStage."Original Selling Price" := SalesPriceListRec."Unit Price";
                    // SalesPriceChangeStage."Suggested Selling Price" := ((SalesPriceListRec."Unit Price" * SalesPriceListRec."Minimum Quantity") / (SalesPriceListRec."Minimum Quantity" + SalesPriceListRec."FOC Qty")) * ((SalesPriceChangeStage."Markup Percent" + 100) / 100); // YF 20 Nov 2021
                    // SalesPriceChangeStage."Suggested Selling Price" := ((SalesPriceListRec."Unit Price") * ((SalesPriceChangeStage."Markup Percent" + 100) / 100)); // YF 29 Nov 2021
                    SalesPriceChangeStage."Suggested Selling Price" := Round(SalesPriceListRec."Unit Price" * NewMarkupPercent, 0.1, '>'); //RL   06 Jan 2022 to round up selling price
                    SalesPriceChangeStage.Status := SalesPriceChangeStage.Status::Pending;
                    SalesPriceChangeStage."Entry Timestamp" := CurrentDateTime;

                    /* Store and compute date logic
                        Existing Price aka Existing Sales Line = Original Start Date + 1 Day | Date of Price Increase + 14 Days
                        New Price aka New Sales Line = Original Start Date | Original End Date
                        Use existing fields
                            1. Revised Start End for Existing Price
                            2. New Start End for New Price 
                    */
                    // SalesPriceChangeStage."Revised Price Start Date" := CalcDate('<1D>', SalesPriceChangeStage."Starting Date");
                    // SalesPriceChangeStage."Revised Price End Date" := CalcDate('<14D>', NewStartDate);
                    // SalesPriceChangeStage."New Price Start Date" := SalesPriceChangeStage."Starting Date";
                    // SalesPriceChangeStage."New Price End Date" := SalesPriceChangeStage."Ending Date";
                    SalesPriceChangeStage."Revised Price Start Date" := NewStartDate;
                    SalesPriceChangeStage."Revised Price End Date" := SalesPriceChangeStage."Ending Date";
                    SalesPriceChangeStage."New Price Start Date" := NewStartDate;
                    SalesPriceChangeStage."New Price End Date" := SalesPriceChangeStage."Ending Date";
                    SalesPriceChangeStage."Requested By" := UserId; // 07 Mar 2022
                    SalesPriceChangeStage."TA Type" := SalesPriceListRec."TA Type"; // YF 18 Mar 2022
                    SalesPriceChangeStage."Find Next" := SalesPriceListRec."Find Next"; // YF 18 Mar 2022
                    SalesPriceChangeStage.Insert(true);
                    RecordsAdded := true;
                end;
            until SalesPriceListRec.Next() = 0;
        exit(RecordsAdded);

    end;


    procedure ProcessSuggestedSalesPriceV3(var SalesPriceStagingRecord: Record "Sales Price Change Staging"; IsApproved: Boolean)
    var
        ErrorMessage: Text;
        ExistingSalesPriceRec: Record "Pharma Sales Price";
        lrec_PharmaSalesPrice2: Record "Pharma Sales Price";
        NewSalesPriceRec: Record "Pharma Sales Price";
        lrec_Item: Record item;
        RollOutChanges2: Boolean; // YF 14 Mar 2022
        lrec_SL: Record "Sales Line" temporary;
        lrec_SL2: Record "Sales Line" temporary;
        lint_LineNo: Integer;
        CUTenant: Codeunit "Environment Information";
    begin
        // RollOutChanges2 := false; // YF 14 Mar 2022
        RollOutChanges2 := true;
        if IsApproved then begin

            SalesPriceStagingRecord.SetFilter(Status, '=%1|%2', SalesPriceStagingRecord.Status::Pending, SalesPriceStagingRecord.Status::Failed);
            // Exclude Applied records from processing


            if SalesPriceStagingRecord.FindSet() then
                repeat
                    ErrorMessage := '';

                    // YF 14 Mar 2022
                    if RollOutChanges2 then begin
                        if (SalesPriceStagingRecord."Starting Date" = 0D) And (SalesPriceStagingRecord."Ending Date" = 0D) then begin
                            // from sales rep
                            NewSalesPriceRec.Reset;

                            NewSalesPriceRec.Init();
                            NewSalesPriceRec.Validate("Item No.", SalesPriceStagingRecord."Item No.");
                            NewSalesPriceRec.Validate("Sales Type", SalesPriceStagingRecord."Sales Type");
                            NewSalesPriceRec.Validate("Sales Code", SalesPriceStagingRecord."Sales Code");
                            NewSalesPriceRec.Validate("Currency Code", SalesPriceStagingRecord."Currency Code");
                            NewSalesPriceRec.Validate("Starting Date", SalesPriceStagingRecord."New Price Start Date");
                            NewSalesPriceRec.Validate("Unit Price", SalesPriceStagingRecord."Suggested Selling Price");
                            NewSalesPriceRec.Validate("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                            NewSalesPriceRec.Validate("Ending Date", SalesPriceStagingRecord."New Price End Date"); //THOMAS - CHANGED 2.0
                            NewSalesPriceRec.Validate("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                            NewSalesPriceRec.Validate("Variant Code", SalesPriceStagingRecord."Variant Code");
                            NewSalesPriceRec.Validate("FOC Qty", SalesPriceStagingRecord."FOC Qty");
                            NewSalesPriceRec.Validate(Status, NewSalesPriceRec.Status::Active);
                            NewSalesPriceRec.Validate("TA Type", SalesPriceStagingRecord."TA Type"); // YF 18 Mar 2022
                            NewSalesPriceRec.Validate("Find Next", SalesPriceStagingRecord."Find Next"); // YF 18 Mar 2022

                            if Not NewSalesPriceRec.Insert(true) then
                                ErrorMessage := StrSubstNo('Insert of New Sales Trade Agreement Entry failed: %1', GetLastErrorText());
                        end
                        else begin
                            // continue the rest
                            // Look for existing Sales Price entry to update key

                            ExistingSalesPriceRec.Reset;
                            ExistingSalesPriceRec.SetRange("Item No.", SalesPriceStagingRecord."Item No.");
                            ExistingSalesPriceRec.SetRange("Sales Type", SalesPriceStagingRecord."Sales Type");
                            ExistingSalesPriceRec.SetRange("Sales Code", SalesPriceStagingRecord."Sales Code");
                            ExistingSalesPriceRec.SetRange("Currency Code", SalesPriceStagingRecord."Currency Code");
                            ExistingSalesPriceRec.SetRange("Starting Date", SalesPriceStagingRecord."Starting Date");
                            ExistingSalesPriceRec.SetRange("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                            ExistingSalesPriceRec.SetRange("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                            ExistingSalesPriceRec.SetRange(Status, ExistingSalesPriceRec.Status::Active);
                            ExistingSalesPriceRec.SetRange("TA Type", SalesPriceStagingRecord."TA Type"); // YF 18 Mar 2022

                            if ExistingSalesPriceRec.FindFirst() then begin

                                // if Not ExistingSalesPriceRec.Rename(SalesPriceStagingRecord."Item No.",
                                //                                     SalesPriceStagingRecord."Sales Type",
                                //                                     SalesPriceStagingRecord."Sales Code",
                                //                                     SalesPriceStagingRecord."Currency Code",
                                //                                     SalesPriceStagingRecord."Revised Price Start Date",
                                //                                     SalesPriceStagingRecord."Minimum Quantity",
                                //                                     SalesPriceStagingRecord."Unit Of Measure Code") then
                                //     Error('Update of Sales Trade Agreement Entry (Key) failed');
                                //Update the end date of existing price.    25 Jun 2025
                                If existingSalesPriceRec."Ending Date" < WorkDate() then begin   //DX        06 Jun 2025     Only update previous trade price to inactive if today < new price start date.
                                    ExistingSalesPriceRec.Status := ExistingSalesPriceRec.Status::Inactive;
                                end;
                                ExistingSalesPriceRec.Validate("Ending Date", CalcDate('<-1D>', SalesPriceStagingRecord."New Price Start Date"));
                                ExistingSalesPriceRec.Modify(FALSE);
                            end;


                            ExistingSalesPriceRec.Reset;
                            ExistingSalesPriceRec.SetRange("Item No.", SalesPriceStagingRecord."Item No.");
                            ExistingSalesPriceRec.SetRange("Sales Type", SalesPriceStagingRecord."Sales Type");
                            ExistingSalesPriceRec.SetRange("Sales Code", SalesPriceStagingRecord."Sales Code");
                            ExistingSalesPriceRec.SetRange("Currency Code", SalesPriceStagingRecord."Currency Code");
                            ExistingSalesPriceRec.SetRange("Starting Date", SalesPriceStagingRecord."Revised Price Start Date");
                            ExistingSalesPriceRec.SetRange("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                            ExistingSalesPriceRec.SetRange("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                            ExistingSalesPriceRec.SetRange(Status, ExistingSalesPriceRec.Status::Active);
                            ExistingSalesPriceRec.SetRange("TA Type", SalesPriceStagingRecord."TA Type"); // YF 18 Mar 2022

                            if ExistingSalesPriceRec.FindFirst() then begin

                                ExistingSalesPriceRec."Ending Date" := SalesPriceStagingRecord."Ending Date";
                                //DX        17 Apr 2025
                                ExistingSalesPriceRec."Unit Price" := SalesPriceStagingRecord."Suggested Selling Price";        //DX        Update selling price
                                //DX        17 Apr 2025

                                if Not ExistingSalesPriceRec.Modify(true) then
                                    ErrorMessage := StrSubstNo('Update of Sales Trade Agreement Entry failed: %1', GetLastErrorText())
                                else begin

                                end;
                            end else begin

                                // insert new sales price entry if cannot find existing record
                                NewSalesPriceRec.Reset;
                                NewSalesPriceRec.Init();
                                NewSalesPriceRec.Validate("Item No.", SalesPriceStagingRecord."Item No.");
                                NewSalesPriceRec.Validate("Sales Type", SalesPriceStagingRecord."Sales Type");
                                NewSalesPriceRec.Validate("Sales Code", SalesPriceStagingRecord."Sales Code");
                                NewSalesPriceRec.Validate("Currency Code", SalesPriceStagingRecord."Currency Code");
                                NewSalesPriceRec.Validate("Starting Date", SalesPriceStagingRecord."New Price Start Date");
                                NewSalesPriceRec.Validate("Unit Price", SalesPriceStagingRecord."Suggested Selling Price");
                                NewSalesPriceRec.Validate("Price Includes VAT", ExistingSalesPriceRec."Price Includes VAT");
                                NewSalesPriceRec.Validate("Allow Invoice Disc.", ExistingSalesPriceRec."Allow Invoice Disc.");
                                NewSalesPriceRec.Validate("Line Discount %", ExistingSalesPriceRec."Line Discount %");
                                NewSalesPriceRec.Validate("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                                NewSalesPriceRec.Validate("Ending Date", SalesPriceStagingRecord."New Price End Date"); //THOMAS - CHANGED 2.0
                                NewSalesPriceRec.Validate("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                                NewSalesPriceRec.Validate("VAT Bus. Posting Gr. (Price)", ExistingSalesPriceRec."VAT Bus. Posting Gr. (Price)");
                                NewSalesPriceRec.Validate("Allow Line Disc.", ExistingSalesPriceRec."Allow Line Disc.");
                                NewSalesPriceRec.Validate("Variant Code", SalesPriceStagingRecord."Variant Code");
                                NewSalesPriceRec.Validate("FOC Qty", SalesPriceStagingRecord."FOC Qty");
                                NewSalesPriceRec.Validate(Status, NewSalesPriceRec.Status::Active);
                                // NewSalesPriceRec.Validate(RecRefID, ExistingSalesPriceRec.RecRefID); //RL 04 May 2022
                                // NewSalesPriceRec.Validate(Remarks, ExistingSalesPriceRec.Remarks); //RL 04 May 2022

                                NewSalesPriceRec.Validate("TA Type", SalesPriceStagingRecord."TA Type"); // YF 18 Mar 2022
                                NewSalesPriceRec.Validate("Find Next", ExistingSalesPriceRec."Find Next"); // YF 18 Mar 2022

                                if Not NewSalesPriceRec.Insert(true) then
                                    ErrorMessage := StrSubstNo('Insert of New Sales Trade Agreement Entry failed: %1', GetLastErrorText());

                                //ErrorMessage := 'Original Sales Trade Agreement Entry not found';
                            end;

                        end;
                    end
                    else begin
                        // Look for existing Sales Price entry to update date

                        ExistingSalesPriceRec.Reset;
                        ExistingSalesPriceRec.SetRange("Item No.", SalesPriceStagingRecord."Item No.");
                        ExistingSalesPriceRec.SetRange("Sales Type", SalesPriceStagingRecord."Sales Type");
                        ExistingSalesPriceRec.SetRange("Sales Code", SalesPriceStagingRecord."Sales Code");
                        ExistingSalesPriceRec.SetRange("Currency Code", SalesPriceStagingRecord."Currency Code");
                        ExistingSalesPriceRec.SetRange("Starting Date", SalesPriceStagingRecord."Starting Date");
                        ExistingSalesPriceRec.SetRange("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                        ExistingSalesPriceRec.SetRange("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                        ExistingSalesPriceRec.SetRange(Status, ExistingSalesPriceRec.Status::Active);
                        ExistingSalesPriceRec.SetRange("TA Type", SalesPriceStagingRecord."TA Type"); // YF 18 Mar 2022

                        if ExistingSalesPriceRec.FindFirst() then begin

                            // if Not ExistingSalesPriceRec.Rename(SalesPriceStagingRecord."Item No.",
                            //                                     SalesPriceStagingRecord."Sales Type",
                            //                                     SalesPriceStagingRecord."Sales Code",
                            //                                     SalesPriceStagingRecord."Currency Code",
                            //                                     SalesPriceStagingRecord."Revised Price Start Date",
                            //                                     SalesPriceStagingRecord."Minimum Quantity",
                            //                                     SalesPriceStagingRecord."Unit Of Measure Code") then
                            //     Error('Update of Sales Trade Agreement Entry (Key) failed');
                            //Update the end date of existing price.    25 Jun 2025                            
                            If existingSalesPriceRec."Ending Date" < WorkDate() then begin   //DX        06 Jun 2025     Only update previous trade price to inactive if today < new price start date.
                                ExistingSalesPriceRec.Status := ExistingSalesPriceRec.Status::Inactive;
                            end;
                            ExistingSalesPriceRec.Validate("Ending Date", CalcDate('<-1D>', SalesPriceStagingRecord."New Price Start Date")); //thomas 1
                            ExistingSalesPriceRec.Modify(FALSE);
                        end;
                        //Find existing new price start date, previous was existing old starting date //thomassss
                        ExistingSalesPriceRec.Reset;
                        ExistingSalesPriceRec.SetRange("Item No.", SalesPriceStagingRecord."Item No.");
                        ExistingSalesPriceRec.SetRange("Sales Type", SalesPriceStagingRecord."Sales Type");
                        ExistingSalesPriceRec.SetRange("Sales Code", SalesPriceStagingRecord."Sales Code");
                        ExistingSalesPriceRec.SetRange("Currency Code", SalesPriceStagingRecord."Currency Code");
                        ExistingSalesPriceRec.SetRange("Starting Date", SalesPriceStagingRecord."Revised Price Start Date");
                        ExistingSalesPriceRec.SetRange("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                        ExistingSalesPriceRec.SetRange("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                        ExistingSalesPriceRec.SetRange(Status, ExistingSalesPriceRec.Status::Active);
                        ExistingSalesPriceRec.SetRange("TA Type", SalesPriceStagingRecord."TA Type"); // YF 18 Mar 2022

                        if ExistingSalesPriceRec.FindFirst() then begin
                            ExistingSalesPriceRec."Ending Date" := SalesPriceStagingRecord."Ending Date"; //thomas 1
                            //DX        17 Apr 2025
                            ExistingSalesPriceRec."Unit Price" := SalesPriceStagingRecord."Suggested Selling Price";        //DX        Update selling price
                            If existingSalesPriceRec."Ending Date" < WorkDate() then begin   //DX        06 Jun 2025     Only update previous trade price to inactive if today < new price start date.
                                ExistingSalesPriceRec.Status := ExistingSalesPriceRec.Status::Inactive;
                            end;
                            if Not ExistingSalesPriceRec.Modify(true) then
                                ErrorMessage := StrSubstNo('Update of Sales Trade Agreement Entry failed: %1', GetLastErrorText())
                            else begin
                                // insert new sales price entry
                            end;
                        end else begin
                            //DX    06 Jun 2025     Create new line (Based on discussion with PMP / Debbie)
                            NewSalesPriceRec.Reset;
                            NewSalesPriceRec.Init();
                            NewSalesPriceRec.Validate("Item No.", SalesPriceStagingRecord."Item No.");
                            NewSalesPriceRec.Validate("Sales Type", SalesPriceStagingRecord."Sales Type");
                            NewSalesPriceRec.Validate("Sales Code", SalesPriceStagingRecord."Sales Code");
                            NewSalesPriceRec.Validate("Currency Code", SalesPriceStagingRecord."Currency Code");
                            NewSalesPriceRec.Validate("Starting Date", SalesPriceStagingRecord."New Price Start Date");
                            NewSalesPriceRec.Validate("Unit Price", SalesPriceStagingRecord."Suggested Selling Price");
                            NewSalesPriceRec.Validate("Price Includes VAT", ExistingSalesPriceRec."Price Includes VAT");
                            NewSalesPriceRec.Validate("Allow Invoice Disc.", ExistingSalesPriceRec."Allow Invoice Disc.");
                            NewSalesPriceRec.Validate("Line Discount %", ExistingSalesPriceRec."Line Discount %");
                            NewSalesPriceRec.Validate("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                            NewSalesPriceRec.Validate("Ending Date", SalesPriceStagingRecord."New Price End Date"); //THOMAS - CHANGED 2.0
                            NewSalesPriceRec.Validate("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                            NewSalesPriceRec.Validate("VAT Bus. Posting Gr. (Price)", ExistingSalesPriceRec."VAT Bus. Posting Gr. (Price)");
                            NewSalesPriceRec.Validate("Allow Line Disc.", ExistingSalesPriceRec."Allow Line Disc.");
                            NewSalesPriceRec.Validate("Variant Code", SalesPriceStagingRecord."Variant Code");
                            NewSalesPriceRec.Validate("FOC Qty", SalesPriceStagingRecord."FOC Qty");
                            NewSalesPriceRec.Validate(Status, NewSalesPriceRec.Status::Active);
                            // NewSalesPriceRec.Validate(RecRefID, ExistingSalesPriceRec.RecRefID); //RL 04 May 2022
                            NewSalesPriceRec.Validate("TA Type", SalesPriceStagingRecord."TA Type"); // YF 19 Mar 2022
                            NewSalesPriceRec.Validate("Find Next", ExistingSalesPriceRec."Find Next"); // YF 19 Mar 2022
                                                                                                       // NewSalesPriceRec.Validate(Remarks, ExistingSalesPriceRec.Remarks); //RL 04 May 2022

                            if Not NewSalesPriceRec.Insert(true) then
                                ErrorMessage := StrSubstNo('Insert of New Sales Trade Agreement Entry failed: %1', GetLastErrorText())
                            else
                                ErrorMessage := 'Original Sales Trade Agreement Entry not found';
                        end;


                    end;

                    // YF 14 Mar 2022

                    // Update Sales price staging record
                    if StrLen(ErrorMessage) > 0 then
                        SalesPriceStagingRecord.Status := SalesPriceStagingRecord.Status::Failed
                    else
                        SalesPriceStagingRecord.Status := SalesPriceStagingRecord.Status::Applied;



                    SalesPriceStagingRecord."Processed By" := UserId;
                    SalesPriceStagingRecord."Processed On" := CurrentDateTime;
                    SalesPriceStagingRecord."Status Descr" := ErrorMessage;

                    SalesPriceStagingRecord.Modify(true);

                    //DX        02 Jun 2025
                    //DX        02 Jun 2025     Add email function after applying price, copied from p
                    lint_LineNo += 10000;
                    lrec_SL.Reset();
                    lrec_SL.Init();

                    if SalesPriceStagingRecord."Sales Type" = SalesPriceStagingRecord."Sales Type"::"Customer Price Group" then
                        lrec_SL."Document Type" := lrec_SL."Document Type"::"Blanket Order"
                    else
                        lrec_SL."Document Type" := lrec_SL."Document Type"::Order;

                    lrec_SL."Document No." := 'S-TRADE-A';
                    lrec_SL."Line No." := lint_LineNo;
                    lrec_SL."Sell-to Customer No." := SalesPriceStagingRecord."Sales Code";
                    lrec_SL."No." := SalesPriceStagingRecord."Item No.";
                    lrec_Item.Reset();
                    lrec_Item.SetLoadFields(Description);
                    lrec_Item.SetRange("No.", SalesPriceStagingRecord."Item No.");
                    if lrec_Item.FindFirst() then begin
                        lrec_SL.Description := lrec_Item.Description;
                    end;
                    lrec_SL.Insert();
                    // lrec_PharmaSalesPrice2.Reset();
                    // lrec_PharmaSalesPrice2.SetLoadFields("Unit Price");
                    // lrec_PharmaSalesPrice2.SetRange("Sales Type", SalesPriceStagingRecord."Sales Type");
                    // lrec_PharmaSalesPrice2.SetRange("Sales Code", SalesPriceStagingRecord."Sales Code");
                    // lrec_PharmaSalesPrice2.SetRange("Item No.", SalesPriceStagingRecord."Item No.");
                    // lrec_PharmaSalesPrice2.SetRange("Currency Code", SalesPriceStagingRecord."Currency Code");
                    // lrec_PharmaSalesPrice2.SetRange("Unit Of Measure Code", SalesPriceStagingRecord."Unit Of Measure Code");
                    // lrec_PharmaSalesPrice2.SetRange("Minimum Quantity", SalesPriceStagingRecord."Minimum Quantity");
                    // lrec_PharmaSalesPrice2.SetFilter("Ending Date", '=%1', CalcDate('-1D', SalesPriceStagingRecord."Starting Date"));
                    // lrec_PharmaSalesPrice2.SetRange("TA Type", SalesPriceStagingRecord."TA Type");
                    // lrec_PharmaSalesPrice2.SetFilter(Status, '=%1', lrec_PharmaSalesPrice2.Status::Active);
                    // if lrec_PharmaSalesPrice2.FindLast() then begin
                    //     lrec_SL."Unit Cost" := lrec_PharmaSalesPrice2."Unit Price"; //From Price.
                    // end;
                    lrec_SL."Unit Cost" := SalesPriceStagingRecord."Original Selling Price";
                    lrec_SL."Unit Price" := SalesPriceStagingRecord."Suggested Selling Price";
                    lrec_SL."Shipment Date" := SalesPriceStagingRecord."New Price Start Date";
                    lrec_SL."Unit Volume" := SalesPriceStagingRecord."Minimum Quantity";     //DX        31 Jan 2025
                    lrec_SL.Modify();

                    lrec_SL2.Reset();
                    lrec_SL2.Init();
                    lrec_SL2.TransferFields(lrec_SL);
                    lrec_SL2."Document No." := 'S-TRADE-A2';
                    lrec_SL2.Insert();


                until SalesPriceStagingRecord.Next() = 0;


            // if SalesPriceStagingRecord."Sales Type" = SalesPriceStagingRecord."Sales Type"::"Customer Price Group" then begin
            //     ProcessSendMailWithCustPriceGroup(lrec_SL, lrec_SL2)
            // end else begin
            //     // if CUTenant.IsProduction() then
            //     ProcessSendMail(SalesPriceStagingRecord, lrec_SL, lrec_SL2);
            // end;

            // if CUTenant.IsProduction() then begin
            ProcessSendMailWithCustPriceGroup(lrec_SL, lrec_SL2);
            ProcessSendMail(SalesPriceStagingRecord, lrec_SL, lrec_SL2);
            // end;

            //DX        02 Jun 2025

            Message('Selected suggested sales price applied');

        end
        else begin
            SalesPriceStagingRecord.SetFilter(Status, '=%1|%2', SalesPriceStagingRecord.Status::Pending, SalesPriceStagingRecord.Status::Failed);

            if SalesPriceStagingRecord.FindSet() then begin
                SalesPriceStagingRecord.ModifyAll(Status, SalesPriceStagingRecord.Status::Rejected);
                SalesPriceStagingRecord.ModifyAll("Processed By", UserId);
                SalesPriceStagingRecord.ModifyAll("Processed On", CurrentDateTime);
            end;

            Message('Selected suggested sales price rejected');
        end;
    end;
    // YF 12 Jan 2022

    procedure ProcessSendMail(var lrec_SalesTradeStaging: Record "Sales Price Change Staging"; var lrec_SL: Record "Sales Line"; var lrec_SL2: Record "Sales Line")
    var
        LCustRec: Record Customer;
        SSetup: Record "Sales & Receivables Setup";
        EmailToList: List of [Text];
        EmailBody: Text;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        CUTenant: Codeunit "Environment Information";
        EmailSent: Integer;
        EmailFailed: Integer;
        MessageBoxText: Text;
        MessageBoxFailText: Text;
    begin
        SSetup.Get();

        EmailSent := 0;
        EmailFailed := 0;
        Clear(MessageBoxText);
        Clear(MessageBoxFailText);

        lrec_SL.Reset();
        lrec_SL.SetRange("Document Type", lrec_SL."Document Type"::Order);
        if lrec_SL.FindSet() then begin
            repeat
                lrec_SL2.Reset();
                lrec_SL2.SetRange("Document Type", lrec_SL."Document Type");
                lrec_SL2.SetRange("Sell-to Customer No.", lrec_SL."Sell-to Customer No.");
                if lrec_SL2.FindSet() then begin

                    LCustRec.RESET;
                    if LCustRec.Get(lrec_SL."Sell-to Customer No.") then begin
                        if LCustRec.I9G_EmailonPriceChg <> '' then begin
                            Clear(EmailToList);
                            if StrPos(LCustRec.I9G_EmailonPriceChg, ';') > 0 then begin
                                EmailToList := LCustRec.I9G_EmailonPriceChg.Split(';');
                            end else begin
                                EmailToList.Add(LCustRec.I9G_EmailonPriceChg);
                            end;
                            EmailBody := SSetup.I9G_SalesTradeAgreementStaging;

                            EmailBody += '<br><br> Price Changed for Items : ';

                            repeat
                                EmailBody += '<br>' + lrec_SL2."No.";
                                EmailBody += '<br>' + lrec_SL2.Description;
                                EmailBody += '<br>  Price from : ' + format(lrec_SL2."Unit Cost");
                                EmailBody += '<br>  Price to : ' + format(lrec_SL2."Unit Price");
                                EmailBody += '<br> Effective date from ' + format(lrec_SL2."Shipment Date") + '<br>';
                                EmailBody += '<br> Minimum Quantity : ' + format(lrec_SL2."Unit Volume") + '<br>';
                                lrec_SL2.Delete();
                            until lrec_SL2.Next() = 0;

                            EmailBody += '<br><br> "This is an auto-generated email, please DO NOT REPLY. Any replies to this email will be disregarded."';

                            if CUTenant.IsProduction() then
                                EmailMessage.Create(EmailToList, 'Price Changed for Items', EmailBody, true)
                            else
                                EmailMessage.Create(EmailToList, 'Price Changed for Items (TESTING)', EmailBody, true);

                            // if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Price Change") then
                            //     Message('Failed to send email for ' + LCustRec."No." + '.')
                            // else
                            //     Message('Email Sent');

                            if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Price Change") then begin
                                MessageBoxFailText := MessageBoxFailText + 'Failed to send email for customer: ' + LCustRec."No." + '.\';

                                EmailFailed := EmailFailed + 1;
                            end else
                                EmailSent := EmailSent + 1;

                            EmailBody := '';
                        end;
                    end;
                end;

            until lrec_SL.Next() = 0;

            if (EmailSent > 0) or (EmailFailed > 0) then begin
                MessageBoxText := MessageBoxText + StrSubstNo('%1 email sent for customer.\', EmailSent);
                MessageBoxText := MessageBoxText + StrSubstNo('%1 email failed to send for customer.', EmailFailed);

                if EmailFailed > 0 then begin
                    MessageBoxText := MessageBoxText + '\' + MessageBoxFailText;
                end;

                Message(MessageBoxText);
            end;
        end;
    end;

    procedure ProcessSendMailWithCustPriceGroup(var lrec_SL: Record "Sales Line"; var lrec_SL2: Record "Sales Line")
    var
        SSetup: Record "Sales & Receivables Setup";
        EmailToList: List of [Text];
        EmailBody: Text;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        CUTenant: Codeunit "Environment Information";
        EmailSent: Integer;
        EmailFailed: Integer;
        MessageBoxText: Text;
        MessageBoxFailText: Text;
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        SSetup.Get();

        EmailSent := 0;
        EmailFailed := 0;
        Clear(MessageBoxText);
        Clear(MessageBoxFailText);

        lrec_SL.Reset();
        lrec_SL.SetRange("Document Type", lrec_SL."Document Type"::"Blanket Order");
        if lrec_SL.FindSet() then begin
            repeat
                lrec_SL2.Reset();
                lrec_SL2.SetRange("Document Type", lrec_SL."Document Type");
                lrec_SL2.SetRange("Sell-to Customer No.", lrec_SL."Sell-to Customer No.");
                if lrec_SL2.FindSet() then begin
                    CustomerPriceGroup.Reset();
                    if CustomerPriceGroup.Get(lrec_SL."Sell-to Customer No.") then begin
                        if CustomerPriceGroup.I9G_EmailonPriceChg <> '' then begin
                            Clear(EmailToList);
                            if StrPos(CustomerPriceGroup.I9G_EmailonPriceChg, ';') > 0 then begin
                                EmailToList := CustomerPriceGroup.I9G_EmailonPriceChg.Split(';');
                            end else begin
                                EmailToList.Add(CustomerPriceGroup.I9G_EmailonPriceChg);
                            end;
                            // EmailToList.Add(SSetup."Distribution Email");

                            EmailBody := SSetup.I9G_SalesTradeAgreementStaging;
                            EmailBody += '<br><br> Price Changed for Items : ';

                            repeat
                                EmailBody += '<br>' + lrec_SL2."No.";
                                EmailBody += '<br>' + lrec_SL2.Description;
                                EmailBody += '<br>  Price from : ' + format(lrec_SL2."Unit Cost");
                                EmailBody += '<br>  Price to : ' + format(lrec_SL2."Unit Price");
                                EmailBody += '<br> Effective date from ' + format(lrec_SL2."Shipment Date") + '<br>';
                                lrec_SL2.Delete();
                            until lrec_SL2.Next() = 0;

                            EmailBody += '<br><br> "This is an auto-generated email, please DO NOT REPLY. Any replies to this email will be disregarded."';

                            if CUTenant.IsProduction() then
                                EmailMessage.Create(EmailToList, 'Price Changed for Items', EmailBody, true)
                            else
                                EmailMessage.Create(EmailToList, 'Price Changed for Items (TESTING)', EmailBody, true);

                            // if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Price Change") then
                            //     Message('Failed to send email.')
                            // else
                            //     Message('Email Sent');

                            if Not Email.Send(EmailMessage, Enum::"Email Scenario"::"Price Change") then begin
                                EmailFailed := EmailFailed + 1;
                            end else
                                EmailSent := EmailSent + 1;

                            EmailBody := '';
                        end;
                    end;
                end;

            until lrec_SL.Next() = 0;

            if (EmailSent > 0) or (EmailFailed > 0) then begin
                MessageBoxText := MessageBoxText + StrSubstNo('%1 email sent for customer price group.\', EmailSent);
                MessageBoxText := MessageBoxText + StrSubstNo('%1 email failed to send for customer price group.', EmailFailed);

                Message(MessageBoxText);
            end;
        end;
    end;

    // YF  24 Feb 2022 // Revision to Custom PMP Sales Price List (Cust then Group then Others)
    procedure IsValidSalesAgreement_PMPCustomizedV2(SLRec: Record "Sales Line"): Boolean
    var
        PriceListRec: Record "Pharma Sales Price";
        SHRec: Record "Sales Header";
        CustRec: Record Customer;
        CustNo: Code[20];
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer specific (Sell-to)
            PriceListRec.Reset();
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::Customer);
            PriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PriceListRec.SetRange("Item No.", SLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
            PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
            if PriceListRec.FindFirst() then
                exit(true);

            // Check customer specific (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                PriceListRec.Reset();
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::Customer);
                PriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                PriceListRec.SetRange("Item No.", SLRec."No.");
                PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
                if PriceListRec.FindFirst() then
                    exit(true);
            end;

            // Check customer group (Sell-to)
            CustNo := SHRec."Sell-to Customer No.";

            if CustRec.Get(CustNo) then begin
                PriceListRec.Reset();
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::"Customer Price Group");
                PriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                PriceListRec.SetRange("Item No.", SLRec."No.");
                PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
                if PriceListRec.FindFirst() then
                    exit(true);
            end;

            // Check customer group (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                CustNo := SHRec."Bill-to Customer No.";

                if CustRec.Get(CustNo) then begin
                    PriceListRec.Reset();
                    PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                    PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::"Customer Price Group");
                    PriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    PriceListRec.SetRange("Item No.", SLRec."No.");
                    PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
                    if PriceListRec.FindFirst() then
                        exit(true);
                end;
            end;

            // Check all customers and campaign
            PriceListRec.Reset();
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Sales Type", '%1|%2', PriceListRec."Sales Type"::"All Customers", PriceListRec."Sales Type"::Campaign);
            PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PriceListRec.SetRange("Item No.", SLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            // PriceListRec.SetRange("Variant Code", SLRec."Variant Code");
            PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
            if PriceListRec.FindFirst() then
                exit(true);
        end;

        exit(false);

    end;

    procedure UpdateSLLineFOCQtyAndAmt_PMPCustomizedV2(var SLRec: Record "Sales Line")
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Pharma Sales Price";
        ItemRec: Record Item;
    begin
        Clear(PriceListLineRec);
        GetPriceTierForSalesAgreement_PMPCustomizedV2(SLRec, PriceListLineRec);

        if PriceListLineRec.IsEmpty then begin
            // use price from item card - last direct unit cost
            if ItemRec.Get(SLRec."No.") then begin
                SLRec.Validate(Quantity, SLRec."Order Qty");
                SLRec.Validate("FOC Qty", 0);
                SLRec.Validate("Selling Price", ItemRec."Unit Price");
                SLRec.Validate("Unit Price", ItemRec."Unit Price");
                // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end
        else begin
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (SLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15        
            AgreementQty := PriceListLineRec."Minimum Quantity";
            if FOCQty <> 0 then begin
                OrgLineAmt := PriceListLineRec."Unit Price" * SLRec."Order Qty";
                InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty" + FOCQty);
                SLRec.Validate(Quantity, SLRec."Order Qty" + FOCQty);
                SLRec.Validate("FOC Qty", FOCQty);
                SLRec.Validate("Selling Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Unit Price", InclFOCUnitPrice);
                SLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                SLRec.Validate("Qty To Deliver", SLRec."Order Qty" - SLRec."Qty Delivered");
                SLRec.validate("FOC (Qty) To Deliver", SLRec."FOC Qty" - SLRec."FOC Qty Delivered");
                SLRec.Modify(TRUE);
            end else begin
                SLRec.Validate(Quantity, SLRec."Order Qty");
                SLRec.Validate("FOC Qty", 0);
                SLRec.Validate("Selling Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Unit Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                SLRec.Modify(TRUE);
            end;
        end;
    end;

    local procedure GetPriceTierForSalesAgreement_PMPCustomizedV2(SLRec: Record "Sales Line"; var PriceListRec: Record "Pharma Sales Price")
    var
        SHRec: Record "Sales Header";
        lAllPriceListRec: Record "Pharma Sales Price";
        lCustPriceListRec: Record "Pharma Sales Price";
        lGrpPriceListRec: Record "Pharma Sales Price";
        lRetPriceListRec: Record "Pharma Sales Price";
        lLowestPrice: Decimal;    // price list identifier
        CustRec: Record Customer;
        lBoolCheckClosestTier: Boolean;
        CustNo: Code[20];
    begin
        lBoolCheckClosestTier := true;

        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin     //Use Sales header because sales line posting date have no value

            // Customer (Sell-to)
            if NOT (SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec)) then begin
                lLowestPrice := 0;
                lCustPriceListRec.Reset();
                lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                lCustPriceListRec.SetAscending("Unit Price", true);
                lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 19 Mar 2022
                lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lCustPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lCustPriceListRec."Unit Price"
                        else begin
                            if lLowestPrice > lCustPriceListRec."Unit Price" then
                                lLowestPrice := lCustPriceListRec."Unit Price";
                        end;
                    until lCustPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin

                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price", "Starting Date");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetAscending("Starting Date", false);  //RL 08 Jun 2022 - to get nearer starting date line in the event where got duplicate unit price
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 19 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                    if lCustPriceListRec.FindFirst() then begin
                        lRetPriceListRec := lCustPriceListRec;
                        lBoolCheckClosestTier := false;

                        PriceListRec := lRetPriceListRec; // Assign and return found price list
                        exit;
                    end;

                end;
            end;

            // Customer (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                // Customer (Bill-to)
                if NOT (SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 19 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lCustPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lCustPriceListRec."Unit Price" then
                                    lLowestPrice := lCustPriceListRec."Unit Price";
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin

                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price", "Starting Date");
                        // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetAscending("Starting Date", false);  //RL 08 Jun 2022 - to get nearer starting date line in the event where got duplicate unit price
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 19 Mar 2022
                        lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                        if lCustPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lCustPriceListRec;
                            lBoolCheckClosestTier := false;

                            PriceListRec := lRetPriceListRec; // Assign and return found price list
                            exit;
                        end;
                    end;
                end;
            end;


            // Group (Sell to)
            if NOT (SLQtyIsLowerThanTradeAgreement_SellToGroup(SLRec)) then begin

                lLowestPrice := 0;

                CustNo := SHRec."Sell-to Customer No.";

                if CustRec.Get(CustNo) then begin
                    lGrpPriceListRec.Reset();
                    lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lGrpPriceListRec.SetAscending("Unit Price", true);
                    lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                    lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                    //DX        04 Oct 2021
                    if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                        lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                    else
                        lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    //DX        04 Oct 2021

                    //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                    lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lGrpPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022
                    lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lGrpPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lGrpPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                    lLowestPrice := lGrpPriceListRec."Unit Price";
                            end;
                        until lGrpPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin

                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Starting Date", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetAscending("Starting Date", false);  //RL 08 Jun 2022 - to get nearer starting date line in the event where got duplicate unit price
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                        if lGrpPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lGrpPriceListRec;
                            lBoolCheckClosestTier := false;

                            PriceListRec := lRetPriceListRec; // Assign and return found price list
                            exit;
                        end;

                    end;
                end;
            end;


            // Group (Bill to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                if NOT (SLQtyIsLowerThanTradeAgreement_BillToGroup(SLRec)) then begin

                    lLowestPrice := 0;

                    CustNo := SHRec."Bill-to Customer No.";

                    if CustRec.Get(CustNo) then begin
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                        //DX        04 Oct 2021
                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021

                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022
                        // lGrpPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lGrpPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                        lLowestPrice := lGrpPriceListRec."Unit Price";
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin

                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price", "Starting Date");
                            // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetAscending("Starting Date", false);  //RL 08 Jun 2022 - to get nearer starting date line in the event where got duplicate unit price
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                            if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                            if lGrpPriceListRec.FindFirst() then begin
                                lRetPriceListRec := lGrpPriceListRec;
                                lBoolCheckClosestTier := false;

                                PriceListRec := lRetPriceListRec; // Assign and return found price list
                                exit;
                            end;

                        end;
                    end;
                end;
            end;


            // Customers and Campaign
            if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                lLowestPrice := 0;
                lAllPriceListRec.Reset();
                lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                lAllPriceListRec.SetAscending("Unit Price", true);

                lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 20 Mar 2022
                lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lAllPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lAllPriceListRec."Unit Price"
                        else begin
                            if lLowestPrice > lAllPriceListRec."Unit Price" then
                                lLowestPrice := lAllPriceListRec."Unit Price";
                        end;
                    until lAllPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin

                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price", "Starting Date");
                    lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lAllPriceListRec.SetAscending("Unit Price", true);
                    lAllPriceListRec.SetAscending("Starting Date", false);
                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 20 Mar 2022
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                    if lAllPriceListRec.FindFirst() then begin
                        lRetPriceListRec := lAllPriceListRec;
                        lBoolCheckClosestTier := false;

                        PriceListRec := lRetPriceListRec; // Assign and return found price list
                        exit;
                    end;
                end;
            end;

            // if after all the checks still no record, repeat and check next closest tier
            if lBoolCheckClosestTier then begin

                // Customer - Next Closest Tier // Sell To
                if NOT (SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 20 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lCustPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lCustPriceListRec."Unit Price" then
                                    lLowestPrice := lCustPriceListRec."Unit Price";
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 20 Mar 2022
                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                        if lCustPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lCustPriceListRec;
                            lBoolCheckClosestTier := false;

                            PriceListRec := lRetPriceListRec; // Assign and return found price list
                            exit;
                        end;

                    end;
                end;

                // Customer - Next Closest Tier // Bill To
                if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                    // Customer - Next Closest Tier // Bill To
                    if NOT (SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec)) then begin
                        lLowestPrice := 0;
                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 20 Mar 2022
                        // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                        lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lCustPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lCustPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lCustPriceListRec."Unit Price" then
                                        lLowestPrice := lCustPriceListRec."Unit Price";
                                end;
                            until lCustPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin
                            lCustPriceListRec.Reset();
                            lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                            lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lCustPriceListRec.SetAscending("Unit Price", true);
                            lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                            lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                            lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                            lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                            lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 20 Mar 2022

                            if lCustPriceListRec.FindFirst() then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;

                                PriceListRec := lRetPriceListRec; // Assign and return found price list
                                exit;
                            end;

                        end;
                    end;

                end;


                // Group - Closest Tier - Sell To
                if NOT (SLQtyIsLowerThanTradeAgreement_SellToGroup(SLRec)) then begin

                    lLowestPrice := 0;

                    CustNo := SHRec."Sell-to Customer No.";

                    if CustRec.Get(CustNo) then begin
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                        //DX        04 Oct 2021
                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021

                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lGrpPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                        lLowestPrice := lGrpPriceListRec."Unit Price";
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin

                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                            // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                            //DX        04 Oct 2021
                            if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            //DX        04 Oct 2021

                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022

                            if lGrpPriceListRec.FindFirst() then begin
                                lRetPriceListRec := lGrpPriceListRec;
                                lBoolCheckClosestTier := false;

                                PriceListRec := lRetPriceListRec; // Assign and return found price list
                                exit;
                            end;

                        end;
                    end;
                end;

                // Group - Closest Tier - Bill To
                if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                    if NOT (SLQtyIsLowerThanTradeAgreement_BillToGroup(SLRec)) then begin

                        lLowestPrice := 0;

                        CustNo := SHRec."Bill-to Customer No.";

                        if CustRec.Get(CustNo) then begin
                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                            // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                            //DX        04 Oct 2021
                            if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            //DX        04 Oct 2021

                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022

                            // find lowest price from this returned dataset cos getrangemin can't work here
                            if lGrpPriceListRec.FindSet() then
                                repeat
                                    if lLowestPrice = 0 then
                                        lLowestPrice := lGrpPriceListRec."Unit Price"
                                    else begin
                                        if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                            lLowestPrice := lGrpPriceListRec."Unit Price";
                                    end;
                                until lGrpPriceListRec.Next() = 0
                            else
                                lLowestPrice := 0;

                            if lLowestPrice <> 0 then begin

                                lGrpPriceListRec.Reset();
                                lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                                // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                                lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                                lGrpPriceListRec.SetAscending("Unit Price", true);
                                lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                                lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                                //DX        04 Oct 2021
                                if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                    lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                                else
                                    lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                                //DX        04 Oct 2021

                                //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                                lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                                lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                                lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                                lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                                lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                                lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 20 Mar 2022

                                if lGrpPriceListRec.FindFirst() then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;

                                    PriceListRec := lRetPriceListRec; // Assign and return found price list
                                    exit;
                                end;

                            end;
                        end;
                    end;
                end;


                // Customers and Campaign - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                    lLowestPrice := 0;
                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lAllPriceListRec.SetAscending("Unit Price", true);

                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 20 Mar 2022

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lAllPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lAllPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lAllPriceListRec."Unit Price" then
                                    lLowestPrice := lAllPriceListRec."Unit Price";
                            end;
                        until lAllPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin

                        lAllPriceListRec.Reset();
                        lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lAllPriceListRec.SetAscending("Unit Price", true);

                        lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                        lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                        lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                        lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 20 Mar 2022

                        if lAllPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lAllPriceListRec;
                            lBoolCheckClosestTier := false;

                            PriceListRec := lRetPriceListRec; // Assign and return found price list
                            exit;
                        end;
                    end;
                end;

            end;

        end;

        PriceListRec := lRetPriceListRec; // Assign and return found price list

    end;
    // YF  24 Feb 2022 // Revision to Custom PMP Sales Price List (Cust then Group then Others)

    // YF 28 Feb 2022
    local procedure SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer specific
            lPriceListRec.Reset();
            lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
            lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
            lPriceListRec.SetFilter("Sales Type", '%1', lPriceListRec."Sales Type"::Customer);
            lPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
            lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            lPriceListRec.SetRange("Item No.", SLRec."No.");
            lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
            // lPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
            lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 20 Mar 2022
            if lPriceListRec.FindFirst() then begin
                if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                    exit(true)
                else
                    exit(false);
            end;

        end;

        exit(true);

    end;

    local procedure SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer specific
            lPriceListRec.Reset();
            lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
            lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
            lPriceListRec.SetFilter("Sales Type", '%1', lPriceListRec."Sales Type"::Customer);
            lPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            lPriceListRec.SetRange("Item No.", SLRec."No.");
            lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
            // lPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
            lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 20 Mar 2022
            if lPriceListRec.FindFirst() then begin
                if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                    exit(true)
                else
                    exit(false);
            end;

        end;

        exit(true);

    end;
    // YF 28 Feb 2022

    // YF 01 Mar 2022
    local procedure SLQtyIsLowerThanTradeAgreement_SellToGroup(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
        CustRec: Record Customer;
        CustNo: Code[20];
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer group
            CustNo := SHRec."Sell-to Customer No.";

            if CustRec.Get(CustNo) then begin
                lPriceListRec.Reset();
                lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
                lPriceListRec.SetFilter("Sales Type", '%1', lPriceListRec."Sales Type"::"Customer Price Group");
                lPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lPriceListRec.SetRange("Item No.", SLRec."No.");
                lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 20 Mar 2022
                if lPriceListRec.FindFirst() then begin
                    if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                        exit(true)
                    else
                        exit(false);
                end;
            end;

        end;

        exit(true);

    end;

    local procedure SLQtyIsLowerThanTradeAgreement_BillToGroup(SLRec: Record "Sales Line") IsTrue: Boolean
    var
        SHRec: Record "Sales Header";
        lPriceListRec: Record "Pharma Sales Price";
        CustRec: Record Customer;
        CustNo: Code[20];
    begin
        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer group
            CustNo := SHRec."Bill-to Customer No.";

            if CustRec.Get(CustNo) then begin
                lPriceListRec.Reset();
                lPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
                lPriceListRec.SetFilter("Sales Type", '%1', lPriceListRec."Sales Type"::"Customer Price Group");
                lPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                lPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lPriceListRec.SetRange("Item No.", SLRec."No.");
                lPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                lPriceListRec.SetRange("TA Type", lPriceListRec."TA Type"::All); // YF 20 Mar 2022
                if lPriceListRec.FindFirst() then begin
                    if SLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                        exit(true)
                    else
                        exit(false);
                end;
            end;

        end;

        exit(true);

    end;
    // YF 01 Mar 2022

    // YF 03 Mar 2022
    procedure IsValidPurchaseAgreement_PMPCustomized(PLRec: Record "Purchase Line"; PurchCountryCode: Code[10]) IsValid: Boolean
    var
        PriceListRec: Record "Pharma Purchase Price";
    begin
        PriceListRec.Reset;
        PriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
        PriceListRec.SetRange(Status, PriceListRec.Status::Active);
        // PriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
        // PriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
        PriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        PriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        PriceListRec.SetRange("Item No.", PLRec."No.");

        //if StrLen(PurchCountryCode) > 0 then
        PriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

        if PriceListRec.FindFirst() then
            IsValid := true
        else
            IsValid := false;
    end;

    procedure UpdatePLLineFOCQtyAndAmt_PMPCustomized(var PLRec: Record "Purchase Line"; PurchCountryCode: Code[10])
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Pharma Purchase Price";
        ItemRec: Record Item;
        AMQ6: Decimal;
        PMPEnhacnce: Codeunit "PMP-Enhancements";
    begin
        GetPriceTierForPurchaseAgreement_PMPCustomized(PLRec, PriceListLineRec, PurchCountryCode);

        if PriceListLineRec.IsEmpty then begin
            // use price from item card - last direct unit cost
            if ItemRec.Get(PLRec."No.") then begin
                PLRec.Validate(Quantity, PLRec."Order Qty");
                PLRec.Validate("FOC Qty", 0);
                PLRec.Validate("Purchase Price", ItemRec."Last Direct Cost");
                PLRec.Validate("Direct Unit Cost", ItemRec."Last Direct Cost");
                // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end
        else begin
            //FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity") * PriceListLineRec."FOC Qty";        //If order 100 pcs, 100 /2 * 15 to get extra sets of FOC        
            AgreementQty := PriceListLineRec."Minimum Quantity";
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (PLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15    

            if FOCQty <> 0 then begin
                OrgLineAmt := PriceListLineRec."Direct Unit Cost" * PLRec."Order Qty";

                InclFOCUnitPrice := OrgLineAmt / (PLRec."Order Qty" + FOCQty);
                PLRec.Validate(Quantity, PLRec."Order Qty" + FOCQty);
                PLRec.Validate("FOC Qty", FOCQty);
                PLRec.Validate("Purchase Price", PriceListLineRec."Direct Unit Cost");
                PLRec.Validate("Direct Unit Cost", InclFOCUnitPrice);
                PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");      //DX        27 Jun 2021 : Add line discount
            end else begin          //If no FOC available
                PLRec.Validate(Quantity, PLRec."Order Qty");
                PLRec.Validate("FOC Qty", 0);
                PLRec.Validate("Purchase Price", PriceListLineRec."Direct Unit Cost");
                PLRec.Validate("Direct Unit Cost", PriceListLineRec."Direct Unit Cost");
                PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end;

        PLRec.Modify(TRUE);
    end;

    procedure GetPriceTierForPurchaseAgreement_PMPCustomized(PLRec: Record "Purchase Line"; var PriceListRec: Record "Pharma Purchase Price"; PurchCountryCode: Code[10])
    var
        lPriceListRec: Record "Pharma Purchase Price";
        lLowestPrice: Decimal;
    begin
        //Different scenarios to consider
        //eg. buy 10 FOC 1, 25 FOC 5, 50 FOC 15
        if NOT (PLQtyIsLowerThanTradeAgreement_PMPCustomized(PLRec, PurchCountryCode)) then begin
            lPriceListRec.reset;
            lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

            lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
            lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
            // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
            // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
            lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
            lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
            lPriceListRec.SetRange("Item No.", PLRec."No.");
            lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

            //if StrLen(PurchCountryCode) > 0 then
            lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

            // find lowest price from this returned dataset cos getrangemin can't work here
            if lPriceListRec.FindSet() then
                repeat
                    if lLowestPrice = 0 then
                        lLowestPrice := lPriceListRec."Direct Unit Cost"
                    else begin
                        if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                            lLowestPrice := lPriceListRec."Direct Unit Cost";
                    end;
                until lPriceListRec.Next() = 0
            else
                lLowestPrice := 0;

            // Message(Format(lLowestPrice)); // debug statement

            //If can find any tier that is below the total quantity of PL line, then return the relveant tier closest tier.
            if lLowestPrice <> 0 then begin
                //DX        29 Aug 2021     Removed current key starting date
                lPriceListRec.reset;
                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetRange("Item No.", PLRec."No.");
                lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                //DX        29 Aug 2021     Additional filters to get the correct list.

                lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);

                //if StrLen(PurchCountryCode) > 0 then
                lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

                if lPriceListRec.Find('-') then
                    PriceListRec := lPriceListRec;
            end
            else begin
                lPriceListRec.reset;
                //lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                //lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Direct Unit Cost");
                lPriceListRec.SetAscending("Minimum Quantity", false);       //Loop from highest minmum quantity first 
                lPriceListRec.SetAscending("Direct Unit Cost", true);       //Loop from lowest direct unit cost next 

                lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                lPriceListRec.SetRange("Item No.", PLRec."No.");                //Min qty : 50 pcs , PL line 100 Pcs
                lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                //DX        29 Aug 2021
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                             //DX        29 Aug 2021
                                                                                             // find lowest price from this returned dataset cos getrangemin can't work here

                //if StrLen(PurchCountryCode) > 0 then
                lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

                if lPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lPriceListRec."Direct Unit Cost"
                        else begin
                            if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                                lLowestPrice := lPriceListRec."Direct Unit Cost";
                        end;
                    until lPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX        29 Aug 2021
                    lPriceListRec.reset;
                    lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                    lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                    lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
                    lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                    // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
                    // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
                    lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                    lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
                    lPriceListRec.SetRange("Item No.", PLRec."No.");
                    lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
                    lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                 //DX        29 Aug 2021     Additional filters to get the correct list.
                    lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);

                    //if StrLen(PurchCountryCode) > 0 then
                    lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

                    if lPriceListRec.Find('-') then begin
                        PriceListRec := lPriceListRec;
                    end;
                end;
            end;
        end;

    end;

    local procedure PLQtyIsLowerThanTradeAgreement_PMPCustomized(PLRec: Record "Purchase Line"; PurchCountryCode: Code[10]) IsTrue: Boolean
    var
        lPriceListRec: Record "Pharma Purchase Price";
    begin
        lPriceListRec.reset;
        lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first 

        lPriceListRec.SetRange("Vendor No.", PLRec."Buy-from Vendor No.");
        lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
        // lPriceListRec.SetFilter("Starting Date", '<=%1', PLRec."Order Date");//LK26Aug2024 --
        // lPriceListRec.SetFilter("Ending Date", '>=%1', PLRec."Order Date");//LK26Aug2024 --
        lPriceListRec.SetFilter("Starting Date", '<=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        lPriceListRec.SetFilter("Ending Date", '>=%1', GetPurchHdrOrderDate(PLRec));//LK26Aug2024 ++
        lPriceListRec.SetRange("Item No.", PLRec."No.");
        lPriceListRec.SetRange("Unit of Measure Code", PLRec."Unit of Measure Code");
        //DX    28 Aug 2021
        lPriceListRec.SetFilter("Minimum Quantity", '<=%1', PLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                     //DX    28 Aug 2021

        //if StrLen(PurchCountryCode) > 0 then
        lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

        if lPriceListRec.FindFirst() then begin
            if PLRec."Order Qty" < lPriceListRec."Minimum Quantity" then
                exit(true)
            else
                exit(false);
        end;
    end;

    procedure GetPriceTierForPurchaseAgreement_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal; var PriceListRec: Record "Pharma Purchase Price"; PurchCountryCode: Code[10])
    var
        lPriceListRec: Record "Pharma Purchase Price";
        lLowestPrice: Decimal;
    begin
        //Different scenarios to consider
        //eg. buy 10 FOC 1, 25 FOC 5, 50 FOC 15
        if NOT (PLQtyIsLowerThanTradeAgreement_PMPCustomized(VendorNo, OrderDate, AssetNo, AssetUOM, AssetOrderQty, PurchCountryCode)) then begin
            lPriceListRec.reset;
            lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

            lPriceListRec.SetRange("Vendor No.", VendorNo);
            lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
            lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
            lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
            lPriceListRec.SetRange("Item No.", AssetNo);
            lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
            lPriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs

            //if StrLen(PurchCountryCode) > 0 then
            lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

            // find lowest price from this returned dataset cos getrangemin can't work here
            if lPriceListRec.FindSet() then
                repeat
                    if lLowestPrice = 0 then
                        lLowestPrice := lPriceListRec."Direct Unit Cost"
                    else begin
                        if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                            lLowestPrice := lPriceListRec."Direct Unit Cost";
                    end;
                until lPriceListRec.Next() = 0
            else
                lLowestPrice := 0;

            // Message(Format(lLowestPrice)); // debug statement

            //If can find any tier that is below the total quantity of PL line, then return the relveant tier closest tier.
            if lLowestPrice <> 0 then begin

                //DX        29 Aug 2021     Removed current key starting date
                lPriceListRec.reset;
                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                lPriceListRec.SetRange("Vendor No.", VendorNo);
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                lPriceListRec.SetRange("Item No.", AssetNo);
                lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
                lPriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                         //DX        29 Aug 2021     Additional filters to get the correc

                lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);
                //DX        29 Aug 2021     Additional filters to get the correct list.

                //if StrLen(PurchCountryCode) > 0 then
                lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

                lPriceListRec.Find('-');
            end
            else begin
                lPriceListRec.reset;
                //lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                //lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first

                lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Direct Unit Cost");
                lPriceListRec.SetAscending("Minimum Quantity", false);       //Loop from highest minmum quantity first 
                lPriceListRec.SetAscending("Direct Unit Cost", true);       //Loop from lowest direct unit cost next 

                lPriceListRec.SetRange("Vendor No.", VendorNo);
                lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                lPriceListRec.SetRange("Item No.", AssetNo);                //Min qty : 50 pcs , PL line 100 Pcs
                lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);

                // find lowest price from this returned dataset cos getrangemin can't work here

                //if StrLen(PurchCountryCode) > 0 then
                lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

                if lPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lPriceListRec."Direct Unit Cost"
                        else begin
                            if lLowestPrice > lPriceListRec."Direct Unit Cost" then
                                lLowestPrice := lPriceListRec."Direct Unit Cost";
                        end;
                    until lPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX        29 Aug 2021     Removed current key starting date
                    lPriceListRec.reset;
                    lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                    lPriceListRec.SetAscending("Minimum Quantity", FALSE);       //Loop from highest minmum quantity first
                    lPriceListRec.SetRange("Vendor No.", VendorNo);
                    lPriceListRec.SetRange(Status, PriceListRec.Status::Active);
                    lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
                    lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
                    lPriceListRec.SetRange("Item No.", AssetNo);
                    lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);
                    lPriceListRec.SetFilter("Minimum Quantity", '<=%1', AssetOrderQty);      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                             //DX        29 Aug 2021     Additional filters to get the correc
                    lPriceListRec.SetFilter("Direct Unit Cost", '%1', lLowestPrice);

                    //if StrLen(PurchCountryCode) > 0 then
                    lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

                    lPriceListRec.Find('-');
                end;
            end;

            // Assign and return found price list
            PriceListRec := lPriceListRec;
        end;

    end;

    local procedure PLQtyIsLowerThanTradeAgreement_PMPCustomized(VendorNo: Text; OrderDate: Date; AssetNo: Text; AssetUOM: Text; AssetOrderQty: Decimal; PurchCountryCode: Code[10]) IsTrue: Boolean
    var
        lPriceListRec: Record "Pharma Purchase Price";
    begin
        lPriceListRec.reset;
        lPriceListRec.SetCurrentKey("Item No.", "Vendor No.", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        lPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first 

        lPriceListRec.SetRange("Vendor No.", VendorNo);
        lPriceListRec.SetRange(Status, lPriceListRec.Status::Active);
        lPriceListRec.SetFilter("Starting Date", '<=%1', OrderDate);
        lPriceListRec.SetFilter("Ending Date", '>=%1', OrderDate);
        lPriceListRec.SetRange("Item No.", AssetNo);
        lPriceListRec.SetRange("Unit of Measure Code", AssetUOM);

        //if StrLen(PurchCountryCode) > 0 then
        lPriceListRec.SetRange("Country of Purchase Code", PurchCountryCode);

        if lPriceListRec.FindFirst() then begin
            if AssetOrderQty < lPriceListRec."Minimum Quantity" then
                exit(true)
            else
                exit(false);
        end;
    end;

    // YF 03 Mar 2022

    // YF 07 Mar 2022
    procedure GetText(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Text
    begin
        if Buffer.Get(Row, Col) then
            exit(Buffer."Cell Value as Text");
    end;

    procedure GetDate(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        d: Date;
        dateval: DateTime;
        datevalOnly: Date;
        ImportString: text;
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if Buffer.Get(Row, Col) then begin
            //Evaluate(D, format(Buffer."Cell Value as Text", 0, 9));

            importstring := Buffer."Cell Value as Text";
            evaluate(Day, copystr(Importstring, 7, 2));
            evaluate(Month, copystr(Importstring, 5, 2));
            evaluate(Year, copystr(Importstring, 1, 4));
            datevalOnly := DMY2DATE(Day, Month, Year);
            exit(datevalOnly);

        end;
    end;

    procedure GetDateLot(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        d: Date;
        dateval: DateTime;
        datevalOnly: Date;
        ImportString: text;
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        if Buffer.Get(Row, Col) then begin

            // importstring := Buffer."Cell Value as Text";
            // evaluate(Day, copystr(Importstring, 1, 2));
            // evaluate(Month, copystr(Importstring, 4, 3));
            // evaluate(Year, copystr(Importstring, 7, 4));
            // datevalOnly := DMY2DATE(Day, Month, Year);

            exit(datevalOnly);
        end;
    end;

    procedure GetDecimal(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Decimal
    var
        d: Decimal;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(d, Buffer."Cell Value as Text");
            exit(d);
        end;
    end;

    procedure GetCode(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Code[20]
    var
        c: Code[20];
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(c, Buffer."Cell Value as Text");
            exit(c);
        end;
    end;

    procedure GetInteger(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Integer
    var
        i: Integer;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(i, Buffer."Cell Value as Text");
            exit(i);
        end;
    end;

    procedure GetBoolean(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Boolean
    var
        b: Boolean;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(b, Buffer."Cell Value as Text");
            exit(b);
        end;
    end;

    local procedure GetLastSalesPriceStagingEntry() LastEntryNo: Integer
    var
        SalesPriceStaging: Record "Sales Price Change Staging";
    begin
        SalesPriceStaging.Reset;
        if SalesPriceStaging.Count = 0 then
            exit(1)
        else begin
            if SalesPriceStaging.FindLast() then begin
                exit(SalesPriceStaging."Entry No." + 1);
            end;
        end;
    end;

    procedure ImportSalesPriceChange()
    var
        x: Codeunit "PMP Integrations";
        Buffer: Record "Excel Buffer" temporary;
        ImportStream: InStream;
        Data: Record "Sales Price Change Staging";
        FileCU: Codeunit "File Management";
        SheetName: text;
        Ins: InStream;
        ImportCount: Integer;
        ImportFilename: Text;
        Row: Integer;
        TempBlobData: Codeunit "Temp Blob";
        LastRow: Integer;
        DialogBox: Dialog;

        HasErrors: Boolean;
        ErrorMessage: Text[50];
        CustRec: Record Customer;
        ItemRec: Record Item;
        ItemUOMRec: Record "Item Unit of Measure";
        SalesPriceRec: Record "Pharma Sales Price";

        NewPriceStartDateText: Text; // YF 17 Mar 2022
        NewPriceEndDateText: Text; // YF 17 Mar 2022
    begin
        FileCU.BLOBImport(TempBlobData, ImportFilename);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::utf8);
        SheetName := Buffer.SelectSheetsNameStream(ImportStream);

        Buffer.reset;
        Buffer.OpenBookStream(ImportStream, SheetName);
        Buffer.ReadSheet();
        if Buffer.FindLast() then
            LastRow := Buffer."Row No.";

        ImportCount := 0;

        for row := 2 to LastRow do begin

            // Customer Specific - customerno.|itemno.|UOM|minimumqty|price|FOCqty|Startdate|Enddate

            Data.Init();
            Data."Entry No." := GetLastSalesPriceStagingEntry();

            Data."Item No." := x.GetCode(Buffer, 2, Row);
            Data."Sales Type" := Data."Sales Type"::Customer;
            Data."Sales Code" := x.GetCode(Buffer, 1, Row);
            Data."Minimum Quantity" := x.GetDecimal(Buffer, 4, Row);
            Data."Unit Of Measure Code" := x.GetCode(Buffer, 3, Row);
            Data."FOC Qty" := x.GetDecimal(Buffer, 6, Row);
            Data."Suggested Selling Price" := x.GetDecimal(Buffer, 5, Row);
            Data.Status := Data.Status::Pending;
            Data."Entry Timestamp" := CurrentDateTime;

            // YF 17 Mar 2022
            NewPriceStartDateText := x.GetText(Buffer, 7, Row);
            NewPriceEndDateText := x.GetText(Buffer, 8, Row);

            if NewPriceStartDateText = '' then
                Data."New Price Start Date" := 0D
            else
                Evaluate(Data."New Price Start Date", NewPriceStartDateText);

            If NewPriceEndDateText = '' then
                Data."New Price End Date" := 0D
            else
                Evaluate(Data."New Price End Date", NewPriceEndDateText);

            // Data."New Price Start Date" := x.GetDate(Buffer, 7, Row);
            // Data."New Price End Date" := x.GetDate(Buffer, 8, Row);
            // YF 17 Mar 2022

            Data."Requested By" := UserId;

            if Data.Insert(true) then begin
                ImportCount += 1;
                HasErrors := false;
                ErrorMessage := '';

                // validate customer
                CustRec.Reset;
                if Not CustRec.Get(Data."Sales Code") then begin
                    HasErrors := true;
                    ErrorMessage := 'Customer not found';
                end;

                // validate item
                ItemRec.Reset;
                if Not ItemRec.Get(Data."Item No.") then begin
                    HasErrors := true;
                    ErrorMessage := 'Item not found';
                end;

                // validate uom
                ItemUOMRec.Reset;
                ItemUOMRec.SetRange("Item No.", Data."Item No.");
                ItemUOMRec.SetRange(Code, Data."Unit Of Measure Code");
                if not ItemUOMRec.FindFirst() then begin
                    HasErrors := true;
                    ErrorMessage := 'Item UOM not found';
                end;

                // validate min qty
                if Data."Minimum Quantity" = 0 then begin
                    HasErrors := true;
                    ErrorMessage := 'Min Qty cannot be zero';
                end;

                // validate price
                if Data."Suggested Selling Price" = 0 then begin
                    HasErrors := true;
                    ErrorMessage := 'Suggested Selling Price cannot be zero';
                end;

                // validate start and end date
                if (Data."New Price Start Date" = 0D) Or (Data."New Price End Date" = 0D) then begin
                    HasErrors := true;
                    ErrorMessage := 'Invalid dates';
                end;

                // validate conflict sales price records
                SalesPriceRec.Reset;
                SalesPriceRec.SetRange("Item No.", Data."Item No.");
                SalesPriceRec.SetRange("Sales Type", Data."Sales Type"::Customer);
                SalesPriceRec.SetRange("Sales Code", Data."Sales Code");
                SalesPriceRec.SetRange("Currency Code", Data."Currency Code");
                SalesPriceRec.SetRange("Starting Date", Data."New Price Start Date");
                SalesPriceRec.SetRange("Minimum Quantity", Data."Minimum Quantity");
                SalesPriceRec.SetRange("Unit Of Measure Code", Data."Unit Of Measure Code");
                if SalesPriceRec.FindFirst() then begin
                    HasErrors := true;
                    ErrorMessage := 'Conflict with existing sales price entry';
                end;

                if HasErrors then begin
                    Data.Status := Data.Status::Rejected;
                    Data."Status Descr" := ErrorMessage;
                    Data.Modify();
                end;

            end;

        end;

        if ImportCount <> 0 then
            Message('%1 row(s) imported.', ImportCount);
    end;

    // YF 07 Mar 2022

    // YF 21 Mar 2022
    procedure IsValidSalesAgreement_PMPCustomizedV2(SLRec: Record "Sales Line"; var FindNextFlag: Boolean): Boolean
    var
        PriceListRec: Record "Pharma Sales Price";
        SHRec: Record "Sales Header";
        CustRec: Record Customer;
        CustNo: Code[20];
    begin
        SHRec.reset;
        SHRec.SetLoadFields("Document Type", "No.", "Sell-to Customer No.", "Posting Date", "Bill-to Customer No.");       //DX        03 May 2023
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin

            // Check customer specific (Sell-to)
            PriceListRec.Reset();
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::Customer);
            PriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
            PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PriceListRec.SetRange("Item No.", SLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
            if PriceListRec.FindFirst() then begin
                FindNextFlag := PriceListRec."Find Next"; // YF 21 Mar 2022
                exit(true);
            end;

            // Check customer specific (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                PriceListRec.Reset();
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::Customer);
                PriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                PriceListRec.SetRange("Item No.", SLRec."No.");
                PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
                if PriceListRec.FindFirst() then begin
                    FindNextFlag := PriceListRec."Find Next"; // YF 21 Mar 2022
                    exit(true);
                end;
            end;

            // Check customer group (Sell-to)
            CustNo := SHRec."Sell-to Customer No.";

            if CustRec.Get(CustNo) then begin
                PriceListRec.Reset();
                PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::"Customer Price Group");
                PriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                PriceListRec.SetRange("Item No.", SLRec."No.");
                PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
                if PriceListRec.FindFirst() then begin
                    FindNextFlag := PriceListRec."Find Next"; // YF 21 Mar 2022
                    exit(true);
                end;
            end;

            // Check customer group (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                CustNo := SHRec."Bill-to Customer No.";

                if CustRec.Get(CustNo) then begin
                    PriceListRec.Reset();
                    PriceListRec.SetRange(Status, PriceListRec.Status::Active);
                    PriceListRec.SetFilter("Sales Type", '%1', PriceListRec."Sales Type"::"Customer Price Group");
                    PriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    PriceListRec.SetRange("Item No.", SLRec."No.");
                    PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
                    if PriceListRec.FindFirst() then begin
                        FindNextFlag := PriceListRec."Find Next"; // YF 21 Mar 2022
                        exit(true);
                    end;
                end;
            end;

            // Check all customers and campaign
            PriceListRec.Reset();
            PriceListRec.SetRange(Status, PriceListRec.Status::Active);
            PriceListRec.SetFilter("Sales Type", '%1|%2', PriceListRec."Sales Type"::"All Customers", PriceListRec."Sales Type"::Campaign);
            PriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
            PriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
            PriceListRec.SetRange("Item No.", SLRec."No.");
            PriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
            PriceListRec.SetRange("TA Type", PriceListRec."TA Type"::All); // YF 19 Mar 2022
            if PriceListRec.FindFirst() then begin
                FindNextFlag := PriceListRec."Find Next"; // YF 21 Mar 2022
                exit(true);
            end;
        end;

        exit(false);

    end;

    procedure UpdateSLLineFOCQtyAndAmt_PMPCustomizedV2(var SLRec: Record "Sales Line"; var FindNextFlag: Boolean)
    var
        OrgLineAmt: Decimal;
        AgreementQty: Decimal;
        InclFOCUnitPrice: Decimal;
        lPLRec: Record "Purchase Line";
        FOCQty: Decimal;
        PriceListLineRec: Record "Pharma Sales Price";
        ItemRec: Record Item;
    begin
        Clear(PriceListLineRec);

        if FindNextFlag then
            GetLowestAveragePriceForSalesAgreement_PMPCustomized(SLRec, PriceListLineRec) // YF 09 Jun 2022 // GetLowestPriceForSalesAgreement_PMPCustomizedV2(SLRec, PriceListLineRec) // Use Lowest Price Logic          
        else
            GetPriceTierForSalesAgreement_PMPCustomizedV2(SLRec, PriceListLineRec); // Use Tiered Price Logic

        if PriceListLineRec.IsEmpty then begin
            // use price from item card - last direct unit cost
            if ItemRec.Get(SLRec."No.") then begin
                SLRec.Validate(Quantity, SLRec."Order Qty");
                SLRec.Validate("FOC Qty", 0);
                SLRec.Validate("Selling Price", ItemRec."Unit Price");
                SLRec.Validate("Unit Price", ItemRec."Unit Price");
                // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
            end;
        end
        else begin
            if PriceListLineRec."Minimum Quantity" <> 0 then
                FOCQty := (SLRec."Order Qty" DIV PriceListLineRec."Minimum Quantity");    //Eg. Order 110 pcs, Min Qty 50 pcs, so 2 x 50 sets
            FOCQty := FOCQty * PriceListLineRec."FOC Qty";        //Total FOC =  2 * 15        
            AgreementQty := PriceListLineRec."Minimum Quantity";
            if FOCQty <> 0 then begin
                OrgLineAmt := PriceListLineRec."Unit Price" * SLRec."Order Qty";
                InclFOCUnitPrice := OrgLineAmt / (SLRec."Order Qty" + FOCQty);
                SLRec.Validate(Quantity, SLRec."Order Qty" + FOCQty);
                SLRec.Validate("FOC Qty", FOCQty);
                SLRec.Validate("Selling Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Unit Price", InclFOCUnitPrice);
                SLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                SLRec.Validate("Qty To Deliver", SLRec."Order Qty" - SLRec."Qty Delivered");
                SLRec.validate("FOC (Qty) To Deliver", SLRec."FOC Qty" - SLRec."FOC Qty Delivered");
                SLRec.Modify(TRUE);
            end else begin
                SLRec.Validate(Quantity, SLRec."Order Qty");
                SLRec.Validate("FOC Qty", 0);
                SLRec.Validate("Selling Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Unit Price", PriceListLineRec."Unit Price");
                SLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                SLRec.Modify(TRUE);
            end;
        end;
    end;

    local procedure GetLowestPriceForSalesAgreement_PMPCustomizedV2(SLRec: Record "Sales Line"; var PriceListRec: Record "Pharma Sales Price")
    var
        SHRec: Record "Sales Header";
        lAllPriceListRec: Record "Pharma Sales Price";
        lCustPriceListRec: Record "Pharma Sales Price";
        lGrpPriceListRec: Record "Pharma Sales Price";
        lRetPriceListRec: Record "Pharma Sales Price";
        lLowestPrice: Decimal;    // price list identifier
        CustRec: Record Customer;
        lBoolCheckClosestTier: Boolean;
        CustNo: Code[20]; // YF 23 Aug 2021 // Logic Change Request by Richmond
    begin
        lBoolCheckClosestTier := true;

        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin     //Use Sales header because sales line posting date have no value

            // Customer (Sell-to)
            if NOT (SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec)) then begin
                lLowestPrice := 0;
                lCustPriceListRec.Reset();
                lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                lCustPriceListRec.SetAscending("Unit Price", true);
                lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lCustPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lCustPriceListRec."Unit Price"
                        else begin
                            if lLowestPrice > lCustPriceListRec."Unit Price" then
                                lLowestPrice := lCustPriceListRec."Unit Price";
                        end;
                    until lCustPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin

                    lCustPriceListRec.Reset();
                    // lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                    lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                    if lCustPriceListRec.FindFirst() then begin
                        lRetPriceListRec := lCustPriceListRec;
                        lBoolCheckClosestTier := false;
                    end;

                    /*
                    if lCustPriceListRec.FindFirst() then begin
                        if lBoolCheckClosestTier then begin
                            lRetPriceListRec := lCustPriceListRec;
                            lBoolCheckClosestTier := false;
                        end
                        else begin
                            if lRetPriceListRec."Unit Price" > lCustPriceListRec."Unit Price" then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;
                            end;
                        end;
                    end;
                    */
                end;
            end;

            // Customer (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                if NOT (SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lCustPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lCustPriceListRec."Unit Price" then
                                    lLowestPrice := lCustPriceListRec."Unit Price";
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin

                        lCustPriceListRec.Reset();
                        // lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                        lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                                                                                                            // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                        lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                        if lCustPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin
                                if lRetPriceListRec."Unit Price" > lCustPriceListRec."Unit Price" then begin
                                    lRetPriceListRec := lCustPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;

                        end;

                    end;
                end;
            end;


            // Group (Sell-to)
            if NOT (SLQtyIsLowerThanTradeAgreement_SellToGroup(SLRec)) then begin
                lLowestPrice := 0;
                CustNo := SHRec."Sell-to Customer No.";

                if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                    lGrpPriceListRec.Reset();
                    lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lGrpPriceListRec.SetAscending("Unit Price", true);
                    lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                    lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                    //DX        04 Oct 2021
                    if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                        lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                    else
                        lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    //DX        04 Oct 2021
                    //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                    lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                    lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lGrpPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lGrpPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lGrpPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                    lLowestPrice := lGrpPriceListRec."Unit Price";
                            end;
                        until lGrpPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        //DX     30 Aug 201
                        lGrpPriceListRec.Reset();
                        // lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                        lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                                                                                                           // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                        //DX        04 Oct 2021
                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021
                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                        //DX        30 Aug 201
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                        if lGrpPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lGrpPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin
                                if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;

                        end;

                    end;
                end;
            end;


            // Group (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                if NOT (SLQtyIsLowerThanTradeAgreement_BillToGroup(SLRec)) then begin
                    lLowestPrice := 0;
                    CustNo := SHRec."Bill-to Customer No.";

                    if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                        //DX        04 Oct 2021
                        if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021
                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        // lGrpPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lGrpPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                        lLowestPrice := lGrpPriceListRec."Unit Price";
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin
                            //DX     30 Aug 201
                            lGrpPriceListRec.Reset();
                            // lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                            lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                                                                                                               // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                            //DX        04 Oct 2021
                            if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            //DX        04 Oct 2021
                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                            //DX        30 Aug 201
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                            if lGrpPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;

                            end;

                        end;
                    end;
                end;
            end;


            // Customers and Campaign
            if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                lLowestPrice := 0;
                lAllPriceListRec.Reset();
                lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                lAllPriceListRec.SetAscending("Unit Price", true);

                lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lAllPriceListRec.FindSet() then
                    repeat
                        if lLowestPrice = 0 then
                            lLowestPrice := lAllPriceListRec."Unit Price"
                        else begin
                            if lLowestPrice > lAllPriceListRec."Unit Price" then
                                lLowestPrice := lAllPriceListRec."Unit Price";
                        end;
                    until lAllPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin
                    //DX     29 Aug 2021        Added all the criteria + price just to be exact.
                    lAllPriceListRec.Reset();
                    // lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                    lAllPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    //DX     29 Aug 2021
                    // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);

                    lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lAllPriceListRec.SetAscending("Unit Price", true);
                    lAllPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                    /*
                    if lAllPriceListRec.FindFirst() then begin
                        lRetPriceListRec := lAllPriceListRec;
                        lBoolCheckClosestTier := false;
                    end;

                    */
                    if lGrpPriceListRec.FindFirst() then begin
                        if lBoolCheckClosestTier then begin
                            lRetPriceListRec := lGrpPriceListRec;
                            lBoolCheckClosestTier := false;
                        end
                        else begin
                            if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                lRetPriceListRec := lGrpPriceListRec;
                                lBoolCheckClosestTier := false;
                            end;
                        end;

                    end;
                end;
            end;


            // if after all the checks still no record, repeat and check next closest tier
            if lBoolCheckClosestTier then begin

                // Customer (Sell to) - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                    lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lCustPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lCustPriceListRec."Unit Price" then
                                    lLowestPrice := lCustPriceListRec."Unit Price";
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        lCustPriceListRec.Reset();
                        // lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                        lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                        if lCustPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lCustPriceListRec;
                            lBoolCheckClosestTier := false;
                        end;

                        /*
                        if lCustPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin
                                if lRetPriceListRec."Unit Price" > lCustPriceListRec."Unit Price" then begin
                                    lRetPriceListRec := lCustPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;
                        end;
                        */
                    end;
                end;

                // Customer (Bill to) - Next Closest Tier
                if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                    if NOT (SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec)) then begin
                        lLowestPrice := 0;
                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lCustPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        // lCustPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                        lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lCustPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lCustPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lCustPriceListRec."Unit Price" then
                                        lLowestPrice := lCustPriceListRec."Unit Price";
                                end;
                            until lCustPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin
                            lCustPriceListRec.Reset();
                            // lCustPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                            lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                            lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                            lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                            lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                            lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                            lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022

                            lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lCustPriceListRec.SetAscending("Unit Price", true);
                            lCustPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022                     

                            if lCustPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lCustPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    if lRetPriceListRec."Unit Price" > lCustPriceListRec."Unit Price" then begin
                                        lRetPriceListRec := lCustPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;
                            end;

                        end;
                    end;
                end;


                // Group Sell to - Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_SelltoGroup(SLRec)) then begin
                    lLowestPrice := 0;
                    CustNo := SHRec."Sell-to Customer No.";

                    if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                        // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                        lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                        //DX        04 Oct 2021
                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        //DX        04 Oct 2021
                        //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                if lLowestPrice = 0 then
                                    lLowestPrice := lGrpPriceListRec."Unit Price"
                                else begin
                                    if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                        lLowestPrice := lGrpPriceListRec."Unit Price";
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin
                            //DX        30 Aug 2021
                            lGrpPriceListRec.Reset();
                            // lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                            lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                                                                                                               // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                            //DX        04 Oct 2021
                            if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            //DX        04 Oct 2021
                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                            //DX        30 Aug 2021

                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                            if lGrpPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;
                            end;

                        end;
                    end;
                end;


                // Group Bill to - Closest Tier
                if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                    if NOT (SLQtyIsLowerThanTradeAgreement_BilltoGroup(SLRec)) then begin
                        lLowestPrice := 0;
                        CustNo := SHRec."Bill-to Customer No.";


                        if CustRec.Get(CustNo) then begin // YF 23 Aug 2021 // Logic Change Request by Richmond
                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                            // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                            lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                            //DX        04 Oct 2021
                            if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            //DX        04 Oct 2021
                            //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                            // find lowest price from this returned dataset cos getrangemin can't work here
                            if lGrpPriceListRec.FindSet() then
                                repeat
                                    if lLowestPrice = 0 then
                                        lLowestPrice := lGrpPriceListRec."Unit Price"
                                    else begin
                                        if lLowestPrice > lGrpPriceListRec."Unit Price" then
                                            lLowestPrice := lGrpPriceListRec."Unit Price";
                                    end;
                                until lGrpPriceListRec.Next() = 0
                            else
                                lLowestPrice := 0;

                            if lLowestPrice <> 0 then begin
                                //DX        30 Aug 2021
                                lGrpPriceListRec.Reset();
                                // lGrpPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                                lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022
                                                                                                                   // lGrpPriceListRec.SetAscending("Minimum Quantity", true);       //Loop from highest minmum quantity first
                                lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                                lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");
                                //DX        04 Oct 2021
                                if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                                    lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                                else
                                    lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                                //DX        04 Oct 2021
                                //lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");
                                lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                                lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                                lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                                lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                                lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                                //DX        30 Aug 2021

                                lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                                lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                                lGrpPriceListRec.SetAscending("Minimum Quantity", FALSE);
                                lGrpPriceListRec.SetAscending("Unit Price", true);
                                lGrpPriceListRec.SetAscending("Starting Date", false); // YF 09 Jun 2022

                                if lGrpPriceListRec.FindFirst() then begin
                                    if lBoolCheckClosestTier then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end
                                    else begin
                                        if lRetPriceListRec."Unit Price" > lGrpPriceListRec."Unit Price" then begin
                                            lRetPriceListRec := lGrpPriceListRec;
                                            lBoolCheckClosestTier := false;
                                        end;
                                    end;
                                end;

                            end;
                        end;
                    end;
                end;


                // Customers and Campaign - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                    lLowestPrice := 0;
                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price");
                    lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                    lAllPriceListRec.SetAscending("Unit Price", true);

                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    // lAllPriceListRec.SetRange("Variant Code", SLRec."Variant Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lAllPriceListRec.FindSet() then
                        repeat
                            if lLowestPrice = 0 then
                                lLowestPrice := lAllPriceListRec."Unit Price"
                            else begin
                                if lLowestPrice > lAllPriceListRec."Unit Price" then
                                    lLowestPrice := lAllPriceListRec."Unit Price";
                            end;
                        until lAllPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        //DX        30 Aug 201
                        lAllPriceListRec.Reset();
                        // lAllPriceListRec.SetCurrentKey("Item No.", "Sales Code", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Unit Price"); // YF 09 Jun 2022
                        lAllPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date"); // YF 09 Jun 2022

                        lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                        lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                        lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                        lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                                                                                        //DX        30 Aug 201
                        lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        lAllPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lAllPriceListRec.SetAscending("Unit Price", true);
                        lAllPriceListRec.SetAscending("Starting Date", false);

                        if lAllPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lAllPriceListRec;
                            lBoolCheckClosestTier := false;
                        end;
                    end;
                end;

            end;

        end;

        PriceListRec := lRetPriceListRec; // Assign and return found price list

    end;
    // YF 21 Mar 2022

    // YF 09 Jun 2022
    local procedure GetLowestAveragePriceForSalesAgreement_PMPCustomized(SLRec: Record "Sales Line"; var PriceListRec: Record "Pharma Sales Price")
    var
        SHRec: Record "Sales Header";
        lAllPriceListRec: Record "Pharma Sales Price";
        lCustPriceListRec: Record "Pharma Sales Price";
        lGrpPriceListRec: Record "Pharma Sales Price";
        lRetPriceListRec: Record "Pharma Sales Price";
        CustRec: Record Customer;
        lBoolCheckClosestTier: Boolean;
        CustNo: Code[20];

        // price list identifier
        lLowestPriceUnit: Decimal;
        lLowestPriceMinQty: Decimal;
        lLowestPriceFOCQty: Decimal;
        // price list identifier

        lLowestPrice: Decimal;
        lCurrRecAvgLowestPrice: Decimal;

        CurrLowestAvgPriceLinePrice: Decimal;
        CurrRecAvgPriceLinePrice: Decimal;
    begin
        lBoolCheckClosestTier := true;

        SHRec.reset;
        SHRec.SetRange("Document Type", SLRec."Document Type");
        SHRec.SetRange("No.", SLRec."Document No.");
        if SHRec.FindFirst() then begin     //Use Sales header because sales line posting date have no value

            // Customer (Sell-to)
            if NOT (SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec)) then begin
                lLowestPrice := 0;
                lCustPriceListRec.Reset();
                lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                lCustPriceListRec.SetAscending("Minimum Quantity", false);
                lCustPriceListRec.SetAscending("Unit Price", true);
                lCustPriceListRec.SetAscending("Starting Date", false);

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lCustPriceListRec.FindSet() then
                    repeat
                        // avg price = total amount / total qty
                        // avg price = (unit price*min qty) / (min qty + foc qty) 
                        // YF 10 Jun 2022
                        if (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty") = 0 then
                            lCurrRecAvgLowestPrice := lCustPriceListRec."Unit Price"
                        else
                            lCurrRecAvgLowestPrice := (lCustPriceListRec."Unit Price" * lCustPriceListRec."Minimum Quantity") / (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty");
                        // YF 10 Jun 2022

                        if lLowestPrice = 0 then begin
                            lLowestPrice := lCurrRecAvgLowestPrice;
                            lLowestPriceUnit := lCustPriceListRec."Unit Price";
                            lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                            lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                        end
                        else begin
                            if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                lLowestPrice := lCurrRecAvgLowestPrice;
                                lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                            end;
                        end;
                    until lCustPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin

                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All);
                    // lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                    lCustPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                    lCustPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                    lCustPriceListRec.SetAscending("Minimum Quantity", false);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetAscending("Starting Date", false);

                    if lCustPriceListRec.FindFirst() then begin
                        lRetPriceListRec := lCustPriceListRec;
                        lBoolCheckClosestTier := false;
                    end;
                end;
            end;

            // Customer (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                if NOT (SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All); // YF 18 Mar 2022
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    // lCustPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                    lCustPriceListRec.SetAscending("Minimum Quantity", false);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetAscending("Starting Date", false);

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat

                            // avg price = total amount / total qty
                            // avg price = (unit price*min qty) / (min qty + foc qty) 
                            // YF 10 Jun 2022
                            if (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty") = 0 then
                                lCurrRecAvgLowestPrice := lCustPriceListRec."Unit Price"
                            else
                                lCurrRecAvgLowestPrice := (lCustPriceListRec."Unit Price" * lCustPriceListRec."Minimum Quantity") / (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty");
                            // YF 10 Jun 2022

                            if lLowestPrice = 0 then begin
                                lLowestPrice := lCurrRecAvgLowestPrice;
                                lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                            end
                            else begin
                                if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                                end;
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin

                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All);
                        // lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                        lCustPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                        lCustPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                        lCustPriceListRec.SetAscending("Minimum Quantity", FALSE);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetAscending("Starting Date", false);

                        if lCustPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lCustPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin

                                // Recalculate Average Lowest Price for Return Rec 
                                CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                                // Recalculate Average Lowest Price for Current Rec
                                CurrRecAvgPriceLinePrice := (lCustPriceListRec."Unit Price" * lCustPriceListRec."Minimum Quantity") / (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty");

                                if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                    lRetPriceListRec := lCustPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;

                        end;

                    end;
                end;
            end;


            // Group (Sell-to)
            if NOT (SLQtyIsLowerThanTradeAgreement_SellToGroup(SLRec)) then begin
                lLowestPrice := 0;
                CustNo := SHRec."Sell-to Customer No.";

                if CustRec.Get(CustNo) then begin
                    lGrpPriceListRec.Reset();
                    lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                    lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                    lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                    if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                        lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                    else
                        lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                    lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                    lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);
                    lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    // lGrpPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                    lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                    lGrpPriceListRec.SetAscending("Unit Price", true);
                    lGrpPriceListRec.SetAscending("Starting Date", false);

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lGrpPriceListRec.FindSet() then
                        repeat

                            // avg price = total amount / total qty
                            // avg price = (unit price*min qty) / (min qty + foc qty) 
                            // YF 10 Jun 2022
                            if (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty") = 0 then
                                lCurrRecAvgLowestPrice := lGrpPriceListRec."Unit Price"
                            else
                                lCurrRecAvgLowestPrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");
                            // YF 10 Jun 2022

                            if lLowestPrice = 0 then begin
                                lLowestPrice := lCurrRecAvgLowestPrice;
                                lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                            end
                            else begin
                                if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                end;
                            end;

                        until lGrpPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin

                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        // lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);

                        lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                        lGrpPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                        lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetAscending("Starting Date", false);

                        if lGrpPriceListRec.FindFirst() then begin
                            if lBoolCheckClosestTier then begin
                                lRetPriceListRec := lGrpPriceListRec;
                                lBoolCheckClosestTier := false;
                            end
                            else begin
                                // Recalculate Average Lowest Price for Return Rec 
                                CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                                // Recalculate Average Lowest Price for Current Rec
                                CurrRecAvgPriceLinePrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");

                                if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end;
                            end;

                        end;

                    end;
                end;
            end;


            // Group (Bill-to)
            if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                if NOT (SLQtyIsLowerThanTradeAgreement_BillToGroup(SLRec)) then begin
                    lLowestPrice := 0;
                    CustNo := SHRec."Bill-to Customer No.";

                    if CustRec.Get(CustNo) then begin
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                        if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        // lGrpPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                        lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetAscending("Starting Date", false);

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                // avg price = total amount / total qty
                                // avg price = (unit price*min qty) / (min qty + foc qty) 
                                // YF 10 Jun 2022
                                if (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty") = 0 then
                                    lCurrRecAvgLowestPrice := lGrpPriceListRec."Unit Price"
                                else
                                    lCurrRecAvgLowestPrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");
                                // YF 10 Jun 2022

                                if lLowestPrice = 0 then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                end
                                else begin
                                    if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                        lLowestPrice := lCurrRecAvgLowestPrice;
                                        lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                        lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                        lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                    end;
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin

                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                            if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            // lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);

                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                            lGrpPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                            lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetAscending("Starting Date", false);

                            if lGrpPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    // Recalculate Average Lowest Price for Return Rec 
                                    CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                                    // Recalculate Average Lowest Price for Current Rec
                                    CurrRecAvgPriceLinePrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");

                                    if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;

                            end;

                        end;
                    end;
                end;
            end;


            // Customers and Campaign
            if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                lLowestPrice := 0;
                lAllPriceListRec.Reset();
                lAllPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All);
                lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                // lAllPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                lAllPriceListRec.SetAscending("Minimum Quantity", false);
                lAllPriceListRec.SetAscending("Unit Price", true);
                lAllPriceListRec.SetAscending("Starting Date", false);

                // find lowest price from this returned dataset cos getrangemin can't work here
                if lAllPriceListRec.FindSet() then
                    repeat
                        // avg price = total amount / total qty
                        // avg price = (unit price*min qty) / (min qty + foc qty) 
                        // YF 10 Jun 2022
                        if (lAllPriceListRec."Minimum Quantity" + lAllPriceListRec."FOC Qty") = 0 then
                            lCurrRecAvgLowestPrice := lAllPriceListRec."Unit Price"
                        else
                            lCurrRecAvgLowestPrice := (lAllPriceListRec."Unit Price" * lAllPriceListRec."Minimum Quantity") / (lAllPriceListRec."Minimum Quantity" + lAllPriceListRec."FOC Qty");
                        // YF 10 Jun 2022

                        if lLowestPrice = 0 then begin
                            lLowestPrice := lCurrRecAvgLowestPrice;
                            lLowestPriceUnit := lAllPriceListRec."Unit Price";
                            lLowestPriceMinQty := lAllPriceListRec."Minimum Quantity";
                            lLowestPriceFOCQty := lAllPriceListRec."FOC Qty";
                        end
                        else begin
                            if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                lLowestPrice := lCurrRecAvgLowestPrice;
                                lLowestPriceUnit := lAllPriceListRec."Unit Price";
                                lLowestPriceMinQty := lAllPriceListRec."Minimum Quantity";
                                lLowestPriceFOCQty := lAllPriceListRec."FOC Qty";
                            end;
                        end;

                    until lAllPriceListRec.Next() = 0
                else
                    lLowestPrice := 0;

                if lLowestPrice <> 0 then begin

                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All);
                    // lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs

                    lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                    lAllPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                    lAllPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                    lAllPriceListRec.SetAscending("Minimum Quantity", false);
                    lAllPriceListRec.SetAscending("Unit Price", true);
                    lAllPriceListRec.SetAscending("Starting Date", false);

                    if lAllPriceListRec.FindFirst() then begin
                        if lBoolCheckClosestTier then begin
                            lRetPriceListRec := lAllPriceListRec;
                            lBoolCheckClosestTier := false;
                        end
                        else begin
                            // Recalculate Average Lowest Price for Return Rec 
                            CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                            // Recalculate Average Lowest Price for Current Rec
                            CurrRecAvgPriceLinePrice := (lAllPriceListRec."Unit Price" * lAllPriceListRec."Minimum Quantity") / (lAllPriceListRec."Minimum Quantity" + lAllPriceListRec."FOC Qty");

                            if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                lRetPriceListRec := lAllPriceListRec;
                                lBoolCheckClosestTier := false;
                            end;
                        end;

                    end;
                end;
            end;


            // if after all the checks still no record, repeat and check next closest tier
            if lBoolCheckClosestTier then begin

                // Customer (Sell to) - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_SellToCustomer(SLRec)) then begin
                    lLowestPrice := 0;
                    lCustPriceListRec.Reset();
                    lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                    lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                    lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                    lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                    lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                    lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All);
                    lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    // lCustPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                    lCustPriceListRec.SetAscending("Minimum Quantity", false);
                    lCustPriceListRec.SetAscending("Unit Price", true);
                    lCustPriceListRec.SetAscending("Starting Date", false);

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lCustPriceListRec.FindSet() then
                        repeat
                            // avg price = total amount / total qty
                            // avg price = (unit price*min qty) / (min qty + foc qty) 
                            // YF 10 Jun 2022
                            if (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty") = 0 then
                                lCurrRecAvgLowestPrice := lCustPriceListRec."Unit Price"
                            else
                                lCurrRecAvgLowestPrice := (lCustPriceListRec."Unit Price" * lCustPriceListRec."Minimum Quantity") / (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty");
                            // YF 10 Jun 2022

                            if lLowestPrice = 0 then begin
                                lLowestPrice := lCurrRecAvgLowestPrice;
                                lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                            end
                            else begin
                                if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                                end;
                            end;
                        until lCustPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");
                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Sell-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        // lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All);

                        lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                        lCustPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                        lCustPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                        lCustPriceListRec.SetAscending("Minimum Quantity", false);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetAscending("Starting Date", false);

                        if lCustPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lCustPriceListRec;
                            lBoolCheckClosestTier := false;
                        end;

                    end;
                end;

                // Customer (Bill to) - Next Closest Tier
                if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                    if NOT (SLQtyIsLowerThanTradeAgreement_BillToCustomer(SLRec)) then begin
                        lLowestPrice := 0;
                        lCustPriceListRec.Reset();
                        lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                        lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                        lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                        lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                        lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                        lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All);
                        lCustPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        // lCustPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                        lCustPriceListRec.SetAscending("Minimum Quantity", false);
                        lCustPriceListRec.SetAscending("Unit Price", true);
                        lCustPriceListRec.SetAscending("Starting Date", false);

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lCustPriceListRec.FindSet() then
                            repeat
                                // avg price = total amount / total qty
                                // avg price = (unit price*min qty) / (min qty + foc qty) 
                                // YF 10 Jun 2022
                                if (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty") = 0 then
                                    lCurrRecAvgLowestPrice := lCustPriceListRec."Unit Price"
                                else
                                    lCurrRecAvgLowestPrice := (lCustPriceListRec."Unit Price" * lCustPriceListRec."Minimum Quantity") / (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty");
                                // YF 10 Jun 2022

                                if lLowestPrice = 0 then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                                end
                                else begin
                                    if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                        lLowestPrice := lCurrRecAvgLowestPrice;
                                        lLowestPriceUnit := lCustPriceListRec."Unit Price";
                                        lLowestPriceMinQty := lCustPriceListRec."Minimum Quantity";
                                        lLowestPriceFOCQty := lCustPriceListRec."FOC Qty";
                                    end;
                                end;
                            until lCustPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin
                            lCustPriceListRec.Reset();
                            lCustPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                            lCustPriceListRec.SetRange(Status, lCustPriceListRec.Status::Active);
                            lCustPriceListRec.SetFilter("Sales Type", '%1', lCustPriceListRec."Sales Type"::Customer);
                            lCustPriceListRec.SetRange("Sales Code", SHRec."Bill-to Customer No.");
                            lCustPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lCustPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lCustPriceListRec.SetRange("Item No.", SLRec."No.");
                            lCustPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            // lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lCustPriceListRec.SetRange("TA Type", lCustPriceListRec."TA Type"::All);

                            lCustPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                            lCustPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                            lCustPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                            lCustPriceListRec.SetAscending("Minimum Quantity", false);
                            lCustPriceListRec.SetAscending("Unit Price", true);
                            lCustPriceListRec.SetAscending("Starting Date", false);

                            if lCustPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lCustPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    // Recalculate Average Lowest Price for Return Rec 
                                    CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                                    // Recalculate Average Lowest Price for Current Rec
                                    CurrRecAvgPriceLinePrice := (lCustPriceListRec."Unit Price" * lCustPriceListRec."Minimum Quantity") / (lCustPriceListRec."Minimum Quantity" + lCustPriceListRec."FOC Qty");

                                    if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                        lRetPriceListRec := lCustPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;
                            end;

                        end;
                    end;
                end;


                // Group Sell to - Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_SelltoGroup(SLRec)) then begin
                    lLowestPrice := 0;
                    CustNo := SHRec."Sell-to Customer No.";

                    if CustRec.Get(CustNo) then begin
                        lGrpPriceListRec.Reset();
                        lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                        lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                        lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                        if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                            lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                        else
                            lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                        lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                        lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);
                        // lGrpPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                        lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                        lGrpPriceListRec.SetAscending("Unit Price", true);
                        lGrpPriceListRec.SetAscending("Starting Date", false);

                        // find lowest price from this returned dataset cos getrangemin can't work here
                        if lGrpPriceListRec.FindSet() then
                            repeat
                                // avg price = total amount / total qty
                                // avg price = (unit price*min qty) / (min qty + foc qty) 
                                // YF 10 Jun 2022
                                if (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty") = 0 then
                                    lCurrRecAvgLowestPrice := lGrpPriceListRec."Unit Price"
                                else
                                    lCurrRecAvgLowestPrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");
                                // YF 10 Jun 2022

                                if lLowestPrice = 0 then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                end
                                else begin
                                    if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                        lLowestPrice := lCurrRecAvgLowestPrice;
                                        lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                        lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                        lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                    end;
                                end;
                            until lGrpPriceListRec.Next() = 0
                        else
                            lLowestPrice := 0;

                        if lLowestPrice <> 0 then begin

                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                            if SHRec."Sell-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            // lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            // lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);

                            lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                            lGrpPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                            lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetAscending("Starting Date", false);

                            if lGrpPriceListRec.FindFirst() then begin
                                if lBoolCheckClosestTier then begin
                                    lRetPriceListRec := lGrpPriceListRec;
                                    lBoolCheckClosestTier := false;
                                end
                                else begin
                                    // Recalculate Average Lowest Price for Return Rec 
                                    CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                                    // Recalculate Average Lowest Price for Current Rec
                                    CurrRecAvgPriceLinePrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");

                                    if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end;
                                end;
                            end;

                        end;
                    end;
                end;


                // Group Bill to - Closest Tier
                if (SHRec."Bill-to Customer No." <> '') And (SHRec."Bill-to Customer No." <> SHRec."Sell-to Customer No.") then begin
                    if NOT (SLQtyIsLowerThanTradeAgreement_BilltoGroup(SLRec)) then begin
                        lLowestPrice := 0;
                        CustNo := SHRec."Bill-to Customer No.";

                        if CustRec.Get(CustNo) then begin
                            lGrpPriceListRec.Reset();
                            lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                            lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                            lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                            if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                                lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                            else
                                lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                            lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                            lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                            lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                            lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                            lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All);
                            // lGrpPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                            lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                            lGrpPriceListRec.SetAscending("Unit Price", true);
                            lGrpPriceListRec.SetAscending("Starting Date", false);

                            // find lowest price from this returned dataset cos getrangemin can't work here
                            if lGrpPriceListRec.FindSet() then
                                repeat
                                    // avg price = total amount / total qty
                                    // avg price = (unit price*min qty) / (min qty + foc qty) 
                                    // YF 10 Jun 2022
                                    if (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty") = 0 then
                                        lCurrRecAvgLowestPrice := lGrpPriceListRec."Unit Price"
                                    else
                                        lCurrRecAvgLowestPrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");
                                    // YF 10 Jun 2022

                                    if lLowestPrice = 0 then begin
                                        lLowestPrice := lCurrRecAvgLowestPrice;
                                        lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                        lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                        lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                    end
                                    else begin
                                        if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                            lLowestPrice := lCurrRecAvgLowestPrice;
                                            lLowestPriceUnit := lGrpPriceListRec."Unit Price";
                                            lLowestPriceMinQty := lGrpPriceListRec."Minimum Quantity";
                                            lLowestPriceFOCQty := lGrpPriceListRec."FOC Qty";
                                        end;
                                    end;
                                until lGrpPriceListRec.Next() = 0
                            else
                                lLowestPrice := 0;

                            if lLowestPrice <> 0 then begin

                                lGrpPriceListRec.Reset();
                                lGrpPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                                lGrpPriceListRec.SetRange(Status, lGrpPriceListRec.Status::Active);
                                lGrpPriceListRec.SetFilter("Sales Type", '%1', lGrpPriceListRec."Sales Type"::"Customer Price Group");

                                if SHRec."Bill-to Customer No." = 'N105PRXJ' then
                                    lGrpPriceListRec.SetRange("Sales Code", 'NTUCHQ')
                                else
                                    lGrpPriceListRec.SetRange("Sales Code", CustRec."Customer Price Group");

                                lGrpPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                                lGrpPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                                lGrpPriceListRec.SetRange("Item No.", SLRec."No.");
                                lGrpPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                                // lGrpPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                                // lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                                lGrpPriceListRec.SetRange("TA Type", lGrpPriceListRec."TA Type"::All); // YF 18 Mar 2022

                                lGrpPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                                lGrpPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                                lGrpPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                                lGrpPriceListRec.SetAscending("Minimum Quantity", false);
                                lGrpPriceListRec.SetAscending("Unit Price", true);
                                lGrpPriceListRec.SetAscending("Starting Date", false);

                                if lGrpPriceListRec.FindFirst() then begin
                                    if lBoolCheckClosestTier then begin
                                        lRetPriceListRec := lGrpPriceListRec;
                                        lBoolCheckClosestTier := false;
                                    end
                                    else begin
                                        // Recalculate Average Lowest Price for Return Rec 
                                        CurrLowestAvgPriceLinePrice := (lRetPriceListRec."Unit Price" * lRetPriceListRec."Minimum Quantity") / (lRetPriceListRec."Minimum Quantity" + lRetPriceListRec."FOC Qty");

                                        // Recalculate Average Lowest Price for Current Rec
                                        CurrRecAvgPriceLinePrice := (lGrpPriceListRec."Unit Price" * lGrpPriceListRec."Minimum Quantity") / (lGrpPriceListRec."Minimum Quantity" + lGrpPriceListRec."FOC Qty");

                                        if CurrLowestAvgPriceLinePrice > CurrRecAvgPriceLinePrice then begin
                                            lRetPriceListRec := lGrpPriceListRec;
                                            lBoolCheckClosestTier := false;
                                        end;
                                    end;
                                end;

                            end;
                        end;
                    end;
                end;


                // Customers and Campaign - Next Closest Tier
                if NOT (SLQtyIsLowerThanTradeAgreement_AllCustomers(SLRec)) then begin
                    lLowestPrice := 0;
                    lAllPriceListRec.Reset();
                    lAllPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                    lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                    lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                    lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                    lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                    lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                    lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All);
                    lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                    // lAllPriceListRec.SetFilter("Minimum Quantity", '<>0'); // YF 10 Jun 2022

                    lAllPriceListRec.SetAscending("Minimum Quantity", false);
                    lAllPriceListRec.SetAscending("Unit Price", true);
                    lAllPriceListRec.SetAscending("Starting Date", false);

                    // find lowest price from this returned dataset cos getrangemin can't work here
                    if lAllPriceListRec.FindSet() then
                        repeat
                            // avg price = total amount / total qty
                            // avg price = (unit price*min qty) / (min qty + foc qty) 
                            // YF 10 Jun 2022
                            if (lAllPriceListRec."Minimum Quantity" + lAllPriceListRec."FOC Qty") = 0 then
                                lCurrRecAvgLowestPrice := lAllPriceListRec."Unit Price"
                            else
                                lCurrRecAvgLowestPrice := (lAllPriceListRec."Unit Price" * lAllPriceListRec."Minimum Quantity") / (lAllPriceListRec."Minimum Quantity" + lAllPriceListRec."FOC Qty");
                            // YF 10 Jun 2022

                            if lLowestPrice = 0 then begin
                                lLowestPrice := lCurrRecAvgLowestPrice;
                                lLowestPriceUnit := lAllPriceListRec."Unit Price";
                                lLowestPriceMinQty := lAllPriceListRec."Minimum Quantity";
                                lLowestPriceFOCQty := lAllPriceListRec."FOC Qty";
                            end
                            else begin
                                if lLowestPrice > lCurrRecAvgLowestPrice then begin
                                    lLowestPrice := lCurrRecAvgLowestPrice;
                                    lLowestPriceUnit := lAllPriceListRec."Unit Price";
                                    lLowestPriceMinQty := lAllPriceListRec."Minimum Quantity";
                                    lLowestPriceFOCQty := lAllPriceListRec."FOC Qty";
                                end;
                            end;
                        until lAllPriceListRec.Next() = 0
                    else
                        lLowestPrice := 0;

                    if lLowestPrice <> 0 then begin
                        //DX        30 Aug 201
                        lAllPriceListRec.Reset();
                        lAllPriceListRec.SetCurrentKey("Minimum Quantity", "Unit Price", "Starting Date");

                        lAllPriceListRec.SetRange(Status, lAllPriceListRec.Status::Active);
                        lAllPriceListRec.SetFilter("Sales Type", '%1|%2', lAllPriceListRec."Sales Type"::"All Customers", lAllPriceListRec."Sales Type"::Campaign);
                        lAllPriceListRec.SetFilter("Starting Date", '<=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetFilter("Ending Date", '>=%1', SHRec."Posting Date");
                        lAllPriceListRec.SetRange("Item No.", SLRec."No.");
                        lAllPriceListRec.SetRange("Unit of Measure Code", SLRec."Unit of Measure Code");
                        // lAllPriceListRec.SetFilter("Minimum Quantity", '<=%1', SLRec."Order Qty");      //Min Qty : 20 pcs, PL Line 25 Pcs
                        // lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPrice);
                        lAllPriceListRec.SetRange("TA Type", lAllPriceListRec."TA Type"::All); // YF 18 Mar 2022

                        lAllPriceListRec.SetFilter("Unit Price", '%1', lLowestPriceUnit);
                        lAllPriceListRec.SetFilter("Minimum Quantity", '%1', lLowestPriceMinQty);
                        lAllPriceListRec.SetFilter("FOC Qty", '%1', lLowestPriceFOCQty);

                        lAllPriceListRec.SetAscending("Minimum Quantity", false);
                        lAllPriceListRec.SetAscending("Unit Price", true);
                        lAllPriceListRec.SetAscending("Starting Date", false);

                        if lAllPriceListRec.FindFirst() then begin
                            lRetPriceListRec := lAllPriceListRec;
                            lBoolCheckClosestTier := false;
                        end;
                    end;
                end;

            end;

        end;

        PriceListRec := lRetPriceListRec; // Assign and return found price list

    end;
    // YF 09 Jun 2022

    //LK26Aug2024 - change to compare Purch Header order date instead of purch line order date
    local procedure GetPurchHdrOrderDate(VAR GetPurchLine: Record "Purchase Line"): Date
    var
        PH: Record "Purchase Header";
    begin
        PH.Reset();

        if PH.get(GetPurchLine."Document Type", GetPurchLine."Document No.") then
            exit(PH."Order Date");
        exit(GetPurchLine."Order Date");
    end;
    //LK26Aug2024 
}