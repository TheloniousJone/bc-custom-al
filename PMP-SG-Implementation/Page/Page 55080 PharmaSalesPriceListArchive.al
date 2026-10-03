page 55080 PharmaSalesPriceListArchives
{

    ApplicationArea = All;
    Caption = 'Sales Trade Agreements Archives';
    PageType = List;
    SourceTable = "Pharma Sales Price Archives";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field("Entry Timestamp"; Rec."Entry Timestamp")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RecRefId; Rec.RecRefID)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                // YF 18 Mar 2022
                field("TA Type"; Rec."TA Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Find Next"; Rec."Find Next")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // YF 18 Mar 2022

            }
        }
    }

    var
        gFieldStyle: Text[50];
        ItemRec: Record item;
        ItemDesc: Text[100];

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
}
