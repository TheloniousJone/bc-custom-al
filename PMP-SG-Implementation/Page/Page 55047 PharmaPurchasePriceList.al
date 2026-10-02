page 55047 PharmaPurchasePriceList
{
    ApplicationArea = All;
    Caption = 'Purchase Trade Agreements';
    PageType = List;
    SourceTable = "Pharma Purchase Price";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the vendor who offers the line discount on the item.';
                    StyleExpr = gFieldStyle;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item that the purchase price applies to.';
                    StyleExpr = gFieldStyle;
                }
                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = all;
                    Visible = true;
                    Caption = 'Description';
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;

                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                    StyleExpr = gFieldStyle;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code of the purchase price.';
                    Visible = true;
                    StyleExpr = gFieldStyle;
                }

                // YF 03 Mar 
                field("Country of Purchase Code"; Rec."Country of Purchase Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                    StyleExpr = gFieldStyle;
                }
                // YF 03 Mar 2022

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    StyleExpr = gFieldStyle;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to get the purchase price.';
                    StyleExpr = gFieldStyle;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                    StyleExpr = gFieldStyle;
                }

                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which the purchase price is valid.';
                    StyleExpr = gFieldStyle;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date to which the purchase price is valid.';
                    StyleExpr = gFieldStyle;
                }

                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;

                    trigger OnValidate()
                    begin
                        if Rec.Status = Rec.Status::Active then
                            gFieldStyle := ''
                        else
                            gFieldStyle := 'Attention';
                    end;
                }
                field(RecRefID; Rec.RecRefID)
                {
                    ApplicationArea = all;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                //DX        15 Oct 2021
                field(Principal; Principal)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //DX        15 Oct 2021
            }
        }
    }

    // actions
    actions
    {
        area(Processing)
        {
            action("Reflect Price Changes")
            {
                ApplicationArea = All;
                Image = PriceAdjustment;

                trigger OnAction();
                var
                    // DateQueryPage: Page "Single Date Entry";
                    PageDialog: Page "New Purchase Price Dialog";
                    NewPurchasePrice: Decimal;
                    SalesPriceChangeRec: Record "Sales Price Change Staging";
                begin
                    Clear(PageDialog);
                    PageDialog.SetVendorNo(Rec."Vendor No.");
                    PageDialog.SetItemNo(Rec."Item No.");
                    PageDialog.SetCurrencyCode(Rec."Currency Code");
                    PageDialog.SetVariantCode(Rec."Variant Code");
                    PageDialog.SetUOMCode(Rec."Unit of Measure Code");

                    if PageDialog.RunModal() = Action::OK then begin
                        SalesPriceChangeRec.Reset;
                        SalesPriceChangeRec.SetRange("Item No.", Rec."Item No.");
                        SalesPriceChangeRec.SetRange("Currency Code", Rec."Currency Code");
                        SalesPriceChangeRec.SetRange("Unit Of Measure Code", Rec."Unit of Measure Code");
                        SalesPriceChangeRec.SetRange(Status, SalesPriceChangeRec.Status::Pending);
                        if SalesPriceChangeRec.FindSet() then
                            Page.Run(55077, SalesPriceChangeRec)
                        else
                            Message('No price change record found');
                    end;
                end;

            }
        }
    }

    var
        gFieldStyle: Text[50];
        ItemDesc: Text[100];
        ItemRec: Record item;

    trigger OnAfterGetCurrRecord()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';

        ItemDesc := '';
        ItemRec.reset;
        ItemRec.SetRange("No.", Rec."Item No.");
        ItemUOM.Reset;
        ItemUOM.SetRange("Item No.", Rec."Item No.");
        ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
        if Rec."Item No." <> '' then begin
            if ItemRec.FindFirst() then
                ItemDesc := ItemRec.Description;
            if ItemUOM.FindFirst() then begin
                if StrLen(ItemUOM."Alternate Description") > 0 then begin
                    ItemDesc := ItemUOM."Alternate Description";
                end;
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
        Principal := '';
        ItemDesc := '';
        ItemRec.reset;
        ItemRec.SetRange("No.", Rec."Item No.");
        ItemUOM.Reset;
        ItemUOM.SetRange("Item No.", Rec."Item No.");
        ItemUOM.SetRange(Code, Rec."Unit of Measure Code");
        if Rec."Item No." <> '' then begin
            if ItemRec.FindFirst() then begin
                ItemDesc := ItemRec.Description;
                Principal := ItemRec.Principal;
            end;
            if ItemUOM.FindFirst() then begin
                if StrLen(ItemUOM."Alternate Description") > 0 then begin
                    ItemDesc := ItemUOM."Alternate Description";
                end;
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Active;
    end;

    var
        Principal: Text[100];

}
