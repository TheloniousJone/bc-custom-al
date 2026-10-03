pageextension 80132 PurchaseOrderListExt3PL extends "Purchase Order List"
{
    layout
    {
        addafter("No.")
        {
            field(I9G_POCreated; Rec.I9G_POCreated)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Order Created field.';
                Visible = POCreatedVisible;
            }
        }
    }
    actions
    {
        addlast(Action9)
        {
            action("SendBatchInternalThirdPartyLogistic")
            {
                Caption = 'Send Batch 3PL Order';
                Visible = ThirdPartyLogisticVisible;
                ApplicationArea = All;
                Image = WarehouseRegisters;
                ToolTip = 'Send and create purchase orders in the warehouse company.';
                trigger OnAction()
                var
                    I9G_BatchCreatePOCU: Codeunit I9G_BatchCreatePO;
                begin
                    if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                            I9G_BatchCreatePOCU.Run();
                        end;
                    end;
                end;
            }
        }
        addlast(Category_Category5)
        {
            actionref(SendBatchInternalThirdPartyLogistic_Promoted; SendBatchInternalThirdPartyLogistic) { }
        }
    }

    trigger OnOpenPage()
    var
    begin
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            ThirdPartyLogisticVisible := I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic;
            BatchCreate := I9G_ThirdPartyLogisticSetupRec.I9G_BatchCreate;
        end;
        CompanyInformationRec.Get();
        if CompanyInformationRec.Name = 'Novem Healthcare Pte Ltd' then begin
            POCreatedVisible := true;
        end else begin
            POCreatedVisible := false;
        end;
    end;

    var
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        CompanyInformationRec: Record "Company Information";
        ThirdPartyLogisticVisible: Boolean;
        BatchCreate: Boolean;
        POCreatedVisible: Boolean;
}