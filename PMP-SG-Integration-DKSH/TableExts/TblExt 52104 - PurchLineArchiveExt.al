tableextension 52104 DKSHPurchaseLineArchiveExt extends "Purchase Line Archive"
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