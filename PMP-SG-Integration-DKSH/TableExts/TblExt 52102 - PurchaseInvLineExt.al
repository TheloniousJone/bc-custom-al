tableextension 52102 DKSHPurchaseInvLineExt extends "Purch. Inv. Line"
{
    fields
    {
        // Add changes to table fields here
        field(52100; "Imported Invoiced Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Imported Invoiced Purchase Price';
        }
    }

}