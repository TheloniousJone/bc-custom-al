tableextension 80133 PurchReceiptHeaderTableExt3PL extends "Purch. Rcpt. Header"
{
    fields
    {
        field(80130; "I9G_POCreated"; Boolean)
        {
            Caption = 'Purchase Order Created';
            Editable = false;
        }
        field(80131; "I9G_PONo"; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
        }
        field(80132; "I9G_POCreatedDateTime"; DateTime)
        {
            Caption = 'Purchase Order Created Date Time';
            Editable = false;
        }
        field(80133; "I9G_POCreatedBy"; Code[50])
        {
            Caption = 'Purchase Order Created By';
            Editable = false;
        }
        field(80134; "I9G_NeedToCreatePO"; Boolean)
        {
            Caption = 'Create Purchase Order';
            Editable = false;
        }
        field(80135; "I9G_FromCompanyName"; Text[30])
        {
            Caption = 'From Company Name';
            TableRelation = Company.Name;
            Editable = false;
        }
        field(80136; "I9G_POLastModifiedDateTime"; DateTime)
        {
            Caption = 'Purchase Order Last Modifited Date Time';
            Editable = false;
        }
        field(80137; "I9G_ReceiptNo"; Code[20])
        {
            Caption = 'ReceiptNo';
            Editable = false;
        }
        field(80138; "I9G_3PLRemarks"; Text[500])
        {
            Caption = '3PL Remarks';
            Editable = false;
        }
        field(80139; "I9G_CustVendName"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(80140; "I9G_CustVendCode"; Code[20])
        {
            Caption = 'Customer Code';
            Editable = false;
        }
    }
}