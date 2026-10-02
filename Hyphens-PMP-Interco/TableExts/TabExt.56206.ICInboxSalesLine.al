tableextension 56206 ICInboxSalesLineExt extends "IC Inbox Sales Line"
{
    fields
    {
        Field(56200; "Order Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Qty';
        }

        field(56201; "FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'FOC Qty';
        }

        field(56202; "Selling Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Selling Price';
        }

    }

}