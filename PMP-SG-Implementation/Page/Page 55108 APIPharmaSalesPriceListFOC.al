page 55108 APIPharmaSalesPriceListFOC
{

    ApplicationArea = All;
    Caption = 'API Sales Trade Agreements FOC';
    PageType = List;
    SourceTable = "Pharma Sales Price";
    UsageCategory = Lists;
    SourceTableTemporary = true;

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
                    ToolTip = 'Specifies the value of the Starting Date field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
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

                // YF 19 Nov 2021
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                }
                // YF 19 Nov 2021

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }

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
            }
        }
    }

    var
        gFieldStyle: Text[50];
        ItemRec: Record item;
        ItemDesc: Text[100];

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        LoadData();
    end;


    local procedure LoadData()
    var
        myInt: Integer;
        pharmaRec: Record "Pharma Sales Price";
        ItemUOM: Record "Item Unit of Measure";
    begin
        pharmaRec.reset;
        pharmaRec.SetFilter("Item No.", '<>%1', '');
        pharmaRec.SetFilter("FOC Qty", '<>0');
        if pharmaRec.FindSet() then
            repeat
                ItemUOM.reset;
                ItemUOM.SetRange(Code, pharmaRec."Unit Of Measure Code");
                ItemUOM.SetRange("Item No.", pharmaRec."Item No.");
                ItemUOM.SetFilter("Qty. per Unit of Measure", '>=1');
                if ItemUOM.FindFirst() then begin
                    rec.reset;
                    Rec.copy(pharmaRec);
                    Rec.Insert(FALSE);
                end;
            until pharmaRec.next = 0;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
        ItemDesc := '';
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                ItemDesc := ItemRec.Description;
            end else
                ItemDesc := '';
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Active;
    end;
}
