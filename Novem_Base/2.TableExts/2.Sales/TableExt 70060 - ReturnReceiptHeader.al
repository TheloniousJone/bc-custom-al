tableextension 70060 ReturnReceiptHeaderTableExt extends "Return Receipt Header"
{
    fields
    {
        field(70000; "I9G_Purchaser"; Text[150])
        {
            Caption = 'Purchaser';
            Editable = false;
        }
        field(70001; "I9G_InternalRemarks"; Text[250])
        {
            Caption = 'Internal Remarks';
            Editable = false;
        }
        field(70002; "I9G_Remarks"; Text[250])
        {
            Caption = 'Remarks';
            Editable = false;
        }
        field(70003; "I9G_CaseNumber"; Code[150])
        {
            Caption = 'Case No.';
            Editable = false;
        }
        field(70004; "I9G_SignedOrder"; Boolean)
        {
            Caption = 'Signed Order';
            Editable = false;
        }
        field(70005; "I9G_DeliveryOrder"; Boolean)
        {
            Caption = 'Delivery Order';
            Editable = false;
        }
        field(70006; "I9G_SellToAddress3"; Text[250])
        {
            Caption = 'Address 3';
            Editable = false;
        }
        field(70007; "I9G_StartDate"; Date)
        {
            Caption = 'Start Date';
            Editable = false;
        }
        field(70008; "I9G_EndDate"; Date)
        {
            Caption = 'End Date';
            Editable = false;
        }
        field(70009; "I9G_FulfilledStatus"; Enum I9G_SalesStatus)
        {
            Caption = 'Fullfilled Status';
            Editable = false;
        }
        field(70010; "I9G_RowStatus"; enum I9G_SalesStatus)
        {
            Caption = 'Row Status';
            Editable = false;
        }
        field(70011; "I9G_TerminationDate"; Enum I9G_SalesStatus)
        {
            Caption = 'Termination Date';
            Editable = false;
        }
        field(70012; "I9G_ShipToAddress3"; Text[250])
        {
            Caption = 'Address 3';
            Editable = False;
        }
        field(70013; "I9G_ShipToDistrictCode"; Code[20])
        {
            Caption = 'District Code';
            Editable = false;
        }
        field(70014; "I9G_DRIC"; Text[100])
        {
            Caption = 'DR / IC';
            Editable = false;
        }
        field(70015; "I9G_Admin"; Code[50])
        {
            Caption = 'Admin';
            Editable = False;
        }
        field(70016; "I9G_BlanketSalesOrder"; Boolean)
        {
            Caption = 'Blanket Sales Order';
            Editable = false;
        }
        field(70017; "I9G_BlanketSalesOrderNo"; code[20])
        {
            Caption = 'Blanket Sales Order No.';
            Editable = false;
        }
        field(70018; "I9G_ReferenceInvoiceNo"; Code[50])
        {
            Caption = 'Ref. Invoice No.';
            Editable = false;
        }
        field(70019; "I9G_ProductCode"; Code[50])
        {
            Caption = 'Product Code';
            Editable = false;
        }
        field(70020; "I9G_ProductDescription"; Text[250])
        {
            Caption = 'Product Description';
            Editable = false;
        }
        field(70021; "I9G_ProductDescription2"; Text[250])
        {
            Caption = 'Product Description 2';
            Editable = false;
        }
        field(70022; "I9G_BillToAddress3"; Text[250])
        {
            Caption = 'Address 3';
        }
        field(70023; "I9G_CaseDoctor"; Text[100])
        {
            Caption = 'Case Doctor';
        }
        field(70024; "I9G_DateUsed"; Date)
        {
            Caption = 'Date Used';
        }
    }
}