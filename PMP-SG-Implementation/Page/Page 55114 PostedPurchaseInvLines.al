page 55114 PostedPurchaseInvLines
{
    ApplicationArea = All;
    Caption = 'PostedPurchaseInvLines';
    PageType = List;
    SourceTable = "Purch. Inv. Line";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the number of the invoice that this line belongs to.';
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the line type.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies either the name of, or a description of, the item or general ledger account.';
                    ApplicationArea = All;
                }
                field("Order Qty"; Rec."Order Qty")
                {
                    ToolTip = 'Specifies the value of the Order Qty field.';
                    ApplicationArea = All;
                }
                field("FOC Qty"; Rec."FOC Qty")
                {
                    ToolTip = 'Specifies the value of the FOC Qty field.';
                    ApplicationArea = All;
                }
                field("Qty To Deliver"; Rec."Qty To Deliver")
                {
                    ToolTip = 'Specifies the value of the Qty To Deliver field.';
                    ApplicationArea = All;
                }
                field("FOC (Qty) To Deliver"; Rec."FOC (Qty) To Deliver")
                {
                    ToolTip = 'Specifies the value of the FOC (Qty) To Deliver field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity posted from the line.';
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    ApplicationArea = All;
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ToolTip = 'Specifies the value of the Purchase Price field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the line''s net amount.';
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                    ApplicationArea = All;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ToolTip = 'Specifies the value of the VAT Base Amount field.';
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                    ApplicationArea = All;
                }
                field("For Tender"; Rec."For Tender")
                {
                    ToolTip = 'Specifies the value of the For Tender field.';
                    ApplicationArea = All;
                }
                field("Tender Qty"; Rec."Tender Qty")
                {
                    ToolTip = 'Specifies the value of the Tender Qty field.';
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.';
                    ApplicationArea = All;
                }
                field(ShiptoCountry; ShiptoCountry)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    var
        ShiptoCountry: Code[20];

    trigger OnAfterGetRecord()
    var
        PPH: Record "Purch. Inv. Header";
    begin
        Clear(ShiptoCountry);
        PPH.Reset();
        PPH.SetFilter("No.", Rec."Document No.");
        if PPH.FindFirst() then begin
            ShiptoCountry := PPH."Ship-to Country/Region Code";
        end;


    end;
}
