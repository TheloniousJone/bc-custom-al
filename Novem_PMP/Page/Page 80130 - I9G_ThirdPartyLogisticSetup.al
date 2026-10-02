page 80130 I9G_ThirdPartyLogisticSetup
{
    ApplicationArea = All;
    Caption = 'Internal Third Party Logistic Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = I9G_ThirdPartyLogisticSetup;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(I9G_EnableThirdPartyLogistic; Rec.I9G_EnableThirdPartyLogistic)
                {
                    ToolTip = 'Specifies the value of the Enable Internal 3PL field.';
                }
                field(I9G_WarehouseCompany; Rec.I9G_WarehouseCompany)
                {
                    ToolTip = 'Specifies the value of the Warehouse Company field.';
                }
                field(I9G_BatchCreate; Rec.I9G_BatchCreate)
                {
                    ToolTip = 'Specifies the value of the Batch Create field.';
                }
            }
            group("No. Series")
            {
                field(I9G_PurchaseOrderNoSeries; Rec.I9G_PurchaseOrderNoSeries)
                {
                    ToolTip = 'Specifies the value of the Purchase No. Series field.';
                }
                field(I9G_SalesOrderNoSeries; Rec.I9G_SalesOrderNoSeries)
                {
                    ToolTip = 'Specifies the value of the Sales No. Series field.';
                }
                field(I9G_SalesCrMmNoSeries; Rec.I9G_SalesCrMmNoSeries)
                {
                    ToolTip = 'Specifies the value of the Sales Credit No. Series field.';
                }
                field(I9G_SalesInvoiceNoSeries; Rec.I9G_SalesInvoiceNoSeries)
                {
                    ToolTip = 'Specifies the value of the Sales Invoice No. Series field.';
                }
                field(I9G_TransferOrderNoSeries; Rec.I9G_TransferOrderNoSeries)
                {
                    ToolTip = 'Specifies the value of the Transfer Order No. Series field.';
                }
            }
            group("Warehouse Company Setup")
            {
                group("Template Code")
                {
                    field(I9G_VendorCode; Rec.I9G_VendorCode)
                    {
                        ToolTip = 'Specifies the value of the Vendor Code field.';
                    }
                    field(I9G_CustomerCode; Rec.I9G_CustomerCode)
                    {
                        ToolTip = 'Specifies the value of the Customer Code field.';
                    }
                }
                group("Location Code")
                {
                    field(I9G_PurchaseOrderLocation; Rec.I9G_PurchaseOrderLocation)
                    {
                        ToolTip = 'Specifies the value of the Purchase Order Location Code field.';
                    }
                    field(I9G_SalesOrderLocation; Rec.I9G_SalesOrderLocation)
                    {
                        ToolTip = 'Specifies the value of the Sales Order Location Code field.';
                    }
                    field(I9G_SalesCrMmLocation; Rec.I9G_SalesCrMmLocation)
                    {
                        ToolTip = 'Specifies the value of the Sales Credit Location Code field.';
                    }
                    field(I9G_SalesInvoiceLocation; Rec.I9G_SalesInvoiceLocation)
                    {
                        ToolTip = 'Specifies the value of the Sales Invoice Location Code field.';
                    }
                    field(I9G_TranferFromLocation; Rec.I9G_TranferFromLocation)
                    {
                        ToolTip = 'Specifies the value of the Transfer Location Code field.';
                    }
                    field(I9G_TranferToLocation; Rec.I9G_TranferToLocation)
                    {
                        ToolTip = 'Specifies the value of the Transfer Location Code field.';
                    }
                }
                group("Payment Terms Code")
                {
                    field(I9G_PurchasePaymentTermsCode; Rec.I9G_PurchasePaymentTermsCode)
                    {
                        ToolTip = 'Specifies the value of the Purchase Payment Terms Code field.';
                    }
                    field(I9G_SalesPaymentTermsCode; Rec.I9G_SalesPaymentTermsCode)
                    {
                        ToolTip = 'Specifies the value of the Sales Payment Terms Code field.';
                    }
                }
                group("Product Posting Group")
                {
                    field(I9G_SalesGenProdPostingGrp; Rec.I9G_SalesGenProdPostingGrp)
                    {
                        ToolTip = 'Specifies the value of the Sales Gen. Prod. Posting Grp field.';
                    }
                    field(I9G_PurchaseGenProdPostingGrp; Rec.I9G_PurchaseGenProdPostingGrp)
                    {
                        ToolTip = 'Specifies the value of the Purchase Gen. Prod. Posting Grp field.';
                    }
                    field(I9G_TransferGenProdPostingGrp; Rec.I9G_TransferGenProdPostingGrp)
                    {
                        ToolTip = 'Specifies the value of the Transfer Gen. Prod. Posting Grp field.';
                    }
                }
                group("Business Posting Group")
                {
                    field(I9G_SalesGenBusPostingGrp; Rec.I9G_SalesGenBusPostingGrp)
                    {
                        ToolTip = 'Specifies the value of the Sales Gen. Bus. Posting Grp field.';
                    }
                    field(I9G_PurchaseGenBusPostingGrp; Rec.I9G_PurchaseGenBusPostingGrp)
                    {
                        ToolTip = 'Specifies the value of the Purchase Gen. Bus. Posting Grp field.';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        NoSeriesCodeUnit: Codeunit "No. Series";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        UserRec: Record User;
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        xI9G_ThirdPartyLogisticSetupRec := Rec;
        UserRec.Reset();
        UserRec.SetRange("User Security ID", UserSecurityId());
        if UserRec.FindFirst() then begin
            if UserRec."Authentication Email".Contains('@9itgroup') or UserRec."Authentication Email".Contains('Illum (9) Pte Ltd Technician') then begin
                InternalVisible := true;
            end else begin
                InternalVisible := false;
            end;
        end;
    end;

    var
        xI9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        InternalVisible: Boolean;
}