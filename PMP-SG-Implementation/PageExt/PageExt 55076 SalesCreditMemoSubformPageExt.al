pageextension 55076 SalesCreditMemoSubformPageExt extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Order Qty"; Rec."Order Qty")
            {
                ApplicationArea = all;
            }
            field("FOC Qty"; Rec."FOC Qty")
            {
                ApplicationArea = all;
            }

            field("Selling Price"; Rec."Selling Price")
            {
                ApplicationArea = ALL;
            }

            field("Qty To Deliver"; Rec."Qty To Deliver")
            {
                ApplicationArea = all;
            }
            field("FOC (Qty) To Deliver"; Rec."FOC (Qty) To Deliver")
            {
                ApplicationArea = all;
            }

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
        TradeCU: Codeunit "Trade Agreement CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
        OrigSellingPrice: Decimal; // YF 15 Dec 2021   
        RollOutChanges0: Boolean; // YF 25 Feb 2022 
}
