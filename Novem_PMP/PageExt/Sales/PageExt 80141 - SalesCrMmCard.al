pageextension 80141 SalesCrMmCardExtExt3PL extends "Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            group("Interal Third Party Logistic")
            {
                Visible = ThirdPartyLogisticVisible;
                field(I9G_NeedToCreateSO; Rec.I9G_NeedToCreateSO)
                {
                    ApplicationArea = All;
                    Visible = BatchCreate;
                    ToolTip = 'Specifies the value of the Create Purchase Order field.';
                    trigger OnValidate()
                    var
                    begin
                        if Rec.I9G_SOCreated = true then begin
                            Error('Sales Document has been already created in the warehouse company.');
                        end;
                    end;
                }
                field(I9G_SOCreated; Rec.I9G_SOCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Created field.';
                }
                field(I9G_SONo; Rec.I9G_SONo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order No. field.';
                }
                field(I9G_CustVendName; Rec.I9G_CustVendName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(I9G_SOCreatedBy; Rec.I9G_SOCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Created By field.';
                }
                field(I9G_SOCreatedDateTime; Rec.I9G_SOCreatedDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order Created Date Time field.';
                }
                field(I9G_SOLastModifiedDateTime; Rec.I9G_SOLastModifiedDateTime)
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
                field(I9G_ReturnReasonCode; Rec.I9G_ReturnReasonCode)
                {
                    ApplicationArea = all;
                }
                field(I9G_Reason_Text; Rec.I9G_Reason_Text)
                {
                    ApplicationArea = all;
                }
                field(I9Reason; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        modify(CopyDocument)
        {
            trigger OnAfterAction()
            var
            begin
                Rec.I9G_FromCompanyName := '';
                Rec.I9G_NeedToCreateSO := false;
                Rec.I9G_SOCreated := false;
                Rec.I9G_SOCreatedBy := '';
                Rec.I9G_SOCreatedDateTime := 0DT;
                Rec.I9G_SONo := '';
                Rec.I9G_ShipmentNo := '';
                Rec.I9G_InvoiceNo := '';
                Rec.I9G_SOLastModifiedDateTime := 0DT;
                Rec.I9G_CustVendName := '';
                Rec.I9G_CustVendCode := '';
                Rec.I9G_3PLRemarks := '';
                Rec.I9G_CreditMemoNo := '';
                Rec.Modify();
            end;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
            begin
                //DX        24 Oct 2025
                if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                    if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                        //DX        24 Oct 2025
                        if (Rec.I9G_ReturnReasonCode = '') or (Rec.I9G_Reason_Text = '') then
                            Error('Return Reason Code and Reason Text must have a value.');
                    end;

                end;
            end;
        }
        addlast("F&unctions")
        {
            action("SendInternalThirdPartyLogistic")
            {
                Caption = 'Send 3PL Credit Memo';
                Visible = ThirdPartyLogisticVisible;
                ApplicationArea = All;
                Image = WarehouseRegisters;
                ToolTip = 'Send and create sales credit memo in the warehouse company.';
                trigger OnAction()
                var
                    ApprovalsMgmtCU: Codeunit "Approvals Mgmt.";
                    ApprovalEntry: Record "Approval Entry";
                    CompanyInformationRec: Record "Company Information";
                begin
                    if (Rec.I9G_ReturnReasonCode = '') or (Rec.I9G_Reason_Text = '') then
                        Error('Return Reason Code and Reason Text must have a value.');
                    if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                        if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                            I9G_ThirdPartyLogisticCodeUnit.CreateSalesDocument(Rec);
                        end;
                        CurrPage.Update();
                    end;

                    /* Task List No. 2885 - Start 
                    CompanyInformationRec.Get();
                    if CompanyInformationRec.Name = 'Novem Healthcare Pte Ltd' then begin
                        ApprovalEntry.SetRange("Table ID", Database::"Sales Header");
                        ApprovalEntry.SetRange("Document Type", Rec."Document Type");
                        ApprovalEntry.SetRange("Document No.", Rec."No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                        if ApprovalEntry.FindFirst() then begin
                            if I9G_ThirdPartyLogisticSetupRec.Get() then begin
                                if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) then begin
                                    I9G_ThirdPartyLogisticCodeUnit.CreateSalesDocument(Rec);
                                end;
                                CurrPage.Update();
                            end;
                        end else begin
                            Message('The document must be approved before send for 3PL.');
                        end;
                    end;
                    Task List No. 2885 - End*/
                end;
            }
        }
        addlast(Category_Category7)
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
        if CurrentClientType <> ClientType::ODataV4 then begin
            InitNoSeries();
        end;
    end;

    procedure InitNoSeries()
    var
        Selections: Text[100];
        Selected: Integer;
        SelectionsLbl: Label 'Create customer sales order,Create warehouse sales order';
        DialogTitlelbl: Label 'Please select the type of sales order to create :';
        NoSeriesCodeUnit: Codeunit "No. Series";
        SalesReceivablesSetupRec: Record "Sales & Receivables Setup";
    begin
        if I9G_ThirdPartyLogisticSetupRec.Get() then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (I9G_ThirdPartyLogisticCodeUnit.CheckCompanyName = true) then begin
                Selections := SelectionsLbl;
                Selected := Dialog.StrMenu(Selections, 1, DialogTitlelbl);
                if Selected in [1, 2] then begin
                    if Selected = 1 then begin
                        SalesReceivablesSetupRec.Get();
                        SalesReceivablesSetupRec.TestField("Credit Memo Nos.");
                        Rec."No. Series" := SalesReceivablesSetupRec."Credit Memo Nos.";
                        Rec."No." := NoSeriesCodeUnit.GetNextNo(SalesReceivablesSetupRec."Credit Memo Nos.");
                    end;
                    if Selected = 2 then begin
                        I9G_ThirdPartyLogisticSetupRec.Get();
                        I9G_ThirdPartyLogisticSetupRec.TestField(I9G_SalesCrMmNoSeries);
                        Rec."No. Series" := I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmNoSeries;
                        Rec."No." := NoSeriesCodeUnit.GetNextNo(I9G_ThirdPartyLogisticSetupRec.I9G_SalesCrMmNoSeries);
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