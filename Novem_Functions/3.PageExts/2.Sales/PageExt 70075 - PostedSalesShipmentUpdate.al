pageextension 70075 PostedSalesShipmentUpdate extends "Posted Sales Shipment - Update"
{
    layout
    {
        addlast(General)
        {
            field(I9G_CaseDoctor; Rec.I9G_CaseDoctor)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
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
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
            field(I9G_ReferenceInvoiceNo; Rec.I9G_ReferenceInvoiceNo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
            field(I9G_InternalRemarks; Rec.I9G_InternalRemarks)
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
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = true;
            }
        }
        addlast(Shipping)
        {
            field("Shipment Date"; Rec."Shipment Date")
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