page 59024 "POM5 Sales Invoice Line API"
{
    PageType = API;
    APIPublisher = 'illum9';
    APIGroup = 'pom_integration';
    APIVersion = 'v2.0';

    EntityName = 'salesInvoiceLine';
    EntitySetName = 'salesInvoiceLines';

    SourceTable = "Sales Invoice Line";
    SourceTableView = where(
        Type = filter('Item'),
        Quantity = filter(> 0)
    );

    ODataKeyFields = SystemId;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                }
                field(document; Rec."Document No.")
                {
                }
                field(item; Rec."No.")
                {
                }
                field(type; Rec.Type)
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(quantity_ordered; Rec."Order Qty")
                {
                }
                field(quantity_delivered; Rec."Qty Delivered")
                {
                }
                field(quantity_to_deliver; Rec."Qty To Deliver")
                {
                }
                field(foc_quantity; Rec."FOC Qty")
                {
                }
                field(foc_quantity_delivered; Rec."FOC Qty Delivered")
                {
                }
                field(foc_quantity_to_deliver; Rec."FOC Qty To Deliver")
                {
                }
                field(exported; Rec."I9G Line Export")
                {
                }
            }
        }
    }

}