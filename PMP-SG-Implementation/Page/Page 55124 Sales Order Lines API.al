page 55124 "Sales Order Lines API"
{
    AutoSplitKey = true;
    Caption = 'Sales Order Lines API';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
                    Visible = not TypeAsTextFieldVisible;

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                        SetLocationCodeMandatory();
                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }
                field(FilteredTypeField; TypeAsText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
                    Editable = CurrPageIsEditable;
                    LookupPageID = "Option Lookup List";
                    TableRelation = "Option Lookup Buffer"."Option Caption" where("Lookup Type" = const(Sales));
                    ToolTip = 'Specifies the type of transaction that will be posted with the document line. If you select Comment, then you can enter any text in the Description field, such as a message to a customer. ';
                    Visible = TypeAsTextFieldVisible;

                    trigger OnValidate()
                    begin
                        TempOptionLookupBuffer.SetCurrentType(Rec.Type.AsInteger());
                        if TempOptionLookupBuffer.AutoCompleteLookup(TypeAsText, TempOptionLookupBuffer."Lookup Type"::Sales) then
                            Rec.Validate(Type, TempOptionLookupBuffer.ID);
                        TempOptionLookupBuffer.ValidateOption(TypeAsText);
                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies what you are selling, such as a product or a fixed asset. You’ll see different lists of things to choose from depending on your choice in the Type field.';

                    trigger OnValidate()
                    var
                        IsHandled: Boolean;
                    begin
                        IsHandled := false;
                        OnBeforeValidateNo(Rec, xRec, IsHandled);
                        if IsHandled then
                            exit;

                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        Rec.ShowShortcutDimCode(ShortcutDimCode);

                        QuantityOnAfterValidate();
                        UpdateTypeText();
                        DeltaUpdateTotals();

                        CurrPage.Update();
                    end;
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    AccessByPermission = tabledata "Item Reference" = R;
                    ApplicationArea = Suite, ItemReferences;
                    QuickEntry = false;
                    ToolTip = 'Specifies a reference to the item number as defined by the vendor or customer, or the item''s barcode.';
                    Visible = ItemReferenceVisible;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesHeader: Record "Sales Header";
                        ItemReferenceMgt: Codeunit "Item Reference Management";
                    begin
                        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                        ItemReferenceMgt.SalesReferenceNoLookup(Rec, SalesHeader);
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        DeltaUpdateTotals();
                        OnReferenceNoOnAfterLookup(Rec);
                        CurrPage.Update();
                    end;

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        DeltaUpdateTotals();
                        CurrPage.Update();
                    end;
                }
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
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
                    Visible = false;
                }
                field("IC Partner Ref. Type"; Rec."IC Partner Ref. Type")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
                    Visible = false;
                }
                field("IC Partner Reference"; Rec."IC Partner Reference")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner''s company that corresponds to the line.';
                    Visible = false;
                }
                field("IC Item Reference"; Rec."IC Item Reference No.")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the IC item reference. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner''s company that corresponds to the line.';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    ShowMandatory = VariantCodeMandatory;
                    Visible = false;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        VariantCodeOnAfterValidate();
                        DeltaUpdateTotals();
                        if Rec."Variant Code" = '' then
                            VariantCodeMandatory := Item.IsVariantMandatory(Rec.Type = Rec.Type::Item, Rec."No.");
                    end;
                }
                field("Substitution Available"; Rec."Substitution Available")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that a substitute is available for the item on the sales line.';
                    Visible = false;
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for a special procurement method, such as drop shipment.';
                    Visible = false;
                }
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that this item is a catalog item.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies a description of what you’re selling. Based on your choices in the Type and No. fields, the field may show suggested text that you can change it for this document. To add a comment, set the Type field to Comment and write the comment itself here.';

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow();

                        Rec.RestoreLookupSelection();

                        if Rec."No." = xRec."No." then
                            exit;

                        NoOnAfterValidate();
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        UpdateTypeText();
                        DeltaUpdateTotals();
                        OnAfterValidateDescription(Rec, xRec);
                    end;

                    trigger OnAfterLookup(Selected: RecordRef)
                    begin
                        Rec.SaveLookupSelection(Selected);
                    end;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies information in addition to the description.';
                    Visible = false;
                }
                field(MinShelf; VarMinShelf)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Favorable;
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
                    Visible = false;
                }
                field("Special Order"; Rec."Special Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the item on the sales line is a special-order item.';
                    Visible = false;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    QuickEntry = false;
                    ShowMandatory = LocationCodeMandatory;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = LocationCodeVisible;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate();
                        DeltaUpdateTotals();
                    end;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                    Visible = false;
                }
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
                field(Control50; Rec.Reserve)
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies whether a reservation can be made for items on this line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate();
                    end;
                }
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
                    // trigger OnValidate()
                    // var
                    //     ItemRec: Record Item;
                    //     FindNext: Boolean; // YF 21 Mar 2022
                    // begin
                    //     FindNext := true; // YF 21 Mar 2022

                    //     if (Rec.Type = Rec.Type::Item) and
                    //                    (Rec."No." <> '') and
                    //                    (Rec."Order Qty" <> 0) then begin
                    //         if Rec."Order Qty" <> xRec."Order Qty" then begin

                    //             // YF 25 Feb 2022
                    //             if RollOutChanges0 then begin
                    //                 if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                    //                     TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomizedV2(Rec, FindNext); // YF 21 Mar 2022 // Added FindNext parameter
                    //                     CurrPage.Update(true);
                    //                 end else begin
                    //                     // take from item card price
                    //                     if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                    //                         ItemRec.reset;
                    //                         ItemRec.SetLoadFields("No.", "Unit Price");      //DX        24 May 2023
                    //                         if ItemRec.Get(Rec."No.") then begin
                    //                             Rec.Validate(Quantity, Rec."Order Qty");
                    //                             Rec.Validate("FOC Qty", 0);
                    //                             Rec.Validate("Selling Price", ItemRec."Unit Price");
                    //                             Rec.Validate("Unit Price", ItemRec."Unit Price");
                    //                             // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                    //                             CurrPage.Update(true);
                    //                         end;
                    //                     end;
                    //                 end;
                    //             end
                    //             else begin
                    //                 if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                    //                     TradeCU.UpdateSLLineFOCQtyAndAmt_PMPCustomized(Rec);
                    //                     CurrPage.Update(true);
                    //                 end else begin
                    //                     // take from item card price
                    //                     if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                    //                         ItemRec.reset;
                    //                         ItemRec.SetLoadFields("No.", "Unit Price");      //DX        24 May 2023
                    //                         if ItemRec.Get(Rec."No.") then begin
                    //                             Rec.Validate(Quantity, Rec."Order Qty");
                    //                             Rec.Validate("FOC Qty", 0);
                    //                             Rec.Validate("Selling Price", ItemRec."Unit Price");
                    //                             Rec.Validate("Unit Price", ItemRec."Unit Price");
                    //                             // PLRec.Validate("Line Discount %", PriceListLineRec."Line Discount %");
                    //                             CurrPage.Update(true);
                    //                         end;
                    //                     end;
                    //                 end;
                    //             end;
                    //             // YF 25 Feb 2022

                    //             if (Rec."Order Qty" = 0) then begin
                    //                 Rec.Validate("Unit Price", 0);
                    //                 Rec.Validate("Selling Price", 0);
                    //                 Rec.Validate("FOC Qty", 0);
                    //                 Rec.Modify(TRUE);
                    //             end;

                    //             //DX        27 Jun 2021
                    //             EnhanceCU.ExpirationLessThan12MthsWithLoc(Rec."No.", Rec."Location Code");
                    //             //DX        27 Jun 2021
                    //             TradeCU.RequireMaxQtyApproval(Rec);


                    //         end else
                    //             if (Rec."Order Qty" = 0) then begin
                    //                 Rec.Validate("Unit Price", 0);
                    //                 Rec.Validate("Selling Price", 0);
                    //                 Rec.Validate("FOC Qty", 0);
                    //                 Rec.Modify(TRUE);
                    //             end;
                    //     end else begin
                    //         //DX        27 Jun 2021
                    //         Rec.Validate(Quantity, Rec."Order Qty");
                    //         Rec.Validate("Selling Price", Rec."Unit Price"); // YF 06 Sept 2021
                    //                                                          //DX        27 Jun 2021
                    //     end;

                    //     if TradeCU.IsPromoPrice(Rec) then
                    //         FieldStyle := 'Attention'
                    //     else
                    //         FieldStyle := 'none';

                    //     // YF 06 Aug 2021 // Temp Fix for Issue #80
                    //     if (Rec."Selling Price" = 0) Or (Rec."Unit Price" = 0) And (Rec."Order Qty" > 0) then
                    //         Rec.Validate(Quantity, Rec."Order Qty");
                    //     // YF 06 Aug 2021 // Temp Fix for Issue #80

                    //     // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                    //     Rec."Qty To Deliver" := Rec."Order Qty" - Rec."Qty Delivered";
                    //     Rec."FOC (Qty) To Deliver" := Rec."FOC Qty" - Rec."FOC Qty Delivered";
                    //     CurrPage.Update();
                    //     // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                    // end;
                }

                field("Selling Price"; Rec."Selling Price")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 2 : 5;
                    BlankZero = true;
                    // StyleExpr = FieldStyle;
                    // Editable = LeadCanEdit;
                    Editable = true;

                    // trigger OnValidate()
                    // var
                    //     OrgLineAmt: Decimal;
                    //     InclFOCUnitPrice: Decimal;
                    //     FindNext: Boolean; // YF 21 Mar 2022
                    // begin
                    //     FindNext := true; // YF 21 Mar 2022

                    //     // YF 21 Oct 2021 // Access Control Checks
                    //     if (Not EnhanceCU.IsCSLead()) And (Rec."Selling Price" <> xRec."Selling Price") then
                    //         Error('Not allowed to edit');
                    //     // YF 21 Oct 2021 // Access Control Checks

                    //     if (Rec.Type = Rec.Type::Item) and
                    //                    (Rec."No." <> '') and
                    //                    (Rec."Order Qty" <> 0) then begin

                    //         // YF 25 Feb 2022
                    //         if RollOutChanges0 then begin
                    //             if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022
                    //                 TradeCU.UpdateSLLineSellPrice(Rec);
                    //                 CurrPage.Update(true);
                    //             end else begin
                    //                 TradeCU.UpdateSLLine(Rec);
                    //             end;
                    //         end
                    //         else begin
                    //             if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                    //                 TradeCU.UpdateSLLineSellPrice(Rec);
                    //                 CurrPage.Update(true);
                    //             end else begin
                    //                 //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                    //                 //Rec.Validate("Unit Price", Rec."Selling Price");
                    //                 //Rec.Validate(Quantity, Rec."Order Qty" + Rec."FOC Qty");
                    //                 //Rec.Modify(TRUE);
                    //                 TradeCU.UpdateSLLine(Rec);
                    //                 //DX        17 Jun 2021 : If user enters the selling price but got no valid trade agreement.
                    //             end;
                    //         end;
                    //         // YF 25 Feb 2022               

                    //     end else begin
                    //         //DX        27 Jun 2021
                    //         Rec.Validate("Unit Price", Rec."Selling Price");
                    //         //DX        27 Jun 2021
                    //     end;

                    //     //DX        15 Aug 2021
                    //     Rec."To Del. Amt" := Rec."Qty To Deliver" * Rec."Selling Price";
                    //     //DX        15 Aug 2021
                    // end;
                }

                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    BlankZero = true;
                    // trigger OnValidate()
                    // var
                    //     OrgLineAmt: Decimal;
                    //     InclFOCUnitPrice: Decimal;
                    //     FindNext: Boolean; // YF 21 Mar 2022
                    // begin
                    //     FindNext := true; // YF 21 Mar 2022

                    //     if (Rec.Type = Rec.Type::Item) and
                    //                    (Rec."No." <> '') and
                    //                    (Rec."Order Qty" <> 0) then begin

                    //         // YF 25 Feb 2022
                    //         if RollOutChanges0 then begin
                    //             if TradeCU.IsValidSalesAgreement_PMPCustomizedV2(Rec, FindNext) then begin // YF 21 Mar 2022 // Added FindNext parameter
                    //                                                                                        //TradeCU.UpdatePLLineFOCQtyAndAmt(Rec);
                    //                 TradeCU.UpdateSLLineFromFOCQty(Rec);
                    //                 CurrPage.Update(true);
                    //             end else begin
                    //                 //DX    18 Jun 2021 : Tweaking                            
                    //                 TradeCU.UpdateSLLine(Rec);
                    //                 //DX    18 Jun 2021 : Tweaking
                    //             end;
                    //         end
                    //         else begin
                    //             if TradeCU.IsValidSalesAgreement_PMPCustomized(Rec) then begin
                    //                 //TradeCU.UpdatePLLineFOCQtyAndAmt(Rec);
                    //                 TradeCU.UpdateSLLineFromFOCQty(Rec);
                    //                 CurrPage.Update(true);
                    //             end else begin
                    //                 //DX    18 Jun 2021 : Tweaking                            
                    //                 TradeCU.UpdateSLLine(Rec);
                    //                 //DX    18 Jun 2021 : Tweaking
                    //             end;
                    //         end;
                    //         // YF 25 Feb 2022

                    //     end else begin
                    //         if (Rec.Type = Rec.Type::Item) and
                    //             (Rec."No." <> '') and
                    //             (Rec."Order Qty" = 0) then
                    //             Rec.Validate(Quantity, Rec."FOC Qty");

                    //     end;

                    //     // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver
                    //     Rec."Qty To Deliver" := Rec."Order Qty" - Rec."Qty Delivered";
                    //     Rec."FOC (Qty) To Deliver" := Rec."FOC Qty" - Rec."FOC Qty Delivered";
                    //     // YF 30 Jul 2021 // Bypass to update default Qty to Deliver and FOC Qty to Deliver

                    // end;
                    // //DX        15 Aug 2021

                    // //DX        15 Aug 2021
                }
                field("Remarks"; Rec."I9G Remarks")
                {
                    ApplicationArea = All;
                    Caption = 'Remarks';
                }
                field("Qty To Deliver"; Rec."Qty To Deliver")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Style = Attention;
                    // trigger OnValidate()
                    // begin
                    //     if Rec."Order Qty" - Rec."Qty Delivered" < Rec."Qty To Deliver" then
                    //         Error('Cannot amend more than %1 units', Rec."Order Qty" - Rec."Qty Delivered");
                    //     if rec."FOC (Qty) To Deliver" < 0 then
                    //         Error('Cannot enter negative quantity.');
                    //     //DX        15 Aug 2021
                    //     Rec."To Del. Amt" := Rec."Qty To Deliver" * Rec."Selling Price";
                    //     //DX        15 Aug 2021

                    //     UpdateQtytoShipOrInvoice(); // YF 06 Sept 2021
                    // end;
                }

                field("FOC (Qty) To Deliver"; Rec."FOC (Qty) To Deliver")
                {
                    ApplicationArea = all;
                    Caption = 'FOC Qty To Deliver';
                    DecimalPlaces = 0 : 5;
                    Style = Attention;
                    // trigger OnValidate()
                    // begin
                    //     if Rec."FOC Qty" - rec."FOC Qty Delivered" < Rec."FOC (Qty) To Deliver" then
                    //         Error('Cannot amend more than %1 units', rec."FOC Qty Delivered" - Rec."FOC Qty");
                    //     if rec."FOC (Qty) To Deliver" < 0 then
                    //         Error('Cannot enter negative quantity.');

                    //     UpdateQtytoShipOrInvoice(); // YF 06 Sept 2021
                    // end;
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
                    // StyleExpr = POImportPriceStyle;
                }
                // YF 25 Aug 2021

                // YF 14 Oct 2021
                field("Out of Stock"; Rec."Out of Stock")
                {
                    ApplicationArea = All;
                    Caption = 'Out of Stock';
                    Style = Favorable;
                    // StyleExpr = OOSBool;
                    Editable = false;
                }

                field("Insufficient Stocks in Pick"; Rec."Insufficient Stocks in Pick")
                {
                    ApplicationArea = All;
                    Caption = 'Insufficient Stocks in Active Area';
                    Style = Favorable;
                    // StyleExpr = IStkBool;
                    Editable = false;
                }
                // YF 14 Oct 2021
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsCommentLine;
                    Enabled = not IsCommentLine;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies how many units are being sold.';

                    AboutTitle = 'How much is being ordered';
                    AboutText = 'The quantity on a line specifies how much of an item a customer is ordering. This quantity determines whether the order qualifies for special prices or discounts.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate();
                        DeltaUpdateTotals();
                        SetItemChargeFieldsStyle();
                        if SalesSetup."Calc. Inv. Discount" and (Rec.Quantity = 0) then
                            CurrPage.Update(false);
                    end;
                }
                field("Qty. to Assemble to Order"; Rec."Qty. to Assemble to Order")
                {
                    ApplicationArea = Assembly;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the sales line quantity that you want to supply by assembly.';
                    Visible = true;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowAsmToOrderLines();
                    end;

                    trigger OnValidate()
                    begin
                        QtyToAsmToOrderOnAfterValidate();
                    end;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                }
                field(I9G_TotalReservedQty; Rec.I9G_TotalReservedQty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Reserved Qty field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    QuickEntry = false;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValidate();
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure for the item or resource on the sales line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                // field(SalesPriceExist; Rec.PriceExists())
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Sales Price Exists';
                //     Editable = false;
                //     ToolTip = 'Specifies that there is a specific price for this customer.';
                //     Visible = false;
                // }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies the price for one unit on the sales line.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = SalesTax;
                    Editable = false;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    Visible = false;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = SalesTax;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = SalesTax;
                    Editable = not IsCommentLine;
                    Enabled = not IsCommentLine;
                    ShowMandatory = Rec."Tax Area Code" <> '';
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Allocation Account No."; Rec."Selected Alloc. Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Allocation Account No.';
                    ToolTip = 'Specifies the allocation account number that will be used to distribute the amounts during the posting process.';
                    Visible = UseAllocationAccountNumber;
                    trigger OnValidate()
                    var
                        SalesAllocAccMgt: Codeunit "Sales Alloc. Acc. Mgt.";
                    begin
                        SalesAllocAccMgt.VerifySelectedAllocationAccountNo(Rec);
                    end;
                }
                // field(SalesLineDiscExists; Rec.LineDiscExists())
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Sales Line Disc. Exists';
                //     Editable = false;
                //     ToolTip = 'Specifies that there is a specific discount for this customer.';
                //     Visible = false;
                // }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the prepayment percentage to use to calculate the prepayment for sales.';
                    Visible = false;
                }
                field("Prepmt. Line Amount"; Rec."Prepmt. Line Amount")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the prepayment amount of the line in the currency of the sales document if a prepayment percentage is specified for the sales line.';
                    Visible = false;
                }
                field("Prepmt. Amt. Inv."; Rec."Prepmt. Amt. Inv.")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the prepayment amount that has already been invoiced to the customer for this sales line.';
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
                        InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                        ValidateInvoiceDiscountAmount();
                    end;
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total calculated invoice discount amount for the line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Inv. Disc. Amount to Invoice"; Rec."Inv. Disc. Amount to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the actual invoice discount amount that will be posted for the line in next invoice.';
                    Visible = false;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of items that remain to be shipped.';

                    AboutTitle = 'Partially shipping the order?';
                    AboutText = 'If you want to ship only parts of the order, adjust the *Qty. to Ship* value to that quantity. By common default, the total quantity is shipped.';

                    trigger OnValidate()
                    begin
                        SetItemChargeFieldsStyle();
                        if Rec."Qty. to Asm. to Order (Base)" <> 0 then begin
                            CurrPage.SaveRecord();
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';

                    trigger OnDrillDown()
                    var
                        SalesShipmentLine: Record "Sales Shipment Line";
                    begin
                        SalesShipmentLine.SetCurrentKey("Document No.", "No.", "Shipment Date");
                        SalesShipmentLine.SetRange("Order No.", Rec."Document No.");
                        SalesShipmentLine.SetRange("Order Line No.", Rec."Line No.");
                        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
                        Page.RunModal(0, SalesShipmentLine);
                    end;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';

                    AboutTitle = 'Invoicing more or less than you ship?';
                    AboutText = 'Adjust the *Qty. to Invoice* to specify the quantity you want to invoice now. If that is more than you ship, use the prepayment functionality.';

                    trigger OnValidate()
                    begin
                        SetItemChargeFieldsStyle();
                    end;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';

                    trigger OnDrillDown()
                    var
                        SalesInvoiceLine: Record "Sales Invoice Line";
                    begin
                        SalesInvoiceLine.SetCurrentKey("Document No.", "No.", "Posting Date");
                        SalesInvoiceLine.SetRange("Order No.", Rec."Document No.");
                        SalesInvoiceLine.SetRange("Order Line No.", Rec."Line No.");
                        SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                        Page.RunModal(0, SalesInvoiceLine);
                    end;
                }
                field("Prepmt Amt to Deduct"; Rec."Prepmt Amt to Deduct")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
                    Visible = false;
                }
                field("Prepmt Amt Deducted"; Rec."Prepmt Amt Deducted")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; Rec."Allow Item Charge Assignment")
                {
                    ApplicationArea = ItemCharges;
                    ToolTip = 'Specifies that you can assign item charges to this line.';
                    Visible = false;
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    ApplicationArea = ItemCharges;
                    QuickEntry = false;
                    StyleExpr = ItemChargeStyleExpression;
                    ToolTip = 'Specifies how many units of the item charge are assigned to the line originally.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord();
                        Rec.ShowItemChargeAssgnt();
                        UpdateForm(false);
                    end;
                }
                field("Item Charge Qty. to Handle"; Rec."Item Charge Qty. to Handle")
                {
                    ApplicationArea = ItemCharges;
                    QuickEntry = false;
                    StyleExpr = ItemChargeToHandleStyleExpression;
                    ToolTip = 'Specifies how many items the item charge will be assigned to on the line. It can be either equal to Qty. to Assign or to zero. If it is zero, the item charge will not be assigned to the line.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord();
                        Rec.ShowItemChargeAssgnt();
                        UpdateForm(false);
                    end;
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTip = 'Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord();
                        Rec.ShowItemChargeAssgnt();
                        CurrPage.Update(false);
                    end;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Planning;
                    QuickEntry = false;
                    ToolTip = 'Specifies the planned date that the shipment will be delivered at the customer''s address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.';

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the date that the shipment should ship from the warehouse. If the customer requests a delivery date, the program calculates the planned shipment date by subtracting the shipping time from the requested delivery date. If the customer does not request a delivery date or the requested delivery date cannot be met, the program calculates the content of this field by adding the shipment time to the shipping date.';

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate();
                    end;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
                    Visible = false;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.';
                    Visible = false;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.';
                    Visible = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which work type the resource applies to when the sale is related to a project.';
                    Visible = false;
                }
                field("Whse. Outstanding Qty."; Rec."Whse. Outstanding Qty.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how many units on the sales order line remain to be handled in warehouse documents.';
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)"; Rec."Whse. Outstanding Qty. (Base)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how many units on the sales order line remain to be handled in warehouse documents.';
                    Visible = false;
                }
                field("ATO Whse. Outstanding Qty."; Rec."ATO Whse. Outstanding Qty.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how many assemble-to-order units on the sales order line need to be assembled and handled in warehouse documents.';
                    Visible = false;
                }
                field("ATO Whse. Outstd. Qty. (Base)"; Rec."ATO Whse. Outstd. Qty. (Base)")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies how many assemble-to-order units on the sales order line remain to be assembled and handled in warehouse documents.';
                    Visible = false;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date.';
                    Visible = false;
                }
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the blanket order that the record originates from.';
                    Visible = false;
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the blanket order line that the record originates from.';
                    Visible = false;
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date that will be used on related fixed asset ledger entries.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies if depreciation was calculated until the FA posting date of the line.';
                    Visible = false;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Use Duplication List"; Rec."Use Duplication List")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. ';
                    Visible = false;
                }
                field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
                    Visible = false;
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
                    Visible = false;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = Suite;
                    Enabled = (Rec.Type <> Rec.Type::"Fixed Asset") and (Rec.Type <> Rec.Type::" ");
                    TableRelation = "Deferral Template"."Deferral Code";
                    ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        CurrPage.SaveRecord();
                        Commit();
                        Rec.ShowDeferralSchedule();
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                                  "Dimension Value Type" = const(Standard),
                                                                                  Blocked = const(false));
                    Visible = DimVisible3;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimension(3);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                                  "Dimension Value Type" = const(Standard),
                                                                                  Blocked = const(false));
                    Visible = DimVisible4;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimension(4);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                                  "Dimension Value Type" = const(Standard),
                                                                                  Blocked = const(false));
                    Visible = DimVisible5;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimension(5);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                                  "Dimension Value Type" = const(Standard),
                                                                                  Blocked = const(false));
                    Visible = DimVisible6;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimension(6);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                                  "Dimension Value Type" = const(Standard),
                                                                                  Blocked = const(false));
                    Visible = DimVisible7;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimension(7);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                                  "Dimension Value Type" = const(Standard),
                                                                                  Blocked = const(false));
                    Visible = DimVisible8;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimension(8);
                    end;
                }
                field("Special Order Purchase No."; Rec."Special Order Purchase No.")
                {
                    ApplicationArea = All;
                }
                field("Special Order Purch. Line No."; Rec."Special Order Purch. Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    Caption = 'Unit Gross Weight';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the gross weight of one unit of the item. In the sales statistics window, the gross weight on the line is included in the total gross weight of all the lines for the particular sales document.';
                    Visible = false;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    Caption = 'Unit Net Weight';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the net weight of one unit of the item. In the sales statistics window, the net weight on the line is included in the total net weight of all the lines for the particular sales document.';
                    Visible = false;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the volume of one unit of the item. In the sales statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular sales document.';
                    Visible = false;
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units per parcel of the item. In the sales statistics window, the number of units per parcel on the line helps to determine the total number of units for all the lines for the particular sales document.';
                    Visible = false;
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line number to which this sales line is attached.';
                    Visible = false;
                }
                field("Attached Lines Count"; Rec."Attached Lines Count")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of non-inventory product lines attached to the sales line.';
                    Visible = AttachingLinesEnabled;
                }
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
            group(Control51)
            {
                ShowCaption = false;
                group(Control45)
                {
                    ShowCaption = false;
#pragma warning disable AA0100
                    field("TotalSalesLine.""Line Amount"""; TotalSalesLine."Line Amount")
#pragma warning restore AA0100
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
                    }
                    field("Invoice Discount Amount"; InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(Rec.FieldCaption("Inv. Discount Amount"), Currency.Code);
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            DocumentTotals.SalesDocTotalsNotUpToDate();
                            ValidateInvoiceDiscountAmount();
                        end;
                    }
                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 3;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is applied to the invoice, based on sales lines where the Allow Invoice Disc. field is selected. The percentage and criteria are defined in the Customer Invoice Discounts page, but you can enter or change the percentage manually.';

                        trigger OnValidate()
                        begin
                            DocumentTotals.SalesDocTotalsNotUpToDate();
                            AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
                            InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount();
                        end;
                    }
                }
                group(Control28)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                }
            }
        }
    }

    actions
    {

    }

    trigger OnAfterGetCurrRecord()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAfterGetCurrRecord(Rec, IsHandled, TotalSalesHeader, Currency);
        if IsHandled then
            exit;

        GetTotalSalesHeader();
        CalculateTotals();
        SetLocationCodeMandatory();
        UpdateEditableOnRow();
        UpdateTypeText();
        SetItemChargeFieldsStyle();
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record "Item";
        ItemRec: Record Item;
        MiniShelf: Record MinimumShelf;
        SHRec: Record "Sales Header";
        EnhanceCU: Codeunit "PMP-Enhancements";
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateEditableOnRow();
        UpdateTypeText();
        SetItemChargeFieldsStyle();
        if Rec."Variant Code" = '' then
            VariantCodeMandatory := Item.IsVariantMandatory(Rec.Type = Rec.Type::Item, Rec."No.");

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

        GetFirstItemTrackingLineData();

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

    trigger OnDeleteRecord(): Boolean
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
    begin
        if Rec.Quantity <> 0 then
            if Rec.ItemExists(Rec."No.") then begin
                if not SalesLineReserve.DeleteLineConfirm(Rec) then
                    exit(false);

                OnBeforeDeleteReservationEntries(Rec);
                SalesLineReserve.DeleteLine(Rec);
            end;
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        Rec.AddLoadFields(
            "Price Calculation Method", "Sell-to Customer No.", "Customer Disc. Group", "Customer Price Group",
            "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group",
            "Dimension Set ID", "Currency Code", "Qty. per Unit of Measure", "Allow Line Disc.");

        DocumentTotals.SalesCheckAndClearTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        exit(Rec.Find(Which));
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        SalesSetup.Get();
        Currency.InitRoundingPrecision();
        TempOptionLookupBuffer.FillLookupBuffer(Enum::"Option Lookup Type"::Sales);
        TypeAsTextFieldVisible := ApplicationAreaMgmtFacade.IsFoundationEnabled() and not ApplicationAreaMgmtFacade.IsAdvancedEnabled();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.InitType();
        SetDefaultType();

        Clear(ShortcutDimCode);
        UpdateTypeText();
    end;

    trigger OnOpenPage()
    var
        AllocationAccountMgt: Codeunit "Allocation Account Mgt.";
    begin
        UseAllocationAccountNumber := AllocationAccountMgt.UseAllocationAccountNoField();
        SetOpenPage();

        SetDimensionsVisibility();
        SetItemReferenceVisibility();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesAvailabilityMgt: Codeunit "Sales Availability Mgt.";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        AmountWithDiscountAllowed: Decimal;
#pragma warning disable AA0074
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
#pragma warning restore AA0074
        VariantCodeMandatory: Boolean;
        LocationCodeVisible: Boolean;
        CurrPageIsEditable: Boolean;
        BackgroundErrorCheck: Boolean;
        ShowAllLinesEnabled: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        ExtendedPriceEnabled: Boolean;
        AttachingLinesEnabled: Boolean;
        UpdateInvDiscountQst: Label 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
        ItemChargeStyleExpression: Text;
        ItemChargeToHandleStyleExpression: Text;
        TypeAsText: Text[30];
        TypeAsTextFieldVisible: Boolean;
        UseAllocationAccountNumber: Boolean;
        ActionOnlyAllowedForAllocationAccountsErr: Label 'This action is only available for lines that have Allocation Account set as Type.';
        ExcelFileNameTxt: Label 'Sales Order %1 - Lines', Comment = '%1 = document number, ex. 10000';

    protected var
        Currency: Record Currency;
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        DocumentTotals: Codeunit "Document Totals";
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        InvDiscAmountEditable: Boolean;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        IsCommentLine: Boolean;
        IsBlankNumber: Boolean;
        ItemReferenceVisible: Boolean;
        LocationCodeMandatory: Boolean;
        SuppressTotals: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        AttachToInvtItemEnabled: Boolean;
        VATAmount: Decimal;
        ExprDate: Text[100];
        Status: Text[100];
        VarMinShelf: Date;
        SelectedItemTrackingLot: Code[50];
        SelectedExpiry: Date;

    local procedure SetOpenPage()
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        Location: Record Location;
        ServerSetting: Codeunit "Server Setting";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
    begin
        OnBeforeSetOpenPage();

        if Location.ReadPermission then
            LocationCodeVisible := not Location.IsEmpty();

        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
        BackgroundErrorCheck := DocumentErrorsMgt.BackgroundValidationEnabled();
        AttachingLinesEnabled :=
            SalesSetup."Auto Post Non-Invt. via Whse." = SalesSetup."Auto Post Non-Invt. via Whse."::"Attached/Assigned";
    end;

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if SuppressTotals then
            exit;

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if SalesHeader.Status = SalesHeader.Status::"Pending Approval" then
            SalesHeader.FieldError(SalesHeader.Status);
        if SalesHeader.InvoicedLineExists() then
            if not ConfirmManagement.GetResponseOrDefault(UpdateInvDiscountQst, true) then
                exit;

        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        DocumentTotals.SalesDocTotalsNotUpToDate();
        CurrPage.Update(false);
    end;

    procedure CalcInvDisc()
    var
        SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
    begin
        SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure ExplodeBOM()
    begin
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
        IsHandled: Boolean;
        PageEditable: Boolean;
    begin
        IsHandled := false;
        OnBeforeOpenPurchOrderForm(Rec, PageEditable, IsHandled);
        if IsHandled then
            exit;

        Rec.TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", Rec."Purchase Order No.");
        PurchOrder.SetTableView(PurchHeader);
        PurchOrder.Editable := PageEditable;
        PurchOrder.Run();
    end;

    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
        IsHandled: Boolean;
        PageEditable: Boolean;
    begin
        IsHandled := false;
        OnBeforeOpenSpecialPurchOrderForm(Rec, PageEditable, IsHandled);
        if IsHandled then
            exit;

        Rec.TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.", Rec."Special Order Purchase No.");
        if not PurchHeader.IsEmpty() then begin
            PurchOrder.SetTableView(PurchHeader);
            PurchOrder.Editable := PageEditable;
            PurchOrder.Run();
        end else begin
            PurchRcptHeader.SetRange("Order No.", Rec."Special Order Purchase No.");
            if PurchRcptHeader.Count = 1 then
                PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            else
                PAGE.Run(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        end;
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        OnBeforeInsertExtendedText(Rec);
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord();
            Commit();
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        OnInsertExtendedTextOnAfterInsertSalesExtText(Rec);

        if TransferExtendedText.MakeUpdate() then
            UpdateForm(true);
    end;

    procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock();
    end;

    procedure ShowTracking()
    begin
        Rec.ShowOrderTracking();
    end;

    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt();
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure ShowPrices()
    begin
        Rec.PickPrice();
        UpdateForm(true);
    end;

    procedure ShowLineDisc()
    begin
        Rec.PickDiscount();
    end;

    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SetRange("Source Type", Rec."Document Type");
        OrderPromisingLine.SetRange("Source ID", Rec."Document No.");
        OrderPromisingLine.SetRange("Source Line No.", Rec."Line No.");

        OrderPromisingLines.SetSource(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SetTableView(OrderPromisingLine);
        OrderPromisingLines.RunModal();
    end;

    procedure NoOnAfterValidate()
    begin
        OnBeforeNoOnAfterValidate(Rec, xRec);

        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();

        OnNoOnAfterValidateOnBeforeSaveAndAutoAsmToOrder();

        SaveAndAutoAsmToOrder();

        OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder(Rec);

        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            if (Rec."Outstanding Qty. (Base)" <> 0) and (Rec."No." <> xRec."No.") then begin
                Rec.AutoReserve();
                CurrPage.Update(false);
            end;
        end;

        OnAfterNoOnAfterValidate(Rec, xRec);
    end;

    protected procedure VariantCodeOnAfterValidate()
    begin
        OnBeforeVariantCodeOnAfterValidate(Rec, xRec);
        SaveAndAutoAsmToOrder();
    end;

    procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder();

        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Location Code" <> xRec."Location Code")
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;

        OnAfterLocationCodeOnAfterValidate(Rec, xRec);
    end;

    protected procedure ReserveOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and (Rec."Outstanding Qty. (Base)" <> 0) then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
        end;
    end;

    protected procedure QuantityOnAfterValidate()
    begin
        OnBeforeQuantityOnAfterValidate(Rec, xRec);

        if Rec.Type = Rec.Type::Item then begin
            CurrPage.SaveRecord();
            case Rec.Reserve of
                Rec.Reserve::Always:
                    Rec.AutoReserve();
            end;
        end;

        OnAfterQuantityOnAfterValidate(Rec, xRec);
    end;

    protected procedure QtyToAsmToOrderOnAfterValidate()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeQtyToAsmToOrderOnAfterValidate(Rec, IsHandled);
        if IsHandled then
            exit;

        CurrPage.SaveRecord();
        if Rec.Reserve = Rec.Reserve::Always then
            Rec.AutoReserve();
        CurrPage.Update(true);
    end;

    protected procedure UnitofMeasureCodeOnAfterValidate()
    begin
        OnBeforeUnitofMeasureCodeOnAfterValidate(Rec, xRec);

        DeltaUpdateTotals();
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;

        OnAfterUnitofMeasureCodeOnAfterValidate(Rec, xRec);
    end;

    protected procedure ShipmentDateOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Shipment Date" <> xRec."Shipment Date")
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end else
            CurrPage.Update(true);
    end;

    protected procedure SaveAndAutoAsmToOrder()
    begin
        if (Rec.Type = Rec.Type::Item) and Rec.IsAsmToOrderRequired() then begin
            CurrPage.SaveRecord();
            Rec.AutoAsmToOrder();
            CurrPage.Update(false);
        end;
    end;

    procedure ShowDocumentLineTracking()
    var
        DocumentLineTrackingPage: Page "Document Line Tracking";
    begin
        Clear(DocumentLineTrackingPage);
        DocumentLineTrackingPage.SetSourceDoc(
            "Document Line Source Type"::"Sales Order", Rec."Document No.", Rec."Line No.", Rec."Blanket Order No.", Rec."Blanket Order Line No.", '', 0);
        DocumentLineTrackingPage.RunModal();
    end;

    local procedure SetLocationCodeMandatory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        LocationCodeMandatory := InventorySetup."Location Mandatory" and (Rec.Type = Rec.Type::Item);
    end;

    local procedure GetTotalSalesHeader()
    begin
        DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
    end;

    procedure ClearTotalSalesHeader();
    begin
        Clear(TotalSalesHeader);
    end;

    procedure CalculateTotals()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalculateTotals(Rec, IsHandled, DocumentTotals, SuppressTotals);
        if IsHandled then
            exit;

        if SuppressTotals then
            exit;

        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshSalesLine(Rec);
    end;

    procedure DeltaUpdateTotals()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeltaUpdateTotals(Rec, IsHandled, xRec, SuppressTotals);
        if IsHandled then
            exit;

        if SuppressTotals then
            exit;

        DocumentTotals.SalesDeltaUpdateTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        if Rec."Line Amount" <> xRec."Line Amount" then
            Rec.SendLineInvoiceDiscountResetNotification();
    end;

    procedure ForceTotalsCalculation()
    begin
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure RedistributeTotalsOnAfterValidate()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SuppressTotals then
            exit;

        CurrPage.SaveRecord();

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.Update(false);
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := not Rec.HasTypeToFillMandatoryFields();
        IsBlankNumber := IsCommentLine;
        UnitofMeasureCodeIsChangeable := not IsCommentLine;
        if AttachingLinesEnabled then
            AttachToInvtItemEnabled := not Rec.IsInventoriableItem();

        CurrPageIsEditable := CurrPage.Editable;
        InvDiscAmountEditable :=
            CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount" and
            (TotalSalesHeader.Status = TotalSalesHeader.Status::Open);

        OnAfterUpdateEditableOnRow(Rec, IsCommentLine, IsBlankNumber);
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        if not TypeAsTextFieldVisible then
            exit;

        OnBeforeUpdateTypeText(Rec);

        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Type)));
    end;

    local procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        ItemChargeToHandleStyleExpression := '';
        if Rec.AssignedItemCharge() then begin
            if Rec."Qty. To Assign" <> (Rec.Quantity - Rec."Qty. Assigned") then
                ItemChargeStyleExpression := 'Unfavorable';
            if Rec."Item Charge Qty. to Handle" <> Rec."Qty. to Invoice" then
                ItemChargeToHandleStyleExpression := 'Unfavorable';
        end;
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);

        OnAfterSetDimensionsVisibility();
    end;

    local procedure SetItemReferenceVisibility()
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReferenceVisible := not ItemReference.IsEmpty();
    end;

    local procedure SetDefaultType()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetDefaultType(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if xRec."Document No." = '' then
            Rec.Type := Rec.GetDefaultLineType();
    end;

    local procedure ValidateShortcutDimension(DimIndex: Integer)
    var
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        Rec.ValidateShortcutDimCode(DimIndex, ShortcutDimCode[DimIndex]);
        AssembleToOrderLink.UpdateAsmDimFromSalesLine(Rec);

        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, DimIndex);
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

    [IntegrationEvent(true, false)]
    local procedure OnAfterNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterLocationCodeOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateEditableOnRow(SalesLine: Record "Sales Line"; var IsCommentLine: Boolean; var IsBlankNumber: Boolean);
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterValidateDescription(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var SalesLine: Record "Sales Line"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeDeleteReservationEntries(var SalesLine: Record "Sales Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertExtendedText(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetDefaultType(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateTypeText(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReferenceNoOnAfterLookup(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnNoOnAfterValidateOnBeforeSaveAndAutoAsmToOrder()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeQtyToAsmToOrderOnAfterValidate(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAfterGetCurrRecord(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; var TotalSalesHeader: Record "Sales Header"; var Currency: Record Currency)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateTotals(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; var DocumentTotals: Codeunit "Document Totals"; var SuppressTotals: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenPurchOrderForm(SalesOrderLine: Record "Sales Line"; var PageEditable: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenSpecialPurchOrderForm(SalesOrderLine: Record "Sales Line"; var PageEditable: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeSetOpenPage()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetDimensionsVisibility();
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeDeltaUpdateTotals(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; SuppressTotals: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeVariantCodeOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeUnitofMeasureCodeOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterUnitofMeasureCodeOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertExtendedTextOnAfterInsertSalesExtText(SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeValidateNo(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;
}

