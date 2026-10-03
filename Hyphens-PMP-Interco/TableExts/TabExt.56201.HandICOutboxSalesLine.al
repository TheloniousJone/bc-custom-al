tableextension 56201 HandICOutboxSalesLineExt extends "Handled IC Outbox Sales Line"
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

        /*
        field(56203; "Qty To Deliver"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qty To Deliver';
        }

        field(56204; "FOC Qty To Deliver"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'FOC Qty To Deliver';
        }
        */
    }

}