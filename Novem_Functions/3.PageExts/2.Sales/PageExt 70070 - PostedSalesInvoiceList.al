pageextension 70070 PostedSalesInvoiceListExt extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
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
        }
        addafter("Order No.")
        {
            field(I9G_BlanketSalesOrderNo; Rec.I9G_BlanketSalesOrderNo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Blanket Sales Order No. field.';
            }
        }
        addlast(Control1)
        {
            field("Ship-to Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_ShipToAddress3; Rec.I9G_ShipToAddress3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_Remarks; Rec.I9G_Remarks)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action(PostedSalesTaxInvoice)
            {
                Caption = 'Tax Invoice';
                Image = SalesInvoice;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(SalesInvoiceHeaderRec);
                    Report.RunModal(70001, true, false, SalesInvoiceHeaderRec);
                end;
            }
            action(PostedSalesDebitNote)
            {
                Caption = 'Debit Note';
                Image = SalesInvoice;
                ApplicationArea = All;
                Visible = CustomizedVisible;
                trigger OnAction()
                var
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeaderRec.Reset();
                    CurrPage.SetSelectionFilter(SalesInvoiceHeaderRec);
                    Report.RunModal(70040, true, false, SalesInvoiceHeaderRec);
                end;
            }
        }
        addlast(Category_Category7)
        {
            actionref(PostedSalesTaxInvoice_Promoted; PostedSalesTaxInvoice) { }
            actionref(PostedSalesDebitNote_Promoted; PostedSalesDebitNote) { }
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