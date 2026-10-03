pageextension 55096 SalesQuoteSubformPageExt extends "Sales Quote Subform"
{
    layout
    {
        // Add changes to page layout here
        addlast(content)
        {
            // field("Return Qty. to Receive"; Rec."Return Qty. to Receive")
            // {
            //     ApplicationArea = all;
            // }
            // field("Return Qty. Received"; Rec."Return Qty. Received")
            // {
            //     ApplicationArea = all;
            // }
        }
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

                    // UpdateQtyToShip(); // YF 17 Aug 2021 // Issue 13 and 107

                    CurrPage.Update();
                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                end;
            }

            field("Selling Price"; Rec."Selling Price")
            {
                ApplicationArea = all;
                DecimalPlaces = 2 : 5;
                BlankZero = true;
                StyleExpr = FieldStyle;
                Editable = true;

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
                                TradeCU.UpdateSLLine(Rec);
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
                            if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameters
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

                    // UpdateQtyToShip(); // YF 17 Aug 2021 // Issue 13 and 107

                end;
                //DX        15 Aug 2021

                //DX        15 Aug 2021
            }


        }
        //DX        28 July 2021
        addbefore(Quantity)
        {
            // //DX        17 Jun 2021
            // field("Max Qty Approval"; Rec."Max Qty Approval")
            // {
            //     ApplicationArea = all;
            //     Editable = false;
            // }
            // field(Principal; Rec.Principal)
            // {
            //     ApplicationArea = all;
            // }
            // //DX        17 Jun 2021        
        }
        //DX        28 July 2021
        addafter("No.")
        {
            // field(ExprDate; ExprDate)
            // {
            //     Caption = 'Expiration Date';
            //     ApplicationArea = all;
            //     Editable = false;
            //     Style = Attention;
            // }
        }
        addafter("Line Amount")
        {
            field(c2price; c2price)
            {
                ApplicationArea = All;
                Caption = 'C2 Price';
                Editable = false;
                DecimalPlaces = 0 : 5;
            }
            field(purchaseprice; purchaseprice)
            {
                ApplicationArea = All;
                Caption = 'Purchase Price';
                Editable = false;
                DecimalPlaces = 0 : 5;

            }
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record item;
                SSSetup: Record "Sales & Receivables Setup";
                SHRec: Record "Sales Header";
                ItemUOM: Record "Item Unit of Measure";
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
                end;


                //DX        01 July 2021
            end;
        }

        /*
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        */

        modify(Quantity)
        {
            Caption = 'Total Qty';
        }


        /*
        addfirst(Control45)
        {
            field(AmtToShip; TotalSalesLine."To Del. Amt")
            {
                ApplicationArea = all;
                Visible = false;
                //DX        15 Aug 2021 hide first
                Caption = 'Total Amt To Deliver';
                Editable = false;
            }
        }
        */

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

            trigger OnBeforeValidate()
            begin
                OrigSellingPrice := Rec."Selling Price"; // get original selling price
            end;

            trigger OnAfterValidate()
            begin
                Rec.Validate("Selling Price", OrigSellingPrice); // replace with original selling price
                CurrPage.SaveRecord(); // YF 18 May 2022
                ReValidateSellingPrice();
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

    actions
    {
        // Add changes to page actions here
        addfirst("F&unctions")
        {
            action("View Historial Transactions")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = History;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ViewHistoryPage: Page ViewItemHistorical;
                begin
                    ViewHistoryPage.LoadData(Rec."No.", Rec."Sell-to Customer No.");
                    ViewHistoryPage.RunModal();
                end;

            }
        }
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
                    PricePage: page PharmaSalesPriceList;
                    PriceRec: Record "Pharma Sales Price";
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

    trigger OnAfterGetRecord()
    begin
        if TradeCU.IsPromoPrice(Rec) then
            FieldStyle := 'Attention'
        else
            FieldStyle := 'none';
        //DX        01 Jun 2021
        //DX        27 Jun 2021
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
        end else
            ExprDate := '';
        //DX        27 Jun 2021
        GetTradePrice();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //DX        27 Jun 2021
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
        end else
            ExprDate := '';
        //DX        27 Jun 2021
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //DX        27 Jun 2021
        ExprDate := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
        end else begin
            ExprDate := '';
        end;
        //DX        27 Jun 2021
    end;

    local procedure UpdateQtyToShip()
    begin
        Rec.Validate("Qty. to Ship", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
    end;

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
                if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Add FindNext parameter
                    TradeCU.UpdateSLLineSellPrice(Rec);
                    CurrPage.Update(true);
                end else begin
                    TradeCU.UpdateSLLine(Rec);
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
    // YF 15 Dec 2021
    var
        FieldStyle: Text[100];
        TradeCU: Codeunit "Trade Agreement CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
        ExprDate: Text[100];
        OrigSellingPrice: Decimal;
        RollOutChanges0: Boolean; // YF 25 Feb 2022

        c2price, purchaseprice : decimal;

    local procedure GetTradePrice()
    var
        myInt: Integer;
        STARec: Record "Pharma Sales Price";
        PTARec: Record "Pharma Purchase Price";
        SHRec: Record "Sales Header";

    begin
        Clear(c2price);
        Clear(purchaseprice);

        SHRec.Reset();
        SHRec.SetRange("Document Type", Rec."Document Type");
        SHRec.SetRange("No.", Rec."Document No.");
        SHRec.SetLoadFields("Order Date", "Document Date");
        if SHRec.FindFirst() then begin

            STARec.Reset();
            STARec.SetRange("Item No.", Rec."No.");
            STARec.SetRange("Sales Type", STARec."Sales Type"::"Customer Price Group");
            STARec.SetRange("Sales Code", 'C2');
            STARec.SetFilter(STARec."Starting Date", '<=%1', SHRec."Document Date");
            STARec.SetFilter(STARec."Ending Date", '>=%1', SHRec."Document Date");
            STARec.SetRange(Status, STARec.Status::Active);
            STARec.SetRange("TA Type", STARec."TA Type"::All);
            STARec.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            STARec.SetLoadFields("Unit Price");
            if STARec.FindFirst() then
                c2price := STARec."Unit Price";


            PTARec.Reset();
            PTARec.SetRange("Item No.", Rec."No.");
            // PTARec.SetRange("Sales Type", PTARec."Sales Type"::"Customer Price Group");
            // PTARec.SetRange("Sales Code", 'C2');
            PTARec.SetFilter(PTARec."Starting Date", '<=%1', SHRec."Document Date");
            PTARec.SetFilter(PTARec."Ending Date", '>=%1', SHRec."Document Date");
            PTARec.SetRange(Status, PTARec.Status::Active);
            // PTARec.SetRange("TA Type", PTARec."TA Type"::All);
            PTARec.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            PTARec.SetAscending("Minimum Quantity", false);
            PTARec.SetLoadFields("Direct Unit Cost");
            if PTARec.FindFirst() then
                purchaseprice := PTARec."Direct Unit Cost";
        end;



    end;
}