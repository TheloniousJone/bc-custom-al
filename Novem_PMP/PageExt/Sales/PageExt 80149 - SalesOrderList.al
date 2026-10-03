pageextension 80149 SalesOrderListExt3PL extends "Sales Order List"
{
    layout
    {
        addafter("No.")
        {
            field(I9G_SOCreated; Rec.I9G_SOCreated)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Created field.';
                Visible = SOCreatedVisible;
            }
            field(I9G_NovemCustNoOfCopies; Rec.I9G_NovemCustNoOfCopies)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast("&Order Confirmation")
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
                    I9G_BatchCreateSOCU: Codeunit I9G_BatchCreateSO;
                begin
                    if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                            I9G_BatchCreateSOCU.Run();
                        end;
                    end;
                end;
            }
        }
        addlast(Category_Category8)
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
            SOCreatedVisible := true;
        end else begin
            SOCreatedVisible := false;
        end;
    end;

    var
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        CompanyInformationRec: Record "Company Information";
        ThirdPartyLogisticVisible: Boolean;
        BatchCreate: Boolean;
        SOCreatedVisible: Boolean;
}