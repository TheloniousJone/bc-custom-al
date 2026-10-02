pageextension 70060 SalesCrMemoSubformExt extends "Sales Cr. Memo Subform"
{
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
                    I9G_TempTable: Record I9G_TempTable;

                begin
                    Rec.TestField(Type, Rec.Type::Item);

                    CheckPriceHistory.LookupMode := true;
                    CheckPriceHistory.SetRec(Rec."No.", Rec."Sell-to Customer No.", 0, Rec."Document No.");
                    CheckPriceHistory.Run();
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