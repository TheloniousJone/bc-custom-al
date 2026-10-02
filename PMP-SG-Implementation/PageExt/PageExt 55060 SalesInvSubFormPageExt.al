pageextension 55060 SalesInvSubFormPageExt extends "Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here

        addbefore(Quantity)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 2;
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
                                if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Add FindNext parameter
                                    TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomizedV2(Rec, FindNext); // YF 21 Mar 2022 // Add FindNext parameter
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

                    // Pre-customized Price List
                    /*
                    if (Rec.Type = Rec.Type::Item) and
                                   (Rec."No." <> '') and
                                   (Rec."Order Qty" <> 0) then begin
                        if TradeCU.IsValidSalesAgreement(Rec) then begin
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
                    end else begin
                        //DX        27 Jun 2021
                        Rec.Validate("Unit Price", Rec."Selling Price");
                        //DX        27 Jun 2021
                    end;
                    */
                    //DX        15 Aug 2021
                    Rec."To Del. Amt" := Rec."Qty To Deliver" * Rec."Selling Price";
                    //DX        15 Aug 2021
                end;
            }
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 2;
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

                    // Pre-customized Price List
                    /*
                    if (Rec.Type = Rec.Type::Item) and
                                   (Rec."No." <> '') and
                                   (Rec."FOC Qty" <> 0) and
                                   (Rec."Order Qty" <> 0) then begin
                        if TradeCU.IsValidSalesAgreement(Rec) then begin
                            //TradeCU.UpdatePLLineFOCQtyAndAmt(Rec);
                            TradeCU.UpdateSLLineFromFOCQty(Rec);
                            CurrPage.Update(true);
                        end else begin
                            //DX    18 Jun 2021 : Tweaking                            
                            TradeCU.UpdateSLLine(Rec);
                            //DX    18 Jun 2021 : Tweaking
                        end;
                    end;
                    */

                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                    Rec."Qty To Deliver" := Rec."Order Qty" - Rec."Qty Delivered";
                    Rec."FOC (Qty) To Deliver" := Rec."FOC Qty" - Rec."FOC Qty Delivered";
                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                end;
                //DX        15 Aug 2021

                //DX        15 Aug 2021
            }


        }
        //DX        28 July 2021
        addbefore(Quantity)
        {
            field("Qty To Deliver"; Rec."Qty To Deliver")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 2;
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
                DecimalPlaces = 0 : 2;
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
            field("To Del. Amt"; Rec."To Del. Amt")
            {
                ApplicationArea = all;
                Style = Attention;
                Editable = false;
            }
            field("Qty Delivered"; Rec."Qty Delivered")
            {
                ApplicationArea = all;
                Editable = false;
                DecimalPlaces = 0 : 2;
            }
            field("FOC Qty Delivered"; Rec."FOC Qty Delivered")
            {
                ApplicationArea = all;
                Editable = false;
                DecimalPlaces = 0 : 2;
            }

            //DX        17 Jun 2021
            field("Max Qty Approval"; Rec."Max Qty Approval")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Principal; Rec.Principal)
            {
                ApplicationArea = all;
            }
            //DX        17 Jun 2021        

            // YF 25 Aug 2021
            field("PO Import Price"; Rec."PO Import Price")
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = POImportPriceStyle;
            }
            // YF 25 Aug 2021
        }
        //DX        28 July 2021
        addafter("No.")
        {
            field(ExprDate; ExprDate)
            {
                Caption = 'Expiration Date';
                ApplicationArea = all;
                Editable = false;
                Style = Attention;
            }
            field(Status; Status)
            {
                ApplicationArea = all;
                Caption = 'Item Status';
                Editable = false;
                Style = Attention;
            }
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record item;
                SSSetup: Record "Sales & Receivables Setup";
                SHRec: Record "Sales Header";
            begin
                //DX        01 July 2021
                if (Rec.Type = Rec.Type::Item) and
                (Rec."No." <> xRec."No.") then begin
                    EnhanceCU.CustItemIsBlocked(Rec."Sell-to Customer No.", Rec."No.");
                    //DX        21 July 2021
                    EnhanceCU.LsItemCannotEnter(Rec);
                    //DX        21 July 2021
                    //DX        08 Aug 2021
                    ItemRec.Reset();
                    ItemRec.SetRange("No.", Rec."No.");
                    if itemrec.FindFirst() then begin
                        Rec.Principal := ItemRec.Principal;
                        Rec."I9G Item Status" := ItemRec."Item Status";
                    end;
                    //DX        08 Aug 2021
                    //DX        13 Aug 2021
                    EnhanceCU.CustItemForensicIsTrue(Rec);
                    EnhanceCU.CustIsInAllowed(Rec);
                    //DX        13 Aug 2021

                    //DX        28 Aug 2021
                    EnhanceCU.CheckMixofCDandNonCD(Rec);
                    //EnhanceCU.AutoupdateSTO(Rec);
                    //DX        28 Aug 2021
                    //DX        30 Aug 2021

                    if EnhanceCU.IsPMPCompany() then
                        EnhanceCU.CheckMixofSTBioandNonSTBio(Rec); // YF 24 Mar 2025

                    SHRec.reset;
                    SHRec.SetRange("Document Type", Rec."Document Type");
                    shrec.SetRange("No.", Rec."Document No.");
                    SHRec.SetRange("Logistics Service", true);
                    if SHRec.FindFirst() then begin
                        SSSetup.reset;
                        SSSetup.get;
                        SSSetup.TestField("Def. LS Gen Prod Posting");
                        rec.Validate("Gen. Prod. Posting Group", SSSetup."Def. LS Gen Prod Posting");
                        rec.Modify(true);
                    end;

                    SHRec.reset;
                    SHRec.SetRange("Document Type", Rec."Document Type");
                    shrec.SetRange("No.", Rec."Document No.");
                    SHRec.SetRange("Samples SO", true);
                    if SHRec.FindFirst() then begin
                        SSSetup.reset;
                        SSSetup.get;
                        SSSetup.TestField("Def. Gen Prod PG for Sample");
                        rec.Validate("Gen. Prod. Posting Group", SSSetup."Def. Gen Prod PG for Sample");
                        rec.Modify(true);
                    end;
                    //DX        30 Aug 2021
                end;


                //DX        01 July 2021

            end;
        }
        addafter(Description)
        {
            field(MinShelf; VarMinShelf)
            {
                ApplicationArea = All;
                Editable = false;
                Style = Favorable;
            }
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify(Quantity)
        {
            Caption = 'Total Qty';
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

        modify("Location Code")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            begin
                CurrPage.SaveRecord(); // YF 18 May 2022
            end;
        }

        addlast(Control1)
        {
            field(I9G_ChainRemarks; Rec.I9G_ChainRemarks)
            {
                Caption = 'Chain Remarks';
                ApplicationArea = All;
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        SHRec: Record "Sales Header";
    begin
        if TradeCU.IsPromoPrice(Rec) then
            FieldStyle := 'Attention'
        else
            FieldStyle := 'none';

        if (Rec."PO Import Price" = 0) Or (Rec."PO Import Price" = Rec."Selling Price") then
            POImportPriceStyle := 'none'
        else
            POImportPriceStyle := 'Attention';

        //DX        01 Jun 2021
        //DX        27 Jun 2021
        ExprDate := '';
        Status := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then
                Status := ItemRec."Item Status";
        end else begin
            ExprDate := '';
            Status := '';
        end;

        //DX        27 Jun 2021

        //PK20032024
        MiniShelf.Reset();
        MiniShelf.SetRange("No.", Rec."No.");
        MiniShelf.SetRange(Code, Rec."Customer Price Group");
        if MiniShelf.FindFirst() then begin
            SHRec.Reset;
            SHRec.SetRange("Document Type", Rec."Document Type");
            SHRec.SetRange("No.", Rec."Document No.");
            if SHRec.FindFirst() then
                VarMinShelf := CalcDate(MiniShelf.MinShelf, SHRec."Posting Date");
        end;
        //PK20032024
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //DX        27 Jun 2021
        ExprDate := '';
        Status := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then
                Status := ItemRec."Item Status";
        end else begin
            ExprDate := '';
            Status := '';
        end;

        //DX        27 Jun 2021
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //DX        27 Jun 2021
        Status := '';
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then
                Status := ItemRec."Item Status";
        end else begin
            ExprDate := '';
            Status := '';
        end;
        //DX        27 Jun 2021
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
        SHRec: Record "Sales Header";
    begin
        //DX        06 Sept 2021
        SHRec.reset;
        SHRec.SetRange("No.", Rec."Document No.");
        SHRec.SetRange("Document Type", Rec."Document Type");
        if SHRec.FindFirst() then begin
            if SHRec."Samples SO" = true then begin
                Rec."Unit Price" := 0;
                rec."Selling Price" := 0;
            end;
        end;
        //DX        06 Sept 2021
    end;

    local procedure UpdateQtytoShipOrInvoice()
    begin
        //DX        07 Sept 2021
        if NOT (TradeCU.IsWarehouseReq(Rec."Location Code")) then begin
            Rec.Validate("Qty. to Ship", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
            Rec.Validate("Qty. to Invoice", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
            //DX        07 Sept 2021
        end;
    end;

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

    var
        FieldStyle: Text[100];
        TradeCU: Codeunit "Trade Agreement CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
        ExprDate: Text[100];
        POImportPriceStyle: Text[100];
        Status: Text[100];
        ItemRec: Record Item;
        RollOutChanges0: Boolean; // YF 25 Feb 2022
        MiniShelf: Record MinimumShelf;
        VarMinShelf: Date;
}
