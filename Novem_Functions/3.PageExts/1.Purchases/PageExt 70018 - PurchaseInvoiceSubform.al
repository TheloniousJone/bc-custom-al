pageextension 70018 PurchInvoiceSubformExt extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field(I9G_GSTBaseAmount; Rec.I9G_GSTBaseAmount)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_TaxAmount; I9G_TaxAmount)
            {
                Caption = 'Tax Amount';
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("Check Price History")
            {
                ApplicationArea = All;
                Caption = 'Check Price History';
                Image = Check;
                Visible = CustomizedVisible;

                trigger OnAction()
                var
                    CheckPriceHistory: Page I9G_CheckPriceHistory;

                begin
                    Rec.TestField(Type, Rec.Type::Item);

                    CheckPriceHistory.LookupMode := true;
                    CheckPriceHistory.SetRec(Rec."No.", Rec."Buy-from Vendor No.", 1, Rec."Document No.");
                    CheckPriceHistory.Run();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CompanyInformationRec: Record "Company Information";
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            // I9G_TaxAmount := Rec."Amount Including VAT" - Rec."Line Amount";
            I9G_TaxAmount := Rec."Amount Including VAT" - Rec.Amount;
        end;
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
        I9G_TaxAmount: Decimal;
}