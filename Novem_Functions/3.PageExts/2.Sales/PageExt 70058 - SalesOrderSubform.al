pageextension 70058 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(I9G_OpenQuantity; Rec.I9G_OpenQuantity)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Open Quantity field.';
            }
        }
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
        modify("Order Qty")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record Item;
                InventoryNotification: Notification;
                NotificationMsg001: Text;
                NotificationGuid: Label '00000000-0000-0000-0000-000000000001';
            begin
                if I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck() then begin
                    if Rec.Type = Rec.Type::Item then begin
                        ItemRec.Reset();
                        ItemRec.SetRange("No.", Rec."No.");
                        ItemRec.SetLoadFields(Inventory, "Qty. on Sales Order", I9G_QtyOnSalesInvoice);
                        ItemRec.SetAutoCalcFields(Inventory, "Qty. on Sales Order", I9G_QtyOnSalesInvoice);
                        if ItemRec.FindFirst() then begin
                            if ItemRec.I9G_MinimumQuantity <> 0 then begin
                                if (ItemRec.Inventory - ItemRec."Qty. on Sales Order" - ItemRec.I9G_QtyOnSalesInvoice) <= ItemRec.I9G_MinimumQuantity then begin
                                    InventoryNotification.Id(NotificationGuid);
                                    If InventoryNotification.Recall() then;
                                    NotificationMsg001 := 'The available inventory for item [' + Rec."No." + '] is lower than the Minimum Quantity.';
                                    InventoryNotification.Message(NotificationMsg001);
                                    InventoryNotification.Scope := NotificationScope::LocalScope;
                                    InventoryNotification.Send();
                                end else begin
                                    InventoryNotification.Id(NotificationGuid);
                                    If InventoryNotification.Recall() then;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
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
                    CheckPriceHistory.SetRec(Rec."No.", Rec."Sell-to Customer No.", 0, Rec."Document No.");
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