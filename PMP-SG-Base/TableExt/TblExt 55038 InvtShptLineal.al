tableextension 55038 "InvtShptLine.al" extends "Invt. Shipment Line"
{
    fields
    {
        field(55000; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
    }
}
