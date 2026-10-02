tableextension 70250 SalesReceivablesSetupTableExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(70000; "I9G_PostedSalesShipmentNo2"; Code[20])
        {
            Caption = 'Delivery Order Nos.';
            TableRelation = "No. Series";
        }
        field(70001; "I9G_CustomerLicenseExpiration"; Integer)
        {
            Caption = 'Customer License Expiration (Days)';
        }
        field(70002; "I9G_DeliveryOrderFooter"; Text[2048])
        {
            Caption = 'Delivery Order Footer';
        }
        field(70003; "I9G_SignedOrderFooter"; Text[2048])
        {
            Caption = 'Signed Order Footer';
        }
        field(70005; "I9G_TaxInvoiceFooter"; Text[2048])
        {
            Caption = 'Tax Invoice Footer';
        }
        field(70006; "I9G_CreditNoteFooter"; Text[2048])
        {
            Caption = 'Credit Note Footer';
        }
        field(70007; "I9G_DefaultOrder"; Enum I9G_DefaultOrders)
        {
            Caption = 'Default Order';
        }
        field(70009; "I9G_StatementFooter"; Text[2048])
        {
            Caption = 'Statement of Account Footer';
        }
        field(70010; "I9G_TransferOrderFooter"; Text[2048])
        {
            Caption = 'Transfer Order Footer';
        }
    }
}