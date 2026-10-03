page 59003 POM2SubForm
{

    Caption = 'POM2SubForm';
    PageType = ListPart;
    SourceTable = POM2DetailsTbl;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field';
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name field';
                    ApplicationArea = All;
                }
                field(PurchaseOrderID; Rec.PurchaseOrderID)
                {
                    ToolTip = 'Specifies the value of the PurchaseOrderID field';
                    ApplicationArea = All;
                }
                field(QuantityOrdered; Rec.QuantityOrdered)
                {
                    ToolTip = 'Specifies the value of the QuantityOrdered field';
                    ApplicationArea = All;
                }
                field(BonusQuantity; Rec.BonusQuantity)
                {
                    ToolTip = 'Specifies the value of the BonusQuantity field';
                    ApplicationArea = All;
                }
                field(UOMCode; Rec.UOMCode)
                {
                    ToolTip = 'Specifies the value of the UOMCode field';
                    ApplicationArea = All;
                }
                field(UnitPrice; Rec.UnitPrice)
                {
                    ToolTip = 'Specifies the value of the UnitPrice field';
                    ApplicationArea = All;
                }
                field(ExpiryDate; Rec.ExpiryDate)
                {
                    ToolTip = 'Specifies the value of the ExpiryDate field';
                    ApplicationArea = All;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ToolTip = 'Specifies the value of the Process Remarks field';
                    ApplicationArea = All;
                }
                field("Doc No."; Rec."Doc No.")
                {
                    ToolTip = 'Specifies the value of the Doc No. field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
