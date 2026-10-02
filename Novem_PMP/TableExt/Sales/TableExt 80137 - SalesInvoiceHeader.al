tableextension 80137 SalesInvoiceHeaderTableExt3PL extends "Sales Invoice Header"
{
    fields
    {
        field(80135; "I9G_SOCreated"; Boolean)
        {
            Caption = 'Sales Order Created';
            Editable = false;
        }
        field(80136; "I9G_SONo"; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
        }
        field(80137; "I9G_SOCreatedDateTime"; DateTime)
        {
            Caption = 'Sales Order Created Date Time';
            Editable = false;
        }
        field(80138; "I9G_SOCreatedBy"; Code[50])
        {
            Caption = 'Sales Order Created By';
            Editable = false;
        }
        field(80139; "I9G_NeedToCreateSO"; Boolean)
        {
            Caption = 'Create Sales Order';
            Editable = false;
        }
        field(80140; "I9G_FromCompanyName"; Text[30])
        {
            Caption = 'From Company Name';
            TableRelation = Company.Name;
            Editable = false;
        }
        field(80141; "I9G_SOLastModifiedDateTime"; DateTime)
        {
            Caption = 'Sales Order Last Modifited Date Time';
            Editable = false;
        }
        field(80142; "I9G_3PLRemarks"; Text[500])
        {
            Caption = '3PL Remarks';
            Editable = false;
        }
        field(80143; "I9G_ShipmentNo"; Code[20])
        {
            Caption = 'Shipment No';
            Editable = false;
        }
        field(80144; "I9G_InvoiceNo"; Code[20])
        {
            Caption = 'Invoice No';
            Editable = false;
        }
        field(80145; "I9G_CreditMemoNo"; Code[20])
        {
            Caption = 'Credit Memo No';
            Editable = false;
        }
        field(80146; "I9G_CustVendName"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(80147; "I9G_NovemCustNoOfCopies"; Integer)
        {
            Caption = 'Novem Cust No Of Copies';
            Editable = false;
        }
        field(80148; "I9G_CustVendCode"; Code[20])
        {
            Caption = 'Customer Code';
            Editable = false;
        }
        field(80149; "I9G_NovemShipToAddress"; Text[250])
        {
            Caption = 'Novem Ship-to Address';
            Editable = false;
        }
        field(80150; "I9G_NovemShipToAddress2"; Text[250])
        {
            Caption = 'Novem Ship-to Address 2';
            Editable = false;
        }
        field(80151; "I9G_NovemShipToAddress3"; Text[250])
        {
            Caption = 'Novem Ship-to Address 3';
            Editable = false;
        }
        field(80152; "I9G_NovemShipToCustomerName"; Text[250])
        {
            Caption = 'Novem Ship-to Customer Name';
            Editable = false;
        }
        field(80153; "I9G_NovemShipToCustomerName2"; Text[250])
        {
            Caption = 'Novem Ship-to Customer Name 2';
            Editable = false;
        }
    }
}