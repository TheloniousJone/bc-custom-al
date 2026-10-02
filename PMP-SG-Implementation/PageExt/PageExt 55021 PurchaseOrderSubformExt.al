pageextension 55021 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
                ShowMandatory = true;
                Style = Favorable;
                trigger OnValidate()
                var
                    OrgLineAmt: Decimal;
                    InclFocUnitPrice: Decimal;
                    ItemRec: Record Item;
                begin
                    if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."Order Qty" <> 0) then begin

                        // YF 03 Mar 2022
                        GetPurchCountryCode();

                        if TradeCU.IsValidPurchaseAgreement_PMPCustomized(Rec, PurchCountryCode) then begin
                            TradeCU.UpdatePLLineFOCQtyAndAmt_PMPCustomized(Rec, PurchCountryCode);
                            CurrPage.Update(true);
                        end else begin
                            // take from item card price
                            if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                                if ItemRec.Get(Rec."No.") then begin
                                    Rec.Validate(Quantity, Rec."Order Qty");
                                    Rec.Validate("FOC Qty", 0);
                                    Rec.Validate("Purchase Price", ItemRec."Last Direct Cost");
                                    Rec.Validate("Direct Unit Cost", ItemRec."Last Direct Cost");
                                    // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                                    CurrPage.Update(true);
                                end;
                            end;
                        end;
                        // YF 03 Mar 2022

                    end else begin
                        //DX        27 Jun 2021
                        Rec.Validate(Quantity, Rec."Order Qty");
                        //DX        27 Jun 2021
                    end;

                    // Pre-Customized Price List
                    /*
                    if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."Order Qty" <> 0) then begin
                        if TradeCU.IsValidPurchaseAgreement(Rec) then begin
                            TradeCU.UpdatePLLineFOCQtyAndAmt(Rec);
                            CurrPage.Update(true);
                        end else begin
                        end;
                    end else begin
                        //DX        27 Jun 2021
                        Rec.Validate(Quantity, Rec."Order Qty");
                        //DX        27 Jun 2021
                    end;
                    */
                end;
            }

            field("Purchase Price"; Rec."Purchase Price")
            {
                ApplicationArea = all;
                DecimalPlaces = 2 : 5;
                BlankZero = true;
                Style = Standard;
                trigger OnValidate()
                var
                    OrgLineAmt: Decimal;
                    InclFocUnitPrice: Decimal;
                begin

                    if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."Order Qty" <> 0) then begin

                        // YF 03 Mar 2022
                        GetPurchCountryCode();

                        if TradeCU.IsValidPurchaseAgreement_PMPCustomized(Rec, PurchCountryCode) then begin
                            TradeCU.UpdatePLLineSellPrice(Rec);
                            CurrPage.Update(true);
                        end else begin
                            TradeCU.UpdatePLLine(Rec);
                        end;
                        // YF 03 Mar 2022

                    end else begin
                        TradeCU.UpdatePLLine(Rec);
                    end;

                    // Pre-Customized Price List
                    /*
                    if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."Order Qty" <> 0) then begin
                        if TradeCU.IsValidPurchaseAgreement(Rec) then begin
                            TradeCU.UpdatePLLineSellPrice(Rec);
                            CurrPage.Update(true);
                        end else begin
                            //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                            
                            // if Rec."Purchase Price" <> 0 then begin
                            //    Rec.Validate("Direct Unit Cost", Rec."Purchase Price");
                            //    Rec.Validate(Quantity, Rec."Order Qty" + Rec."FOC Qty");
                            //    Rec.Modify(TRUE);

                            //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.                          
                            TradeCU.UpdatePLLine(Rec);
                        end;
                    end else begin
                        TradeCU.UpdatePLLine(Rec);
                    end;
                    */
                end;

            }
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
                trigger OnValidate()
                var
                    OrgLineAmt: Decimal;
                    InclFocUnitPrice: Decimal;
                begin

                    if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."Order Qty" <> 0) then begin

                        // YF 03 Mar 2022
                        GetPurchCountryCode();

                        if TradeCU.IsValidPurchaseAgreement_PMPCustomized(Rec, PurchCountryCode) then begin
                            TradeCU.UpdatePLLineFromFOCQty(Rec);
                            CurrPage.Update(true);
                        end else begin
                            TradeCU.UpdatePLLine(Rec);
                        end;
                        // YF 03 Mar 2022
                    end;

                    // Pre-Customized Price List
                    /*
                    if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."FOC Qty" <> 0) and
                        (Rec."Order Qty" <> 0) then begin
                        if TradeCU.IsValidPurchaseAgreement(Rec) then begin
                            TradeCU.UpdatePLLineFromFOCQty(Rec);
                            CurrPage.Update(true);
                        end else begin
                            TradeCU.UpdatePLLine(Rec);
                        end;
                    end;
                    */
                end;
            }

            // YF 14 Jan 2022
            field("Qty To Deliver"; Rec."Qty To Deliver")
            {
                Caption = 'Order Qty to Invoice';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    rec.Validate("Qty. to Invoice", (Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver"));
                end;
            }

            field("FOC (Qty) To Deliver"; Rec."FOC (Qty) To Deliver")
            {
                Caption = 'FOC (Qty) to Invoice';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    rec.Validate("Qty. to Invoice", (Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver"));
                end;
            }
            // YF 14 Jan 2022
            field("I9G_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Caption = 'Gen. Prod. Posting Group';
                ApplicationArea = All;
                Visible = false;
            }
            field("I9G_For Tender"; Rec."For Tender")
            {
                Caption = 'For Tender';
                ApplicationArea = All;
                Visible = false;
            }
            field("I9G_Tender Qty"; Rec."Tender Qty")
            {
                Caption = 'Tender Qty';
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("No.")
        {
            field(Status; Status)
            {
                ApplicationArea = all;
                Caption = 'Item Status';
                Editable = false;
                Style = Attention;
            }
        }
        addafter("Expected Receipt Date")
        {
            field(Principal; Rec.Principal)
            {
                ApplicationArea = all;
            }
            //DX        15 Aug 2021 
            field(">5K"; Rec.">5K")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(">300K"; Rec.">300K")
            {
                ApplicationArea = all;
                Editable = false;
            }
            // YF 02 March 2025
            field(">3 Mth"; Rec.">3 Mth Inventory")
            {
                ApplicationArea = all;
                Editable = false;
            }
            // YF 02 March 2025
            field(">6 Mth"; Rec.">6 Mth Inventory")
            {
                ApplicationArea = all;
                Editable = false;

            }
            // YF 02 March 2025
            field(AMQ3; AMQ3)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(AMQ6; AMQ6)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(CurrentOnHand; CurrentOnHand)
            {
                ApplicationArea = all;
                Editable = false;
            }
            //DX        17 Aug 2021
            field(Exchangeable; Rec.Exchangeable)
            {
                ApplicationArea = all;
            }
            //DX        17 Aug 2021
            //DX        15 Aug 2021 

            /*
            //RL 30 Dec 2021
            field("Qty. Rounding Precision"; Rec."Qty. Rounding Precision")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Qty. Rounding Precision (Base)"; Rec."Qty. Rounding Precision (Base)")
            {
                ApplicationArea = all;
                Editable = true;
            }
            //RL 30 Dec 2021
            */
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                ItemRec: Record item;
                EnhanceCU: Codeunit "PMP-Enhancements";
                PHRec: Record "Purchase Header";
                SSSetup: Record "Sales & Receivables Setup";
                ItemUOM: Record "Item Unit of Measure";
            begin
                //DX        08 Aug 2021

                if (Rec.Type = Rec.Type::Item) and
                (Rec."No." <> xRec."No.") then begin
                    ItemRec.reset;
                    ItemRec.SetRange("No.", Rec."No.");
                    if itemrec.FindFirst() then
                        Rec.Principal := ItemRec.Principal;
                    Rec.Modify(FALSE);

                    //DX        25 Aug 2021
                    PHRec.reset;
                    PHRec.SetRange("Document Type", Rec."Document Type");
                    PHRec.SetRange("No.", Rec."Document No.");
                    PHRec.SetRange("Logistics Service", false);
                    if PHRec.FindFirst() then begin
                        PMPEnhacnce.ItemIsInVendorTradeAgreement(Rec."No.", Rec."Buy-from Vendor No.")
                    end;
                    //DX        25 Aug 2021
                    //DX        26 Sept 2021
                    //DX        21 Sept 2021
                    PHRec.reset;
                    PHRec.SetRange("Document Type", Rec."Document Type");
                    PHRec.SetRange("No.", Rec."Document No.");
                    PHRec.SetRange("Logistics Service", true);
                    if PHRec.FindFirst() then begin
                        SSSetup.reset;
                        SSSetup.get;
                        if SSSetup."Def. LS Location Code" <> '' then begin
                            if Rec."Location Code" <> SSSetup."Def. LS Location COde" then begin
                                rec.Validate("Location Code", SSSetup."Def. LS Location COde");
                                Rec.Modify(TRUE);
                            end;

                        end;
                    end;
                    //DX        26 Sept 2021

                end;
                //DX        08 Aug 2021
                //RL 28 Dec 2021
                // Issue #388 : Overwrite Description with Alternate descr from Item UOM Table
                ItemUOM.Reset;
                ItemUOM.SetRange("Item No.", Rec."No.");
                ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                if ItemUOM.FindFirst() then begin
                    if StrLen(ItemUOM."Alternate Description") > 0 then begin
                        Rec.Description := ItemUOM."Alternate Description";
                        currpage.update(true);
                    end;
                end;
                //RL 28 Dec 2021

            end;
        }

        modify("Unit of Measure Code")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            var
                ItemUOM: Record "Item Unit of Measure";
                ItemRec: Record Item;
            begin
                // Issue #388 : Overwrite Description with Alternate descr from Item UOM Table
                ItemUOM.Reset;
                ItemUOM.SetRange("Item No.", Rec."No.");
                ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                if ItemUOM.FindFirst() then begin
                    if StrLen(ItemUOM."Alternate Description") > 0 then
                        Rec.Description := ItemUOM."Alternate Description";
                end;
            end;
        }

        // YF 07 Dec 2021
        modify("Location Code")
        {
            ApplicationArea = All;

            trigger OnBeforeValidate()
            begin
                OrigPurchasePrice := Rec."Purchase Price"; // get original purchase price
            end;

            trigger OnAfterValidate()
            begin
                Rec.Validate("Purchase Price", OrigPurchasePrice); // replace with original purchase price
                ReValidatePurchasePrice();
            end;
        }
        // YF 07 Dec 2021

    }
    actions
    {
        addfirst("&Line")
        {
            action("Trade Agreements")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Price;
                trigger OnAction()
                var
                    myInt: Integer;
                    PricePage: page PharmaPurchasePriceList;
                    PriceRec: Record "Pharma Purchase Price";
                begin
                    PriceRec.reset;
                    Pricerec.SetRange("Item No.", Rec."No.");

                    clear(PricePage);
                    PricePage.SetTableView(PriceRec);
                    PricePage.Run();


                end;
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        AMQ6 := PMPEnhacnce.IsMoreThan6MthInv(Rec);
        AMQ3 := PMPEnhacnce.IsMoreThan3MthInv(Rec); // YF 02 March 2025


    end;

    trigger OnAfterGetRecord()
    begin
        Status := '';
        Clear(CurrentOnHand);
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin

            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then begin
                Status := ItemRec."Item Status";
                ItemRec.CalcFields(Inventory);
                CurrentOnHand := ItemRec.Inventory;
            end;

        end else begin

            Status := '';
        end;
        AMQ6 := PMPEnhacnce.IsMoreThan6MthInv(Rec);
        AMQ3 := PMPEnhacnce.IsMoreThan3MthInv(Rec); // YF 02 March 2025
        //DX        27 Jun 2021
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //DX        27 Jun 2021        
        Status := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin

            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then
                Status := ItemRec."Item Status";
        end else begin

            Status := '';
        end;

        //DX        27 Jun 2021
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //DX        27 Jun 2021
        Status := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then
                Status := ItemRec."Item Status";

        end else begin
            Status := '';
        end;
        //DX        27 Jun 2021
    end;

    local procedure ReValidatePurchasePrice()
    var
        OrgLineAmt: Decimal;
        InclFocUnitPrice: Decimal;
    begin
        if (Rec.Type = Rec.Type::Item) and
            (Rec."No." <> '') and
            (Rec."Order Qty" <> 0) then begin

            GetPurchCountryCode();

            // YF 03 Mar 2022
            if TradeCU.IsValidPurchaseAgreement_PMPCustomized(Rec, PurchCountryCode) then begin
                TradeCU.UpdatePLLineSellPrice(Rec);
                CurrPage.Update(true);
            end else begin
                TradeCU.UpdatePLLine(Rec);
            end;
            // YF 03 Mar 2022

        end else begin
            TradeCU.UpdatePLLine(Rec);
        end;
    end;

    // YF 03 Mar 2022
    local procedure GetPurchCountryCode()
    begin
        PurchCountryCode := '';
        PurchHeaderRec.Reset;
        PurchHeaderRec.SetRange("Document Type", Rec."Document Type");
        PurchHeaderRec.SetRange("No.", Rec."Document No.");
        if PurchHeaderRec.FindFirst() then
            PurchCountryCode := PurchHeaderRec."Country of Purchase Code";
    end;
    // YF 03 Mar 2022

    var
        TradeCU: Codeunit "Trade Agreement CU";
        PMPEnhacnce: Codeunit "PMP-Enhancements";
        AMQ6: Decimal;
        Status: Text[100];
        ItemRec: Record item;
        CurrentOnHand: Decimal;
        OrigPurchasePrice: Decimal; // 07 Dec 2021
        PurchCountryCode: Code[10]; // YF 03 Mar 2022
        PurchHeaderRec: Record "Purchase Header"; // YF 03 Mar 2022
        AMQ3: Decimal; // YF 02 March 2025
}
