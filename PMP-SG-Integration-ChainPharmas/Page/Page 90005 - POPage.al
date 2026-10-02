page 90005 "Chain Pharma PO Page"
{

    Caption = 'Chain Pharma Purchase Order Staging Page';
    PageType = Document;
    SourceTable = "Chain PO Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Chain; Rec.Chain)
                {
                    ToolTip = 'Specifies the value of the Chain field';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field';
                    ApplicationArea = All;
                }
                field("Invoice Number "; Rec."Invoice Number")
                {
                    ToolTip = 'Specifies the value of the Invoice Number  field';
                    ApplicationArea = All;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field';
                    ApplicationArea = All;
                }
                field("PO Number"; Rec."PO Number")
                {
                    ToolTip = 'Specifies the value of the PO Number field';
                    ApplicationArea = All;
                }
                field("PO Date"; Rec."PO Date")
                {
                    ToolTip = 'Specifies the value of the PO Date field';
                    ApplicationArea = All;
                }
                field("DO Number "; Rec."DO Number")
                {
                    ToolTip = 'Specifies the value of the DO Number  field';
                    ApplicationArea = All;
                }
                field("DO Date"; Rec."DO Date")
                {
                    ToolTip = 'Specifies the value of the DO Date field';
                    ApplicationArea = All;
                }
                field("Delivery Start Date"; Rec."Delivery Start Date")
                {
                    ToolTip = 'Specifies the value of the Delivery Start Date field';
                    ApplicationArea = All;
                }
                field("Delivery End Date"; Rec."Delivery End Date")
                {
                    ToolTip = 'Specifies the value of the Delivery End Date field';
                    ApplicationArea = All;
                }
                field("Buyer Code"; Rec."Buyer Code")
                {
                    ToolTip = 'Specifies the value of the Buyer Code field';
                    ApplicationArea = All;
                }
                field("Buyer Name"; Rec."Buyer Name")
                {
                    ToolTip = 'Specifies the value of the Buyer Name field';
                    ApplicationArea = All;
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                    ToolTip = 'Specifies the value of the Supplier Code field';
                    ApplicationArea = All;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Name field';
                    ApplicationArea = All;
                }
                field("Line Item Count "; Rec."Line Item Count")
                {
                    ToolTip = 'Specifies the value of the Line Item Count  field';
                    ApplicationArea = All;
                }
                field("Invoice Amount Without Tax"; Rec."Invoice Amount Without Tax")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount Without Tax field';
                    ApplicationArea = All;
                }
                field("Invoice Amount With Tax "; Rec."Invoice Amount With Tax")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount With Tax  field';
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Tax Amount field';
                    ApplicationArea = All;
                }
                field("Tax Percent "; Rec."Tax Percent")
                {
                    ToolTip = 'Specifies the value of the Tax Percent  field';
                    ApplicationArea = All;
                }
                field("Store Code"; Rec."Store Code")
                {
                    ToolTip = 'Specifies the value of the Store Code field';
                    ApplicationArea = All;
                }
                field("Store Name"; Rec."Store Name")
                {
                    ToolTip = 'Specifies the value of the Store Name field';
                    ApplicationArea = All;
                }
                field("Store Delivery Quantity"; Rec."Store Delivery Quantity")
                {
                    ToolTip = 'Specifies the value of the Store Delivery Quantity field';
                    ApplicationArea = All;
                }
                field("Store FOC Quantity "; Rec."Store FOC Quantity")
                {
                    ToolTip = 'Specifies the value of the Store FOC Quantity  field';
                    ApplicationArea = All;
                }
                field(ChainPOHeaderTimestamp; Rec.ChainPOHeaderTimestamp)
                {
                    ToolTip = 'Specifies the value of the ChainPOHeaderTimestamp field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SO Created"; Rec."SO Created")
                {
                    ToolTip = 'Specifies the value of the SO Created field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SO Error"; Rec."SO Error")
                {
                    ToolTip = 'Specifies the value of the SO Error field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Process Remarks"; Rec."Process Remarks")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field';
                    ApplicationArea = All;
                }
                field("Last Error Message"; Rec."Last Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Error Message field.', Comment = '%';
                }
            }
            part(PurchLines; "Chain Pharma PO Subform")
            {
                ApplicationArea = all;
                Caption = 'Purchase Details';
                SubPageLink = "PO Entry No." = FIELD("Entry No."), "PO Number" = field("PO Number");
                UpdatePropagation = Both;
            }
        }
    }
}
