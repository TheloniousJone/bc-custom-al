pageextension 80155 TransferOrderCardExt3PL extends "Transfer Order"
{
    layout
    {
        addlast(General)
        {
            group("Interal Third Party Logistic")
            {
                Visible = false;
                field(I9G_NeedToCreateTO; Rec.I9G_NeedToCreateTO)
                {
                    ApplicationArea = All;
                    Visible = BatchCreate;
                    ToolTip = 'Specifies the value of the Create Purchase Order field.';
                    trigger OnValidate()
                    var
                    begin
                        if Rec.I9G_TOCreated = true then begin
                            Error('Sales Document has been already created in the warehouse company.');
                        end;
                    end;
                }
                field(I9G_TOCreated; Rec.I9G_TOCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Created field.';
                }
                field(I9G_TONo; Rec.I9G_TONo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order No. field.';
                }
                field(I9G_TransferFromName; Rec.I9G_TransferFromName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-From Name field.';
                }
                field(I9G_TransferToName; Rec.I9G_TransferToName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-To Name field.';
                }

                field(I9G_TOCreatedBy; Rec.I9G_TOCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Created By field.';
                }
                field(I9G_TOCreatedDateTime; Rec.I9G_TOCreatedDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Created Date Time field.';
                }
                field(I9G_TOLastModifiedDateTime; Rec.I9G_TOLastModifiedDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Last Modifited Date Time field.';
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
        addafter("Create &Whse. Receipt")
        {
            action("SendInternalThirdPartyLogistic")
            {
                Caption = 'Send 3PL Order';
                Visible = false;
                ApplicationArea = All;
                Image = WarehouseRegisters;
                ToolTip = 'Send and create transfer order in the warehouse company.';
                trigger OnAction()
                var
                begin
                    if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                            I9G_ThirdPartyLogisticCodeUnit.CreateTransferDocument(Rec);
                        end;
                        CurrPage.Update();
                    end;
                end;
            }
        }
        addlast(Category_Category8)
        {
            actionref(SendInternalThirdPartyLogistic_Promoted; SendInternalThirdPartyLogistic) { }
        }
    }

    trigger OnOpenPage()
    var
    begin
        /*Pending 
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            ThirdPartyLogisticVisible := I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic;
            BatchCreate := I9G_ThirdPartyLogisticSetupRec.I9G_BatchCreate;
        end;
        */
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        /*Pending 
        InitNoSeries();
        */
    end;

    procedure InitNoSeries()
    var
        Selections: Text[100];
        Selected: Integer;
        SelectionsLbl: Label 'Create customer sales order,Create warehouse sales order';
        DialogTitlelbl: Label 'Please select the type of sales order to create :';
        NoSeriesCodeUnit: Codeunit "No. Series";
        InventorySetupRec: Record "Inventory Setup";
    begin
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (I9G_ThirdPartyLogisticCodeUnit.CheckCompanyName = true) then begin
                Selections := SelectionsLbl;
                Selected := Dialog.StrMenu(Selections, 1, DialogTitlelbl);
                if Selected in [1, 2] then begin
                    if Selected = 1 then begin
                        InventorySetupRec.Get();
                        InventorySetupRec.TestField("Transfer Order Nos.");
                        Rec."No. Series" := InventorySetupRec."Transfer Order Nos.";
                        Rec."No." := NoSeriesCodeUnit.GetNextNo(InventorySetupRec."Transfer Order Nos.");
                    end;
                    if Selected = 2 then begin
                        I9G_ThirdPartyLogisticSetupRec.Get();
                        I9G_ThirdPartyLogisticSetupRec.TestField(I9G_TransferOrderNoSeries);
                        Rec."No. Series" := I9G_ThirdPartyLogisticSetupRec.I9G_TransferOrderNoSeries;
                        Rec."No." := NoSeriesCodeUnit.GetNextNo(I9G_ThirdPartyLogisticSetupRec.I9G_TransferOrderNoSeries);
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