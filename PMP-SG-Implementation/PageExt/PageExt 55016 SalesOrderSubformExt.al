pageextension 55016 SaleOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Quantity)
        {
            field(I9G_LineNFRemarks; Rec.I9G_LineNFRemarks)
            {
                ApplicationArea = all;
                Caption = 'NF Line Remarks';
                TableRelation = NFLineRemarks.Code where(Code = filter('PRE*'));
            }   //DX        12 Jun 26
            //DX        09 Sept 2021
            field("STO Qty"; Rec."STO Qty")
            {
                ApplicationArea = all;
                ToolTip = 'Qty for STO Qty before confirming.';
            }
            //DX        09 Sept 2021

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
                                        ItemRec.reset;
                                        ItemRec.SetLoadFields("No.", "Unit Price");      //DX        24 May 2023
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
                                        ItemRec.reset;
                                        ItemRec.SetLoadFields("No.", "Unit Price");      //DX        24 May 2023
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
                DecimalPlaces = 2 : 5;
                BlankZero = true;
                StyleExpr = FieldStyle;
                // Editable = LeadCanEdit;
                Editable = true;

                trigger OnValidate()
                var
                    OrgLineAmt: Decimal;
                    InclFOCUnitPrice: Decimal;
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
                            if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022
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

                    end else begin
                        if (Rec.Type = Rec.Type::Item) and
                            (Rec."No." <> '') and
                            (Rec."Order Qty" = 0) then
                            Rec.Validate(Quantity, Rec."FOC Qty");

                    end;

                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                    Rec."Qty To Deliver" := Rec."Order Qty" - Rec."Qty Delivered";
                    Rec."FOC (Qty) To Deliver" := Rec."FOC Qty" - Rec."FOC Qty Delivered";
                    // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                end;
                //DX        15 Aug 2021

                //DX        15 Aug 2021
            }
            field("Remarks"; Rec."I9G Remarks")
            {
                ApplicationArea = All;
                Caption = 'Remarks';
            }


        }
        //DX        28 July 2021
        addafter(Description)
        {
            field(MinShelf; VarMinShelf)
            {
                ApplicationArea = All;
                Editable = false;
                Style = Favorable;
            }
            field(InvDiscAmount; Rec."Inv. Discount Amount")
            {
                applicationArea = All;
                Editable = false;
            }
        }

        addbefore(Quantity)
        {
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
                DecimalPlaces = 0 : 5;
            }
            field("FOC Qty Delivered"; Rec."FOC Qty Delivered")
            {
                ApplicationArea = all;
                Editable = false;
                DecimalPlaces = 0 : 5;
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

            // YF 14 Oct 2021
            field("Out of Stock"; Rec."Out of Stock")
            {
                ApplicationArea = All;
                Caption = 'Out of Stock';
                Style = Favorable;
                StyleExpr = OOSBool;
                Editable = false;
            }

            field("Insufficient Stocks in Pick"; Rec."Insufficient Stocks in Pick")
            {
                ApplicationArea = All;
                Caption = 'Insufficient Stocks in Active Area';
                Style = Favorable;
                StyleExpr = IStkBool;
                Editable = false;
            }
            field(I9G_RequiredLOU; Rec.I9G_RequiredLOU)
            {
                applicationArea = All;
                editable = false;
            }
            field(I9G_Restriction; Rec.I9G_Restriction)
            {
                applicationArea = All;
                editable = false;
            }

            // YF 14 Oct 2021
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
            StyleExpr = ItemNoStyle;
            ApplicationArea = All;

            trigger OnBeforeValidate()
            var
                myInt: Integer;
                SHRec: Record "Sales Header";
                SSSetup: Record "Sales & Receivables Setup";
            begin
                //DX        21 Sept 2021
                SHRec.reset;
                SHRec.SetRange("Document Type", Rec."Document Type");
                shrec.SetRange("No.", Rec."Document No.");
                SHRec.SetRange("Logistics Service", true);
                if SHRec.FindFirst() then begin
                    SSSetup.reset;
                    SSSetup.get;
                    if SSSetup."Def. LS Location COde" <> '' then begin
                        if SHRec."Location Code" <> SSSetup."Def. LS Location COde" then begin
                            SHRec.Validate("Location Code", SSSetup."Def. LS Location COde");
                            SHRec.Modify(TRUE);
                        end;
                    end;
                end;

                //DX        21 Sept 2021
            end;

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
                    //DX        21 Sept 2021
                    SHRec.reset;
                    SHRec.SetRange("Document Type", Rec."Document Type");
                    shrec.SetRange("No.", Rec."Document No.");
                    SHRec.SetRange("Logistics Service", true);
                    if SHRec.FindFirst() then begin
                        SSSetup.reset;
                        SSSetup.get;
                        if SSSetup."Def. LS Location COde" <> '' then begin
                            if Rec."Location Code" <> SSSetup."Def. LS Location COde" then begin
                                rec.Validate("Location Code", SSSetup."Def. LS Location COde");
                                Rec.Modify(TRUE);
                            end;

                        end;
                    end;
                end;


                //DX        01 July 2021

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
        modify("Quantity Invoiced")
        {
            Caption = 'Total Qty Invoiced';
        }
        modify("Quantity Shipped")
        {
            Caption = 'Total Qty Shipped';
        }

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

        addafter("Location Code")
        {
            field(SelectedItemTrackingLot; SelectedItemTrackingLot)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Selected Item Tracking Lot';
            }

            field(SelectedExpiry; SelectedExpiry)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Selected Expiry Date';
            }
        }
        modify("Unit Price")
        {
            Editable = LeadCanEdit;
        }

        modify("Unit of Measure Code")
        {
            ApplicationArea = All;
            trigger OnBeforeValidate()
            begin
                if CurrentClientType = ClientType::ODataV4 then
                    OrigSellingPrice := Rec."Selling Price"; // get original selling price
            end;

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

                if CurrentClientType = ClientType::ODataV4 then begin
                    Rec.Validate("Selling Price", OrigSellingPrice); // replace with original selling price
                    CurrPage.SaveRecord(); // YF 18 May 2022
                    ReValidateSellingPrice();
                end;
            end;



        }

        // YF            22 Oct 2021
        addbefore("Unit of Measure Code")
        {
            field("ZP Customer Name"; Rec."ZP Customer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("ZP SP"; Rec."ZP SP")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("ZP Detailman"; Rec."ZP Detailman")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        // YF           22 Oct 2021

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
            end;
        }
        // YF 15 Dec 2021

        addlast(Control1)
        {
            field(I9G_ChainRemarks; Rec.I9G_ChainRemarks)
            {
                Caption = 'Chain Remarks';
                ApplicationArea = All;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created At';
                Editable = false;
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified At';
                Editable = false;
            }
            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }
        }
        addafter("Reserved Quantity")
        {
            field(I9G_TotalReservedQty; Rec.I9G_TotalReservedQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Reserved Qty field.', Comment = '%';
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
            action("Create TBA Pending Delivery")
            {
                ApplicationArea = All;
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = page "Add Pending Del TBA Card";
                trigger OnAction()
                var
                    LSLrec: Record "Sales Line";
                    PendRec: Page "Add Pending Del TBA Card";
                    SHRec: Record "Sales Header";
                begin
                    SHRec.reset;
                    SHRec.SetRange("No.", rec."Document No.");
                    shrec.SetRange("Document Type", Rec."Document Type");
                    if SHRec.FindFirst() then begin
                        if SHRec."TBA Order" = false then begin
                            Error('You can only do this if your SO is a TBA order.');
                        end;
                    end;
                    CurrPage.SetSelectionFilter(LSLrec);
                    page.Run(55073, LSLrec);
                end;
            }
        }
    }


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

        // YF 15 Dec 2021    
        if (Rec."Selling Price" <> Rec."PO Import Price") And (Rec."PO Import Price" <> 0) then
            ItemNoStyle := 'Attention'
        else
            ItemNoStyle := 'none';
        // YF 15 Dec 2021

        //DX        01 Jun 2021
        //DX        27 Jun 2021
        ExprDate := '';
        Status := '';
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            ExprDate := format(EnhanceCU.GetItemEarliestExpiration(Rec."No.", Rec."Location Code"));
            ItemRec.reset;
            ItemRec.SetLoadFields("No.", "Item Status");
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then
                Status := ItemRec."Item Status";
        end else begin
            ExprDate := '';
            Status := '';
        end;

        //DX        27 Jun 2021
        //DX        26 Sept 2021
        LeadCanEdit := EnhanceCU.IsCSLead();
        //DX        26 Sept 2021

        GetFirstItemTrackingLineData();

        // YF        14 Oct 2021
        OOSBool := Not Rec."Out of Stock";
        IStkBool := Not Rec."Insufficient Stocks in Pick";
        // YF        14 Oct 2021

        Clear(VarMinShelf);

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
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // YF 15 Dec 2021    
        if (Rec."Selling Price" <> Rec."PO Import Price") And (Rec."PO Import Price" <> 0) then
            ItemNoStyle := 'Attention'
        else
            ItemNoStyle := 'none';
        // YF 15 Dec 2021
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
        if NOT (IsWarehouseReq(Rec."Location Code")) then begin
            Rec.Validate("Qty. to Ship", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
            Rec.Validate("Qty. to Invoice", Rec."Qty To Deliver" + Rec."FOC (Qty) To Deliver");
            //DX        07 Sept 2021
        end;
    end;

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

    local procedure GetFirstItemTrackingLineData()
    var
        ReservEntry: Record "Reservation Entry";
        ILERec: Record "Item Ledger Entry";
    begin
        SelectedItemTrackingLot := '';
        SelectedExpiry := 0D;

        ReservEntry.Reset;
        ReservEntry.SetLoadFields("Item No.", "Source ID", "Source Type", "Source Subtype", "Source Ref. No.", "Lot No.");     //DX    03 May 2023
        ReservEntry.SetCurrentKey("Item No.", "Source Type", "Source Subtype", "Source ID", "Source Ref. No.");     //DX        12 Jun 2023
        ReservEntry.SetRange("Item No.", Rec."No.");
        ReservEntry.SetRange("Source Type", 37);
        ReservEntry.SetRange("Source Subtype", 1);
        ReservEntry.SetRange("Source ID", Rec."Document No.");
        ReservEntry.Setrange("Source Ref. No.", rec."Line No."); //RL 15 Dec 2021 - cater for multiple lines of the same item
        if ReservEntry.FindFirst() then begin
            SelectedItemTrackingLot := ReservEntry."Lot No.";
            ILERec.Reset;
            ILERec.SetLoadFields("Item No.", "Lot No.", "Expiration Date");         //DX        03 May 2023
            ILERec.SetCurrentKey("Item No.", "Lot No.");     //DX        16 May 2023
            ILERec.SetRange("Item No.", Rec."No.");
            ILERec.SetRange("Lot No.", SelectedItemTrackingLot);
            if ILERec.FindLast() then
                SelectedExpiry := ILERec."Expiration Date";
        end;
    end;

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
        POImportPriceStyle: Text[100];
        Status: Text[100];
        ItemRec: Record Item;
        SelectedItemTrackingLot: Code[50];
        SelectedExpiry: Date;
        LeadCanEdit: Boolean;
        OOSBool: Boolean;
        IStkBool: Boolean;
        OrigSellingPrice: Decimal; // YF 15 Dec 2021
        ItemNoStyle: Text[50]; // YF 15 Dec 2021
        RollOutChanges0: Boolean; // YF 25 Feb 2022
        MiniShelf: Record MinimumShelf;
        VarMinShelf: Date;
}