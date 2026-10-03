pageextension 55077 SalesReturnOrderSubformPageExt extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Return Reason Code")
        {
            //LK231123
            field("I9G QC/QA Comments"; rec."I9G QC/QA Comments")
            {
                ApplicationArea = All;

            }
            //LK231123
        }
        addafter(Description)
        {
            field(LotNo; LotNo)
            {
                Caption = 'Lot No.';
                ApplicationArea = all;
                Editable = false;
                Style = Attention;
            }
            field(ExprDate; ExprDate)
            {
                Caption = 'Expiration Date';
                ApplicationArea = all;
                Editable = false;
                Style = Attention;
            }
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                BlankZero = true;
                ShowMandatory = true;
                Style = Favorable;
                trigger OnValidate()
                var
                    ItemRec: Record Item;
                    FindNext: Boolean; // YF 21 Mar 2022
                begin
                    FindNext := true; // YF 21 Mar 2022

                    if (Rec.Type = Rec.Type::Item) and
                                   (Rec."No." <> '') and
                                   (Rec."Order Qty" <> 0) then begin
                        if Rec."Order Qty" <> xRec."Order Qty" then begin

                            // YF 25 Feb 2022
                            if RollOutChanges0 then begin
                                if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                                    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomizedV2(Rec, FindNext); // YF 21 Mar 2022 // Added FindNext parameter
                                    CurrPage.Update(true);
                                end else begin
                                    // take from item card price
                                    if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                                        if ItemRec.Get(Rec."No.") then begin
                                            Rec.Validate(Quantity, Rec."Order Qty");
                                            Rec.Validate("FOC Qty", 0);
                                            Rec.Validate("Selling Price", ItemRec."Unit Price");
                                            Rec.Validate("Unit Price", ItemRec."Unit Price");
                                            // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                                            CurrPage.Update(true);
                                        end;
                                    end;
                                end;
                            end
                            else begin
                                if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                                    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(Rec);
                                    CurrPage.Update(true);
                                end else begin
                                    // take from item card price
                                    if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                                        if ItemRec.Get(Rec."No.") then begin
                                            Rec.Validate(Quantity, Rec."Order Qty");
                                            Rec.Validate("FOC Qty", 0);
                                            Rec.Validate("Selling Price", ItemRec."Unit Price");
                                            Rec.Validate("Unit Price", ItemRec."Unit Price");
                                            // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                                            CurrPage.Update(true);
                                        end;
                                    end;
                                end;
                            end;
                            // YF 25 Feb 2022

                            if (Rec."Order Qty" = 0) then begin
                                Rec.Validate("Unit Price", 0);
                                Rec.Validate("Selling Price", 0);
                                Rec.Validate("FOC Qty", 0);
                                Rec.Modify(TRUE);
                            end;

                            //DX        27 Jun 2021
                            EnhanceCU.ExpirationLessThan12MthsWithLoc(Rec."No.", Rec."Location Code");
                            //DX        27 Jun 2021
                            TradeCU.RequireMaxQtyApproval(Rec);


                        end else
                            if (Rec."Order Qty" = 0) then begin
                                Rec.Validate("Unit Price", 0);
                                Rec.Validate("Selling Price", 0);
                                Rec.Validate("FOC Qty", 0);
                                Rec.Modify(TRUE);
                            end;
                    end else begin
                        //DX        27 Jun 2021
                        Rec.Validate(Quantity, Rec."Order Qty");
                        Rec.Validate("Selling Price", Rec."Unit Price"); // YF 06 Sept 2021
                        //DX        27 Jun 2021
                    end;

                    if TradeCU.IsPromoPrice(Rec) then
                        FieldStyle := 'Attention'
                    else
                        FieldStyle := 'none';

                    // YF 06 Aug 2021 // Temp Fix for Issue #80
                    if (Rec."Selling Price" = 0) Or (Rec."Unit Price" = 0) And (Rec."Order Qty" > 0) then
                        Rec.Validate(Quantity, Rec."Order Qty");
                    // YF 06 Aug 2021 // Temp Fix for Issue #80

                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                    Rec."Qty To Deliver" := Rec."Order Qty" - Rec."Qty Delivered";
                    Rec."FOC (Qty) To Deliver" := Rec."FOC Qty" - Rec."FOC Qty Delivered";
                    CurrPage.Update();
                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

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
                    InclFOCUnitPrice: Decimal;
                    FindNext: Boolean; // YF 21 Mar 2022
                begin
                    FindNext := true; // YF 21 Mar 2022

                    if (Rec.Type = Rec.Type::Item) and
                                   (Rec."No." <> '') and
                                   (Rec."Order Qty" <> 0) then begin

                        // YF 25 Feb 2022
                        if RollOutChanges0 then begin
                            if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                                //TradeCU.UpdatePLLineFOCQtyAndAmt(Rec);
                                TradeCU.UpdateSLLineFromFOCQty(Rec);
                                CurrPage.Update(true);
                            end else begin
                                //DX    18 Jun 2021 : Tweaking                            
                                TradeCU.UpdateSLLine(Rec);
                                //DX    18 Jun 2021 : Tweaking
                            end;
                        end
                        else begin
                            if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                                //TradeCU.UpdatePLLineFOCQtyAndAmt(Rec);
                                TradeCU.UpdateSLLineFromFOCQty(Rec);
                                CurrPage.Update(true);
                            end else begin
                                //DX    18 Jun 2021 : Tweaking                            
                                TradeCU.UpdateSLLine(Rec);
                                //DX    18 Jun 2021 : Tweaking
                            end;
                        end;
                        // YF 25 Feb 2022

                    end;

                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                    Rec."Qty To Deliver" := Rec."Order Qty" - Rec."Qty Delivered";
                    Rec."FOC (Qty) To Deliver" := Rec."FOC Qty" - Rec."FOC Qty Delivered";
                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                end;
                //DX        15 Aug 2021

                //DX        15 Aug 2021
            }

            field("Selling Price"; Rec."Selling Price")
            {
                ApplicationArea = all;
                DecimalPlaces = 2 : 4;
                BlankZero = true;
                StyleExpr = FieldStyle;

                trigger OnValidate()
                var
                    OrgLineAmt: Decimal;
                    InclFOCUnitPrice: Decimal;
                    FindNext: Boolean; // YF 21 Mar 2022
                begin
                    FindNext := true; // YF 21 Mar 2022

                    if (Rec.Type = Rec.Type::Item) and
                                   (Rec."No." <> '') and
                                   (Rec."Order Qty" <> 0) then begin

                        // YF 25 Feb 2022
                        if RollOutChanges0 then begin
                            if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                                TradeCU.UpdateSLLineSellPrice(Rec);
                                CurrPage.Update(true);
                            end else begin
                                //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                                //Rec.Validate("Unit Price", Rec."Selling Price");
                                //Rec.Validate(Quantity, Rec."Order Qty" + Rec."FOC Qty");
                                //Rec.Modify(TRUE);
                                TradeCU.UpdateSLLine(Rec);
                                //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                            end;
                        end
                        else begin
                            if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                                TradeCU.UpdateSLLineSellPrice(Rec);
                                CurrPage.Update(true);
                            end else begin
                                //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                                //Rec.Validate("Unit Price", Rec."Selling Price");
                                //Rec.Validate(Quantity, Rec."Order Qty" + Rec."FOC Qty");
                                //Rec.Modify(TRUE);
                                TradeCU.UpdateSLLine(Rec);
                                //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                            end;
                        end;
                        // YF 25 Feb 2022               

                    end else begin
                        //DX        27 Jun 2021
                        Rec.Validate("Unit Price", Rec."Selling Price");
                        //DX        27 Jun 2021
                    end;

                    //DX        15 Aug 2021
                    Rec."To Del. Amt" := Rec."Qty To Deliver" * Rec."Selling Price";
                    //DX        15 Aug 2021
                end;
            }

            field("Qty To Deliver"; Rec."Qty To Deliver")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 5;
                Style = Attention;
                trigger OnValidate()
                begin
                    if Rec."Order Qty" - Rec."Qty Delivered" < Rec."Qty To Deliver" then
                        Error('Cannot amend more than %1 units', Rec."Order Qty" - Rec."Qty Delivered");
                    if rec."FOC (Qty) To Deliver" < 0 then
                        Error('Cannot enter negative quantity.');
                    //DX        15 Aug 2021
                    Rec."To Del. Amt" := Rec."Qty To Deliver" * Rec."Selling Price";
                    //DX        15 Aug 2021

                    UpdateQtytoShipOrInvoice(); // YF 06 Sept 2021
                end;
            }

            field("FOC (Qty) To Deliver"; Rec."FOC (Qty) To Deliver")
            {
                ApplicationArea = all;
                Caption = 'FOC Qty To Deliver';
                DecimalPlaces = 0 : 5;
                Style = Attention;
                trigger OnValidate()
                begin
                    if Rec."FOC Qty" - rec."FOC Qty Delivered" < Rec."FOC (Qty) To Deliver" then
                        Error('Cannot amend more than %1 units', rec."FOC Qty Delivered" - Rec."FOC Qty");
                    if rec."FOC (Qty) To Deliver" < 0 then
                        Error('Cannot enter negative quantity.');

                    UpdateQtytoShipOrInvoice(); // YF 06 Sept 2021
                end;
            }
            field(I9G_LineNFRemarks; Rec.I9G_LineNFRemarks)
            {
                ApplicationArea = all;
                Caption = 'NF Line Remarks';
                TableRelation = NFLineRemarks.Code where(Code = filter('POST*'));
            }   //DX        12 Jun 26
            // field("I9G_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = all;
            //     Visible = false;
            //     Caption = 'Gen. Prod. Posting Group';
            // } //I9 040423 - Update version

        }

        addbefore(Quantity)
        {
            // YF 25 Aug 2021
            field("PO Import Price"; Rec."PO Import Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
            // YF 25 Aug 2021
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
        }
        modify("Return Reason Code")
        {
            ApplicationArea = All;
            ShowMandatory = true;
        }

        // YF 15 Dec 2021
        modify("Location Code")
        {
            ApplicationArea = All;

            trigger OnBeforeValidate()
            begin
                OrigSellingPrice := Rec."Selling Price"; // get original selling price
            end;

            trigger OnAfterValidate()
            begin
                Rec.Validate("Selling Price", OrigSellingPrice); // replace with original selling price
                CurrPage.SaveRecord(); // YF 18 May 2022
                ReValidateSellingPrice();
                CurrPage.Update(true);

            end;
        }
        // YF 15 Dec 2021

        //RL    07 Jan 2022
        addlast(Control1)
        {
            field("Qty. to Ship"; Rec."Qty. to Ship")
            {
                ApplicationArea = All;
            }
            field("I9G Driver Reason"; Rec."I9G Driver Reason")
            {
                ApplicationArea = All;
            }
        }
        //RL    07 Jan 2022

        //RL    19 July 2022
        // modify("No.")
        // {
        // trigger OnAfterValidate()
        // var
        //     SHRec: Record "Sales Header";

        // begin
        //     SHRec.Reset();
        //     SHRec.SetRange("Document Type", Rec."Document Type");
        //     SHRec.SetRange("No.", Rec."Document No.");
        //     if SHRec.FindFirst() then begin
        //         if (Rec.Type <> rec.Type::" ") AND (Rec."No." <> '') then begin
        //             Rec.Validate("Return Reason Code", SHRec.I9G_ReturnReasonCode);

        //         end;
        //     end;
        // end;

        // trigger OnBeforeValidate()
        // var
        //     SHRec: Record "Sales Header";

        // begin
        //     SHRec.Reset();
        //     SHRec.SetRange("Document Type", Rec."Document Type");
        //     SHRec.SetRange("No.", Rec."Document No.");
        //     if SHRec.FindFirst() then begin
        //         if (Rec.Type <> rec.Type::" ") AND (Rec."No." <> '') then begin
        //             Rec.Validate("Return Reason Code", SHRec.I9G_ReturnReasonCode);
        //         end;
        //     end;
        // end;
        // }
    }


    // YF 15 Dec 2021
    local procedure ReValidateSellingPrice()
    var
        OrgLineAmt: Decimal;
        InclFocUnitPrice: Decimal;
        FindNext: Boolean; // YF 21 Mar 2022
    begin
        FindNext := true; // YF 21 Mar 2022

        // YF 21 Oct 2021 // Access Control Checks
        if (Not EnhanceCU.IsCSLead()) And (Rec."Selling Price" <> xRec."Selling Price") then
            Error('Not allowed to edit');
        // YF 21 Oct 2021 // Access Control Checks

        if (Rec.Type = Rec.Type::Item) and
                        (Rec."No." <> '') and
                        (Rec."Order Qty" <> 0) then begin

            // YF 25 Feb 2022
            if RollOutChanges0 then begin
                if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                    TradeCU.UpdateSLLineSellPrice(Rec);
                    // CurrPage.Update(true);
                end else begin
                    //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                    //Rec.Validate("Unit Price", Rec."Selling Price");
                    //Rec.Validate(Quantity, Rec."Order Qty" + Rec."FOC Qty");
                    //Rec.Modify(TRUE);
                    TradeCU.UpdateSLLine(Rec);
                    //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                end;
            end
            else begin
                if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                    TradeCU.UpdateSLLineSellPrice(Rec);
                    // CurrPage.Update(true);
                end else begin
                    //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                    //Rec.Validate("Unit Price", Rec."Selling Price");
                    //Rec.Validate(Quantity, Rec."Order Qty" + Rec."FOC Qty");
                    //Rec.Modify(TRUE);
                    TradeCU.UpdateSLLine(Rec);
                    //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                end;
            end;
            // YF 25 Feb 2022

        end else begin
            //DX        27 Jun 2021
            Rec.Validate("Unit Price", Rec."Selling Price");
            //DX        27 Jun 2021
        end;

        //DX        15 Aug 2021
        Rec."To Del. Amt" := Rec."Qty To Deliver" * Rec."Selling Price";
        //DX        15 Aug 2021
    end;
    // YF 15 Dec 2021

    local procedure UpdateQtytoShipOrInvoice()
    begin
        //DX        07 Sept 2021
        if NOT (IsWarehouseReq(Rec."Location Code")) then begin
            Rec.Validate("Qty. to Ship", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
            Rec.Validate("Qty. to Invoice", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
            //DX        07 Sept 2021
        end;
    end;

    local procedure IsWarehouseReq(LocCode: Code[20]): Boolean
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

    trigger OnAfterGetRecord()
    var
        ILEREC: Record "Item Ledger Entry";
    begin
        if TradeCU.IsPromoPrice(Rec) then
            FieldStyle := 'Attention'
        else
            FieldStyle := 'none';

        GetItemEarliestExpiration();
    end;

    //RL 6 July 2023
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SHRec: Record "Sales Header";

    begin
        SHRec.Reset();
        SHRec.SetRange("Document Type", Rec."Document Type");
        SHRec.SetRange("No.", Rec."Document No.");
        SHRec.SetLoadFields("No.", "Document Type", I9G_ReturnReasonCode);
        if SHRec.FindFirst() then begin
            if (Rec.Type <> rec.Type::" ") AND (Rec."No." <> '') then begin
                Rec.Validate("Return Reason Code", SHRec.I9G_ReturnReasonCode);
            end;
        end;
        GetItemEarliestExpiration();
    end;
    //RL 6 July 2023

    // YF 25 Feb 2022
    trigger OnOpenPage()
    begin
        // ### ACTUAL SCHEDULED TRIGGER CONDITION ### //
        // RollOutChanges0 := Today = DMY2Date(1, 4, 2022);
        // ### ACTUAL SCHEDULED TRIGGER CONDITION ### //

        // ### FOR INTERNAL DEBUG AND TEST ### // 
        // RollOutChanges0 := UserId = 'BCADMIN';
        // RollOutChanges0 := false; // override
        RollOutChanges0 := true; // override
        // ### FOR INTERNAL DEBUG AND TEST ### // 
    end;
    // YF 25 Feb 2022
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GetItemEarliestExpiration();
    end;

    var
        FieldStyle: Text[100];
        TradeCU: Codeunit "Trade Agreement CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
        ExprDate: Date;
        LotNo: Text[100];

        OrigSellingPrice: Decimal; // YF 15 Dec 2021
        RollOutChanges0: Boolean; // YF 25 Feb 2022 
        ItemRec: Record Item;

    procedure GetItemEarliestExpiration()
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";

    begin
        ExprDate := 0D;
        LotNo := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ItemRec.reset;
            ItemRec.SetLoadFields("No.", "Item Tracking Code");  //DX        06 May 2023
            ItemRec.SetRange("No.", Rec."No.");
            ItemRec.SetFilter("Item Tracking Code", '<>%1', '');
            if ItemRec.FindFirst() then begin
                ILERec.reset;
                ILERec.SetLoadFields("Item No.", "Location Code", "Expiration Date", "Lot No.", "Remaining Quantity", "Variant Code");
                ILERec.SetCurrentKey("Item No.", "Location Code", "Expiration Date");
                ILERec.SetAscending("Expiration Date", true);
                ILERec.SetRange("Location Code", Rec."Location Code");
                ILERec.SetRange("Item No.", Rec."No.");
                ILERec.SetFilter("Lot No.", '<>%1', '');
                ILERec.SetFilter("Expiration Date", '<>%1', 0D);
                ILERec.SetFilter("Remaining Quantity", '>0');
                ILERec.SetFilter("Variant Code", Rec."Variant Code");
                if ILERec.FindFirst() then begin
                    ExprDate := ILERec."Expiration Date";
                    LotNo := ILERec."Lot No.";
                end;
            end;
        end else begin
            ExprDate := 0D;
            LotNo := '';
        end;
    end;
}
