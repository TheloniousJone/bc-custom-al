page 60109 "Incoming Wellaway PO Lines"
{

    ApplicationArea = All;
    Caption = 'Incoming Wellaway Staging Details';
    // PageType = ListPart;
    PageType = List;
    SourceTable = "Incoming Wellaway PO Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field(POLineTimestamp; Rec.POLineTimestamp)
                {
                    ToolTip = 'Specifies the value of the Timestamp field';
                    ApplicationArea = All;
                }
                field("SO Created"; Rec."SO Created")
                {
                    ToolTip = 'Specifies the value of the SO Created field';
                    ApplicationArea = All;
                }
                field("SO Error "; Rec."SO Error")
                {
                    ToolTip = 'Specifies the value of the SO Error  field';
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field';
                    ApplicationArea = All;
                }
                field("Sales Line No. "; Rec."Sales Line No.")
                {
                    ToolTip = 'Specifies the value of the Sales Line No.  field';
                    ApplicationArea = All;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = all;
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
