pageextension 70065 SalesOrdesListExt extends "Sales Order List"
{
    layout
    {
        addafter("No.")
        {
            field(I9G_SignedOrder; Rec.I9G_SignedOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_DeliveryOrder; Rec.I9G_DeliveryOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_BlanketSalesOrderNo; Rec.I9G_BlanketSalesOrderNo)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Blanket Sales Order No. field.';
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
                PromotedCategory = Category8;
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