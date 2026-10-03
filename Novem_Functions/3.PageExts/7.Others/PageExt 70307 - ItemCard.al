pageextension 70305 ItemCardExt extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field(I9G_ItemGroupCode; Rec.I9G_ItemGroupCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                LookupPageId = I9G_ItemGroupCodeList;
                ToolTip = 'Specifies the value of the Item Group Code field.';
            }
            field(I9G_HSARegistrationNo; Rec.I9G_HSARegistrationNo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_ProdClassificationCode; Rec.I9G_ProdClassificationCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
        addbefore(Inventory)
        {
            field(I9G_ItemLocationCode; Rec.I9G_ItemLocationCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Item Location Code field.';
            }
            field(I9G_MinimumQuantity; Rec.I9G_MinimumQuantity)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Minimum Quantity field.';
            }
        }
        addafter("Qty. on Sales Order")
        {
            field(I9G_QtyOnSalesInvoice; Rec.I9G_QtyOnSalesInvoice)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Qty. on Sales Invoice field.';
            }
        }
        addafter("Qty. on Asm. Component")
        {
            field(LotNo; LotNo)
            {
                ApplicationArea = All;
                Caption = 'Lot No.';
                Visible = CustomizedVisible;
                Editable = false;
            }
            field(ExpiryDate; ExpiryDate)
            {
                ApplicationArea = All;
                Caption = 'Expiry Date';
                Visible = CustomizedVisible;
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        RefreshLotInfo();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RefreshLotInfo();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
        ExpiryDate: Date;
        LotNo: Code[20];

    local procedure RefreshLotInfo()
    var
        ILERec: Record "Item Ledger Entry";
        CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        LotNo := '';
        ExpiryDate := 0D;
        ILERec.Reset;
        ILERec.SetLoadFields("Item No.", "Location Code", Open, "Remaining Quantity", "Variant Code", "Entry No.", "Expiration Date", "Lot No.");  //DX    03 May 2023
        ILERec.SetCurrentKey("Item No.", "Location Code", Open);      //DX        24 May 2023
        ILERec.SetRange("Item No.", Rec."No.");
        //RL    13 Jan 2022
        // ILERec.SetRange("Location Code", 'PMP-WH');
        ILERec.SetRange("Location Code", CompInfo."Location Code");
        //RL    13 Jan 2022
        ILERec.SetRange(Open, true);
        ILERec.SetFilter("Remaining Quantity", '>0');
        ILERec.SetFilter("Variant Code", '%1', ''); //RL    10 Jan 2023        
        if ILERec.FindFirst() then begin
            LotNo := ILERec."Lot No.";
            ExpiryDate := ILERec."Expiration Date";
        end;
    end;
}