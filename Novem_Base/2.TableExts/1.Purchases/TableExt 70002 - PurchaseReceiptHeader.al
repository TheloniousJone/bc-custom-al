tableextension 70002 PurchaseReceiptHeaderTableExt extends "Purch. Rcpt. Header"
{
    fields
    {
        field(70000; "I9G_Remarks"; Text[250])
        {
            Caption = 'Remarks';
            Editable = false;
        }
        field(70001; "I9G_InternalRemarks"; Text[250])
        {
            Caption = 'Internal Remarks';
            Editable = false;
        }
        field(70002; "I9G_ShipmentDate"; Date)
        {
            Caption = 'Shipment Date';
            Editable = false;
        }
        field(70003; "I9G_ShipVia"; Text[100])
        {
            Caption = 'Ship Via';
            Editable = false;
        }
        field(70004; "I9G_SpecialInstructions"; Text[250])
        {
            Caption = 'Special Instructions';
            Editable = false;
        }
        field(70005; "I9G_CompletelyReceived"; Boolean)
        {
            Caption = 'Completely Received';
            Editable = false;
        }
        field(70006; "I9G_ReferenceInvoiceNo"; Code[50])
        {
            Caption = 'Ref. Invoice No.';
            Editable = false;
        }
        field(70007; "I9G_Admin"; Code[50])
        {
            Caption = 'Admin';
            Editable = False;
        }
    }
}