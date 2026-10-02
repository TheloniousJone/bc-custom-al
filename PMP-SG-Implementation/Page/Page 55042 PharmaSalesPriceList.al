page 55042 PharmaSalesPriceList
{

    ApplicationArea = All;
    Caption = 'Sales Trade Agreements';
    PageType = List;
    SourceTable = "Pharma Sales Price";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sales Type"; Rec."Sales Type")
                {
                    ToolTip = 'Specifies the value of the Sales Type field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ToolTip = 'Specifies the value of the Sales Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                    Editable = false;
                    Visible = true;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Visible = false;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ToolTip = 'Specifies the value of the Minimum Quantity field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;

                    // YF 10 Jun 2022
                    trigger OnValidate()
                    begin
                        if Rec."Minimum Quantity" = 0 then
                            Rec."Minimum Quantity" := 1;
                    end;
                    // YF 10 Jun 2022
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field';
                    StyleExpr = gFieldStyle;

                    // trigger OnValidate()
                    // var
                    //     PrevPharmaSalesPrice: Record "Pharma Sales Price";
                    // begin
                    //     if Rec."Starting Date" = 0D then
                    //         exit;

                    //     // Find the previous record with same Sales Type, Sales Code, Item No. but different Unit Price
                    //     PrevPharmaSalesPrice.Reset();
                    //     PrevPharmaSalesPrice.SetRange("Sales Type", Rec."Sales Type");
                    //     PrevPharmaSalesPrice.SetRange("Sales Code", Rec."Sales Code");
                    //     PrevPharmaSalesPrice.SetRange("Item No.", Rec."Item No.");
                    //     PrevPharmaSalesPrice.SetFilter("Unit Price", '<>%1', Rec."Unit Price");
                    //     PrevPharmaSalesPrice.SetFilter("Starting Date", '<%1', Rec."Starting Date");
                    //     if PrevPharmaSalesPrice.FindLast() then begin
                    //         PrevPharmaSalesPrice."Ending Date" := Rec."Starting Date" - 1;
                    //         PrevPharmaSalesPrice.Modify(true);
                    //     end;
                    // end;
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ToolTip = 'Specifies the value of the Price Includes VAT field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ToolTip = 'Specifies the value of the Allow Line Disc. field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ToolTip = 'Specifies the value of the Allow Invoice Disc field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Gr. (Price) field';
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

                field(RecRefId; Rec.RecRefID)
                {
                    ApplicationArea = all;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }
                //RL    05 Jan 2021
                field(Principal; Principal)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //RL    05 Jan 2021

                // YF 18 Mar 2022
                field("TA Type"; Rec."TA Type")
                {
                    ApplicationArea = All;
                }

                field("Find Next"; Rec."Find Next")
                {
                    ApplicationArea = All;
                }
                // YF 18 Mar 2022
                field(SalesRepWS; SalesRepWS)
                {
                    ApplicationArea = All;
                    caption = 'Sales Rep (WS)';
                }
            }
        }
    }

    var
        gFieldStyle: Text[50];
        ItemRec: Record item;
        ItemDesc: Text[100];
        Principal: Text[100];
        CustomerRec: Record Customer;
        SalesRepWS: Code[20];

    trigger OnInsertRecord(belowxrec: Boolean): Boolean
    var
        myInt: Integer;
        ItemUOM: Record "Item Unit of Measure";
    begin
        //DX        21 May 2025
        if rec."Item No." <> '' then begin
            ItemUOM.reset;
            ItemUOM.SetLoadFields("Item No.", Code, I9G_BlockUOM);
            ItemUOM.SetRange("Item No.", rec."Item No.");
            ItemUOM.SetRange(Code, rec."Unit of Measure Code");
            if ItemUOM.FindFirst() then begin
                if ItemUOM.I9G_BlockUOM = true then
                    Error('Item UOM has been set to blocked for Sales Trade Agreements, please check on this before trying to create the Record');
            end;
        end;
        //DX        21 May 2025
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
    end;

    trigger OnAfterGetRecord()
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
            Principal := ItemRec.Principal;
            if ItemUOM.FindFirst() then begin
                if StrLen(ItemUOM."Alternate Description") > 0 then begin
                    ItemDesc := ItemUOM."Alternate Description";
                end;
            end;
        end;

        CustomerRec.reset;
        SalesRepWS := '';
        CustomerRec.SetRange("No.", Rec."Sales Code");
        if (Rec."Sales Code" <> '') and (Rec."Sales Type" = Rec."Sales Type"::Customer) then begin
            if CustomerRec.FindFirst() then
                SalesRepWS := CustomerRec."Corporate  Sales Rep (WS)";
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Active;
        Rec."Minimum Quantity" := 1; // YF 10 Jun 2022
    end;
}
