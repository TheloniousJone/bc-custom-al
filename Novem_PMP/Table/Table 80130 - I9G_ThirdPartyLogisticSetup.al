table 80130 I9G_ThirdPartyLogisticSetup
{
    Caption = 'Internal Third-Party Logistic Setup';

    fields
    {
        field(1; "I9G_PrimaryKey"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "I9G_EnableThirdPartyLogistic"; Boolean)
        {
            Caption = 'Enable Internal 3PL';
        }
        field(3; "I9G_WarehouseCompany"; Text[250])
        {
            Caption = 'Warehouse Company';
            TableRelation = Company.Name;
        }
        field(4; "I9G_BatchCreate"; Boolean)
        {
            Caption = 'Batch Create';
        }
        field(5; "I9G_PurchaseOrderNoSeries"; Code[20])
        {
            Caption = 'Purchase Order No. Series';
            TableRelation = "No. Series";
        }
        field(6; "I9G_SalesOrderNoSeries"; Code[20])
        {
            Caption = 'Sales Order No. Series';
            TableRelation = "No. Series";
        }
        field(7; "I9G_SalesCrMmNoSeries"; Code[20])
        {
            Caption = 'Sales Credit No. Series';
            TableRelation = "No. Series";
        }
        field(8; "I9G_PurchaseOrderLocation"; Code[10])
        {
            Caption = 'Purchase Order Location Code';
            TableRelation = Location.Code;
        }
        field(9; "I9G_SalesOrderLocation"; Code[10])
        {
            Caption = 'Sales Order Location Code';
            TableRelation = Location.Code;
        }
        field(10; "I9G_SalesCrMmLocation"; Code[10])
        {
            Caption = 'Sales Credit Location Code';
            TableRelation = Location.Code;
        }
        field(11; "I9G_SalesPaymentTermsCode"; Code[10])
        {
            Caption = 'Sales Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(12; "I9G_PurchasePaymentTermsCode"; Code[10])
        {
            Caption = 'Purchase Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(13; "I9G_SalesGenProdPostingGrp"; Code[20])
        {
            Caption = 'Sales Gen. Prod. Posting Grp';
            TableRelation = "Gen. Product Posting Group";
        }
        field(14; "I9G_PurchaseGenProdPostingGrp"; Code[20])
        {
            Caption = 'Purchase Gen. Prod. Posting Grp';
            TableRelation = "Gen. Product Posting Group";
        }
        field(15; "I9G_CustomerCode"; Code[20])
        {
            Caption = 'Template Customer Code';
            TableRelation = Customer;
        }
        field(16; "I9G_VendorCode"; Code[20])
        {
            Caption = 'Template Vendor Code';
            TableRelation = "Vendor";
        }
        field(17; "I9G_SalesInvoiceNoSeries"; Code[20])
        {
            Caption = 'Sales Invoice No. Series';
            TableRelation = "No. Series";
        }
        field(18; "I9G_SalesInvoiceLocation"; Code[10])
        {
            Caption = 'Sales Invoice Location Code';
            TableRelation = Location.Code;
        }
        field(19; "I9G_TransferOrderNoSeries"; Code[20])
        {
            Caption = 'Transfer Order No. Series';
            TableRelation = "No. Series";
        }
        field(20; "I9G_TranferFromLocation"; Code[10])
        {
            Caption = 'Transfer Location Code';
            TableRelation = Location.Code;
        }
        field(21; "I9G_TranferToLocation"; Code[10])
        {
            Caption = 'Transfer Location Code';
            TableRelation = Location.Code;
        }
        field(22; "I9G_SalesGenBusPostingGrp"; Code[20])
        {
            Caption = 'Sales Gen. Bus. Posting Grp';
            TableRelation = "Gen. Business Posting Group";
        }
        field(23; "I9G_PurchaseGenBusPostingGrp"; Code[20])
        {
            Caption = 'Purchase Gen. Bus. Posting Grp';
            TableRelation = "Gen. Business Posting Group";
        }
        field(24; "I9G_TransferGenProdPostingGrp"; Code[20])
        {
            Caption = 'Transfer Gen. Prod. Posting Grp';
            TableRelation = "Gen. Product Posting Group";
        }
    }

    keys
    {
        key(PK; "I9G_PrimaryKey")
        {
            Clustered = true;
        }
    }
}