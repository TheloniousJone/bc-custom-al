pageextension 80130 PurchaseOrderCardExt3PL extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            group("Interal Third Party Logistic")
            {
                Visible = ThirdPartyLogisticVisible;
                field(I9G_NeedToCreatePO; Rec.I9G_NeedToCreatePO)
                {
                    ApplicationArea = All;
                    Visible = BatchCreate;
                    ToolTip = 'Specifies the value of the Create Purchase Order field.';
                    trigger OnValidate()
                    var
                    begin
                        if Rec.I9G_POCreated = true then begin
                            Error('Purchase Document has been already created in the warehouse company.');
                        end;
                    end;
                }
                field(I9G_POCreated; Rec.I9G_POCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order Created field.';
                }
                field(I9G_PONo; Rec.I9G_PONo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order No. field.';
                }
                field(I9G_CustVendName; Rec.I9G_CustVendName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(I9G_POCreatedBy; Rec.I9G_POCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order Created By field.';
                }
                field(I9G_POCreatedDateTime; Rec.I9G_POCreatedDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order Created Date Time field.';
                }
                field(I9G_POLastModifiedDateTime; Rec.I9G_POLastModifiedDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Order Last Modifited Date Time field.';
                }
                field(I9G_3PLRemarks; Rec.I9G_3PLRemarks)
                {
                    ApplicationArea = All;
                    Editable = Rec.Status = Rec.Status::Open;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        modify("Create &Whse. Receipt")
        {
            trigger OnBeforeAction()
            var
            begin
                if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                    if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                        if Rec."Posting No." <> '' then
                            I9G_ThirdPartyLogisticCodeUnit.CheckPurchaseLineBeforeCreateWarehouseReceipt(Rec);
                    end;
                end;
            end;
        }
        modify(CopyDocument)
        {
            trigger OnAfterAction()
            var
            begin
                Rec.I9G_FromCompanyName := '';
                Rec.I9G_NeedToCreatePO := false;
                Rec.I9G_POCreated := false;
                Rec.I9G_POCreatedBy := '';
                Rec.I9G_POCreatedDateTime := 0DT;
                Rec.I9G_PONo := '';
                Rec.I9G_POLastModifiedDateTime := 0DT;
                Rec.I9G_CustVendName := '';
                Rec.I9G_CustVendCode := '';
                Rec.I9G_3PLRemarks := '';
                Rec.I9G_ReceiptNo := '';
                Rec.Modify();
            end;
        }
        addlast(Print)
        {
            action("SendInternalThirdPartyLogistic")
            {
                Caption = 'Send 3PL Order';
                Visible = ThirdPartyLogisticVisible;
                ApplicationArea = All;
                Image = WarehouseRegisters;
                ToolTip = 'Send and create purchase order in the warehouse company.';
                trigger OnAction()
                var
                begin
                    if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                            I9G_ThirdPartyLogisticCodeUnit.CreatePurchaseDocument(Rec);
                        end;
                        CurrPage.Update();
                    end;
                end;
            }
        }
        addlast(Category_Category10)
        {
            actionref(SendInternalThirdPartyLogistic_Promoted; SendInternalThirdPartyLogistic) { }
        }
    }

    trigger OnOpenPage()
    var
    begin
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            ThirdPartyLogisticVisible := I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic;
            BatchCreate := I9G_ThirdPartyLogisticSetupRec.I9G_BatchCreate;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        InitNoSeries();
    end;

    procedure InitNoSeries()
    var
        Selections: Text[100];
        Selected: Integer;
        SelectionsLbl: Label 'Create vendor purchase order,Create warehouse purchase order';
        DialogTitlelbl: Label 'Please select the type of purchase order to create :';
        NoSeriesCodeUnit: Codeunit "No. Series";
        PurchasePayableSetupRec: Record "Purchases & Payables Setup";
    begin
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (I9G_ThirdPartyLogisticCodeUnit.CheckCompanyName = true) then begin
                Selections := SelectionsLbl;
                Selected := Dialog.StrMenu(Selections, 1, DialogTitlelbl);
                if Selected in [1, 2] then begin
                    if Selected = 1 then begin
                        PurchasePayableSetupRec.Get();
                        PurchasePayableSetupRec.TestField("Order Nos.");
                        Rec."No. Series" := PurchasePayableSetupRec."Order Nos.";
                        Rec."No." := NoSeriesCodeUnit.GetNextNo(PurchasePayableSetupRec."Order Nos.");
                    end;
                    if Selected = 2 then begin
                        I9G_ThirdPartyLogisticSetupRec.Get();
                        I9G_ThirdPartyLogisticSetupRec.TestField(I9G_PurchaseOrderNoSeries);
                        Rec."No. Series" := I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderNoSeries;
                        Rec."No." := NoSeriesCodeUnit.GetNextNo(I9G_ThirdPartyLogisticSetupRec.I9G_PurchaseOrderNoSeries);
                    end;
                end;
            end;
        end;
    end;

    var
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        ThirdPartyLogisticVisible: Boolean;
        BatchCreate: Boolean;
}