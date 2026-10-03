tableextension 70303 ItemTableExt extends Item
{
    fields
    {
        field(70000; "I9G_ItemGroupCode"; Code[100])
        {
            Caption = 'Item Group Code';
            TableRelation = I9G_ItemGroups.I9G_ItemGroupCode;
        }
        field(70001; "I9G_QtyOnSalesInvoice"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Invoice), Type = const(Item), "No." = field("No."), "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Shipment Date" = field("Date Filter"), "Unit of Measure Code" = field("Unit of Measure Filter")));
            Caption = 'Qty. on Sales Invoice';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70002; "I9G_MinimumQuantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 2 : 5;
        }
        field(70003; "I9G_ItemLocationCode"; Code[10])
        {
            Caption = 'Item Location Code';
            TableRelation = Location.Code;
        }
        field(70004; "I9G_HSARegistrationNo"; Text[20])
        {
            Caption = 'HSA Registration No.';
        }
        field(70005; "I9G_ProdClassificationCode"; Code[25])
        {
            Caption = 'Device/Product Classification Code';
            TableRelation = I9G_ProductClassifications.I9G_ProductClassficationCode;
        }
    }
}