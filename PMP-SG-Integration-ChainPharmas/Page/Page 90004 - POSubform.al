page 90004 "Chain Pharma PO Subform"
{

    AutoSplitKey = true;
    Caption = 'Chain Pharma Purchase Order Subform';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Chain PO Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("SO Created "; Rec."SO Created")
                {
                    ApplicationArea = all;

                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("PO Entry No."; Rec."PO Entry No.")
                {
                    ToolTip = 'Specifies the value of the PO Entry No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("PO Number"; Rec."PO Number")
                {
                    ToolTip = 'Specifies the value of the PO Number field';
                    ApplicationArea = All;
                }
                field("Item Line No."; Rec."Item Line No.")
                {
                    ToolTip = 'Specifies the value of the Item Line No. field';
                    ApplicationArea = All;
                }
                field("Buyer Item Code "; Rec."Buyer Item Code")
                {
                    ToolTip = 'Specifies the value of the Buyer Item Code  field';
                    ApplicationArea = All;
                }
                field("Supplier Item Code "; Rec."Supplier Item Code")
                {
                    ToolTip = 'Specifies the value of the Supplier Item Code  field';
                    ApplicationArea = All;
                }
                field(Barcode; Rec.Barcode)
                {
                    ToolTip = 'Specifies the value of the Barcode field';
                    ApplicationArea = All;
                }
                field("Item Description "; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description  field';
                    ApplicationArea = All;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field';
                    ApplicationArea = All;
                }
                field("Pack Size "; Rec."Pack Size")
                {
                    ToolTip = 'Specifies the value of the Pack Size  field';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field';
                    ApplicationArea = All;
                }
                field("Order Quantity "; Rec."Order Quantity")
                {
                    ToolTip = 'Specifies the value of the Order Quantity  field';
                    ApplicationArea = All;
                }
                field("Invoice Quantity "; Rec."Invoice Quantity")
                {
                    ToolTip = 'Specifies the value of the Invoice Quantity  field';
                    ApplicationArea = All;
                }
                field("FOC Quantity"; Rec."FOC Quantity")
                {
                    ToolTip = 'Specifies the value of the FOC Quantity field';
                    ApplicationArea = All;
                }
                field("Line Item Total Amount "; Rec."Line Item Total")
                {
                    ToolTip = 'Specifies the value of the Line Item Total  field';
                    Caption = 'Line Item Total Amount';
                    ApplicationArea = All;
                }

                field("Total Discount Amount"; Rec."Total Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Line Item Total Discount Amount field';
                    ApplicationArea = All;
                }
                field("Total Discount Percentage"; Rec."Total Discount Percentage")
                {
                    ToolTip = 'Specifies the value of the Line Item Total Discount Percentage field';
                    ApplicationArea = All;
                }
                field("Total Amount After Discount"; rec."Total Amount After Discount")
                {
                    ApplicationArea = all;
                }
                field("Last Error Message"; Rec."Last Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Error Message field.', Comment = '%';
                }
            }
        }
    }

}
