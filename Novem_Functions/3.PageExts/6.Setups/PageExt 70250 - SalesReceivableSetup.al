pageextension 70250 SalesReceivableSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field(I9G_CustomerLicenseExpiration; Rec.I9G_CustomerLicenseExpiration)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Customer License Expiration in Days field.';
            }
            field(I9G_DefaultOrder; Rec.I9G_DefaultOrder)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Default Order field.';
            }
        }
        addafter("Posted Shipment Nos.")
        {
            field(I9G_PostedSalesShipmentNo2; Rec.I9G_PostedSalesShipmentNo2)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Posted Sales Shipment No. 2 field.';
            }
        }
        addafter(Archiving)
        {
            group(Reporting)
            {
                Caption = 'Reporting';
                field(I9G_DeliveryOrderFooter; Rec.I9G_DeliveryOrderFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Delivery Order Footer field.';
                }
                field(I9G_SignedOrderFooter; Rec.I9G_SignedOrderFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Signed Order Footer field.';
                }
                field(I9G_TaxInvoiceFooter; Rec.I9G_TaxInvoiceFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Tax Invoice Footer field.';
                }
                field(I9G_CreditNoteFooter; Rec.I9G_CreditNoteFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Credit Note Footer field.';
                }
                field(I9G_StatementFooter; Rec.I9G_StatementFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Statement of Account Footer field.';
                }
                field(I9G_TransferOrderFooter; Rec.I9G_TransferOrderFooter)
                {
                    ApplicationArea = All;
                    Visible = CustomizedVisible;
                    Width = 1500;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Transfer Order Footer field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}