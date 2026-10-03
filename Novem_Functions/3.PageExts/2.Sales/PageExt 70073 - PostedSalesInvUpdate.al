pageextension 70073 PostedSalesInvUpdate extends "Posted Sales Inv. - Update"
{
    layout
    {
        addlast("Invoice Details")
        {
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
                MultiLine = true;
            }
            field(I9G_InternalRemarks; Rec.I9G_InternalRemarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
                MultiLine = true;
            }
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
        }
        addlast(General)
        {
            field(I9G_DRIC; Rec.I9G_DRIC)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
            field(I9G_CaseNumber; Rec.I9G_CaseNumber)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
            field(I9G_DateUsed; Rec.I9G_DateUsed)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
            field(I9G_CaseDoctor; Rec.I9G_CaseDoctor)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
        }
    }

    actions
    {
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