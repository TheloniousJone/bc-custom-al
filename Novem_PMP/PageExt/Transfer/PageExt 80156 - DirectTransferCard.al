pageextension 80156 DirectTransferOrderCardExt3PL extends "Posted Direct Transfer"
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
                    Editable = false;
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
                    Editable = false;
                }
            }
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

    var
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        ThirdPartyLogisticVisible: Boolean;
        BatchCreate: Boolean;
}