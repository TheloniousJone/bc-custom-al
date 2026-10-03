page 90001 "Chain PO Line"
{

    ApplicationArea = All;
    Caption = 'Chain Staging Line';
    PageType = List;
    SourceTable = "Chain PO Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("PO Entry No."; Rec."PO Entry No.")
                {
                    ToolTip = 'Specifies the value of the PO Entry No. field';
                    ApplicationArea = All;
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
                field("Line Item Total "; Rec."Line Item Total")
                {
                    ToolTip = 'Specifies the value of the Line Item Total field';
                    ApplicationArea = All;
                }
                field("Total Discount Amount"; rec."Total Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Total Discount Amount field';
                    ApplicationArea = All;

                }
                field("Total Discount Percentage"; Rec."Total Discount Percentage")
                {
                    ToolTip = 'Specifies the value of the Total Discount Percentage field';
                    ApplicationArea = All;
                }
                field("Total Amount After Discount"; rec."Total Amount After Discount")
                {
                    ApplicationArea = all;
                }
                field(ChainPOLineTimestamp; Rec.ChainPOLineTimestamp)
                {
                    ToolTip = 'Specifies the value of the ChainPOLineTimestamp field';
                    ApplicationArea = All;
                }
                field("SO Created "; Rec."SO Created")
                {
                    ToolTip = 'Specifies the value of the SO Created  field';
                    ApplicationArea = All;
                }
                field("SO Error"; Rec."SO Error")
                {
                    ToolTip = 'Specifies the value of the SO Error field';
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field';
                    ApplicationArea = All;
                }
                field("Sales Line No."; Rec."Sales Line No.")
                {
                    ToolTip = 'Specifies the value of the Sales Line No. field';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
