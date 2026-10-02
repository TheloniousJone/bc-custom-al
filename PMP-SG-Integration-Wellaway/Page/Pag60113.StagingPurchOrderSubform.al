page 60113 "Incoming Purch Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Incoming Purchase Detials';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Incoming Wellaway PO Line";

    layout
    {
        area(content)
        {
            repeater(Details)
            {
                field("Purchase Order ID"; Rec."Purchase Order ID")
                {
                    ToolTip = 'Specifies the value of the Purchase Order ID field';
                    ApplicationArea = All;
                }
                field("Purchase Line No"; Rec."Purchase Line No")
                {
                    ToolTip = 'Specifies the value of the Purchase Line No field';
                    ApplicationArea = All;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field';
                    ApplicationArea = All;
                }
                field("Product Name "; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name  field';
                    ApplicationArea = All;
                }
                field("Quantity Ordered"; Rec."Quantity Ordered")
                {
                    ToolTip = 'Specifies the value of the Quantity Ordered field';
                    ApplicationArea = All;
                }
                field("Bonus Quantity "; Rec."Bonus Quantity")
                {
                    ToolTip = 'Specifies the value of the Bonus Quantity  field';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field';
                    ApplicationArea = All;
                }
                field("UOM Code"; Rec."UOM Code")
                {
                    ToolTip = 'Specifies the value of the UOM Code field';
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field';
                    ApplicationArea = All;
                }
                field("Instruction of Use"; Rec."Instruction of Use")
                {
                    ToolTip = 'Specifies the value of the Instruction of Use field';
                    ApplicationArea = All;
                }
                field("Precautions "; Rec."Precautions")
                {
                    ToolTip = 'Specifies the value of the Precautions  field';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field';
                    ApplicationArea = All;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}
