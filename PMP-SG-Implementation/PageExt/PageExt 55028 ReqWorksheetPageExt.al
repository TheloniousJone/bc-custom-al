pageextension 55028 ReqWorksheetPageExt extends "Req. Worksheet"
{
    layout
    {
        //DX        28 Jun 2021
        // Add changes to page layout here

        addafter("No.")
        {
            field(ExprDate; ExprDate)
            {
                Caption = 'Expiration Date';
                Editable = false;
                Style = Attention;
                ApplicationArea = all;
            }
        }

        addafter("Direct Unit Cost")
        {
            // YF 17 Feb 2022
            field("Ad Hoc Entry"; Rec."Ad Hoc Entry")
            {
                ApplicationArea = All;
            }
            // YF 17 Feb 2022

            field(PurchPriceFOCQty; PurchPriceFOCQty)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'FOC Quantity';
                BlankZero = true;
            }

            field("Line Discount Percent"; Rec."Line Discount Percent")
            {
                ApplicationArea = All;
                Caption = 'Line Discount %';
            }
        }

        addafter("Location Code")
        {
            field("Min Qty"; Rec."Min Qty")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Best Tier Qty';
                Style = Attention;
            }

            field("Unit Cost Price"; Rec."Unit Cost Price")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Best Tier Unit Cost Price';
                Style = Attention;
            }

            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Best Tier FOC Qty';
                Style = Attention;
            }

            field("Revised FOC Qty"; Rec."Revised FOC Qty")
            {
                ApplicationArea = All;
                Caption = 'Revised FOC Qty';
                Style = Favorable;
                //DX        17 Aug 2021
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    if Rec."Revised FOC Qty" <> 0 then begin
                        if Rec."FOC Qty" <> 0 then
                            Error('Cannot revise FOC qty if initial FOC is 0.');
                    end;
                end;
                //DX        17 Aug 2021
            }
        }

        addafter(Control1901776201)
        {
            group(Information)
            {
                field("Item Status"; ItemStatus)
                {
                    Caption = 'Item Status';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Item Status Remarks"; ItemStatusRemarks)
                {
                    Caption = 'Item Status Remarks';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Last Purchase Date"; LastPurchDate)
                {
                    ApplicationArea = all;
                    Caption = 'Last Purchase Date';
                    Editable = false;
                }

                field("Last Direct Cost"; LastPurchPrice)
                {
                    ApplicationArea = all;
                    // Caption = 'Last Direct Cost'; // YF 12 Nov 2021
                    Caption = 'Last Purchase Price'; // YF 12 Nov 2021
                    BlankZero = true;
                    Editable = false;
                }

                field("Last Purchase Qty"; LastPurchQty)
                {
                    ApplicationArea = all;
                    Caption = 'Last Purchase Qty';
                    Editable = false;
                    BlankZero = true;
                }
                field("Last FOC Qty"; LastFOCQty)
                {
                    ApplicationArea = all;
                    Caption = 'Last FOC Qty';
                    Editable = false;
                    BlankZero = true;
                }



            }
            group(Additional)
            {

            }

        }

        modify("No.")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            begin
                if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                    ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
                end else begin
                    ExprDate := '';
                end;

                UpdateAlternateItemDescrByUOM(false); // YF 12 Nov 2021 // YF 20 Dec 2021
            end;
        }

        modify("Direct Unit Cost")
        {
            Caption = 'Purchase Cost';
            Style = Favorable;
        }

        // YF 23 Jul 2021
        modify(Quantity)
        {
            Style = Favorable;
            trigger OnAfterValidate()
            begin
                // update FOC Qty Field
                // PurchPriceFOCQty := EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity);
                // EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity, PurchPrice, PurchPriceFOCQty); // YF 30 Jul 2021
                UpdateLineVar(true);
            end;
        }
        // YF 23 Jul 2021

        //DX        29 Aug 0221
        modify("Price Calculation Method")
        {
            Visible = false;
        }
        //DX        29 Aug 0221

        // YF 06 Sep 2021 // Issue #207 - Requisition worksheet, when change vendor no., need to take the respective purchase trade agreement price and update in the line.
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateLineVar(true);
            end;
        }
        // YF 06 Sep 2021 // Issue #207 - Requisition worksheet, when change vendor no., need to take the respective purchase trade agreement price and update in the line.
        modify("Due Date")
        {
            Visible = false;
        }

        modify("Line Discount %")
        {
            ApplicationArea = All;
            Visible = false;
        }

        // YF 12 Nov 2021
        modify("Unit of Measure Code")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            begin
                UpdateAlternateItemDescrByUOM(false); // YF 12 Nov 2021 // YF 20 Dec 2021
            end;
        }
        // YF 12 Nov 2021

    }
    actions
    {
        // Add changes to page actions here
        //DX        17 Aug 2021
        addafter(Card)
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

            //DX        29 Aug 2021
            action("Clear all actions")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Price;
                trigger OnAction()
                var
                    ReqRec: Record "Requisition Line";
                begin
                    if Confirm('Are you sure you wish to clear all action messages?') then begin
                        ReqRec.reset;
                        ReqRec.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
                        ReqRec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        ReqRec."Accept Action Message" := false;
                        ReqRec.ModifyAll("Accept Action Message", false, true);
                        Message('Actions have been cleared.');
                    end;
                end;
            }

            action("Combine Req. Lines")
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
                    EnhanceCU: Codeunit "PMP-Enhancements";
                begin
                    if Confirm('Are you sure you wish combine the requisiton lines?') then begin
                        EnhanceCU.ReqWorkSheetCombination(Rec);
                        UpdateAlternateItemDescrByUOM(true); // YF 12 Nov 2021 // YF 20 Dec 2021
                    end;
                end;
            }

            //DX        29 Aug 2021
        }
        //DX        17 Aug 2021

        // YF 12 Nov 2021
        modify(CalculatePlan)
        {
            ApplicationArea = All;

            trigger OnAfterAction()
            begin
                UpdateAlternateItemDescrByUOM(true); // YF 12 Nov 2021 // YF 20 Dec 2021
            end;
        }
        // YF 12 Nov 2021
    }

    trigger OnAfterGetRecord()
    begin
        UpdateLineVar(false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateLineVar(false);
        // Rec."Revised FOC Qty" := PurchPriceFOCQty; // Set Default for Revised FOC Qty Field // YF 27 Jul 2021
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateLineVar(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateLineVar(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // PurchPriceFOCQty := EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity); // YF 27 Jul 2021
        // EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity, PurchPrice, PurchPriceFOCQty); // YF 30 Jul 2021
    end;

    procedure UpdateLineVar(SaveRecord: Boolean)
    begin

        // YF 21 Dec 2021
        /*
        if SaveRecord then
            EnhanceCU.MaintainPlanningLineOnAfterReqLineInsert(Rec);
        */
        // YF 21 Dec 2021

        // YF 17 Feb 2022
        if SaveRecord And not Rec."Ad Hoc Entry" then
            EnhanceCU.MaintainPlanningLineOnAfterReqLineInsert(Rec);
        // YF 17 Feb 2022

        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
            ItemRec.reset;
            ItemRec.SetLoadFields("No.", "Item Status", "Status Remarks", Inventory, "Qty. on Sales Order", "Location Filter");     //DX        24 May 2023
            ItemRec.get(Rec."No.");
            ItemStatus := ItemRec."Item Status";
            ItemStatusRemarks := ItemRec."Status Remarks";
            LastPurchQty := EnhanceCU.GetLastItemPurchaseQuantity(Rec."No.");
            LastPurchDate := EnhanceCU.GetLastPurchaseDate(Rec."No.");

            //DX        17 Aug 2021
            LastFOCQty := EnhanceCU.GetLastItemPurchaseFOCQuantity(Rec."No.");
            //DX        17 Aug 2021

            // LastPurchPrice := ItemRec."Last Direct Cost"; // YF 12 Nov 2021
            LastPurchPrice := EnhanceCU.GetLastPurchasePrice(Rec."No."); // YF 12 Nov 2021

            //DX        08 Aug 2021
            CompInfo.reset;
            CompInfo.get;
            ItemRec.SetFilter("Location Filter", CompInfo."Location Code");
            ItemRec.CalcFields(Inventory, "Qty. on Sales Order");
            InvBal := ItemRec.Inventory;
            SOQty := ItemRec."Qty. on Sales Order";
            AvailQty := InvBal - SOQty;
            //DX        08 Aug 2021

            // PurchPriceFOCQty := EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity); // YF 23 Jul 2021
            // EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity, PurchPrice, PurchPriceFOCQty); // YF 30 Jul 2021 // YF 17 Feb 2022
            // EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", WorkDate(), Rec."No.", Rec."Unit of Measure Code", Rec.Quantity, PurchPrice, PurchPriceFOCQty); // YF 30 Jul 2021

            // YF 17 Feb 2022
            if not Rec."Ad Hoc Entry" then
                EnhanceCU.CalculatePurchPriceFOCQty_PMPCustomized(Rec."Vendor No.", Rec."Order Date", Rec."No.", Rec."Unit of Measure Code", Rec.Quantity, PurchPrice, PurchPriceFOCQty);
            // YF 17 Feb 2022

        end else begin
            ExprDate := '';
            LastPurchDate := 0D;
            LastPurchQty := 0;
            LastFOCQty := 0;
            LastPurchPrice := 0;
            ItemStatus := '';
            ItemStatusRemarks := '';
            PurchPriceFOCQty := 0;
            PurchPrice := 0;
            InvBal := 0;
        end;

        // YF 17 Feb 2022
        /*
        Rec."Direct Unit Cost" := PurchPrice;
        Rec."Revised FOC Qty" := PurchPriceFOCQty;
        */
        if not Rec."Ad Hoc Entry" then begin
            Rec."Direct Unit Cost" := PurchPrice;
            Rec."Revised FOC Qty" := PurchPriceFOCQty;
        end;
        // YF 17 Feb 2022

        // YF 21 Dec 2021
        /*
        if SaveRecord then
            Rec.Modify();
        CurrPage.Update(false);
        */
        CurrPage.Update(SaveRecord);
        // YF 21 Dec 2021

    end;
    //DX        28 Jun 2021

    // YF 12 Nov 2021 // YF 20 Dec 2021
    local procedure UpdateAlternateItemDescrByUOM(BulkUpdate: Boolean)
    var
        ItemRec: Record Item;
        ItemUOM: Record "Item Unit of Measure";
    begin
        if BulkUpdate then begin
            Commit();
            if Rec.FindSet() then
                repeat
                    // Overwrite Description with Alternate descr from Item UOM Table
                    if ItemRec.Get(Rec."No.") then
                        Rec.Description := ItemRec.Description;

                    ItemUOM.Reset;
                    ItemUOM.SetRange("Item No.", Rec."No.");
                    ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
                    if ItemUOM.FindFirst() then begin
                        if StrLen(ItemUOM."Alternate Description") > 0 then
                            Rec.Description := ItemUOM."Alternate Description";
                    end;

                    Rec.Modify();
                until Rec.Next() = 0;
        end
        else begin
            if ItemRec.Get(Rec."No.") then
                Rec.Description := ItemRec.Description;
            ItemUOM.Reset;
            ItemUOM.SetRange("Item No.", Rec."No.");
            ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
            if ItemUOM.FindFirst() then begin
                if StrLen(ItemUOM."Alternate Description") > 0 then
                    Rec.Description := ItemUOM."Alternate Description";
            end;
        end;

        // CurrPage.Update(false);

    end;
    // YF 12 Nov 2021 // YF 20 Dec 2021

    var
        ExprDate: text;
        LastPurchQty: Decimal;
        LastFOCQty: Decimal;
        LastPurchDate: Date;
        ItemStatus: text;
        ItemStatusRemarks: Text[250];
        LastPurchPrice: Decimal;


        EnhanceCU: Codeunit "PMP-Enhancements";
        ItemRec: Record Item;

        PurchPriceFOCQty: Decimal;
        PurchPrice: Decimal;
        InvBal: Decimal;
        CompInfo: Record "Company Information";
        AvailQty: Decimal;
        SOQty: Decimal;
}