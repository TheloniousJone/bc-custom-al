tableextension 55039 InvtDocLine extends "Invt. Document Line"
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
