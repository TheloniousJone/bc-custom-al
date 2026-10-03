tableextension 70101 DirectTransferHeaderTableExt extends "Direct Trans. Header"
{
    fields
    {
        field(70000; "I9G_Consignment"; Boolean)
        {
            Caption = 'Consignment';
            Editable = false;
        }
        field(70001; "I9G_CaseNumber"; Code[150])
        {
            Caption = 'Case No.';
            Editable = false;
        }
        field(70002; "I9G_Remarks"; text[250])
        {
            Caption = 'Remarks';
            Editable = false;
        }
        field(70003; "I9G_CaseDR"; Text[100])
        {
            Caption = 'Case DR';
            Editable = false;
        }
        field(70004; "I9G_DateUsed"; Date)
        {
            Caption = 'Date Used';
            Editable = false;
        }
        field(70005; "I9G_Admin"; Code[50])
        {
            Caption = 'Admin';
            Editable = false;
        }
        field(70006; "I9G_CustomerNo"; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
        }
        field(70007; "I9G_ShiptoCode"; Code[20])
        {
            Caption = 'Ship-To Code';
            Editable = false;
        }
        field(70008; "I9G_CustomerName"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(70009; "I9G_CustomerName2"; Text[50])
        {
            Caption = 'Customer Name 2';
            Editable = false;
        }
        FIeld(70010; "I9G_CustomerAddress"; Text[100])
        {
            Caption = 'Customer Address';
            Editable = false;
        }
        field(70011; "I9G_CustomerAddress2"; Text[50])
        {
            Caption = 'Customer Address 2';
            Editable = false;
        }
        field(70012; "I9G_CustomerAddress3"; Text[250])
        {
            Caption = 'Customer Address 3';
            Editable = false;
        }
        field(70013; "I9G_DeliveryDate"; Date)
        {
            Caption = 'Delivery Date';
            Editable = false;
        }
        field(70014; "I9G_InternalRemarks"; Text[250])
        {
            Caption = 'Internal Remarks';
            Editable = false;
        }
    }
}