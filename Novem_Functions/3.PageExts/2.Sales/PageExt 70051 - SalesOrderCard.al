pageextension 70051 SalesOrderCardExt extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Address 2")
        {
            field(I9G_SellToAddress3; Rec.I9G_SellToAddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies additional address information.';
            }
        }
        addafter("Bill-to Address 2")
        {
            field(I9G_BillToAddress3; Rec.I9G_BillToAddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                ToolTip = 'Specifies additional address information.';
            }
        }
        addafter(Status)
        {
            field(I9G_BlanketSalesOrderNo; Rec.I9G_BlanketSalesOrderNo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Blanket Sales Order No. field.';
            }
            field(I9G_DRIC; Rec.I9G_DRIC)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the DR / IC field.';
            }
            field(I9G_Purchaser; Rec.I9G_Purchaser)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Purchaser field.';
            }
            field("I9G_CaseNumber"; Rec.I9G_CaseNumber)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Case Number field.';
            }
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Internal Remarks field.';
                MultiLine = true;
            }
            field(I9G_InternalRemarks; Rec.I9G_InternalRemarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Internal Remarks field.';
                MultiLine = true;
            }
            field("I9G_Start Date"; Rec.I9G_StartDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Start Date field.';
            }
            field("I9G_End Date"; Rec.I9G_EndDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the End Date field.';
            }
            field(I9G_RowStatus; Rec.I9G_RowStatus)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Row Status field.';
            }
            field("I9G_Fulfilled Status"; Rec.I9G_FulfilledStatus)
            {
                ValuesAllowed = 1, 2;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Fulfilled Status field.';
            }
            field("I9G_Termination Date"; Rec.I9G_TerminationDate)
            {
                ValuesAllowed = 3, 4;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Termination Date field.';
            }
            field(I9G_SignedOrder; Rec.I9G_SignedOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Signed Order field.';
            }
            field(I9G_DeliveryOrder; Rec.I9G_DeliveryOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Delivery Order field.';
            }
            field(I9G_Admin; Rec.I9G_Admin)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Admin field.';
            }
            field(I9G_CaseDoctor; Rec.I9G_CaseDoctor)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_DateUsed; Rec.I9G_DateUsed)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
        addafter("Ship-to Address 2")
        {
            field(I9G_ShipToAddress3; Rec.I9G_ShipToAddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Ship-to Address 3 field.';
            }
            field(I9G_ShipToDistrictCode; Rec.I9G_ShipToDistrictCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the District Code field.';
            }
        }
        addafter(I9G_DeliveryOrder)
        {
            field("I9_Shipping No. Series"; Rec."Shipping No. Series")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action(PostedSalesTaxInvoice)
            {
                Caption = 'Tax Invoice';
                Image = SalesInvoice;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Promoted = true;
                PromotedCategory = Category11;
                trigger OnAction()
                var
                    SalesHeaderRec: Record "Sales Header";
                begin
                    SalesHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(SalesHeaderRec);
                    Report.RunModal(70052, true, false, SalesHeaderRec);
                end;
            }
        }

        modify(PreviewPosting)
        {
            trigger OnBeforeAction()
            var
            begin
                if I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck = true then begin
                    if Rec."Document Type" = Rec."Document Type"::Order then begin
                        if (Rec.I9G_SignedOrder = false) and (Rec.I9G_DeliveryOrder = false) then begin
                            Error('Please indicate posting for Signed Order or Delivery order.');
                        end;
                    end;
                end;
            end;
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