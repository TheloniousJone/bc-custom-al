pageextension 70074 PostedSalesCreditMemoUpdate extends "Pstd. Sales Cr. Memo - Update"
{
    layout
    {
        addlast(Shipping)
        {
            field(I9G_ShipToAddress3; Rec.I9G_ShipToAddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
            field(I9G_ShipToDistrictCode; Rec.I9G_ShipToDistrictCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
        }
        addlast(General)
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}