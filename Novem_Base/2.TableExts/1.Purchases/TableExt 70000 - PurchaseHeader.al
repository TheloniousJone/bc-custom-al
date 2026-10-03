tableextension 70000 PurchaseHeaderTableExt extends "Purchase Header"
{
    fields
    {
        field(70000; "I9G_Remarks"; Text[250])
        {
            Caption = 'Remarks';
        }
        field(70001; "I9G_InternalRemarks"; Text[250])
        {
            Caption = 'Internal Remarks';
        }
        field(70002; "I9G_ShipmentDate"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(70003; "I9G_ShipVia"; Text[100])
        {
            Caption = 'Ship Via';
        }
        field(70004; "I9G_SpecialInstructions"; Text[250])
        {
            Caption = 'Special Instructions';
        }
        field(70005; "I9G_CompletelyReceived"; Boolean)
        {
            Caption = 'Completely Received';
        }
        field(70006; "I9G_ReferenceInvoiceNo"; Code[50])
        {
            Caption = 'Ref. Invoice No.';
        }
        field(70007; "I9G_Admin"; Code[50])
        {
            Caption = 'Admin';
            Editable = False;
        }
        field(70008; "I9G_ShippingConfig"; Text[20])
        {
            Caption = 'Shipping Configuration';
        }
    }
    trigger OnInsert()
    var
        CompanyInformationRec: Record "Company Information";
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            I9G_Admin := UserId;
        end;
    end;
}