page 55079 PharmaPurchasePriceListArchive
{
    ApplicationArea = All;
    Caption = 'Purchase Trade Agreements Archives';
    PageType = List;
    SourceTable = "Pharma Purchase Price Archives";
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

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

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
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }

                // YF 03 Mar 2022
                field("Country of Purchase Code"; Rec."Country of Purchase Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // YF 03 Mar 2022

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RecRefID; Rec.RecRefID)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }


    var
        gFieldStyle: Text[50];
        ItemDesc: Text[100];
        ItemRec: Record item;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';

        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                ItemDesc := ItemRec.Description;
            end else
                ItemDesc := '';
        end;
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
