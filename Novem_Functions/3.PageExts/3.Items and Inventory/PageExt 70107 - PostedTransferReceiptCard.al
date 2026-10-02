pageextension 70107 PostedTransferReceiptCardExt extends "Posted Transfer Receipt"
{
    layout
    {
        addafter("Transfer-to Code")
        {
            field(I9G_Consignment; Rec.I9G_Consignment)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Consignment field.';
            }
            field(I9G_DateUsed; Rec.I9G_DateUsed)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Date Used field.';
            }
            field("I9G_DeliveryDate"; Rec.I9G_DeliveryDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Delivery Date field.';
            }
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                MultiLine = true;
                ToolTip = 'Specifies the value of the Remarks field.';
            }
            field(I9G_CaseNumber; Rec.I9G_CaseNumber)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Case Number field.';
            }
            field(I9G_CaseDR; Rec.I9G_CaseDR)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Case DR field.';
            }
            field(I9G_Admin; Rec.I9G_Admin)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Admin field.';
            }
            field(I9G_CustomerNo; Rec.I9G_CustomerNo)
            {
                ApplicationArea = all;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer No. field.';
                Enabled = rec.I9G_Consignment;
            }
            field(I9G_ShiptoCode; Rec.I9G_ShiptoCode)
            {
                ApplicationArea = all;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Ship-to Code field.';
                Enabled = Rec.I9G_Consignment;
            }
            field(I9G_CustomerName; Rec.I9G_CustomerName)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer Name field.';
            }
            field(I9G_CustomerName2; Rec.I9G_CustomerName2)
            {
                ApplicationArea = all;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer Name 2 field.';
            }
            field(I9G_CustomerAddress; Rec.I9G_CustomerAddress)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer Address field.';
            }
            field(I9G_CustomerAddress2; Rec.I9G_CustomerAddress2)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer Address 2 field.';
            }
            field(I9G_CustomerAddress3; Rec.I9G_CustomerAddress3)
            {
                ApplicationArea = all;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer Address 3 field.';
            }
        }
        addlast(General)
        {
            field(I9G_InternalRemarks; Rec.I9G_InternalRemarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                MultiLine = true;
                ToolTip = 'Specifies the value of the Internal Remarks.';
            }
            field(ShortcutDimCode7; ShortcutDimCode[7])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,7';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7), "Dimension Value Type" = const(Standard), Blocked = const(false));
                Visible = CustomizedVisible;
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();

        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    local procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCode);
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        DimMgt: Codeunit DimensionManagement;
        CustomizedVisible: Boolean;
        ShortcutDimCode: array[8] of Code[20];
}