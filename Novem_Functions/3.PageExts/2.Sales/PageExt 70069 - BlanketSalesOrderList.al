pageextension 70069 SalesBlanketOrderListExt extends "Blanket Sales Orders"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(ProductDescription; ProductDescription)
            {
                ApplicationArea = All;
                Caption = 'Product Description';
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Product Description field.';
            }
        }
        addlast(Control1)
        {
            field(I9G_Admin; Rec.I9G_Admin)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }

    actions
    {

        addafter("Make &Order")
        {
            action(BlanketAgreementFulfillment)
            {
                Caption = 'Blanket Agreement Fulfillment';
                Image = Report;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                Visible = CustomizedVisible;

                trigger OnAction()
                var
                    SalesHdrRec: Record "Sales Header";
                begin
                    SalesHdrRec.Reset();
                    CurrPage.SetSelectionFilter(SalesHdrRec);
                    Report.RunModal(70054, true, false, SalesHdrRec);
                end;
            }
        }

    }

    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();

        Clear(ProductDescription);

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<> %1', '');
        if SalesLine.FindFirst() then
            ProductDescription := SalesLine.Description;
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
        ProductDescription: Text[250];
}