tableextension 56204 ICOutboxPurchLineExt extends "IC Outbox Purchase Line"
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

        field(56202; "Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purchase Price';
        }

    }

}